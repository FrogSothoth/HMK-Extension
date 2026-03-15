--
-- HarnMaster Missile Weapon Data
-- Contains missile weapon and ammo stats from HMK rules for auto-population
-- from Possessions to Combat tab Missile Weapons list
--

-----------------------------------------------------------
-- Missile Weapon Database
-----------------------------------------------------------

-- Keyed by lowercase weapon name
-- Fields: name, skill, wq, drw, hft, br, vm, chg, proj, pbzd, impd, impv, asp, ta
local aMissileWeaponData = {
    -- THROWING
    ["net"] = {
        name = "Net", skill = "Throwing", wq = 9, drw = nil, hft = 12,
        br = 10, vm = 2, chg = 3, proj = "self",
        pbzd = nil, impd = nil, impv = nil, asp = nil, ta = nil
    },
    ["javelin"] = {
        name = "Javelin", skill = "Throwing", wq = 10, drw = nil, hft = 11,
        br = 60, vm = 2, chg = 3, proj = "self",
        pbzd = 6, impd = 8, impv = 2, asp = "P", ta = "4"
    },
    ["shorkana"] = {
        name = "Shorkana", skill = "Throwing", wq = 10, drw = nil, hft = 10,
        br = 40, vm = 2, chg = 3, proj = "self",
        pbzd = 8, impd = 8, impv = 2, asp = "E", ta = "6"
    },
    ["spear"] = {
        name = "Spear", skill = "Throwing", wq = 11, drw = nil, hft = 13,
        br = 40, vm = 2, chg = 3, proj = "self",
        pbzd = 8, impd = 8, impv = 3, asp = "P", ta = "4"
    },
    ["taburi"] = {
        name = "Taburi", skill = "Throwing", wq = 10, drw = nil, hft = 7,
        br = 30, vm = 2, chg = 3, proj = "self",
        pbzd = 6, impd = 8, impv = 0, asp = "P", ta = "4"
    },
    -- BOWS (Composite)
    ["small bow"] = {
        name = "Small Bow", skill = "Archery", wq = 10, drw = 40, hft = nil,
        br = 120, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 3, asp = "p", ta = nil
    },
    ["composite bow-150"] = {
        name = "Composite Bow-150", skill = "Archery", wq = 11, drw = 40, hft = nil,
        br = 150, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 1, asp = "P", ta = nil
    },
    ["composite bow-180"] = {
        name = "Composite Bow-180", skill = "Archery", wq = 11, drw = 60, hft = nil,
        br = 180, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 2, asp = "P", ta = nil
    },
    ["composite bow-210"] = {
        name = "Composite Bow-210", skill = "Archery", wq = 11, drw = 80, hft = nil,
        br = 210, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 3, asp = "P", ta = nil
    },
    ["composite bow-240"] = {
        name = "Composite Bow-240", skill = "Archery", wq = 12, drw = 100, hft = nil,
        br = 240, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 4, asp = "P", ta = nil
    },
    ["composite bow-270"] = {
        name = "Composite Bow-270", skill = "Archery", wq = 12, drw = 120, hft = nil,
        br = 270, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 5, asp = "P", ta = nil
    },
    ["composite bow-300"] = {
        name = "Composite Bow-300", skill = "Archery", wq = 12, drw = 140, hft = nil,
        br = 300, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 6, asp = "P", ta = nil
    },
    -- BOWS (Longbow)
    ["longbow-150"] = {
        name = "Longbow-150", skill = "Archery", wq = 10, drw = 50, hft = nil,
        br = 150, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 1, asp = "P", ta = nil
    },
    ["longbow-180"] = {
        name = "Longbow-180", skill = "Archery", wq = 10, drw = 75, hft = nil,
        br = 180, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 2, asp = "P", ta = nil
    },
    ["longbow-210"] = {
        name = "Longbow-210", skill = "Archery", wq = 10, drw = 100, hft = nil,
        br = 210, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 3, asp = "P", ta = nil
    },
    ["longbow-240"] = {
        name = "Longbow-240", skill = "Archery", wq = 11, drw = 125, hft = nil,
        br = 240, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 4, asp = "P", ta = nil
    },
    ["longbow-270"] = {
        name = "Longbow-270", skill = "Archery", wq = 11, drw = 150, hft = nil,
        br = 270, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 5, asp = "P", ta = nil
    },
    ["longbow-300"] = {
        name = "Longbow-300", skill = "Archery", wq = 11, drw = 175, hft = nil,
        br = 300, vm = 3, chg = 0, proj = "arrow",
        pbzd = 6, impd = nil, impv = 6, asp = "P", ta = nil
    },
    -- CROSSBOWS
    ["composite crossbow-270"] = {
        name = "Composite Crossbow-270", skill = "Crossbow", wq = 11, drw = 200, hft = nil,
        br = 270, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 4, asp = "P", ta = nil
    },
    ["composite crossbow-300"] = {
        name = "Composite Crossbow-300", skill = "Crossbow", wq = 12, drw = 300, hft = nil,
        br = 300, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 6, asp = "P", ta = nil
    },
    ["wooden crossbow-180"] = {
        name = "Wooden Crossbow-180", skill = "Crossbow", wq = 10, drw = 80, hft = nil,
        br = 180, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 1, asp = "P", ta = nil
    },
    ["wooden crossbow-210"] = {
        name = "Wooden Crossbow-210", skill = "Crossbow", wq = 10, drw = 120, hft = nil,
        br = 210, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 2, asp = "P", ta = nil
    },
    ["wooden crossbow-240"] = {
        name = "Wooden Crossbow-240", skill = "Crossbow", wq = 10, drw = 160, hft = nil,
        br = 240, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 3, asp = "P", ta = nil
    },
    ["kuzhan steelbow"] = {
        name = "Kuzhan Steelbow", skill = "Crossbow", wq = 14, drw = 500, hft = nil,
        br = 360, vm = 2, chg = 0, proj = "bolt",
        pbzd = 6, impd = nil, impv = 10, asp = "P", ta = nil
    },
    -- SLINGS
    ["hand sling"] = {
        name = "Hand Sling", skill = "Slings", wq = 9, drw = 0, hft = nil,
        br = 180, vm = 4, chg = 0, proj = "stone",
        pbzd = 6, impd = 10, impv = nil, asp = "B", ta = "3"
    },
    ["staff sling"] = {
        name = "Staff Sling", skill = "Slings", wq = 9, drw = nil, hft = 11,
        br = 240, vm = 3, chg = 0, proj = "stone",
        pbzd = 6, impd = 10, impv = nil, asp = "B", ta = "3"
    },
};

