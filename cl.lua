ESX = nil
local clienttiii = {}
local config   = {}

config = {
	  distance = 1.2,
	  menunpos = 'bottom-right', -- Menu POS
	  onlynight = false, --Vain öisin auki (true = kyllä, false= ei)
}


RegisterNetEvent('blackweashop:serveristaclienttiiclient')
AddEventHandler('blackweashop:serveristaclienttiiclient', function(serverii)
  clienttiii = serverii
end)

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	end

	TriggerServerEvent('blackweashop:serveristaclienttii')
	Wait(2000)

    while true do
		local playerposition = GetEntityCoords(PlayerPedId())
        Wait(6)
		for k,v in pairs(clienttiii) do
			for i=1, #v.Locations, 1 do
				local shops = v.Locations[i]
				if #(playerposition - shops) < config.distance then
					text3d(shops.x,shops.y,shops.z,"Paina ~g~[~w~E~g~]~w~ ostaaksesi jotain kaupasta")
					if IsControlJustReleased(0, 38) then
						if config.onlynight then
							local hours = GetClockHours()
							if hours < 6 then
							    shopmenu(k)
							else
								 exports['mythic_notify']:DoHudText('inform', 'Kauppa on auki vain öisin!')
						    end
						else
							shopmenu(k)
						end
					end
				end
			end
		end
	end

end)


--Functiot
function text3d(x,y,z, text)
	local onScreen, x, y = World3dToScreen2d(x, y, z)
	if onScreen and text and x and y and z  then
		SetTextScale(0.35, 0.35)
		SetTextOutline()
		SetTextFont(4)
		SetTextEntry('STRING')
		SetTextCentre(1)
		SetTextColour(255, 255, 255, 215)
		AddTextComponentString(text)
		DrawText(x, y)
		local factor = (string.len(text)) / 410
		DrawRect(x, y+0.012, 0.015+ factor, 0.03, 18, 18, 18, 70)
	end
end

function shopmenu(shopName)
	local elements = {}
	local shop = clienttiii[shopName]
	for i=1, #shop.items, 1 do
		local item = shop.items[i]
		local price = item.price
		table.insert(elements, {
			label = item.label..' <span style="color:green;">$'..price..'</span>',
			price = price,
			item = item.name,
			itemType = item.type,
			blackMoney = shop.blackMoney
		})
	end

	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'shopmenu', {
		title    = shopName,
		align = config.menunpos,
		elements = elements
  	},
  	function(data, menu) 
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = "Oletko varma?",
			align    = config.menunpos,
			elements = {
				{label = 'Ei',  value = false},
				{label = 'Kyllä', value = true}
			}
		}, function(data2, menu2)
			if data2.current.value then
				if data.current.itemType == 'weapon' then
					TriggerServerEvent("blackweashop:buy_weapon", data.current.item, data.current.price, data.current.blackMoney)
				else
					TriggerServerEvent("blackweashop:buy_item", data.current.item, data.current.price, data.current.blackMoney)
				end
			end
			ESX.UI.Menu.CloseAll()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end
