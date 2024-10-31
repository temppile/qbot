# Start with your preferred Node.js base image
FROM node:18

# Create and set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install all dependencies except Bloxy
RUN npm install --omit=dev && npm uninstall bloxy

# Install the latest version of Bloxy from GitHub and build it
RUN npm install https://github.com/LengoLabs/bloxy.git && \
    cd node_modules/bloxy && \
    npm run build && \
    cd ../..

# Install a specific version of the `got` package
RUN npm install got@11.8.2

RUN npx prisma generate --schema ./src/database/schema.prisma
RUN npx prisma migrate dev --schema ./src/database/schema.prisma --name init

# Copy the rest of your application files
COPY . .

# Expose the port your bot runs on, if applicable (change 3000 to your app's port if needed)
EXPOSE 3000

# Define the command to run your bot
CMD ["npm", "start"]

