-- Yetumia — Table pivot uniquement (lexique_swahili)
-- Pour le schéma complet (tous les lexiques + FKs), utiliser yetumia_schema.sql

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

CREATE TABLE IF NOT EXISTS public.lexique_swahili (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  mot_swahili character varying(255) NOT NULL,
  argot character varying(255),
  traduction_fr text NOT NULL,
  categorie_grammaticale character varying(50) NOT NULL,
  exemples_swahili text,
  exemples_traduction_fr text,
  synonymes_swahili text,
  antonymes_swahili text,
  etymologie text,
  prononciation_api character varying(255),
  notes_culturelles text,
  niveau_langue character varying(50),
  date_ajout timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  historique_modifications jsonb DEFAULT '{}'::jsonb,
  categorie_semantique character varying(50),
  niveau_difficulte character varying(20),
  CONSTRAINT lexique_swahili_pkey PRIMARY KEY (id),
  CONSTRAINT unique_mot_swahili UNIQUE (mot_swahili, argot)
);

CREATE INDEX IF NOT EXISTS idx_lexique_swahili_mot ON public.lexique_swahili (mot_swahili);
