local DEBUG = 
-- function() end
d

local function _tr(str)
	return str
end

local IM = InventoryManager

local _waitforpanel = nil

local at2tradeskill = {
	[ARMORTYPE_HEAVY]				= CRAFTING_TYPE_BLACKSMITHING,
	[ARMORTYPE_MEDIUM]				= CRAFTING_TYPE_CLOTHIER,
	[ARMORTYPE_LIGHT]				= CRAFTING_TYPE_CLOTHIER,
}

local wt2tradeskill = {
    [WEAPONTYPE_AXE]				= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_BOW]				= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_DAGGER]				= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_FIRE_STAFF]			= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_FROST_STAFF]		= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_HAMMER]				= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_HEALING_STAFF]		= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_LIGHTNING_STAFF]	= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_SHIELD]				= CRAFTING_TYPE_WOODWORKING,
    [WEAPONTYPE_SWORD]				= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_TWO_HANDED_AXE]		= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_TWO_HANDED_HAMMER]	= CRAFTING_TYPE_BLACKSMITHING,
    [WEAPONTYPE_TWO_HANDED_SWORD]	= CRAFTING_TYPE_BLACKSMITHING,
}

local it2tradeskill = {
	[ITEMTYPE_GLYPH_ARMOR] 			= CRAFTING_TYPE_ENCHANTING,
	[ITEMTYPE_GLYPH_WEAPON]			= CRAFTING_TYPE_ENCHANTING,
	[ITEMTYPE_GLYPH_JEWELRY]		= CRAFTING_TYPE_ENCHANTING,
	[ITEMTYPE_ARMOR]				= { "armorType", at2tradeskill },
	[ITEMTYPE_WEAPON]				= { "weaponType", wt2tradeskill },
}

local dt2tradeskill = { "itemType", it2tradeskill }

-- Recurse through the decision tree to get the correct tradeskill for the item
local function GetItemTradeSkill(data, _used_table)
	if not _used_table then _used_table = dt2tradeskill end
	
	local _key = _used_table[1]
	local _tab = _used_table[2]
	
	local entry = _tab[data[_key]]

	if not entry then return nil end

	if type(entry) ~= "table" then return entry end
	
	return GetItemTradeSkill(data, entry)
end

local function GetTradeskillUsed()
	if not ZO_EnchantingTopLevelExtractionSlotContainer:IsHidden() then
		return CRAFTING_TYPE_ENCHANTING
	elseif not ZO_SmithingTopLevelDeconstructionPanelSlotContainer:IsHidden() then
		return CRAFTING_TYPE_BLACKSMITHING
	end
	
	return nil
end

local function filter_for_deconstruction(tradeskill, data)
		local ts = GetItemTradeSkill(data)
		
		if ts ~= tradeskill then return false end
		
		if not CanItemBeSmithingExtractedOrRefined(data.bagId, data.slotId, ts) then return false end
		
		if IM.FCOISL:IsProtectedAction(data.action, data.bagId, data.slotId, ts == CRAFTING_TYPE_ENCHANTING) then return false end
		
		return true
end

local function extract_single_item(tradeskill, data)
	if tradeskill == CRAFTING_TYPE_ENCHANTING then
		ExtractEnchantingItem(data.bagId, data.slotId)
	else
		ExtractOrRefineSmithingItem(data.bagId, data.slotId)
	end
	IM:ReportAction(data, false, data.action, data.index, data.text)
end

local function InitDeconstruction(tradeskill)
	InventoryManager.currentRuleset:ResetCounters()

	local list = IM:CreateInventoryList(BAG_BACKPACK, IM.ACTION_DECONSTRUCT,
		function(data) return filter_for_deconstruction(tradeskill, data) end)
	
	list = IM:CreateInventoryList(BAG_BANK, IM.ACTION_DECONSTRUCT,
		function(data) return filter_for_deconstruction(tradeskill, data) end,
		list)

	list = IM:CreateInventoryList(BAG_SUBSCRIBER_BANK, IM.ACTION_DECONSTRUCT,
		function(data) return filter_for_deconstruction(tradeskill, data) end,
		list)

	IM:DoEventProcessing(list,
		function(data) return extract_single_item(tradeskill, data) end,
		function() end,
		EVENT_CRAFT_COMPLETED,
		EVENT_END_CRAFTING_STATION_INTERACT,
		InventoryManager.settings.bankMoveDelay)
end

local function WaitPanel()
	if GetTradeskillUsed() then
		InitDeconstruction(_waitforpanel)
		_waitforpanel = nil
	end
	
	if not _waitforpanel then return end
	
	zo_callLater(WaitPanel, 500)
end

local function OnOpenCraftingStation(eventCode, craftSkill, sameStation)
	_waitforpanel = craftSkill
	zo_callLater(WaitPanel, 500)
end

local function OnCloseCraftingStation(eventCode, craftSkill)
	_waitforpanel = nil
end

EVENT_MANAGER:RegisterForEvent(IM.name, EVENT_CRAFTING_STATION_INTERACT, OnOpenCraftingStation)
EVENT_MANAGER:RegisterForEvent(IM.name, EVENT_END_CRAFTING_STATION_INTERACT, OnCloseCraftingStation)
