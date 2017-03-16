
local function generateFiltertypes()
	local _new = { }
	for _, f in pairs(InventoryManager.filterorder) do
		local _innernew = { }
		for _, ff in pairs(f[2]) do
			_innernew[ff[1]] = ff[2]
		end
		_new[f[1]] = _innernew
	end
	return _new
end

InventoryManager.IM_Ruleset = { }

local IM_Ruleset = InventoryManager.IM_Ruleset

function InventoryManager:getIQString(itemQuality)
	return GetItemQualityColor(itemQuality):Colorize(GetString("SI_ITEMQUALITY", itemQuality))
end
 
IM_Ruleset.ACTION_KEEP		=  0
IM_Ruleset.ACTION_JUNK		=  1
IM_Ruleset.ACTION_DESTROY 	=  2
IM_Ruleset.ACTION_STASH		= 10
IM_Ruleset.ACTION_RETRIEVE	= 20

IM_Ruleset.ITEM_TRAIT_TYPE_ANY				= -1
IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS		= -2
IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN		= -3

 
InventoryManager.filterorder = {
		{ "IM_FILTER_ANY" 			, {
			{ "IM_FILTERSPEC_ANY"			, { } },
		} },
		{ "IM_FILTER_WEAPON" 		, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_WEAPON } },
			{ "IM_FILTERSPEC_1H"			, { "weaponType", WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER } },
			{ "IM_FILTERSPEC_2H"			, { "weaponType", WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD } },
			{ "IM_FILTERSPEC_BOW"			, { "weaponType", WEAPONTYPE_BOW } },
			{ "IM_FILTERSPEC_STAFF_DEST"	, { "weaponType", WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF } },
			{ "IM_FILTERSPEC_STAFF_HEAL"	, { "weaponType", WEAPONTYPE_HEALING_STAFF } }
		} }, 
		{ "IM_FILTER_APPAREL"		, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_ARMOR } },
			{ "IM_FILTERSPEC_ANY_BODY"		, { "armorType", ARMORTYPE_HEAVY, ARMORTYPE_MEDIUM, ARMORTYPE_LIGHT } },
			{ "IM_FILTERSPEC_HEAVY" 		, { "armorType", ARMORTYPE_HEAVY } },
			{ "IM_FILTERSPEC_MEDIUM"		, { "armorType", ARMORTYPE_MEDIUM } },
			{ "IM_FILTERSPEC_LIGHT"			, { "armorType", ARMORTYPE_LIGHT } },
			{ "IM_FILTERSPEC_SHIELD"		, { "equipType", EQUIP_TYPE_OFF_HAND } },
			{ "IM_FILTERSPEC_JEWELRY"		, { "equipType", EQUIP_TYPE_RING, EQUIP_TYPE_NECK } },
			{ "IM_FILTERSPEC_VANITY"		, { "equipType", EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME  }}
		} },
		{ "IM_FILTER_CONSUMABLE"	, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_CROWN_ITEM, ITEMTYPE_FOOD, ITEMTYPE_DRINK, ITEMTYPE_RECIPE, ITEMTYPE_POTION, ITEMTYPE_POISON, ITEMTYPE_RACIAL_STYLE_MOTIF, ITEMTYPE_MASTER_WRIT, ITEMTYPE_CONTAINER, ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR, ITEMTYPE_FISH, ITEMTYPE_TROPHY } },
			{ "IM_FILTERSPEC_CROWN_ITEM"	, { "itemType", ITEMTYPE_CROWN_ITEM } },
			{ "IM_FILTERSPEC_FOOD"			, { "itemType", ITEMTYPE_FOOD } },
			{ "IM_FILTERSPEC_DRINK"			, { "itemType", ITEMTYPE_DRINK } },
			{ "IM_FILTERSPEC_RECIPE"		, { "itemType", ITEMTYPE_RECIPE } },
			{ "IM_FILTERSPEC_POTION"		, { "itemType", ITEMTYPE_POTION } },
			{ "IM_FILTERSPEC_POISON"		, { "itemType", ITEMTYPE_POISON } },
			{ "IM_FILTERSPEC_MOTIF"			, { "itemType", ITEMTYPE_RACIAL_STYLE_MOTIF } },
			{ "IM_FILTERSPEC_MASTER_WRIT"	, { "itemType", ITEMTYPE_MASTER_WRIT } },
			{ "IM_FILTERSPEC_CONTAINER"		, { "itemType", ITEMTYPE_CONTAINER } },
			{ "IM_FILTERSPEC_REPAIR"		, { "itemType", ITEMTYPE_AVA_REPAIR, ITEMTYPE_TOOL, ITEMTYPE_CROWN_REPAIR } },
			{ "IM_FILTERSPEC_FISH"			, { "itemType", ITEMTYPE_FISH } },
			{ "IM_FILTERSPEC_TROPHY"		, { "itemType", ITEMTYPE_TROPHY } },
		} },
		{ "IM_FILTER_MATERIAL"		, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER, ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER, ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER, ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE, ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY, ITEMTYPE_INGREDIENT, ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL, ITEMTYPE_WEAPON_TRAIT, ITEMTYPE_ARMOR_TRAIT } },
			{ "IM_FILTERSPEC_BLACKSMITHING"	, { "itemType", ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER } },
			{ "IM_FILTERSPEC_CLOTHIER"		, { "itemType", ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER } },
			{ "IM_FILTERSPEC_WOODWORKING"	, { "itemType", ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER } },
			{ "IM_FILTERSPEC_ALCHEMY"		, { "itemType", ITEMTYPE_REAGENT, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE } },
			{ "IM_FILTERSPEC_ENCHANTING"	, { "itemType", ITEMTYPE_ENCHANTING_RUNE_ASPECT, ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY } },
			{ "IM_FILTERSPEC_PROVISIONING"	, { "itemType", ITEMTYPE_INGREDIENT } },
			{ "IM_FILTERSPEC_STYLE_MATERIAL", { "itemType", ITEMTYPE_STYLE_MATERIAL, ITEMTYPE_RAW_MATERIAL } },
			{ "IM_FILTERSPEC_ARMOR_TRAIT"	, { "itemType", ITEMTYPE_WEAPON_TRAIT } },
			{ "IM_FILTERSPEC_WEAPON_TRAIT"	, { "itemType", ITEMTYPE_ARMOR_TRAIT } },
		} },
		{ "IM_FILTER_FURNISHING"	, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_FURNISHING } },
		} },
		{ "IM_FILTER_MISC"			, { 
			{ "IM_FILTERSPEC_ANY"			, { "itemType", ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON, ITEMTYPE_SOUL_GEM, ITEMTYPE_SIEGE, ITEMTYPE_LURE, ITEMTYPE_TOOL, ITEMTYPE_TRASH, ITEMTYPE_COLLECTIBLE, ITEMTYPE_TREASURE } },
			{ "IM_FILTERSPEC_GLYPH"			, { "itemType", ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON } },
			{ "IM_FILTERSPEC_SOUL_GEM"		, { "itemType", ITEMTYPE_SOUL_GEM } },
			{ "IM_FILTERSPEC_SIEGE"			, { "itemType", ITEMTYPE_SIEGE } },
			{ "IM_FILTERSPEC_BAIT"			, { "itemType", ITEMTYPE_LURE } },
			{ "IM_FILTERSPEC_TOOL"			, { "itemType", ITEMTYPE_TOOL } },
			{ "IM_FILTERSPEC_TRASH"			, { "itemType", ITEMTYPE_TRASH } },
			{ "IM_FILTERSPEC_TREASURE"		, { "itemType", ITEMTYPE_COLLECTIBLE, ITEMTYPE_TREASURE } },
		} },
}

