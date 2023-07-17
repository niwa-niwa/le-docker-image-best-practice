FROM node:18-alpine as deps_modules

WORKDIR /app

COPY ./backend/package*.json ./backend/

COPY ./frontend/package*.json ./frontend/

RUN cd ./backend && npm ci --only=production

RUN cd ./frontend && npm ci --only=production



FROM node:18-alpine as builder

WORKDIR /app

COPY ./ ./

RUN npm run install:all && npm run build:all



FROM node:18-alpine

ENV NODE_ENV production

RUN apk --update add --no-cache tzdata tini && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder --chown=node:node /app/backend/dist /app/backend/dist

COPY --from=deps_modules --chown=node:node /app/backend/node_modules /app/backend/node_modules

COPY --from=builder --chown=node:node /app/frontend/dist /app/frontend/dist

COPY --from=builder --chown=node:node /app/frontend/public /app/frontend/public

COPY --from=deps_modules --chown=node:node /app/frontend/node_modules /app/frontend/node_modules

COPY --from=builder --chown=node:node /app/assets /app/assets

USER node

WORKDIR /app/backend

EXPOSE 3000

ENTRYPOINT ["/sbin/tini", "-e", "143", "--"]

CMD ["node", "dist/main.js"]
