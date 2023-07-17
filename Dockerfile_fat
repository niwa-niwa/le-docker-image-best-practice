FROM node:18-alpine

WORKDIR /app

COPY --chown=node:node ./ ./

RUN npm run install:all && npm run build:all

# RUN cd ./backend && npm run build
# RUN cd ../frontend && npm run build

EXPOSE 80

USER node

WORKDIR /app/backend

CMD ["node", "dist/main.js"]
