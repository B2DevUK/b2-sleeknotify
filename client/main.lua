local styleSet = false
local activeNotifications = {}

local function CreateNotification(data)
    data.type = data.type or Config.DefaultType
    data.position = data.position or Config.DefaultPosition
    data.duration = data.duration or Config.DefaultDuration
    
    local notification = {
        id = GetGameTimer(),
        type = data.type,
        message = data.message,
        title = data.title,
        position = data.position,
        duration = data.duration
    }
    
    activeNotifications[notification.id] = true
    
    if Config.Sounds[notification.type] then
        local soundData = Config.Sounds[notification.type]
        PlaySoundFrontend(-1, soundData.soundName, soundData.soundRef, true)
    end
    
    if not styleSet then
        SendNUIMessage({
            action = "setStyle",
            config = { style = Config.Style }
        })
        styleSet = true
    end
    
    SendNUIMessage({
        action = "addNotification",
        notification = notification
    })
    
    Citizen.SetTimeout(notification.duration, function()
        if activeNotifications[notification.id] then
            activeNotifications[notification.id] = nil
            SendNUIMessage({
                action = "removeNotification",
                id = notification.id
            })
        end
    end)
    
    return notification.id
end

exports('CreateNotification', CreateNotification)

RegisterNetEvent('notifications:create')
AddEventHandler('notifications:create', function(data)
    CreateNotification(data)
end)