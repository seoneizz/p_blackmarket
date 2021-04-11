ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--itemin tyypit on ase tai itemi

local serverii = {
	asekauppa = {
		Itemit = {
			{itemi  = 'WEAPON_KNIFE', hinta = 1000, texti = 'Puukko', tyyppi = 'ase'},
			{itemi  = 'WEAPON_PISTOL', hinta = 3000, texti = 'Pistooli', tyyppi = 'ase'}
		},
		Paikat = {
			vector3(21.596227645874,-1106.5979003906,29.797023773193)
		}
	},
	itemikauppa = {
		Itemit = {
			{itemi  = 'luotiliivi', hinta = 200,  texti = 'luotiliivi', tyyppi = 'itemi'}
		},
		Paikat = {
			vector3(17.892114639282,-1111.5885009766,29.797023773193)
		}
	},
         itemikauppa2 = { --Esimerkki kuinka lisätä kauppa
		Itemit = {
			--	{itemi  = 'luotiliivi', hinta = 200,  texti = 'luotiliivi', tyyppi = 'itemi'}
                        --{itemi  = 'luotiliivi2', hinta = 200,  texti = 'luotiliivi2', tyyppi = 'itemi'}
		},
		Paikat = {
			--vector3(17.892114639282,-1111.5885009766,29.797023773193)
		}
	}
}


RegisterServerEvent('paskanen_kauppa:serveristaclienttii')
AddEventHandler("paskanen_kauppa:serveristaclienttii", function()
  TriggerClientEvent('paskanen_kauppa:serveristaclienttiiclient', source, serverii)
end)


RegisterServerEvent('paskanen_kauppa:osta_ase')
AddEventHandler("paskanen_kauppa:osta_ase", function(aseennimi, hinta)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.hasWeapon(aseennimi) then
		TriggerClientEvent('esx:showNotification', source, '~r~Sinulla on jo tämä ase')
	else
		if xPlayer.getAccount('black_money').money >= hinta then
			xPlayer.removeAccountMoney('black_money', hinta)
			xPlayer.addWeapon(aseennimi, 100)
		else
			TriggerClientEvent('esx:showNotification', source, '~r~Sinulla ei ole riittävästi likaista!')
		end
	end
end)

RegisterServerEvent('paskanen_kauppa:osta_itemi')
AddEventHandler("paskanen_kauppa:osta_itemi", function(iteminnimi, hinta)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getAccount('black_money').money >= hinta then
		xPlayer.removeAccountMoney('black_money', hinta)
		xPlayer.addInventoryItem(iteminnimi, 1)
		xPlayer.showNotification("~g~Maksu suoritettu:~r~ $" ..hinta)
	else
		xPlayer.showNotification("~r~Sinulla ei ole riittävästi likaista!")
	end
end)
