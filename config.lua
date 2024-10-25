Config = {}
Config.Lang = 'en'
Config.StoreURL = 'https://trase.dev/' -- The website that opens when they press the + button

Config.Logs = {
    Enabled = true, -- Enable discord logs?
    -- Setup webhook in server/open.lua
}

Config.PlayTime = {
    Enabled = true, -- Set to false to disable playtime
    Duration = 1, -- Give rewards every X minutes
    Reward = 5, -- Amount of coins to give every 5 X duration (0 to disable)
    Command = 'playtime', -- The command to check playtime
}

-- Uses framework permissons or ace permissions (can edit in framework/[FRAMEWORK]/server.lua HasPermission function)
-- add_ace identifier.[identifier] trase_shop.giveCoins allow
-- add_ace identifier.discord:334259748499357697 trase_shop.giveCoins allow
Config.AddCommand = {
    Enabled = true,
    Command = 'addcoins',
}

Config.Debug = true -- Set to false to disable debug messages (helps find issues)
Config.DB = true -- Set to false if you don't want to use the database and use json instead (not recommended)
Config.DailyRewardsOnce = true -- Setting this to true will stop players from switching characters to claim rewards again (IF using multicharacters)
Config.DailyRewardsVIP = true -- If true, only VIP players can claim daily rewards

-- NOTE: Due to new FiveM Update, Imgur and Discord links do not display images.
Config.DefaultAvatar = 'https://api-private.atlassian.com/users/6b5c1609134a5887d7f3ab1b73557664/avatar' -- Will use this is the player doesn't have a discord avatar or if Config.Discord.Avatar is false
Config.Discord = {
    ResourceName = 'trase_discord', -- If you changed the resource name for trase_discord, change this to the new name
    Avatar = true, -- If true will use the player's discord avatar as their profile picture
    Name = true, -- If true will use the player's discord name as their profile name
}


Config.Open = {
    Command = 'shop',
    Key = 'F4', -- Set to false to disable the keybind
}

Config.UI = {
    -- Red Color Example
    -- MainColor = '#FF1A1A',
    -- MainColorDarker = '#a30000',

    -- Blue Color Example
    MainColor = '#1A1AFF',
    MainColorDarker = '#0000a3',

    -- NOTE: Due to new FiveM Update, Imgur and Discord links do not display images.
    Logo = 'https://r2.fivemanage.com/BPXlFpW6Q3yIqdqXyvRgD/images/text_logo.png', -- Set to a URL to use a custom logo
    Images = 'nui://ox_inventory/web/images/'
}

--[[ For Images its the NUI link to where the images are stored. 
    ox_inventory: 'nui://ox_inventory/web/images/'
    esx_inventoryhud: 'nui://esx_inventoryhud/html/images/'
    qb-inventory: 'nui://qb-inventory/html/images/'

    -----------------------------------------------------------------------------------------------
    --- You can also just manually add the images to the web/images folder and use the direct link
    --- Example: nui://trase_store/web/images/
    --- -----------------------------------------------------------------------------------------------

    This will be used to display images in the shop UI
    For more support and information join the discord: https://discord.gg/trase
]]

Config.DailyRewards = {
    { item = 'bandage', amount = '2x', count = 2, label = 'Bandage', day = 1 },
    { item = 'burger', amount = '1x', count = 1, label = 'Burger', day = 2 },
    { item = 'sprunk', amount = '1x', count = 1, label = 'Sprunk', day = 3 },
    { item = 'parachute', amount = '1x', count = 1, label = 'Parachute', day = 4 },
    { item = 'armour', amount = '1x', count = 1, label = 'Armor', day = 5 },
    { item = 'black_money', amount = '$5000', count = 5000, label = 'Dirty Money', day = 6 },
    { item = 'ammo-9', amount = '100x', count = 100, label = 'Pistol Ammo', day = 7 },
    { item = 'lockpick', amount = '1x', count = 1, label = 'Lockpick', day = 8 },
    { item = 'paperbag', amount = '2x', count = 2, label = 'Paper Bag', day = 9 },
    { item = 'phone', amount = '1x', count = 1, label = 'Phone', day = 10 },
    { item = 'money', amount = '$10000', count = 10000, label = 'Money', day = 11 },
    { item = 'bandage', amount = '3x', count = 3, label = 'Bandage', day = 12 },
    { item = 'burger', amount = '2x', count = 2, label = 'Burger', day = 13 },
    { item = 'parachute', amount = '1x', count = 1, label = 'Parachute', day = 14 },
    { item = 'sprunk', amount = '2x', count = 2, label = 'Sprunk', day = 15 },
    { item = 'armour', amount = '2x', count = 2, label = 'Armor', day = 16 },
    { item = 'lockpick', amount = '2x', count = 2, label = 'Lockpick', day = 17 },
    { item = 'black_money', amount = '$7000', count = 7000, label = 'Dirty Money', day = 18 },
    { item = 'ammo-9', amount = '150x', count = 150, label = 'Pistol Ammo', day = 19 },
    { item = 'phone', amount = '1x', count = 1, label = 'Phone', day = 20 },
    { item = 'money', amount = '$15000', count = 15000, label = 'Money', day = 21 },
    { item = 'bandage', amount = '5x', count = 5, label = 'Bandage', day = 22 },
    { item = 'burger', amount = '3x', count = 3, label = 'Burger', day = 23 },
    { item = 'parachute', amount = '1x', count = 1, label = 'Parachute', day = 24 },
    { item = 'sprunk', amount = '3x', count = 3, label = 'Sprunk', day = 25 },
    { item = 'armour', amount = '3x', count = 3, label = 'Armor', day = 26 },
    { item = 'phone', amount = '1x', count = 1, label = 'Phone', day = 27 },
    { item = 'money', amount = '$20000', count = 20000, label = 'Money', day = 28 },
    { item = 'lockpick', amount = '3x', count = 3, label = 'Lockpick', day = 29 },
    { item = 'ammo-9', amount = '200x', count = 200, label = 'Pistol Ammo', day = 30 },
    { item = 'black_money', amount = '$10000', count = 10000, label = 'Dirty Money', day = 31 }
}

