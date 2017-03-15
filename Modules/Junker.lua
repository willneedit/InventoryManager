
function InventoryManager:CheckAndDestroy()
	if GetNumBagFreeSlots(BAG_BACKPACK) >= InventoryManager.settings.destroyThreshold then
		return
	end

	self:SetCurrentInventory(BAG_BACKPACK)
	for i,_ in pairs(self.currentInventory) do
		local data = self:GetItemData(i)
		local action, index, text = InventoryManager.currentRuleset:Match(data)
		if action == self.IM_Ruleset.ACTION_DESTROY then
			self:ReportAction(data, false, action, index, text)
			DestroyItem(BAG_BACKPACK, i)
		end
	end
end

function InventoryManager:WorkBackpack(dryrun)
	self:SetCurrentInventory(BAG_BACKPACK)
	for i,_ in pairs(self.currentInventory) do
		local data = self:GetItemData(i)
		local action, index, text = self.currentRuleset:Match(data)

		if action == self.IM_Ruleset.ACTION_JUNK or 
			action == self.IM_Ruleset.ACTION_DESTROY then
			if not dryrun then
				action = self.IM_Ruleset.ACTION_JUNK
				SetItemIsJunk(BAG_BACKPACK, i, true)
			end
			self:ReportAction(data, dryrun, action, index, text)
		end
		if (action == self.IM_Ruleset.ACTION_STASH) and dryrun then
			self:ReportAction(data, dryrun, action, index, text)
		end
	end
	if not dryrun then
		self:CheckAndDestroy()
	end
end

function InventoryManager:UnJunk()
	for i = 1, GetBagSize(BAG_BACKPACK), 1 do
		SetItemIsJunk(BAG_BACKPACK, i, false)
	end
end

function InventoryManager:OnInvSlotUpdate(bagId, slotId)
	self:SetCurrentInventory(bagId)
	local data = self:GetItemData(slotId)
	
	if not data then return end
	
	local action = self.currentRuleset:Match(data)
	if action == self.IM_Ruleset.ACTION_JUNK or
		action == self.IM_Ruleset.ACTION_DESTROY then
		self:ReportAction(data, false, action)
		SetItemIsJunk(bagId, slotId, true)
	end

	self:CheckAndDestroy()
end

local function OnInvSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) 
	if not isNewItem or bagId ~= BAG_BACKPACK then return end

	InventoryManager:OnInvSlotUpdate(bagId, slotId)
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnInvSlotUpdate)
