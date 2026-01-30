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

-- Layering Restrictions (Simplified from ArmorProfiles.csv and rules)
-- Format: Material -> { under = {mat...}, over = {mat...} }
Layering = {
    ["Cloth"]    = { under = {"Cloth"}, over = {"Cloth", "Padded", "Leather", "Quilted", "Gambeson", "Kurbul", "Scale", "Mail", "Plate"} },
    ["Padded"]   = { under = {"Cloth"}, over = {"Cloth", "Leather", "Kurbul", "Scale", "Mail", "Plate"} },
    ["Leather"]  = { under = {"Cloth", "Padded"}, over = {"Cloth"} },
    ["Quilted"]  = { under = {"Cloth"}, over = {"Cloth", "Kurbul", "Scale", "Mail", "Plate"} },
    ["Gambeson"] = { under = {"Cloth"}, over = {"Cloth"} },
    ["Kurbul"]   = { under = {"Cloth", "Padded"}, over = {"Cloth", "Padded", "Quilted"} },
    ["Scale"]    = { under = {"Cloth", "Padded"}, over = {"Cloth", "Padded", "Quilted"} },
    ["Mail"]     = { under = {"Cloth", "Padded"}, over = {"Cloth", "Padded", "Quilted", "Kurbul", "Plate"} },
    ["Plate"]    = { under = {"Cloth", "Padded"}, over = {"Cloth", "Padded", "Quilted"} },
}