Config.Shop = {
    Categories = {
        'Weapons',
        'New Category',
        'Case',
    },
    Items = {
        {
            label = 'AP Pistol', -- Label of the card title
            item = 'WEAPON_APPISTOL', -- The item that picture shows on the card
            price = 100, -- The amount of coins needed to purchase the item
            rewards = { -- The rewards the player will receive when purchasing the item
                ['WEAPON_APPISTOL'] = 1,
                ['ammo-9'] = 100, -- 9mm Pistol Ammo
            },
            category = 'Weapons', -- The category the item belongs to
            features = { -- The features of the item that will be listed when the card is clicked
                '1x AP Pistol',
                '100x 9mm Ammo',
            }
        },
        {
            label = 'Carbine Rifle',
            item = 'WEAPON_CARBINERIFLE',
            price = 250,
            rewards = {
                ['WEAPON_CARBINERIFLE'] = 1,
                ['ammo-rifle'] = 200, -- Rifle Ammo
            },
            category = 'Weapons',
            features = {
                '1x Carbine Rifle',
                '200x Rifle Ammo',
            }
        },
        {
            label = 'Pump Shotgun',
            item = 'WEAPON_PUMPSHOTGUN',
            price = 150,
            rewards = {
                ['WEAPON_PUMPSHOTGUN'] = 1,
                ['ammo-shotgun'] = 50, -- Shotgun Ammo
            },
            category = 'Weapons',
            features = {
                '1x Pump Shotgun',
                '50x Shotgun Ammo',
            }
        },
        {
            label = 'SMG',
            item = 'WEAPON_SMG',
            price = 180,
            rewards = {
                ['WEAPON_SMG'] = 1,
                ['ammo-smg'] = 150, -- SMG Ammo
            },
            category = 'Weapons',
            features = {
                '1x SMG',
                '150x SMG Ammo',
            }
        },
        {
            label = 'Sniper Rifle',
            item = 'WEAPON_SNIPERRIFLE',
            price = 400,
            rewards = {
                ['WEAPON_SNIPERRIFLE'] = 1,
                ['ammo-sniper'] = 20, -- Sniper Ammo
            },
            category = 'Weapons',
            features = {
                '1x Sniper Rifle',
                '20x Sniper Ammo',
            }
        },
        {
            label = 'Combat Pistol',
            item = 'WEAPON_COMBATPISTOL',
            price = 120,
            rewards = {
                ['WEAPON_COMBATPISTOL'] = 1,
                ['ammo-9'] = 120, -- 9mm Pistol Ammo
            },
            category = 'Weapons',
            features = {
                '1x Combat Pistol',
                '120x 9mm Ammo',
            }
        },
        {
            label = 'Heavy Revolver',
            item = 'WEAPON_REVOLVER',
            price = 200,
            rewards = {
                ['WEAPON_REVOLVER'] = 1,
                ['ammo-revolver'] = 30, -- Revolver Ammo
            },
            category = 'Weapons',
            features = {
                '1x Heavy Revolver',
                '30x Revolver Ammo',
            }
        },
        -- Food Category
        {
            label = 'Burger',
            item = 'burger',
            price = 10,
            rewards = {
                ['burger'] = 1,
            },
            category = 'New Category',
            features = {
                '1x Burger',
            }
        },
        -- Case Category
        {
            label = 'Pistol Case',
            item = 'pistol_case',
            price = 500,
            rewards = {
                ['WEAPON_PISTOL'] = 1,
                ['ammo-9'] = 250,
            },
            category = 'Case',
            features = {
                '1x Pistol',
                '250x Pistol Ammo Rounds'
            }
        },
        {
            label = 'Rifle Case',
            item = 'rifle_case',
            price = 500,
            rewards = {
                ['WEAPON_CARBINERIFLE'] = 1,
                ['WEAPON_PUMPSHOTGUN'] = 1,
                ['ammo-rifle'] = 200,
                ['ammo-shotgun'] = 50,
            },
            category = 'Case',
            features = {
                '1x Carbine Rifle',
                '1x Pump Shotgun',
                '200x Rifle Ammo',
                '50x Shotgun Ammo',
            }
        },
    }
}
