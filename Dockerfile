# Start from the official Node.js image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the code
COPY . .

# Compile TypeScript
RUN npm run build

# Expose the port that Qbot will run on
EXPOSE 3000

# Start Qbot
CMD ["npm", "start"]
