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

-- Master spell list (built in onInit)
SkillsData.spells = nil;

-- Lookup table by spell name (built in onInit)
SkillsData.spellsByName = nil;

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

	-- Build master spell list
	-- Each spell has: name, conv (convocation), cmp (complexity)
	SkillsData.spells = {};

	-- PVARIC SPELLS
	-- Format: {name="Spell Name", conv="Convocation", cmp=complexity_number}

	-- FYVRIA Convocation
	table.insert(SkillsData.spells, {name="Balm", conv="Fyvria", cmp=1});
	table.insert(SkillsData.spells, {name="Decay", conv="Fyvria", cmp=1});
	table.insert(SkillsData.spells, {name="Growth", conv="Fyvria", cmp=1});
	table.insert(SkillsData.spells, {name="Shape", conv="Fyvria", cmp=1});
	table.insert(SkillsData.spells, {name="Diagnosis", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Pox", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Stay", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Syncope", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Tremor", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Victual", conv="Fyvria", cmp=2});
	table.insert(SkillsData.spells, {name="Hunger", conv="Fyvria", cmp=3});
	table.insert(SkillsData.spells, {name="Nurture", conv="Fyvria", cmp=3});
	table.insert(SkillsData.spells, {name="Physique", conv="Fyvria", cmp=3});
	table.insert(SkillsData.spells, {name="Transfer", conv="Fyvria", cmp=3});
	table.insert(SkillsData.spells, {name="Warp", conv="Fyvria", cmp=3});
	table.insert(SkillsData.spells, {name="Earthwork", conv="Fyvria", cmp=4});
	table.insert(SkillsData.spells, {name="Guardian", conv="Fyvria", cmp=4});
	table.insert(SkillsData.spells, {name="Slumber", conv="Fyvria", cmp=4});
	table.insert(SkillsData.spells, {name="Vine", conv="Fyvria", cmp=4});
	table.insert(SkillsData.spells, {name="Wasting", conv="Fyvria", cmp=4});
	table.insert(SkillsData.spells, {name="Animus", conv="Fyvria", cmp=5});
	table.insert(SkillsData.spells, {name="Balsam", conv="Fyvria", cmp=5});
	table.insert(SkillsData.spells, {name="Succour", conv="Fyvria", cmp=5});
	table.insert(SkillsData.spells, {name="Tunnel", conv="Fyvria", cmp=5});
	table.insert(SkillsData.spells, {name="Beckon", conv="Fyvria", cmp=6});
	table.insert(SkillsData.spells, {name="Meld", conv="Fyvria", cmp=6});
	table.insert(SkillsData.spells, {name="Petrification", conv="Fyvria", cmp=6});
	table.insert(SkillsData.spells, {name="Regenesis", conv="Fyvria", cmp=6});

	-- JMORVI Convocation
	table.insert(SkillsData.spells, {name="Lustre", conv="Jmorvi", cmp=1});
	table.insert(SkillsData.spells, {name="Protection", conv="Jmorvi", cmp=1});
	table.insert(SkillsData.spells, {name="Revelation", conv="Jmorvi", cmp=1});
	table.insert(SkillsData.spells, {name="Sight", conv="Jmorvi", cmp=1});
	table.insert(SkillsData.spells, {name="Aspect", conv="Jmorvi", cmp=2});
	table.insert(SkillsData.spells, {name="Dart", conv="Jmorvi", cmp=2});
	table.insert(SkillsData.spells, {name="Foundry", conv="Jmorvi", cmp=2});
	table.insert(SkillsData.spells, {name="Magnet", conv="Jmorvi", cmp=2});
	table.insert(SkillsData.spells, {name="Tempering", conv="Jmorvi", cmp=2});
	table.insert(SkillsData.spells, {name="Anvil", conv="Jmorvi", cmp=3});
	table.insert(SkillsData.spells, {name="Charm", conv="Jmorvi", cmp=3});
	table.insert(SkillsData.spells, {name="Mend", conv="Jmorvi", cmp=3});
	table.insert(SkillsData.spells, {name="Repel", conv="Jmorvi", cmp=3});
	table.insert(SkillsData.spells, {name="Singing Sword", conv="Jmorvi", cmp=3});
	table.insert(SkillsData.spells, {name="Fist", conv="Jmorvi", cmp=4});
	table.insert(SkillsData.spells, {name="Forge", conv="Jmorvi", cmp=4});
	table.insert(SkillsData.spells, {name="Mephitis", conv="Jmorvi", cmp=4});
	table.insert(SkillsData.spells, {name="Steel", conv="Jmorvi", cmp=4});
	table.insert(SkillsData.spells, {name="Swordbreaker", conv="Jmorvi", cmp=4});
	table.insert(SkillsData.spells, {name="Armour", conv="Jmorvi", cmp=5});
	table.insert(SkillsData.spells, {name="Hand", conv="Jmorvi", cmp=5});
	table.insert(SkillsData.spells, {name="Mould", conv="Jmorvi", cmp=5});
	table.insert(SkillsData.spells, {name="Restoration", conv="Jmorvi", cmp=5});
	table.insert(SkillsData.spells, {name="Shroud", conv="Jmorvi", cmp=5});
	table.insert(SkillsData.spells, {name="Assemble", conv="Jmorvi", cmp=6});
	table.insert(SkillsData.spells, {name="Lance", conv="Jmorvi", cmp=6});
	table.insert(SkillsData.spells, {name="Screen", conv="Jmorvi", cmp=6});
	table.insert(SkillsData.spells, {name="Shatter", conv="Jmorvi", cmp=6});

	-- PELEAHN Convocation
	table.insert(SkillsData.spells, {name="Caress", conv="Peleahn", cmp=1});
	table.insert(SkillsData.spells, {name="Desiccation", conv="Peleahn", cmp=1});
	table.insert(SkillsData.spells, {name="Flame", conv="Peleahn", cmp=1});
	table.insert(SkillsData.spells, {name="Heat", conv="Peleahn", cmp=1});
	table.insert(SkillsData.spells, {name="Sphere", conv="Peleahn", cmp=1});
	table.insert(SkillsData.spells, {name="Cloak", conv="Peleahn", cmp=2});
	table.insert(SkillsData.spells, {name="Fireworks", conv="Peleahn", cmp=2});
	table.insert(SkillsData.spells, {name="Hastening", conv="Peleahn", cmp=2});
	table.insert(SkillsData.spells, {name="Skin", conv="Peleahn", cmp=2});
	table.insert(SkillsData.spells, {name="Thirst", conv="Peleahn", cmp=2});
	table.insert(SkillsData.spells, {name="Brand", conv="Peleahn", cmp=3});
	table.insert(SkillsData.spells, {name="Eyes", conv="Peleahn", cmp=3});
	table.insert(SkillsData.spells, {name="Pyre", conv="Peleahn", cmp=3});
	table.insert(SkillsData.spells, {name="Shooting Star", conv="Peleahn", cmp=3});
	table.insert(SkillsData.spells, {name="Conflagration", conv="Peleahn", cmp=4});
	table.insert(SkillsData.spells, {name="Envelope", conv="Peleahn", cmp=4});
	table.insert(SkillsData.spells, {name="Fever", conv="Peleahn", cmp=4});
	table.insert(SkillsData.spells, {name="Wall", conv="Peleahn", cmp=4});
	table.insert(SkillsData.spells, {name="Doom Curtain", conv="Peleahn", cmp=5});
	table.insert(SkillsData.spells, {name="Gauntlet", conv="Peleahn", cmp=5});
	table.insert(SkillsData.spells, {name="Immolation", conv="Peleahn", cmp=5});
	table.insert(SkillsData.spells, {name="Meteor", conv="Peleahn", cmp=5});
	table.insert(SkillsData.spells, {name="Seeker", conv="Peleahn", cmp=5});
	table.insert(SkillsData.spells, {name="Burn", conv="Peleahn", cmp=6});
	table.insert(SkillsData.spells, {name="Convoke", conv="Peleahn", cmp=6});
	table.insert(SkillsData.spells, {name="Doom Flame", conv="Peleahn", cmp=6});
	table.insert(SkillsData.spells, {name="Fire Fiend", conv="Peleahn", cmp=6});
	table.insert(SkillsData.spells, {name="Mantle", conv="Peleahn", cmp=6});

	-- LYAHVI Convocation
	table.insert(SkillsData.spells, {name="Beacon", conv="Lyahvi", cmp=1});
	table.insert(SkillsData.spells, {name="Muffle", conv="Lyahvi", cmp=1});
	table.insert(SkillsData.spells, {name="Palm", conv="Lyahvi", cmp=1});
	table.insert(SkillsData.spells, {name="Stench", conv="Lyahvi", cmp=1});
	table.insert(SkillsData.spells, {name="Whisper", conv="Lyahvi", cmp=1});
	table.insert(SkillsData.spells, {name="Flash", conv="Lyahvi", cmp=2});
	table.insert(SkillsData.spells, {name="Lens", conv="Lyahvi", cmp=2});
	table.insert(SkillsData.spells, {name="Pocket", conv="Lyahvi", cmp=2});
	table.insert(SkillsData.spells, {name="Sound", conv="Lyahvi", cmp=2});
	table.insert(SkillsData.spells, {name="Voice", conv="Lyahvi", cmp=2});
	table.insert(SkillsData.spells, {name="Caecity", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="Globe", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="Image", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="Prism", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="Unveiling", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="View", conv="Lyahvi", cmp=3});
	table.insert(SkillsData.spells, {name="Beam", conv="Lyahvi", cmp=4});
	table.insert(SkillsData.spells, {name="Curtain", conv="Lyahvi", cmp=4});
	table.insert(SkillsData.spells, {name="Mirror", conv="Lyahvi", cmp=4});
	table.insert(SkillsData.spells, {name="Nightmare", conv="Lyahvi", cmp=4});
	table.insert(SkillsData.spells, {name="Glamour", conv="Lyahvi", cmp=5});
	table.insert(SkillsData.spells, {name="Motes", conv="Lyahvi", cmp=5});
	table.insert(SkillsData.spells, {name="Passage", conv="Lyahvi", cmp=5});
	table.insert(SkillsData.spells, {name="Tube", conv="Lyahvi", cmp=5});
	table.insert(SkillsData.spells, {name="Call", conv="Lyahvi", cmp=6});
	table.insert(SkillsData.spells, {name="Figure", conv="Lyahvi", cmp=6});
	table.insert(SkillsData.spells, {name="Vapour", conv="Lyahvi", cmp=6});
	table.insert(SkillsData.spells, {name="Wind", conv="Lyahvi", cmp=6});

	-- SAVORYA Convocation
	table.insert(SkillsData.spells, {name="Candour", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Diversion", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Enquiry", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Harmony", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Sensation", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Solace", conv="Savorya", cmp=1});
	table.insert(SkillsData.spells, {name="Enrichment", conv="Savorya", cmp=2});
	table.insert(SkillsData.spells, {name="Feel", conv="Savorya", cmp=2});
	table.insert(SkillsData.spells, {name="Fervour", conv="Savorya", cmp=2});
	table.insert(SkillsData.spells, {name="Insight", conv="Savorya", cmp=2});
	table.insert(SkillsData.spells, {name="Thought", conv="Savorya", cmp=2});
	table.insert(SkillsData.spells, {name="Missive", conv="Savorya", cmp=3});
	table.insert(SkillsData.spells, {name="Panic", conv="Savorya", cmp=3});
	table.insert(SkillsData.spells, {name="Quill", conv="Savorya", cmp=3});
	table.insert(SkillsData.spells, {name="Wisdom", conv="Savorya", cmp=3});
	table.insert(SkillsData.spells, {name="Key", conv="Savorya", cmp=4});
	table.insert(SkillsData.spells, {name="Link", conv="Savorya", cmp=4});
	table.insert(SkillsData.spells, {name="Obedience", conv="Savorya", cmp=4});
	table.insert(SkillsData.spells, {name="Probity", conv="Savorya", cmp=4});
	table.insert(SkillsData.spells, {name="Recollection", conv="Savorya", cmp=4});
	table.insert(SkillsData.spells, {name="Aural Blast", conv="Savorya", cmp=5});
	table.insert(SkillsData.spells, {name="Confusion", conv="Savorya", cmp=5});
	table.insert(SkillsData.spells, {name="Enervation", conv="Savorya", cmp=5});
	table.insert(SkillsData.spells, {name="Perspective", conv="Savorya", cmp=5});
	table.insert(SkillsData.spells, {name="Host", conv="Savorya", cmp=6});
	table.insert(SkillsData.spells, {name="Rupture", conv="Savorya", cmp=6});
	table.insert(SkillsData.spells, {name="Suggestion", conv="Savorya", cmp=6});
	table.insert(SkillsData.spells, {name="Veil", conv="Savorya", cmp=6});

	-- ODIVSHE Convocation
	table.insert(SkillsData.spells, {name="Cooling", conv="Odivshe", cmp=1});
	table.insert(SkillsData.spells, {name="Flotation", conv="Odivshe", cmp=1});
	table.insert(SkillsData.spells, {name="Quenching", conv="Odivshe", cmp=1});
	table.insert(SkillsData.spells, {name="Spoon", conv="Odivshe", cmp=1});
	table.insert(SkillsData.spells, {name="Alchema", conv="Odivshe", cmp=2});
	table.insert(SkillsData.spells, {name="Dowsing", conv="Odivshe", cmp=2});
	table.insert(SkillsData.spells, {name="Hush", conv="Odivshe", cmp=2});
	table.insert(SkillsData.spells, {name="Shadow", conv="Odivshe", cmp=2});
	table.insert(SkillsData.spells, {name="Sponge", conv="Odivshe", cmp=2});
	table.insert(SkillsData.spells, {name="Breath", conv="Odivshe", cmp=3});
	table.insert(SkillsData.spells, {name="Crystals", conv="Odivshe", cmp=3});
	table.insert(SkillsData.spells, {name="Freeze", conv="Odivshe", cmp=3});
	table.insert(SkillsData.spells, {name="Gills", conv="Odivshe", cmp=3});
	table.insert(SkillsData.spells, {name="Condensation", conv="Odivshe", cmp=4});
	table.insert(SkillsData.spells, {name="Pall", conv="Odivshe", cmp=4});
	table.insert(SkillsData.spells, {name="Sweat", conv="Odivshe", cmp=4});
	table.insert(SkillsData.spells, {name="Tide", conv="Odivshe", cmp=4});
	table.insert(SkillsData.spells, {name="Calm", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="Gloomweb", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="Icewalk", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="Restoration", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="River", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="Wave", conv="Odivshe", cmp=5});
	table.insert(SkillsData.spells, {name="Conjure", conv="Odivshe", cmp=6});
	table.insert(SkillsData.spells, {name="Enigma", conv="Odivshe", cmp=6});
	table.insert(SkillsData.spells, {name="Floe", conv="Odivshe", cmp=6});
	table.insert(SkillsData.spells, {name="Snowball", conv="Odivshe", cmp=6});
	table.insert(SkillsData.spells, {name="Waterwalk", conv="Odivshe", cmp=6});

	-- NEUTRAL Spells
	table.insert(SkillsData.spells, {name="Absorb", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Aegis", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Attune", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Detect", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Reveal", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Survey", conv="Neutral", cmp=1});
	table.insert(SkillsData.spells, {name="Alarm", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Bane", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Charge", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Dispel", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Distort", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Imbue", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Monitor", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Tap", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Ward", conv="Neutral", cmp=2});
	table.insert(SkillsData.spells, {name="Counter", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="False Soul", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="Focus", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="Fount", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="Pool", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="Trigger", conv="Neutral", cmp=3});
	table.insert(SkillsData.spells, {name="Chain", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Converse", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Resolve", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Resurge", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Sanctum", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Subvert", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Vessel", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Well", conv="Neutral", cmp=4});
	table.insert(SkillsData.spells, {name="Gate", conv="Neutral", cmp=5});
	table.insert(SkillsData.spells, {name="Investment", conv="Neutral", cmp=5});
	table.insert(SkillsData.spells, {name="Mask", conv="Neutral", cmp=5});
	table.insert(SkillsData.spells, {name="Reverse", conv="Neutral", cmp=5});
	table.insert(SkillsData.spells, {name="Bubble", conv="Neutral", cmp=6});
	table.insert(SkillsData.spells, {name="Personality", conv="Neutral", cmp=6});
	table.insert(SkillsData.spells, {name="Vortex", conv="Neutral", cmp=6});

	-- Build lookup table by spell name for quick access
	SkillsData.spellsByName = {};
	for _, spell in ipairs(SkillsData.spells) do
		SkillsData.spellsByName[spell.name] = spell;
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

	-- Store spells data in the database for cross-script access
	-- First, delete any existing data to prevent duplicates on reload
	local nodeExistingSpells = DB.findNode("harnmaster.spells");
	if nodeExistingSpells then
		nodeExistingSpells.delete();
		Debug.console("Cleared existing harnmaster.spells node");
	end

	-- Now create fresh spell reference data
	local nodeSpellsRef = DB.createNode("harnmaster.spells");
	for _, spell in ipairs(SkillsData.spells) do
		local nodeSpell = DB.createChild(nodeSpellsRef);
		DB.setValue(nodeSpell, "name", "string", spell.name);
		DB.setValue(nodeSpell, "conv", "string", spell.conv);
		DB.setValue(nodeSpell, "cmp", "number", spell.cmp);
	end

	Debug.console("SkillsData initialized with " .. #SkillsData.spells .. " spells");
	Debug.console("SkillsData stored in database at harnmaster.spells");
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

-- Get spell data by name
function SkillsData.getSpell(sName)
	if not SkillsData.spellsByName then return nil; end
	return SkillsData.spellsByName[sName];
end

-- Get all spells for a specific convocation
function SkillsData.getSpellsByConvocation(sConv)
	local aSpells = {};
	if not SkillsData.spells then return aSpells; end
	for _, spell in ipairs(SkillsData.spells) do
		if spell.conv == sConv then
			table.insert(aSpells, spell);
		end
	end
	return aSpells;
end

-- Get all spells
function SkillsData.getAllSpells()
	if not SkillsData.spells then return {}; end
	return SkillsData.spells;
end
