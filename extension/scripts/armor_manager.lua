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

    -- 3. Calculate Bulk Penalties
    local nTotalBulk = 0;
    for sLoc, tData in pairs(locData) do
        nTotalBulk = nTotalBulk + calculateLocationBulk(tData.materials);
    end

    -- 4. Update Database
    updateBodyLocations(nodeChar, locData);
    
    -- Update Encumbrance and Bulk
    -- HMK: armour_enc field contains summed ENC from items, Bulk contains penalties
    safeSetValue(nodeChar, "armour_enc", "number", nArmorPenalty);
    safeSetValue(nodeChar, "armour_weight_total", "float", nArmorWeight);
    safeSetValue(nodeChar, "bulk", "number", nTotalBulk);

    -- Ensure gear is also recalculated to get latest total
    calculateGear(nodeChar);
end

-- Bulk penalty based on AmorProfiles.csv
function calculateLocationBulk(tMaterials)
    if #tMaterials == 0 then return 0; end

    -- Count total Cloth/Padded in worn materials
    local nLightWorn = 0;
    local tHeavyWorn = {};
    for _, sMat in ipairs(tMaterials) do
        if sMat == "Cloth" or sMat == "Padded" then
            nLightWorn = nLightWorn + 1;
        else
            table.insert(tHeavyWorn, sMat);
        end
    end

    -- Find best matching profile (exact match of heavy materials)
    local nMaxLightInProfile = 0;
    local bHeavyMatchFound = false;

    for _, tProfile in ipairs(ArmorData.Profiles) do
        local nLightInProfile = 0;
        local tHeavyInProfile = {};
        for _, sPMat in ipairs(tProfile) do
            if sPMat == "Cloth" or sPMat == "Padded" then
                nLightInProfile = nLightInProfile + 1;
            else
                table.insert(tHeavyInProfile, sPMat);
            end
        end

        -- Check if heavy materials match exactly (order doesn't matter for bulk penalty logic usually, but here we assume set match)
        if #tHeavyInProfile == #tHeavyWorn then
            local bMatch = true;
            local tTempHeavy = {};
            for _, v in ipairs(tHeavyWorn) do tTempHeavy[v] = (tTempHeavy[v] or 0) + 1; end
            for _, v in ipairs(tHeavyInProfile) do
                if not tTempHeavy[v] or tTempHeavy[v] == 0 then
                    bMatch = false;
                    break;
                else
                    tTempHeavy[v] = tTempHeavy[v] - 1;
                end
            end

            if bMatch then
                bHeavyMatchFound = true;
                if nLightInProfile > nMaxLightInProfile then
                    nMaxLightInProfile = nLightInProfile;
                end
            end
        end
    end

    -- If no profile matches the heavy configuration at all, use 0 as base light count?
    -- Actually, most sets are covered. If not covered, assume base is 0.
    local nExtra = nLightWorn - nMaxLightInProfile;
    if nExtra > 0 then
        return nExtra * -5;
    end

    return 0;
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
    
    -- PF is separate from Total ENC as per user's "Bulk handled separately" note?
    -- Actually user says: "ENC entry in Encumbrance, then, is the sum of Armour,Gear,and STR Mod."
    -- In prior code PF was EncTotal + Bulk. I'll keep Bulk (penalties) separate for now.
    -- If user wants PF updated I will, but they didn't mention it in the breakdown.
    local nBulk = DB.getValue(nodeChar, "bulk", 0);
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
