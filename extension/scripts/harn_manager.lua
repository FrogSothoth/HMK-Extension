--
-- HarnMaster Extension
-- Main manager script
--

function onInit()
	Debug.chat("HarnMaster character sheet extension loaded!")
end

function onClose()
	-- Cleanup (handlers are managed per-character in charsheet.xml)
end

--
-- Utility functions for HarnMaster calculations
--

-- Month name to number mapping (1-12)
local MONTH_VALUES = {
	["Nuzyael"] = 1,
	["Peonu"] = 2,
	["Kelen"] = 3,
	["Nolus"] = 4,
	["Larane"] = 5,
	["Agrazhar"] = 6,
	["Azura"] = 7,
	["Halane"] = 8,
	["Savor"] = 9,
	["Ilvin"] = 10,
	["Navek"] = 11,
	["Morgat"] = 12,
}

-- Skills affected by each body zone impairment
-- Head and Torso also affect all Craft skills (handled in isSkillAffectedByZone)
local ZONE_AFFECTED_SKILLS = {
	head = {
		"Acrobatics", "Awareness", "Climbing", "Dancing", "Dodge",
		"Jumping", "Legerdemain", "Melee", "Riding", "Stealth",
		"Swimming", "Archery", "Slings", "Throwing"
		-- Plus all Craft skills (checked separately)
	},
	torso = {
		"Acrobatics", "Climbing", "Dancing", "Dodge", "Jumping",
		"Melee", "Riding", "Stealth", "Swimming", "Archery",
		"Slings", "Throwing"
		-- Plus all Craft skills (checked separately)
	},
	legs = {
		"Acrobatics", "Climbing", "Dancing", "Dodge", "Jumping",
		"Melee", "Riding", "Stealth", "Swimming", "Archery",
		"Slings", "Throwing"
	},
	arms = {
		"Acrobatics", "Archery", "Climbing", "Dancing", "Dexterity",
		"Jumping", "Legerdemain", "Melee", "Riding", "Slings",
		"Strength", "Swimming", "Throwing"
		-- Plus all Craft skills (checked separately)
	}
}