-----------------------------------------------------------
-- Ammo Database
-----------------------------------------------------------

-- Keyed by lowercase ammo name
-- Fields: name, vm, impd, ta
local aAmmoData = {
    -- Bullets
    ["bullet, lead"] =             { name = "Bullet, Lead",             vm = 0, impd = 0,  ta = "0" },
    ["bullet, stone"] =            { name = "Bullet, Stone",            vm = 0, impd = 0,  ta = "0" },
    -- Arrows (Heavy)
    ["arrows, heavy bodkin"] = { name = "Heavy Bodkin", vm = 0, impd = 12, ta = "3" },
    ["arrows, heavy blunt"] =  { name = "Heavy Blunt",  vm = 0, impd = 12, ta = "4" },
    ["arrows, heavy broad"] =  { name = "Heavy Broad",  vm = 0, impd = 12, ta = "4" },
    -- Arrows (Light)
    ["arrows, light bodkin"] = { name = "Light Bodkin", vm = 1, impd = 8,  ta = "3" },
    ["arrows, light blunt"] =  { name = "Light Blunt",  vm = 1, impd = 8,  ta = "4" },
    ["arrows, light broad"] =  { name = "Light Broad",  vm = 1, impd = 8,  ta = "4" },
    -- Bolts (Heavy)
    ["bolts, heavy bodkin"] =  { name = "Heavy Bodkin",  vm = 0, impd = 12, ta = "3" },
    ["bolts, heavy blunt"] =   { name = "Heavy Blunt",   vm = 0, impd = 12, ta = "4" },
    ["bolts, heavy broad"] =   { name = "Heavy Broad",   vm = 0, impd = 12, ta = "4" },
    -- Bolts (Light)
    ["bolts, light bodkin"] =  { name = "Light Bodkin",  vm = 1, impd = 8,  ta = "3" },
    ["bolts, light blunt"] =   { name = "Light Blunt",   vm = 1, impd = 8,  ta = "4" },
    ["bolts, light broad"] =   { name = "Light Broad",   vm = 1, impd = 8,  ta = "4" },
};

