--
-- HMK Armour Entry
-- Handles autofill from armor_data.lua and triggers sheet-wide calculations.
--

local bLocked = false;

function onInit()
    Debug.console("Armour: Entry initialized.");
    local node = getDatabaseNode();
    if not node then return; end

    -- Handle focus for autofill (UI Event instead of Data Handler)
    if name then
        name.onLoseFocus = onNameLoseFocus;
    end

    -- Trigger character-wide armor calculation when weight node changes in DB
    DB.addHandler(DB.getPath(node, "weight"), "onUpdate", onDataUpdate);
end

function onClose()
    local node = getDatabaseNode();
    if node then
        DB.removeHandler(DB.getPath(node, "weight"), "onUpdate", onDataUpdate);
    end
end

function onNameLoseFocus()
    Debug.console("Armour: Name field lost focus.");
    onNameUpdate();
end

function onNameUpdate()
    if bLocked then return; end
    if not ArmorData then 
        Debug.console("Armour: Error - ArmorData script not found.");
        return; 
    end
    
    if not name or not weight then return; end

    local sName = name.getValue();
    if sName == "" then 
        ArmorManager.safeSetValue(getDatabaseNode(), "weight", "number", 0);
        onDataUpdate();
        return; 
    end

    local tItem, sFullName = ArmorData.lookupItem(sName);
    
    if tItem and sFullName then
        Debug.console("Armour: Match found - " .. sFullName);
        Debug.console("Armour: Data weight = " .. tostring(tItem.weight));
        
        bLocked = true;
        
        local node = getDatabaseNode();
        ArmorManager.safeSetValue(node, "material", "string", tItem.material);
        ArmorManager.safeSetValue(node, "enc_penalty", "number", tItem.enc or 0);
        ArmorManager.safeSetValue(node, "price", "number", tItem.price or 0);
        
        -- Write the weight and verify immediately
        Debug.console("Armour: Writing weight " .. tostring(tItem.weight) .. " to DB...");
        ArmorManager.safeSetValue(node, "weight", "number", tItem.weight);
        
        local nDBValue = DB.getValue(node, "weight", -1);
        Debug.console("Armour: DB verified value = " .. tostring(nDBValue));
        
        if sName ~= sFullName then
            name.setValue(sFullName);
        end
        
        bLocked = false;
        onDataUpdate();
    else
        Debug.console("Armour: No match for '" .. sName .. "'");
    end
end

function onDataUpdate()
    if bLocked then return; end
    local node = getDatabaseNode();
    local nodeChar = DB.getParent(DB.getParent(node));
    if nodeChar then
        ArmorManager.calculateArmor(nodeChar);
    end
end
