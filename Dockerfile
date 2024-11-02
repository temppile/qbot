# Start from a lightweight Node.js image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app code into the container
COPY . .

# Expose the port Qbot uses (customize if different)
EXPOSE 3000

# Run the bot
CMD ["npm", "start"]
