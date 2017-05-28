local DEBUG = 
function() end
-- d

local function _tr(str)
	return str
end


local IM_Rule = {}
local IM_Ruleset = InventoryManager.IM_Ruleset

IM_Rule.action		= InventoryManager.ACTION_KEEP
IM_Rule.minQuality 	= ITEM_QUALITY_TRASH
IM_Rule.maxQuality 	= ITEM_QUALITY_LEGENDARY

IM_Rule.filterType 		= "IM_FILTER_ANY"
IM_Rule.filterSubType 	= "IM_FILTERSPEC_ANY"

function IM_Rule:New()
	local _new = { }
	
	for k,v in pairs(self) do
		_new[k] = v
	end

	return _new
end

function IM_Rule:ToString()
	local stolenText = ""
	local traitText = ""
	local worthlessText = ""
	local qualityRangeText = ""
	local isSetText = ""
	local actionText = GetString("IM_ACTIONTXT", self.action)

	local itemDescription = zo_strformat(
		GetString(self.filterSubType),
			" " .. GetString(self.filterType))
	
	
	if self.maxCount then
		actionText = actionText .. " " .. zo_strformat(GetString(IM_RULETXT_EXECOUNT), self.maxCount)
	end
	
	if self.traitType then
		local which = (self.filterType == "IM_FILTER_CONSUMABLE" and 1) or 0
		if self.traitType < 0 then
			if self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_NOTRAIT then which = 2 end
			local str = (self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_ANY and "") or GetString("IM_META_TRAIT_TYPE", -self.traitType)
			itemDescription = zo_strformat(
				GetString("IM_META_TRAIT_TYPE_FORMAT", which), 
				itemDescription,
				str)
		else
			itemDescription = GetString("SI_ITEMTRAITTYPE", self.traitType) .. " " .. itemDescription
		end
	end

	if self.crafted then
		itemDescription = GetString(IM_RULETXT_CRAFTED) .. " " .. itemDescription
	end
	
	if self.worthless then
		itemDescription = GetString(IM_RULETXT_WORTHLESS) .. " " .. itemDescription
	end

	if self.junk then
		itemDescription = GetString(IM_RULETXT_JUNKED) .. " " .. itemDescription
	end
	
	if InventoryManager.FCOISL:hasAddon() and self.FCOISMark then
		if InventoryManager.FCOISL:IsNoMark(self.FCOISMark) then
			itemDescription = GetString(IM_FCOIS_UNMARKED) .. " " .. itemDescription
		elseif InventoryManager.FCOISL:IsAnyMark(self.FCOISMark) then
			itemDescription = itemDescription .. " " .. GetString(IM_FCOIS_WITHANYMARK)
		else
			itemDescription = itemDescription .. " " .. zo_strformat(
				GetString(IM_FCOIS_MARKEDASX),
				InventoryManager.FCOISL:GetIndexedMark(self.FCOISMark))
		end
	end

	if self.stolen then
		itemDescription = GetString(IM_RULETXT_STOLEN) .. " " .. itemDescription
	end

	if self.isSet then
		isSetText = " " .. GetString(IM_RULETXT_ISSET)
	end
	
	colorMin = GetItemQualityColor(self.minQuality)
	colorMax = GetItemQualityColor(self.maxQuality)
	
	if self.minQuality == self.maxQuality then
		qualityRangeText = " " .. zo_strformat(GetString("IM_RULETXT_QUALITY", 1),
			InventoryManager:getIQString(self.minQuality))
	elseif self.minQuality ~= ITEM_QUALITY_TRASH or self.maxQuality ~= ITEM_QUALITY_LEGENDARY then
		qualityRangeText = " " .. zo_strformat(GetString("IM_RULETXT_QUALITY", 2), 
			InventoryManager:getIQString(self.minQuality),
			InventoryManager:getIQString(self.maxQuality))
	end

	return zo_strformat(GetString(IM_RULETXTFORMAT),
		itemDescription,
		qualityRangeText,
		isSetText,
		actionText)
end

