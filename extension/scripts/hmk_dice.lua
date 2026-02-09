-- HMK Dice Rolling
-- Handles /hmk slash command for skill checks
-- Usage: /hmk d100 60  or  /hmk d100 charm  or  /hmk d10 5

-- Attribute lookup: abbreviation and full name → ML field + display name
local ATTRIBUTE_ML_MAP = {
	["str"] = {field = "str_ml", display = "Strength"},
	["strength"] = {field = "str_ml", display = "Strength"},
	["end"] = {field = "end_ml", display = "Endurance"},
	["endurance"] = {field = "end_ml", display = "Endurance"},
	["dex"] = {field = "dex_ml", display = "Dexterity"},
	["dexterity"] = {field = "dex_ml", display = "Dexterity"},
	["agl"] = {field = "agl_ml", display = "Agility"},
	["agility"] = {field = "agl_ml", display = "Agility"},
	["per"] = {field = "per_ml", display = "Perception"},
	["perception"] = {field = "per_ml", display = "Perception"},
	["cml"] = {field = "cml_ml", display = "Comeliness"},
	["comeliness"] = {field = "cml_ml", display = "Comeliness"},
	["aur"] = {field = "aur_ml", display = "Aura"},
	["aura"] = {field = "aur_ml", display = "Aura"},
	["wil"] = {field = "wil_ml", display = "Will"},
	["will"] = {field = "wil_ml", display = "Will"},
	["rea"] = {field = "rea_ml", display = "Reasoning"},
	["reasoning"] = {field = "rea_ml", display = "Reasoning"},
	["cre"] = {field = "cre_ml", display = "Creativity"},
	["creativity"] = {field = "cre_ml", display = "Creativity"},
	["emp"] = {field = "emp_ml", display = "Empathy"},
	["empathy"] = {field = "emp_ml", display = "Empathy"},
	["elo"] = {field = "elo_ml", display = "Eloquence"},
	["eloquence"] = {field = "elo_ml", display = "Eloquence"},
};

-- All skill/esoterica list DB paths to search
local SKILL_LISTS = {
	"socialskills", "loreskills", "physicalskills",
	"natureskills", "craftskills", "combatskills",
	"esotericalist", "spellslist", "talentslist", "alchemylist",
};

function onInit()
	Comm.registerSlashHandler("hmk", processHMKRoll);
	Comm.registerSlashHandler("eml", processEMLQuery);
	GameSystem.actions["hmk"] = { bUseModStack = false };
	ActionsManager.registerResultHandler("hmk", onHMKResult);
	Debug.console("HMKDice: /hmk and /eml slash commands registered");
end

-- Get the active character node for the player typing the command
function getActiveCharacterNode()
	local sIdentity = User.getCurrentIdentity();
	if not sIdentity or sIdentity == "" then
		return nil, "No active character. Select a character portrait to use skill-based rolls.";
	end
	local nodeChar = DB.findNode("charsheet." .. sIdentity);
	if not nodeChar then
		return nil, "Character data not found for identity: " .. sIdentity;
	end
	return nodeChar, nil;
end

-- Look up a skill or attribute ML on the character
-- Returns: nML, sDisplayName  or  nil, nil
function lookupML(nodeChar, sQuery)
	local sLower = sQuery:lower():match("^%s*(.-)%s*$");

	-- 1. Check attributes
	local tAttr = ATTRIBUTE_ML_MAP[sLower];
	if tAttr then
		local nML = DB.getValue(nodeChar, tAttr.field, 0);
		return nML, tAttr.display;
	end

	-- 2. Search all skill and esoterica lists
	for _, sListName in ipairs(SKILL_LISTS) do
		local nodeList = DB.getChild(nodeChar, sListName);
		if nodeList then
			for _, nodeEntry in pairs(DB.getChildList(nodeList)) do
				local sName = DB.getValue(nodeEntry, "name", "");
				if sName:lower() == sLower then
					local nML = DB.getValue(nodeEntry, "ml", 0);
					Debug.console("[lookupML] Found in " .. sListName .. " at " .. DB.getPath(nodeEntry) .. ", ml=" .. tostring(nML));
					return nML, sName;
				end
			end
		end
	end

	return nil, nil;
