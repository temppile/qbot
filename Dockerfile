# Start with the preferred Node.js base image
FROM node:20

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies without devDependencies and handle deprecations
RUN npm install --omit=dev && \
    npm uninstall signalr-client && \
    npm install simple-update-notifier@latest semver@latest got@12.0.0 @sapphire/framework && \
    npm install https://github.com/LengoLabs/bloxy.git && \
    npm install --save-dev @types/debug @types/tough-cookie && \
    npm run build --prefix node_modules/bloxy

# Generate Prisma client and apply database migrations
COPY ./src/database/schema.prisma ./src/database/schema.prisma
RUN npx prisma generate --schema ./src/database/schema.prisma && \
    npx prisma migrate dev --schema ./src/database/schema.prisma --name init

# Copy the rest of your application files
COPY . .

# Expose the port your bot runs on (change 3000 if needed)
EXPOSE 3000

# Define the default command to run your bot
CMD ["npm", "start"]
