--
-- HarnMaster Skills Data
-- Master list of all skills with their properties
--

SkillsData = {};

-- Skill Groups for the Skills Tab
SkillsData.SKILLS_TAB_GROUPS = nil;

-- Skill Groups for the Esoterica Tab
SkillsData.ESOTERICA_TAB_GROUPS = nil;

-- Master skill list (built in onInit)
SkillsData.skills = nil;

-- Lookup table by skill name (built in onInit)
SkillsData.byName = nil;

-- Initialize function - called when scripts are fully loaded
-- NOTE: Must be global 'onInit' for FG to call it automatically
function onInit()
	-- Initialize group lists
	SkillsData.SKILLS_TAB_GROUPS = {"Social", "Lore", "Physical", "Nature", "Craft", "Combat"};
	SkillsData.ESOTERICA_TAB_GROUPS = {"Esoterica", "Talents", "Spells", "Rituals"};

	-- Build master skill list
	-- Each skill has: name, group, att1, att2, sm (starting mastery - if > 0, it's a default skill)
	SkillsData.skills = {};

	-- SOCIAL Skills
	table.insert(SkillsData.skills, {name="Charm", group="Social", att1="CML", att2="EMP", sm=3});
	table.insert(SkillsData.skills, {name="Command", group="Social", att1="WIL", att2="ELO", sm=2});
	table.insert(SkillsData.skills, {name="Discourse", group="Social", att1="REA", att2="ELO", sm=2});
	table.insert(SkillsData.skills, {name="Guile", group="Social", att1="EMP", att2="CRE", sm=3});
	table.insert(SkillsData.skills, {name="Intrigue", group="Social", att1="EMP", att2="REA", sm=3});
	table.insert(SkillsData.skills, {name="Language", group="Social", att1="ELO", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Singing", group="Social", att1="VOI", att2="CRE", sm=3});
	table.insert(SkillsData.skills, {name="Theatrics", group="Social", att1="CRE", att2="ELO", sm=1});

	-- LORE Skills
	table.insert(SkillsData.skills, {name="Brewing", group="Lore", att1="PER", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Cookery", group="Lore", att1="PER", att2="REA", sm=2});
	table.insert(SkillsData.skills, {name="Embalming", group="Lore", att1="REA", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Engineering", group="Lore", att1="REA", att2="CRE", sm=0});
	table.insert(SkillsData.skills, {name="Folklore", group="Lore", att1="REA", att2="WIL", sm=1});
	table.insert(SkillsData.skills, {name="Heraldry", group="Lore", att1="REA", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Law", group="Lore", att1="REA", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Mathematics", group="Lore", att1="REA", att2="CRE", sm=0});
	table.insert(SkillsData.skills, {name="Mercantilism", group="Lore", att1="REA", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Perfumery", group="Lore", att1="PER", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Physician", group="Lore", att1="REA", att2="PER", sm=1});
	table.insert(SkillsData.skills, {name="Ritual", group="Lore", att1="WIL", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Script", group="Lore", att1="REA", att2="CRE", sm=0});
	table.insert(SkillsData.skills, {name="Shipwright", group="Lore", att1="REA", att2="CRE", sm=0});

	-- PHYSICAL Skills
	table.insert(SkillsData.skills, {name="Acrobatics", group="Physical", att1="AGL", att2="END", sm=0});
	table.insert(SkillsData.skills, {name="Awareness", group="Physical", att1="PER", att2="WIL", sm=3});
	table.insert(SkillsData.skills, {name="Climbing", group="Physical", att1="AGL", att2="DEX", sm=3});
	table.insert(SkillsData.skills, {name="Dancing", group="Physical", att1="AGL", att2="CRE", sm=2});
	table.insert(SkillsData.skills, {name="Jumping", group="Physical", att1="AGL", att2="STR", sm=3});
	table.insert(SkillsData.skills, {name="Legerdemain", group="Physical", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Riding", group="Physical", att1="EMP", att2="AGL", sm=1});
	table.insert(SkillsData.skills, {name="Stealth", group="Physical", att1="AGL", att2="WIL", sm=3});
	table.insert(SkillsData.skills, {name="Swimming", group="Physical", att1="AGL", att2="END", sm=1});

	-- NATURE Skills
	table.insert(SkillsData.skills, {name="Agriculture", group="Nature", att1="PER", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Animalcraft", group="Nature", att1="EMP", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Fishing", group="Nature", att1="PER", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Herblore", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Mineralogy", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Piloting", group="Nature", att1="REA", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Seamanship", group="Nature", att1="WIL", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Survival", group="Nature", att1="WIL", att2="REA", sm=1});
	table.insert(SkillsData.skills, {name="Timbercraft", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Tracking", group="Nature", att1="REA", att2="PER", sm=0});

	-- CRAFT Skills
	table.insert(SkillsData.skills, {name="Ceramics", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Drawing", group="Craft", att1="DEX", att2="CRE", sm=1});
	table.insert(SkillsData.skills, {name="Fletching", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Glassworking", group="Craft", att1="PER", att2="DEX", sm=0});
	table.insert(SkillsData.skills, {name="Hideworking", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Jewelcraft", group="Craft", att1="PER", att2="DEX", sm=0});
	table.insert(SkillsData.skills, {name="Lockcraft", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Masonry", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(SkillsData.skills, {name="Metalcraft", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(SkillsData.skills, {name="Milling", group="Craft", att1="PER", att2="STR", sm=0});
	table.insert(SkillsData.skills, {name="Musician", group="Craft", att1="PER", att2="CRE", sm=0});
	table.insert(SkillsData.skills, {name="Textilecraft", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Weaponcraft", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(SkillsData.skills, {name="Woodworking", group="Craft", att1="DEX", att2="STR", sm=0});

	-- COMBAT Skills
	table.insert(SkillsData.skills, {name="Archery", group="Combat", att1="PER", att2="DEX", sm=1});
	table.insert(SkillsData.skills, {name="Dodge", group="Combat", att1="AGL", att2="PER", sm=2});
	table.insert(SkillsData.skills, {name="Initiative", group="Combat", att1="WIL", att2="REA", sm=3});
	table.insert(SkillsData.skills, {name="Melee", group="Combat", att1="DEX", att2="AGL", sm=2});
	table.insert(SkillsData.skills, {name="Shock", group="Combat", att1="STR", att2="END", sm=3});
	table.insert(SkillsData.skills, {name="Slings", group="Combat", att1="DEX", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Throwing", group="Combat", att1="DEX", att2="PER", sm=2});

	-- ESOTERICA Skills
	table.insert(SkillsData.skills, {name="Alchemy", group="Esoterica", att1="AUR", att2="PER", sm=0});
	table.insert(SkillsData.skills, {name="Astrology", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(SkillsData.skills, {name="Pvarism", group="Esoterica", att1="AUR", att2="REA", sm=0});
	table.insert(SkillsData.skills, {name="Runecraft", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(SkillsData.skills, {name="Spirit", group="Esoterica", att1="AUR", att2="WIL", sm=3});
	table.insert(SkillsData.skills, {name="Summoning", group="Esoterica", att1="AUR", att2="ELO", sm=0});
	table.insert(SkillsData.skills, {name="Talent", group="Esoterica", att1="AUR", att2="WIL", sm=0});
	table.insert(SkillsData.skills, {name="Tarotry", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(SkillsData.skills, {name="Trance", group="Esoterica", att1="AUR", att2="CRE", sm=0});

	-- Build lookup table by skill name for quick access
	SkillsData.byName = {};
	for _, skill in ipairs(SkillsData.skills) do
		SkillsData.byName[skill.name] = skill;
	end

	-- Store skills data in the database for cross-script access
	-- First, delete any existing data to prevent duplicates on reload
	local nodeExisting = DB.findNode("harnmaster.skills");
	if nodeExisting then
		nodeExisting.delete();
		Debug.console("Cleared existing harnmaster.skills node");
	end

	-- Now create fresh reference data
	local nodeSkillsRef = DB.createNode("harnmaster.skills");
	for _, skill in ipairs(SkillsData.skills) do
		local nodeSkill = DB.createChild(nodeSkillsRef);
		DB.setValue(nodeSkill, "name", "string", skill.name);
		DB.setValue(nodeSkill, "group", "string", skill.group);
		DB.setValue(nodeSkill, "att1", "string", skill.att1);
		DB.setValue(nodeSkill, "att2", "string", skill.att2);
		DB.setValue(nodeSkill, "sm", "number", skill.sm);
	end

	Debug.console("SkillsData initialized with " .. #SkillsData.skills .. " skills");
	Debug.console("SkillsData stored in database at harnmaster.skills");
end

-- Get all skills for a specific group
function SkillsData.getSkillsByGroup(sGroup)
	local aSkills = {};
	if not SkillsData.skills then return aSkills; end
	for _, skill in ipairs(SkillsData.skills) do
		if skill.group == sGroup then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get all default skills (sm > 0) for a specific group
function SkillsData.getDefaultSkillsByGroup(sGroup)
	local aSkills = {};
	if not SkillsData.skills then return aSkills; end
	for _, skill in ipairs(SkillsData.skills) do
		if skill.group == sGroup and skill.sm > 0 then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get all default skills (sm > 0)
function SkillsData.getDefaultSkills()
	local aSkills = {};
	if not SkillsData.skills then return aSkills; end
	for _, skill in ipairs(SkillsData.skills) do
		if skill.sm > 0 then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get skill data by name
function SkillsData.getSkill(sName)
	if not SkillsData.byName then return nil; end
	return SkillsData.byName[sName];
end

-- Check if a group belongs to Skills tab
function SkillsData.isSkillsTabGroup(sGroup)
	if not SkillsData.SKILLS_TAB_GROUPS then return false; end
	for _, g in ipairs(SkillsData.SKILLS_TAB_GROUPS) do
		if g == sGroup then
			return true;
		end
	end
	return false;
end

-- Check if a group belongs to Esoterica tab
function SkillsData.isEsotericaTabGroup(sGroup)
	if not SkillsData.ESOTERICA_TAB_GROUPS then return false; end
	for _, g in ipairs(SkillsData.ESOTERICA_TAB_GROUPS) do
		if g == sGroup then
			return true;
		end
	end
	return false;
end
