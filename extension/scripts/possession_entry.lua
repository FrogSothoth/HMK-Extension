-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    Debug.console("Harn: Possession entry initialized.");
    local node = getDatabaseNode();
    if not node then
        return;
    end

    -- Set up handlers for calculation
    -- We use DB handlers to catch all updates (local and remote)
    local sQtyPath = DB.getPath(node, "quantity");
    local sWtPath = DB.getPath(node, "weight");
    local sNamePath = DB.getPath(node, "name");

    DB.addHandler(sQtyPath, "onUpdate", onBalanceUpdate);
    DB.addHandler(sWtPath, "onUpdate", onBalanceUpdate);
    DB.addHandler(sNamePath, "onUpdate", onNameUpdate);

    -- Initial calculation
    onBalanceUpdate();
end

function onClose()
    local node = getDatabaseNode();
    if node then
        local sQtyPath = DB.getPath(node, "quantity");
        local sWtPath = DB.getPath(node, "weight");
        local sNamePath = DB.getPath(node, "name");

        DB.removeHandler(sQtyPath, "onUpdate", onBalanceUpdate);
        DB.removeHandler(sWtPath, "onUpdate", onBalanceUpdate);
        DB.removeHandler(sNamePath, "onUpdate", onNameUpdate);
    end
end

function onNameUpdate()
    -- Guard against script not being loaded
    if not EquipmentData then 
        return; 
    end

    -- Defensive check for control existence
    if not name or not weight then
        return;
    end

    local sName = name.getValue();
    if sName == "" then return; end

    -- Log to console for debugging
    Debug.console("Gear: Searching for item: " .. sName);

    local tItem, sFullName = EquipmentData.lookupItem(sName);
    
    if tItem and sFullName then
        Debug.console("Gear: Found item: " .. sFullName .. " (Weight: " .. tostring(tItem.weight) .. ")");
        
        -- Autocomplete the name if it's different
        if sName ~= sFullName then
            name.setValue(sFullName);
            
            -- If we autocompleted, we assume the user wants the data for this item
            -- So we overwrite the weight regardless of its previous value
            weight.setValue(tItem.weight);
            
            -- If quantity is 0 or nil, default it to 1 since we just found a valid item
            if quantity.getValue() == 0 then
                quantity.setValue(1);
            end
            
            -- Force a balance update
            onBalanceUpdate();
        end
    else
        Debug.console("Gear: No item found for: " .. sName);
    end
end

function onBalanceUpdate()
    -- Defensive checks
    if not quantity or not weight or not total_weight then
        return;
    end

    local nQty = quantity.getValue();
    local nWt = weight.getValue();
    
    -- Calculate Total Weight
    local nTotal = nQty * nWt;
    ArmorManager.safeSetValue(node, "total_weight", "number", nTotal);

    -- Trigger sheet-wide calculation
    local nodeChar = DB.getParent(DB.getParent(node));
    if nodeChar then
        ArmorManager.calculateGear(nodeChar);
    end
end
