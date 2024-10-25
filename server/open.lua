local WEBHOOK <const> = ''

CreateThread(function()
    local URL <const> = 'https://raw.githubusercontent.com/ImTrase/versions/main/shop_system.txt'
    local VERSION <const> = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

    PerformHttpRequest(URL, function(status, body)
        if body and status == 200 then
            body = body:match('%d%.%d+%.%d+')
            if VERSION < body then
                print(('^4[Trase_Shops] ^3[INFO]^0: A new version is available. ^7(Current Version: ^1%s^7, Latest Version: ^2%s^7)'):format(VERSION, body))
            end
        end
    end, 'GET')
end)

function DebugMessage(where, problem, line)
    if not Config.Debug then return end
    local msg = ('^4[TRASE_SHOP] ^6[DEBUG]^0: \n^5[%s]^0: %s\n^5[%s]^0: %s\n^5[%s]^0: %s'):format(
        Config.Locales['where'],
        where,
        Config.Locales['reason'],
        problem,
        Config.Locales['line'],
        line
    )
    print(msg)
end

local function LoadJSON(file)
    local jsonData = LoadResourceFile(GetCurrentResourceName(), file)
    return jsonData and json.decode(jsonData) or {}
end

local function SaveJSON(file, data)
    SaveResourceFile(GetCurrentResourceName(), file, json.encode(data, { indent = true }), -1)
end

