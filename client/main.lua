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

	if num > 10 then
		success = false
	else
		success = true
	end
	return success
end

local function array_map(array)
	local map = {}
	for _, item in ipairs(array) do
	  map[item] = true
	end
	return map
  end

function calcPercent(value, percent)
    value = tonumber(value)
    percent = tonumber(percent)
    if value == nil or percent == nil then  return false end
    return math.ceil(value * (percent/100))
end

--NPC PickPocket
local function pickNPCPocket()
	print("TEST SUCCEEDED")
	Citizen.CreateThread(function ()
		if lib.progressBar({
			duration = 3000,
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
	Citizen.Wait(math.random(1000,3000))
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
		TriggerServerEvent('ejcspp:npcPocket', args, playerID)
		
	end
end)


-- Player PickPocket
local function pickPlayerPocket(entity)
	print("TEST SUCCEEDED")
	PlayerInv = {}
	local bi_map = array_map(Config.BlacklistedItems)
	local itemNames = {}

	for item, data in pairs(exports.ox_inventory:Items()) do 
		itemNames[item] = data.label
	end
	if IsPedAPlayer(entity) then 
		
		
		Citizen.CreateThread(function ()
			if lib.progressBar({
				duration = 2000,
				label = 'Picking Pocket',
				useWhileDead = false,
				canCancel = true,
			}) then
				PlayerID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
				PlayerData = GetPlayerFromServerId(PlayerID)
				print("Searching: "..PlayerID)
				ESX.TriggerServerCallback('ejcspp:getPlayerInventory',function(PlayerID, cb)
					print(inv)
					print(PlayerID)
					playerInv = PlayerID
					print(playerInv)
				
				for k,v in pairs(playerInv) do 
					print(v.name)
					if bi_map[v.name] then 
						print(v.name.." is blacklisted")
					else
						table.insert(PlayerInv, {label=itemNames[v.name], item=v.name, count=v.count})
					end
				end
				randomItemID = math.random(1, tableLength(PlayerInv))
				randomItem = PlayerInv[randomItemID]
				maxItemCount = randomItem.count
				if randomItem.item == 'money' then
					if Config.MaxMoneyType == '%' then
						maxItemCount = calcPercent(randomItem.count, Config.MaxMoney)
					elseif Config.MaxMoneyType == '$' then
						if randomItem.count > Config.MaxMoney then
							maxItemCount = Config.MaxMoney
						else
							maxItemCount = randomItem.count
						end
					end
				else
					maxItemCount = randomItem.count
				end
				print(maxItemCount)
				randomItemCount = math.random(1, maxItemCount)

				lib.setMenuOptions('PlayerpickPocket_Menu', {label = 'Take '..randomItem.label, args={randomItem.item, randomItemCount, PlayerID}}, 2)
				lib.showMenu('PlayerpickPocket_Menu')
				end)
				
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
	-- for k,v in pairs(entity) do print("k:"..k.." V:"..v) end
	
	
end

exports.qtarget:Player({
	options = {
		{
			event = "",
			icon = "fas fa-box-circle-check",
			label = "Pick Pocket",
			action = pickPlayerPocket,
			num = 1
			
		},
	},
	distance = 2
})
lib.registerMenu({
    id = 'PlayerpickPocket_Menu',
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
		TriggerServerEvent('ejcspp:pickPlayerPocket', args, playerID)
		
	end
end)