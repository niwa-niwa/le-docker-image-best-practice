FROM node:18-alpine

RUN cat /etc/passwd

WORKDIR /app

COPY --chown=NODE:NODE ./ ./

RUN npm run install:all && npm run build:all

# RUN cd ./backend && npm run build
# RUN cd ../frontend && npm run build

# USER NODE

EXPOSE 80

CMD ["node", "backend/dist/main.js"]