InventoryManager.filtertypes = generateFiltertypes()

InventoryManager.qualityorder = {
	{ InventoryManager:getIQString(ITEM_QUALITY_TRASH), 		ITEM_QUALITY_TRASH },
	{ InventoryManager:getIQString(ITEM_QUALITY_NORMAL), 	ITEM_QUALITY_NORMAL },
	{ InventoryManager:getIQString(ITEM_QUALITY_MAGIC), 		ITEM_QUALITY_MAGIC },
	{ InventoryManager:getIQString(ITEM_QUALITY_ARCANE), 	ITEM_QUALITY_ARCANE },
	{ InventoryManager:getIQString(ITEM_QUALITY_ARTIFACT), 	ITEM_QUALITY_ARTIFACT },
	{ InventoryManager:getIQString(ITEM_QUALITY_LEGENDARY), 	ITEM_QUALITY_LEGENDARY }
}

InventoryManager.actionorder = {
	{ IM_Ruleset.ACTION_KEEP },
	{ IM_Ruleset.ACTION_JUNK },
	{ IM_Ruleset.ACTION_DESTROY },
	{ IM_Ruleset.ACTION_STASH },
	{ IM_Ruleset.ACTION_RETRIEVE },
}

InventoryManager.traitsorder = {
	["IM_FILTER_ANY"] = {
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANY, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
		ITEM_TRAIT_TYPE_WEAPON_INTRICATE,
		ITEM_TRAIT_TYPE_WEAPON_ORNATE,
	},
	["IM_FILTER_WEAPON"] = {
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANY, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
		ITEM_TRAIT_TYPE_WEAPON_CHARGED,
		ITEM_TRAIT_TYPE_WEAPON_DECISIVE,
		ITEM_TRAIT_TYPE_WEAPON_DEFENDING,
		ITEM_TRAIT_TYPE_WEAPON_INFUSED,
		ITEM_TRAIT_TYPE_WEAPON_POWERED,
		ITEM_TRAIT_TYPE_WEAPON_PRECISE,
		ITEM_TRAIT_TYPE_WEAPON_SHARPENED,
		ITEM_TRAIT_TYPE_WEAPON_TRAINING,
		ITEM_TRAIT_TYPE_WEAPON_NIRNHONED,
		ITEM_TRAIT_TYPE_WEAPON_INTRICATE,
		ITEM_TRAIT_TYPE_WEAPON_ORNATE,
 	},
	["IM_FILTER_APPAREL"] = { 
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANY, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
		ITEM_TRAIT_TYPE_ARMOR_DIVINES,
		ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE,
		ITEM_TRAIT_TYPE_ARMOR_INFUSED,
		ITEM_TRAIT_TYPE_ARMOR_PROSPEROUS,
		ITEM_TRAIT_TYPE_ARMOR_REINFORCED,
		ITEM_TRAIT_TYPE_ARMOR_STURDY,
		ITEM_TRAIT_TYPE_ARMOR_TRAINING,
		ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED,
		ITEM_TRAIT_TYPE_WEAPON_NIRNHONED,
		ITEM_TRAIT_TYPE_WEAPON_INTRICATE,
		ITEM_TRAIT_TYPE_WEAPON_ORNATE,
	},
	["IM_FILTERSPEC_JEWELRY"] = { 
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANY, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
		ITEM_TRAIT_TYPE_JEWELRY_ARCANE,
		ITEM_TRAIT_TYPE_JEWELRY_HEALTHY,
		ITEM_TRAIT_TYPE_JEWELRY_ROBUST,
		ITEM_TRAIT_TYPE_WEAPON_ORNATE,
 	},
	["IM_FILTERSPEC_RECIPE"] = {
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
	},
	["IM_FILTERSPEC_MOTIF"] = {
		0, -- Redefined to "don't care about traits"
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS, 
		IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN,
	},
}

