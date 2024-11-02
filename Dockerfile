# Start with the preferred Node.js base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Increase network timeout to handle any network delays
RUN npm config set network-timeout 600000

# Install dependencies without devDependencies and remove any unused packages
RUN npm ci --omit=dev --no-audit --no-fund && \
    npm uninstall bloxy || true

# Address any vulnerabilities if possible
RUN npm audit fix --force

# Install the latest version of Bloxy from GitHub and build it
RUN npm install https://github.com/LengoLabs/bloxy.git --no-audit --no-fund && \
    npm run build --prefix node_modules/bloxy

# Install the specified version of `got` package
RUN npm install got@11.8.2 --no-audit --no-fund

# Copy only Prisma schema and generate Prisma client and apply migrations
COPY ./src/database/schema.prisma ./src/database/schema.prisma
RUN npx prisma generate --schema ./src/database/schema.prisma && \
    npx prisma migrate dev --schema ./src/database/schema.prisma --name init

# Copy the rest of your application files
COPY . .

# Expose the port Qbot runs on
EXPOSE 3000

# Define the default command to run Qbot
CMD ["npm", "start"]
