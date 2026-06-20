FROM node:18 as buildando
WORKDIR /app
COPY src/package.json ./
RUN npm install
COPY src/ .

FROM node:18-alpine
WORKDIR /app
COPY --from=buildando /app .
EXPOSE 3000
CMD ["npm", "start"]