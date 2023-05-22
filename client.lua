local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core 
end)

local looting = false
local LootModifier = 10
local debug = Config.debug
local vdebug = Config.verboseDebug
local notifyFingerslip = Config.butterfingers
local notifyTime = Config.notifyLength * 1000

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0,1101824977) and not IsPedInAnyVehicle(player, true) and not looting then
			local shape = true
			while shape do
				Wait(0)
				local player = PlayerPedId()
				local coords = GetEntityCoords(player)
				local entityHit = 0
				local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
				local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
				local type = GetPedType(entityHit)
				local dead = IsEntityDead(entityHit)
				local PressTime = 0
				if type == 4 and dead then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(0)
							if IsControlJustReleased(0,1101824977) then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 10 then
									looting = false
									Wait(500)
									local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
									if lootedcheck then
										local thieving = 1
										local loot_xp = 0 --math.random(10,1000)
										local loot_xp_pay = 0 --loot_xp / 100
										TriggerServerEvent('vorp_loot', thieving, loot_xp_pay)
										KeyHeldTime = 0
									else
										VORPcore.NotifyBottomRight(notifyFingerslip, notifyTime)
										looting = false
										LootSeed = 0
										SeedMaths = 0
										SeedSysTime = 0
									end
								else
									looting = false
								end
							end
						end
					end
				end
			end
		end
    end
end)