-- Sunsign data: each entry is {startDay, endDay, sunsignName, fatSocial, fatLore, fatPhysical, fatNature, fatCraft, fatCombat, logo}
-- Modifiers stored for future use
local SUNSIGN_DATA = {
	{1, 2, "Lado", 10, 0, -10, 10, 0, -10, "lado.png"},
	{2, 4, "Lado-Ulandus", 10, 0, -10, 15, 5, -5, "lado-ulandus.png"},
	{5, 6, "Ulandus-Lado", 10, 0, -10, 15, 5, -5, "lado-ulandus.png"},
	{7, 31, "Ulandus", 5, -5, -15, 15, 5, -5, "ulandus.png"},
	{32, 33, "Ulandus-Aralius", 5, -5, -10, 15, 10, 0, "ulandus-aralius.png"},
	{34, 35, "Aralius-Ulandus", 5, -5, -10, 15, 10, 0, "ulandus-aralius.png"},
	{36, 60, "Aralius", 0, -10, -10, 10, 10, 0, "aralius.png"},
	{61, 62, "Aralius-Feneri", 0, -10, -5, 10, 15, 5, "aralius-feneri.png"},
	{63, 65, "Feneri-Aralius", 0, -10, -5, 10, 15, 5, "aralius-feneri.png"},
	{66, 91, "Feneri", -5, -15, -5, 5, 15, 5, "feneri.png"},
	{92, 93, "Feneri-Ahnu", -5, -10, 0, 5, 15, 10, "feneri-ahnu.png"},
	{94, 95, "Ahnu-Feneri", -5, -10, 0, 5, 15, 10, "feneri-ahnu.png"},
	{96, 123, "Ahnu", -10, -10, 0, 0, 10, 10, "ahnu.png"},
	{124, 125, "Ahnu-Angberelius", -10, -5, 5, 0, 10, 15, "ahnu-angberelius.png"},
	{126, 127, "Angberelius-Ahnu", -10, -5, 5, 0, 10, 15, "ahnu-angberelius.png"},
	{128, 154, "Angberelius", -15, -5, 5, -5, 5, 15, "angberelius.png"},
	{155, 156, "Angberelius-Nadai", -10, 0, 10, -5, 5, 15, "angberelius-nadai.png"},
	{157, 158, "Nadai-Angberelius", -10, 0, 10, -5, 5, 15, "angberelius-nadai.png"},
	{159, 183, "Nadai", -10, 0, 10, -10, 0, 10, "nadai.png"},
	{184, 185, "Nadai-Hirin", -5, 5, 15, -10, 0, 10, "nadai-hirin.png"},
	{186, 187, "Hirin-Nadai", -5, 5, 15, -10, 0, 10, "nadai-hirin.png"},
	{188, 212, "Hirin", -5, 5, 15, -15, -5, 5, "hirin.png"},	
	{213, 214, "Hirin-Tarael", 0, 10, 15, -10, -5, 5, "hirin-tarael.png"},
	{215, 216, "Tarael-Hirin", 0, 10, 15, -10, -5, 5, "hirin-tarael.png"},
	{217, 241, "Tarael", 0, 10, 10, -10, -10, 0, "tarael.png"},
	{242, 243, "Tarael-Tai", 5, 15, 10, -5, -10, 0, "tarael-tai.png"},
	{244, 245, "Tai-Tarael", 5, 15, 10, -5, -10, 0, "tarael-tai.png"},
	{246, 270, "Tai", 5, 15, 5, -5, 15, -5, "tai.png"},
	{271, 272, "Tai-Skorus", 10, 15, 5, 0, -10, -5, "tai-skorus.png"},
	{273, 274, "Skorus-Tai", 10, 15, 5, 0, -10, -5, "tai-skorus.png"},
	{275, 300, "Skorus", 10, 10, 0, 0, -10, -10, "skorus.png"},
	{301, 302, "Skorus-Masara", 15, 10, 0, 5, -5, -10, "skorus-masara.png"},
	{303, 304, "Masara-Skorus", 15, 10, 0, 5, -5, -10, "skorus-masara.png"},
	{305, 329, "Masara", 15, 5, -5, 5, -5, -15, "masara.png"},
	{330, 331, "Masara-Lado", 15, 5, -5, 10, 0, -10, "masara-lado.png"},
	{332, 333, "Lado-Masara", 15, 5, -5, 10, 0, -10, "masara-lado.png"},
	{334, 360, "Lado", 10, 0, -10, 10, 0, -10, "lado.png"},
}

-- Morality descriptors by score range
local MORALITY_DATA = {
	{ min = 1, max = 4, text = "Diabolical" },
	{ min = 5, max = 7, text = "Unscrupulous" },
	{ min = 8, max = 10, text = "Corruptible" },
	{ min = 11, max = 13, text = "Dutiful" },
	{ min = 14, max = 16, text = "Principled" },
	{ min = 17, max = 100, text = "Exemplary" },
}

-- Wealth descriptors by score range
local WEALTH_DATA = {
	{ min = 0, max = 4, text = "Poor" },
	{ min = 5, max = 9, text = "Meagre" },
	{ min = 10, max = 19, text = "Comfortable" },
	{ min = 20, max = 49, text = "Affluent" },
	{ min = 50, max = 1000, text = "Ostentatious" },
}

-- Estrangement descriptors by score range
local ESTRANGEMENT_DATA = {
	{ min = 1, max = 10, text = "Outcast" },
	{ min = 11, max = 40, text = "Unpopular" },
	{ min = 41, max = 60, text = "Accepted" },
	{ min = 61, max = 95, text = "Popular" },
	{ min = 96, max = 100, text = "Favourite" },
}

-- Look up morality descriptor by score
function getMoralityDescriptor(nScore)
	local nVal = tonumber(nScore)
	if not nVal or nVal < 1 then return "" end
	
	for _, entry in ipairs(MORALITY_DATA) do
		if nVal >= entry.min and nVal <= entry.max then
			return entry.text
		end
	end
	
	-- Fallback for values > 100
	if nVal > 100 then return "Exemplary" end
	
	return ""
end

