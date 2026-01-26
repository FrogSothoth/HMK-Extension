--
-- HarnMaster Skills Manager
-- Manages skill definitions and calculations
--

-- Initialize the global table
if not SkillsManager then
	SkillsManager = {};
end

-- Master skills database
SkillsManager.allSkills = {
	-- SOCIAL SKILLS
	{ name = "Charm", category = "social", att1 = "CML", att2 = "EMP", multiple = 3 },
	{ name = "Command", category = "social", att1 = "WIL", att2 = "ELO", multiple = 2 },
	{ name = "Discourse", category = "social", att1 = "REA", att2 = "ELO", multiple = 2 },
	{ name = "Guile", category = "social", att1 = "EMP", att2 = "CRE", multiple = 3 },
	{ name = "Intrigue", category = "social", att1 = "EMP", att2 = "REA", multiple = 3 },
	{ name = "Language", category = "social", att1 = "ELO", att2 = "REA", multiple = 0 },
	{ name = "Singing", category = "social", att1 = "VOI", att2 = "CRE", multiple = 3 },
	{ name = "Theatrics", category = "social", att1 = "CRE", att2 = "ELO", multiple = 1 },
	
	-- LORE SKILLS
	{ name = "Brewing", category = "lore", att1 = "PER", att2 = "REA", multiple = 0 },
	{ name = "Cookery", category = "lore", att1 = "PER", att2 = "REA", multiple = 2 },
	{ name = "Embalming", category = "lore", att1 = "REA", att2 = "PER", multiple = 0 },
	{ name = "Engineering", category = "lore", att1 = "REA", att2 = "CRE", multiple = 0 },
	{ name = "Folklore", category = "lore", att1 = "REA", att2 = "WIL", multiple = 1 },
	{ name = "Heraldry", category = "lore", att1 = "REA", att2 = "WIL", multiple = 0 },
	{ name = "Law", category = "lore", att1 = "REA", att2 = "WIL", multiple = 0 },
	{ name = "Mathematics", category = "lore", att1 = "REA", att2 = "CRE", multiple = 0 },
	{ name = "Mercantilism", category = "lore", att1 = "REA", att2 = "PER", multiple = 0 },
	{ name = "Perfumery", category = "lore", att1 = "PER", att2 = "REA", multiple = 0 },
	{ name = "Physician", category = "lore", att1 = "REA", att2 = "PER", multiple = 1 },
	{ name = "Ritual", category = "lore", att1 = "WIL", att2 = "REA", multiple = 0 },
	{ name = "Script", category = "lore", att1 = "REA", att2 = "PER", multiple = 0 },
	{ name = "Shipwright", category = "lore", att1 = "REA", att2 = "CRE", multiple = 0 },
	
	-- PHYSICAL SKILLS
	{ name = "Acrobatics", category = "physical", att1 = "AGL", att2 = "END", multiple = 0 },
	{ name = "Awareness", category = "physical", att1 = "PER", att2 = "WIL", multiple = 3 },
	{ name = "Climbing", category = "physical", att1 = "AGL", att2 = "DEX", multiple = 3 },
	{ name = "Dancing", category = "physical", att1 = "AGL", att2 = "CRE", multiple = 2 },
	{ name = "Jumping", category = "physical", att1 = "AGL", att2 = "STR", multiple = 3 },
	{ name = "Legerdemain", category = "physical", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Riding", category = "physical", att1 = "EMP", att2 = "AGL", multiple = 1 },
	{ name = "Stealth", category = "physical", att1 = "AGL", att2 = "WIL", multiple = 3 },
	{ name = "Swimming", category = "physical", att1 = "AGL", att2 = "END", multiple = 1 },
	
	-- COMBAT SKILLS
	{ name = "Archery", category = "combat", att1 = "PER", att2 = "DEX", multiple = 1 },
	{ name = "DODGE", category = "combat", att1 = "AGL", att2 = "PER", multiple = 2 },
	{ name = "Initiative", category = "combat", att1 = "WIL", att2 = "REA", multiple = 3 },
	{ name = "Melee", category = "combat", att1 = "DEX", att2 = "AGL", multiple = 2 },
	{ name = "SHOCK", category = "combat", att1 = "STR", att2 = "END", multiple = 3 },
	{ name = "Slings", category = "combat", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Throwing", category = "combat", att1 = "DEX", att2 = "PER", multiple = 2 },
	
	-- NATURE SKILLS
	{ name = "Agriculture", category = "nature", att1 = "PER", att2 = "WIL", multiple = 0 },
	{ name = "Animalcraft", category = "nature", att1 = "EMP", att2 = "WIL", multiple = 0 },
	{ name = "Fishing", category = "nature", att1 = "PER", att2 = "WIL", multiple = 0 },
	{ name = "Herbalore", category = "nature", att1 = "PER", att2 = "WIL", multiple = 0 },
	{ name = "Mineralogy", category = "nature", att1 = "PER", att2 = "REA", multiple = 0 },
	{ name = "Piloting", category = "nature", att1 = "REA", att2 = "PER", multiple = 0 },
	{ name = "Seamanship", category = "nature", att1 = "WIL", att2 = "PER", multiple = 0 },
	{ name = "Survival", category = "nature", att1 = "WIL", att2 = "REA", multiple = 1 },
	{ name = "Timbercraft", category = "nature", att1 = "PER", att2 = "REA", multiple = 0 },
	{ name = "Tracking", category = "nature", att1 = "REA", att2 = "PER", multiple = 0 },
	
	-- CRAFT SKILLS
	{ name = "Ceramics", category = "craft", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Drawing", category = "craft", att1 = "DEX", att2 = "CRE", multiple = 1 },
	{ name = "Fletching", category = "craft", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Glassworking", category = "craft", att1 = "PER", att2 = "DEX", multiple = 0 },
	{ name = "Hideworking", category = "craft", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Jewelcraft", category = "craft", att1 = "PER", att2 = "DEX", multiple = 0 },
	{ name = "Lockcraft", category = "craft", att1 = "DEX", att2 = "PER", multiple = 0 },
	{ name = "Masonry", category = "craft", att1 = "DEX", att2 = "STR", multiple = 0 },
	{ name = "Metalcraft", category = "craft", att1 = "DEX", att2 = "STR", multiple = 0 },
	{ name = "Milling", category = "craft", att1 = "PER", att2 = "STR", multiple = 0 },
	{ name = "Musician", category = "craft", att1 = "PER", att2 = "CRE", multiple = 0 },
	{ name = "Textilecraft", category = "craft", att1 = "AUR", att2 = "EMP", multiple = 0 },
	{ name = "Weaponcraft", category = "craft", att1 = "DEX", att2 = "STR", multiple = 0 },
	{ name = "Woodworking", category = "craft", att1 = "DEX", att2 = "STR", multiple = 0 },
	
	-- ESOTERICA SKILLS
	{ name = "Alchemy", category = "esoterica", att1 = "AUR", att2 = "PER", multiple = 0 },
	{ name = "Astrology", category = "esoterica", att1 = "AUR", att2 = "EMP", multiple = 0 },
	{ name = "Pvârism", category = "esoterica", att1 = "AUR", att2 = "REA", multiple = 0 },
	{ name = "Runecraft", category = "esoterica", att1 = "AUR", att2 = "EMP", multiple = 0 },
	{ name = "Spirit", category = "esoterica", att1 = "AUR", att2 = "WIL", multiple = 3 },
	{ name = "Summoning", category = "esoterica", att1 = "AUR", att2 = "ELO", multiple = 0 },
	{ name = "Talent", category = "esoterica", att1 = "AUR", att2 = "WIL", multiple = 0 },
	{ name = "Tarotry", category = "esoterica", att1 = "AUR", att2 = "EMP", multiple = 0 },
	{ name = "Trance", category = "esoterica", att1 = "AUR", att2 = "CRE", multiple = 0 },
};

-- Category mapping (XML list name to display name)
SkillsManager.categoryMap = {
	socialskills = "social",
	loreskills = "lore",
	physicalskills = "physical",
	combatskills = "combat",
	natureskills = "nature",
	craftskills = "craft",
	esotericaskills = "esoterica",
};

-- Default skills that appear on new characters
SkillsManager.defaultSkills = {
	"Awareness", "Climbing", "Initiative", "Stealth", "Folklore", "Survival"
};

-- onInit is called when the script loads
function onInit()
	if Debug then
		Debug.console("SkillsManager initialized with " .. #SkillsManager.allSkills .. " skills");
		Debug.console("Type of SkillsManager: " .. type(SkillsManager));
		Debug.console("Type of initializeDefaultSkills: " .. type(SkillsManager.initializeDefaultSkills));
		Debug.console("Type of getSkillsByListName: " .. type(SkillsManager.getSkillsByListName));
	end
end

-- Get all skills for a specific category
SkillsManager.getSkillsByCategory = function(sCategory)
	local result = {};
	for _, skill in ipairs(SkillsManager.allSkills) do
		if skill.category == sCategory then
			table.insert(result, skill);
		end
	end
	return result;
end

-- Get skills by XML list name (e.g., "socialskills")
SkillsManager.getSkillsByListName = function(sListName)
	local category = SkillsManager.categoryMap[sListName];
	if not category then
		if Debug then
			Debug.console("WARNING: Unknown skill list name: " .. sListName);
		end
		return {};
	end
	return SkillsManager.getSkillsByCategory(category);
end

-- Check if a skill is in the default list
SkillsManager.isDefaultSkill = function(sSkillName)
	for _, name in ipairs(SkillsManager.defaultSkills) do
		if name == sSkillName then
			return true;
		end
	end
	return false;
end

-- Get default skills for a category
SkillsManager.getDefaultSkillsForCategory = function(sCategory)
	local result = {};
	for _, skill in ipairs(SkillsManager.allSkills) do
		if skill.category == sCategory and SkillsManager.isDefaultSkill(skill.name) then
			table.insert(result, skill);
		end
	end
	return result;
end

-- Calculate Skill Base (SB) from character attributes
-- Formula: (ATT1 + ATT2) / 2
-- Round UP if ATT1 > ATT2, DOWN if ATT1 < ATT2
SkillsManager.calculateSB = function(nodeChar, sAtt1, sAtt2)
	if not nodeChar then return 0; end
	
	-- Get attribute scores
	-- VOI is special - stored directly as voi_score, not in attributes subnode
	local score1, score2;
	
	if sAtt1 == "VOI" then
		score1 = DB.getValue(nodeChar, "voi_score", 0);
	else
		score1 = DB.getValue(nodeChar, sAtt1:lower() .. "_score", 0);
	end
	
	if sAtt2 == "VOI" then
		score2 = DB.getValue(nodeChar, "voi_score", 0);
	else
		score2 = DB.getValue(nodeChar, sAtt2:lower() .. "_score", 0);
	end
	
	local avg = (score1 + score2) / 2;
	
	-- Apply rounding rule
	if score1 > score2 then
		return math.ceil(avg);
	else
		return math.floor(avg);
	end
end

-- Get skill definition by name
SkillsManager.getSkillByName = function(sSkillName)
	for _, skill in ipairs(SkillsManager.allSkills) do
		if skill.name == sSkillName then
			return skill;
		end
	end
	return nil;
end

-- Format attribute formula for display (e.g., "CML·EMP")
SkillsManager.formatAttributeFormula = function(sAtt1, sAtt2)
	return sAtt1 .. "·" .. sAtt2;
end

-- Add a skill to a character's skill list
SkillsManager.addSkillToCharacter = function(nodeChar, sListName, skillDef)
	if not nodeChar or not skillDef then return false; end
	
	local nodeList = DB.createChild(nodeChar, sListName);
	
	-- Check if skill already exists
	for _, nodeSkill in pairs(DB.getChildren(nodeList)) do
		if DB.getValue(nodeSkill, "name", "") == skillDef.name then
			if Debug then
				Debug.console("Skill already exists: " .. skillDef.name);
			end
			return false;
		end
	end
	
	-- Create new skill entry
	local nodeSkill = DB.createChild(nodeList);
	DB.setValue(nodeSkill, "name", "string", skillDef.name);
	DB.setValue(nodeSkill, "base", "string", SkillsManager.formatAttributeFormula(skillDef.att1, skillDef.att2));
	
	-- Calculate initial SB
	local sb = SkillsManager.calculateSB(nodeChar, skillDef.att1, skillDef.att2);
	DB.setValue(nodeSkill, "sb", "number", sb);
	DB.setValue(nodeSkill, "ml", "number", 0);
	
	if Debug then
		Debug.console("Added skill: " .. skillDef.name .. " (SB: " .. sb .. ")");
	end
	return true;
end

-- Initialize default skills for a character
SkillsManager.initializeDefaultSkills = function(nodeChar, sListName)
	if not nodeChar then return; end
	
	local category = SkillsManager.categoryMap[sListName];
	if not category then return; end
	
	local nodeList = DB.createChild(nodeChar, sListName);
	
	-- Only add defaults if list is empty
	if DB.getChildCount(nodeList) == 0 then
		local defaultSkills = SkillsManager.getDefaultSkillsForCategory(category);
		for _, skillDef in ipairs(defaultSkills) do
			SkillsManager.addSkillToCharacter(nodeChar, sListName, skillDef);
		end
	end
end

-- Update SB for a specific skill node
SkillsManager.updateSkillSB = function(nodeSkill, nodeChar)
	if not nodeSkill or not nodeChar then return; end
	
	local skillName = DB.getValue(nodeSkill, "name", "");
	local skillDef = SkillsManager.getSkillByName(skillName);
	
	if skillDef then
		local sb = SkillsManager.calculateSB(nodeChar, skillDef.att1, skillDef.att2);
		DB.setValue(nodeSkill, "sb", "number", sb);
	end
end

-- Update all skills' SB values for a character (call when attributes change)
SkillsManager.updateAllSkillSB = function(nodeChar)
	if not nodeChar then return; end
	
	for listName, _ in pairs(SkillsManager.categoryMap) do
		local nodeList = DB.getChild(nodeChar, listName);
		if nodeList then
			for _, nodeSkill in pairs(DB.getChildren(nodeList)) do
				SkillsManager.updateSkillSB(nodeSkill, nodeChar);
			end
		end
	end
	
	if Debug then
		Debug.console("Updated all skill SB values");
	end
end