
-- Check Behavior of GetString
local lang = {
	
	-- parameters are itemDescription, qualityRangeText, isSetText, actionText
	-- e.g. "put in trash any stolen worthless light armor with quality Trash to Normal"
	IM_RULETXTFORMAT			= "<<z:4>> any <<z:1>><<z:2>><<z:3>>",
	IM_RULETXT_ISSET			= "which is part of a set",
	IM_RULETXT_STOLEN			= "stolen",
	IM_RULETXT_WORTHLESS		= "worthless",
	IM_RULETXT_JUNKED			= "junked",
	IM_RULETXT_CRAFTED			= "crafted",
	IM_RULETXT_QUALITY1			= "with quality <<1>>",
	IM_RULETXT_QUALITY2			= "with quality from <<1>> to <<2>>",
	IM_RULETXT_EXECOUNT 		= "(max. <<1>> times)",

	IM_ACTIONTXT0				= "Keep",
	IM_ACTIONTXT1				= "Put to junk",
	IM_ACTIONTXT2				= "Destroy",
	IM_ACTIONTXT3				= "Sell",
	IM_ACTIONTXT4				= "Launder",
	IM_ACTIONTXT5				= "Deconstruct",
	IM_ACTIONTXT6				= "Lock",
	IM_ACTIONTXT7				= "Unlock",
	IM_ACTIONTXT10				= "Put in bank",
	IM_ACTIONTXT20				= "Pull from bank",
	
	IM_TAKENACTION0				= "Would <<z:1>>: |t16:16:<<2>>|t <<3>> because of Rule <<4>>: <<5>>.",
	IM_TAKENACTION1				= "<<1>>: |t16:16:<<2>>|t <<3>>",
	IM_TAKENACTION2				= "Would |cff4444NOT|r <<z:1>>: |t16:16:<<2>>|t <<3>> because of Rule <<4>>: <<5>>, but it's locked by FCOIS",

	IM_FILTER_RULE_ANY			= "Any",
	IM_FILTER_ANY0				= "Item",
	IM_FILTERSPEC_ANY0			= "<<1>>",
	IM_FILTER_WEAPON0			= "Weapon",
	IM_FILTERSPEC_1H0			= "One-Handed weapon",
	IM_FILTERSPEC_2H0			= "Two-Handed weapon",
	IM_FILTERSPEC_BOW0			= "Bow",
	IM_FILTERSPEC_STAFF_DEST0 	= "Destruction staff",
	IM_FILTERSPEC_STAFF_HEAL0 	= "Healing staff",
	IM_FILTER_APPAREL0			= "Apparel",
	IM_FILTERSPEC_ANY_BODY0		= "Protective vestment",
	IM_FILTERSPEC_HEAVY0		= "Heavy Armor",
	IM_FILTERSPEC_MEDIUM0		= "Medium Armor",
	IM_FILTERSPEC_LIGHT0		= "Light Armor",
	IM_FILTERSPEC_SHIELD0		= "Shield",
	IM_FILTERSPEC_JEWELRY0		= "Jewelry",
	IM_FILTERSPEC_VANITY0		= "Vanity clothing",
	IM_FILTER_CONSUMABLE0		= "Consumable",
	IM_FILTERSPEC_CROWN_ITEM0 	= "Crown Item",
	IM_FILTERSPEC_FOOD0			= "Food",
	IM_FILTERSPEC_DRINK0		= "Drink",
	IM_FILTERSPEC_RECIPE0		= "Recipe",
	IM_FILTERSPEC_POTION0		= "Potion",
	IM_FILTERSPEC_POISON0		= "Poison",
	IM_FILTERSPEC_MOTIF0		= "Style motif",
	IM_FILTERSPEC_MASTER_WRIT0 	= "Master writ",
	IM_FILTERSPEC_CONTAINER0	= "Container",
	IM_FILTERSPEC_REPAIR0		= "Repair item",
	IM_FILTERSPEC_FISH0			= "Fish",
	IM_FILTERSPEC_TROPHY0		= "Trophy",
	IM_FILTER_MATERIAL0			= "Material",
	IM_FILTERSPEC_BLACKSMITHING0	= "Blacksmithing material",
	IM_FILTERSPEC_CLOTHIER0		= "Clothier material",
	IM_FILTERSPEC_WOODWORKING0 	= "Woodworking material",
	IM_FILTERSPEC_ALCHEMY0		= "Alchemy material",
	IM_FILTERSPEC_ENCHANTING0 	= "Enchanting material",
	IM_FILTERSPEC_PROVISIONING0 = "Provisioning ingredient",
	IM_FILTERSPEC_STYLE_MATERIAL0 = "Style material",
	IM_FILTERSPEC_ARMOR_TRAIT0 	= "Armor trait",
	IM_FILTERSPEC_WEAPON_TRAIT0 = "Weapon trait",
	IM_FILTER_FURNISHING0		= "Furnishing",
	IM_FILTER_MISC0				= "Miscellaneous",
	IM_FILTERSPEC_GLYPH0		= "Glyph",
	IM_FILTERSPEC_SOUL_GEM0 	= "Soul gem",
	IM_FILTERSPEC_SIEGE0		= "Siege equipment",
	IM_FILTERSPEC_BAIT0			= "Bait",
	IM_FILTERSPEC_TOOL0			= "Tool",
	IM_FILTERSPEC_TRASH0		= "Trash",
	IM_FILTERSPEC_TREASURE0		= "Treasure",
	
	IM_META_TRAIT_TYPE_FORMAT0	= "<<1>> with any trait <<2>>",
	IM_META_TRAIT_TYPE_FORMAT1	= "<<1>> which is <<2>>",
	IM_META_TRAIT_TYPE_FORMAT2	= "<<1>> with no trait",
	IM_META_TRAIT_TYPE0			= "(irrelevant)",
	IM_META_TRAIT_TYPE1			= "any trait",
	IM_META_TRAIT_TYPE2			= "unknown to others",
	IM_META_TRAIT_TYPE3			= "unknown",
	IM_META_TRAIT_TYPE4			= "no trait",
	
	IM_RE_CURRENTRULES			= "Current Rules",
	IM_RE_DELETERULE			= "Delete Rule",
	IM_RE_MOVERULEUP			= "Move rule up",
	IM_RE_ADDRULEBEFORE			= "Add rule before this one",
	IM_RE_MOVERULEDN			= "Move rule down",
	IM_RE_ADDRULEAFTER			= "Add rule after this one",
	IM_RE_REPLACERULE			= "Replace Rule",
	IM_RE_DESC					= "Modify the contents of these fields to specify the rule to add.",
	IM_RE_ACTION				= "Action",
	IM_RE_GENTYPE				= "General type",
	IM_RE_SPECTYPE				= "Specific type",
	IM_RE_TRAIT					= "Trait",
	IM_RE_PARTOFSET				= "Part of a set",
	IM_RE_MINQUAL				= "Minimum Quality",
	IM_RE_MAXQUAL				= "Maximum Quality",
	IM_RE_STOLEN				= "stolen",
	IM_RE_WORTHLESS				= "worthless",
	IM_RE_CRAFTED				= "crafted",
	IM_RE_EMPTY					= "(empty)",
	IM_RE_INJUNK 				= "In Junk",

	IM_PE_PROFILES				= "Profiles",
	IM_PE_LOADPROFILE			= "Load Profile",
	IM_PE_DELETEPROFILE			= "Delete Profile",
	IM_PE_EDITPRNAME			= "Edit Profile Name",
	IM_PE_SAVEPROFILE			= "Save Profile",
	
	IM_BANK_LIMITED				= "Incomplete transaction - avoiding anti-flood filtering",
	IM_BANK_DEADLOCK			= "Incomplete transaction - both inventories full",
	IM_BANK_PARTIAL				= "Incomplete transaction - one inventory full",
	IM_BANK_OK					= "All transactions sent",

	IM_UI_LISTRULES_HEAD		= "List of rules",
	IM_SET_MIN_GOLD				= "Minimum Gold",
	IM_SET_MIN_GOLD_TOOLTIP		= "Minimum amount of gold to keep on character",
	IM_SET_MAX_GOLD				= "Maximum Gold",
	IM_SET_MAX_GOLD_TOOLTIP		= "Maximum amount of gold to keep on character",
	IM_SET_MIN_TV				= "Minimum Tel Var stones",
	IM_SET_MIN_TV_TOOLTIP		= "Minimum amount of Tel Var stones to keep on character",
	IM_SET_MAX_TV				= "Maximum Tel Var stones",
	IM_SET_MAX_TV_TOOLTIP		= "Maximum amount of Tel Var stones to keep on character",
	IM_SET_BANK					= "Delay between bank moves",
	IM_SET_BANK_TOOLTIP			= "Time in milliseconds to wait between bank moves",
	IM_SET_DEST					= "Destroy Threshold",
	IM_SET_DEST_TOOLTIP			= "Destroy items when inventory space drops below this number of slots",
	IM_SET_LIST					= "List rules",
	IM_SET_LIST_TOOLTIP			= "List the current ruleset in the chat window",
	IM_SET_UNJUNK				= "UnJunk all",
	IM_SET_UNJUNK_TOOLTIP		= "Remove Junk markings on all of your items",
	IM_SET_DRYRUN				= "Dry run",
	IM_SET_DRYRUN_TOOLTIP		= "List the actions which would be performed on your inventory",
	IM_SET_RUN					= "Run over Inventory",
	IM_SET_RUN_TOOLTIP			= "Perform the junk/destroy options on your current inventory",
	
	IM_SET_AUTOSELL				= "Auto-Sell junked items",
	IM_SET_AUTOSELL_TOOLTIP		= "When set, junked items will be sold whenever visiting a merchant or a fence",
	IM_SET_START_BM 			= "Delay before starting bank moves",
	IM_SET_START_BM_TT 			= "Sets the delay before starting bank moves. It's advisable to set a higher delay if you use high-impact addons like Inventory Grid View.",
	IM_SET_INV 					= "Delay between inv changes",
	IM_SET_INV_TT 				= "Sets the delay between inventory status changes like junk/unjunk lock/unlock and so on.",
	IM_SET_EXECOUNT 			= "Maximum execution count",
	IM_SET_EXECOUNT_TT 			= "How often this rule may be executed in a single run. 0 means 'unlimited'",
	
	IM_PM_PROFILENAME_TOOLTIP	= "Enter the name of the new profile here",
	IM_RM_PRESETRULES			= "--- Preset profiles ---",
	IM_RM_CUSTOMRULES			= "--- Custom profiles ---",
	IM_LIST_NUM_RULES			= "Rules found: ",
	IM_LIST_RULE				= "Rule ",
	IM_UI_PM					= "Profile Management",
	IM_UI_PM_TOOLTIP			= "Select, add or delete profiles",
	IM_UI_RM					= "Rule Management",
	IM_UI_RM_TOOLTIP			= "Add, modify and delete rules",
	IM_UI_SETTINGS				= "Settings",
	IM_UI_SETTINGS_TOOLTIP		= "Adapt the general behavior",
	IM_CUR_SOLDJUNK				= "Sold items, Revenue is <<1>> gold coins.",
	IM_CUR_DEPOSIT				= "Depositing <<1>> <<2>>.",
	IM_CUR_WITHDRAW				= "Withdrawing <<1>> <<2>>.",
	IM_CUR_GOLD					= "gold coins",
	IM_CUR_TVSTONES				= "Tel Var stones",

	IM_FCOIS_CHOICE				= "FCO ItemSaver Marking",
	IM_FCOIS_UNMARKED			= "unmarked",
	IM_FCOIS_WITHANYMARK		= "with any mark",
	IM_FCOIS_MARKEDASX			= "marked as <<z:1>>",
	IM_FCOIS_NOCAREMARK			= "Don't care",
	IM_FCOIS_NOMARK				= "No mark",
	IM_FCOIS_ANYMARK			= "Any mark",

	IM_INIT_DETECTED_CS_OLD		= "IM: Old CraftStore 3.00+ detected. It's outdated, please update to 'CraftStore Fixed And Improved'",
	IM_INIT_DETECTED_CS_NEW		= "IM: CraftStore Fixed And Improved detected",
	IM_INIT_UPDATE_V2_NOTE 		= "Upgraded character data to version 2: Added sell rule up front to maintain backwards compatibility.",

	IM_FCO_STATIC_TXT1			= "for locking",
	IM_FCO_STATIC_TXT2			= "gear set 1",
	IM_FCO_STATIC_TXT3			= "for research",
	IM_FCO_STATIC_TXT4			= "gear set 2",
	IM_FCO_STATIC_TXT5			= "for sale",
	IM_FCO_STATIC_TXT6			= "gear set 3",
	IM_FCO_STATIC_TXT7			= "gear set 4",
	IM_FCO_STATIC_TXT8			= "gear set 5",
	IM_FCO_STATIC_TXT9			= "deconstruction",
	IM_FCO_STATIC_TXT10			= "for improvement",
	IM_FCO_STATIC_TXT11			= "for sale at guildstore",
	IM_FCO_STATIC_TXT12			= "intricate",
}

for stringId, stringValue in pairs(lang) do
   ZO_CreateStringId(stringId, stringValue)
   SafeAddVersion(stringId, 1)
end
