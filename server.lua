TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local discordToggle = Config.discordToggle
local webook = Config.discordWebhook
local MathLow = Config.LootingLow
local MathHigh = Config.LootingHigh
local LootModifier = 10
local debug = Config.debug
local thiefFailtext = Config.searchFailtext
local searchFindtext = Config.searchFindtext
local monies = 0

RegisterServerEvent('vorp_loot')
AddEventHandler('vorp_loot', function(price,xp)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local _price = tonumber(price)
    local playername = Character.firstname.. ' ' ..Character.lastname
	local playerIdentifier = GetPlayerIdentifier(_source)
	local playerIP = GetPlayerEndpoint(_source)
	local playerInfo = "Player: ".. GetPlayerName(_source) .."\nCharacter: ".. playername .."\nIdentifier(s): ".. playerIdentifier .."\nIP: ".. playerIP
	local webhookTitle = "Hails.LootWatch"
	if Config.webhookTitle then webhookTitle = Config.webhookTitle end
	local text = "looted local for " .. monies
	local message = playerInfo .. " Msg: ".. text
	local playerCamRot = GetPlayerCameraRotation(source)
	local playerPingSeed = GetPlayerPing(source)
	local specialSauce = playerPingSeed / playerCamRot.x
	local fortyfours = 0.414444144 * playerCamRot.z + playerPingSeed
	local gameTimerSeed = GetGameTimer()
	local preSeeding = playerCamRot.x * gameTimerSeed * fortyfours
	local RandomSeed = preSeeding * specialSauce / 2
	if debug == true then print("[LootCheck]\n Seed Generated: " .. RandomSeed .. "\n[Modifiers applied]\n Ping: " .. playerPingSeed .. "\n Special Mod: " .. specialSauce .. "\n Special Mod Deux: " .. fortyfours .. "\n Camera Rotation Z: " .. playerCamRot.z .. "\n Camera Rotation X: " .. playerCamRot.x .. "\n GameTimer: " .. gameTimerSeed .. " ") end
	math.randomseed(RandomSeed)
	local loot = math.random(MathLow,MathHigh)
	local pennies = math.random(0,9)
		if pennies == 0 then
			pennyConv = 0.00
		else
			pennyConv = pennies / 100
		end
		if loot == 0 then
			lootmath = 0.00
		else
			lootmath = loot / LootModifier
		end
	local monies = lootmath + pennyConv
		if monies == 0.00 then
			if debug == true then print("[LootCheck]\n" .. playername .. " failed to find money, value " .. monies) end
			if discordToggle then Discord(webhookTitle, message, 16711680) end
			TriggerClientEvent("vorp:TipBottom", source, thiefFailtext, 3000)
		else
			if debug == true then print("" .. playername .. " steals $" .. monies .. " from a local Ped") end
			if discordToggle then Discord(webhookTitle, message, 16711680) end
			Character.addCurrency(0, monies)
			TriggerClientEvent("vorp:TipBottom", source, '' ..searchFindtext .. ' $' .. monies, 3000)
			Wait(400)
		end	
end)

function Discord( title, description, color)
	VorpCore.AddWebhook(title, webhook, description, color)
end