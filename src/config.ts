import { ActivityType } from 'discord.js';
import { BotConfig } from './structures/types'; 

export const config: BotConfig = {
    groupId: 34836147,
    slashCommands: true,
    legacyCommands: {
        enabled: true,
        prefixes: ['q!'],
    },
    permissions: {
        all: ['1283150907831353425', '1235671893315424326', '1280174749816979456', '1282054590522720287', '1297360036670079027'],
        ranking: ['1280145653464432660', '1189322992044478519', '1189323232973689002', '1300641917003894895', '1301027087301349420', '1189323180414865469'],
        users: [''],
        shout: [''],
        join: [''],
        signal: [''],
        admin: [''],
    },
    logChannels: {
        actions: '1280281375445880874',
        shout: '1280281375445880874',
    },
    api: true,
    maximumRank: 255,
    verificationChecks: true,
    bloxlinkGuildId: '1074357095488552991',
    firedRank: 1,
    suspendedRank: 1,
    recordManualActions: true,
    memberCount: {
        enabled: true,
        channelId: '1280292208012034121',
        milestone: 200,
        onlyMilestones: false,
    },
    xpSystem: {
        enabled: false,
        autoRankup: false,
        roles: [],
    },
    antiAbuse: {
        enabled: false,
        clearDuration: 1 * 60,
        threshold: 10,
        demotionRank: 1,
    },
