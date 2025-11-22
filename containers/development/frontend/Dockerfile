FROM node:22.21.1

WORKDIR /srv/frontend

COPY ./frontend /srv/frontend

RUN npm install

EXPOSE 4200

CMD ["npm", "start"]