-----------------------------------------------------------
-- Lookup Functions
-----------------------------------------------------------

-- Look up a missile weapon by name (case-insensitive)
-- Tries exact match first, then strips parenthetical suffix for throwing weapons
-- Returns (entry, canonicalKey) or nil
function lookupMissileWeapon(sName)
    if not sName or sName == "" then return nil; end
    local sLower = sName:lower();

    -- Exact match
    if aMissileWeaponData[sLower] then
        return aMissileWeaponData[sLower], sLower;
    end

    -- Strip parenthetical suffix: "Javelin (barbed)" → "Javelin"
    local sBase = sLower:match("^(.-)%s*%(.*%)$");
    if sBase and sBase ~= "" and aMissileWeaponData[sBase] then
        return aMissileWeaponData[sBase], sBase;
    end

    return nil;
end

-- Look up ammo by name (case-insensitive exact match)
-- Returns entry table or nil
function lookupAmmo(sName)
    if not sName or sName == "" then return nil; end
    local sLower = sName:lower();
    
    -- Try direct key match
    if aAmmoData[sLower] then
        return aAmmoData[sLower];
    end

    -- Try matching the 'name' field within entries
    for _, tAmmo in pairs(aAmmoData) do
        if tAmmo.name:lower() == sLower then
            return tAmmo;
        end
    end

    return nil;
end

