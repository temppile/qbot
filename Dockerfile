# Start from a lightweight Node.js image
FROM node:18-alpine

# Install Git, as it’s required to pull dependencies from GitHub
RUN apk add --no-cache git

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies first
COPY package*.json ./

# Install dependencies, replace bloxy with the custom version, build it, and add got
RUN npm install && \
    npm uninstall bloxy && \
    npm install https://github.com/LengoLabs/bloxy.git && \
    cd node_modules/bloxy && npm run build && cd ../../ && \
    npm install got@11.8.2

# Copy the rest of the app code into the container
COPY . .

# Expose the port Qbot uses (customize if different)
EXPOSE 3000

# Run the bot
CMD ["npm", "start"]
