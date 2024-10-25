local TOPPlayers = {}

CreateThread(function()
    ValidDB()
    TOPPlayers = GetTopPlayers()
end)

local function organizeRewards()
    local todaysDate = os.date('*t')

    for i = 1, #Config.DailyRewards do
        -- Check the day and see if it is past or the same as the current day
        Config.DailyRewards[i].canOpen = todaysDate.day == Config.DailyRewards[i].day
    end

    return Config.DailyRewards
end

local function formatRewards(target)
    local rewards = organizeRewards()
    local playerRewards = {}
    local daysOpened = {}

    local query = GetDailyRewards(target)
    if query then
        local found = json.decode(query.days)
        for i = 1, #found do
            daysOpened[found[i]] = true
        end
    end

    for i = 1, #rewards do
        local reward = rewards[i]
        local canOpen = reward.canOpen

        playerRewards[i] = {
            day = reward.day,
            item = reward.item,
            amount = reward.amount,
            label = reward.label,
            canOpen = canOpen,
            claimed = daysOpened[reward.day] and true or false,
            image = reward.image,
            count = reward.count,
        }
    end

    return playerRewards
end

local function GetInfo(src)
    local avatar = Config.DefaultAvatar
    local name = GetPlayerName(src)
    if not src then
        return DebugMessage('GetAvatar', Config.Locales['error_src_nil'], debug.getinfo(1).currentline)
    end

    if GetResourceState(Config.Discord.ResourceName) ~= 'started' then
        DebugMessage('GetAvatar', Config.Locales['error_discord_not_started'], debug.getinfo(1).currentline)
        return avatar, name
    end

    if Config.Discord.Avatar then
        avatar = exports[Config.Discord.ResourceName]:getAvatar(src)
    end

    if Config.Discord.Name then
        name = exports[Config.Discord.ResourceName]:getUsername(src)
    end

    return avatar, name
end

RegisterCommand('shop', function(src)
    local identifier = GetDailyRewardIdentifier(src)
    if not identifier then
        DebugMessage('/shop', Config.Locales['error_identifier_nil'], debug.getinfo(1).currentline)
    end

    local coins = CountCoins(src)
    local icon, name = GetInfo(src)
    local playtime = GetPlaytime(src)
    local string = Config.Locales['playtime_format']:format(playtime.days, playtime.hours, playtime.minutes)

    local data = {
        name = name,
        playtime = string,
        icon = icon,
        coins = coins
    }

    local Rewards = formatRewards(src)
    TriggerClientEvent('trase_shop:client:open', src, data, TOPPlayers, Rewards)
end, false)

