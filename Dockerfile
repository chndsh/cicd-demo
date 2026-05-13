# ── Stage 1: dependency install ──────────────────────────────
# Using alpine 3.20+ which contains many of the library fixes
FROM node:20-alpine3.20 AS deps

WORKDIR /app

# Copy only package files first
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# ── Stage 2: runtime ─────────────────────────────────────────
FROM node:20-alpine3.20 AS runtime

# Security best practice: update the OS packages to catch latest patches
RUN apk update && apk upgrade --no-cache

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy dependencies from stage 1
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY src/ ./src/
COPY package.json ./

# Switch to non-root user
USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]