FROM node:latest

WORKDIR /app/

COPY *.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]