RegisterNetEvent('trase_shop:server:rewards:open', function(day)
    local src = source
    local identifier = GetDailyRewardIdentifier(src)
    local Rewards = formatRewards(src)
    local FoundReward
    for i = 1, #Rewards do
        local reward = Rewards[i]
        if reward.day == day then
            FoundReward = reward
            break
        end
    end

    if not FoundReward then return end
    if FoundReward.claimed or not FoundReward.canOpen then return end

    AddItem(src, FoundReward.item, FoundReward.count)
    AddDayOpened(identifier, day)

    if Config.Logs.Enabled then
        -- Discord log
        local fields = {}
        fields[#fields+1] = { name = Config.Locales['player'], value = ('%s (ID: %s)'):format(GetPlayerName(src), src), inline = true }
        fields[#fields+1] = { name = Config.Locales['reward'], value = ('%sx %s'):format(FoundReward.count, FoundReward.label), inline = true }
        fields[#fields+1] = { name = Config.Locales['day'], value = day, inline = true }
        fields[#fields+1] = { name = Config.Locales['player_identifiers'], value = FormatIdentifiers(src), inline = true }

        LogToDiscord({
            title = Config.Locales['daily_reward_claimed'],
            description = ('%s %s'):format(GetPlayerName(src), Config.Locales['daily_reward_claimed_desc']),
            fields = fields,
        })
    end
end)

-- Cron Expression for the 1st of every month to reset the daily rewards
local cron = '0 0 1 * *'
lib.cron.new(cron, function()
    WipeDailyRewards()
end)

RegisterNetEvent('trase_shop:server:purchaseItem', function(item)
    local src = source
    local identifier = GetIdentifier(src)

    if not item.index then return end
    local itemData = Config.Shop.Items[item.index]
    if not itemData then return end

    local coins = CountCoins(src)
    if tonumber(coins) < tonumber(itemData.price) then
        return TriggerClientEvent('trase_shop:client:notify', src, {
            type = 'error',
            title = Config.Locales['error'],
            description = Config.Locales['not_enough_coins']
        })
    end

    RemoveCoins(src, itemData.price)

    TriggerClientEvent('trase_shop:client:notify', src, {
        type = 'success',
        title = Config.Locales['success'],
        description = Config.Locales['item_purchased']
    })

    for addItem, amount in pairs(itemData.rewards) do
        print(addItem, amount)
        AddItem(src, addItem, amount)
    end

    -- Discord log
    if Config.Logs.Enabled then
        local fields = {}
        fields[#fields+1] = { name = Config.Locales['player'], value = ('%s (ID: %s)'):format(GetPlayerName(src), src), inline = true }
        fields[#fields+1] = { name = Config.Locales['package'], value = itemData.label, inline = true }
        fields[#fields+1] = { name = Config.Locales['price'], value = itemData.price, inline = true }
        fields[#fields+1] = { name = Config.Locales['player_identifiers'], value = FormatIdentifiers(src), inline = true }

        LogToDiscord({
            title = Config.Locales['package_purchased'],
            description = ('%s %s %s'):format(GetPlayerName(src), Config.Locales['package_purchased_desc'], itemData.label),
            fields = fields,
        })
    end
end)

if Config.AddCommand.Enabled then
    RegisterCommand(Config.AddCommand.Command, function(src, args)
        if not HasPermissions(src) then return end

        if not args[1] or not args[2] then return end

        local target = tonumber(args[1])
        local amount = tonumber(args[2])

        if not target or not amount then return end

        if not GetPlayerName(target) then return end
        AddCoins(target, tonumber(amount))

        TriggerClientEvent('trase_shop:client:notify', src, {
            type = 'success',
            title = Config.Locales['success'],
            description = Config.Locales['coins_added']:format(amount, GetPlayerName(target))
        })

        TriggerClientEvent('trase_shop:client:notify', target, {
            type = 'success',
            title = Config.Locales['success'],
            description = Config.Locales['coins_received']:format(amount)
        })
    end, true)
end

if Config.PlayTime.Enabled then
    local CachedPlaytime = {}

    AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
        local src = source
        CachedPlaytime[tonumber(src)] = os.time()
    end)

    AddEventHandler('playerDropped', function(reason)
        local src = source
        local playtime = os.time() - CachedPlaytime[tonumber(src)]
        UpdatePlaytime(src, playtime) -- Call the function to update playtime
    end)

    -- On resource start, update the playtime for all players
    CreateThread(function()
        Wait(1000)
        local players = GetPlayers()
        for i = 1, #players do
            local src = players[i]
            CachedPlaytime[tonumber(src)] = os.time()
        end
    end)

    RegisterCommand('saveallplaytime', function(user)
        if user ~= 0 then return end
        local players = GetPlayers()
        for i = 1, #players do
            local src = players[i]
            local playtime = os.time() - CachedPlaytime[tonumber(src)]
            UpdatePlaytime(src, playtime) -- Call the function to update playtime
        end
        print(Config.Locales['playtime_saved'])
    end, false)

    RegisterCommand(Config.PlayTime.Command, function(src)
        local playtime = GetPlaytime(src)

        if not playtime then
            return TriggerClientEvent('trase_shop:client:notify', src, {
                type = 'error',
                title = Config.Locales['playtime_error_title'],
                description = Config.Locales['playtime_error_description']
            })
        end

        -- Notification
        TriggerClientEvent('trase_shop:client:notify', src, {
            type = 'info',
            title = Config.Locales['playtime_notification_title'],
            description = Config.Locales['playtime_notification_description']:format(playtime.days, playtime.hours, playtime.minutes, playtime.seconds)
        })
    end, false)
end
