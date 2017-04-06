local DEBUG =
-- function() end
d


local IM = InventoryManager

function IM:CheckAndDestroy()
	if GetNumBagFreeSlots(BAG_BACKPACK) >= IM.settings.destroyThreshold then
		return
	end

	InventoryManager.currentRuleset:ResetCounters()

	self:SetCurrentInventory(BAG_BACKPACK)
	for i,_ in pairs(self.currentInventory) do
		local data = self:GetItemData(i)
		local action, index, text = IM.currentRuleset:Match(data)
		if action == self.ACTION_DESTROY and not
			self.FCOISL:IsProtectedAction(action, BAG_BACKPACK, i) then
			self:ReportAction(data, false, action, index, text)
			DestroyItem(BAG_BACKPACK, i)
		end
	end
end

local function filter_for_backpack_action(dryrun, data)
	if data.action == IM.ACTION_JUNK then
		return not data.junk
	end
	if data.action == IM.ACTION_DESTROY then
		return true
	end
	
	-- List other inventory actions only if it's a dryrun.
	-- Else we need to get to the specific stations to actually perform them
	if data.action ~= IM.ACTION_KEEP and data.action ~= IM.ACTION_RETRIEVE and dryrun then
		return true
	end
	return false
end

function IM:WorkBackpack(dryrun)
	InventoryManager.currentRuleset:ResetCounters()
	self:ProcessBag(BAG_BACKPACK,
		function(data) return filter_for_backpack_action(dryrun, data) end,
		function(data) IM:ProcessSingleItem(dryrun, data) end,
		function() IM:CheckAndDestroy() end,
		IM.settings.statusChangeDelay)
end

function IM:UnJunk()
	for i = 1, GetBagSize(BAG_BACKPACK), 1 do
		SetItemIsJunk(BAG_BACKPACK, i, false)
	end
end

function IM:OnInvSlotUpdate(bagId, slotId)
	self:SetCurrentInventory(bagId)
	local data = self:GetItemData(slotId)
	
	if not data then return end

	if not self.currentRuleset or not self.currentRuleset.Match then return end
	
	data.action, data.index, data.text = self.currentRuleset:Match(data)
	if filter_for_backpack_action(false, data) then
		IM:ProcessSingleItem(false, data)
	end

	self:CheckAndDestroy()
end

local function OnInvSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) 
	if not isNewItem or bagId ~= BAG_BACKPACK then return end

	IM:OnInvSlotUpdate(bagId, slotId)
end

EVENT_MANAGER:RegisterForEvent(IM.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnInvSlotUpdate)
