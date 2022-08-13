RegisterNetEvent('ejcspp:test')
AddEventHandler('ejcspp:test', function(args,source)
	print("player: ",source)
	for index, value in ipairs(args) do
		print(index, ". ", value)
	end
	exports.ox_inventory:AddItem(source, args[1], args[2])
end)