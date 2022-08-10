-- if Config.BlackMarketBlip then 
--     CreateThread(function()
--         for k, v in 
 
--     end)
-- end


function CheckForKeypress(action)
    CreateThread(function()
        
        if action == 'Enter' or action == 'Exit' then

            while IsPedInAnyVehicle(player) == false and inBlackMarketZone do
                if IsControlJustReleased(0, 38) then 
                    if action == 'Enter' then
                        BlackMarket(action) 
                        return
                    elseif action == 'Exit' then 
                        BlackMarket(action) 
                        return
                    end
                end
                Wait(0)
            end
            exports['qb-core']:HideText()

        end
    end)
end


function HasItem(items, amount)
    return QBCore.Functions.HasItem(items, amount)
end


function BlackMarket(action)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
	if action == 'Enter' then
        DoScreenFadeOut(100)
        Wait(100)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
		SetEntityCoords(player, vector3(178.9588, -1000.091, -98.99999), false, false, false, false)
        SetEntityHeading(player, 180.0)
        FreezeEntityPosition(player, true)

        while HasCollisionLoadedAroundEntity(player) == false do 
            RequestCollisionAtCoord(coords)
            RequestAdditionalCollisionAtCoord(coords)
            Wait(1)
        end
    
        while IsEntityWaitingForWorldCollision(player) == true do 
            RequestCollisionAtCoord(coords)
            RequestAdditionalCollisionAtCoord(coords)
            Wait(1)
        end
    
        FreezeEntityPosition(player, false)
        Wait(100)
        DoScreenFadeIn(100)

	elseif action == 'Exit' then
        DoScreenFadeOut(100)
        Wait(100)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
		SetEntityCoords(player, vector3(-80.80535, -1326.134, 29.26139), false, false, false, false)
        SetEntityHeading(player, 91.0)
        FreezeEntityPosition(player, true)

        while HasCollisionLoadedAroundEntity(player) == false do 
            RequestCollisionAtCoord(coords)
            RequestAdditionalCollisionAtCoord(coords)
            Wait(1)
        end
    
        while IsEntityWaitingForWorldCollision(player) == true do 
            RequestCollisionAtCoord(coords)
            RequestAdditionalCollisionAtCoord(coords)
            Wait(1)
        end

        FreezeEntityPosition(player, false)
        Wait(100)
        DoScreenFadeIn(100)
	end
end


function CreateBlip(coords)
	DeleteBlip()
    
	blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 440)
    SetBlipScale(blip, 1.25)
    SetBlipHighDetail(blip, true)
    SetBlipAsShortRange(blip, false)
    SetBlipColour(blip, 26)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Trade-off")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
end


function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end


function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end


function CreateMarker(coords)
    DrawMarker(2, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 12, 106, 201, 155, false, false, false, 1, false, false, false)
end


function TradeItems(item)
    TriggerServerEvent('daiwik-blackmarket:Server:Trade', item)
    Wait(1000)
    DeleteBlip()
end


function SetupInteraction(action)
    local text = '[E] '..action
    exports['qb-core']:DrawText(text, 'left')
    CheckForKeypress(action)
end