if GetResourceState('es_extended') ~= 'started' then return end
local ESX <const> = exports['es_extended']:getSharedObject()

-- For whatever reason, JSON logic is here, but if you're using ESX why are you not using MySQL option?
local function LoadJSON(file)
    local jsonData = LoadResourceFile(GetCurrentResourceName(), file)
    return jsonData and json.decode(jsonData) or {}
end

local function SaveJSON(file, data)
    SaveResourceFile(GetCurrentResourceName(), file, json.encode(data, { indent = true }), -1)
end

-- Function to get the player object from the player's source
-- @param source: The player's source
function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

-- Function to get the identifier of a player
-- @param source: The player's source
function GetIdentifier(source)
    local xPlayer = GetPlayer(source)
    if not xPlayer then
        local text = Config.Locales['xPlayer_nil']:format('GetIdentifier')
        DebugMessage('GetIdentifier', text, debug.getinfo(1).currentline)
        return
    end

    return xPlayer.identifier
end

-- Function to AddItem
-- @param source: The player's source
-- @param item: The item to add
-- @param amount: The amount of the item to add
function AddItem(source, item, amount)
    if not source then
        local text = Config.Locales['source_nil']:format('AddItem')
        DebugMessage('AddItem', text, debug.getinfo(1).currentline)
        return
    end
    if not item then
        local text = Config.Locales['item_nil']:format('AddItem')
        DebugMessage('AddItem', text, debug.getinfo(1).currentline)
        return
    end
    if not amount then
        local text = Config.Locales['amount_nil']:format('AddItem')
        DebugMessage('AddItem', text, debug.getinfo(1).currentline)
        return
    end

    local xPlayer = GetPlayer(source)
    if not xPlayer then
        local text = Config.Locales['xPlayer_nil']:format('AddItem')
        DebugMessage('AddItem', text, debug.getinfo(1).currentline)
        return
    end

    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(xPlayer.source, item, amount)
    end

    if item:lower():find('money') then
        -- Add regular money
        xPlayer.addMoney(amount)
    elseif item:lower():find('black_money') then
        -- Add black money
        xPlayer.addAccountMoney('black_money', amount)
    elseif item:lower():find('weapon_') then
        -- Add weapon with ammo
        if amount and type(amount) == 'number' then
            xPlayer.addWeapon(item:upper(), amount)  -- Uppercasing the weapon item to ensure it's valid
        else
            xPlayer.addWeapon(item:upper(), 0)  -- Default to 0 ammo if none is specified
        end
    else
        -- Add regular inventory item
        xPlayer.addInventoryItem(item, amount)
    end
end

