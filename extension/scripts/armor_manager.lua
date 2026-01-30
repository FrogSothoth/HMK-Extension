--
-- HMK Armor Manager
-- Handles AV calculations, stacking, Bulk penalties, and ENC/PF.
--

function onInit()
    -- Global registry happens in harn_manager.lua
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
            local tItem = ArmorData.lookupItem(sItemName);

            if tItem then
                nArmorWeight = nArmorWeight + (tItem.weight or 0);
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
    for sZone, tZoneLocs in pairs(ArmorData.BodyZones) do
        if checkZoneRestrictions(sZone, tZoneLocs, locData) then
            nTotalBulk = nTotalBulk + 5;
        end
    end

    -- 4. Update Database
    updateBodyLocations(nodeChar, locData);
    
    -- Update Encumbrance and Bulk
    -- HMK: Armour field contains weight, Bulk contains penalties
    DB.setValue(nodeChar, "armour_enc", "number", math.floor(nArmorWeight + 0.5));
    DB.setValue(nodeChar, "bulk", "number", nArmorPenalty + nTotalBulk);

    -- Ensure gear is also recalculated to get latest total
    calculateGear(nodeChar);
end

-- Sum up all possessions weight
function calculateGear(nodeChar)
    if not nodeChar then return; end

    local nGearEnc = 0;
    local nodeGearList = nodeChar.getChild("possessions");
    if nodeGearList then
        for _, nodeItem in pairs(nodeGearList.getChildren()) do
            nGearEnc = nGearEnc + DB.getValue(nodeItem, "total_weight", 0);
        end
    end

    DB.setValue(nodeChar, "gear_enc", "number", nGearEnc);

    -- Update Totals
    local nArmorEnc = DB.getValue(nodeChar, "armour_enc", 0);
    local nBulk = DB.getValue(nodeChar, "bulk", 0);
    local nEncTotal = nArmorEnc + nGearEnc;
    
    DB.setValue(nodeChar, "enc_total", "number", nEncTotal);
    DB.setValue(nodeChar, "pf", "number", nEncTotal + nBulk);
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
