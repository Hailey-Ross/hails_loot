Config = {}

    Config.debug = false          -- True enables debug output | False for opposite

    Config.discordToggle = false  -- True enables Discord Webhooks | False to Disable
    Config.discordWebhook = ""    -- Paste your Discord Webhook here, Previous option must be enabled to work. 
    Config.webhookTitle = ""      -- Leave blank for Default

    Config.PickpocketChance = 55  -- Chance from 1 to 100 that Pickpocketing will Succeed. Default of 55 means there is a 55% chance out of 100 that the player will succeed.
    Config.LootingLow = 0         -- Set for low end of change dropped, Default 0 or 1
    Config.LootingHigh = 10       -- Set for high end of change dropped, Default 10 for $1.00 max dropped by a Ped

    Config.thiefFailtext = 'You cannot find anything in their pockets..'
    Config.searchFailtext = 'You search their pockets but find nothing of value..'
    Config.searchFindtext = 'You steal'