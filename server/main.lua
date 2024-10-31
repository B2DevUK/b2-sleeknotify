-- server/main.lua
-- Function to send notification to specific player
function SendNotificationToPlayer(source, data)
    TriggerClientEvent('notifications:create', source, data)
end

-- Function to send notification to all players
function SendNotificationToAll(data)
    TriggerClientEvent('notifications:create', -1, data)
end

-- Export the functions
exports('SendNotificationToPlayer', SendNotificationToPlayer)
exports('SendNotificationToAll', SendNotificationToAll)

-- Example server event that triggers a notification
RegisterNetEvent('notifications:server:create')
AddEventHandler('notifications:server:create', function(target, data)
    if target then
        SendNotificationToPlayer(target, data)
    else
        SendNotificationToAll(data)
    end
end)