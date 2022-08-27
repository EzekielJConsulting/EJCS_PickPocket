ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(30)
	end
	ESX.RegisterServerCallback('ejcspp:getPlayerInventory', function(source, cb, PlayerID)
		local xPlayer = ESX.GetPlayerFromId(PlayerID)
		print (xPlayer)
		local inv = xPlayer.getInventory()
		if tableLength(inv) == 0 then
			inv = "empty"
		end
		-- for k,v in pairs(inv) do 
		-- 	print("K: "..k.."V: "..v)
		-- end
		cb(inv)

		-- print (cb)
		-- return inv
	end)
end)

function tableLength (T)
	local count = 0
	for _ in ipairs(T) do count = count + 1 end
	return count
end


RegisterNetEvent('ejcspp:npcPocket')
AddEventHandler('ejcspp:npcPocket', function(args,source)
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
	print("Stole from PlayerID: "..tostring(args[3]))
	exports.ox_inventory:RemoveItem(args[3], args[1], args[2])
end)

