# Utilise Node.js 20
FROM node:20

# Crée un dossier de travail
WORKDIR /app

# Copie les fichiers de dépendances
COPY package*.json ./

# Installe les dépendances
RUN npm install

# Copie tout le code
COPY . .

# Expose le port utilisé par le backend
EXPOSE 4000

# Commande pour démarrer le backend
CMD ["node", "server.js"]
