--
-- HMK Gear Tab Script
--

function onInit()
    local node = getDatabaseNode();
    if node then
        DB.addHandler(DB.getPath(node, "strmod"), "onUpdate", onDataUpdate);
    end
end

function onClose()
    local node = getDatabaseNode();
    if node then
        DB.removeHandler(DB.getPath(node, "strmod"), "onUpdate", onDataUpdate);
    end
end

function onDataUpdate()
    local node = getDatabaseNode();
    if node then
        ArmorManager.calculateGear(node);
    end
end
