local characterName = "Unknown"
local activeBlips = {}

RegisterNetEvent("updateCharacterNameClient")
AddEventHandler("updateCharacterNameClient", function(newName)
    characterName = newName
end)

-- Create a 911 blip
RegisterNetEvent('onduty:createBlip')
AddEventHandler('onduty:createBlip', function(coords, callId)
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 50.0)
    SetBlipColour(blip, 5)
    SetBlipAlpha(blip, 128)

    local markerBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(markerBlip, 188)
    SetBlipColour(markerBlip, 5)
    SetBlipAsShortRange(markerBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("911 Call")
    EndTextCommandSetBlipName(markerBlip)

    activeBlips[callId] = {radiusBlip = blip, markerBlip = markerBlip}
end)

RegisterNetEvent('onduty:clearBlip')
AddEventHandler('onduty:clearBlip', function(callId)
    if activeBlips[callId] then
        RemoveBlip(activeBlips[callId].radiusBlip)
        RemoveBlip(activeBlips[callId].markerBlip)
        activeBlips[callId] = nil
    end
end)

RegisterNetEvent('onduty:playSound')
AddEventHandler('onduty:playSound', function()
    PlaySoundFrontend(-1, "new_911", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
end)

-- 911 Command
RegisterCommand('911', function(source, args)
    local text = table.concat(args, " ")
    if string.len(text) == 0 then 
        TriggerEvent('cc-rpchat:addMessage', source, '#e74c3c', 'fa-solid fa-phone', 'SYSTEM', 'Please provide a message with your 911 call.')
        return 
    end
    
    -- Send to server (notification will be handled server-side)
    TriggerServerEvent('911:serverCall', text)
end, false)