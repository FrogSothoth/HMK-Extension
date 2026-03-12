--
-- HMK Armor Data
-- Based on ArmorValues.csv, ArmorItems.csv, and ArmorProfiles.csv
--

-- Material AV values (B, E, P, F)
Materials = {
    ["Cloth"]    = { b = 0, e = 1, p = 0, f = 1 },
    ["Leather"]  = { b = 1, e = 2, p = 1, f = 3 },
    ["Padded"]   = { b = 2, e = 2, p = 1, f = 2 },
    ["Quilted"]  = { b = 4, e = 3, p = 2, f = 3 },
    ["Gambeson"] = { b = 6, e = 5, p = 4, f = 5 },
    ["Kurbul"]   = { b = 4, e = 6, p = 5, f = 4 },
    ["Scale"]    = { b = 4, e = 8, p = 5, f = 5 },
    ["Mail"]     = { b = 2, e = 8, p = 7, f = 3 },
    ["Plate"]    = { b = 6, e = 11, p = 9, f = 5 },
}

-- Body Zones and Locations Mapping
BodyZones = {
    ["Head"]  = { "Skull", "Face", "Neck" },
    ["Arms"]  = { "Shoulder", "Upper Arm", "Elbow", "Forearm", "Hand" },
    ["Torso"] = { "Thorax", "Abdomen", "Pelvis" },
    ["Legs"]  = { "Thigh", "Knee", "Calf", "Foot" },
}

-- Hit Range Metadata
-- ZR = Zone Range, ZN = Zone Name, LR = Location Range
BodyLocationRanges = {
    ["Skull"]     = { zr = "1",    zn = "HEAD",  lr = "1-5" },
    ["Face"]      = { zr = "1",    zn = "HEAD",  lr = "6-8" },
    ["Neck"]      = { zr = "1",    zn = "HEAD",  lr = "9-10" },
    ["Shoulder"]  = { zr = "2-3",  zn = "ARMS",  lr = "1-3" },
    ["Upper Arm"] = { zr = "2-3",  zn = "ARMS",  lr = "4-6" },
    ["Elbow"]     = { zr = "2-3",  zn = "ARMS",  lr = "7" },
    ["Forearm"]   = { zr = "2-3",  zn = "ARMS",  lr = "8-9" },
    ["Hand"]      = { zr = "2-3",  zn = "ARMS",  lr = "10" },
    ["Thorax"]    = { zr = "4-7",  zn = "TORSO", lr = "1-4" },
    ["Abdomen"]   = { zr = "4-7",  zn = "TORSO", lr = "5-7" },
    ["Pelvis"]    = { zr = "4-7",  zn = "TORSO", lr = "8-10" },
    ["Thigh"]     = { zr = "8-10", zn = "LEGS",  lr = "1-4" },
    ["Knee"]      = { zr = "8-10", zn = "LEGS",  lr = "5" },
    ["Calf"]      = { zr = "8-10", zn = "LEGS",  lr = "6-8" },
    ["Foot"]      = { zr = "8-10", zn = "LEGS",  lr = "9-10" },
}

