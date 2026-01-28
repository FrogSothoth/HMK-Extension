-- 
-- Equipment Data
-- 

local aEquipmentData = {
    ["Arrow Bag (24)"] = { weight = 4, price = 48 },
    ["Backpack (30)"] = { weight = 4, price = 30 },
    ["Bag, Leather (15)"] = { weight = 2, price = 12 },
    ["Bandages (32)"] = { weight = 3, price = 24 },
    ["Bedroll"] = { weight = 4, price = 96 },
    ["Bedroll, Heavy"] = { weight = 10, price = 144 },
    ["Belt Pouch (5)"] = { weight = 0.5, price = 4 },
    ["Bow Case"] = { weight = 3, price = 18 },
    ["Blanket"] = { weight = 3, price = 132 },
    ["Flask (1 pt)"] = { weight = 0.5, price = 6 },
    ["Grappling Hook"] = { weight = 4, price = 18 },
    ["Herbs (retail)"] = { weight = 1, price = 0.25 },
    ["Lantern (1/8 pt)"] = { weight = 1, price = 12 },
    ["Lockpicks"] = { weight = 1, price = 15 },
    ["Oil (1 pt)"] = { weight = 1, price = 1.5 },
    ["Pitons, Iron (6)"] = { weight = 2, price = 6 },
    ["Potion, Great"] = { weight = 1, price = 480 },
    ["Potion, Mild"] = { weight = 1, price = 16 },
    ["Potion, Strong"] = { weight = 1, price = 48 },
    ["Pouch, Buckram"] = { weight = 0.25, price = 7 },
    ["Purse, Silk"] = { weight = 0.1, price = 60 },
    ["Quiver (12)"] = { weight = 2, price = 8 },
    ["Quiver (24)"] = { weight = 3, price = 12 },
    ["Rations, Iron"] = { weight = 3, price = 3 },
    ["Rations, Standard"] = { weight = 3, price = 2 },
    ["Rope, Hemp, 1\", 50'"] = { weight = 12, price = 96 },
    ["Rope, Hemp, 1/2\", 50'"] = { weight = 4, price = 48 },
    ["Rope, Silk, 1/2\", 50'"] = { weight = 4, price = 1440 },
    ["Sack, Canvas (50)"] = { weight = 1, price = 24 },
    ["Sack, Canvas (20)"] = { weight = 0.5, price = 12 },
    ["Surgery Tools"] = { weight = 6, price = 96 },
    ["Tarpaulin (4'x6')"] = { weight = 10, price = 108 },
    ["Tent, 1-man"] = { weight = 25, price = 360 },
    ["Tent, 2-man"] = { weight = 35, price = 504 },
    ["Tent, Conical, 3-man"] = { weight = 50, price = 648 },
    ["Tinderbox"] = { weight = 2, price = 6 },
    ["Torch"] = { weight = 1, price = 1 },
    ["Waterskin (2 qt)"] = { weight = 1.5, price = 24 },
    ["Beads, Ceramic (12)"] = { weight = 2, price = 6 },
    ["Beads, Glass (12)"] = { weight = 1, price = 12 },
    ["Book Binding (Leather)"] = { weight = 1, price = 10 },
    ["Bottle, Ceramic (2 pt)"] = { weight = 1, price = 2 },
    ["Bottle, Glass (2 pt)"] = { weight = 2, price = 6 },
    ["Bowl (8\"x4\")"] = { weight = 3, price = 6 },
    ["Bucket (3 gal)"] = { weight = 10, price = 8 },
    ["Cage (1' cub)"] = { weight = 4, price = 7 },
    ["Candle, Tallow (8 hr)"] = { weight = 1, price = 3 },
    ["Censer, Chain"] = { weight = 2, price = 24 },
    ["Chain (3 ft)"] = { weight = 1, price = 5 },
    ["Charcoal Tinder"] = { weight = 4, price = 0.5 },
    ["Crowbar"] = { weight = 4, price = 9 },
    ["Cup (1 pt)"] = { weight = 1, price = 3 },
    ["Fetters"] = { weight = 2, price = 8 },
    ["Goblet, Pewter"] = { weight = 0.4, price = 3 },
    ["Grainflail"] = { weight = 4, price = 12 },
    ["Hammer"] = { weight = 2, price = 5 },
    ["Hourglass"] = { weight = 0.3, price = 150 },
    ["Icon, Religious (4\")"] = { weight = 1, price = 2 },
    ["Incense"] = { weight = 1, price = 8 },
    ["Ink (1 oz)"] = { weight = 0.05, price = 4 },
    ["Inkwell (2 oz)"] = { weight = 1, price = 30 },
    ["Jar (1 pt)"] = { weight = 0.75, price = 6 },
    ["Jar, Lidded (1 qt)"] = { weight = 2, price = 5 },
    ["Jug (1 gal)"] = { weight = 5, price = 9 },
    ["Knife"] = { weight = 1, price = 6 },
    ["Maul"] = { weight = 5, price = 12 },
    ["Oil, Cinnamon"] = { weight = 0.06, price = 60 },
    ["Oil, Myrtle"] = { weight = 0.06, price = 25 },
    ["Oil, Rose"] = { weight = 0.06, price = 20 },
    ["Padlock, Cmp 1"] = { weight = 2, price = 12 },
    ["Pan, Copper"] = { weight = 2, price = 18 },
    ["Parchment (10\"x14\")"] = { weight = 0.02, price = 2 },
    ["Pen, Quill"] = { weight = 0.05, price = 2 },
    ["Perfume, Cheap"] = { weight = 0.06, price = 12 },
    ["Perfume, Nice"] = { weight = 0.06, price = 120 },
    ["Perfume, Typical"] = { weight = 0.06, price = 48 },
    ["Pickaxe"] = { weight = 5, price = 12 },
    ["Pitchfork"] = { weight = 4, price = 9 },
    ["Plate, Ceramic (8\")"] = { weight = 2, price = 3 },
    ["Plate, Pewter"] = { weight = 0.5, price = 5 },
    ["Plate, Tin"] = { weight = 0.5, price = 6 },
    ["Ploughshare"] = { weight = 12, price = 36 },
    ["Pot (2 qt)"] = { weight = 4, price = 4 },
    ["Scythe"] = { weight = 6, price = 16 },
    ["Sickle"] = { weight = 2, price = 10 },
    ["Soap"] = { weight = 0.06, price = 2 },
    ["Spade"] = { weight = 7, price = 8 },
    ["Spikes/Nails (24)"] = { weight = 1, price = 3 },
    ["Urn (5 gal)"] = { weight = 9, price = 12 },
    ["Vase"] = { weight = 2, price = 4 },
    ["Vial (4oz) (2\"x5\")"] = { weight = 0.25, price = 4 },
    ["Whip"] = { weight = 2, price = 12 },
};

function lookupItem(sName)
    if not sName or sName == "" then return nil; end
    
    local sLowerName = sName:lower();
    local nLen = #sLowerName;
    
    -- First try exact match (case-insensitive)
    for k, v in pairs(aEquipmentData) do
        if k:lower() == sLowerName then
            return v, k;
        end
    end
    
    -- If no exact match, try prefix match (if input is at least 3 chars)
    if nLen >= 3 then
        for k, v in pairs(aEquipmentData) do
            if k:lower():sub(1, nLen) == sLowerName then
                return v, k;
            end
        end
    end
    
    return nil;
end
