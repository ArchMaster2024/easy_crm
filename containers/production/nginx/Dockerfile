FROM alpine:3.22.2 AS builder

RUN apk add --no-cache \
    curl \
    nodejs \
    npm \
    && apk cache clean && apk del --purge $(apk info -a | awk '{print $1}' | sort | uniq -u) && rm -rf /var/cache/apk/* && rm -rf /tmp/*

WORKDIR /srv/backend

COPY ./backend /srv/backend

RUN npm install && npm run build

FROM nginx:1.29.3-alpine3.22

COPY ./containers/production/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /srv/backend/public /srv/backend/public

WORKDIR /srv/backend/public

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
