--
-- HMK Armor Manager
-- Handles AV calculations, stacking, Bulk penalties, and ENC/PF.
--

function onInit()
    -- Global registry happens in harn_manager.lua
end

-- Safely set a database value
function safeSetValue(nodeParent, sPath, sType, vValue)
    if not nodeParent then return; end
    
    -- In FGU, the numeric type is always "number" (which supports decimals in Unity)
    -- Using "float" or other names will cause type mismatch errors.
    local sActualType = sType;
    if sType == "float" then sActualType = "number"; end

    local node = nodeParent.getChild(sPath);
    if node then
        if node.getType() ~= sActualType then
            Debug.console("ArmorManager: Type mismatch for " .. sPath .. " (" .. node.getType() .. " vs " .. sActualType .. "). Deleting.");
            node.delete();
        end
    end
    
    DB.setValue(nodeParent, sPath, sActualType, vValue);
end

-- Calculate Total ARMOR and GEAR
function calculateArmor(nodeChar)
    if not nodeChar then return; end

    -- 1. Initialize Body Locations Data Structures
    local locations = {
        "Skull", "Face", "Neck", "Shoulder", "Upper Arm",
        "Elbow", "Forearm", "Hand", "Thorax", "Abdomen",
        "Pelvis", "Thigh", "Knee", "Calf", "Foot"
    };

    local locData = {};
    for _, loc in ipairs(locations) do
        locData[loc] = {
            front = { b=0, e=0, p=0, f=0, rigid=false },
            back = { b=0, e=0, p=0, f=0, rigid=false },
            materials = {},
            layerCount = 0
        };
    end

    local nArmorWeight = 0;
    local nArmorPenalty = 0;

    -- 2. Process Armor Items
    local nodeArmourList = nodeChar.getChild("armourlist");
    if nodeArmourList then
        for _, nodeItem in pairs(nodeArmourList.getChildren()) do
            local sItemName = DB.getValue(nodeItem, "name", "");
            local nWt = DB.getValue(nodeItem, "weight", 0);
            
            -- Increment total weight immediately from what's in the field
            nArmorWeight = nArmorWeight + nWt;

            local tItem = ArmorData.lookupItem(sItemName);
            if tItem then
                -- Still use lookup for metadata like AV and ENC penalty
                -- but we already counted the weight from the field above.
                nArmorPenalty = nArmorPenalty + (tItem.enc or 0);
                local tMat = ArmorData.Materials[tItem.material];

                for sLoc, sCov in pairs(tItem.cov) do
                    if locData[sLoc] then
                        table.insert(locData[sLoc].materials, tItem.material);
                        locData[sLoc].layerCount = locData[sLoc].layerCount + 1;

                        local bRigid = (sCov == "R");
                        if sCov == "Y" or sCov == "R" then
                            applyAV(locData[sLoc].front, tMat, bRigid);
                            applyAV(locData[sLoc].back, tMat, bRigid);
                        elseif sCov == "F" then
                            applyAV(locData[sLoc].front, tMat, bRigid);
                        elseif sCov == "B" then
                            applyAV(locData[sLoc].back, tMat, bRigid);
                        end
                    end
                end
            end
        end
    end

        -- 3. Calculate Bulk and Layering Encumbrance
    local nBulk, nExtraEnc, bError = calculateBulkAndLayering(nodeChar, locData);
    
    -- 4. Update Database
    updateBodyLocations(nodeChar, locData);
    
    -- Update Encumbrance and Bulk
    -- nExtraEnc is from Padded1/Quilted1 matching profiles (+5)
    local nFinalArmorPenalty = nArmorPenalty + nExtraEnc;
    
    safeSetValue(nodeChar, "armour_enc", "number", nFinalArmorPenalty);
    safeSetValue(nodeChar, "armour_weight_total", "float", nArmorWeight);
    
    if bError then
        safeSetValue(nodeChar, "bulk_str", "string", "ERR");
    else
        safeSetValue(nodeChar, "bulk_str", "string", tostring(nBulk));
    end

    -- Cleanup legacy bulk node if it exists to prevent confusion/errors
    if nodeChar.getChild("bulk") then
        nodeChar.getChild("bulk").delete();
    end

    -- Ensure gear is also recalculated to get latest total
    calculateGear(nodeChar);
end

