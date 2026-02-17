--
-- HarnMaster Melee Weapon Data
-- Contains melee weapon stats from HMK rules for auto-population
-- from Possessions to Combat tab Melee Weapons list
--

-- Melee weapon database keyed by lowercase weapon name
-- Values are arrays of attack-form entries (one weapon can have multiple attack forms)
-- Fields: name, wq, hft, lng, zd, impd, impv, asp, ta
local aMeleeWeaponData = {
    -- AXES
    ["battleaxe"] = {
        { name = "Battleaxe", wq = 12, hft = 17, lng = 5, zd = 6, impd = 8, impv = 7, asp = "E", ta = "6" },
    },
    ["handaxe"] = {
        { name = "Handaxe", wq = 11, hft = 13, lng = 5, zd = 6, impd = 8, impv = 4, asp = "E", ta = "6" },
    },
    ["hatchet"] = {
        { name = "Hatchet", wq = 9, hft = 10, lng = 4, zd = 6, impd = 8, impv = 4, asp = "E", ta = "6" },
    },
    ["pickaxe"] = {
        { name = "Pickaxe", wq = 9, hft = 18, lng = 5, zd = 6, impd = 8, impv = 5, asp = "P", ta = "5" },
    },
    ["shorkana"] = {
        { name = "Shorkana", wq = 10, hft = 10, lng = 5, zd = 6, impd = 8, impv = 4, asp = "E", ta = "6" },
    },
    ["sickle"] = {
        { name = "Sickle", wq = 9, hft = 9, lng = 3, zd = 6, impd = 10, impv = 2, asp = "E", ta = "5" },
    },
    ["warhammer"] = {
        { name = "Warhammer", wq = 11, hft = 13, lng = 5, zd = 6, impd = 6, impv = 4, asp = "B", ta = "3" },
        { name = "Warhammer", wq = 11, hft = 13, lng = 5, zd = 6, impd = 8, impv = 3, asp = "P", ta = "4" },
    },
    ["wood axe"] = {
        { name = "Wood Axe", wq = 9, hft = 16, lng = 5, zd = 6, impd = 8, impv = 6, asp = "E", ta = "6" },
    },
    -- CLUBS
    ["club"] = {
        { name = "Club", wq = 9, hft = 11, lng = 4, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["club (improvised)"] = {
        { name = "Club (improvised)", wq = 8, hft = 11, lng = 4, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["crowbar"] = {
        { name = "Crowbar", wq = 11, hft = 13, lng = 4, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["club (crafted)"] = {
        { name = "Club (crafted)", wq = 9, hft = 14, lng = 5, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["mace (metal shaft)"] = {
        { name = "Mace (metal shaft)", wq = 12, hft = 11, lng = 4, zd = 6, impd = 6, impv = 4, asp = "B", ta = "3" },
    },
    ["mace (wood shaft)"] = {
        { name = "Mace (wood shaft)", wq = 11, hft = 11, lng = 4, zd = 6, impd = 6, impv = 3, asp = "B", ta = "3" },
    },
    ["maul (metal)"] = {
        { name = "Maul (metal)", wq = 12, hft = 18, lng = 5, zd = 6, impd = 6, impv = 6, asp = "B", ta = "3" },
    },
    ["maul (wood)"] = {
        { name = "Maul (wood)", wq = 10, hft = 17, lng = 5, zd = 6, impd = 6, impv = 5, asp = "B", ta = "3" },
    },
    ["morningstar"] = {
        { name = "Morningstar", wq = 11, hft = 15, lng = 5, zd = 6, impd = 8, impv = 4, asp = "P", ta = "3" },
    },
    ["stick"] = {
        { name = "Stick", wq = 8, hft = 9, lng = 3, zd = 6, impd = 6, impv = 0, asp = "B", ta = "3" },
    },
    -- FLAILS
    ["ball and chain"] = {
        { name = "Ball and Chain", wq = 12, hft = 14, lng = 5, zd = 6, impd = 6, impv = 5, asp = "B", ta = "3" },
    },
    ["grainflail"] = {
        { name = "Grainflail", wq = 9, hft = 11, lng = 5, zd = 6, impd = 6, impv = 2, asp = "B", ta = "3" },
    },
    ["net"] = {
        { name = "Net", wq = 9, hft = 12, lng = 2, zd = 0, impd = 0, impv = 0, asp = "B", ta = "0" },
    },
    ["warflail"] = {
        { name = "Warflail", wq = 11, hft = 17, lng = 6, zd = 6, impd = 6, impv = 6, asp = "B", ta = "3" },
    },
    ["whip (herder)"] = {
        { name = "Whip (herder)", wq = 9, hft = 9, lng = 8, zd = 8, impd = 6, impv = 0, asp = "E", ta = "2" },
    },
    ["whip (teamster)"] = {
        { name = "Whip (teamster)", wq = 9, hft = 8, lng = 4, zd = 6, impd = 6, impv = 0, asp = "E", ta = "2" },
    },
    ["isagara"] = {
        { name = "Isagara", wq = 10, hft = 10, lng = 8, zd = 8, impd = 8, impv = 1, asp = "E", ta = "4" },
    },
    -- KNIVES
    ["dagger"] = {
        { name = "Dagger", wq = 11, hft = 7, lng = 3, zd = 6, impd = 8, impv = 2, asp = "P", ta = "4" },
        { name = "Dagger", wq = 11, hft = 7, lng = 3, zd = 6, impd = 10, impv = 1, asp = "E", ta = "5" },
    },
    ["keltan"] = {
        { name = "Keltan", wq = 12, hft = 7, lng = 3, zd = 6, impd = 8, impv = 1, asp = "P", ta = "3" },
        { name = "Keltan", wq = 12, hft = 7, lng = 3, zd = 6, impd = 10, impv = 0, asp = "E", ta = "4" },
    },
    ["knife"] = {
        { name = "Knife", wq = 10, hft = 6, lng = 2, zd = 6, impd = 8, impv = 1, asp = "P", ta = "3" },
        { name = "Knife", wq = 10, hft = 6, lng = 2, zd = 6, impd = 10, impv = 0, asp = "E", ta = "4" },
    },
    ["longknife"] = {
        { name = "Longknife", wq = 13, hft = 7, lng = 4, zd = 6, impd = 8, impv = 3, asp = "P", ta = "4" },
        { name = "Longknife", wq = 13, hft = 7, lng = 4, zd = 6, impd = 10, impv = 2, asp = "E", ta = "5" },
    },
    ["taburi"] = {
        { name = "Taburi", wq = 10, hft = 7, lng = 2, zd = 6, impd = 8, impv = 2, asp = "P", ta = "4" },
    },
    -- POLEARMS
    ["falcastra"] = {
        { name = "Falcastra", wq = 9, hft = 18, lng = 7, zd = 8, impd = 8, impv = 4, asp = "P", ta = "4" },
    },
    ["glaive"] = {
        { name = "Glaive", wq = 11, hft = 18, lng = 7, zd = 8, impd = 10, impv = 4, asp = "E", ta = "5" },
        { name = "Glaive", wq = 11, hft = 18, lng = 7, zd = 8, impd = 8, impv = 3, asp = "P", ta = "4" },
    },
    ["javelin (barbed)"] = {
        { name = "Javelin (barbed)", wq = 10, hft = 11, lng = 5, zd = 6, impd = 8, impv = 4, asp = "P", ta = "4" },
    },
    ["javelin (narrow)"] = {
        { name = "Javelin (narrow)", wq = 10, hft = 11, lng = 5, zd = 6, impd = 8, impv = 3, asp = "P", ta = "4" },
    },
    ["jousting pole"] = {
        { name = "Jousting Pole", wq = 8, hft = 16, lng = 8, zd = 8, impd = 6, impv = 2, asp = "B", ta = "3" },
    },
    ["lance"] = {
        { name = "Lance", wq = 11, hft = 17, lng = 8, zd = 8, impd = 8, impv = 6, asp = "P", ta = "4" },
    },
    ["pike"] = {
        { name = "Pike", wq = 12, hft = 19, lng = 9, zd = 8, impd = 8, impv = 6, asp = "P", ta = "4" },
    },
    ["pitchfork"] = {
        { name = "Pitchfork", wq = 9, hft = 12, lng = 5, zd = 6, impd = 8, impv = 3, asp = "P", ta = "4" },
    },
    ["poleaxe"] = {
        { name = "Poleaxe", wq = 11, hft = 18, lng = 6, zd = 6, impd = 6, impv = 5, asp = "B", ta = "3" },
        { name = "Poleaxe", wq = 11, hft = 18, lng = 6, zd = 6, impd = 8, impv = 7, asp = "E", ta = "6" },
        { name = "Poleaxe", wq = 11, hft = 18, lng = 6, zd = 8, impd = 8, impv = 4, asp = "P", ta = "4" },
    },
    ["spear"] = {
        { name = "Spear", wq = 11, hft = 13, lng = 7, zd = 8, impd = 8, impv = 5, asp = "P", ta = "4" },
    },
    ["staff"] = {
        { name = "Staff", wq = 11, hft = 12, lng = 5, zd = 6, impd = 6, impv = 2, asp = "B", ta = "3" },
    },
    ["trident"] = {
        { name = "Trident", wq = 12, hft = 14, lng = 6, zd = 8, impd = 8, impv = 5, asp = "P", ta = "4" },
    },
    -- SHIELDS
    ["buckler"] = {
        { name = "Buckler", wq = 9, hft = 8, lng = 1, zd = 6, impd = 6, impv = 0, asp = "B", ta = "3" },
    },
    ["kite shield"] = {
        { name = "Kite Shield", wq = 11, hft = 11, lng = 1, zd = 8, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["knight's shield"] = {
        { name = "Knight's Shield", wq = 11, hft = 10, lng = 1, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["roundshield"] = {
        { name = "Roundshield", wq = 10, hft = 10, lng = 1, zd = 6, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    ["tower shield"] = {
        { name = "Tower Shield", wq = 11, hft = 12, lng = 1, zd = 8, impd = 6, impv = 1, asp = "B", ta = "3" },
    },
    -- SWORDS
    ["bastard sword"] = {
        { name = "Bastard Sword", wq = 12, hft = 14, lng = 5, zd = 6, impd = 10, impv = 4, asp = "E", ta = "5" },
        { name = "Bastard Sword", wq = 12, hft = 14, lng = 5, zd = 6, impd = 8, impv = 2, asp = "P", ta = "4" },
    },
    ["battlesword"] = {
        { name = "Battlesword", wq = 13, hft = 18, lng = 6, zd = 6, impd = 10, impv = 5, asp = "E", ta = "5" },
        { name = "Battlesword", wq = 13, hft = 18, lng = 6, zd = 6, impd = 8, impv = 2, asp = "P", ta = "4" },
    },
    ["broadsword"] = {
        { name = "Broadsword", wq = 12, hft = 10, lng = 5, zd = 6, impd = 10, impv = 3, asp = "E", ta = "5" },
        { name = "Broadsword", wq = 12, hft = 10, lng = 5, zd = 6, impd = 8, impv = 1, asp = "P", ta = "4" },
    },
    ["estoc"] = {
        { name = "Estoc", wq = 12, hft = 14, lng = 5, zd = 6, impd = 8, impv = 3, asp = "P", ta = "3" },
    },
    ["falchion"] = {
        { name = "Falchion", wq = 12, hft = 12, lng = 4, zd = 6, impd = 8, impv = 4, asp = "E", ta = "6" },
    },
    ["scimitar"] = {
        { name = "Scimitar", wq = 12, hft = 10, lng = 5, zd = 6, impd = 10, impv = 2, asp = "E", ta = "6" },
        { name = "Scimitar", wq = 12, hft = 10, lng = 5, zd = 6, impd = 8, impv = 1, asp = "P", ta = "4" },
    },
    ["shortsword"] = {
        { name = "Shortsword", wq = 12, hft = 8, lng = 4, zd = 6, impd = 10, impv = 2, asp = "E", ta = "5" },
        { name = "Shortsword", wq = 12, hft = 8, lng = 4, zd = 6, impd = 8, impv = 1, asp = "P", ta = "4" },
    },
    ["mang"] = {
        { name = "Mang", wq = 10, hft = 11, lng = 5, zd = 6, impd = 8, impv = 4, asp = "E", ta = "5" },
    },
    ["mankar"] = {
        { name = "Mankar", wq = 11, hft = 9, lng = 3, zd = 6, impd = 8, impv = 3, asp = "E", ta = "5" },
    },
    -- UNARMED
    ["bite"] = {
        { name = "Bite", wq = 0, hft = 0, lng = 0, zd = 2, impd = 4, impv = 0, asp = "P", ta = "3" },
    },
    ["grab"] = {
        { name = "Grab", wq = 0, hft = 0, lng = 1, zd = 4, impd = nil, impv = nil, asp = nil, ta = "" },
    },
    ["headbutt"] = {
        { name = "Headbutt", wq = 0, hft = 0, lng = 0, zd = 4, impd = 6, impv = -2, asp = "B", ta = "2" },
    },
    ["kick"] = {
        { name = "Kick", wq = 0, hft = 0, lng = 2, zd = 4, impd = 6, impv = -2, asp = "B", ta = "2" },
    },
    ["limb block"] = {
        { name = "Limb Block", wq = 0, hft = 0, lng = 1, zd = nil, impd = nil, impv = nil, asp = nil, ta = "" },
    },
    ["press"] = {
        { name = "Press", wq = 0, hft = 0, lng = 1, zd = nil, impd = nil, impv = nil, asp = nil, ta = "" },
    },
    ["punch"] = {
        { name = "Punch", wq = 0, hft = 0, lng = 1, zd = 4, impd = 6, impv = -3, asp = "B", ta = "2" },
    },
    ["trip"] = {
        { name = "Trip", wq = 0, hft = 0, lng = 2, zd = nil, impd = nil, impv = nil, asp = nil, ta = "" },
    },
};

-----------------------------------------------------------
-- Lookup Functions
-----------------------------------------------------------

-- Look up a weapon by name (case-insensitive exact match)
-- Returns array of entry tables or nil
function lookupWeapon(sName)
    if not sName or sName == "" then return nil; end
    local sLower = sName:lower();
    return aMeleeWeaponData[sLower];
end

-- Format Zone Dice string: "d6", "d8", etc.
-- Returns "" for nil/0 values
function formatZD(entry)
    if not entry.zd or entry.zd == 0 then
        return "";
    end
    return "d" .. entry.zd;
end

-- Format Impact string: "d8+4E", "d6-2B", "d6B", etc.
-- Returns "" for entries with no impact data
function formatImpact(entry)
    if not entry.impd or not entry.asp or entry.asp == "" then
        return "";
    end
    if entry.impd == 0 and (not entry.impv or entry.impv == 0) then
        return "";
    end

    local sResult = "d" .. entry.impd;

    if entry.impv and entry.impv > 0 then
        sResult = sResult .. "+" .. entry.impv;
    elseif entry.impv and entry.impv < 0 then
        sResult = sResult .. entry.impv;
    end
    -- impv == 0 or nil: omit modifier entirely

    sResult = sResult .. entry.asp;
    return sResult;
end

-----------------------------------------------------------
-- Character Skill Lookup
-----------------------------------------------------------

-- Get character's Melee skill ML from combatskills
-- Returns 0 if Melee skill not found
function getMeleeML(nodeChar)
    if not nodeChar then return 0; end

    -- Try standard character path first
    local nodeList = DB.getChild(nodeChar, "combatskills");
    
    -- If not found (NPC), try the flat skills list
    if not nodeList then
        nodeList = DB.getChild(nodeChar, "skills");
    end

    if not nodeList then return 0; end

    for _, nodeSkill in pairs(DB.getChildList(nodeList)) do
        if DB.getValue(nodeSkill, "name", "") == "Melee" then
            return DB.getValue(nodeSkill, "ml", 0);
        end
    end
    return 0;
end

-----------------------------------------------------------
-- Sync and Update Functions
-----------------------------------------------------------

-- Synchronize melee weapons list with current possessions
-- Removes melee entries for weapons no longer in possessions
-- Adds melee entries for weapons newly in possessions
-- nodeExclude: optional node to skip during scan (used when called from onDelete handler,
--   because the deleted node is still visible in DB.getChildList at that point)
function syncMeleeWeapons(nodeChar, nodeExclude)
    if not nodeChar then return; end
    if not EquipmentData then
        Debug.console("MeleeData: EquipmentData not available");
        return;
    end

    Debug.console("MeleeData: syncMeleeWeapons starting for " .. DB.getPath(nodeChar));

    -- Step 1: Build set of weapon names currently in possessions
    local tPossessionWeapons = {};
    local nodeGearList = DB.getChild(nodeChar, "possessions");
    if nodeGearList then
        for _, nodeItem in pairs(DB.getChildList(nodeGearList)) do
            -- Skip the node being deleted (still visible during onDelete)
            if nodeItem ~= nodeExclude then
                local sName = DB.getValue(nodeItem, "name", "");
                if sName ~= "" then
                    local tItem, sFullName = EquipmentData.lookupItem(sName);
                    if tItem and tItem.type == "Weapon" and sFullName then
                        -- Check if this weapon exists in our melee data
                        local aEntries = lookupWeapon(sFullName);
                        if aEntries then
                            tPossessionWeapons[sFullName:lower()] = true;
                        end
                    end
                end
            end
        end
    end

    Debug.console("MeleeData: Found " .. _countKeys(tPossessionWeapons) .. " weapon types in possessions");

    -- Step 2: Remove melee entries that don't match any possession weapon
    local nodeMeleeList = DB.getChild(nodeChar, "meleeweapons");
    if nodeMeleeList then
        local aToDelete = {};
        for _, nodeMelee in pairs(DB.getChildList(nodeMeleeList)) do
            local sMeleeName = DB.getValue(nodeMelee, "name", "");
            if sMeleeName ~= "" then
                -- Check if this weapon name matches any possession weapon
                if not tPossessionWeapons[sMeleeName:lower()] then
                    table.insert(aToDelete, nodeMelee);
                end
            end
        end
        for _, node in ipairs(aToDelete) do
            Debug.console("MeleeData: Removing melee entry: " .. DB.getValue(node, "name", ""));
            DB.deleteNode(node);
        end
    end

    -- Step 3: Add melee entries for weapons in possessions but not in melee list
    local nMeleeML = getMeleeML(nodeChar);

    for sWeaponKey, _ in pairs(tPossessionWeapons) do
        local aEntries = aMeleeWeaponData[sWeaponKey];
        if aEntries then
            -- Check if entries already exist for this weapon
            local nExisting = 0;
            nodeMeleeList = DB.getChild(nodeChar, "meleeweapons");
            if nodeMeleeList then
                for _, nodeMelee in pairs(DB.getChildList(nodeMeleeList)) do
                    if DB.getValue(nodeMelee, "name", ""):lower() == sWeaponKey then
                        nExisting = nExisting + 1;
                    end
                end
            end

            -- Only add if no entries exist for this weapon
            if nExisting == 0 then
                local nodeList = DB.createChild(nodeChar, "meleeweapons");
                for _, entry in ipairs(aEntries) do
                    local nodeWeapon = DB.createChild(nodeList);
                    DB.setValue(nodeWeapon, "name", "string", entry.name);
                    DB.setValue(nodeWeapon, "wq", "number", entry.wq);
                    DB.setValue(nodeWeapon, "hft", "string", tostring(entry.hft));
                    DB.setValue(nodeWeapon, "rch", "number", entry.lng);
                    DB.setValue(nodeWeapon, "atk", "number", nMeleeML);
                    DB.setValue(nodeWeapon, "def", "number", nMeleeML);
                    DB.setValue(nodeWeapon, "zd", "string", formatZD(entry));
                    DB.setValue(nodeWeapon, "imp", "string", formatImpact(entry));
                    DB.setValue(nodeWeapon, "ta", "string", entry.ta or "");
                    Debug.console("MeleeData: Added melee entry: " .. entry.name .. " (" .. (entry.asp or "?") .. ")");
                end
            end
        end
    end
end

-- Update ATK and DEF on all melee weapon entries with current Melee ML
function updateMeleeATKDEF(nodeChar)
    if not nodeChar then return; end

    local nMeleeML = getMeleeML(nodeChar);
    Debug.console("MeleeData: Updating ATK/DEF with Melee ML = " .. nMeleeML);

    local nodeMeleeList = DB.getChild(nodeChar, "meleeweapons");
    if not nodeMeleeList then return; end

    for _, nodeMelee in pairs(DB.getChildList(nodeMeleeList)) do
        DB.setValue(nodeMelee, "atk", "number", nMeleeML);
        DB.setValue(nodeMelee, "def", "number", nMeleeML);
    end
end

-- Utility: count keys in a table
function _countKeys(t)
    local n = 0;
    for _ in pairs(t) do n = n + 1; end
    return n;
end
