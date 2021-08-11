
# Use node 16 as base image
FROM node:16

# Create nizuri dir and set as working dir
RUN mkdir -p /usr/src/nizuri
WORKDIR /usr/src/nizuri

# Copy files/folders to working dir
COPY commands ./commands
COPY events ./events
COPY * ./

# Install dependencies
RUN npm i

# Compile from Typescript
RUN ./node_modules/typescript/bin/tsc -p ./tsconfig.json

# Open ports for discordjs
EXPOSE 80 443

# Build for Production
ENV NODE_ENV = "production"

# Start cmd
CMD [ "node", "./dist/index.js" ]