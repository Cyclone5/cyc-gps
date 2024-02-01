QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
local retval = false
local GPSActive = false

function CreateBlipThread()
	retval = true
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(Config.UpdateTick)
			if not retval then
				return
			end
            if not QBCore.Functions.HasItem('gps') then
                GPSActive = false
                TriggerServerEvent("cycgps:server:dropGPS")
            end
			QBCore.Functions.TriggerCallback("cycgps:server:getData", function(Units)
				CreateBlips(Units)
			end)
		end
	end)
end

RegisterNetEvent("cycgps:client:connectGPS")
AddEventHandler("cycgps:client:connectGPS", function()
	CreateBlipThread()
end)

RegisterNetEvent("cycgps:client:dropGPS")
AddEventHandler("cycgps:client:dropGPS", function(id)
	if id == GetPlayerServerId(PlayerId()) then
		retval = false
		RemoveExistingBlips()
	end
	if blips[id] then
		RemoveBlip(blips[id])
		blips[id] = nil
	end
end)

function CreateBlips(Units)
	for k,v in pairs(Units) do
		if v ~= nil then
			local blip
			if k ~= GetPlayerServerId(PlayerId()) or Config.ShowYourself then
				if not DoesBlipExist(blips[k]) then
					blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					blips[k] = blip
				else
					SetBlipCoords(blips[k], v.coords.x, v.coords.y, v.coords.z)
				end
				SetBlipSprite(blips[k], (v.inVehicle == true and Config.VehicleBlips) and 225 or Config.Jobs[v.job].sprite)
				SetBlipColour(blips[k], Config.Jobs[v.job].color)
				SetBlipScale(blips[k], ((v.inVehicle == true and Config.VehicleBlips) and 0.6 or Config.Jobs[v.job].scale) or 0.8)
				SetBlipAsShortRange(blips[k], true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.code ~= nil and v.code or Config.Locales["unknown"]..  " | "..v.name)
				EndTextCommandSetBlipName(blips[k])
			end
		end
	end
end

function RemoveExistingBlips()
	for k,v in pairs(blips) do
		if DoesBlipExist(v) then
			RemoveBlip(v)
			blips[k] = nil
		end
	end
end

RegisterNetEvent('cycgps:client:UseGPS', function()
    local player = QBCore.Functions.GetPlayerData()
    PlayerJob = player.job
    if PlayerJob.type == 'leo' and PlayerJob.onduty then
        local newinputs = {}
        if not GPSActive then
            HeaderText = "GPS - "..PlayerJob.name.."<br>🔴 ".. "GPS KAPALI"
            Submittext = "Aktif Et"
            newinputs[#newinputs+1] = { type = 'text', name = 'callsign', text = "", isRequired = true}
        else
            HeaderText = "GPS - "..PlayerJob.name.."<br>🟢 ".. "AKTİF"
            Submittext = "GPS'İ KAPAT"
        end
        local dialog = exports['qb-input']:ShowInput({ header = HeaderText, submitText = Submittext, inputs = newinputs })
        if dialog then
            if GPSActive then
                GPSActive = false
            else
                GPSActive = true
                TriggerServerEvent('cycgps:server:SetCallSign', dialog.callsign)
            end
            TriggerServerEvent('cycgps:server:execute')
        end
    else
        QBCore.Functions.Notify("Görevde değilsin.", 'error', 4500)
    end
end)
