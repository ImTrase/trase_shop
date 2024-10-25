local function SendReactMessage(action, data)
	SendNUIMessage({ action = action, data = data })
end

local function toggleNuiFrame(shouldShow)
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage('setVisible', shouldShow)
	OnStoreOpen(shouldShow)
	-- Blur
	if shouldShow then
		TriggerScreenblurFadeIn(500)
	else
		TriggerScreenblurFadeOut(500)
	end
end

RegisterNUICallback('hideFrame', function(_, cb)
	toggleNuiFrame(false)
	cb({})
end)

local cachedData, cachedTopPlayers, cachedRewards = nil, nil, nil

local function setData(data, TOPPlayers, rewards)
	Config.UI.ResourceName = GetCurrentResourceName()
	data.isVIP = Config.DailyRewardsVIP == false and true or GetVIPState()
	Config.UI.Locale = Config.Locales
	Config.UI.StoreURL = Config.StoreURL
	SendReactMessage('setConfig', Config.UI)
	SendReactMessage('setPlayerData', data)
	SendReactMessage('setTopPlayers', TOPPlayers)
	SendReactMessage('setDailyRewards', rewards)
	SendReactMessage('setCategories', Config.Shop.Categories)
	SendReactMessage('setItems', Config.Shop.Items)
	cachedData = data
	cachedTopPlayers = TOPPlayers
	cachedRewards = rewards
end

RegisterNUICallback('setData', function()
	if cachedData and cachedTopPlayers and cachedRewards then
		setData(cachedData, cachedTopPlayers, cachedRewards)
	end
end)

RegisterNetEvent('trase_shop:client:open', function(data, TOPPlayers, rewards)
	setData(data, TOPPlayers, rewards)
	toggleNuiFrame(true)
end)

RegisterNUICallback('openDailyReward', function(day)
	TriggerServerEvent('trase_shop:server:rewards:open', day)
end)

RegisterNuiCallback('purchaseItem', function(item)
	toggleNuiFrame(false)
	TriggerServerEvent('trase_shop:server:purchaseItem', item)
end)

if Config.Open.Key then
	lib.addKeybind({
		name = 'openShop',
		description = ('press %s to open shop'):format(Config.Open.Key),
		defaultKey = Config.Open.Key,
		onPressed = function(self)
			ExecuteCommand('shop')
		end
	})
end