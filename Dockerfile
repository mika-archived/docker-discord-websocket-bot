# Builder
FROM node:12.4-alpine AS builder
WORKDIR /usr/src/app
LABEL stage=intermediate

# for node-gyp building
RUN apk add --no-cache python make g++

COPY . ./

RUN yarn install --frozen-lockfile && \
  yarn run build && \
  rm -r node_modules && \
  yarn install --frozen-lockfile --production

# App
FROM node:12.4-alpine
ARG DISCORD_TOKEN
ENV NODE_ENV=production
ENV DISCORD_TOKEN=${DISCORD_TOKEN}
WORKDIR /usr/src/app

RUN apk add --no-cache tini

COPY --from=builder /usr/src/app/lib ./lib
COPY --from=builder /usr/src/app/node_modules ./node_modules

USER node
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "node", "lib/index.js" ]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "lib/healthcheck.js" ]
