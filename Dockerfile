# Use a última versão estável do Node.js
FROM node:22

# Instale dependências necessárias para o Puppeteer
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm-dev \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure o diretório de trabalho
WORKDIR /app

# Copie o package.json e package-lock.json
COPY package*.json ./

RUN npm install -g npm@11.0.0

# Instale dependências do projeto
RUN npm install

# Copie o código-fonte para dentro do container
COPY . .

# Compile o TypeScript para JavaScript
RUN npm run build

# Exponha a porta da aplicação
EXPOSE 3000

# Inicie a aplicação
CMD ["npm", "start"]