-- Find all ammo of a given type prefix in possessions
-- sPrefix: "arrows" or "bolts" or "bullet" (case-insensitive)
-- nodeExclude: optional node to skip (for deletion timing)
-- Returns array of {name=<string>, ammo=<ammoEntry>}
function findAmmoInPossessions(nodeChar, sPrefix, nodeExclude)
    local aResult = {};
    local sPrefixLower = sPrefix:lower();

    local nodeGearList = DB.getChild(nodeChar, "possessions");
    if not nodeGearList then return aResult; end

    for _, nodeItem in pairs(DB.getChildList(nodeGearList)) do
        if nodeItem ~= nodeExclude then
            local sName = DB.getValue(nodeItem, "name", "");
            if sName ~= "" then
                local sNameLower = sName:lower();
                if sNameLower:sub(1, #sPrefixLower) == sPrefixLower then
                    local tAmmo = lookupAmmo(sName);
                    if tAmmo then
                        table.insert(aResult, { name = tAmmo.name, ammo = tAmmo });
                    end
                end
            end
        end
    end

    return aResult;
end

-----------------------------------------------------------
-- Skill Lookup
-----------------------------------------------------------

-- Map skill names from CSV to actual HMK skill names
-- HMK has no "Crossbow" skill; crossbows use Archery
local SKILL_MAP = {
    ["Crossbow"] = "Archery",
};

-- Get the actual HMK skill name for a weapon skill
function getActualSkillName(sSkill)
    return SKILL_MAP[sSkill] or sSkill;
end

-- Get a combat skill's ML from a character
-- Returns ML value, or 0 if skill not found
function getSkillML(nodeChar, sSkillName)
    if not nodeChar then return 0; end

    local sActual = getActualSkillName(sSkillName);
    
    -- Try standard character path first
    local nodeList = DB.getChild(nodeChar, "combatskills");
    
    -- If not found (NPC), try the flat skills list
    if not nodeList then
        nodeList = DB.getChild(nodeChar, "skills");
    end

    if not nodeList then return 0; end

    for _, nodeSkill in pairs(DB.getChildList(nodeList)) do
        if DB.getValue(nodeSkill, "name", "") == sActual then
            return DB.getValue(nodeSkill, "ml", 0);
        end
    end
    return 0;
end

-- Get a combat skill's SB from a character using SkillsData + SkillsManager
-- Returns SB value, or 0 if skill not found
function getSkillSB(nodeChar, sSkillName)
    if not nodeChar then return 0; end
    if not SkillsData or not SkillsManager then return 0; end

    local sActual = getActualSkillName(sSkillName);
    local skillData = SkillsData.getSkill(sActual);
    if not skillData then return 0; end

    return SkillsManager.calculateSB(nodeChar, skillData.att1, skillData.att2);
end

-----------------------------------------------------------
-- Format Functions
-----------------------------------------------------------

-- Format DRW/HFT: show DRW if present, else HFT, else 0
function formatDrwHft(entry)
    if entry.drw and entry.drw > 0 then
        return tonumber(entry.drw) or 0;
    elseif entry.hft then
        return tonumber(entry.hft) or 0;
    end
    return 0;
end

-- Format ATK value based on skill ML (and bolt max rule)
-- Returns number: ML value or 0
function formatATK(nodeChar, entry)
    local nML = getSkillML(nodeChar, entry.skill);

    if entry.proj == "bolt" then
        -- Bolt rule: ATK = max(Archery ML, Archery SB × 3)
        local nSB = getSkillSB(nodeChar, entry.skill);
        local nSB3 = nSB * 3;
        if nSB3 > nML then
            nML = nSB3;
        end
    end

    return tonumber(nML) or 0;
end

-- Format PB-ZD: "d6", "d8", etc., or ""
function formatPBZD(nPBZD)
    if not nPBZD or nPBZD == 0 then
        return "";
    end
    return "d" .. nPBZD;
end

-- Format impact string from component values
-- Returns formatted string like "d12+2P", "d8P", "d10-2B", or ""
function formatImpact(nImpD, nImpV, sAsp, nStrImp)
    if not nImpD or nImpD == 0 then
        return "";
    end
    if not sAsp or sAsp == "" then
        return "";
    end

    local sResult = "d" .. nImpD;

    if nImpV and nImpV > 0 then
        sResult = sResult .. "+" .. nImpV;
    elseif nImpV and nImpV < 0 then
        sResult = sResult .. nImpV;
    end
    -- nImpV == 0 or nil: omit modifier

    sResult = sResult .. sAsp;

    if nStrImp and nStrImp ~= 0 then
        if nStrImp > 0 then
            sResult = sResult .. "+" .. nStrImp;
        else
            sResult = sResult .. nStrImp;
        end
    end

    return sResult;
end


-----------------------------------------------------------
-- Sync Functions
-----------------------------------------------------------

-- Synchronize missile weapons list with current possessions
-- Uses a full rebuild strategy: delete all existing entries, then recreate from scratch.
-- This ensures fresh, correctly-structured entries every time and avoids stale data issues.
-- nodeExclude: optional node to skip during scan (for deletion timing)
function syncMissileWeapons(nodeChar, nodeExclude)
    if not nodeChar then return; end

    Debug.console("MissileData: syncMissileWeapons starting for " .. DB.getPath(nodeChar));

    -- Step 1: Build set of expected weapon+ammo combinations from possessions
    -- Identity: "WeaponName|AmmoName" or "WeaponName|self" etc.
    local tExpected = {};  -- set of combo keys
    local tComboData = {}; -- map combo key -> {weaponEntry, ammoEntry}
    
    local nodeGearList = DB.getChild(nodeChar, "possessions");
    if nodeGearList then
        local tSeenWeapons = {};
        for _, nodeItem in pairs(DB.getChildList(nodeGearList)) do
            if nodeItem ~= nodeExclude then
                local sName = DB.getValue(nodeItem, "name", "");
                if sName ~= "" then
                    local tWeapon, sWeaponKey = lookupMissileWeapon(sName);
                    if tWeapon and not tSeenWeapons[sWeaponKey] then
                        tSeenWeapons[sWeaponKey] = true;

                        if tWeapon.proj == "self" or tWeapon.proj == "stone" then
                            local sKey = tWeapon.name:lower() .. "|" .. tWeapon.proj;
                            tExpected[sKey] = true;
                            tComboData[sKey] = { weapon = tWeapon, ammo = nil };
                        elseif tWeapon.proj == "arrow" then
                            local aAmmo = findAmmoInPossessions(nodeChar, "arrows", nodeExclude);
                            for _, tAmmoResult in ipairs(aAmmo) do
                                local sKey = tWeapon.name:lower() .. "|" .. tAmmoResult.ammo.name:lower();
                                tExpected[sKey] = true;
                                tComboData[sKey] = { weapon = tWeapon, ammo = tAmmoResult.ammo };
                            end
                        elseif tWeapon.proj == "bolt" then
                            local aAmmo = findAmmoInPossessions(nodeChar, "bolts", nodeExclude);
                            for _, tAmmoResult in ipairs(aAmmo) do
                                local sKey = tWeapon.name:lower() .. "|" .. tAmmoResult.ammo.name:lower();
                                tExpected[sKey] = true;
                                tComboData[sKey] = { weapon = tWeapon, ammo = tAmmoResult.ammo };
                            end
                        end
                    end
                end
            end
        end
    end

    Debug.console("MissileData: Expected " .. _countKeys(tExpected) .. " combinations");

    -- Step 2: Careful Sync - Remove entries that match a "standard" weapon but no longer exist in expected set
    local nodeMissileList = DB.getChild(nodeChar, "missileweapons");
    if nodeMissileList then
        local aToDelete = {};
        for _, nodeMissile in pairs(DB.getChildList(nodeMissileList)) do
            local sWpnName = DB.getValue(nodeMissile, "name", ""):lower();
            local sProj = DB.getValue(nodeMissile, "proj", ""):lower();
            
            -- If this looks like a standard weapon entry
            if lookupMissileWeapon(sWpnName) then
                -- Check the proj source
                local sCheckProj = sProj;
                if sProj == "self" or sProj == "stone" then
                    -- standard self-propelled
                else
                    -- standard arrow/bolt if it matches an ammo name
                    if not lookupAmmo(sProj) then
                        sCheckProj = nil; -- Not a standard ammo, might be manual
                    end
                end

                if sCheckProj then
                    local sKey = sWpnName .. "|" .. sCheckProj;
                    if not tExpected[sKey] then
                        table.insert(aToDelete, nodeMissile);
                    end
                end
            end
        end
        for _, node in ipairs(aToDelete) do
            Debug.console("MissileData: Removing missile entry: " .. DB.getValue(node, "name", ""));
            DB.deleteNode(node);
        end
    end

    -- Step 3: Add missing entries
    for sComboKey, tData in pairs(tComboData) do
        -- Check if already exists
        local bExists = false;
        nodeMissileList = DB.getChild(nodeChar, "missileweapons");
        if nodeMissileList then
            for _, nodeMissile in pairs(DB.getChildList(nodeMissileList)) do
                local sWpnName = DB.getValue(nodeMissile, "name", ""):lower();
                local sProj = DB.getValue(nodeMissile, "proj", ""):lower();
                if (sWpnName .. "|" .. sProj) == sComboKey then
                    bExists = true;
                    break;
                end
            end
        end

        if not bExists then
            local tWeapon = tData.weapon;
            local tAmmo = tData.ammo;
            local nodeList = DB.createChild(nodeChar, "missileweapons");
            local nodeEntry = DB.createChild(nodeList);

            DB.setValue(nodeEntry, "name", "string", tWeapon.name);
            DB.setValue(nodeEntry, "wq", "number", tWeapon.wq);
            DB.setValue(nodeEntry, "drwhft", "number", formatDrwHft(tWeapon));
            DB.setValue(nodeEntry, "br", "number", tWeapon.br);
            DB.setValue(nodeEntry, "chg", "number", tWeapon.chg);
            DB.setValue(nodeEntry, "pbzd", "string", formatPBZD(tWeapon.pbzd));
            DB.setValue(nodeEntry, "atk", "number", formatATK(nodeChar, tWeapon));

            if tWeapon.proj == "self" then
                local nStrImp = nil;
                if tWeapon.skill == "Throwing" then
                    nStrImp = HarnManager.calculateStrImpact(nodeChar) - 1;
                end
                DB.setValue(nodeEntry, "vm", "number", tWeapon.vm);
                DB.setValue(nodeEntry, "proj", "string", "self");
                DB.setValue(nodeEntry, "imp", "string", formatImpact(tWeapon.impd, tWeapon.impv, tWeapon.asp, nStrImp));
                DB.setValue(nodeEntry, "ta", "number", tonumber(tWeapon.ta) or 0);
            elseif tWeapon.proj == "stone" then
                local nStrImp = HarnManager.calculateStrImpact(nodeChar);
                DB.setValue(nodeEntry, "vm", "number", tWeapon.vm);
                DB.setValue(nodeEntry, "proj", "string", "stone");
                DB.setValue(nodeEntry, "imp", "string", formatImpact(tWeapon.impd, nStrImp, tWeapon.asp));
                DB.setValue(nodeEntry, "ta", "number", tonumber(tWeapon.ta) or 0);
            elseif tAmmo then
                DB.setValue(nodeEntry, "vm", "number", (tWeapon.vm or 0) + (tAmmo.vm or 0));
                DB.setValue(nodeEntry, "proj", "string", tAmmo.name);
                DB.setValue(nodeEntry, "imp", "string", formatImpact(tAmmo.impd, tWeapon.impv, tWeapon.asp));
                DB.setValue(nodeEntry, "ta", "number", tonumber(tAmmo.ta) or 0);
            end
            Debug.console("MissileData: Added missile entry: " .. sComboKey);
        end
    end
end

-- Update ATK on all missile weapon entries with current skill MLs
function updateMissileATK(nodeChar)
    if not nodeChar then return; end

    Debug.console("MissileData: Updating ATK values");

    local nodeMissileList = DB.getChild(nodeChar, "missileweapons");
    if not nodeMissileList then return; end

    for _, nodeMissile in pairs(DB.getChildList(nodeMissileList)) do
        local sMissileName = DB.getValue(nodeMissile, "name", "");
        local tWeapon = lookupMissileWeapon(sMissileName);
        if tWeapon then
            DB.setValue(nodeMissile, "atk", "string", formatATK(nodeChar, tWeapon));
        end
    end
end

-- Update Impact on all missile weapon entries with current STR modifier
function updateMissileImpact(nodeChar)
    if not nodeChar then return; end

    local nodeMissileList = DB.getChild(nodeChar, "missileweapons");
    if not nodeMissileList then return; end

    local nStrImpThrowing = HarnManager.calculateStrImpact(nodeChar) - 1;
    local nStrImpSling = HarnManager.calculateStrImpact(nodeChar);
    
    Debug.console("MissileData: Updating Impact with STR throw=" .. nStrImpThrowing .. " sling=" .. nStrImpSling);

    for _, nodeMissile in pairs(DB.getChildList(nodeMissileList)) do
        local sMissileName = DB.getValue(nodeMissile, "name", "");
        local tWeapon = lookupMissileWeapon(sMissileName);
        if tWeapon then
            if tWeapon.proj == "self" then
                if tWeapon.skill == "Throwing" then
                    DB.setValue(nodeMissile, "imp", "string", formatImpact(tWeapon.impd, tWeapon.impv, tWeapon.asp, nStrImpThrowing));
                else
                    DB.setValue(nodeMissile, "imp", "string", formatImpact(tWeapon.impd, tWeapon.impv, tWeapon.asp));
                end
            elseif tWeapon.proj == "stone" then
                 DB.setValue(nodeMissile, "imp", "string", formatImpact(tWeapon.impd, nStrImpSling, tWeapon.asp));
            else
                 -- For arrows and bolts, impact is ammo impd + weapon impv. STR does not apply.
                local sProj = DB.getValue(nodeMissile, "proj", "");
                local tAmmo = lookupAmmo(sProj);
                if tAmmo then
                    DB.setValue(nodeMissile, "imp", "string", formatImpact(tAmmo.impd, tWeapon.impv, tWeapon.asp));
                end
            end
        end
    end
end

-- Utility: count keys in a table
function _countKeys(t)
    local n = 0;
    for _ in pairs(t) do n = n + 1; end
    return n;
end
