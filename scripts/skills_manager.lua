--
-- HarnMaster Skills Manager
-- Handles skill operations: adding, calculating SB, initializing defaults
--

SkillsManager = {};

-- Initialize function - called when scripts are fully loaded
function SkillsManager.onInit()
	-- Manager is ready
end

-- Database node names for each skill group
SkillsManager.GROUP_NODES = {
	["Social"] = "socialskills",
	["Lore"] = "loreskills",
	["Physical"] = "physicalskills",
	["Nature"] = "natureskills",
	["Craft"] = "craftskills",
	["Combat"] = "combatskills",
	["Esoterica"] = "esotericaskills",
	["Talents"] = "talents",
	["Spells"] = "spells",
	["Rituals"] = "rituals",
};

-- Get the database node name for a skill group
function SkillsManager.getNodeNameForGroup(sGroup)
	return SkillsManager.GROUP_NODES[sGroup] or "miscskills";
end

-- Get attribute value from character node
-- Returns the score value for the given attribute abbreviation
function SkillsManager.getAttributeValue(nodeChar, sAttrAbbr)
	if not nodeChar or not sAttrAbbr then
		return 0;
	end

	-- Map attribute abbreviations to database field names
	-- Field names are like str_score, end_score, dex_score, etc.
	local attrMap = {
		["STR"] = "str_score",
		["END"] = "end_score",
		["DEX"] = "dex_score",
		["AGL"] = "agl_score",
		["PER"] = "per_score",
		["CML"] = "cml_score",
		["AUR"] = "aur_score",
		["WIL"] = "wil_score",
		["REA"] = "rea_score",
		["CRE"] = "cre_score",
		["EMP"] = "emp_score",
		["ELO"] = "elo_score",
		["VOI"] = "voi_score",
	};

	local sFieldName = attrMap[sAttrAbbr:upper()];
	if not sFieldName then
		Debug.console("SkillsManager: Unknown attribute abbreviation: " .. tostring(sAttrAbbr));
		return 0;
	end

	-- Get the score value
	local nValue = DB.getValue(nodeChar, sFieldName, 0);
	return nValue;
end

-- Calculate Skill Base (SB) from two attributes
-- SB = (Attr1 + Attr2) / 2
-- Rounding: UP if Attr1 > Attr2, DOWN if Attr1 < Attr2, normal if equal
function SkillsManager.calculateSB(nodeChar, sAtt1, sAtt2)
	local nAtt1 = SkillsManager.getAttributeValue(nodeChar, sAtt1);
	local nAtt2 = SkillsManager.getAttributeValue(nodeChar, sAtt2);

	local nSum = nAtt1 + nAtt2;
	local nSB;

	if nAtt1 > nAtt2 then
		-- Round up
		nSB = math.ceil(nSum / 2);
	elseif nAtt1 < nAtt2 then
		-- Round down
		nSB = math.floor(nSum / 2);
	else
		-- Equal - standard rounding
		nSB = math.floor(nSum / 2 + 0.5);
	end

	return nSB;
end