-- Item Data
-- Coverage symbols: Y=Yes, R=Rigid (Both), F=Front only, B=Back only
Items = {
    -- CLOTH
    ["Cloth Cap"]        = { material = "Cloth", price = 4,  weight = 0.2, enc = 0, cov = { Skull = "Y" } },
    ["Cloth Cowl"]       = { material = "Cloth", price = 6,  weight = 0.3, enc = 0, cov = { Skull = "Y", Neck = "Y" } },
    ["Cloth Mantle"]     = { material = "Cloth", price = 21, weight = 1.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Cloth Gauntlets"]  = { material = "Cloth", price = 5,  weight = 0.3, enc = 0, cov = { Hand = "Y" } },
    ["Cloth Vest"]       = { material = "Cloth", price = 24, weight = 1.2, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Cloth Shirt"]      = { material = "Cloth", price = 33, weight = 1.7, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Cloth Tunic"]      = { material = "Cloth", price = 45, weight = 2.3, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Cloth Tunic, Sleeved"] = { material = "Cloth", price = 50, weight = 2.5, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Cloth Coat"]       = { material = "Cloth", price = 64, weight = 3.2, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Cloth Surcoat"]    = { material = "Cloth", price = 54, weight = 2.7, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Cloth Cloak"]      = { material = "Cloth", price = 66, weight = 3.3, enc = 0, cov = { Shoulder = "Y", Thorax = "B", Abdomen = "B", Pelvis = "B", Thigh = "B", Knee = "B", Calf = "B" } },
    ["Cloth Robe"]       = { material = "Cloth", price = 79, weight = 4.0, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Cloth Breeches"]   = { material = "Cloth", price = 17, weight = 0.9, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y" } },
    ["Cloth Trousers"]   = { material = "Cloth", price = 39, weight = 2.0, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Cloth Leggings"]   = { material = "Cloth", price = 36, weight = 1.8, enc = 0, cov = { Thigh = "Y", Knee = "Y", Calf = "Y", Foot = "Y" } },
    ["Cloth Swaddle"]    = { material = "Cloth", price = 19, weight = 1.0, enc = 0, cov = { Calf = "Y", Foot = "Y" } },

    -- LEATHER
    ["Leather Cap"]      = { material = "Leather", price = 16, weight = 0.6, enc = 0, cov = { Skull = "Y" } },
    ["Leather Bracers"]  = { material = "Leather", price = 20, weight = 0.8, enc = 0, cov = { Forearm = "Y" } },
    ["Leather Gauntlets"] = { material = "Leather", price = 20, weight = 0.8, enc = 0, cov = { Hand = "Y" } },
    ["Leather Vest"]     = { material = "Leather", price = 96, weight = 3.6, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Leather Long Vest"] = { material = "Leather", price = 148, weight = 6.8, enc = 5, cov = { Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Leather Boots"]    = { material = "Leather", price = 176, weight = 2.9, enc = 0, cov = { Calf = "Y", Foot = "Y" } },
    ["Leather Shoes"]    = { material = "Leather", price = 28, weight = 1.1, enc = 0, cov = { Foot = "Y" } },

    -- PADDED
    ["Padded Cap"]       = { material = "Padded", price = 8,  weight = 0.3, enc = 0, cov = { Skull = "Y" } },
    ["Padded Cowl"]      = { material = "Padded", price = 12, weight = 0.5, enc = 0, cov = { Skull = "Y", Neck = "Y" } },
    ["Padded Mantle"]    = { material = "Padded", price = 42, weight = 1.7, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Padded Mittens"]   = { material = "Padded", price = 10, weight = 0.4, enc = 0, cov = { Hand = "Y" } },
    ["Padded Vest"]      = { material = "Padded", price = 48, weight = 1.9, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Padded Shirt"]     = { material = "Padded", price = 66, weight = 2.6, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Padded Tunic"]     = { material = "Padded", price = 90, weight = 3.6, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Padded Tunic, Sleeved"] = { material = "Padded", price = 100, weight = 4.0, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Padded Coat"]      = { material = "Padded", price = 128, weight = 5.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Padded Surcoat"]   = { material = "Padded", price = 108, weight = 4.3, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Padded Cloak"]     = { material = "Padded", price = 132, weight = 5.3, enc = 0, cov = { Shoulder = "Y", Thorax = "B", Abdomen = "B", Pelvis = "B", Thigh = "B", Knee = "B", Calf = "B" } },
    ["Padded Cuisses"]   = { material = "Padded", price = 34, weight = 1.4, enc = 0, cov = { Pelvis = "Y", Thigh = "Y" } },
    ["Padded Trousers"]  = { material = "Padded", price = 78, weight = 3.1, enc = 0, cov = { Pelvis = "Y", Thigh = "Y", Knee = "Y", Calf = "Y" } },
    ["Padded Leggings"]  = { material = "Padded", price = 72, weight = 2.9, enc = 0, cov = { Thigh = "Y", Knee = "Y", Calf = "Y", Foot = "Y" } },

    -- QUILTED
    ["Quilted Cap"]      = { material = "Quilted", price = 16, weight = 0.7, enc = 0, cov = { Skull = "Y" } },
    ["Quilted Cowl"]     = { material = "Quilted", price = 24, weight = 1.1, enc = 0, cov = { Skull = "Y", Neck = "Y" } },
    ["Quilted Mantle"]   = { material = "Quilted", price = 84, weight = 3.8, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y" } },
    ["Quilted Vest"]     = { material = "Quilted", price = 96, weight = 4.3, enc = 0, cov = { Thorax = "Y", Abdomen = "Y" } },
    ["Quilted Shirt"]    = { material = "Quilted", price = 132, weight = 5.9, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "Y", Abdomen = "Y" } },
    ["Quilted Tunic"]    = { material = "Quilted", price = 180, weight = 8.1, enc = 0, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Quilted Tunic, Sleeved"] = { material = "Quilted", price = 200, weight = 9.0, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y" } },
    ["Quilted Coat"]     = { material = "Quilted", price = 256, weight = 11.5, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Quilted Surcoat"]  = { material = "Quilted", price = 216, weight = 9.7, enc = 0, cov = { Shoulder = "Y", Thorax = "Y", Abdomen = "Y", Pelvis = "Y", Thigh = "Y" } },
    ["Quilted Cuisses"]  = { material = "Quilted", price = 68, weight = 3.1, enc = 0, cov = { Pelvis = "Y", Thigh = "Y" } },

    -- GAMBESON
    ["Gambeson Vest"]    = { material = "Gambeson", price = 208, weight = 7.3, enc = 0, cov = { Thorax = "R", Abdomen = "R" } },
    ["Gambeson Shirt"]   = { material = "Gambeson", price = 280, weight = 9.8, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Thorax = "R", Abdomen = "R" } },
    ["Gambeson Long Vest"] = { material = "Gambeson", price = 312, weight = 10.9, enc = 5, cov = { Shoulder = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Gambeson Tunic"]   = { material = "Gambeson", price = 376, weight = 13.2, enc = 5, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Gambeson Tunic, Sleeved"] = { material = "Gambeson", price = 416, weight = 14.6, enc = 10, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Gambeson Coat"]    = { material = "Gambeson", price = 528, weight = 18.5, enc = 10, cov = { Shoulder = "Y", ["Upper Arm"] = "Y", Elbow = "Y", Forearm = "Y", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },

    -- KURBUL
    ["Kurbul Helm"]      = { material = "Kurbul", price = 20, weight = 3.0, enc = 0, cov = { Skull = "R" } },
    ["Kurbul 3/4 Helm"]  = { material = "Kurbul", price = 35, weight = 5.3, enc = 0, cov = { Skull = "R", Face = "R" } },
    ["Kurbul Spaulders"] = { material = "Kurbul", price = 15, weight = 1.1, enc = 0, cov = { Shoulder = "R" } },
    ["Kurbul Rerebraces"] = { material = "Kurbul", price = 40, weight = 3.0, enc = 0, cov = { ["Upper Arm"] = "R" } },
    ["Kurbul Coudes"]    = { material = "Kurbul", price = 10, weight = 0.8, enc = 0, cov = { Elbow = "R" } },
    ["Kurbul Vambraces"] = { material = "Kurbul", price = 25, weight = 1.9, enc = 0, cov = { Forearm = "R" } },
    ["Kurbul Cuirass"]   = { material = "Kurbul", price = 120, weight = 9.1, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Kurbul Breastplate"] = { material = "Kurbul", price = 60, weight = 4.6, enc = 5, cov = { Thorax = "F", Abdomen = "F" } },
    ["Kurbul Kneecops"]  = { material = "Kurbul", price = 15, weight = 1.1, enc = 0, cov = { Knee = "R" } },
    ["Kurbul Greaves"]   = { material = "Kurbul", price = 60, weight = 4.6, enc = 5, cov = { Calf = "R" } },

    -- SCALE
    ["Scale Cowl"]       = { material = "Scale", price = 60, weight = 3.3, enc = 0, cov = { Skull = "R", Neck = "R" } },
    ["Scale Gauntlets"]  = { material = "Scale", price = 50, weight = 2.8, enc = 0, cov = { Hand = "R" } },
    ["Scale Vest"]       = { material = "Scale", price = 240, weight = 13.2, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Scale Byrnie"]     = { material = "Scale", price = 330, weight = 18.2, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Thorax = "R", Abdomen = "R" } },
    ["Scale Byrnie, Sleeved"] = { material = "Scale", price = 400, weight = 22.0, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R" } },
    ["Scale Habergeon"]  = { material = "Scale", price = 450, weight = 24.8, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Scale Hauberk"]    = { material = "Scale", price = 640, weight = 35.2, enc = 20, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },
    ["Scale Cuisses"]    = { material = "Scale", price = 170, weight = 9.4, enc = 5, cov = { Pelvis = "R", Thigh = "R" } },
    ["Scale Leggings"]   = { material = "Scale", price = 360, weight = 19.8, enc = 10, cov = { Pelvis = "R", Thigh = "R", Knee = "R", Calf = "R" } },

    -- MAIL
    ["Mail Cowl"]        = { material = "Mail", price = 90, weight = 2.7, enc = 0, cov = { Skull = "R", Neck = "R" } },
    ["Mail Mittens"]     = { material = "Mail", price = 75, weight = 2.3, enc = 0, cov = { Hand = "R" } },
    ["Mail Vest"]        = { material = "Mail", price = 360, weight = 10.8, enc = 0, cov = { Thorax = "R", Abdomen = "R" } },
    ["Mail Byrnie"]      = { material = "Mail", price = 495, weight = 14.9, enc = 5, cov = { Shoulder = "R", ["Upper Arm"] = "R", Thorax = "R", Abdomen = "R" } },
    ["Mail Byrnie, Sleeved"] = { material = "Mail", price = 600, weight = 18.0, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R" } },
    ["Mail Habergeon"]   = { material = "Mail", price = 675, weight = 20.3, enc = 10, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Thorax = "R", Abdomen = "R", Pelvis = "R" } },
    ["Mail Hauberk"]     = { material = "Mail", price = 960, weight = 28.8, enc = 15, cov = { Shoulder = "R", ["Upper Arm"] = "R", Elbow = "R", Forearm = "R", Thorax = "R", Abdomen = "R", Pelvis = "R", Thigh = "R" } },
    ["Mail Cuisses"]     = { material = "Mail", price = 255, weight = 7.7, enc = 5, cov = { Pelvis = "R", Thigh = "R" } },
    ["Mail Leggings"]    = { material = "Mail", price = 540, weight = 16.2, enc = 10, cov = { Pelvis = "R", Thigh = "R", Knee = "R", Calf = "R" } },

    -- PLATE
    ["Plate Helm"]       = { material = "Plate", price = 80, weight = 3.0, enc = 0, cov = { Skull = "R" } },
    ["Plate 3/4 Helm"]   = { material = "Plate", price = 140, weight = 5.3, enc = 0, cov = { Skull = "R", Face = "R" } },
    ["Plate Great Helm"] = { material = "Plate", price = 180, weight = 6.8, enc = 0, cov = { Skull = "R", Face = "R", Neck = "R" } },
    ["Plate Spaulders"]  = { material = "Plate", price = 60, weight = 1.1, enc = 0, cov = { Shoulder = "R" } },
    ["Plate Rerebraces"] = { material = "Plate", price = 160, weight = 3.0, enc = 0, cov = { ["Upper Arm"] = "R" } },
    ["Plate Coudes"]     = { material = "Plate", price = 40, weight = 0.8, enc = 0, cov = { Elbow = "R" } },
    ["Plate Vambraces"]  = { material = "Plate", price = 100, weight = 1.9, enc = 0, cov = { Forearm = "R" } },
    ["Plate Cuirass"]    = { material = "Plate", price = 480, weight = 9.1, enc = 5, cov = { Thorax = "R", Abdomen = "R" } },
    ["Plate Breastplate"] = { material = "Plate", price = 240, weight = 4.6, enc = 5, cov = { Thorax = "F", Abdomen = "F" } },
    ["Plate Kneecops"]   = { material = "Plate", price = 60, weight = 1.1, enc = 0, cov = { Knee = "R" } },
    ["Plate Greaves"]    = { material = "Plate", price = 240, weight = 4.6, enc = 5, cov = { Calf = "R" } },
}

-- Helper to get item data by name
function lookupItem(sName)
    if not sName or sName == "" then return nil; end
    local sLowerName = sName:lower();
    for k, v in pairs(Items) do
        if k:lower() == sLowerName then
            return v, k;
        end
    end
    -- Try partial match
    if #sLowerName >= 3 then
        for k, v in pairs(Items) do
            if k:lower():find(sLowerName, 1, true) then
                return v, k;
            end
        end
    end
    return nil;
end
