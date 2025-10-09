local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["ISLANDMENU"] = {
		{ 2, "TIslandWeapon", "timelesscoin_yellow", "=q4="..BabbleInventory["Weapon"], "Хроми"};
		{ 3, "TIslandRing", "timelesscoin_yellow", "=q4="..BabbleInventory["Ring"], "Хроми"};
		{ 4, "TIslandBelt", "timelesscoin_yellow", "=q4="..BabbleInventory["Waist"], "Хроми"};
		{ 17, "TIslandHood", "timelesscoin_yellow", "=q4="..BabbleInventory["Back"], "Шаохао"};
		{ 18, "TIslandTrinket", "timelesscoin_yellow", "=q4="..BabbleInventory["Trinket"], "Шаохао"};
		{ 20, "TIslandOther", "timelesscoin_yellow", "=q4="..BabbleInventory["Other"], "Шаохао/Хроми"};
	};