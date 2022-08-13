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