-- New matching and bulk logic
function calculateBulkAndLayering(nodeChar, locData)
    local zones = { "Head", "Arms", "Torso", "Legs" };
    local zoneItems = {};
    for _, z in ipairs(zones) do zoneItems[z] = {}; end

    -- Group items by zone
    -- We need to know which items are in which zone to check suffixes correctly.
    -- We'll use the materials collected in locData but with more metadata.
    -- To avoid duplicates in a zone (same item covering multiple locs in same zone), we track by item node path.
    
    local nodeArmourList = nodeChar.getChild("armourlist");
    if nodeArmourList then
        for _, nodeItem in pairs(nodeArmourList.getChildren()) do
            local sName = DB.getValue(nodeItem, "name", "");
            local tItem = ArmorData.lookupItem(sName);
            if tItem then
                local bSuffix1 = ArmorData.isSpecialItem1(sName);
                local tZonesSeen = {};

                for sLoc, _ in pairs(tItem.cov) do
                    local sZone = getZoneFromLoc(sLoc);
                    if sZone and not tZonesSeen[sZone] then
                        tZonesSeen[sZone] = true;
                        table.insert(zoneItems[sZone], {
                            mat = tItem.material,
                            isSuffix1 = bSuffix1,
                            name = sName
                        });
                    end
                end
            end
        end
    end

    local nTotalBulk = 0;
    local bAnyError = false;
    local bHasExtraEnc = false;

    for _, sZone in ipairs(zones) do
        local tItems = zoneItems[sZone];
        if #tItems > 0 then
            local nZoneBulk, bZoneExtraEnc, bZoneError = calculateZoneBulk(sZone, tItems);
            if bZoneError then
                bAnyError = true;
            else
                nTotalBulk = nTotalBulk + nZoneBulk;
                if bZoneExtraEnc then bHasExtraEnc = true; end
            end
        end
    end

    return nTotalBulk, (bHasExtraEnc and 5 or 0), bAnyError;
end

function calculateZoneBulk(sZone, tItems)
    -- 1. Try exact profile match
    local bMatch, bExtraEnc = matchProfile(sZone, tItems);
    if bMatch then
        return 0, bExtraEnc, false;
    end

    -- 2. Try minor violation (-5 penalty)
    -- Violation if removing one Cloth or Padded item results in a match.
    for i, tItem in ipairs(tItems) do
        if tItem.mat == "Cloth" or tItem.mat == "Padded" then
            -- Create subset without this item
            local tSubset = {};
            for j, v in ipairs(tItems) do if i ~= j then table.insert(tSubset, v); end end
            
            local bSubMatch, bSubExtraEnc = matchProfile(sZone, tSubset);
            if bSubMatch then
                -- Penalize -5 per location in zone? 
                -- User: "receives a -5 bulk penalty for the arms and a -5 bulk penalty for the legs"
                -- I'll return -5 for the zone.
                return -5, bSubExtraEnc, false;
            end
        end
    end

    -- 3. Major violation
    return 0, false, true;
end

function matchProfile(sZone, tItems)
    if #tItems == 0 then return true, false; end
    
    local bIsArmsOrLegs = (sZone == "Arms" or sZone == "Legs");

    for _, tProfile in ipairs(ArmorData.Profiles) do
        if #tProfile == #tItems then
            -- Try to match materials and suffixes
            -- Since the items can be in any order, we try permutations or a greedy match.
            -- With max 4 items, let's just do a simple recursive match.
            local bMatched, bExtraEnc = checkMatchRecursive(tProfile, tItems, 1, {}, bIsArmsOrLegs);
            if bMatched then
                return true, bExtraEnc;
            end
        end
    end
    return false, false;
end

function checkMatchRecursive(tProfile, tItems, nIdx, tUsed, bIsArmsOrLegs)
    if nIdx > #tProfile then return true, false; end

    local tSlot = tProfile[nIdx];
    for i, tItem in ipairs(tItems) do
        if not tUsed[i] then
            -- Check material
            if tItem.mat == tSlot.m then
                -- Check Suffix 1 (Cloth1/Padded1/Quilted1)
                local bSuffix1OK = true;
                if tSlot.s == 1 then
                    bSuffix1OK = tItem.isSuffix1;
                end

                -- Check Suffix 2 (Kurbul2/Plate2)
                local bSuffix2OK = true;
                if tSlot.s == 2 then
                    bSuffix2OK = bIsArmsOrLegs;
                end

                if bSuffix1OK and bSuffix2OK then
                    tUsed[i] = true;
                    local bRes, bEnc = checkMatchRecursive(tProfile, tItems, nIdx + 1, tUsed, bIsArmsOrLegs);
                    if bRes then
                        -- Check for extra enc if this matched a Suffix 1 slot with Padded/Quilted
                        local bThisExtra = (tSlot.s == 1 and (tItem.mat == "Padded" or tItem.mat == "Quilted"));
                        return true, bEnc or bThisExtra;
                    end
                    tUsed[i] = false;
                end
            end
        end
    end
    return false, false;
end

