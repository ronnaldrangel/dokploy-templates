# Stage 1: Build stage
FROM node:20-alpine AS builder

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy the entire workspace (required because app/vite.config.ts uses ../blueprints and ../meta.json)
COPY . .

# Build the frontend application
WORKDIR /app/app
RUN pnpm install --no-frozen-lockfile
RUN pnpm run build

# Stage 2: Production stage (using a simple static server)
FROM node:20-alpine

# Install serve for serving static files
RUN npm install -g serve

WORKDIR /app

# Copy only the built output from the builder stage
COPY --from=builder /app/app/dist ./dist

# Expose the default port (3000 as requested)
EXPOSE 3000

# Start reflecting the static files on port 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