InventoryManager.presetProfiles = {
	[1] = 
	{
		["rules"] = 
		{
			[1] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 10,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = -2,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[2] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 10,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = 9,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[3] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 1,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = 10,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[4] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 20,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = -3,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[5] = 
			{
				["minQuality"] = 0,
				["Filter"] = nil, -- invalid value type [function] used
				["action"] = 1,
				["New"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
				["maxQuality"] = 5,
				["filterSubType"] = "IM_FILTERSPEC_TRASH",
				["filterType"] = "IM_FILTER_MISC",
			},
		},
		["name"] = "Research Assistant",
	},
	[2] = 
	{
		["rules"] = 
		{
			[1] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 20,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = -3,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[2] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 10,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = -2,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[3] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 20,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = 9,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[4] = 
			{
				["minQuality"] = 0,
				["filterType"] = "IM_FILTER_ANY",
				["filterSubType"] = "IM_FILTERSPEC_ANY",
				["action"] = 1,
				["New"] = nil, -- invalid value type [function] used
				["traitType"] = 10,
				["maxQuality"] = 5,
				["Filter"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
			},
			[5] = 
			{
				["minQuality"] = 0,
				["Filter"] = nil, -- invalid value type [function] used
				["action"] = 1,
				["New"] = nil, -- invalid value type [function] used
				["ToString"] = nil, -- invalid value type [function] used
				["maxQuality"] = 5,
				["filterSubType"] = "IM_FILTERSPEC_TRASH",
				["filterType"] = "IM_FILTER_MISC",
			},
		},
		["name"] = "Researcher",
	},
}