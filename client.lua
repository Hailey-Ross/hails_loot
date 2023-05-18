local looting = false
local MathLow = Config.LootingLow
local MathHigh = Config.LootingHigh
local LootModifier = 10
local debug = Config.debug
local thiefchance = Config.PickpocketChance

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
										if debug == true then print("[Thieving Check]\n Seed Generated: " .. LootSeed .. "\n Seed Modifiers:\n Var-1 [" .. SeedMaths .. "]\n Var-2 [" .. SeedSysTime .. "]\n Var-3 [" .. fortyfours .. "]") end
										math.randomseed(LootSeed)
										local thieving = math.random(0,100)
										local loot_xp = math.random(10,1000)
										local loot_xp_pay= loot_xp / 100
										if thieving <= thiefchance then
											if debug == true then print("[Thieving Check]\n Passed with Result: " .. thieving) end
											TriggerServerEvent('vorp_loot', thieving, loot_xp_pay)
										else
											if debug == true then print("[Thieving Check]\n Failed with Result: " .. thieving) end
											TriggerEvent("vorp:TipBottom", 'You find this person has their pockets sewn shut..', 3000)
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