-- Add coins to a player
-- @param source: The player's source
-- @param amount: The amount of coins to add
function AddCoins(source, amount)
    if not source then
        local text = Config.Locales['source_nil']:format('AddCoins')
        DebugMessage('AddCoins', text, debug.getinfo(1).currentline)
        return
    end
    if not amount then
        local text = Config.Locales['amount_nil']:format('AddCoins')
        DebugMessage('AddCoins', text, debug.getinfo(1).currentline)
        return
    end

    local identifier = GetIdentifier(source)
    if not identifier then
        local text = Config.Locales['identifier_nil']:format('AddCoins')
        DebugMessage('AddCoins', text, debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        MySQL.query.await('UPDATE `users` SET `coins` = `coins` + ? WHERE `identifier` = ?', { amount, identifier })
    else
        -- Use JSON storage
        local data = LoadJSON('coins.json')
        if not data[identifier] then
            data[identifier] = {
                name = GetPlayerName(source),
                coins = 0,
            }
        end
        data[identifier] = {
            name = GetPlayerName(source),
            coins = data[identifier].coins + amount
        }
        SaveJSON('coins.json', data)
    end
end

-- CountCoins from a player
-- @param source: The player's source
function CountCoins(source)
    if not source then
        local text = Config.Locales['source_nil']:format('CountCoins')
        DebugMessage('CountCoins', text, debug.getinfo(1).currentline)
        return
    end

    local identifier = GetIdentifier(source)
    if not identifier then
        local text = Config.Locales['identifier_nil']:format('CountCoins')
        DebugMessage('CountCoins', text, debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        local query = MySQL.single.await('SELECT `coins` FROM `users` WHERE `identifier` = ?', { identifier })
        return query and query.coins or 0
    else
        -- Use JSON storage
        local data = LoadJSON('coins.json')
        return data[identifier].coins or 0
    end
end

-- Function to remove coins from a player
-- @param source: The player's source
-- @param amount: The amount of coins to remove
function RemoveCoins(source, amount)
    if not source then
        local text = Config.Locales['source_nil']:format('RemoveCoins')
        DebugMessage('RemoveCoins', text, debug.getinfo(1).currentline)
        return
    end
    if not amount then
        local text = Config.Locales['amount_nil']:format('RemoveCoins')
        DebugMessage('RemoveCoins', text, debug.getinfo(1).currentline)
        return
    end

    local identifier = GetIdentifier(source)
    if not identifier then
        local text = Config.Locales['identifier_nil']:format('RemoveCoins')
        DebugMessage('RemoveCoins', text, debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        MySQL.query.await('UPDATE `users` SET `coins` = `coins` - ? WHERE `identifier` = ?', { amount, identifier })
    else
        -- Use JSON storage
        local data = LoadJSON('coins.json')
        if data[identifier] then
            data[identifier] = {
                name = GetPlayerName(source),
                coins = math.max(data[identifier] - amount, 0) -- Ensure no negative coins
            }
            SaveJSON('coins.json', data)
        end
    end
end

-- Function to set coins for a player
-- @param source: The player's source
-- @param amount: The amount of coins to set
function SetCoins(source, amount)
    if not source then
        local text = Config.Locales['source_nil']:format('SetCoins')
        DebugMessage('SetCoins', text, debug.getinfo(1).currentline)
        return
    end
    if not amount then
        local text = Config.Locales['amount_nil']:format('SetCoins')
        DebugMessage('SetCoins', text, debug.getinfo(1).currentline)
        return
    end

    local identifier = GetIdentifier(source)
    if not identifier then
        local text = Config.Locales['identifier_nil']:format('SetCoins')
        DebugMessage('SetCoins', text, debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        MySQL.query.await('UPDATE `users` SET `coins` = ? WHERE `identifier` = ?', { amount, identifier })
    else
        -- Use JSON storage
        local data = LoadJSON('coins.json')
        data[identifier] = {
            name = GetPlayerName(source),
            coins = amount
        }
        SaveJSON('coins.json', data)
    end
end


-- Function to get the top players
function GetTopPlayers()
    if Config.DB then
        local users = MySQL.query.await('SELECT `firstname`, `lastname`, `coins` FROM `users` ORDER BY `coins` DESC LIMIT 10')
        local TOPPlayers = {}

        for i = 1, #users do
            local user = users[i]
            local coins = user.coins
            local name = ('%s %s'):format(user.firstname, user.lastname)

            TOPPlayers[i] = {
                name = name,
                coins = coins,
            }
        end

        return TOPPlayers
    else
        -- Use JSON storage
        local data = LoadJSON('coins.json')
        local TOPPlayers = {}
        local sortedPlayers = {}

        -- Sort players by coins
        for identifier, coins in pairs(data) do
            sortedPlayers[#sortedPlayers + 1] = { identifier = identifier, coins = coins }
        end
        table.sort(sortedPlayers, function(a, b) return a.coins > b.coins end)

        -- Fetch the top 10 players
        for i = 1, math.min(10, #sortedPlayers) do
            local player = sortedPlayers[i]
            TOPPlayers[i] = {
                name = player.coins.name,
                coins = player.coins.coins,
            }
        end

        return TOPPlayers
    end
end
-- Function to check if the `coins` column exists in the `users` table
function ValidDB()
    if Config.DB then
        -- Check if `coins` column exists in the `users` table
        local query = MySQL.query.await('SHOW COLUMNS FROM `users` LIKE "coins"')
        if #query == 0 then
            MySQL.query.await('ALTER TABLE `users` ADD `coins` INT NOT NULL DEFAULT 0')
            print(Config.Locales['added_coins_column'])
        end

        -- Check if `trase_dailyrewards` table exists
        local tableQuery = MySQL.query.await('SHOW TABLES LIKE "trase_dailyrewards"')
        if #tableQuery == 0 then
            MySQL.query.await([[CREATE TABLE IF NOT EXISTS `trase_dailyrewards` (`identifier` varchar(60) DEFAULT NULL, `days` longtext DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;]])
            print(Config.Locales['created_dailyrewards_table'])
        end

        if Config.PlayTime.Enabled then
            -- Check if `trase_playtime` table exists
            local playtimeTable = MySQL.query.await('SHOW TABLES LIKE "trase_playtime"')
            if #playtimeTable == 0 then
                MySQL.query.await([[CREATE TABLE IF NOT EXISTS `trase_playtime` (`identifier` varchar(60) DEFAULT NULL, `playtime` int(11) DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;]])
                print(Config.Locales['created_playtime_table'])
            end
        end
    else
        -- Ensure JSON files exist
        if not LoadResourceFile(GetCurrentResourceName(), 'coins.json') then
            SaveJSON('coins.json', {})
            print(Config.Locales['created_coins_json'])
        end
        if not LoadResourceFile(GetCurrentResourceName(), 'daily_rewards.json') then
            SaveJSON('daily_rewards.json', {})
            print(Config.Locales['created_daily_rewards_json'])
        end
        if Config.PlayTime.Enabled and not LoadResourceFile(GetCurrentResourceName(), 'playtime.json') then
            SaveJSON('playtime.json', {})
            print(Config.Locales['created_playtime_json'])
        end
    end
end


function GetDailyRewardIdentifier(src)
    if not Config.DailyRewardsOnce then
        return GetIdentifier(src)
    end

    local identifiers = GetPlayerIdentifiers(src)
    for i = 1, #identifiers do
        local identifier = identifiers[i]
        if identifier:find('license') then
            return identifier
        end
    end

    return nil
end

-- Function to get Daily Rewards
-- @param source: The player's source
function GetDailyRewards(source)
    if not source then
        local text = Config.Locales['source_nil']:format('GetDailyRewards')
        DebugMessage('GetDailyRewards', text, debug.getinfo(1).currentline)
        return
    end

    local identifier = GetDailyRewardIdentifier(source)
    if not identifier then
        local text = Config.Locales['identifier_nil']:format('GetDailyRewards')
        DebugMessage('GetDailyRewards', text, debug.getinfo(1).currentline)
        return
    end

    if Config.DB then
        local query = MySQL.single.await('SELECT * FROM `trase_dailyrewards` WHERE `identifier` = ?', { identifier })
        return query
    else
        -- Use JSON storage
        local data = LoadJSON('daily_rewards.json')
        local days = {}
        if data[identifier] then
            days = data[identifier].days
        end
        return {
            days = json.encode(days)
        }
    end
end


-- Function to check for permission
-- @param source: Boolean
function HasPermissions(source)
    local xPlayer = GetPlayer(source)
    if not xPlayer then return false end

    local group = xPlayer.getGroup()

    -- Check if the player is in a group with permissions
    if group == 'superadmin' or group == 'admin' then
        return true
    end

    -- Check if the player has the ace permission "trase_shop.giveCoins"
    if IsPlayerAceAllowed(source, 'trase_shop.giveCoins') then
        return true
    end

    return false
end

function AddDayOpened(identifier, day)
    if Config.DB then
        local data = MySQL.single.await('SELECT * FROM `trase_dailyrewards` WHERE `identifier` = ?', { identifier })
        if not data then
            MySQL.insert.await('INSERT INTO `trase_dailyrewards` (`identifier`, `days`) VALUES (?, ?)', { identifier, json.encode({ day }) })
        else
            local days = json.decode(data.days)
            days[#days+1] = day
            MySQL.query.await('UPDATE `trase_dailyrewards` SET `days` = ? WHERE `identifier` = ?', { json.encode(days), identifier })
        end
    else
        -- Use JSON storage
        local data = LoadJSON('daily_rewards.json')
        if not data[identifier] then
            data[identifier] = {
                days = { day }
            }
        else
            data[identifier].days[#data[identifier].days + 1] = day
        end
        SaveJSON('daily_rewards.json', data)
    end
end

function WipeDailyRewards()
    if Config.DB then
        MySQL.query.await('TRUNCATE TABLE `trase_dailyrewards`')
    end
end