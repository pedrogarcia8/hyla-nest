ARG NODE_VERSION=node:14.17.6
ARG ALPINE_VERSION=alpine3.11

# Base image
FROM ${NODE_VERSION} as base

WORKDIR /home/node/app

RUN chown node:node .

# Builder image, used only for build 
FROM base as builder

COPY . .

RUN npm install && \
    npm run build

# Production image, with dist artifacts and production mode enabled
FROM base as production

USER node

ENV NODE_ENV production

COPY --chown=node:node package*.json ./
COPY --chown=node:node --from=builder /home/node/app/dist ./dist

RUN npm install --only=production

EXPOSE 3000

CMD npm run start