function GetVIPState()
    return LocalPlayer.state.vip or LocalPlayer.state['vip+']
end

-- @param bool boolean
function OnStoreOpen(bool)
    -- Things to do when the store UI opens
    DisplayRadar(not bool)
    if GetResourceState('esx_hud') == 'started' then
        TriggerEvent("esx_hud:HudToggle", not bool)
    end
end

-- Custom Notifications here
RegisterNetEvent('trase_shop:client:notify', function(data)
    data.position = data.position or 'right'
    lib.notify(data)
end)

if Config.PlayTime.Enabled and Config.PlayTime.Reward >= 1 then
    CreateThread(function()
        while true do
            Wait(Config.PlayTime.Duration * 60000)
            TriggerServerEvent('trase_shop:server:rewardPlaytime')
        end
    end)
end