-- Look up wealth descriptor by score
function getWealthDescriptor(nScore)
	local nVal = tonumber(nScore)
	if not nVal or nVal < 0 then return "" end
	
	for _, entry in ipairs(WEALTH_DATA) do
		if nVal >= entry.min and nVal <= entry.max then
			return entry.text
		end
	end
	
	-- Fallback for values > 1000
	if nVal > 1000 then return "Ostentatious" end
	
	return ""
end

-- Look up estrangement descriptor by score
function getEstrangementDescriptor(nScore)
	local nVal = tonumber(nScore)
	if not nVal or nVal < 1 then return "" end
	
	for _, entry in ipairs(ESTRANGEMENT_DATA) do
		if nVal >= entry.min and nVal <= entry.max then
			return entry.text
		end
	end
	
	-- Fallback for values > 100
	if nVal > 100 then return "Favourite" end
	
	return ""
end

-- Get month number from name
function getMonthValue(sMonthName)
	return MONTH_VALUES[sMonthName] or 0
end

-- Calculate day of year from month and day
-- Formula: ((month - 1) * 30) + day
function calculateDayOfYear(nMonth, nDay)
	if nMonth < 1 or nMonth > 12 then return 0 end
	if nDay < 1 or nDay > 30 then return 0 end
	return ((nMonth - 1) * 30) + nDay
end

-- Look up sunsign data by day of year
-- Returns: sunsignName, mod1, mod2, mod3, mod4, mod5, mod6, logo
function getSunsignData(nDayOfYear)
	for _, entry in ipairs(SUNSIGN_DATA) do
		if nDayOfYear >= entry[1] and nDayOfYear <= entry[2] then
			return entry[3], entry[4], entry[5], entry[6], entry[7], entry[8], entry[9], entry[10]
		end
	end
	return "Unknown", 0, 0, 0, 0, 0, 0, ""
end

-- Look up sunsign modifiers by name
-- Returns: {social, lore, physical, nature, craft, combat}
function getSunsignModifiers(sSunsign)
	for _, entry in ipairs(SUNSIGN_DATA) do
		if entry[3] == sSunsign then
			return { entry[4], entry[5], entry[6], entry[7], entry[8], entry[9] }
		end
	end
	return { 0, 0, 0, 0, 0, 0 }
end

-- Get sunsign name and logo from month name and day
function getSunsign(sMonthName, nDay)
	local nMonth = getMonthValue(sMonthName)
	if nMonth == 0 then return "", "" end

	local nDayOfYear = calculateDayOfYear(nMonth, nDay)
	if nDayOfYear == 0 then return "", "" end

	local sSunsign, _, _, _, _, _, _, sLogo = getSunsignData(nDayOfYear)
	return sSunsign, sLogo
end

-- Update the first-created "Language" skill entry found on the character sheet
function updateNativeLanguage(nodeChar, sLanguage)
	if not nodeChar or not sLanguage or sLanguage == "" then return end

	local tSkillLists = { "socialskills", "loreskills", "physicalskills", "natureskills", "craftskills", "combatskills" }
	
	for _, sListName in ipairs(tSkillLists) do
		local nodeCharChild = nodeChar.getChild(sListName)
		if nodeCharChild then
			-- To find the "first-created", we sort the child keys (id-XXXXX)
			local tKeys = {}
			for k, _ in pairs(nodeCharChild.getChildren()) do
				table.insert(tKeys, k)
			end
			table.sort(tKeys)

			for _, sKey in ipairs(tKeys) do
				local nodeSkill = nodeCharChild.getChild(sKey)
				local sName = DB.getValue(nodeSkill, "name", "")
				-- Match "Language" exactly or names starting with "Language: "
				if sName == "Language" or string.sub(sName, 1, 10) == "Language: " then
					Debug.console("HarnManager.updateNativeLanguage: Updating " .. sName .. " (" .. sKey .. ") to " .. sLanguage)
					DB.setValue(nodeSkill, "language", "string", sLanguage)
					return true -- Found and updated
				end
			end
		end
	end
	Debug.console("HarnManager.updateNativeLanguage: No Language skill found to update.")
	return false
end

