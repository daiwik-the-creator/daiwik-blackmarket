playerReputation = nil
TradeinProgress = false

-- RegisterCommand('checkrep', function() -- Command to check rep.
-- 	print(playerReputation)
-- end)

-- RegisterCommand('rep', function() -- Command to test adding rep.
--     print(PlayerId())
--     TriggerEvent('daiwik-blackmarket:AddReputation', 1) 
-- end)

TriggerServerEvent('daiwik-blackmarket:Server:SearchReputation')

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    player = PlayerPedId()
    PlayerLoaded = true
    TriggerServerEvent('daiwik-blackmarket:Server:SearchReputation')
end)


CreateThread(function()
    for i = 1, #Config.PointofInterest do
        if Config.PointofInterest[i].Name == 'Black Market' then
            if Config.PointofInterest[i].Blip then 
                poi = AddBlipForCoord(Config.PointofInterest[i].Enter)
                SetBlipSprite(poi, 606)
                SetBlipScale(poi, 0.9)
                SetBlipHighDetail(poi, true)
                SetBlipAsShortRange(poi, false)
                SetBlipColour(poi, 26)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Black Market")
                EndTextCommandSetBlipName(poi)
            end
            local BlackMarketEnter = BoxZone:Create(Config.PointofInterest[i].Enter, 1, 1, {
                name="Black Market Enter",
                heading=0,
                --debugPoly=true,
                minZ=26.67,
                maxZ=30.67
            })

            local BlackMarketExit = BoxZone:Create(Config.PointofInterest[i].Exit, 1, 1, {
                name="Black Market Exit",
                heading=0,
                --debugPoly=true,
                minZ=-101.7,
                maxZ=-97.7
            })
              

            BlackMarketEnter:onPlayerInOut(function(isPointInside, _)
                if isPointInside then
                    SetupInteraction('Enter')
                    inBlackMarketZone = true
                    SetEntityLoadCollisionFlag(player, true)
                else
                    inBlackMarketZone = false
                    SetEntityLoadCollisionFlag(player, false)
                end
            end)

            BlackMarketExit:onPlayerInOut(function(isPointInside, _)
                if isPointInside then
                    SetupInteraction('Exit')
                    inBlackMarketZone = true
                    SetEntityLoadCollisionFlag(player, true)
                else
                    inBlackMarketZone = false
                    SetEntityLoadCollisionFlag(player, false)
                end
            end)

        end
    end
end)


RegisterNetEvent('daiwik-blackmarket:Client:UpdateReputation')
AddEventHandler('daiwik-blackmarket:Client:UpdateReputation', function(reputation)
	playerReputation = reputation
end)


RegisterNetEvent('daiwik-blackmarket:AddReputation', function(reputation)
	playerReputation = playerReputation + reputation
	if playerReputation < 0 then
		playerReputation = 0
	elseif playerReputation > 100 then
		playerReputation = 100
	end
	TriggerServerEvent('daiwik-blackmarket:Server:UpdateReputation', playerReputation)
end)


RegisterNetEvent('daiwik-blackmarket:CheckReputation', function()
    TriggerServerEvent('daiwik-blackmarket:Server:SearchReputation')
    Wait(100)
    if playerReputation <= 0 then StreetRank = "Unknown" 
    elseif playerReputation <= 10  then StreetRank = "Newbie"
    elseif playerReputation <= 25  then StreetRank = "Amateur"
    elseif playerReputation <= 50  then StreetRank = "Hustler"
    elseif playerReputation <= 80  then StreetRank = "Well-Known"
    elseif playerReputation <= 100 then StreetRank = "Professional"
    end
    QBCore.Functions.Notify(("Your Street Credit: "..StreetRank.."("..playerReputation..")"), "primary")
end)


CreateThread(function()
    exports['qb-target']:AddCircleZone("name", vector3(172.96, -999.24, -99.0), 0.5, {
      name = "darkweb_laptop",
      --debugPoly = true,
      useZ=true,
    }, {
        options = {
            {
                type    = "client",
                event   = "daiwik-blackmarket:CheckReputation",
                icon    = "fa-solid fa-credit-card",
                label   = "Street Cred",
                job     = "all",
            },
            { 
                type    = "client",
                action  = function()
                    TriggerEvent("daiwik-blackmarket:Client:Shop", 1000)
                end,
                icon    = "fa-solid fa-cart-arrow-down",
                label   = "Dark Web",
                job     = "all",
            },
            { 
                type    = "client",
                action  = function()
                    TriggerEvent("daiwik-blackmarket:Client:EndTrade", false)
                end,
                icon    = "fa-solid fa-xmark",
                label   = "Cancel Ongoing Trades",
                job     = "all",
            },
        },
      distance = 1.0,
    })
end)


