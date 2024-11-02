# Start with the preferred Node.js base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies, excluding Bloxy initially for a cleaner install
RUN npm ci --omit=dev --silent && npm uninstall bloxy --silent

# Set network timeout in case of network issues
RUN npm config set network-timeout 600000

# Address any vulnerabilities if possible
RUN npm audit fix --force

# Install the latest version of Bloxy from GitHub and build it
RUN npm install https://github.com/LengoLabs/bloxy.git --silent && \
    npm run build --prefix node_modules/bloxy --silent

# Install a specific version of `got` package
RUN npm install got@11.8.2 --silent

# Generate Prisma client and apply database migrations
# Make sure DATABASE_URL is set in Northflank environment variables
COPY ./src/database/schema.prisma ./src/database/schema.prisma
RUN npx prisma generate --schema ./src/database/schema.prisma && \
    npx prisma migrate dev --schema ./src/database/schema.prisma --name init

# Copy the rest of your application files
COPY . .

# Expose the port your bot runs on (change 3000 if needed)
EXPOSE 3000

# Define the default command to run your bot
CMD ["npm", "start"]
