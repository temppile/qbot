# Start with the preferred Node.js base image
FROM node:20

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install Qbot's main dependencies with `-D` flag
RUN npm install -D

# Uninstall and reinstall specific dependencies due to known issues
RUN npm uninstall bloxy && \
    npm install https://github.com/LengoLabs/bloxy.git && \
    cd node_modules/bloxy && \
    npm run build && \
    cd ../.. && \
    npm install got@11.8.2

# Install type definitions for 'debug' and 'tough-cookie' as dev dependencies
RUN npm install --save-dev @types/debug @types/tough-cookie

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
