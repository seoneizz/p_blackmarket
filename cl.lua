ESX = nil
local clienttiii = {}
local config   = {}

config = {
	  distance = 1.2,
	  menunpos = 'bottom-right', -- Menun sijainti
	  onlynight = false, --Vain öisin auki (true = kyllä, false= ei)
}


RegisterNetEvent('blackweashop:serveristaclienttiiclient')
AddEventHandler('blackweashop:serveristaclienttiiclient', function(paikatserveris)
  clienttiii = paikatserveris
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
		local hours = GetClockHours()
        Wait(6)
		for k,v in pairs(clienttiii) do
			for i=1, #v.Paikat, 1 do
				if GetDistanceBetweenCoords(playerposition, v.Paikat[i], true) < config.distance then
					notif("Paina ~INPUT_CONTEXT~ ostaaksesi jotain kaupasta")
					if IsControlJustReleased(0, 38) then
						if config.onlynight then
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
function notif(text)
    AddTextEntryByHash(0x98237489, text)
    BeginTextCommandDisplayHelp('esxHelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function shopmenu(mikakauppa)
	local elements = {}
	for i=1, #clienttiii[mikakauppa].Itemit, 1 do
		local item = clienttiii[mikakauppa].Itemit[i]
		local price = item.hinta
		table.insert(elements, {
			label = item.texti..' <span style="color:green;">$'..price..'</span>',
			price = price,
			itemii = item.itemi,
			mitalaitetaa = item.tyyppi
		})
	end

	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'shopmenu',
  {
    title    = mikakauppa,
    align = config.menunpos,
    elements = elements
  },
  function(data, menu) 
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
		title    = "Oletko varma?",
		align    = config.menunpos,
		elements = {
			{label = 'Ei',  value = 'ei'},
			{label = 'Kyllä', value = 'kylla'}
	}}, function(data2, menu2)
		if data2.current.value == 'kylla' then
			if data.current.mitalaitetaa == 'ase' then
				TriggerServerEvent("blackweashop:osta_ase", data.current.itemii, data.current.price)
			else
				TriggerServerEvent("blackweashop:osta_itemi", data.current.itemii, data.current.price)
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