-- Calculate Strength Impact modifier
-- STR 0-4: (2 * STR) - 12
-- STR > 4: floor(STR / 2) - 5
function calculateStrImpact(nodeChar)
	if not nodeChar then return 0 end
	local nSTR = DB.getValue(nodeChar, "str_score", 10)
	local nStrImp
	if nSTR <= 4 then
		nStrImp = (2 * nSTR) - 12
	else
		nStrImp = math.floor(nSTR / 2) - 5
	end
	return nStrImp
end

-- Calculate Fate Roll based on AUR score
-- Formula: floor(AUR / 2) * 5 + 25
function calculateFate(nodeChar)
	if not nodeChar then return end
	local nAUR = DB.getValue(nodeChar, "aur_score", 10)
	local nFateRoll = math.floor(nAUR / 2) * 5 + 25
	DB.setValue(nodeChar, "fate_roll", "number", nFateRoll)
	return nFateRoll
end

-- Calculate Healing Base based on END and WIL
-- HB = average of END and WIL
-- Round up if END > WIL, else round down
function calculateHealingBase(nodeChar)
	if not nodeChar then return end
	local nEND = DB.getValue(nodeChar, "end_score", 10)
	local nWIL = DB.getValue(nodeChar, "wil_score", 10)
	local nHB
	if nEND > nWIL then
		nHB = math.ceil((nEND + nWIL) / 2)
	else
		nHB = math.floor((nEND + nWIL) / 2)
	end
	DB.setValue(nodeChar, "healing_base", "number", nHB)
	return nHB
end

-- Calculate Move based on AGL, STR, and Folk
-- 1. Get MOVE SB (AGL, STR) using SkillsManager.calculateSB
-- 2. MOVE = 25 + (floor(MOVE SB / 2) * 5)
-- 3. If Folk is Kuzhai, subtract 20
function calculateMove(nodeChar)
	if not nodeChar then return end
	
	-- 1. Calculate the hidden Skill Base (SB) for Move (AGL + STR)
	local nSB = 0
	if SkillsManager and SkillsManager.calculateSB then
		nSB = SkillsManager.calculateSB(nodeChar, "AGL", "STR")
	else
		-- Fallback if SkillsManager is not yet loaded or available
		local nAGL = DB.getValue(nodeChar, "agl_score", 10)
		local nSTR = DB.getValue(nodeChar, "str_score", 10)
		if nAGL > nSTR then
			nSB = math.ceil((nAGL + nSTR) / 2)
		else
			nSB = math.floor((nAGL + nSTR) / 2)
		end
	end

	-- 2. Base Move Formula
	local nMove = 25 + (math.floor(nSB / 2) * 5)

	-- 3. Kuzhai Modifier
	local sFolk = DB.getValue(nodeChar, "folk", "")
	if sFolk == "Kuzhai" then
		nMove = nMove - 20
	end

	DB.setValue(nodeChar, "move", "number", nMove)

	-- Also update Effective Move when base Move changes
	calculateEffectiveMove(nodeChar)

	return nMove
end

-- Update attribute ML based on score (ML = score * 5)
function updateAttributeML(nodeChar, sFieldName)
	if not nodeChar or not sFieldName then return end
	
	-- Check if the updated field is an attribute score
	local sAttr = sFieldName:match("^([%a]+)_score$")
	if not sAttr then return end
	
	local nScore = DB.getValue(nodeChar, sFieldName, 0)
	local nML = nScore * 5
	
	local sMLField = sAttr .. "_ml"
	DB.setValue(nodeChar, sMLField, "number", nML)
	
	-- Also trigger related calculations
	if sAttr == "aur" then
		calculateFate(nodeChar)
	elseif sAttr == "agl" or sAttr == "str" then
		calculateMove(nodeChar)
	elseif sAttr == "end" or sAttr == "wil" then
		calculateHealingBase(nodeChar)
	end
	
	-- Update recalculate all SB whenever an attribute changes
	if SkillsManager and SkillsManager.recalculateAllSB then
		SkillsManager.recalculateAllSB(nodeChar)
	end
end

-----------------------------------------------------------
-- EML (Effective Mastery Level) and Effective Move
-----------------------------------------------------------