function getZoneFromLoc(sLoc)
    -- FO = Forearm, FT = Foot (as per user's correction)
    -- Skull, Face, Neck -> Head
    -- Shoulder, Upper Arm, Elbow, Forearm (FO), Hand -> Arms
    -- Thorax, Abdomen, Pelvis -> Torso
    -- Thigh, Knee, Calf, Foot (FT) -> Legs
    
    for sZone, tLocs in pairs(ArmorData.BodyZones) do
        for _, sZLoc in ipairs(tLocs) do
            if sZLoc == sLoc then return sZone; end
        end
    end
    return nil;
end

-- Sum up all possessions weight and calculate Gear ENC
function calculateGear(nodeChar)
    if not nodeChar then return; end

    local nTotalPossWeight = 0;
    local nodeGearList = nodeChar.getChild("possessions");
    if nodeGearList then
        for _, nodeItem in pairs(nodeGearList.getChildren()) do
            nTotalPossWeight = nTotalPossWeight + DB.getValue(nodeItem, "total_weight", 0);
        end
    end

    -- Sum weights: Possessions + Armour
    local nArmorWeight = DB.getValue(nodeChar, "armour_weight_total", 0);
    local nTotalWeight = nTotalPossWeight + nArmorWeight;

    Debug.console("Gear: Total weight = " .. tostring(nTotalWeight) .. " (Poss=" .. tostring(nTotalPossWeight) .. ", Armor=" .. tostring(nArmorWeight) .. ")");

    -- Gear Encumbrance = floor(Total weight / 20) * 5
    local nGearEnc = math.floor(nTotalWeight / 20) * 5;
    safeSetValue(nodeChar, "gear_enc", "number", nGearEnc);

    -- Update Totals
    -- Strength Encumbrance Modifier: 25 - (floor(STR / 2) * 5)
    local nStrScore = DB.getValue(nodeChar, "str_score", 10);
    local nStrEncMod = 25 - (math.floor(nStrScore / 2) * 5);
    safeSetValue(nodeChar, "strmod", "number", nStrEncMod);

    local nArmorEnc = DB.getValue(nodeChar, "armour_enc", 0);
    local nEncTotal = nArmorEnc + nGearEnc + nStrEncMod;
    
    safeSetValue(nodeChar, "enc_total", "number", nEncTotal);
    
    local nBulk = 0;
    local sBulk = DB.getValue(nodeChar, "bulk_str", "0");
    if sBulk == "ERR" then
        -- Handle ERR state? For now, treated as 0 in math, but blocks worn calc.
    else
        nBulk = tonumber(sBulk) or 0;
    end
    
    safeSetValue(nodeChar, "pf", "number", nEncTotal + nBulk);
end

-- Helper to sum AV values
function applyAV(tTarget, tMat, bRigid)
    if not tMat then return; end
    tTarget.b = tTarget.b + (tMat.b or 0);
    tTarget.e = tTarget.e + (tMat.e or 0);
    tTarget.p = tTarget.p + (tMat.p or 0);
    tTarget.f = tTarget.f + (tMat.f or 0);
    if bRigid then
        tTarget.rigid = true;
    end
end

-- Check layering violations per Body Zone
function checkZoneRestrictions(sZone, tZoneLocs, locData)
    for _, sLoc in ipairs(tZoneLocs) do
        local tLoc = locData[sLoc];
        if tLoc then
            -- Layer Count Check
            if tLoc.layerCount > 4 then return true; end -- HMK limit is typically 4

            -- Material Sequence Check
            if tLoc.layerCount > 1 then
                for i = 2, tLoc.layerCount do
                    local prevMat = tLoc.materials[i-1];
                    local currMat = tLoc.materials[i];
                    
                    local tRes = ArmorData.Layering[currMat];
                    if tRes then
                        local bAllowed = false;
                        for _, allowedUnder in ipairs(tRes.under) do
                            if allowedUnder == prevMat then
                                bAllowed = true;
                                break;
                            end
                        end
                        -- If not allowed under, check if it's the "same" material (some allowed)
                        -- or if it's explicitly disallowed. 
                        -- For now, if it's not in the 'under' list, it's a violation.
                        if not bAllowed then return true; end
                    end
                end
            end
        end
    end
    return false;
end

-- Update tab_combat bodylocations
function updateBodyLocations(nodeChar, locData)
    local nodeList = nodeChar.getChild("bodylocations");
    if not nodeList then return; end

    for _, nodeLoc in pairs(nodeList.getChildren()) do
        local sLocName = DB.getValue(nodeLoc, "location", "");
        local tData = locData[sLocName];
        if tData then
            -- Format AV strings for B, E, P, F
            DB.setValue(nodeLoc, "av_b", "string", formatAVPipe(tData.front.b, tData.back.b));
            DB.setValue(nodeLoc, "av_e", "string", formatAVPipe(tData.front.e, tData.back.e));
            DB.setValue(nodeLoc, "av_p", "string", formatAVPipe(tData.front.p, tData.back.p));
            DB.setValue(nodeLoc, "av_f", "string", formatAVPipe(tData.front.f, tData.back.f));
            
            -- Set rigid flag for bolding
            local bIsRigid = tData.front.rigid or tData.back.rigid;
            DB.setValue(nodeLoc, "is_rigid", "number", bIsRigid and 1 or 0);
        end
    end
end

-- Format Front|Back pipe notation
function formatAVPipe(nFront, nBack)
    if nFront == nBack then
        return tostring(nFront);
    else
        return string.format("%d|%d", nFront, nBack);
    end
end