-- Layering Profiles (from ArmorProfiles.csv and user requirements)
-- Sequences that result in 0 Bulk penalty.
-- m = material name
-- s = suffix (1: Cloth1/Padded1/Quilted1, 2: Kurbul2/Plate2)
Profiles = {
    -- CLOTH
    { {m="Cloth"} },
    { {m="Cloth"}, {m="Cloth"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Cloth"} },
    { {m="Cloth"}, {m="Padded"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Padded"} },
    { {m="Cloth"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Cloth"}, {m="Quilted", s=1} },

    -- LEATHER
    { {m="Leather"} },
    { {m="Cloth"}, {m="Leather"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Leather"} },
    { {m="Padded"}, {m="Leather"} },
    { {m="Cloth"}, {m="Padded"}, {m="Leather"} },
    { {m="Leather"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Leather"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Leather"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Leather"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Leather"}, {m="Cloth", s=1} },

    -- PADDED
    { {m="Padded"} },
    { {m="Cloth"}, {m="Padded"} },
    { {m="Padded"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Padded"}, {m="Kurbul"} },
    { {m="Padded"}, {m="Plate"} },
    { {m="Cloth"}, {m="Padded"}, {m="Plate"} },
    { {m="Padded"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Plate"}, {m="Cloth", s=1} },

    -- QUILTED
    { {m="Quilted"} },
    { {m="Cloth"}, {m="Quilted"} },
    { {m="Quilted"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Quilted"}, {m="Cloth", s=1} },
    { {m="Quilted"}, {m="Kurbul", s=2} },
    { {m="Cloth"}, {m="Quilted"}, {m="Kurbul", s=2} },
    { {m="Quilted"}, {m="Plate", s=2} },
    { {m="Cloth"}, {m="Quilted"}, {m="Plate", s=2} },
    { {m="Quilted"}, {m="Kurbul", s=2}, {m="Cloth", s=1} },
    { {m="Quilted"}, {m="Plate", s=2}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Quilted"}, {m="Plate", s=2}, {m="Cloth", s=1} },

    -- GAMBESON
    { {m="Gambeson"} },
    { {m="Cloth"}, {m="Gambeson"} },
    { {m="Gambeson"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Gambeson"}, {m="Cloth", s=1} },

    -- KURBUL
    { {m="Cloth"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Kurbul"} },
    { {m="Padded"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Padded"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Kurbul"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Kurbul"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Kurbul"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Kurbul"}, {m="Quilted", s=1} },

    -- SCALE
    { {m="Cloth"}, {m="Scale"} },
    { {m="Padded"}, {m="Scale"} },
    { {m="Scale"}, {m="Kurbul", s=2} },
    { {m="Cloth"}, {m="Scale"}, {m="Kurbul", s=2} },
    { {m="Padded"}, {m="Scale"}, {m="Kurbul", s=2} },
    { {m="Scale"}, {m="Plate", s=2} },
    { {m="Cloth"}, {m="Scale"}, {m="Plate", s=2} },
    { {m="Padded"}, {m="Scale"}, {m="Plate", s=2} },
    { {m="Scale"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Scale"}, {m="Cloth", s=1} },
    { {m="Scale"}, {m="Kurbul", s=2}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Kurbul", s=2}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Scale"}, {m="Kurbul", s=2}, {m="Cloth", s=1} },
    { {m="Scale"}, {m="Plate", s=2}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Plate", s=2}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Scale"}, {m="Plate", s=2}, {m="Cloth", s=1} },
    { {m="Scale"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Padded", s=1} },
    { {m="Scale"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Quilted", s=1} },
    { {m="Scale"}, {m="Kurbul", s=2}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Kurbul", s=2}, {m="Padded", s=1} },
    { {m="Scale"}, {m="Kurbul", s=2}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Kurbul", s=2}, {m="Quilted", s=1} },
    { {m="Scale"}, {m="Plate", s=2}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Plate", s=2}, {m="Padded", s=1} },
    { {m="Scale"}, {m="Plate", s=2}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Scale"}, {m="Plate", s=2}, {m="Quilted", s=1} },

    -- MAIL
    { {m="Cloth"}, {m="Mail"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"} },
    { {m="Padded"}, {m="Mail"} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"} },
    { {m="Cloth"}, {m="Mail"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Kurbul"} },
    { {m="Padded"}, {m="Mail"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"}, {m="Kurbul"} },
    { {m="Cloth"}, {m="Mail"}, {m="Plate"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Plate"} },
    { {m="Padded"}, {m="Mail"}, {m="Plate"} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"}, {m="Plate"} },
    { {m="Cloth"}, {m="Mail"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Mail"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Mail"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"}, {m="Kurbul"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Mail"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Mail"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Kurbul"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Mail"}, {m="Plate"}, {m="Quilted", s=1} },

    -- PLATE
    { {m="Cloth"}, {m="Plate"} },
    { {m="Cloth"}, {m="Cloth"}, {m="Plate"} },
    { {m="Padded"}, {m="Plate"} },
    { {m="Cloth"}, {m="Padded"}, {m="Plate"} },
    { {m="Cloth"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Padded"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Padded"}, {m="Plate"}, {m="Cloth", s=1} },
    { {m="Cloth"}, {m="Plate"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Plate"}, {m="Padded", s=1} },
    { {m="Cloth"}, {m="Plate"}, {m="Quilted", s=1} },
    { {m="Cloth"}, {m="Cloth"}, {m="Plate"}, {m="Quilted", s=1} },
}

-- Special Item Identification
-- Cloth1/Padded1/Quilted1 must be one of these types
SpecialTypes1 = { "cloak", "mantle", "vest", "surcoat", "coat", "robe", "cuisse" }

function isSpecialItem1(sItemName)
    if not sItemName then return false; end
    local sLower = sItemName:lower();
    for _, sType in ipairs(SpecialTypes1) do
        if sLower:find(sType, 1, true) then
            return true;
        end
    end
    return false;
end

-- Item Data
-- Coverage symbols: Y=Yes, R=Rigid (Both), F=Front only, B=Back only
Items = {
    -- CLOTH
    ["Cap (Cloth)"]        = { material = "Cloth", price = 4,  weight = 0.2, enc = 0, cov = { Skull = "Y" } },
    ["Cowl (Cloth)"]       = { material = "Cloth", price = 6,  weight = 0.3, enc = 0, cov = { Skull = "Y", Neck = "Y" } },
    ["Mantle (Cloth)"]     = { material = "Cloth", price = 21, weight = 1.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Gauntlets (Cloth)"]  = { material = "Cloth", price = 5,  weight = 0.3, enc = 0, cov = { Hand = "Y" } },
    ["Vest (Cloth)"]       = { material = "Cloth", price = 24, weight = 1.2, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Shirt (Cloth)"]      = { material = "Cloth", price = 33, weight = 1.7, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Tunic (Cloth)"]      = { material = "Cloth", price = 45, weight = 2.3, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Tunic, Sleeved (Cloth)"] = { material = "Cloth", price = 50, weight = 2.5, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Coat (Cloth)"]       = { material = "Cloth", price = 64, weight = 3.2, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Surcoat (Cloth)"]    = { material = "Cloth", price = 54, weight = 2.7, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Cloak (Cloth)"]      = { material = "Cloth", price = 66, weight = 3.3, enc = 0, cov = { Shoulder = "Y", Thorax = "B", Abdomen = "B", Pelvis = "B", Thigh = "B", Knee = "B", Calf = "B" } },
    ["Robe (Cloth)"]       = { material = "Cloth", price = 79, weight = 4.0, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Breeches (Cloth)"]   = { material = "Cloth", price = 17, weight = 0.9, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y" } },
    ["Trousers (Cloth)"]   = { material = "Cloth", price = 39, weight = 2.0, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Leggings (Cloth)"]   = { material = "Cloth", price = 36, weight = 1.8, enc = 0, cov = { Thigh = "Y", Knee = "Y", Calf = "Y", Foot = "Y" } },
    ["Swaddle (Cloth)"]    = { material = "Cloth", price = 19, weight = 1.0, enc = 0, cov = { Calf = "Y", Foot = "Y" } },

    -- LEATHER
    ["Cap (Leather)"]      = { material = "Leather", price = 16, weight = 0.6, enc = 0, cov = { Skull = "Y" } },
    ["Bracers (Leather)"]  = { material = "Leather", price = 20, weight = 0.8, enc = 0, cov = { Forearm = "Y" } },
    ["Gauntlets (Leather)"] = { material = "Leather", price = 20, weight = 0.8, enc = 0, cov = { Hand = "Y" } },
    ["Vest (Leather)"]     = { material = "Leather", price = 96, weight = 3.6, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Long Vest (Leather)"] = { material = "Leather", price = 148, weight = 6.8, enc = 5, cov = { Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Boots (Leather)"]    = { material = "Leather", price = 176, weight = 2.9, enc = 0, cov = { Calf = "Y", Foot = "Y" } },
    ["Shoes (Leather)"]    = { material = "Leather", price = 28, weight = 1.1, enc = 0, cov = { Foot = "Y" } },

    -- PADDED
    ["Cap (Padded)"]       = { material = "Padded", price = 8,  weight = 0.3, enc = 0, cov = { Skull = "Y" } },
    ["Cowl (Padded)"]      = { material = "Padded", price = 12, weight = 0.5, enc = 5, cov = { Skull = "Y", Neck = "Y" } },
    ["Mantle (Padded)"]    = { material = "Padded", price = 42, weight = 1.7, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Mittens (Padded)"]   = { material = "Padded", price = 10, weight = 0.4, enc = 0, cov = { Hand = "Y" } },
    ["Vest (Padded)"]      = { material = "Padded", price = 48, weight = 1.9, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Shirt (Padded)"]     = { material = "Padded", price = 66, weight = 2.6, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Tunic (Padded)"]     = { material = "Padded", price = 90, weight = 3.6, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Tunic, Sleeved (Padded)"] = { material = "Padded", price = 100, weight = 4.0, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Coat (Padded)"]      = { material = "Padded", price = 128, weight = 5.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Surcoat (Padded)"]   = { material = "Padded", price = 108, weight = 4.3, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Cloak (Padded)"]     = { material = "Padded", price = 132, weight = 5.3, enc = 0, cov = { Shoulder = "Y", Thorax = "B", Abdomen = "B", Pelvis = "B", Thigh = "B", Knee = "B", Calf = "B" } },
    ["Cuisses (Padded)"]   = { material = "Padded", price = 34, weight = 1.4, enc = 0, cov = { Pelvis = "Y", Thigh = "Y" } },
    ["Trousers (Padded)"]  = { material = "Padded", price = 78, weight = 3.1, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Leggings (Padded)"]  = { material = "Padded", price = 72, weight = 2.9, enc = 0, cov = { Thigh = "Y", Knee = "Y", Calf = "Y", Foot = "Y" } },

    -- QUILTED
    ["Cap (Quilted)"]      = { material = "Quilted", price = 16, weight = 0.7, enc = 0, cov = { Skull = "Y" } },
    ["Cowl (Quilted)"]     = { material = "Quilted", price = 24, weight = 1.1, enc = 5, cov = { Skull = "Y", Neck = "Y" } },
    ["Mantle (Quilted)"]   = { material = "Quilted", price = 84, weight = 3.8, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Vest (Quilted)"]     = { material = "Quilted", price = 96, weight = 4.3, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Shirt (Quilted)"]    = { material = "Quilted", price = 132, weight = 5.9, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Tunic (Quilted)"]    = { material = "Quilted", price = 180, weight = 8.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Tunic, Sleeved (Quilted)"] = { material = "Quilted", price = 200, weight = 9.0, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Coat (Quilted)"]     = { material = "Quilted", price = 256, weight = 11.5, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Surcoat (Quilted)"]  = { material = "Quilted", price = 216, weight = 9.7, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Cuisses (Quilted)"]  = { material = "Quilted", price = 68, weight = 3.1, enc = 0, cov = { Pelvis = "Y", Thigh = "Y" } },

    -- GAMBESON
    ["Vest (Gambeson)"]    = { material = "Gambeson", price = 208, weight = 7.3, enc = 0, cov = { Thorax = "R", Abdomen = "R" } },
    ["Shirt (Gambeson)"]   = { material = "Gambeson", price = 280, weight = 9.8, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "R", Abdomen = "R" } },
    ["Long Vest (Gambeson)"] = { material = "Gambeson", price = 312, weight = 10.9, enc = 5, cov = { Shoulder = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Tunic (Gambeson)"]   = { material = "Gambeson", price = 376, weight = 13.2, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Tunic, Sleeved (Gambeson)"] = { material = "Gambeson", price = 416, weight = 14.6, enc = 10, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Coat (Gambeson)"]    = { material = "Gambeson", price = 528, weight = 18.5, enc = 10, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },

    -- KURBUL
    ["Helm (Kurbul)"]      = { material = "Kurbul", price = 20, weight = 3.0, enc = 0, cov = { Skull = "R" } },
    ["3/4-Helm (Kurbul)"]  = { material = "Kurbul", price = 35, weight = 5.3, enc = 5, cov = { Skull = "R", Face = "R" } },
    ["Spaulders (Kurbul)"] = { material = "Kurbul", price = 15, weight = 1.1, enc = 5, cov = { Shoulder = "R" } },
    ["Rerebraces (Kurbul)"] = { material = "Kurbul", price = 40, weight = 3.0, enc = 5, cov = { ["Upper Arm"] = "R" } },
    ["Coudes (Kurbul)"]    = { material = "Kurbul", price = 10, weight = 0.8, enc = 5, cov = { Elbow = "R" } },
    ["Vambraces (Kurbul)"] = { material = "Kurbul", price = 25, weight = 1.9, enc = 5, cov = { Forearm = "R" } },
    ["Cuirass (Kurbul)"]   = { material = "Kurbul", price = 120, weight = 9.1, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Breastplate (Kurbul)"] = { material = "Kurbul", price = 60, weight = 4.6, enc = 5, cov = { Thorax = "F", Abdomen = "F" } },
    ["Kneecops (Kurbul)"]  = { material = "Kurbul", price = 15, weight = 1.1, enc = 0, cov = { Knee = "R" } },
    ["Greaves (Kurbul)"]   = { material = "Kurbul", price = 60, weight = 4.6, enc = 5, cov = { Calf = "R" } },

    -- SCALE
    ["Cowl (Scale)"]       = { material = "Scale", price = 60, weight = 3.3, enc = 5, cov = { Skull = "R", Neck = "R" } },
    ["Gauntlets (Scale)"]  = { material = "Scale", price = 50, weight = 2.8, enc = 5, cov = { Hand = "R" } },
    ["Vest (Scale)"]       = { material = "Scale", price = 240, weight = 13.2, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Byrnie (Scale)"]     = { material = "Scale", price = 330, weight = 18.2, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Thorax = "R", Abdomen = "R" } },
    ["Byrnie, Sleeved (Scale)"] = { material = "Scale", price = 400, weight = 22.0, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R" } },
    ["Habergeon (Scale)"]  = { material = "Scale", price = 450, weight = 24.8, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Hauberk (Scale)"]    = { material = "Scale", price = 640, weight = 35.2, enc = 20, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },
    ["Cuisses (Scale)"]    = { material = "Scale", price = 170, weight = 9.4, enc = 5, cov = { Pelvis = "R", Thigh = "R" } },
    ["Leggings (Scale)"]   = { material = "Scale", price = 360, weight = 19.8, enc = 10, cov = { Pelvis = "R", Thigh = "R", Knee = "R", Calf = "R" } },

    -- MAIL
    ["Cowl (Mail)"]        = { material = "Mail", price = 90, weight = 2.7, enc = 5, cov = { Skull = "R", Neck = "R" } },
    ["Gauntlets (Mail)"]     = { material = "Mail", price = 75, weight = 2.3, enc = 5, cov = { Hand = "R" } },
    ["Vest (Mail)"]        = { material = "Mail", price = 360, weight = 10.8, enc = 0, cov = { Thorax = "R", Abdomen = "R" } },
    ["Byrnie (Mail)"]      = { material = "Mail", price = 495, weight = 14.9, enc = 5, cov = { Shoulder = "R", ["Upper Arm"] = "R", Thorax = "R", Abdomen = "R" } },
    ["Byrnie, Sleeved (Mail)"] = { material = "Mail", price = 600, weight = 18.0, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R" } },
    ["Habergeon (Mail)"]   = { material = "Mail", price = 675, weight = 20.3, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Hauberk (Mail)"]     = { material = "Mail", price = 960, weight = 28.8, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },
    ["Cuisses (Mail)"]     = { material = "Mail", price = 255, weight = 7.7, enc = 5, cov = { Pelvis = "R", Thigh = "R" } },
    ["Leggings (Mail)"]    = { material = "Mail", price = 540, weight = 16.2, enc = 10, cov = { Pelvis = "R", Thigh = "R", Knee = "R", Calf = "R" } },

    -- PLATE
    ["Helm (Plate)"]       = { material = "Plate", price = 80, weight = 3.0, enc = 0, cov = { Skull = "R" } },
    ["3/4-Helm (Plate)"]   = { material = "Plate", price = 140, weight = 5.3, enc = 5, cov = { Skull = "R", Face = "R" } },
    ["Great Helm (Plate)"] = { material = "Plate", price = 180, weight = 6.8, enc = 10, cov = { Skull = "R", Face = "R", Neck = "R" } },
    ["Spaulders (Plate)"]  = { material = "Plate", price = 60, weight = 1.1, enc = 5, cov = { Shoulder = "R" } },
    ["Rerebraces (Plate)"] = { material = "Plate", price = 160, weight = 3.0, enc = 5, cov = { ["Upper Arm"] = "R" } },
    ["Coudes (Plate)"]     = { material = "Plate", price = 40, weight = 0.8, enc = 5, cov = { Elbow = "R" } },
    ["Vambraces (Plate)"]  = { material = "Plate", price = 100, weight = 1.9, enc = 5, cov = { Forearm = "R" } },
    ["Cuirass (Plate)"]    = { material = "Plate", price = 480, weight = 9.1, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Breastplate (Plate)"] = { material = "Plate", price = 240, weight = 4.6, enc = 5, cov = { Thorax = "F", Abdomen = "F" } },
    ["Kneecops (Plate)"]   = { material = "Plate", price = 60, weight = 1.1, enc = 0, cov = { Knee = "R" } },
    ["Greaves (Plate)"]    = { material = "Plate", price = 240, weight = 4.6, enc = 5, cov = { Calf = "R" } },
}

-- Helper to get item data by name
function lookupItem(sName)
    if not sName or sName == "" then return nil; end
    
    -- Trim whitespace
    local sTrimmed = sName:gsub("^%s*(.-)%s*$", "%1");
    local sLowerName = sTrimmed:lower();
    local nLen = #sLowerName;
    
    -- 1. Try exact match (case-insensitive)
    for k, v in pairs(Items) do
        if k:lower() == sLowerName then
            return v, k;
        end
    end
    
    -- 2. Try prefix match (if input is at least 3 chars)
    if nLen >= 3 then
        for k, v in pairs(Items) do
            if k:lower():sub(1, nLen) == sLowerName then
                return v, k;
            end
        end
    end
    
    -- 3. Try substring search (if input is at least 3 chars)
    if nLen >= 3 then
        for k, v in pairs(Items) do
            if k:lower():find(sLowerName, 1, true) then
                return v, k;
            end
        end
    end
    
    return nil;
end
