# Start with the preferred Node.js base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies, excluding Bloxy initially for a cleaner install
RUN npm install --omit=dev && npm uninstall bloxy

# Install the latest version of Bloxy from GitHub and build it
RUN npm install https://github.com/LengoLabs/bloxy.git && \
    npm run build --prefix node_modules/bloxy

# Install a specific version of `got` package
RUN npm install got@11.8.2

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
