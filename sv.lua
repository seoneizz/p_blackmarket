ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('blackweashop:serveristaclienttii')
AddEventHandler("blackweashop:serveristaclienttii", function()
  	TriggerClientEvent('blackweashop:serveristaclienttiiclient', source, {
		["Pistoolikauppa"] = {
			blackMoney = false,
			items = {
				{name  = 'WEAPON_PISTOL50', price = 35000, label = 'Pistooli 50', type = 'weapon'},
				{name  = 'WEAPON_PISTOL', price = 28000, label = 'Pistooli', type = 'weapon'}
			},
			Locations = {
				vector3(902.25885009766,-1672.7186279297,47.357490539551)
			}
		},
		["Puukkokauppa"] = {
			blackMoney = true,
			items = {
				{name  = 'WEAPON_KNIFE', price = 200,  label = 'Puukko', type = 'weapon'}
			},
			Locations = {
				vector3(510.60913085938,-1951.3472900391,24.98509979248)
			}
		}
  	})
end)


RegisterServerEvent('blackweashop:buy_weapon')
AddEventHandler("blackweashop:buy_weapon", function(weaponName, price, blackMoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.hasWeapon(weaponName) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sinulla on jo tämä ase!'})
	else
		if blackMoney then
			if xPlayer.getAccount('black_money').money >= price then
				xPlayer.removeAccountMoney('black_money', price)
				xPlayer.addWeapon(weaponName, 100)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Maksu suoritettu: $'..price})
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Sinulla ei ole riittävästi likaista!'})
			end
		else
			if xPlayer.getMoney() >= price then
				xPlayer.removeMoney(price)
				xPlayer.addWeapon(weaponName, 100)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Maksu suoritettu: $'..price})
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sinulla ei ole riittävästi likaista'})
			end
		end
	end
end)

RegisterServerEvent('blackweashop:buy_item')
AddEventHandler("blackweashop:buy_item", function(itemName, price, blackMoney)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if blackMoney then
		if xPlayer.getAccount('black_money').money >= price then
			xPlayer.removeAccountMoney('black_money', price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Maksu suoritettu: $'..price})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sinulla ei ole riittävästi likaista'})
		end
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Maksu suoritettu: $'..price})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sinulla ei ole riittävästi rahaa'})
		end
	end
end)
