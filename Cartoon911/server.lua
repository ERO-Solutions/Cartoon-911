local characterNames = {}
local onDutyPlayers = {}
local active911Calls = {}

function GetRPName(source)
    return characterNames[source] or GetPlayerName(source)
end

-- 911 Call Handling
RegisterNetEvent('911:serverCall')
AddEventHandler('911:serverCall', function(text)
    local source = source
    local message = '' .. GetRPName(source) .. ': ' .. text
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local callId = #active911Calls + 1
    active911Calls[callId] = playerCoords

    -- Send confirmation to caller
    TriggerClientEvent('cc-rpchat:addMessage', source, '#2ecc71', 'fa-solid fa-phone', 'SYSTEM', '911 Successfully Sent')

    -- Alert on-duty players
    for playerId, _ in pairs(onDutyPlayers) do
        TriggerClientEvent('cc-rpchat:addMessage', tonumber(playerId), '#e74c3c', 'fa-solid fa-phone-volume', '911 Dispatch', message)
        TriggerClientEvent('onduty:createBlip', tonumber(playerId), playerCoords, callId)
        TriggerClientEvent('onduty:playSound', tonumber(playerId))
    end
end)

-- /onduty command with cc-chat messages
RegisterCommand('onduty', function(source)
    local playerId = tostring(source)
    if onDutyPlayers[playerId] then
        onDutyPlayers[playerId] = nil
        TriggerClientEvent('cc-rpchat:addMessage', source, '#e74c3c', 'fa-solid fa-person-military-pointing', 'SYSTEM', 'You are now off duty.')
    else
        onDutyPlayers[playerId] = true
        TriggerClientEvent('cc-rpchat:addMessage', source, '#2ecc71', 'fa-solid fa-person-military-pointing', 'SYSTEM', 'You are now on duty.')
    end
end, false)

-- /name command
RegisterCommand("name", function(source, args)
    local newName = table.concat(args, " ")
    if newName == "" then return end
    characterNames[source] = newName
    TriggerClientEvent("updateCharacterNameClient", source, newName)
    TriggerClientEvent('cc-rpchat:addMessage', source, '#2ecc71', 'fa-solid fa-user-pen', 'SYSTEM', 'Your RP name has been set to: '..newName)
end, false)

-- /clr911 command
RegisterCommand('clr911', function(source)
    local playerId = tostring(source)
    if not onDutyPlayers[playerId] then
        TriggerClientEvent('cc-rpchat:addMessage', source, '#e74c3c', 'fa-solid fa-person-military-pointing', 'SYSTEM', 'You must be on duty to clear 911 calls.')
        return
    end
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local nearestCallId, nearestDistance = nil, nil
    for callId, callCoords in pairs(active911Calls) do
        local distance = #(playerCoords - callCoords)
        if not nearestDistance or distance < nearestDistance then
            nearestCallId = callId
            nearestDistance = distance
        end
    end
    if nearestCallId then
        active911Calls[nearestCallId] = nil
        TriggerClientEvent('onduty:clearBlip', -1, nearestCallId)
        TriggerClientEvent('cc-rpchat:addMessage', source, '#2ecc71', 'fa-solid fa-person-military-pointing', 'SYSTEM', 'You have cleared the nearest 911 call.')
    else
        TriggerClientEvent('cc-rpchat:addMessage', source, '#e74c3c', 'fa-solid fa-person-military-pointing', 'SYSTEM', 'No active 911 calls found.')
    end
end, false)

-- RP name sync event
RegisterServerEvent("updateCharacterName")
AddEventHandler("updateCharacterName", function(name)
    characterNames[source] = name
    TriggerClientEvent("updateCharacterNameClient", source, name)
end)