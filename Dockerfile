# Build stage
FROM node:18-alpine as builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY gulpfile.js ./
COPY tsconfig.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY src ./src

# Build the project
RUN npx gulp

# Runtime stage
FROM node:18-alpine

WORKDIR /app

# Install http-server globally for serving static files
RUN npm install -g http-server

# Copy built files from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src/index.html ./dist/

# Copy demo assets if they exist
COPY --from=builder /app/dist/demo_assets ./dist/demo_assets 2>/dev/null || true

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start the server
CMD ["http-server", "dist", "-p", "8080", "-c-1", "--cors"]
