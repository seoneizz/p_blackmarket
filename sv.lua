ESX = nil
local clients = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


AddEventHandler('playerDropped', function()
	clients[source] = nil
end

RegisterServerEvent('p_shop:getDataToClient', function()
	if not clients[source] then
		clients[source] = true

		TriggerClientEvent('p_shop:sendDataToClient', source, {
			["Pistoolikauppa"] = {
				useBlackMoney = false,
				items = {
					{name  = 'WEAPON_PISTOL50', price = 35000, label = 'Pistooli 50'},
					{name  = 'WEAPON_PISTOL', price = 28000, label = 'Pistooli'}
				},
				locations = {
					vector3(902.25885009766,-1672.7186279297,47.357490539551)
				}
			},
			["Puukkokauppa"] = {
				useBlackMoney = true,
				items = {
					{name  = 'WEAPON_KNIFE', price = 200,  label = 'Puukko'}
				},
				locations = {
					vector3(510.60913085938,-1951.3472900391,24.98509979248)
				}
			}
		})
	else
		print('Clientti yrittää hakee uudestaan dataa, [Source: '. source . ']')
	end
end)

function itemIsWeapon(name)
	if string.find(name, "WEAPON_") then return true
	else return false end
end

RegisterNetEvent('p_shop:buy', function(name, price, blackMoney)
	local isWeapon = itemIsWeapon(name)

	if isWeapon and xPlayer.hasWeapon(weaponName) then 
		return TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You have already this weapon!'})
	end

	if not blackMoney and xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
	else if blackMoney and xPlayer.getAccount('black_money').money >= price then
		xPlayer.removeAccountMoney('black_money', price)
	else
		return TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You do not have enough money'})
	end

	if isWeapon then xPlayer.addWeapon(name, 100)
	else xPlayer.addInventoryItem(name, 1) end

	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Maksu suoritettu: $'..price})
end)