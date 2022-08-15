Config = {}

-- Set the Items that can be taken from an NPC
Config.NPCItems = {
    {label = "Phone", item = "phone", maxCount = 1},
    {label = "Gold Necklace", item = "10kgoldchain", maxCount = 1},
    {label = "Cigarettes", item = "cigarette", maxCount = 12}
}

Config.MaxNPCMoney = 400

-- Set Items that can NOT be taken from a Player
Config.BlacklistedItems = {
    "WEAPON_SNSPISTOL"
}

-- Set the Max amount of money that can be taken from a player
-- Max Money Type can be % = Percentage of Total or $ = Max Dollar amount
Config.MaxMoneyType = "%"
Config.MaxMoney = 20

-- Set the name of Police Job for Notification
Config.Police = "police"

