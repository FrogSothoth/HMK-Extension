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
    local sLocPath = DB.getPath(node, "location");

    DB.addHandler(sQtyPath, "onUpdate", onBalanceUpdate);
    DB.addHandler(sWtPath, "onUpdate", onBalanceUpdate);
    DB.addHandler(sLocPath, "onUpdate", onBalanceUpdate);

    -- Handle name lookup on focus loss (not every keystroke)
    if name then
        name.onLoseFocus = onNameLoseFocus;
    end

    -- Initial calculation
    onBalanceUpdate();
end

function onClose()
    local node = getDatabaseNode();
    if node then
        local sQtyPath = DB.getPath(node, "quantity");
        local sWtPath = DB.getPath(node, "weight");
        local sLocPath = DB.getPath(node, "location");

        DB.removeHandler(sQtyPath, "onUpdate", onBalanceUpdate);
        DB.removeHandler(sWtPath, "onUpdate", onBalanceUpdate);
        DB.removeHandler(sLocPath, "onUpdate", onBalanceUpdate);
    end
end

function onNameLoseFocus()
    Debug.console("Possession: Name field lost focus.");
    onNameUpdate();
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

        -- Update weight from standard equipment data
        weight.setValue(tItem.weight);

        -- If quantity is 0 or nil, default it to 1 since we just found a valid item
        if quantity.getValue() == 0 then
            quantity.setValue(1);
        end

        -- Force a balance update
        onBalanceUpdate();
    else
        Debug.console("Gear: No item found for: " .. sName);
    end

    -- Always sync weapons on name change (handles both add and rename-away cases)
    local node = getDatabaseNode();
    if node then
        local nodeChar = DB.getParent(DB.getParent(node));
        if nodeChar then
            if MeleeData then
                MeleeData.syncMeleeWeapons(nodeChar);
            end
            if MissileData then
                MissileData.syncMissileWeapons(nodeChar);
            end
        end
    end
end

function onBalanceUpdate()
    local node = getDatabaseNode();
    if not node then
        return;
    end

    -- Defensive checks
    if not quantity or not weight or not total_weight then
        return;
    end

    local nQty = quantity.getValue();
    local nWt = weight.getValue();
    local sLocRaw = DB.getValue(node, "location", "");
    local sLoc = sLocRaw:match("^%s*(.-)%s*$");

    -- Calculate Total Weight
    local nTotal = nQty * nWt;

    -- Check for Backpack reduction
    -- Case-insensitive check for "Backpack"
    if sLoc:lower() == "backpack" then
        nTotal = nTotal / 2;
        Debug.console("Gear: Reducing weight for " .. name.getValue() .. " (Location: " .. sLoc .. ") to " .. tostring(nTotal));

        -- Update display for backpack items
        if total_weight_display then
            -- Format to 2 decimals, then remove trailing zeros and decimal point
            local sDisplay = string.format("%.2f", nTotal);
            sDisplay = sDisplay:gsub("0+$", "");
            sDisplay = sDisplay:gsub("%.$", "");

            total_weight_display.setValue("(" .. sDisplay .. ")");
            total_weight_display.setVisible(true);
            total_weight.setVisible(false);
        end
    else
        -- Standard display
        if total_weight_display then
            total_weight_display.setVisible(false);
            total_weight.setVisible(true);
        end
    end

    -- Update DB directly
    DB.setValue(node, "total_weight", "number", nTotal);

    -- Trigger sheet-wide calculation
    local nodeChar = DB.getParent(DB.getParent(node));
    if nodeChar then
        ArmorManager.calculateGear(nodeChar);
    end
end
