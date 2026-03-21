--
-- HarnMaster Skills Data
-- Master list of all skills with their properties
--
-- NOTE: Data is stored in local variables, functions are defined without prefix
-- so FGU can properly export them through the SkillsData namespace.
--

-- Skill Groups for the Skills Tab
local _SKILLS_TAB_GROUPS = nil;

-- Skill Groups for the Esoterica Tab
local _ESOTERICA_TAB_GROUPS = nil;

-- Master skill list (built in onInit)
local _skills = nil;

-- Lookup table by skill name (built in onInit)
local _byName = nil;

-- Master spell list (built in onInit)
local _spells = nil;

-- Lookup table by spell name (built in onInit)
local _spellsByName = nil;

-- Master talents list (built in onInit)
local _talents = nil;

-- Lookup table by talent name (built in onInit)
local _talentsByName = nil;

-- Master alchemy list (built in onInit)
local _alchemy = nil;

-- Lookup table by alchemy name (built in onInit)
local _alchemyByName = nil;

-- Initialize function - called when scripts are fully loaded
-- NOTE: Must be global 'onInit' for FG to call it automatically
function onInit()
	-- Initialize group lists
	_SKILLS_TAB_GROUPS = {"Social", "Lore", "Physical", "Nature", "Craft", "Combat"};
	_ESOTERICA_TAB_GROUPS = {"Esoterica", "Talents", "Spells", "Rituals"};

	-- Build master skill list
	-- Each skill has: name, group, att1, att2, sm (starting mastery - if > 0, it's a default skill)
	_skills = {};

	-- SOCIAL Skills
	table.insert(_skills, {name="Charm", group="Social", att1="CML", att2="EMP", sm=3});
	table.insert(_skills, {name="Command", group="Social", att1="WIL", att2="ELO", sm=2});
	table.insert(_skills, {name="Discourse", group="Social", att1="REA", att2="ELO", sm=2});
	table.insert(_skills, {name="Guile", group="Social", att1="EMP", att2="CRE", sm=3});
	table.insert(_skills, {name="Intrigue", group="Social", att1="EMP", att2="REA", sm=3});
	table.insert(_skills, {name="Language", group="Social", att1="ELO", att2="REA", sm=0});
	table.insert(_skills, {name="Singing", group="Social", att1="VOI", att2="CRE", sm=3});
	table.insert(_skills, {name="Theatrics", group="Social", att1="CRE", att2="ELO", sm=1});

	-- LORE Skills
	table.insert(_skills, {name="Brewing", group="Lore", att1="PER", att2="REA", sm=0});
	table.insert(_skills, {name="Cookery", group="Lore", att1="PER", att2="REA", sm=2});
	table.insert(_skills, {name="Embalming", group="Lore", att1="REA", att2="PER", sm=0});
	table.insert(_skills, {name="Engineering", group="Lore", att1="REA", att2="CRE", sm=0});
	table.insert(_skills, {name="Folklore", group="Lore", att1="REA", att2="WIL", sm=1});
	table.insert(_skills, {name="Heraldry", group="Lore", att1="REA", att2="WIL", sm=0});
	table.insert(_skills, {name="Law", group="Lore", att1="REA", att2="WIL", sm=0});
	table.insert(_skills, {name="Mathematics", group="Lore", att1="REA", att2="CRE", sm=0});
	table.insert(_skills, {name="Mercantilism", group="Lore", att1="REA", att2="PER", sm=0});
	table.insert(_skills, {name="Perfumery", group="Lore", att1="PER", att2="REA", sm=0});
	table.insert(_skills, {name="Physician", group="Lore", att1="REA", att2="PER", sm=1});
	table.insert(_skills, {name="Ritual", group="Lore", att1="WIL", att2="REA", sm=0});
	table.insert(_skills, {name="Script", group="Lore", att1="REA", att2="PER", sm=0});
	table.insert(_skills, {name="Shipwright", group="Lore", att1="REA", att2="CRE", sm=0});

	-- PHYSICAL Skills
	table.insert(_skills, {name="Acrobatics", group="Physical", att1="AGL", att2="END", sm=0});
	table.insert(_skills, {name="Awareness", group="Physical", att1="PER", att2="WIL", sm=3});
	table.insert(_skills, {name="Climbing", group="Physical", att1="AGL", att2="DEX", sm=3});
	table.insert(_skills, {name="Dancing", group="Physical", att1="AGL", att2="CRE", sm=2});
	table.insert(_skills, {name="Jumping", group="Physical", att1="AGL", att2="STR", sm=3});
	table.insert(_skills, {name="Legerdemain", group="Physical", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Riding", group="Physical", att1="EMP", att2="AGL", sm=1});
	table.insert(_skills, {name="Stealth", group="Physical", att1="AGL", att2="WIL", sm=3});
	table.insert(_skills, {name="Swimming", group="Physical", att1="AGL", att2="END", sm=1});

	-- NATURE Skills
	table.insert(_skills, {name="Agriculture", group="Nature", att1="PER", att2="WIL", sm=0});
	table.insert(_skills, {name="Animalcraft", group="Nature", att1="EMP", att2="WIL", sm=0});
	table.insert(_skills, {name="Fishing", group="Nature", att1="PER", att2="WIL", sm=0});
	table.insert(_skills, {name="Herblore", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(_skills, {name="Mineralogy", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(_skills, {name="Piloting", group="Nature", att1="REA", att2="PER", sm=0});
	table.insert(_skills, {name="Seamanship", group="Nature", att1="WIL", att2="PER", sm=0});
	table.insert(_skills, {name="Survival", group="Nature", att1="WIL", att2="REA", sm=1});
	table.insert(_skills, {name="Timbercraft", group="Nature", att1="PER", att2="REA", sm=0});
	table.insert(_skills, {name="Tracking", group="Nature", att1="REA", att2="PER", sm=0});

	-- CRAFT Skills
	table.insert(_skills, {name="Ceramics", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Drawing", group="Craft", att1="DEX", att2="CRE", sm=1});
	table.insert(_skills, {name="Fletching", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Glassworking", group="Craft", att1="PER", att2="DEX", sm=0});
	table.insert(_skills, {name="Hideworking", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Jewelcraft", group="Craft", att1="PER", att2="DEX", sm=0});
	table.insert(_skills, {name="Lockcraft", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Masonry", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(_skills, {name="Metalcraft", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(_skills, {name="Milling", group="Craft", att1="PER", att2="STR", sm=0});
	table.insert(_skills, {name="Musician", group="Craft", att1="PER", att2="CRE", sm=0});
	table.insert(_skills, {name="Textilecraft", group="Craft", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Weaponcraft", group="Craft", att1="DEX", att2="STR", sm=0});
	table.insert(_skills, {name="Woodworking", group="Craft", att1="DEX", att2="STR", sm=0});

	-- COMBAT Skills
	table.insert(_skills, {name="Archery", group="Combat", att1="PER", att2="DEX", sm=1});
	table.insert(_skills, {name="Dodge", group="Combat", att1="AGL", att2="PER", sm=2});
	table.insert(_skills, {name="Initiative", group="Combat", att1="WIL", att2="REA", sm=3});
	table.insert(_skills, {name="Melee", group="Combat", att1="DEX", att2="AGL", sm=2});
	table.insert(_skills, {name="Shock", group="Combat", att1="STR", att2="END", sm=3});
	table.insert(_skills, {name="Slings", group="Combat", att1="DEX", att2="PER", sm=0});
	table.insert(_skills, {name="Throwing", group="Combat", att1="DEX", att2="PER", sm=2});

	-- ESOTERICA Skills
	table.insert(_skills, {name="Alchemy", group="Esoterica", att1="AUR", att2="PER", sm=0});
	table.insert(_skills, {name="Astrology", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(_skills, {name="Pvarism", group="Esoterica", att1="AUR", att2="REA", sm=0});
	table.insert(_skills, {name="Runecraft", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(_skills, {name="Spirit", group="Esoterica", att1="AUR", att2="WIL", sm=3});
	table.insert(_skills, {name="Summoning", group="Esoterica", att1="AUR", att2="ELO", sm=0});
	table.insert(_skills, {name="Talent", group="Esoterica", att1="AUR", att2="WIL", sm=0});
	table.insert(_skills, {name="Tarotry", group="Esoterica", att1="AUR", att2="EMP", sm=0});
	table.insert(_skills, {name="Trance", group="Esoterica", att1="AUR", att2="CRE", sm=0});

	-- Build lookup table by skill name for quick access
	_byName = {};
	for _, skill in ipairs(_skills) do
		_byName[skill.name] = skill;
	end

	-- Build master spell list
	-- Each spell has: name, conv (convocation), cmp (complexity)
	_spells = {};

	-- PVARIC SPELLS
	-- Format: {name="Spell Name", conv="Convocation", cmp=complexity_number}

	-- FYVRIA Convocation
	table.insert(_spells, {name="Balm", conv="Fyvria", cmp=1});
	table.insert(_spells, {name="Decay", conv="Fyvria", cmp=1});
	table.insert(_spells, {name="Growth", conv="Fyvria", cmp=1});
	table.insert(_spells, {name="Shape", conv="Fyvria", cmp=1});
	table.insert(_spells, {name="Diagnosis", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Pox", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Stay", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Syncope", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Tremor", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Victual", conv="Fyvria", cmp=2});
	table.insert(_spells, {name="Hunger", conv="Fyvria", cmp=3});
	table.insert(_spells, {name="Nurture", conv="Fyvria", cmp=3});
	table.insert(_spells, {name="Physique", conv="Fyvria", cmp=3});
	table.insert(_spells, {name="Transfer", conv="Fyvria", cmp=3});
	table.insert(_spells, {name="Warp", conv="Fyvria", cmp=3});
	table.insert(_spells, {name="Earthwork", conv="Fyvria", cmp=4});
	table.insert(_spells, {name="Guardian", conv="Fyvria", cmp=4});
	table.insert(_spells, {name="Slumber", conv="Fyvria", cmp=4});
	table.insert(_spells, {name="Vine", conv="Fyvria", cmp=4});
	table.insert(_spells, {name="Wasting", conv="Fyvria", cmp=4});
	table.insert(_spells, {name="Animus", conv="Fyvria", cmp=5});
	table.insert(_spells, {name="Balsam", conv="Fyvria", cmp=5});
	table.insert(_spells, {name="Succour", conv="Fyvria", cmp=5});
	table.insert(_spells, {name="Tunnel", conv="Fyvria", cmp=5});
	table.insert(_spells, {name="Beckon", conv="Fyvria", cmp=6});
	table.insert(_spells, {name="Meld", conv="Fyvria", cmp=6});
	table.insert(_spells, {name="Petrification", conv="Fyvria", cmp=6});
	table.insert(_spells, {name="Regenesis", conv="Fyvria", cmp=6});

	-- JMORVI Convocation
	table.insert(_spells, {name="Lustre", conv="Jmorvi", cmp=1});
	table.insert(_spells, {name="Protection", conv="Jmorvi", cmp=1});
	table.insert(_spells, {name="Revelation", conv="Jmorvi", cmp=1});
	table.insert(_spells, {name="Sight", conv="Jmorvi", cmp=1});
	table.insert(_spells, {name="Aspect", conv="Jmorvi", cmp=2});
	table.insert(_spells, {name="Dart", conv="Jmorvi", cmp=2});
	table.insert(_spells, {name="Foundry", conv="Jmorvi", cmp=2});
	table.insert(_spells, {name="Magnet", conv="Jmorvi", cmp=2});
	table.insert(_spells, {name="Tempering", conv="Jmorvi", cmp=2});
	table.insert(_spells, {name="Anvil", conv="Jmorvi", cmp=3});
	table.insert(_spells, {name="Charm", conv="Jmorvi", cmp=3});
	table.insert(_spells, {name="Mend", conv="Jmorvi", cmp=3});
	table.insert(_spells, {name="Repel", conv="Jmorvi", cmp=3});
	table.insert(_spells, {name="Singing Sword", conv="Jmorvi", cmp=3});
	table.insert(_spells, {name="Fist", conv="Jmorvi", cmp=4});
	table.insert(_spells, {name="Forge", conv="Jmorvi", cmp=4});
	table.insert(_spells, {name="Mephitis", conv="Jmorvi", cmp=4});
	table.insert(_spells, {name="Steel", conv="Jmorvi", cmp=4});
	table.insert(_spells, {name="Swordbreaker", conv="Jmorvi", cmp=4});
	table.insert(_spells, {name="Armour", conv="Jmorvi", cmp=5});
	table.insert(_spells, {name="Hand", conv="Jmorvi", cmp=5});
	table.insert(_spells, {name="Mould", conv="Jmorvi", cmp=5});
	table.insert(_spells, {name="Restoration", conv="Jmorvi", cmp=5});
	table.insert(_spells, {name="Shroud", conv="Jmorvi", cmp=5});
	table.insert(_spells, {name="Assemble", conv="Jmorvi", cmp=6});
	table.insert(_spells, {name="Lance", conv="Jmorvi", cmp=6});
	table.insert(_spells, {name="Screen", conv="Jmorvi", cmp=6});
	table.insert(_spells, {name="Shatter", conv="Jmorvi", cmp=6});

	-- PELEAHN Convocation
	table.insert(_spells, {name="Caress", conv="Peleahn", cmp=1});
	table.insert(_spells, {name="Desiccation", conv="Peleahn", cmp=1});
	table.insert(_spells, {name="Flame", conv="Peleahn", cmp=1});
	table.insert(_spells, {name="Heat", conv="Peleahn", cmp=1});
	table.insert(_spells, {name="Sphere", conv="Peleahn", cmp=1});
	table.insert(_spells, {name="Cloak", conv="Peleahn", cmp=2});
	table.insert(_spells, {name="Fireworks", conv="Peleahn", cmp=2});
	table.insert(_spells, {name="Hastening", conv="Peleahn", cmp=2});
	table.insert(_spells, {name="Skin", conv="Peleahn", cmp=2});
	table.insert(_spells, {name="Thirst", conv="Peleahn", cmp=2});
	table.insert(_spells, {name="Brand", conv="Peleahn", cmp=3});
	table.insert(_spells, {name="Eyes", conv="Peleahn", cmp=3});
	table.insert(_spells, {name="Pyre", conv="Peleahn", cmp=3});
	table.insert(_spells, {name="Shooting Star", conv="Peleahn", cmp=3});
	table.insert(_spells, {name="Conflagration", conv="Peleahn", cmp=4});
	table.insert(_spells, {name="Envelope", conv="Peleahn", cmp=4});
	table.insert(_spells, {name="Fever", conv="Peleahn", cmp=4});
	table.insert(_spells, {name="Wall", conv="Peleahn", cmp=4});
	table.insert(_spells, {name="Doom Curtain", conv="Peleahn", cmp=5});
	table.insert(_spells, {name="Gauntlet", conv="Peleahn", cmp=5});
	table.insert(_spells, {name="Immolation", conv="Peleahn", cmp=5});
	table.insert(_spells, {name="Meteor", conv="Peleahn", cmp=5});
	table.insert(_spells, {name="Seeker", conv="Peleahn", cmp=5});
	table.insert(_spells, {name="Burn", conv="Peleahn", cmp=6});
	table.insert(_spells, {name="Convoke", conv="Peleahn", cmp=6});
	table.insert(_spells, {name="Doom Flame", conv="Peleahn", cmp=6});
	table.insert(_spells, {name="Fire Fiend", conv="Peleahn", cmp=6});
	table.insert(_spells, {name="Mantle", conv="Peleahn", cmp=6});

	-- LYAHVI Convocation
	table.insert(_spells, {name="Beacon", conv="Lyahvi", cmp=1});
	table.insert(_spells, {name="Muffle", conv="Lyahvi", cmp=1});
	table.insert(_spells, {name="Palm", conv="Lyahvi", cmp=1});
	table.insert(_spells, {name="Stench", conv="Lyahvi", cmp=1});
	table.insert(_spells, {name="Whisper", conv="Lyahvi", cmp=1});
	table.insert(_spells, {name="Flash", conv="Lyahvi", cmp=2});
	table.insert(_spells, {name="Lens", conv="Lyahvi", cmp=2});
	table.insert(_spells, {name="Pocket", conv="Lyahvi", cmp=2});
	table.insert(_spells, {name="Sound", conv="Lyahvi", cmp=2});
	table.insert(_spells, {name="Voice", conv="Lyahvi", cmp=2});
	table.insert(_spells, {name="Caecity", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="Globe", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="Image", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="Prism", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="Unveiling", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="View", conv="Lyahvi", cmp=3});
	table.insert(_spells, {name="Beam", conv="Lyahvi", cmp=4});
	table.insert(_spells, {name="Curtain", conv="Lyahvi", cmp=4});
	table.insert(_spells, {name="Mirror", conv="Lyahvi", cmp=4});
	table.insert(_spells, {name="Nightmare", conv="Lyahvi", cmp=4});
	table.insert(_spells, {name="Glamour", conv="Lyahvi", cmp=5});
	table.insert(_spells, {name="Motes", conv="Lyahvi", cmp=5});
	table.insert(_spells, {name="Passage", conv="Lyahvi", cmp=5});
	table.insert(_spells, {name="Tube", conv="Lyahvi", cmp=5});
	table.insert(_spells, {name="Call", conv="Lyahvi", cmp=6});
	table.insert(_spells, {name="Figure", conv="Lyahvi", cmp=6});
	table.insert(_spells, {name="Vapour", conv="Lyahvi", cmp=6});
	table.insert(_spells, {name="Wind", conv="Lyahvi", cmp=6});

	-- SAVORYA Convocation
	table.insert(_spells, {name="Candour", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Diversion", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Enquiry", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Harmony", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Sensation", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Solace", conv="Savorya", cmp=1});
	table.insert(_spells, {name="Enrichment", conv="Savorya", cmp=2});
	table.insert(_spells, {name="Feel", conv="Savorya", cmp=2});
	table.insert(_spells, {name="Fervour", conv="Savorya", cmp=2});
	table.insert(_spells, {name="Insight", conv="Savorya", cmp=2});
	table.insert(_spells, {name="Thought", conv="Savorya", cmp=2});
	table.insert(_spells, {name="Missive", conv="Savorya", cmp=3});
	table.insert(_spells, {name="Panic", conv="Savorya", cmp=3});
	table.insert(_spells, {name="Quill", conv="Savorya", cmp=3});
	table.insert(_spells, {name="Wisdom", conv="Savorya", cmp=3});
	table.insert(_spells, {name="Key", conv="Savorya", cmp=4});
	table.insert(_spells, {name="Link", conv="Savorya", cmp=4});
	table.insert(_spells, {name="Obedience", conv="Savorya", cmp=4});
	table.insert(_spells, {name="Probity", conv="Savorya", cmp=4});
	table.insert(_spells, {name="Recollection", conv="Savorya", cmp=4});
	table.insert(_spells, {name="Aural Blast", conv="Savorya", cmp=5});
	table.insert(_spells, {name="Confusion", conv="Savorya", cmp=5});
	table.insert(_spells, {name="Enervation", conv="Savorya", cmp=5});
	table.insert(_spells, {name="Perspective", conv="Savorya", cmp=5});
	table.insert(_spells, {name="Host", conv="Savorya", cmp=6});
	table.insert(_spells, {name="Rupture", conv="Savorya", cmp=6});
	table.insert(_spells, {name="Suggestion", conv="Savorya", cmp=6});
	table.insert(_spells, {name="Veil", conv="Savorya", cmp=6});

	-- ODIVSHE Convocation
	table.insert(_spells, {name="Cooling", conv="Odivshe", cmp=1});
	table.insert(_spells, {name="Flotation", conv="Odivshe", cmp=1});
	table.insert(_spells, {name="Quenching", conv="Odivshe", cmp=1});
	table.insert(_spells, {name="Spoon", conv="Odivshe", cmp=1});
	table.insert(_spells, {name="Alchema", conv="Odivshe", cmp=2});
	table.insert(_spells, {name="Dowsing", conv="Odivshe", cmp=2});
	table.insert(_spells, {name="Hush", conv="Odivshe", cmp=2});
	table.insert(_spells, {name="Shadow", conv="Odivshe", cmp=2});
	table.insert(_spells, {name="Sponge", conv="Odivshe", cmp=2});
	table.insert(_spells, {name="Breath", conv="Odivshe", cmp=3});
	table.insert(_spells, {name="Crystals", conv="Odivshe", cmp=3});
	table.insert(_spells, {name="Freeze", conv="Odivshe", cmp=3});
	table.insert(_spells, {name="Gills", conv="Odivshe", cmp=3});
	table.insert(_spells, {name="Condensation", conv="Odivshe", cmp=4});
	table.insert(_spells, {name="Pall", conv="Odivshe", cmp=4});
	table.insert(_spells, {name="Sweat", conv="Odivshe", cmp=4});
	table.insert(_spells, {name="Tide", conv="Odivshe", cmp=4});
	table.insert(_spells, {name="Calm", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="Gloomweb", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="Icewalk", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="Restoration", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="River", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="Wave", conv="Odivshe", cmp=5});
	table.insert(_spells, {name="Conjure", conv="Odivshe", cmp=6});
	table.insert(_spells, {name="Enigma", conv="Odivshe", cmp=6});
	table.insert(_spells, {name="Floe", conv="Odivshe", cmp=6});
	table.insert(_spells, {name="Snowball", conv="Odivshe", cmp=6});
	table.insert(_spells, {name="Waterwalk", conv="Odivshe", cmp=6});

	-- NEUTRAL Spells
	table.insert(_spells, {name="Absorb", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Aegis", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Attune", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Detect", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Reveal", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Survey", conv="Neutral", cmp=1});
	table.insert(_spells, {name="Alarm", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Bane", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Charge", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Dispel", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Distort", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Imbue", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Monitor", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Tap", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Ward", conv="Neutral", cmp=2});
	table.insert(_spells, {name="Counter", conv="Neutral", cmp=3});
	table.insert(_spells, {name="False Soul", conv="Neutral", cmp=3});
	table.insert(_spells, {name="Focus", conv="Neutral", cmp=3});
	table.insert(_spells, {name="Fount", conv="Neutral", cmp=3});
	table.insert(_spells, {name="Pool", conv="Neutral", cmp=3});
	table.insert(_spells, {name="Trigger", conv="Neutral", cmp=3});
	table.insert(_spells, {name="Chain", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Converse", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Resolve", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Resurge", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Sanctum", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Subvert", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Vessel", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Well", conv="Neutral", cmp=4});
	table.insert(_spells, {name="Gate", conv="Neutral", cmp=5});
	table.insert(_spells, {name="Investment", conv="Neutral", cmp=5});
	table.insert(_spells, {name="Mask", conv="Neutral", cmp=5});
	table.insert(_spells, {name="Reverse", conv="Neutral", cmp=5});
	table.insert(_spells, {name="Bubble", conv="Neutral", cmp=6});
	table.insert(_spells, {name="Personality", conv="Neutral", cmp=6});
	table.insert(_spells, {name="Vortex", conv="Neutral", cmp=6});

	-- Build lookup table by spell name for quick access
	_spellsByName = {};
	for _, spell in ipairs(_spells) do
		_spellsByName[spell.name] = spell;
	end

	-- Build master talents list
	-- Each talent has: name
	_talents = {};

	-- PSIONIC TALENTS
	table.insert(_talents, {name="Amplification"});
	table.insert(_talents, {name="Clairvoyance"});
	table.insert(_talents, {name="Disembodiment"});
	table.insert(_talents, {name="Elemental Bolt"});
	table.insert(_talents, {name="Enthral"});
	table.insert(_talents, {name="Extratemporality"});
	table.insert(_talents, {name="Healing"});
	table.insert(_talents, {name="Hex"});
	table.insert(_talents, {name="Medium"});
	table.insert(_talents, {name="Natural Attunement"});
	table.insert(_talents, {name="Negation"});
	table.insert(_talents, {name="Prescience"});
	table.insert(_talents, {name="Psychometry"});
	table.insert(_talents, {name="Sensitivity"});
	table.insert(_talents, {name="Telekinesis"});
	table.insert(_talents, {name="Telepathy"});
	table.insert(_talents, {name="Transference"});
	table.insert(_talents, {name="Transformation"});
	table.insert(_talents, {name="Visnomy"});

	-- Build lookup table by talent name for quick access
	_talentsByName = {};
	for _, talent in ipairs(_talents) do
		_talentsByName[talent.name] = talent;
	end

	-- Build master alchemy list
	-- Each alchemy has: name
	_alchemy = {};

	-- ALCHEMICAL FORMULAS
	table.insert(_alchemy, {name="Acid"});
	table.insert(_alchemy, {name="Airtrap"});
	table.insert(_alchemy, {name="Aqua"});
	table.insert(_alchemy, {name="Darkvision"});
	table.insert(_alchemy, {name="Dreamwalk"});
	table.insert(_alchemy, {name="Egosight"});
	table.insert(_alchemy, {name="Equipoise"});
	table.insert(_alchemy, {name="Erudition"});
	table.insert(_alchemy, {name="Eruption"});
	table.insert(_alchemy, {name="Exsiccation"});
	table.insert(_alchemy, {name="Fireshield"});
	table.insert(_alchemy, {name="Footpad"});
	table.insert(_alchemy, {name="Formfix"});
	table.insert(_alchemy, {name="Fumebomb"});
	table.insert(_alchemy, {name="Ghostsight"});
	table.insert(_alchemy, {name="Healing"});
	table.insert(_alchemy, {name="Iceshield"});
	table.insert(_alchemy, {name="Mending"});
	table.insert(_alchemy, {name="Might"});
	table.insert(_alchemy, {name="Mindsalve"});
	table.insert(_alchemy, {name="Object Aegis"});
	table.insert(_alchemy, {name="Passion"});
	table.insert(_alchemy, {name="Physic"});
	table.insert(_alchemy, {name="Poison"});
	table.insert(_alchemy, {name="Quiescence"});
	table.insert(_alchemy, {name="Shadowbreath"});
	table.insert(_alchemy, {name="Shout"});
	table.insert(_alchemy, {name="Soulbuffer"});
	table.insert(_alchemy, {name="Soulcloak"});
	table.insert(_alchemy, {name="Sustenance"});
	table.insert(_alchemy, {name="Traumashield"});
	table.insert(_alchemy, {name="Verity"});
	table.insert(_alchemy, {name="Wakefulness"});
	table.insert(_alchemy, {name="Warmth"});
	table.insert(_alchemy, {name="Weakness"});

	-- Build lookup table by alchemy name for quick access
	_alchemyByName = {};
	for _, alch in ipairs(_alchemy) do
		_alchemyByName[alch.name] = alch;
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
	for _, skill in ipairs(_skills) do
		local nodeSkill = DB.createChild(nodeSkillsRef);
		DB.setValue(nodeSkill, "name", "string", skill.name);
		DB.setValue(nodeSkill, "group", "string", skill.group);
		DB.setValue(nodeSkill, "att1", "string", skill.att1);
		DB.setValue(nodeSkill, "att2", "string", skill.att2);
		DB.setValue(nodeSkill, "sm", "number", skill.sm);
	end

	Debug.console("SkillsData initialized with " .. #_skills .. " skills");
	Debug.console("SkillsData stored in database at harnmaster.skills");

	-- Store spells data in the database for cross-script access
	-- First, delete any existing data to prevent duplicates on reload
	local nodeExistingSpells = DB.findNode("harnmaster.spells");
	if nodeExistingSpells then
		nodeExistingSpells.delete();
		Debug.console("Cleared existing harnmaster.spells node");
	end

	-- Now create fresh spell reference data
	local nodeSpellsRef = DB.createNode("harnmaster.spells");
	for _, spell in ipairs(_spells) do
		local nodeSpell = DB.createChild(nodeSpellsRef);
		DB.setValue(nodeSpell, "name", "string", spell.name);
		DB.setValue(nodeSpell, "conv", "string", spell.conv);
		DB.setValue(nodeSpell, "cmp", "number", spell.cmp);
	end

	Debug.console("SkillsData initialized with " .. #_spells .. " spells");
	Debug.console("SkillsData stored in database at harnmaster.spells");

	-- Store talents data in the database for cross-script access
	-- First, delete any existing data to prevent duplicates on reload
	local nodeExistingTalents = DB.findNode("harnmaster.talents");
	if nodeExistingTalents then
		nodeExistingTalents.delete();
		Debug.console("Cleared existing harnmaster.talents node");
	end

	-- Now create fresh talent reference data
	local nodeTalentsRef = DB.createNode("harnmaster.talents");
	for _, talent in ipairs(_talents) do
		local nodeTalent = DB.createChild(nodeTalentsRef);
		DB.setValue(nodeTalent, "name", "string", talent.name);
	end

	Debug.console("SkillsData initialized with " .. #_talents .. " talents");
	Debug.console("SkillsData stored in database at harnmaster.talents");

	-- Store alchemy data in the database for cross-script access
	-- First, delete any existing data to prevent duplicates on reload
	local nodeExistingAlchemy = DB.findNode("harnmaster.alchemy");
	if nodeExistingAlchemy then
		nodeExistingAlchemy.delete();
		Debug.console("Cleared existing harnmaster.alchemy node");
	end

	-- Now create fresh alchemy reference data
	local nodeAlchemyRef = DB.createNode("harnmaster.alchemy");
	for _, alch in ipairs(_alchemy) do
		local nodeAlch = DB.createChild(nodeAlchemyRef);
		DB.setValue(nodeAlch, "name", "string", alch.name);
	end

	Debug.console("SkillsData initialized with " .. #_alchemy .. " alchemy formulas");
	Debug.console("SkillsData stored in database at harnmaster.alchemy");
end

-- Get all skills for a specific group
function getSkillsByGroup(sGroup)
	local aSkills = {};
	if not _skills then return aSkills; end
	for _, skill in ipairs(_skills) do
		if skill.group == sGroup then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get all default skills (sm > 0) for a specific group
function getDefaultSkillsByGroup(sGroup)
	local aSkills = {};
	if not _skills then return aSkills; end
	for _, skill in ipairs(_skills) do
		if skill.group == sGroup and skill.sm > 0 then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get all default skills (sm > 0)
function getDefaultSkills()
	local aSkills = {};
	if not _skills then return aSkills; end
	for _, skill in ipairs(_skills) do
		if skill.sm > 0 then
			table.insert(aSkills, skill);
		end
	end
	return aSkills;
end

-- Get skill data by name
function getSkill(sName)
	if not _byName then return nil; end
	return _byName[sName];
end

-- Check if a group belongs to Skills tab
function isSkillsTabGroup(sGroup)
	if not _SKILLS_TAB_GROUPS then return false; end
	for _, g in ipairs(_SKILLS_TAB_GROUPS) do
		if g == sGroup then
			return true;
		end
	end
	return false;
end

-- Check if a group belongs to Esoterica tab
function isEsotericaTabGroup(sGroup)
	if not _ESOTERICA_TAB_GROUPS then return false; end
	for _, g in ipairs(_ESOTERICA_TAB_GROUPS) do
		if g == sGroup then
			return true;
		end
	end
	return false;
end

-- Get spell data by name
function getSpell(sName)
	if not _spellsByName then return nil; end
	return _spellsByName[sName];
end

-- Get all spells for a specific convocation
function getSpellsByConvocation(sConv)
	local aSpells = {};
	if not _spells then return aSpells; end
	for _, spell in ipairs(_spells) do
		if spell.conv == sConv then
			table.insert(aSpells, spell);
		end
	end
	return aSpells;
end

-- Get all spells
function getAllSpells()
	if not _spells then return {}; end
	return _spells;
end

-- Get talent data by name
function getTalent(sName)
	if not _talentsByName then return nil; end
	return _talentsByName[sName];
end

-- Get all talents
function getAllTalents()
	if not _talents then return {}; end
	return _talents;
end

-- Check if a talent name is valid
function isValidTalent(sName)
	if not _talentsByName then return false; end
	return _talentsByName[sName] ~= nil;
end

-- Get alchemy data by name
function getAlchemy(sName)
	if not _alchemyByName then return nil; end
	return _alchemyByName[sName];
end

-- Get all alchemy formulas
function getAllAlchemy()
	if not _alchemy then return {}; end
	return _alchemy;
end

-- Check if an alchemy name is valid
function isValidAlchemy(sName)
	if not _alchemyByName then return false; end
	return _alchemyByName[sName] ~= nil;
end

-- CONVOCATION ADJACENCY DATA
-- Maps Primary Convocation -> { Related Convocation = Degree Modifier }
-- Degree Modifiers: 0=Primary, 1=Secondary, 3=Tertiary, 4=Diametric
local _CONVOCATION_ADJACENCY = {
	["FYVRIA"]  = { ["FYVRIA"]=0, ["JMORVI"]=1, ["ODIVSHE"]=1, ["PELEAHN"]=3, ["SAVORYA"]=3, ["LYAHVI"]=4 },
	["JMORVI"]  = { ["JMORVI"]=0, ["FYVRIA"]=1, ["PELEAHN"]=1, ["LYAHVI"]=3,  ["ODIVSHE"]=3, ["SAVORYA"]=4 },
	["PELEAHN"] = { ["PELEAHN"]=0,["JMORVI"]=1, ["LYAHVI"]=1,  ["FYVRIA"]=3,  ["SAVORYA"]=3, ["ODIVSHE"]=4 },
	["LYAHVI"]  = { ["LYAHVI"]=0, ["PELEAHN"]=1,["SAVORYA"]=1, ["JMORVI"]=3,  ["ODIVSHE"]=3, ["FYVRIA"]=4 },
	["SAVORYA"] = { ["SAVORYA"]=0,["LYAHVI"]=1, ["ODIVSHE"]=1, ["FYVRIA"]=3,  ["PELEAHN"]=3, ["JMORVI"]=4 },
	["ODIVSHE"] = { ["ODIVSHE"]=0,["FYVRIA"]=1, ["SAVORYA"]=1, ["JMORVI"]=3,  ["LYAHVI"]=3,  ["PELEAHN"]=4 }
}

-- Returns the Degree Modifier for a spell based on character's Primary Convocation
-- 0=Primary, 1=Secondary, 2=Neutral, 3=Tertiary, 4=Diametric
-- Neutral spells always return 2. If Primary is undefined, defaults to 4.
function getConvocationAdjacencyModifier(sPrimary, sSpellConv)
	local sUpperSpell = string.upper(sSpellConv or "")
	if sUpperSpell == "NEUTRAL" then return 2 end
	
	local sUpperPrimary = string.upper(sPrimary or "")
	if _CONVOCATION_ADJACENCY[sUpperPrimary] then
		local modifier = _CONVOCATION_ADJACENCY[sUpperPrimary][sUpperSpell]
		if modifier then
			return modifier
		end
	end
	
	-- Fallback if not found
	return 4
end
