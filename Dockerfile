# Start from the official Node.js image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install -D

# Copy the rest of the code
COPY . .

RUN npm uninstall bloxy
RUN npm install https://github.com/LengoLabs/bloxy.git
RUN cd node_modules/bloxy
RUN npm run build
RUN cd ../..
RUN npm install got@11.8.2

# Expose the port that Qbot will run on
EXPOSE 3000

# Start Qbot
CMD ["npm", "start"]
