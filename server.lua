local QBCore = exports['qb-core']:GetCoreObject()
local Units = {}

QBCore.Functions.CreateUseableItem('gps', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData.job.type == "leo" then
        TriggerClientEvent('cycgps:client:UseGPS', src)
    end
end)

RegisterNetEvent('cycgps:server:execute', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    for k,v in pairs(Config.Jobs) do
        if player.PlayerData.job.name == k then
            if Units[source] == nil then
                TriggerEvent("cycgps:server:connectGPS", source)
            else
                TriggerEvent("cycgps:server:dropGPS", source)
            end
            break
        end
    end
end)

QBCore.Functions.CreateCallback("cycgps:server:getData", function(source, cb)
    for k,v in pairs(Units) do
        if v.ped then
            Units[k].coords = GetEntityCoords(v.ped)
            Units[k].inVehicle = GetVehiclePedIsIn(v.ped, false) ~= 0
        end
    end
    cb(Units)
end)

RegisterServerEvent("cycgps:server:dropGPS")
AddEventHandler("cycgps:server:dropGPS", function(_source)
    local src = _source or source
    -- if Units[src] ~= nil then
    Units[src] = nil
    TriggerClientEvent("cycgps:client:dropGPS", -1, src)
    -- end
end)

RegisterNetEvent("cycgps:server:connectGPS", function(_source)
    local src = _source or source
    local player = QBCore.Functions.GetPlayer(src)
    if QBCore.Functions.HasItem(src, 'gps') then
        Units[_source] = {
            ped = GetPlayerPed(_source),
            job = player.PlayerData.job.name,
            code = player.PlayerData.metadata.callsign .. " | " .. player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
            name = player.PlayerData.charinfo.firstname
        }
        TriggerClientEvent("cycgps:client:connectGPS", src)
    end
end)

AddEventHandler("playerDropped", function(reason)
    TriggerEvent("cycgps:server:dropGPS", source)
end)

RegisterNetEvent('cycgps:server:SetCallSign', function(callsign)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("callsign", callsign)
end)
