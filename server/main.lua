ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(30)
	end
	ESX.RegisterServerCallback('ejcspp:getPlayerInventory', function(PlayerID, cb)
		print("Getting Player: "..PlayerID.." Inventory")
		local xPlayer = ESX.GetPlayerFromId(PlayerID)
		print (xPlayer)
		local inv = xPlayer.getInventory()
		print(inv)
		cb(inv)
	end)
end)


RegisterNetEvent('ejcspp:test')
AddEventHandler('ejcspp:test', function(args,source)
	print("player: ",source)
	for index, value in ipairs(args) do
		print(index, ". ", value)
	end
	exports.ox_inventory:AddItem(source, args[1], args[2])
end)


RegisterNetEvent('ejcspp:pickPlayerPocket')
AddEventHandler('ejcspp:pickPlayerPocket', function(args,source)
	print("player: ",source)
	for index, value in ipairs(args) do
		print(index, ". ", value)
	end
	exports.ox_inventory:AddItem(source, args[1], args[2])
	print("Stole from PlayerID: " + args[3])
	exports.ox_inventory:RemoveItem(args[3], args[1], args[2])
end)

