# syntax=docker/dockerfile:1

ARG NODE_VERSION=26.11.1
FROM node:${NODE_VERSION}-bookworm-slim AS base

WORKDIR /app

# Prisma's CLI uses OpenSSL; CA roots also enable outbound HTTPS from the API.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates openssl \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global npm@11.20.0

FROM base AS build

COPY package.json package-lock.json ./
COPY prisma ./prisma
COPY prisma.config.ts ./

# Generation only needs a syntactically valid URL, never a reachable database.
RUN DATABASE_URL=postgresql://build:build@localhost:5432/build npm ci

COPY . .
RUN DATABASE_URL=postgresql://build:build@localhost:5432/build npm run prisma:generate \
    && npm run build

# Run schema changes explicitly as a release step, independently of API startup.
FROM build AS migrate
ENV NODE_ENV=production
USER node
CMD ["npm", "run", "db:migrate:deploy"]

FROM build AS production-dependencies
# Prisma CLI is an optional peer of @prisma/client; keep it in migrate only.
RUN npm prune --omit=dev --omit=optional --ignore-scripts \
    && npm cache clean --force

# The worker keeps optional dependencies: sharp ships its native binaries that way.
FROM build AS worker-dependencies
RUN npm prune --omit=dev --ignore-scripts \
    && npm cache clean --force

FROM base AS worker

# ffmpeg/ffprobe for video and audio renditions (spec §10.4).
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production

COPY --from=worker-dependencies --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/package.json ./package.json

USER node

# Refreshed only after a database query and a Valkey ping succeed.
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD node -e "const f=require('path').join(require('os').tmpdir(),'baby-worker-heartbeat');try{process.exit(Date.now()-require('fs').statSync(f).mtimeMs<60000?0:1)}catch{process.exit(1)}"

CMD ["node", "dist/workers/worker.js"]

FROM base AS runtime

ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=3000

COPY --from=production-dependencies --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/package.json ./package.json

USER node
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || '3000') + '/health/live').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

CMD ["node", "dist/main.js"]
