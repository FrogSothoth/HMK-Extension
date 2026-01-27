--
-- HarnMaster Dice Manager
-- Handles d100 test rolls against target numbers with FGU dice animation
--
-- Test Results:
--   Critical Success: Roll <= target AND divisible by 5
--   Success: Roll <= target
--   Failure: Roll > target (or roll > 95)
--   Critical Failure: Roll > target AND divisible by 5 (or roll == 95)
--

-- Result category constants
CRITICAL_SUCCESS = "CS";
SUCCESS = "S";
FAILURE = "F";
CRITICAL_FAILURE = "CF";

-- Result display names
local tResultNames = {
	[CRITICAL_SUCCESS] = "Critical Success",
	[SUCCESS] = "Success",
	[FAILURE] = "Failure",
	[CRITICAL_FAILURE] = "Critical Failure"
};

--
-- Evaluate a d100 roll against a target number
-- @param nRoll The d100 result (1-100)
-- @param nTarget The target number to roll against
-- @return sResult Result category (CS, S, F, CF)
--
function evaluateTest(nRoll, nTarget)
	-- Special case: 95 is always Critical Failure
	if nRoll == 95 then
		return CRITICAL_FAILURE;
	end

	-- Special case: Above 95 is always Failure (never critical)
	if nRoll > 95 then
		return FAILURE;
	end

	-- Check success/failure
	if nRoll <= nTarget then
		-- Success - check for critical (divisible by 5)
		if nRoll % 5 == 0 then
			return CRITICAL_SUCCESS;
		else
			return SUCCESS;
		end
	else
		-- Failure - check for critical (divisible by 5)
		if nRoll % 5 == 0 then
			return CRITICAL_FAILURE;
		else
			return FAILURE;
		end
	end
end

--
-- Get the display name for a result category
-- @param sResult Result category code (CS, S, F, CF)
-- @return string Full display name
--
function getResultName(sResult)
	return tResultNames[sResult] or sResult;
end

--
-- Build a roll structure for the test
-- @param nTarget The target number to roll against
-- @param sDescription Optional description for the roll
-- @return rRoll The roll structure
--
function getRoll(nTarget, sDescription)
	local rRoll = {};
	rRoll.sType = "hmtest";
	rRoll.aDice = {"d100"};
	rRoll.nMod = 0;
	rRoll.nTarget = nTarget;
	rRoll.sDesc = "[TEST] " .. (sDescription or "Test") .. " vs " .. nTarget;
	return rRoll;
end

--
-- Perform a test roll with FGU dice animation
-- @param nTarget The target number to roll against
-- @param sDescription Optional description for the roll
--
function rollTest(nTarget, sDescription)
	local rRoll = getRoll(nTarget, sDescription);

	-- Perform the action (this triggers the dice animation)
	ActionsManager.performAction(nil, nil, rRoll);

	Debug.console("DiceManager.rollTest: Throwing d100 vs " .. nTarget);
end

--
-- Handle the test result (called by ActionsManager when dice land)
-- @param rSource Source actor (may be nil)
-- @param rTarget Target actor (may be nil)
-- @param rRoll The roll data including dice results
--
function onTest(rSource, rTarget, rRoll)
	Debug.console("DiceManager.onTest called");

	-- Calculate the total roll
	local nRoll = ActionsManager.total(rRoll);
	local nTarget = rRoll.nTarget or 50;

	Debug.console("DiceManager.onTest: Roll=" .. nRoll .. ", Target=" .. nTarget);

	-- Evaluate the result
	local sResult = evaluateTest(nRoll, nTarget);
	local sResultName = getResultName(sResult);

	-- Build the chat message
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	-- Append the result
	rMessage.text = rMessage.text .. "\nRoll: " .. nRoll .. " = " .. sResultName;

	-- Deliver to chat
	Comm.deliverChatMessage(rMessage);
end

--
-- Process /test slash command
-- Usage: /test <target> [description]
--
function processTestCommand(sCommand, sParams)
	-- Parse parameters
	local sTarget, sDesc = sParams:match("^(%d+)%s*(.*)$");

	if not sTarget then
		local rMessage = {
			font = "chatfont",
			text = "Usage: /test <target> [description]\nExample: /test 65 Sword attack"
		};
		Comm.deliverChatMessage(rMessage);
		return;
	end

	local nTarget = tonumber(sTarget);
	if not nTarget or nTarget < 1 or nTarget > 100 then
		local rMessage = {
			font = "chatfont",
			text = "Target must be a number between 1 and 100"
		};
		Comm.deliverChatMessage(rMessage);
		return;
	end

	-- Perform the test roll with animation
	rollTest(nTarget, sDesc);
end

--
-- Initialize the DiceManager
--
function onInit()
	-- Register /test slash command
	Comm.registerSlashHandler("test", processTestCommand);

	-- Register our action type with ActionsManager
	ActionsManager.registerResultHandler("hmtest", onTest);

	Debug.console("DiceManager initialized - use /test <target> [description]");
end
