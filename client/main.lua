-- RegisterNetEvent('ejcspp:test')
-- AddEventHandler('ejcspp:test', function(data)
-- 	print(data.label, data.num, data.entity)
-- end)
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function tableLength (T)
	local count = 0
	for _ in ipairs(T) do count = count + 1 end
	return count
end

function failureGen()
	num = math.random(10)
	local success

	if num > 5 then
		success = false
	else
		success = true
	end
	return success
end

function notifyPolice()
	local alertCoords = GetEntityCoords(PlayerPedId())
	if Config.AdrenCAD then
		callType = 'Theft'
		description = 'Help! Someone just tried to Pickpocket me!'
		location = alertCoords
		TriggerEvent('911-script:createCall', callType, description, location)
	else
		local notification = {
			title    = 'Theft',
			subject  = '',
			msg      ='Help! Someone just tried to Pickpocket me!'..alertCoords,
			iconType = 1
		}

		TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
	end
end


-- NPC Pickpocket
local function pickNPCPocket()
	print("TEST SUCCEEDED")
	Citizen.CreateThread(function ()
		if lib.progressBar({
			duration = 2000,
			label = 'Picking Pocket',
			useWhileDead = false,
			canCancel = true,
		}) then
			print("ProgressBar Complete")
			amount = tostring(math.random(Config.MaxNPCMoney))
			lib.setMenuOptions('NPCpickPocket_Menu', {label = 'Take Money', args={'money', amount}}, 2)
	
			NPCItemID = math.random(1,tableLength(Config.NPCItems))
			NPCItem = Config.NPCItems[NPCItemID]
			NPCItemCount = tostring(math.random(1, NPCItem.maxCount))
			lib.setMenuOptions('NPCpickPocket_Menu', {label = 'Take '..NPCItem['label'], args={NPCItem.item, NPCItemCount}}, 3)
			lib.showMenu('NPCpickPocket_Menu')
		else print('fuck off quitter') end
	end)
	Citizen.Wait(1000)
	if failureGen() == false then
		lib.cancelProgress()
		notifyPolice()
		exports['okokNotify']:Alert('PickPocket Failed', 'You Failed to Pickpocket. Police have been notified', 10000, 'error')
	else
		exports['okokNotify']:Alert('PickPocket Succeeded', 'You were able to Pickpocket.', 10000, 'success')
	end
	
end

exports.qtarget:Ped({
	options = {
		{
			event = "",
			icon = "fas fa-box-circle-check",
			label = "Pick Pocket",
			action = pickNPCPocket,
			num = 1
			
		},
	},
	distance = 10
})

lib.registerMenu({
    id = 'NPCpickPocket_Menu',
    title = 'PickPocket',
  position = 'top-right',
    onClose = function()
        print('Menu closed')
    end,
    options = {{label = 'Cancel', args='cancel'}}
}, function(selected, scrollIndex, args, label)
	print(label)
	if args == 'cancel' then 
		lib.hideMenu(true)
	else
		xPlayerID = ESX.GetPlayerData().identifier
		playerID = GetPlayerServerId(PlayerId(xPlayerID))
		TriggerServerEvent('ejcspp:test', args, playerID)
		
	end
end)






-- Utils
function getStreetfromCoords(coords)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z);
    local zoneLabel = GetLabelText(zone);
    local hash1, hash2, heading;
    local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    hash1 = GetStreetNameFromHashKey(var1);
    hash2 = GetStreetNameFromHashKey(var2);
    heading = GetEntityHeading(PlayerPedId());
    
    for k, v in pairs(directions) do
        if (math.abs(heading - v) < 22.5) then
            heading = k;
    
            if (heading == 1) then
                heading = 'N';
                break;
            end

            break;
        end
    end

    local street2;
    if (hash2 == '') then
        street2 = zoneLabel;
    else
        street2 = hash2..', '..zoneLabel;
    end

    print("Street: "..hash1)
    print("zone: "..street2)
    print("Direction: "..heading)

    return {street=hash1, zone=street2, direction=heading}
end