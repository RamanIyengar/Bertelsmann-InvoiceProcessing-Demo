# ── Stage 1: build ────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
# Build with base "/" so the app is served at the container root, not /Bertelsmann-InvoiceProcessing-Demo/
RUN npx vite build --base /

# ── Stage 2: serve ────────────────────────────────────────────────────────────
FROM nginx:1.27-alpine

# Custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets from build stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
