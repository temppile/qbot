const roblox = require('noblox.js');
const Discord = require('discord.js');
const path = require('path');
const _ = require('lodash');
require('dotenv').config();

const config = {
    description: 'Shows a list of commands.',
    aliases: [],
    usage: '',
    rolesRequired: [],
    category: 'Info'
}

module.exports = {
    config,
    run: async (client, message, args) => {
        let embed = new Discord.MessageEmbed();
        let categories = _.groupBy(client.commandList, c => c.config.category);
        for (const categoryName of Object.keys(categories)) {
            let category = categories[categoryName];
            let commandString = category.map(c => `\`${process.env.prefix}${c.name}${c.config.usage ? ` ${c.config.usage}` : ''}\` - ${c.config.description}`).join('\n');
            embed.addField(`${categoryName}`, `${commandString}`);
        }
        embed.setDescription('Here is a list of the bot commands:');
        embed.setColor(client.constants.colors.info);
        embed.setAuthor(message.author.tag, message.author.displayAvatarURL());
        return message.channel.send(embed);
    }
}
