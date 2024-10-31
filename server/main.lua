function SendNotificationToPlayer(source, data)
    TriggerClientEvent('notifications:create', source, data)
end

function SendNotificationToAll(data)
    TriggerClientEvent('notifications:create', -1, data)
end

exports('SendNotificationToPlayer', SendNotificationToPlayer)
exports('SendNotificationToAll', SendNotificationToAll)

RegisterNetEvent('notifications:server:create')
AddEventHandler('notifications:server:create', function(target, data)
    if target then
        SendNotificationToPlayer(target, data)
    else
        SendNotificationToAll(data)
    end
end)