-- Add a skill to a character
-- Returns the newly created skill node
function SkillsManager.addSkillToCharacter(nodeChar, sSkillName, sGroup)
	if not nodeChar then
		Debug.console("SkillsManager.addSkillToCharacter: No character node");
		return nil;
	end

	-- Get skill data
	local skillData = SkillsData.getSkill(sSkillName);
	if not skillData then
		Debug.console("SkillsManager.addSkillToCharacter: Unknown skill: " .. tostring(sSkillName));
		return nil;
	end

	-- Use provided group or skill's default group
	local sTargetGroup = sGroup or skillData.group;
	local sListName = SkillsManager.getNodeNameForGroup(sTargetGroup);

	-- Create the skill list if it doesn't exist
	local nodeList = DB.createChild(nodeChar, sListName);

	-- Check if skill already exists
	for _, nodeSkill in ipairs(DB.getChildList(nodeList)) do
		if DB.getValue(nodeSkill, "name", "") == sSkillName then
			Debug.console("SkillsManager.addSkillToCharacter: Skill already exists: " .. sSkillName);
			return nodeSkill;
		end
	end

	-- Create the skill node
	local nodeSkill = DB.createChild(nodeList);

	-- Set skill properties
	DB.setValue(nodeSkill, "name", "string", skillData.name);
	DB.setValue(nodeSkill, "att1", "string", skillData.att1);
	DB.setValue(nodeSkill, "att2", "string", skillData.att2);
	DB.setValue(nodeSkill, "sm", "number", skillData.sm);

	-- Calculate and set SB
	local nSB = SkillsManager.calculateSB(nodeChar, skillData.att1, skillData.att2);
	DB.setValue(nodeSkill, "sb", "number", nSB);

	-- Initialize ML to 0
	DB.setValue(nodeSkill, "ml", "number", 0);

	return nodeSkill;
end

-- Initialize default skills for a character (skills with sm > 0)
function SkillsManager.initializeDefaultSkills(nodeChar)
	if not nodeChar then
		return;
	end

	local aDefaultSkills = SkillsData.getDefaultSkills();

	for _, skillData in ipairs(aDefaultSkills) do
		SkillsManager.addSkillToCharacter(nodeChar, skillData.name);
	end

	Debug.console("SkillsManager: Initialized " .. #aDefaultSkills .. " default skills");
end

-- Initialize default skills for a specific group
function SkillsManager.initializeDefaultSkillsForGroup(nodeChar, sGroup)
	if not nodeChar then
		return;
	end

	local sListName = SkillsManager.getNodeNameForGroup(sGroup);
	local nodeList = DB.getChild(nodeChar, sListName);

	-- Only initialize if the list is empty or doesn't exist
	if nodeList and DB.getChildCount(nodeList) > 0 then
		return;
	end

	local aDefaultSkills = SkillsData.getDefaultSkillsByGroup(sGroup);

	for _, skillData in ipairs(aDefaultSkills) do
		SkillsManager.addSkillToCharacter(nodeChar, skillData.name);
	end
end

-- Recalculate SB for all skills of a character
-- Call this when attributes change
function SkillsManager.recalculateAllSB(nodeChar)
	if not nodeChar then
		return;
	end

	-- Iterate through all skill group nodes
	for sGroup, sListName in pairs(SkillsManager.GROUP_NODES) do
		local nodeList = DB.getChild(nodeChar, sListName);
		if nodeList then
			for _, nodeSkill in ipairs(DB.getChildList(nodeList)) do
				local sAtt1 = DB.getValue(nodeSkill, "att1", "");
				local sAtt2 = DB.getValue(nodeSkill, "att2", "");

				if sAtt1 ~= "" and sAtt2 ~= "" then
					local nSB = SkillsManager.calculateSB(nodeChar, sAtt1, sAtt2);
					DB.setValue(nodeSkill, "sb", "number", nSB);
				end
			end
		end
	end
end

-- Get list of available skills for a group that character doesn't have yet
function SkillsManager.getAvailableSkillsForGroup(nodeChar, sGroup)
	local aAvailable = {};
	local aGroupSkills = SkillsData.getSkillsByGroup(sGroup);

	-- Get list of skills character already has
	local sListName = SkillsManager.getNodeNameForGroup(sGroup);
	local nodeList = DB.getChild(nodeChar, sListName);
	local aExisting = {};

	if nodeList then
		for _, nodeSkill in ipairs(DB.getChildList(nodeList)) do
			local sName = DB.getValue(nodeSkill, "name", "");
			aExisting[sName] = true;
		end
	end

	-- Filter out existing skills
	for _, skillData in ipairs(aGroupSkills) do
		if not aExisting[skillData.name] then
			table.insert(aAvailable, skillData);
		end
	end

	return aAvailable;
end
