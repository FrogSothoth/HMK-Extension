--
-- HarnMaster Extension
-- Main manager script
--

function onInit()
	Debug.chat("HarnMaster character sheet extension loaded!")
end

function onClose()
	-- Cleanup
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

-- Sunsign data: each entry is {startDay, endDay, sunsignName, mod1, mod2, mod3, mod4, mod5, mod6}
-- Modifiers stored for future use
local SUNSIGN_DATA = {
	{1, 2, "Lado", 10, 0, -10, 10, 0, -10},
	{2, 4, "Lado-Ulandus", 10, 0, -10, 15, 5, -5},
	{5, 6, "Ulandus-Lado", 10, 0, -10, 15, 5, -5},
	{7, 31, "Ulandus", 5, -5, -15, 15, 5, -5},
	{32, 33, "Ulandus-Aralius", 5, -5, -10, 15, 10, 0},
	{34, 35, "Aralius-Ulandus", 5, -5, -10, 15, 10, 0},
	{36, 60, "Aralius", 0, -10, -10, 10, 10, 0},
	{61, 62, "Aralius-Feneri", 0, -10, -5, 10, 15, 5},
	{63, 65, "Feneri-Aralius", 0, -10, -5, 10, 15, 5},
	{66, 91, "Feneri", -5, -15, -5, 5, 15, 5},
	{92, 93, "Feneri-Ahnu", -5, -10, 0, 5, 15, 10},
	{94, 95, "Ahnu-Feneri", -5, -10, 0, 5, 15, 10},
	{96, 123, "Ahnu", -10, -10, 0, 0, 10, 10},
	{124, 125, "Ahnu-Angberelius", -10, -5, 5, 0, 10, 15},
	{126, 127, "Angberelius-Ahnu", -10, -5, 5, 0, 10, 15},
	{128, 154, "Angberelius", -15, -5, 5, -5, 5, 15},
	{155, 156, "Angberelius-Nadai", -10, 0, 10, -5, 5, 15},
	{157, 158, "Nadai-Angberelius", -10, 0, 10, -5, 5, 15},
	{159, 183, "Nadai", -10, 0, 10, -10, 0, 10},
	{184, 185, "Nadai-Hirin", -5, 5, 15, -10, 0, 10},
	{186, 187, "Hirin-Nadai", -5, 5, 15, -10, 0, 10},
	{188, 212, "Hirin", -5, 5, 15, -15, -5, 5},
	{213, 214, "Hirin-Tarael", 0, 10, 15, -10, -5, 5},
	{215, 216, "Tarael-Hirin", 0, 10, 15, -10, -5, 5},
	{217, 241, "Tarael", 0, 10, 10, -10, -10, 0},
	{242, 243, "Tarael-Tai", 5, 15, 10, -5, -10, 0},
	{244, 245, "Tai-Tarael", 5, 15, 10, -5, -10, 0},
	{246, 270, "Tai", 5, 15, 5, -5, 15, -5},
	{271, 272, "Tai-Skorus", 10, 15, 5, 0, -10, -5},
	{273, 274, "Skorus-Tai", 10, 15, 5, 0, -10, -5},
	{275, 300, "Skorus", 10, 10, 0, 0, -10, -10},
	{301, 302, "Skorus-Masara", 15, 10, 0, 5, -5, -10},
	{303, 304, "Masara-Skorus", 15, 10, 0, 5, -5, -10},
	{305, 329, "Masara", 15, 5, -5, 5, -5, -15},
	{330, 331, "Masara-Lado", 15, 5, -5, 10, 0, -10},
	{332, 333, "Lado-Masara", 15, 5, -5, 10, 0, -10},
	{334, 360, "Lado", 10, 0, -10, 10, 0, -10},
}

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
-- Returns: sunsignName, mod1, mod2, mod3, mod4, mod5, mod6
function getSunsignData(nDayOfYear)
	for _, entry in ipairs(SUNSIGN_DATA) do
		if nDayOfYear >= entry[1] and nDayOfYear <= entry[2] then
			return entry[3], entry[4], entry[5], entry[6], entry[7], entry[8], entry[9]
		end
	end
	return "Unknown", 0, 0, 0, 0, 0, 0
end

-- Get just the sunsign name from month name and day
function getSunsign(sMonthName, nDay)
	local nMonth = getMonthValue(sMonthName)
	if nMonth == 0 then return "" end

	local nDayOfYear = calculateDayOfYear(nMonth, nDay)
	if nDayOfYear == 0 then return "" end

	local sSunsign = getSunsignData(nDayOfYear)
	return sSunsign
end