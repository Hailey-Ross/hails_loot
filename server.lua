TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local onesyncCompat = Config.onesync
local MathLow = Config.LootingLow
local MathHigh = Config.LootingHigh
local debug = Config.debug
local vdebug = Config.verboseDebug
local thiefFailtext = Config.searchFailtext
local searchFindtext = Config.searchFindtext
local pickpocketChance = Config.PickpocketChance
local notifyTime = Config.notifyLength * 1000
local LootModifier = 10
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
	local text = Config.webhookText 
	local message = playerInfo .. "\nMsg: " .. text
	local playerCamRot = GetPlayerCameraRotation(source)
	local playerPingSeed = GetPlayerPing(source)
	local specialSauce = playerPingSeed / playerCamRot.x
	local fortyfours = 0.414444144 * playerCamRot.z + playerPingSeed
	local gameTimerSeed = GetGameTimer()
	local preSeeding = playerCamRot.x * gameTimerSeed * fortyfours
	local RandomSeed = nil
	if onesyncCompat then RandomSeed = preSeeding * specialSauce / 2 else RandomSeed = gameTimerSeed * _price * playerPingSeed * 0.414444144 end
	if debug and not vdebug then print("[LootCheck]\n Seed Generated: " .. RandomSeed) end
	if vdebug then print("[LootCheck]\n Seed Generated: " .. RandomSeed .. "\n[Modifiers applied]\n Ping: " .. playerPingSeed .. "\n Special Mod: " .. specialSauce .. "\n Special Mod Deux: " .. fortyfours .. "\n Camera Rotation Z: " .. playerCamRot.z .. "\n Camera Rotation X: " .. playerCamRot.x .. "\n GameTimer: " .. gameTimerSeed .. " ") end
	math.randomseed(RandomSeed)
	local thiefChance = math.random(1,100)
	local loot = math.random(MathLow,MathHigh)
	local pennies = math.random(0,9)
	if thiefChance <= pickpocketChance then
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
		local discordToggle = Config.discordToggle
		local webhook = Config.discordWebhook
		local webhookName = GetCurrentResourceName()
		local webhookColor = 12602111
		local webhookAvatar = "http://assets.mobogaming.com/i/dev-sphere96x96.png"
		local webhookLogo = Config.webhookLogo
		local webhookFooterLogo = Config.hookFootLogo
		local webhookTitle = "Loot Watch"
		if Config.webhookTitle then webhookTitle = Config.webhookTitle end
		if Config.webhookName then webhookName = Config.webhookName end
		if Config.webhookColor then webhookColor = Config.webhookColor end
		if Config.webhookAvatar then webhookAvatar = Config.webhookAvatar end
		local monies = lootmath + pennyConv
		if monies == 0.00 then
			if debug then print("[LootCheck]\n" .. playername .. " failed to find money, value " .. monies) end
			if discordToggle then 
				local description = playerInfo .. "\nMsg: failed to find money on a local Ped"
				VorpCore.AddWebhook(webhooktTitle, webhook, description, webhookColor, webhookName, webhookLogo, webhookFooterLogo, webhookAvatar)
				if vdebug then print("Webhook:\nTitle: " .. webhookTitle .. "\nDescription: " .. description .. "\nWebhook URL: \n" .. webhook) end
			end
			TriggerClientEvent("vorp:TipBottom", source, thiefFailtext, notifyTime)
		else
			Character.addCurrency(0, monies)
			TriggerClientEvent("vorp:TipBottom", source, '' .. searchFindtext .. ' $' .. monies, notifyTime)
			if debug then print("" .. playername .. " steals $" .. monies .. " from a local Ped") end
			if discordToggle then 
				local description = message .. "$" .. monies
				VorpCore.AddWebhook(webhookTitle, webhook, description, color, name, logo, footerlogo, avatar)
				if vdebug then print("Webhook:\nTitle: " .. webhookTitle .. "\nDescription: " .. description .. "\nWebhook URL: \n" .. webhook) end
			end
			Wait(400)
		end
	else
		if debug then print("[LootCheck]\n" .. playername .. " failed thieving check, value " .. thiefChance .. " > " .. pickpocketChance) end
		if discordToggle then 
			local description = playerInfo .. "\nMsg: failed Thieving Check (" .. thiefChance .. "/" .. pickpocketChance .. ")"
			VorpCore.AddWebhook(webhookTitle, webhook, description, webhookColor, webhookName, webhookLogo, webhookFooterLogo, webhookAvatar)
			if vdebug then print("Webhook:\nTitle: " .. webhookTitle .. "\nDescription: " .. description .. "\nWebhook URL: \n" .. webhook) end
		end
		TriggerClientEvent("vorp:TipBottom", source, thiefFailtext, notifyTime)
	end
end)