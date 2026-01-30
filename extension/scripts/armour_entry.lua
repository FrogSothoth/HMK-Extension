--
-- HMK Armour Entry
-- Handles autofill from armor_data.lua and triggers sheet-wide calculations.
--

local bLocked = false;

function onInit()
    local node = getDatabaseNode();
    if not node then return; end

    -- Handle name changes for autofill
    local sNamePath = DB.getPath(node, "name");
    DB.addHandler(sNamePath, "onUpdate", onNameUpdate);

    -- Trigger sheet-wide calculation when name or weight changes
    DB.addHandler(sNamePath, "onUpdate", onDataUpdate);
    DB.addHandler(DB.getPath(node, "weight"), "onUpdate", onDataUpdate);
end

function onClose()
    local node = getDatabaseNode();
    if node then
        local sNamePath = DB.getPath(node, "name");
        DB.removeHandler(sNamePath, "onUpdate", onNameUpdate);
        DB.removeHandler(sNamePath, "onUpdate", onDataUpdate);
        DB.removeHandler(DB.getPath(node, "weight"), "onUpdate", onDataUpdate);
    end
end

function onNameUpdate()
    if bLocked then return; end
    if not ArmorData then return; end
    
    -- Defensive check for control existence
    if not name or not weight then
        return;
    end

    local sName = name.getValue();
    if sName == "" then return; end

    -- Log to console for debugging
    Debug.console("Armour: Searching for item: " .. sName);

    local tItem, sFullName = ArmorData.lookupItem(sName);
    
    if tItem and sFullName then
        Debug.console("Armour: Found item: " .. sFullName .. " (Weight: " .. tostring(tItem.weight) .. ")");
        
        bLocked = true;
        
        -- Store hidden attributes on the node for ArmorManager
        local node = getDatabaseNode();
        DB.setValue(node, "material", "string", tItem.material);
        DB.setValue(node, "enc_penalty", "number", tItem.enc or 0);
        DB.setValue(node, "price", "number", tItem.price or 0);
        
        -- Set weight and autocomplete name
        weight.setValue(tItem.weight);
        if sName ~= sFullName then
            name.setValue(sFullName);
        end
        
        bLocked = false;
        
        -- Trigger calculation since we updated weight/metadata
        onDataUpdate();
    else
        Debug.console("Armour: No item found for: " .. sName);
    end
end

function onDataUpdate()
    -- Only trigger if not locked (to avoid multiple calls during autofill)
    if bLocked then return; end

    -- Trigger character-wide armor calculation
    local node = getDatabaseNode();
    local nodeChar = DB.getParent(DB.getParent(node));
    
    if nodeChar then
        ArmorManager.calculateArmor(nodeChar);
    end
end
