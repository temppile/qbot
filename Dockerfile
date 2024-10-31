# Start from a lightweight Node.js image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install git to clone the repository
RUN apk add --no-cache git

# Clone the Qbot repository
RUN git clone https://github.com/LengoLabs/qbot.git /app

# Install dependencies
RUN npm install

# Expose the bot’s port (customize if needed)
EXPOSE 3000

# Run the bot
CMD ["npm", "start"]