-- Calculate total Fatigue penalty (sum of all fatigue levels)
function calculateFatiguePenalty(nodeChar)
	if not nodeChar then return 0 end
	local nWinded = DB.getValue(nodeChar, "winded", 0)
	local nWeary = DB.getValue(nodeChar, "weary", 0)
	local nWeak = DB.getValue(nodeChar, "weak", 0)
	return nWinded + nWeary + nWeak
end

function isAGLSkill(sSkillName)
	if not sSkillName or sSkillName == "" then return false end
	if not SkillsData or not SkillsData.getSkill then return false end

	local tSkill = SkillsData.getSkill(sSkillName)
	if tSkill then
		local bIsAGL = tSkill.att1 == "AGL" or tSkill.att2 == "AGL"
		return bIsAGL
	end
	return false
end

-- Check if a skill is affected by a specific body zone
function isSkillAffectedByZone(sSkillName, sZone)
	if not sSkillName or not sZone then return false end
	
	-- Special case: All Craft skills are affected by Head, Torso, or Arms
	if (sZone == "head" or sZone == "torso" or sZone == "arms") then
		if SkillsData and SkillsData.getSkill then
			local tSkill = SkillsData.getSkill(sSkillName)
			if tSkill and tSkill.group == "Craft" then
				return true
			end
		end
	end
	
	-- Check explicit skill list for this zone
	local tAffectedSkills = ZONE_AFFECTED_SKILLS[sZone]
	if not tAffectedSkills then return false end
	
	for _, sAffectedSkill in ipairs(tAffectedSkills) do
		if sAffectedSkill == sSkillName then
			return true
		end
	end
	
	return false
end

-- Calculate total zone impairment penalties for a skill
-- Returns the sum of all applicable zone impairments
function calculateZoneImpairment(nodeChar, sSkillName)
	if not nodeChar or not sSkillName then return 0 end
	
	local nTotalImpairment = 0
	
	-- Check if skill is affected by Head zone
	if isSkillAffectedByZone(sSkillName, "head") then
		nTotalImpairment = nTotalImpairment + DB.getValue(nodeChar, "injury_head", 0)
	end
	
	-- Check if skill is affected by Torso zone
	if isSkillAffectedByZone(sSkillName, "torso") then
		nTotalImpairment = nTotalImpairment + DB.getValue(nodeChar, "injury_torso", 0)
	end
	
	-- Check if skill is affected by Legs zone (sum both legs)
	if isSkillAffectedByZone(sSkillName, "legs") then
		local nLegL = DB.getValue(nodeChar, "injury_legs_l", 0)
		local nLegR = DB.getValue(nodeChar, "injury_legs_r", 0)
		nTotalImpairment = nTotalImpairment + nLegL + nLegR
	end
	
	-- Check if skill is affected by Arms zone (sum both arms)
	if isSkillAffectedByZone(sSkillName, "arms") then
		local nArmL = DB.getValue(nodeChar, "injury_arms_l", 0)
		local nArmR = DB.getValue(nodeChar, "injury_arms_r", 0)
		nTotalImpairment = nTotalImpairment + nArmL + nArmR
	end
	
	return nTotalImpairment
end

-- Calculate Shadow penalty for a skill or Move test
function calculateShadowPenalty(nodeChar, sSkillName)
	if not nodeChar then return 0 end
	
	local nShadow = DB.getValue(nodeChar, "shadow", 0)
	if nShadow == 0 then return 0 end

	-- 1. Check for -10 per point: Move, Dodge, Stealth
	if sSkillName == "Move" or sSkillName == "Dodge" or sSkillName == "Stealth" then
		return nShadow * 10
	end

	-- 2. Check for -0: Melee
	if sSkillName == "Melee" then
		return 0
	end

	-- 3. Check for -5 per point:
	-- Specific list (includes attributes like Agility and Perception)
	local tSpecialSkills = {
		["Mercantilism"] = true, ["Physician"] = true, ["Script"] = true, ["Agriculture"] = true,
		["Fishing"] = true, ["Mineralogy"] = true, ["Piloting"] = true, ["Seamanship"] = true,
		["Timbercraft"] = true, ["Tracking"] = true, ["Awareness"] = true, ["Legerdemain"] = true,
		["Archery"] = true, ["Slings"] = true, ["Throwing"] = true, ["Ceramics"] = true,
		["Fletching"] = true, ["Glassworking"] = true, ["Hideworking"] = true, ["Jewelcraft"] = true,
		["Lockcraft"] = true, ["Milling"] = true, ["Textilecraft"] = true, ["PERCEPTION"] = true,
		["Perception"] = true, ["Agility"] = true
	}

	if tSpecialSkills[sSkillName] then
		return nShadow * 5
	end

	-- Any other AGL-based skill
	if isAGLSkill(sSkillName) then
		return nShadow * 5
	end

	return 0
