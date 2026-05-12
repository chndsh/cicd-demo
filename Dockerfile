# ── Stage 1: dependency install ──────────────────────────────
FROM node:20-alpine AS deps

WORKDIR /app

# Copy only package files first (layer cache optimization)
COPY package.json ./

# Install production dependencies only
RUN npm install --omit=dev

# ── Stage 2: runtime ─────────────────────────────────────────
FROM node:20-alpine AS runtime

# Create a non-root user — never run containers as root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy dependencies from stage 1
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY src/ ./src/
COPY package.json ./

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Health check built into the image
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Start the app
CMD ["node", "src/index.js"]
