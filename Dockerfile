# Start with the preferred Node.js base image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies without devDependencies and handle deprecations
RUN npm install --omit=dev && \
    npm uninstall signalr-client && \
    if npm list bloxy > /dev/null 2>&1; then npm uninstall bloxy; fi

# Address any vulnerabilities if possible
RUN npm audit fix --force

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

# Additional steps to create environment variables
# Replace [value] placeholders with actual values if needed
RUN echo "DISCORD_TOKEN=MTI4MDI1NjgzOTIyNDkyMjIzNQ.GkzF4B.EpVAnGbUfET3etrlefiHinHlWWN3tNuUmaNIdg" >> .env && \
    echo "_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_41E7401376349CB48DF428411EF70D5B8B46633F91D3E7DD2CCFA3DBA8B55D26052342FD41C28F0F7F5B5DA7ED5EDDA665872D637E13D93321D368B4613FBD724003DF2175CC4D2B107BF3F14D9ED1435AB057C90C42AA202D2C93243DC4DCEA2290EF9A72599DE2DA0A1D054BEEA00484F892DFE54A3411E86E86C5EA230EA71BB13C466A5FE0377A1CBF4ED718FD76E14A48A5C087A0923FC3F3D8B0BFFBB0C24A87F36733134F010DEC764C0DF8F40766C15756CFF81811AC165FF56E72EDC79F04DCE54DA5F95BE7DE7E27A65CF8864B013BC58CB45B8D01A0AD50575757883C944902781A5DF9ED8161317C835CA9D17A79371FFBC97C4BE0187E3A1C94EB2FC8D457EA3B0C76A8C0D0B1B0FD4EA39B995F000FB12423CA0361C5FBBBC2A9C0FC2387512D9A4F3B6D496ED85B0D359514C25104BED0C38FA8CA92D41027B157A7752A1D3F2E76285D1917126007E05FF60424D46ABD6EFFFE496C557FC01B49DCDFC7738C3B0ADFC99749A312778AA4EACABE3C6AF948798DF86E6BA73F351622C2A9D7694F0FFDDE8B2C93E01E2CD942C2219461F5ADFFE852D4F9C0AEFF5627337C926B7009774DF5FCA62CD23991A297381C2748A06914AA189E0697DF9571CC93700C7F007B1A010D5AA5CE306769D1B31B721E2F743BDF53B900016974016BE46AE4C45D2265A0D638E6F8649C63AEC9D63A2595E06900421486E759525653CBFC79E9C71D4265DCE7A4164D0BE45CD8243C0578B56B6E677BDD1A70428ED189F02D4F75CA2B3E498618E9A8810018FD78722BEAC9CCE20902FF27418E496B36626E30A04C7D0A00715AD754CE3A7ECFE07A16D56490AD98B1D21ED22F7C64F29E4E07C39DC76334FAB9C87BCCC64BBBD8FC51BF34E4A241954F61A07007A6DEB25FE2DD4489AF66797A4E9ED48DFA934CDC7F3C1CDB6071E57835E31C58902E75C7CFDC855BBE85A9AB0E5D54487B5742EF316CC74B3F2D64206BE76BA4FCCAF3D82E102A89372F2BD6A4539C04A46A55D2AE2BF958C054F63441CBC4D5C96787505EC55DECADA38B2276F50053E458A4F39479E0D31F1748B357483DE63629BD5ED42085F0AD5214470B712CF68AA8A324132B023A1989617F0C665D87C0E959A053E2CCF377420E765A4D5B408A" >> .env && \
    echo "GROUP_ID=34836147" >> .env

# Run these commands to initialize and start the bot
RUN git clone https://github.com/LengoLabs/qbot.git && \
    cd qbot && \
    npm install -D && \
    npm uninstall bloxy && \
    npm install https://github.com/LengoLabs/bloxy.git && \
    cd node_modules/bloxy && \
    npm run build && \
    cd ../.. && \
    npm install got@11.8.2 && \
    npx prisma migrate dev --schema ./src/database/schema.prisma --name init && \
    pm2 start npm --name "qbot" -- start && \
    pm2 save
