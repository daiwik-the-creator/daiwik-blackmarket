RegisterServerEvent('daiwik-blackmarket:Server:SearchReputation')
AddEventHandler('daiwik-blackmarket:Server:SearchReputation', function()
    local src           = source
	local Player        = QBCore.Functions.GetPlayer(src)
    local cid           = Player.PlayerData.citizenid
	local BaseRep	    = 0

	if Player ~= nil then
		MySQL.query('SELECT * FROM daiwik_blackmarket WHERE cid=@cid', {
			['@cid']	= cid,
		}, 
        function(result)
			if result[1] == nil then
				MySQL.insert('INSERT INTO daiwik_blackmarket (cid, rep) VALUES (@cid, @rep)', {
					['@cid']	= cid,
					['@rep']	= BaseRep
				})
			else
				local rep = result[1].rep
				TriggerClientEvent('daiwik-blackmarket:Client:UpdateReputation', src, rep)
			end
		end)
	end
end)


RegisterServerEvent('daiwik-blackmarket:Server:UpdateReputation', function(data)
    local src           = source
	local Player        = QBCore.Functions.GetPlayer(src)
    local cid           = Player.PlayerData.citizenid
	local rep	        = data

	if Player ~= nil then
		MySQL.update("UPDATE daiwik_blackmarket SET rep=@rep WHERE cid=@cid", {
			['@cid'] = cid,
			['@rep'] = rep
		})
	end
end)


RegisterNetEvent('daiwik-blackmarket:Server:Trade', function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(Config.BlackMarket) do

        if item == v.item then
            
            if v.type == "Items" then 

                if HasTradeItems(source, v.costs, 1) then
                    for k, v in pairs(v.costs) do 
                        TakeItem(source, k, v)
                    end
                    GiveItem(source, item, 1)
                    TriggerClientEvent('daiwik-blackmarket:Client:EndTrade', source, true)
                else
                    TriggerClientEvent('QBCore:Notify', source, "You don't have what I asked for.", 'error')
                end

            elseif v.type == "Cash" then 

                if HasTradeMoney(source, v.costs, 1) then 
                    local playerCash = Player.PlayerData.money.cash
                    for k, v in pairs(v.costs) do
                        TakeMoney(source, k, v)
                    end
                    GiveItem(source, item, 1)
                    TriggerClientEvent('daiwik-blackmarket:Client:EndTrade', source, true)
                else
                    TriggerClientEvent('QBCore:Notify', source, "You don't have what I asked for.", 'error')
                end

            elseif v.type == "Crypto" then 

                if HasTradeMoney(source, v.costs, 1) then
                    for k, v in pairs(v.costs) do
                        TakeMoney(source, k, v)
                    end
                    GiveItem(source, item, 1)
                    TriggerClientEvent('daiwik-blackmarket:Client:EndTrade', source, true)
                else
                    TriggerClientEvent('QBCore:Notify', source, "You don't have what I asked for.", 'error')
                end

            end
        end

    end
end)
