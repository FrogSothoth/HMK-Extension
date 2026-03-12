--
-- HMK Gear Tab Script
--

function onInit()
    local node = getDatabaseNode();
    if node then
        DB.addHandler(DB.getPath(node, "strmod"), "onUpdate", onDataUpdate);
        
        -- Add handler for item deletion in possessions
        local sPossessionsPath = DB.getPath(node, "possessions");
        DB.addHandler(sPossessionsPath, "onChildDeleted", onPossessionsDelete);
    end
end

function onClose()
    local node = getDatabaseNode();
    if node then
        DB.removeHandler(DB.getPath(node, "strmod"), "onUpdate", onDataUpdate);

        -- Remove handler for item deletion in possessions
        local sPossessionsPath = DB.getPath(node, "possessions");
        DB.removeHandler(sPossessionsPath, "onChildDeleted", onPossessionsDelete);
    end
end

function onDataUpdate()
    local node = getDatabaseNode();
    if node then
        ArmorManager.calculateGear(node);
    end
end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local class, datasource = draginfo.getShortcutData();
		if class == "item" then
			local nodeItem = DB.findNode(datasource);
			if nodeItem then
				addItem(nodeItem);
			end
			return true;
		end
	end
end

function addItem(nodeItem)
	local sName = DB.getValue(nodeItem, "name", "");
	local nWeight = DB.getValue(nodeItem, "weight", 0);
	
	-- Get category from multiple possible sources
	local sCategory = DB.getValue(nodeItem, "category", "");
	if sCategory == "" then
		sCategory = DB.getCategory(DB.getPath(nodeItem)) or "";
	end
	
	-- Trim and sanitize category search
	local sCategorySearch = sCategory:gsub("^%s*(.-)%s*$", "%1"):upper();
	
	-- Check if it is Armour/Clothing
	local bIsArmour = (sCategorySearch == "ARMOUR/CLOTHING");
	
	-- Fallback to ArmorData lookup if DB category didn't catch it
	if not bIsArmour then
		if ArmorData and ArmorData.lookupItem then
			if ArmorData.lookupItem(sName) then
				bIsArmour = true;
			end
		end
	end

	local nodeChar = getDatabaseNode();
	if not nodeChar then return; end

	if bIsArmour then
		local nodeEntry = DB.createChild(DB.createChild(nodeChar, "armourlist"));
		DB.setValue(nodeEntry, "name", "string", sName);
		DB.setValue(nodeEntry, "weight", "number", nWeight);
	else
		-- Check if item already exists in possessions
		local bFound = false;
		local nodePossessions = DB.createChild(nodeChar, "possessions");
		for _,v in pairs(DB.getChildren(nodePossessions)) do
			if DB.getValue(v, "name", "") == sName then
				local nQty = DB.getValue(v, "quantity", 1);
				DB.setValue(v, "quantity", "number", nQty + 1);
				bFound = true;
				break;
			end
		end

		if not bFound then
			local nodeEntry = DB.createChild(nodePossessions);
			DB.setValue(nodeEntry, "name", "string", sName);
			DB.setValue(nodeEntry, "weight", "number", nWeight);
			DB.setValue(nodeEntry, "quantity", "number", 1);
		end

        -- Trigger weapon list synchronization
        if MeleeData then
            MeleeData.syncMeleeWeapons(nodeChar);
        end
        if MissileData then
            MissileData.syncMissileWeapons(nodeChar);
        end
	end
end

function onPossessionsDelete(nodeDeleted)
    local nodeChar = DB.getParent(DB.getParent(nodeDeleted));
    if nodeChar then
        if MeleeData then
            MeleeData.syncMeleeWeapons(nodeChar, nodeDeleted);
        end
        if MissileData then
            MissileData.syncMissileWeapons(nodeChar, nodeDeleted);
        end
    end
end
