local looting = false
local MathLow = Config.LootingLow
local MathHigh = Config.LootingHigh
local LootModifier = 10
local debug = Config.debug

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
										local SeedMaths = KeyHeldTime * LootModifier
										local fortyfours = 0.414444144 * SeedMaths
										local SeedSysTime = GetSystemTime() * fortyfours
										local LootSeed = GetGameTimer() + SeedSysTime * LootModifier - SeedMaths
										if debug == true then print("Seed Generated: " .. LootSeed .. " | Seed Modifiers:  Var-1 [" .. SeedMaths .. "], Var-2 [" .. SeedSysTime .. "], Var-3 [" .. fortyfours .. "]") end
										math.randomseed(LootSeed)
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
										local lootpay = lootmath + pennyConv
										local loot_xp = math.random(10,1000)
										local loot_xp_pay= loot_xp / 100
										if lootpay == 0 then
											if debug == true then print("Player found nothing in Pedestrians pockets.") end
											TriggerEvent("vorp:TipBottom", 'You search their pockets but find nothing of value..', 3000)
										elseif lootpay < 0 then
											print("ERROR LOOTPAY WAS NEGATIVE NUMBER - REPORT THIS ERROR TO DEV | Lootpay: " .. lootpay)
											TriggerEvent("vorp:TipBottom", 'You attempt to search their pockets but find they have been sewn shut', 3000)
										else
											TriggerServerEvent('vorp_loot', lootpay, loot_xp_pay)
											if debug == true then print("Player steals $" .. lootpay .. " from a local Ped") end
											TriggerEvent("vorp:TipBottom", 'You steal $' .. lootpay, 3000)
											Wait(400)
										end
									else
										looting = false
										LootSeed = 0
										SeedMaths = 0
										SeedSysTime = 0
										if debug == true then print("Failed Prompt OR Ped already looted") end
									end
								else
									looting = false
									--LootSeed = 0
									--SeedMaths = 0
									--SeedSysTime = 0
								end
							end
						end
					end
				end
			end
		end
    end
end)