end

-- Calculate Doctrine Bonus for a skill
-- If the skill name matches any of the 5 doctrine entries, return the Blessing value
-- Otherwise return 0
function calculateDoctrineBonus(nodeChar, sSkillName)
	if not nodeChar or not sSkillName or sSkillName == "" then return 0 end

	local nBlessing = tonumber(DB.getValue(nodeChar, "blessing", "")) or 0
	if nBlessing == 0 then return 0 end

	local sSkillLower = string.lower(sSkillName)

	for i = 1, 5 do
		local sDoctrine = DB.getValue(nodeChar, "doctrine" .. i, "")
		if sDoctrine ~= "" and string.lower(sDoctrine) == sSkillLower then
			return nBlessing
		end
	end

	return 0
end

-- Calculate EML (Effective Mastery Level) for a skill
-- EML = ML - Fatigue - (ENC if AGL-based skill) - Zone Impairments - Shadow Penalty + Doctrine Bonus
-- Used for skill tests (not displayed on character sheet)
function calculateEML(nodeChar, nML, sSkillName)
	if not nodeChar then return nML end

	local nFatigue = calculateFatiguePenalty(nodeChar)
	local nPenalty = nFatigue

	-- Add ENC penalty only for AGL-based skills
	if isAGLSkill(sSkillName) then
		local nEnc = DB.getValue(nodeChar, "enc_total", 0)
		nPenalty = nPenalty + nEnc
	end

	-- Add zone impairment penalties
	local nZoneImpairment = calculateZoneImpairment(nodeChar, sSkillName)
	nPenalty = nPenalty + nZoneImpairment

	-- Add shadow penalty
	local nShadowPenalty = calculateShadowPenalty(nodeChar, sSkillName)
	nPenalty = nPenalty + nShadowPenalty

	-- Add doctrine bonus (if skill matches a doctrine entry)
	local nDoctrineBonus = calculateDoctrineBonus(nodeChar, sSkillName)

	return nML - nPenalty + nDoctrineBonus
end

-- Calculate and store Effective Move
-- Effective Move = Move - Fatigue - ENC - Zone Injuries (Head, Torso, Legs) - Shadow Penalty (10/pt)
function calculateEffectiveMove(nodeChar)
	if not nodeChar then return end
	
	local nMove = DB.getValue(nodeChar, "move", 0)
	local nFatigue = calculateFatiguePenalty(nodeChar)
	local nEnc = DB.getValue(nodeChar, "enc_total", 0)
	
	-- Add zone injury impairments (Head, Torso, and Legs all affect Move)
	local nHead = DB.getValue(nodeChar, "injury_head", 0)
	local nTorso = DB.getValue(nodeChar, "injury_torso", 0)
	local nLegL = DB.getValue(nodeChar, "injury_legs_l", 0)
	local nLegR = DB.getValue(nodeChar, "injury_legs_r", 0)

	-- Add Shadow penalty (Move is in the -10 list)
	local nShadowPenalty = calculateShadowPenalty(nodeChar, "Move")
	
	local nEffective = nMove - nFatigue - nEnc - nHead - nTorso - nLegL - nLegR - nShadowPenalty
	DB.setValue(nodeChar, "move_effective", "number", nEffective)

	-- Update dependent move fields
	-- Half Move = Effective Move / 2, rounded down to nearest multiple of 5
	DB.setValue(nodeChar, "move_half", "number", math.floor((nEffective / 2) / 5) * 5)
	DB.setValue(nodeChar, "move_double", "number", nEffective * 2)

	return nEffective
end

-----------------------------------------------------------
-- Injury Impairment Calculation
-----------------------------------------------------------

