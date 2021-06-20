ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--itemin tyypit on ase tai itemi

local serverii = {
	Pistoolikauppa = {
		likanen = false,
		Itemit = {
			{itemi  = 'WEAPON_PISTOL50', hinta = 35000, texti = 'Pistooli 50', tyyppi = 'ase'},
			{itemi  = 'WEAPON_PISTOL', hinta = 28000, texti = 'Pistooli', tyyppi = 'ase'}
		},
		Paikat = {
			vector3(902.25885009766,-1672.7186279297,47.357490539551)
		}
	},
	Puukkokauppa = {
		likanen = true,
		Itemit = {
			{itemi  = 'WEAPON_KNIFE', hinta = 200,  texti = 'Puukko', tyyppi = 'ase'}
		},
		Paikat = {
			vector3(510.60913085938,-1951.3472900391,24.98509979248)
		}
	},
    itemikauppa2 = { --Esimerkki kuinka lisätä kauppa
		likanen = false,
		Itemit = {
			{itemi  = 'luotiliivi', hinta = 200,  texti = 'luotiliivi', tyyppi = 'itemi'}
            --{itemi  = 'luotiliivi2', hinta = 200,  texti = 'luotiliivi2', tyyppi = 'itemi'}
		},
		Paikat = {
			--vector3(17.892114639282,-1111.5885009766,29.797023773193)
		}
	}
}


RegisterServerEvent('blackweashop:serveristaclienttii')
AddEventHandler("blackweashop:serveristaclienttii", function()
  TriggerClientEvent('blackweashop:serveristaclienttiiclient', source, serverii)
end)


RegisterServerEvent('blackweashop:osta_ase')
AddEventHandler("blackweashop:osta_ase", function(aseennimi, hinta, likaisella)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.hasWeapon(aseennimi) then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sinulla on jo tämä ase!'})
	else
		if likaisella then
			if xPlayer.getAccount('black_money').money >= hinta then
				xPlayer.removeAccountMoney('black_money', hinta)
				xPlayer.addWeapon(aseennimi, 100)
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'success', text = 'Maksu suoritettu: $'..hinta})
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sinulla ei ole riittävästi likaista!'})
			end
		else
			if xPlayer.getMoney() >= hinta then
				xPlayer.removeMoney(price)
				xPlayer.addWeapon(aseennimi, 100)
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'success', text = 'Maksu suoritettu: $'..hinta})
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'error', text = 'Sinulla ei ole riittävästi likaista'})
			end
		end
	end
end)

RegisterServerEvent('blackweashop:osta_itemi')
AddEventHandler("blackweashop:osta_itemi", function(iteminnimi, hinta, likaisella)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if likaisella then
		if xPlayer.getAccount('black_money').money >= hinta then
			xPlayer.removeAccountMoney('black_money', hinta)
			xPlayer.addInventoryItem(iteminnimi, 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'success', text = 'Maksu suoritettu: $'..hinta})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'error', text = 'Sinulla ei ole riittävästi likaista'})
		end
	else
		if xPlayer.getMoney() >= hinta then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(iteminnimi, 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'success', text = 'Maksu suoritettu: $'..hinta})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer, { type = 'error', text = 'Sinulla ei ole riittävästi rahaa'})
		end
	end
end)
