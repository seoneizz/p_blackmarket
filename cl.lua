ESX = nil
local cData = {}
local config = {
	  distance = 1.2,
	  menunpos = 'bottom-right', -- ESX menu pos
	  onlynight = false, --Vain öisin auki (true = kyllä, false= ei)
}


RegisterNetEvent('p_shop:sendDataToClient', function(data)
  cData = data
end)

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	end

	TriggerServerEvent('p_shop:getDataToClient')
	Wait(2000)

    while true do
        Wait(5)
		local playerPed = PlayerPedId()
		local inVehicle = IsPedInAnyVehicle(playerPed, false)
		local playerPosition = GetEntityCoords(playerPed)

		if not inVehicle then
			for shopName, shopData in pairs(cData) do
				for i=1, #shopData.locations, 1 do
					local shopLocation = shopData.locations[i]
					if #(playerPosition - shopLocation) < config.distance then
						text3d(shops, "Paina ~g~[~w~E~g~]~w~ ostaaksesi jotain kaupasta")
	
						if IsControlJustReleased(0, 38) then
							if not config.onlynight or GetClockHours() =< 6 then 
								return shopmenu(shopName)
							end
	
							exports['mythic_notify']:DoHudText('inform', 'Kauppa on auki vain öisin!')
						end
					else
						Wait(600)
					end
				end
			end
		else
			Wait(600)
		end
	end
end)


--Functiot
function text3d(pos, text)
	if not pos or not text then return end

	local onScreen, x, y = World3dToScreen2d(pos.x, pos.y, pos.z)
	local factor = (string.len(text)) / 410
	SetTextScale(0.35, 0.35)
	SetTextOutline()
	SetTextFont(4)
	SetTextEntry('STRING')
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(x, y)
	DrawRect(x, y + 0.012, 0.015 + factor, 0.03, 18, 18, 18, 70)
end

function shopmenu(shopName)
	local elements = {}
	local shop = cData[shopName]

	for i=1, #shop.items, 1 do
		local item = shop.items[i]
		local price = item.price
		table.insert(elements, {
			label = item.label..' <span style="color:green;">$'..price..'</span>',
			price = price,
			item = item.name,
		})
	end

	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'shopmenu', {
		title    = shopName,
		align = config.menunpos,
		elements = elements
  	},
  	function(data, menu) 
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = "Are you sure?",
			align    = config.menunpos,
			elements = {
				{label = 'No',  value = false},
				{label = 'Yes', value = true}
			}
		}, function(data2, menu2)
			if data2.current.value then
				TriggerServerEvent("p_shop:buy", data.current.item, data.current.price, shop.useBlackMoney)
			end
			ESX.UI.Menu.CloseAll()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end
