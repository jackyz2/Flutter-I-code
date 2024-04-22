FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ENV PORT=2000

EXPOSE 2000

CMD ["npm", "start"]