-- Map body locations to injury zones
-- Returns zone key: "head", "arm_l", "arm_r", "torso", "leg_l", "leg_r"
local LOCATION_TO_ZONE = {
	["Skull"] = "head",
	["Face"] = "head",
	["Neck"] = "head",
	["Shoulder"] = "arms",  -- needs side
	["Upper Arm"] = "arms",
	["Elbow"] = "arms",
	["Forearm"] = "arms",
	["Hand"] = "arms",
	["Thorax"] = "torso",
	["Abdomen"] = "torso",
	["Pelvis"] = "torso",
	["Thigh"] = "legs",  -- needs side
	["Knee"] = "legs",
	["Calf"] = "legs",
	["Foot"] = "legs",
}

-- Get the zone key for an injury based on location and side
function getInjuryZone(sLocation, sSide)
	if not sLocation then return nil end
	
	-- Make lookup case-insensitive by capitalizing first letter
	local sNormalized = sLocation:sub(1,1):upper() .. sLocation:sub(2):lower()
	local sBaseZone = LOCATION_TO_ZONE[sNormalized]
	if not sBaseZone then return nil end

	-- Head and Torso don't use side
	if sBaseZone == "head" or sBaseZone == "torso" then
		return sBaseZone
	end

	-- Arms and Legs use side (default to left if not specified)
	if sSide == "R" then
		return sBaseZone .. "_r"
	else
		return sBaseZone .. "_l"
	end
end

-- Add a delta to a specific zone's impairment
-- Called when an injury's level changes
function addImpairment(nodeChar, sLocation, sSide, nDelta)
	if not nodeChar or nDelta == 0 then return end

	local sZone = getInjuryZone(sLocation, sSide)
	if not sZone then return end

	local sPath = "injury_" .. sZone
	local nCurrent = DB.getValue(nodeChar, sPath, 0)
	local nNew = math.max(0, nCurrent + nDelta)  -- Don't go below 0
	DB.setValue(nodeChar, sPath, "number", nNew)
end

-- Recalculate all zone impairments from active injuries (full recalc)
-- Only used for special cases, not normal injury level changes
function recalculateImpairments(nodeChar)
	if not nodeChar then return end

	-- Initialize zone totals (SUM, not MAX)
	local tZoneSum = {
		head = 0,
		arms_l = 0,
		arms_r = 0,
		torso = 0,
		legs_l = 0,
		legs_r = 0,
	}

	-- Iterate through all active injuries
	local nodeInjuries = nodeChar.getChild("activeinjuries")
	if nodeInjuries then
		for _, nodeInjury in pairs(nodeInjuries.getChildren()) do
			local sLocation = DB.getValue(nodeInjury, "location", "")
			local sSide = DB.getValue(nodeInjury, "side", "-")
			local sLevel = DB.getValue(nodeInjury, "level", "")
			local nLevel = tonumber(sLevel) or 0

			local sZone = getInjuryZone(sLocation, sSide)
			if sZone and tZoneSum[sZone] and nLevel > 0 then
				local nImpairment = nLevel * 5
				tZoneSum[sZone] = tZoneSum[sZone] + nImpairment
			end
		end
	end

	-- Update the impairment fields
	DB.setValue(nodeChar, "injury_head", "number", tZoneSum.head)
	DB.setValue(nodeChar, "injury_arms_l", "number", tZoneSum.arms_l)
	DB.setValue(nodeChar, "injury_arms_r", "number", tZoneSum.arms_r)
	DB.setValue(nodeChar, "injury_torso", "number", tZoneSum.torso)
	DB.setValue(nodeChar, "injury_legs_l", "number", tZoneSum.legs_l)
	DB.setValue(nodeChar, "injury_legs_r", "number", tZoneSum.legs_r)
end

-- Add a delta to Weakness fatigue
-- Called when a psyche stress level changes
function addWeaknessFatigue(nodeChar, nDelta)
	if not nodeChar or nDelta == 0 then return end

	local nCurrent = DB.getValue(nodeChar, "weak", 0)
	local nNew = math.max(0, nCurrent + nDelta)  -- Don't go below 0
	DB.setValue(nodeChar, "weak", "number", nNew)
	
	-- Fatigue change affects effective move
	calculateEffectiveMove(nodeChar)
end