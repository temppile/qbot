# Use the latest Node.js image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Install Prisma CLI globally (if not already included in package.json)
RUN npm install -g prisma

# Copy the rest of the project files
COPY . .

# Generate Prisma client and run migrations
RUN npx prisma generate --schema ./src/database/schema.prisma
RUN npx prisma migrate dev --schema ./src/database/schema.prisma --name init

# Set environment variables (optional, can also be set in Northflank UI)
ENV PORT=3000

# Expose the port the app runs on
EXPOSE 3000

# Start the bot
CMD ["npm", "start"]