function IM_Rule:Filter(data)

	local filterList = InventoryManager.filtertypes[self.filterType][self.filterSubType]
	
	if #filterList > 0 then
		local attrName = filterList[1]
		
		local found = false
		for i = 2, #filterList, 1 do
			if data[attrName] == filterList[i] then
				found = true
				break
			end
		end
		
		if not found then return false end
	end

	-- For sake of simplicity, translate 'intricate' and 'ornate' to a single value
	local traitType = data.traitType

	if traitType == ITEM_TRAIT_TYPE_ARMOR_NIRNHONED then
		traitType = ITEM_TRAIT_TYPE_WEAPON_NIRNHONED
	end

	if traitType == ITEM_TRAIT_TYPE_ARMOR_INTRICATE then
		traitType = ITEM_TRAIT_TYPE_WEAPON_INTRICATE
	end

	if traitType == ITEM_TRAIT_TYPE_ARMOR_ORNATE then
		traitType = ITEM_TRAIT_TYPE_WEAPON_ORNATE
	end

	if traitType == ITEM_TRAIT_TYPE_JEWELRY_ORNATE then
		traitType = ITEM_TRAIT_TYPE_WEAPON_ORNATE
	end

	-- Ornate, Intricate, ect.
	if self.traitType then
		if self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_ANY then
			if traitType == ITEM_TRAIT_TYPE_NONE then return false end
		elseif self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_NOTRAIT then
			if traitType ~= ITEM_TRAIT_TYPE_NONE then return false end
		elseif self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKOTHERS then
			if not data.unknownothers then return false end
		elseif self.traitType == IM_Ruleset.ITEM_TRAIT_TYPE_ANYUNKNOWN then
			if not data.unknownself then return false end
		elseif self.traitType ~= traitType then
			return false
		end
	end
	
	-- FCO ItemSaver marker?
    -- Call with parameters suitable for both API's and let FCOISL sort it out.
    if not InventoryManager.FCOISL:FitMark(data.itemInstanceId, self.FCOISMark, data.bagId, data.slotId) then return false end

	-- Junked?
	if self.junk and not data.junk then return false end
	
	-- Part of a set?
	if self.isSet and not data.isSet then return false end
	
	-- stolen only?
	if self.stolen and not data.stolen then return false end
	
	-- worthless?
	if self.worthless and data.value ~= 0 then return false end
	
	-- crafted?
	if self.crafted and not data.crafted then return false end
	
	-- outside wanted quality range?
	if data.quality < self.minQuality or data.quality > self.maxQuality  then return false end
	
	return true
end

function IM_Ruleset:New()
	local _new = { }
	
	for k,v in pairs(self) do
		_new[k] = v
	end

	_new["rules"] = { }
	if self.rules then
		for k,v in pairs(self.rules) do
			_new["rules"][k] = v:New()
		end
	end
	
	return _new
end

local ExecCounters = nil

function IM_Ruleset:ResetCounters()
	ExecCounters = nil
end

function IM_Ruleset:Match(data)
	if not ExecCounters then ExecCounters = { } end
	
	for k, v in pairs(self.rules) do
		local res = v:Filter(data)
		
		-- Safeguards
		-- If it's locked, don't touch.
		-- If it's stolen, we can't put it in the bank.
		if res then
			if data.locked then res = false
			elseif data.stolen and v.action == InventoryManager.ACTION_STASH then res = false
			end
		end
		
		-- If we reached the max execution count for that particular rule, skip it.
		if res and v.maxCount and ExecCounters[k] and ExecCounters[k] >= v.maxCount then
			res = false
		end
		
		if res then
			ExecCounters[k] = (ExecCounters[k] or 0) + 1
			return v.action, k, v:ToString()
		end
	end
	
	return InventoryManager.ACTION_KEEP, nil, nil
end

function IM_Ruleset:NewRule()
	return IM_Rule:New()
end

InventoryManager.IM_Ruleset = IM_Ruleset

-- DEBUG CODE
-- Ruleset = IM_Ruleset:New()

-- local Rule1 = IM_Ruleset:NewRule()
-- Rule1.filterType = "IM_FILTER_MISC"
-- Rule1.filterSubType = "IM_FILTERSPEC_TRASH"
-- Rule1.action = InventoryManager.ACTION_JUNK

-- local Rule2 = IM_Ruleset:NewRule()
-- Rule2.filterType = "IM_FILTER_WEAPON"
-- Rule2.filterSubType = "IM_FILTERSPEC_2H"
-- Rule2.minQuality = ITEM_QUALITY_MAGIC
-- Rule2.action = InventoryManager.ACTION_RETRIEVE

-- local Rule3 = IM_Ruleset:NewRule()
-- Rule3.filterType = "IM_FILTER_APPAREL"
-- Rule3.filterSubType = "IM_FILTERSPEC_MEDIUM"
-- Rule3.stolen = true
-- Rule3.action = InventoryManager.ACTION_DESTROY

-- Ruleset.rules = { Rule1, Rule2, Rule3 }
-- -- Ruleset.rules = { }

-- InventoryManager.currentRuleset = Ruleset