RegisterNetEvent('daiwik-blackmarket:Client:Shop', function(_)
    local player = PlayerPedId()

    TaskTurnPedToFaceCoord(player, 172.9303, -999.3983, -97.71661, 1.0)
    Wait(1000)
    TriggerServerEvent('daiwik-blackmarket:Server:SearchReputation')
    LoadAnimDict("mp_fbi_heist")
    TaskPlayAnim(player, 'mp_fbi_heist', 'loop', 3.0, 3.0, -1, 1, 0, false, false, false)
    QBCore.Functions.Progressbar("disconnect_security", "Acessing Darkweb", _, false, true, {
    disableMovement     = true,
    disableCarMovement  = true,
    disableMouse        = false,
    disableCombat       = true,
    }, {}, {}, {}, function() -- Done
    
    StopAnimTask(player, "mp_fbi_heist", "loop", 1.0)
    local header = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            header = "Life could be a Dream."
        }
    }

    for k, v in pairs(Config.BlackMarket) do
        if QBCore.Shared.Items[v.item].label and Config.BlackMarket[k].rep <= playerReputation then
            local item = v.item 
            local costs = v.costs
            local ShopData = {item, costs}

            header[#header+1] = {
                header = QBCore.Shared.Items[v.item].label,
                txt = "Requirements",
                icon = v.icon,
                params = {
                    isServer = false,
                    event = "daiwik-blackmarket:Client:Requirements",
                    args = ShopData
                }
            }
        end
    end
    header[#header+1] = {
        header = "Close (ESC)",
        icon = "fa-solid fa-xmark",
        isMenuHeader = true,
        params = {
            event = "",
        }
    }

    exports['qb-menu']:openMenu(header)

    end, function() -- Cancel
    StopAnimTask(player, "mp_fbi_heist", "loop", 1.0)
    QBCore.Functions.Notify(("Huh?"), "error")
    end)
end)


RegisterNetEvent('daiwik-blackmarket:Client:Requirements', function(data)
    local player = PlayerPedId()

    SelectedItem = nil
    for k, v in pairs(data) do
        while SelectedItem == nil do
            SelectedItem = v
        end
        break
    end

    local header = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            header = "Trade: "..QBCore.Shared.Items[SelectedItem].label
        }
    }

    for k, v in pairs(Config.BlackMarket) do

        if SelectedItem == v.item then
            if v.type == "Items" then
                for k, v in pairs(v.costs) do
                    header[#header+1] = {
                    header = QBCore.Shared.Items[k].label,
                    txt = v.."x "..QBCore.Shared.Items[k].label,
                    disabled = true,
                }
                end
            elseif v.type == "Cash" then
                for k, v in pairs(v.costs) do
                    header[#header+1] = {
                    header = k,
                    txt = Config.CashCurrency.." "..v,
                    disabled = true,
                }
                end
            elseif v.type == "Crypto" then 
                for k, v in pairs(v.costs) do
                    header[#header+1] = {
                    header = k,
                    txt = v.." "..k,
                    disabled = true,
                }
                end
            end
        end
    end

    header[#header+1] = {
        header = "Trade Items",
        icon = "fa-solid fa-cart-arrow-down",
        isMenuHeader = false,
        params = {
            event = "daiwik-blackmarket:Client:Trade",
            args = SelectedItem,
        }
    }

    header[#header+1] = {
        header = "Back",
        icon = "fa-solid fa-angle-left",
        isMenuHeader = false,
        params = {
            event = "daiwik-blackmarket:Client:Shop",
            args = 0,
        }
    }

    exports['qb-menu']:openMenu(header)

end)


RegisterNetEvent('daiwik-blackmarket:Client:Trade', function(data)
    local Player = PlayerPedId()
    if not TradeinProgress then
        QBCore.Functions.Notify(("Waiting for Confirmation."), "primary")
        Wait(math.random(1000, 8000))
        TradeinProgress = true
        QBCore.Functions.Notify(("Trade Located. Check your GPS. Don't forget the stuff!"), "success")

        local Item = data
        TradePos = Config.Locations[math.random(1, #Config.Locations)]

        while TradeinProgress do
            local PlayerPos = GetEntityCoords(Player) 
            TradeOffDist = #(PlayerPos - TradePos)
            if TradeOffDist < 2.0 then
	    		if not IsPedInAnyVehicle(Player) and IsControlJustReleased(0,38) then
                    Hold = nil
                    for k, v in pairs(Config.BlackMarket) do 
                        if Item == v.item then 
                            for k, v in pairs(v.costs) do
                                if Hold ~= true then
                                    Hold = true
                                    TradeItems(Item)
                                end
                            end
                        end
                    end
	    		end

	    	end
            Wait(0)
        end
    else
        QBCore.Functions.Notify(("Finish your current trade first."), "error")
    end
end)


CreateThread(function() -- Blip and Marker Creation
    while true do 
        if TradeinProgress then 
            if DoesBlipExist(blip) == false then 
                CreateBlip(TradePos)
            end
            if TradeOffDist < Config.MarkerDistance then
                CreateMarker(TradePos)
            end
            Wait(0)
        else 
            DeleteBlip()
            Wait(1000)
        end
    end
end)


RegisterNetEvent('daiwik-blackmarket:Client:EndTrade', function(Completed)
    if TradeinProgress then
        TradeinProgress = false
        if Completed then 
            TriggerEvent('blackmarket:AddReputation', 1) -- Incase, you want to add 1 rep at each trade.
            QBCore.Functions.Notify(("Trade Successful."), "success")
        else
            QBCore.Functions.Notify(("Trade Cancelled."), "error")
        end
    else
        QBCore.Functions.Notify(("No Trades to Cancel."), "error")
    end
end)
