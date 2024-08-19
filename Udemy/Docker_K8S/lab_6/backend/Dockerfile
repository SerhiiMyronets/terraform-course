FROM node:latest

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 80

ENV MONGO_USER=clyde
ENV MONGO_PASS=admin

CMD ["npm", "start"]