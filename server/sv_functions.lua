function HasTradeItems(source, CostItems, amount)
	local Player = QBCore.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v * amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function HasTradeMoney(source, Currency, amount)
    local Player = QBCore.Functions.GetPlayer(source)
	for k, v in pairs(Currency) do
        if k == "Cash" then 
		    if Player.PlayerData.money.cash ~= nil then
		    	if Player.PlayerData.money.cash < (v * amount) then
		    		return false
		    	end
            else
		    	return false
		    end
		elseif k == "Crypto" then 
			if Player.PlayerData.money.crypto ~= nil then
		    	if Player.PlayerData.money.crypto < (v * amount) then
		    		return false
		    	end
            else
		    	return false
		    end
        end
	end
	return true
end


function TakeMoney(source, Currency, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveMoney(Currency, amount)
end


function GiveItem(source, item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
end


function TakeItem(source, item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
end
