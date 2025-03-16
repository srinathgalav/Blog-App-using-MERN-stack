# Multi-stage build for MERN stack application

# Build stage for React frontend
FROM node:18-alpine as client-build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# Main image for both server and client
FROM node:18-alpine
WORKDIR /app

# Copy and install server dependencies
COPY server/package*.json ./
RUN npm install --only=production

# Copy server code
COPY server/ ./

# Copy built React app from client-build stage
COPY --from=client-build /app/client/build ./client/build

# Environmental variables
ENV NODE_ENV=production
ENV PORT=5000

# Expose ports for backend and frontend
EXPOSE 5000
EXPOSE 3000

# Command to run the application
CMD ["node", "server.js"]