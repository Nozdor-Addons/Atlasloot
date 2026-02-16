local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["Runes"] = {
		{ 2, "PriestRunes", "Spell_Holy_PowerWordShield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
    { 4, "HunterRunes", "Ability_Hunter_RunningShot", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
    { 6, "DKRunes", "Spell_Deathknight_DeathStrike", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], ""};
    { 8, "WarriorRunes", "Ability_Warrior_BattleShout", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
    { 10, "WarlockRunes", "Spell_Shadow_CurseOfTounges", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
    { 17, "RogueRunes", "Ability_BackStab", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
		{ 19, "DruidRunes", "Ability_Druid_Maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
    { 21, "ShamanRunes", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
		{ 23, "MageRunes", "Spell_Frost_IceStorm", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
		{ 25, "PaladinRunes", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
	};