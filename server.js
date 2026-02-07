require('dotenv').config()
const express = require('express')
const { Pool } = require('pg')
const cors = require('cors')

const app = express()
app.use(cors())
app.use(express.json())

// Connexion PostgreSQL
const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
})

// ⚡ Assurer que l’extension pgcrypto est activée pour gen_random_uuid
pool.query(`CREATE EXTENSION IF NOT EXISTS "pgcrypto"`).catch(err => {
  console.error('Erreur pgcrypto:', err.message)
})

// Route test
app.get('/', (req, res) => {
  res.json({ success: true, message: 'Yetumia Backend Running' })
})

// Health check: API + database connectivity (for VPS / Hostinger)
app.get('/health', async (req, res) => {
  let dbOk = false
  let dbError = null
  try {
    await pool.query('SELECT 1')
    dbOk = true
  } catch (err) {
    dbError = err.message
  }
  res.status(dbOk ? 200 : 503).json({
    success: dbOk,
    api: true,
    database: dbOk,
    message: dbOk ? 'API and database OK' : 'Database connection failed',
    ...(dbError && { databaseError: dbError })
  })
})

// 🔍 Rechercher un mot
app.get('/mot/:mot', async (req, res) => {
  const mot = (req.params.mot || '').trim()
  if (!mot) {
    return res.status(400).json({ success: false, error: 'Paramètre mot requis' })
  }
  try {
    const result = await pool.query(
      `SELECT * FROM lexique_swahili WHERE mot_swahili ILIKE $1`,
      [`%${mot}%`]
    )
    res.json({ success: true, data: result.rows })
  } catch (err) {
    console.error(err)
    res.status(500).json({ success: false, error: err.message })
  }
})

// ➕ Ajouter un mot (pivot: UUID auto; retourne id pour lier les autres lexiques)
app.post('/ajouter', async (req, res) => {
  const {
    mot_swahili,
    traduction_fr,
    categorie_grammaticale,
    argot,
    exemples_swahili,
    exemples_traduction_fr,
    synonymes_swahili,
    antonymes_swahili,
    etymologie,
    prononciation_api,
    notes_culturelles,
    niveau_langue,
    categorie_semantique,
    niveau_difficulte
  } = req.body

  if (!mot_swahili || String(mot_swahili).trim() === '') {
    return res.status(400).json({ success: false, error: 'mot_swahili requis' })
  }
  if (!traduction_fr || String(traduction_fr).trim() === '') {
    return res.status(400).json({ success: false, error: 'traduction_fr requise' })
  }

  const catGram = categorie_grammaticale != null ? String(categorie_grammaticale).trim() : ''
  const argotVal = argot != null ? String(argot).trim() : null

  try {
    const result = await pool.query(
      `INSERT INTO lexique_swahili
      (id, mot_swahili, traduction_fr, categorie_grammaticale, argot,
       exemples_swahili, exemples_traduction_fr, synonymes_swahili,
       antonymes_swahili, etymologie, prononciation_api, notes_culturelles,
       niveau_langue, date_ajout, historique_modifications, categorie_semantique, niveau_difficulte)
      VALUES (
        gen_random_uuid(), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, now(), '{}', $13, $14
      )
      RETURNING id`,
      [
        String(mot_swahili).trim(), String(traduction_fr).trim(), catGram || 'nom', argotVal,
        exemples_swahili, exemples_traduction_fr, synonymes_swahili,
        antonymes_swahili, etymologie, prononciation_api, notes_culturelles,
        niveau_langue, categorie_semantique, niveau_difficulte
      ]
    )
    const row = result.rows[0]
    res.status(201).json({ success: true, message: 'Mot ajouté', id: row ? row.id : null })
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({ success: false, error: 'Ce mot (mot_swahili + argot) existe déjà' })
    }
    console.error(err)
    res.status(500).json({ success: false, error: err.message })
  }
})

// ✏️ Modifier un mot par mot_swahili (toutes les lignes avec ce mot)
app.put('/modifier/:mot', async (req, res) => {
  const mot = req.params.mot
  const { traduction_fr } = req.body
  try {
    const result = await pool.query(
      `UPDATE lexique_swahili SET traduction_fr=$1 WHERE mot_swahili=$2`,
      [String(traduction_fr).trim(), mot]
    )
    res.json({ success: true, message: 'Mot modifié', updated: result.rowCount })
  } catch (err) {
    console.error(err)
    res.status(500).json({ success: false, error: err.message })
  }
})

// ✏️ Modifier un mot par id (une seule entrée; schema UNIQUE(mot_swahili, argot))
app.put('/modifier/id/:id', async (req, res) => {
  const id = req.params.id
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  if (!id || !uuidRegex.test(id)) {
    return res.status(400).json({ success: false, error: 'UUID invalide' })
  }
  const { traduction_fr } = req.body
  if (traduction_fr === undefined || traduction_fr === null || String(traduction_fr).trim() === '') {
    return res.status(400).json({ success: false, error: 'traduction_fr requise' })
  }
  try {
    const result = await pool.query(
      `UPDATE lexique_swahili SET traduction_fr=$1 WHERE id=$2`,
      [String(traduction_fr).trim(), id]
    )
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, error: 'Entrée non trouvée' })
    }
    res.json({ success: true, message: 'Mot modifié' })
  } catch (err) {
    console.error(err)
    res.status(500).json({ success: false, error: err.message })
  }
})

// ❌ Supprimer un mot par UUID (échec si d'autres lexiques référencent cet id via FK)
app.delete('/supprimer/:id', async (req, res) => {
  const id = req.params.id
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  if (!id || !uuidRegex.test(id)) {
    return res.status(400).json({ success: false, error: 'UUID invalide' })
  }
  try {
    const result = await pool.query(`DELETE FROM lexique_swahili WHERE id=$1`, [id])
    if (result.rowCount === 0) {
      return res.status(404).json({ success: false, error: 'Entrée non trouvée' })
    }
    res.json({ success: true, message: 'Mot supprimé' })
  } catch (err) {
    if (err.code === '23503') {
      return res.status(409).json({ success: false, error: 'Impossible de supprimer: d\'autres lexiques référencent cet id' })
    }
    console.error(err)
    res.status(500).json({ success: false, error: err.message })
  }
})

// Démarrer serveur
const PORT = process.env.PORT || 4000
app.listen(PORT, '0.0.0.0', () => console.log(`🚀 Yetumia API running on port ${PORT}`))


const cors = require('cors');

// Configuration CORS
const corsOptions = {
  origin: ['https://www.yetumia.com', 'https://yetumia.com'],
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));

