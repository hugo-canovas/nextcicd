FROM node:26-alpine3.24 AS deps

WORKDIR /front

COPY front/package*.json ./

RUN npm ci

FROM node:26-alpine3.24 AS builder

COPY --from=deps /front/node_modules ./node_modules

COPY front/ .

ENV NODE_ENV=production

RUN npm run build

FROM node:26-alpine3.24 AS runner

WORKDIR /front

ENV NODE_ENV=production

ENV PORT=3000

COPY front/package*.json ./

RUN npm ci --omit=dev

COPY --from=builder front/.next ./.next

COPY --from=builder front/public ./public

EXPOSE 3000

CMD ["npm", "start"]

