-- Server-side notification manager
NotificationManager = {}
NotificationManager.activeNotifications = {}

-- Send notification to a specific player
function NotificationManager.SendToPlayer(playerId, data)
    if not playerId or not data then return false end
    
    -- Generate a unique notification ID
    local notificationId = os.time() .. "_" .. math.random(1000, 9999)
    
    -- Store notification data
    NotificationManager.activeNotifications[notificationId] = {
        playerId = playerId,
        data = data,
        timestamp = os.time()
    }
    
    -- Send to client
    TriggerClientEvent('notifications:create', playerId, data)
    return notificationId
end

-- Send notification to all players
function NotificationManager.SendToAll(data)
    if not data then return false end
    
    local notificationId = os.time() .. "_" .. math.random(1000, 9999)
    
    -- Store notification data
    NotificationManager.activeNotifications[notificationId] = {
        playerId = -1,
        data = data,
        timestamp = os.time()
    }
    
    -- Send to all clients
    TriggerClientEvent('notifications:create', -1, data)
    return notificationId
end

-- Send notification to multiple specific players
function NotificationManager.SendToPlayers(playerIds, data)
    if not playerIds or not data then return false end
    
    local notificationIds = {}
    
    for _, playerId in ipairs(playerIds) do
        local notificationId = NotificationManager.SendToPlayer(playerId, data)
        table.insert(notificationIds, notificationId)
    end
    
    return notificationIds
end

-- Send notification to all players in a specific radius
function NotificationManager.SendToRadius(coords, radius, data)
    if not coords or not radius or not data then return false end
    
    local players = GetPlayers()
    local notifiedPlayers = {}
    
    for _, playerId in ipairs(players) do
        local ped = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(ped)
        
        if #(coords - playerCoords) <= radius then
            NotificationManager.SendToPlayer(playerId, data)
            table.insert(notifiedPlayers, playerId)
        end
    end
    
    return notifiedPlayers
end

-- Register server events
RegisterNetEvent('notifications:server:create')
AddEventHandler('notifications:server:create', function(target, data)
    if target then
        NotificationManager.SendToPlayer(target, data)
    else
        NotificationManager.SendToAll(data)
    end
end)

-- Register exports
exports('SendToPlayer', NotificationManager.SendToPlayer)
exports('SendToAll', NotificationManager.SendToAll)
exports('SendToPlayers', NotificationManager.SendToPlayers)
exports('SendToRadius', NotificationManager.SendToRadius)