end

-- Send a local error/info message to chat
function chatMessage(sText)
	local msg = {};
	msg.text = sText;
	msg.font = "systemfont";
	msg.sender = "";
	Comm.addChatMessage(msg);
end

function processHMKRoll(sCommand, sParams)
	-- Parse: die type + everything after it
	local sDie, sTarget = string.match(sParams, "^%s*(d%d+)%s+(.+)%s*$");
	if not sDie or not sTarget then
		chatMessage("[HMK] Usage: /hmk d100 <target> or /hmk d100 <skill name>");
		return;
	end
	sTarget = sTarget:match("^%s*(.-)%s*$");

	local nTarget = tonumber(sTarget);
	local sSkillName = nil;

	if not nTarget then
		-- Skill/attribute lookup
		local nodeChar, sError = getActiveCharacterNode();
		if not nodeChar then
			chatMessage("[HMK] " .. sError);
			return;
		end

		local nML, sDisplayName = lookupML(nodeChar, sTarget);
		if not nML then
			chatMessage("[HMK] Skill or attribute \"" .. sTarget .. "\" not found on character sheet.");
			return;
		end

		nTarget = nML;
		sSkillName = sDisplayName;
	end

	local rRoll = {};
	rRoll.sType = "hmk";
	if sSkillName then
		rRoll.sDesc = "[HMK] " .. string.upper(sDie) .. " " .. sSkillName .. " vs TN " .. nTarget;
	else
		rRoll.sDesc = "[HMK] " .. string.upper(sDie) .. " vs TN " .. nTarget;
	end
	rRoll.aDice = { sDie };
	rRoll.nMod = 0;
	rRoll.nTarget = nTarget;
	rRoll.sDieType = string.lower(sDie);

	ActionsManager.performAction(nil, nil, rRoll);
end

function onHMKResult(rSource, rTarget, rRoll)
	local nTotal = ActionsManager.total(rRoll);
	local nTarget = rRoll.nTarget or 0;
	local bIsD100 = (rRoll.sDieType == "d100");

	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	-- Determine result
	local sResult, sFont;
	if bIsD100 then
		sResult, sFont = resolveD100(nTotal, nTarget);
	else
		-- Simple pass/fail for non-d100
		if nTotal <= nTarget then
			local nMargin = nTarget - nTotal;
			sResult = "SUCCESS (Margin: " .. nMargin .. ")";
			sFont = "oocfont";
		else
			local nMargin = nTotal - nTarget;
			sResult = "FAILURE (Margin: " .. nMargin .. ")";
			sFont = "emotefont";
		end
	end

	rMessage.text = rMessage.text .. " = " .. sResult;
	rMessage.font = sFont;
	Comm.deliverChatMessage(rMessage);
end

-- D100 critical resolution
-- Priority: 95 = always CF, >95 = always F, then div-by-5 criticals, then normal
function resolveD100(nTotal, nTarget)
	if nTotal == 95 then
		local nMargin = nTotal - nTarget;
		return "CRITICAL FAILURE (Margin: " .. nMargin .. ")", "emotefont";
	end

	if nTotal > 95 then
		local nMargin = nTotal - nTarget;
		return "FAILURE (Margin: " .. nMargin .. ")", "emotefont";
	end

	local bCritical = (nTotal % 5 == 0);

	if nTotal <= nTarget then
		local nMargin = nTarget - nTotal;
		if bCritical then
			return "CRITICAL SUCCESS (Margin: " .. nMargin .. ")", "oocfont";
		else
			return "SUCCESS (Margin: " .. nMargin .. ")", "oocfont";
		end
	else
		local nMargin = nTotal - nTarget;
		if bCritical then
			return "CRITICAL FAILURE (Margin: " .. nMargin .. ")", "emotefont";
		else
			return "FAILURE (Margin: " .. nMargin .. ")", "emotefont";
		end
	end
