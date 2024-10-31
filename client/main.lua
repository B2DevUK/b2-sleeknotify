-- client/main.lua
local activeNotifications = {}

-- Initialize position trackers
for position in pairs(Config.Positions) do
    activeNotifications[position] = nil
end

-- Function to create a new notification
function CreateNotification(data)
    local position = data.position or Config.DefaultPosition
    
    -- If there's already an active notification at this position, queue it
    if activeNotifications[position] then
        -- Wait for the current notification to finish
        Citizen.CreateThread(function()
            while activeNotifications[position] do
                Citizen.Wait(100)
            end
            ProcessNotification(data)
        end)
        return
    end
    
    ProcessNotification(data)
end

-- Function to process the notification
function ProcessNotification(data)
    local position = data.position or Config.DefaultPosition
    local positionData = Config.Positions[position]
    
    if not positionData then
        print("Invalid position specified: " .. tostring(position))
        position = Config.DefaultPosition
        positionData = Config.Positions[position]
    end

    local notification = {
        id = GetGameTimer(), -- Use timestamp as ID
        type = data.type or "info",
        message = data.message,
        time = "Just now",
        duration = data.duration or Config.DefaultDuration,
        position = position,
        align = positionData.align,
        x = positionData.x,
        y = positionData.y
    }

    -- Mark position as occupied
    activeNotifications[position] = notification.id

    -- Play sound if configured
    if Config.Types[notification.type] then
        local soundData = Config.Types[notification.type]
        PlaySoundFrontend(-1, soundData.soundName, soundData.soundRef, true)
    end

    -- Send to NUI
    SendNUIMessage({
        action = "addNotification",
        notification = notification
    })

    -- Set up auto-remove timer
    Citizen.CreateThread(function()
        Citizen.Wait(notification.duration)
        RemoveNotification(notification.id)
    end)
end

-- Function to remove a notification
function RemoveNotification(id)
    -- Find and clear the position this notification was using
    for position, notifId in pairs(activeNotifications) do
        if notifId == id then
            activeNotifications[position] = nil
            break
        end
    end
    
    SendNUIMessage({
        action = "removeNotification",
        id = id
    })
end

-- Export the function
exports('CreateNotification', CreateNotification)

-- Register NUI Callback for when notification is closed from UI
RegisterNUICallback('notificationClosed', function(data, cb)
    RemoveNotification(data.id)
    cb('ok')
end)

-- Example event handler
RegisterNetEvent('b2-sleeknotify:create')
AddEventHandler('b2-sleeknotify:create', function(data)
    CreateNotification(data)
end)

-- Test the notification system with:
RegisterCommand('testnotif', function(source, args, rawCommand)
    local positions = {
        'TOP_LEFT', 'TOP_RIGHT', 'TOP_CENTER',
        'MIDDLE_LEFT', 'MIDDLE_RIGHT', 'MIDDLE_CENTER',
        'BOTTOM_LEFT', 'BOTTOM_RIGHT', 'BOTTOM_CENTER'
    }
    
    local types = {'success', 'error', 'info', 'warning'}
    
    exports['b2-sleeknotify']:CreateNotification({
        type = types[math.random(1, #types)],
        message = 'Test notification ' .. math.random(1, 100),
        position = positions[math.random(1, #positions)],
        duration = 5000
    })
end, false)