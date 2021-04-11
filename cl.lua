ESX = nil
local clienttiii = {}
local config   = {}

config = {
	  etaisyys = 1.2,
	  menunpos = 'bottom-right', -- Menun sijainti
	  vainoisin = false, --Vain öisin auki (true = kyllä, false= ei)
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	TriggerServerEvent('paskanen_kauppa:serveristaclienttii')
end)

RegisterNetEvent('paskanen_kauppa:serveristaclienttiiclient')
AddEventHandler('paskanen_kauppa:serveristaclienttiiclient', function(paikatserveris)
  clienttiii = paikatserveris
end)

function kauppamenu(mikakauppa)
	local elements = {}
	for i=1, #clienttiii[mikakauppa].Itemit, 1 do
		local item = clienttiii[mikakauppa].Itemit[i]
		table.insert(elements, {
			label = item.texti,
			price = item.hinta,
			itemii = item.itemi,
			weaponName = item.itemi,
			mitalaitetaa = item.tyyppi
		})
	end

	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'kauppamenu',
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
			{label = 'EI',  value = 'ei'},
			{label = 'Kyllä', value = 'kylla'}
	}}, function(data2, menu2)
		if data2.current.value == 'kylla' then
			if data.current.mitalaitetaa == 'ase' then
				TriggerServerEvent("paskanen_kauppa:osta_ase", data.current.itemii, data.current.price)
			else
				TriggerServerEvent("paskanen_kauppa:osta_itemi", data.current.itemii, data.current.price)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		for k,v in pairs(clienttiii) do
			for i=1, #v.Paikat, 1 do
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.Paikat[i], true) < config.etaisyys then
					ESX.ShowHelpNotification("Paina ~INPUT_CONTEXT~ ostaaksesi jotain kaupasta")
					if IsControlJustReleased(0, 38) then
						if config.vainoisin then
							if GetClockHours() < 6 then
							    kauppamenu(k)
							else
                                 ESX.ShowNotification("Kauppa on auki vain öisin!")
						    end
						else
							kauppamenu(k)
						end
					end
				end
			end
		end
    end
end)