end

-----------------------------------------------------------
-- EML Query Command: /eml <character> <skill>
-----------------------------------------------------------

-- Find a character node by name (case-insensitive partial match)
function findCharacterByName(sName)
	if not sName or sName == "" then return nil, nil; end
	local sLower = sName:lower();

	local nodeCharsheet = DB.findNode("charsheet");
	if not nodeCharsheet then return nil, nil; end

	for _, nodeChar in pairs(DB.getChildList(nodeCharsheet)) do
		local sCharName = DB.getValue(nodeChar, "name", "");
		if sCharName:lower() == sLower then
			return nodeChar, sCharName;
		end
	end

	-- Partial match fallback
	for _, nodeChar in pairs(DB.getChildList(nodeCharsheet)) do
		local sCharName = DB.getValue(nodeChar, "name", "");
		if sCharName:lower():find(sLower, 1, true) then
			return nodeChar, sCharName;
		end
	end

	return nil, nil;
end

-- Process /eml <character> <skill> command
function processEMLQuery(sCommand, sParams)
	-- Parse: first word = character name, rest = skill name
	-- Support quoted character names: /eml "Jimbo the Great" Melee
	local sCharName, sSkillName;

	-- Check for quoted character name
	local sQuoted, sRest = sParams:match('^%s*"([^"]+)"%s+(.+)%s*$');
	if sQuoted then
		sCharName = sQuoted;
		sSkillName = sRest;
	else
		-- Simple space-separated: first word is character, rest is skill
		sCharName, sSkillName = sParams:match("^%s*(%S+)%s+(.+)%s*$");
	end

	if not sCharName or not sSkillName then
		chatMessage('[EML] Usage: /eml <character> <skill>  (e.g., /eml Jimbo Melee)');
		return;
	end

	sSkillName = sSkillName:match("^%s*(.-)%s*$");

	-- Find the character
	local nodeChar, sFoundName = findCharacterByName(sCharName);
	if not nodeChar then
		chatMessage('[EML] Character "' .. sCharName .. '" not found.');
		return;
	end

	-- Look up the skill ML
	local nML, sDisplayName = lookupML(nodeChar, sSkillName);
	if not nML then
		chatMessage('[EML] Skill "' .. sSkillName .. '" not found on ' .. sFoundName .. "'s character sheet.");
		return;
	end

	-- Calculate EML using HarnManager
	local nEML = nML;
	local nZoneImpairment = 0;
	if HarnManager and HarnManager.calculateEML then
		nEML = HarnManager.calculateEML(nodeChar, nML, sDisplayName);
	end
	if HarnManager and HarnManager.calculateZoneImpairment then
		nZoneImpairment = HarnManager.calculateZoneImpairment(nodeChar, sDisplayName);
	end

	-- Get penalty breakdown for display
	local nFatigue = 0;
	local nEnc = 0;
	if HarnManager and HarnManager.calculateFatiguePenalty then
		nFatigue = HarnManager.calculateFatiguePenalty(nodeChar);
	end
	if HarnManager and HarnManager.isAGLSkill and HarnManager.isAGLSkill(sDisplayName) then
		nEnc = DB.getValue(nodeChar, "enc_total", 0);
	end

	-- Build result message
	local sResult = "[EML] " .. sFoundName .. " - " .. sDisplayName .. ": ML " .. nML;
	if nFatigue > 0 or nEnc > 0 or nZoneImpairment > 0 then
		sResult = sResult .. " - " .. (nFatigue + nEnc + nZoneImpairment) .. " (";
		local tParts = {};
		if nFatigue > 0 then table.insert(tParts, "Fatigue " .. nFatigue); end
		if nEnc > 0 then table.insert(tParts, "ENC " .. nEnc); end
		if nZoneImpairment > 0 then table.insert(tParts, "Zone " .. nZoneImpairment); end
		sResult = sResult .. table.concat(tParts, ", ") .. ")";
	end
	sResult = sResult .. " = EML " .. nEML;

	chatMessage(sResult);
end