-- Function to return os.time format to a table of days, hours, minutes, seconds
-- @param time: The time in seconds
local function ConvertTime(time)
    if not time then return end
    local days = math.floor(time / 86400)
    local hours = math.floor((time % 86400) / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = math.floor(time % 60)
    return {
        days = days,
        hours = hours,
        minutes = minutes,
        seconds = seconds
    }
end

-- Can change this function to your playtime script if you have one
-- Should return a table containing days, hours, minutes, seconds
function GetPlaytime(target)
    if not target then return end
    local identifier = GetIdentifier(target)
    if not identifier then
        DebugMessage(Config.Locales['get_playtime'], Config.Locales['identifier_missing'], debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        local playtime = MySQL.query.await('SELECT `playtime` FROM `trase_playtime` WHERE `identifier` = ?', { identifier })
        if not playtime or not playtime[1] then
            -- Insert 0
            MySQL.query.await('INSERT INTO `trase_playtime` (`identifier`, `playtime`) VALUES (?, ?)', { identifier, 0 })
            return { days = 0, hours = 0, minutes = 0, seconds = 0 }
        end
        return ConvertTime(playtime[1].playtime)
    else
        -- Load JSON data if database is disabled
        local data = LoadJSON('playtime.json')
        if not data[identifier] then
            -- Insert 0
            data[identifier] = 0
            SaveJSON('playtime.json', data)
            return { days = 0, hours = 0, minutes = 0, seconds = 0 }
        end
        return ConvertTime(data[identifier])
    end
end

-- Function to update playtime in the database
function UpdatePlaytime(src, playtime)
    local identifier = GetIdentifier(src)
    if not identifier then
        DebugMessage(Config.Locales['update_playtime'], Config.Locales['identifier_missing'], debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        local exists = MySQL.query.await('SELECT * FROM `trase_playtime` WHERE `identifier` = ?', { identifier })
        if #exists == 0 then
            MySQL.query.await('INSERT INTO `trase_playtime` (`identifier`, `playtime`) VALUES (?, ?)', { identifier, playtime })
            local insertMessage = Config.Locales['playtime_inserted']:format(GetPlayerName(src))
            print(('^4[TRASE_PLAYTIME] ^2[SUCCESS]^0: %s'):format(insertMessage))
            return
        end
        MySQL.query.await('UPDATE `trase_playtime` SET `playtime` = `playtime` + ? WHERE `identifier` = ?', { playtime, identifier })
        local updateMessage = Config.Locales['playtime_updated']:format(GetPlayerName(src))
        print(('^4[TRASE_PLAYTIME] ^2[SUCCESS]^0: %s'):format(updateMessage))
    else
        -- Load the existing data from the JSON file
        local data = LoadJSON('playtime.json')

        -- Update playtime or insert a new record if the player doesn't exist
        if not data[identifier] then
            data[identifier] = playtime
            print(('^4[TRASE_PLAYTIME] ^2[SUCCESS]^0: %s inserted into JSON'):format(GetPlayerName(src)))
        else
            data[identifier] = data[identifier] + playtime
            print(('^4[TRASE_PLAYTIME] ^2[SUCCESS]^0: %s updated in JSON'):format(GetPlayerName(src)))
        end

        -- Save the updated data back to the JSON file
        SaveJSON('playtime.json', data)
    end
end

-- Award playtime to players for being online
local CachedRewards = {}
RegisterNetEvent('trase_shop:server:rewardPlaytime', function()
    local src = source

    if not Config.PlayTime.Enabled then
        return -- Modder, playtime is disabled
    end

    
    if Config.PlayTime.Reward <= 0 then
        return -- Modder, reward is 0
    end

    if CachedRewards[src] then
        local lastRewarded = CachedRewards[src]
        local currentTime = os.time()
        local timeDifference = currentTime - lastRewarded

        -- Convert the duration from minutes to seconds
        print(timeDifference)
        if timeDifference < Config.PlayTime.Duration * 60 then
            return print('mod') -- Modder, player has not played long enough
        end
    end

    AddCoins(src, Config.PlayTime.Reward)
    CachedRewards[src] = os.time()
end)

local function getIdentifiers(player)
    local t = {}

    if player then
        local identifiers = GetPlayerIdentifiers(player)

        for i=1, #identifiers do
            local prefix, identifier = string.strsplit(':', identifiers[i])
            t[prefix] = identifier
        end
    end

    return t
end

function FormatIdentifiers(target)
    local t = {}

    local identifiers = getIdentifiers(target)

    for k, v in pairs(identifiers) do
        if k == 'steam' then
            t[#t+1] = ('Steam: [%s](https://steamcommunity.com/profiles/%s)'):format(v, tonumber(v, 16))
        elseif k == 'discord' then
            t[#t+1] = ('Discord: <@%s>'):format(v)
        elseif k == 'license' then
            t[#t+1] = ('License: %s'):format(v)
        elseif k == 'license2' then
            t[#t+1] = ('License 2: %s'):format(v)
        elseif k == 'fivem' then
            t[#t+1] = ('FiveM: %s'):format(v)
        elseif k == 'xbl' then
            t[#t+1] = ('Xbox: %s'):format(v)
        elseif k == 'live' then
            t[#t+1] = ('Live: %s'):format(v)
        end
    end

    return table.concat(t, '\n')
end

-- Function to log to discord
function LogToDiscord(args)
    if (not args or type(args) ~= 'table') then return end

    local embed = {
        color = '0',
        type = 'rich',
        title = args?.title or '',
        description = args?.description or '',
        timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
        footer = {
            text = 'Trase.Dev © 2024',
            icon_url = 'https://cdn.discordapp.com/attachments/1119540289196003410/1157097126363406457/logo.png?ex=65175e2c&is=65160cac&hm=5acffe6f61ae2989aab52dc1fb41136910754f7848e7f4071bbd90028c0a20c9&'
        }
    }

    if type(args?.fields) == 'table' and #args?.fields >= 1 then
        embed.fields = args?.fields
    end

    local encodedData = {
        username = 'Shop System 🛒',
        avatar_url = 'https://cdn.discordapp.com/attachments/1119540289196003410/1157097126363406457/logo.png?ex=65175e2c&is=65160cac&hm=5acffe6f61ae2989aab52dc1fb41136910754f7848e7f4071bbd90028c0a20c9&',
        embeds = { embed }
    }
 
    PerformHttpRequest(WEBHOOK, function(statusCode, responseText, headers)
    end, 'POST', json.encode(encodedData), { ['Content-Type'] = 'application/json' })
end