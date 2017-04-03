local DEBUG =
-- function() end
d

local function _tr(str)
	return str
end

local IM = InventoryManager

local RevCaches = nil
local Empties = nil

local function CreateReverseCache(bagType)
	local _revCache = { }
	local _empties = { }
	
	for i = 0, GetBagSize(bagType)-1, 1 do
		local curStack, maxStack = GetSlotStackSize(bagType, i)
		if curStack > 0 then
			local id = GetItemInstanceId(bagType, i)
			if curStack < maxStack then
				if not _revCache[id] then _revCache[id] = { } end
				local entry = _revCache[id]
				entry[i] = { curStack, maxStack }
			end
		else
			_empties[#_empties + 1] = i
		end
	end
	return _revCache, _empties
end

local function CreateReverseCaches()
	RevCaches = { }
	Empties = { }
	RevCaches[BAG_BACKPACK], 	Empties[BAG_BACKPACK] 	= CreateReverseCache(BAG_BACKPACK)
	RevCaches[BAG_BANK], 		Empties[BAG_BANK] 		= CreateReverseCache(BAG_BANK)
end

local function UpdateCaches(srcBagType, srcSlotId, tgtBagType, tgtSlotId, count)
	local id = GetItemInstanceId(srcBagType, srcSlotId)
	local stack
	
	stack = RevCaches[srcBagType][id] and RevCaches[srcBagType][id][srcSlotId]
	if stack then
		stack[1] = stack[1] - count
		if stack[1] == 0 then
			local newempties = Empties[srcBagType]
			newempties[#newempties + 1] = srcSlotId
			RevCaches[srcBagType][id][srcSlotId] = nil
		end
	else
		local newempties = Empties[srcBagType]
		newempties[#newempties + 1] = srcSlotId
	end
	
	stack = RevCaches[tgtBagType][id] and RevCaches[tgtBagType][id][tgtSlotId]
	if stack then
		stack[1] = stack[1] + count
		if stack[1] == stack[2] then
			RevCaches[tgtBagType][id][tgtSlotId] = nil
		end
	else
		local _, maxStack = GetSlotStackSize(srcBagType, srcSlotId)
		if count < maxStack then
			-- We ended up with a new incomplete stack.
			if not RevCaches[tgtBagType][id] then RevCaches[tgtBagType][id] = { } end
			local newstack = RevCaches[tgtBagType][id]
			newstack[tgtSlotId] = { count, maxStack }
		end	
	end
end

-- Returns (empties source?), tgtSlotId, transferCount
local function FindTargetSlot(srcBagType, srcSlotId, tgtBagType)
	local curStack, maxStack = GetSlotStackSize(srcBagType, srcSlotId)
	local id = GetItemInstanceId(srcBagType, srcSlotId)

	local stacks = RevCaches[tgtBagType][id]
	if stacks then
		-- First, try to find a stack small enough to hold the entirety of the source
		for tgtSlotId, v in pairs(stacks) do
			if v[2]-v[1] >= curStack then
				UpdateCaches(srcBagType, srcSlotId, tgtBagType, tgtSlotId, curStack)
				return true, tgtSlotId, curStack
			end
		end

		-- Now, fill any incomplete stack we might have, splitting the source stack
		for tgtSlotId, v in pairs(stacks) do
			local missing = v[2] - v[1]
			if missing > 0 then
				UpdateCaches(srcBagType, srcSlotId, tgtBagType, tgtSlotId, missing)
				return false, tgtSlotId, missing
			end
		end
	end
		
	-- All the stacks we might have found are already full, we need to find a free slot
	local empties = Empties[tgtBagType]
	
	-- No such luck?
	if #empties == 0 then return false, -1, 0 end
	
	-- It's a complete move, remove the empty slot from the target list, and create a new one on the source list
	local tgtSlotId = empties[#empties]
	empties[#empties] = nil

	UpdateCaches(srcBagType, srcSlotId, tgtBagType, tgtSlotId, curStack)
	return true, tgtSlotId, curStack
	
end


local function CollectSingleDirection(action)
	local bagType = (action == InventoryManager.ACTION_STASH and BAG_BACKPACK) or BAG_BANK
	local _moveSlots = { }
	
	InventoryManager:SetCurrentInventory(bagType)
	
	for i,_ in pairs(InventoryManager.currentInventory) do
		local data = InventoryManager:GetItemData(i)
		if action == InventoryManager.currentRuleset:Match(data) then
			_moveSlots[#_moveSlots + 1] = i
		end
	end
	return _moveSlots
end

local function CalculateSingleMove(direction)
	local srcBagType = (direction == 1 and BAG_BACKPACK) or BAG_BANK
	local tgtBagType = (direction == 1 and BAG_BANK) or BAG_BACKPACK
	
	local srcSlotRepo = Moves[(direction == 1 and "stash") or "retrieve"]
	if #srcSlotRepo == 0 then return "src_empty" end

	local srcSlotId = srcSlotRepo[#srcSlotRepo]
	
	local empties, tgtSlotId, count = FindTargetSlot(srcBagType, srcSlotId, tgtBagType) 
	if count == 0 then return "tgt_full" end
	
	if empties then srcSlotRepo[#srcSlotRepo] = nil end
	
	return "ok", { 
		["srcbag"] = srcBagType,
		["srcslot"] = srcSlotId,
		["tgtbag"] = tgtBagType,
		["tgtslot"] = tgtSlotId,
		["count"] = count
	}
end

local function CalculateMoves()
	-- Prepare an overview of the inventories and the pending transfers in both directions
	CreateReverseCaches()
	local continue = true
	local _moveStack = { }

	InventoryManager.currentRuleset:ResetCounters()
	
    Moves = {
		["stash"] = CollectSingleDirection(IM.ACTION_STASH),
		["retrieve"] = CollectSingleDirection(IM.ACTION_RETRIEVE)
    }
	
	-- We alternate between stashing and retrieving to minimize the chance of one
	-- of the inventories running full.
	while continue do
		local leftres, leftentry = CalculateSingleMove(1)
		local rightres, rightentry = CalculateSingleMove(-1)
		
		-- ZOS Spam limitation
		if #_moveStack > 95 then
			return "limited", _moveStack
		end
		
		-- Both inventories full, can't move anything
		if leftres == "tgt_full" and rightres == "tgt_full" then
			return "deadlock", _moveStack
		end
		
		-- We completed all we were set out to do
		if leftres == "src_empty" and rightres == "src_empty" then
			return "ok", _moveStack
		end
		
		-- We filled up one side, but we can't empty it out
		if leftres ~= "ok" and rightres ~= "ok" then
			return "partial", _moveStack
		end
		
		if leftres == "ok" then
			_moveStack[#_moveStack + 1] = leftentry
		end
		
		if rightres == "ok" then
			_moveStack[#_moveStack + 1] = rightentry
		end
	end
	-- NOTREACHED
end

InventoryManager.moveStatus = nil

function ProcessMove(move)	
	local bagIdFrom = move["srcbag"]
	local slotIdFrom = move["srcslot"]
	local bagIdTo = move["tgtbag"]
	local slotIdTo = move["tgtslot"]
	local qtyToMove = move["count"]
	local action = (bagIdFrom == BAG_BACKPACK and InventoryManager.ACTION_STASH) or InventoryManager.ACTION_RETRIEVE
	
	local data = InventoryManager:GetItemData(slotIdFrom, SHARED_INVENTORY:GetOrCreateBagCache(bagIdFrom))
	InventoryManager:ReportAction(data, false, action)
	
	if IsProtectedFunction("RequestMoveItem") then
		CallSecureProtected("RequestMoveItem", bagIdFrom, slotIdFrom, bagIdTo, slotIdTo, qtyToMove)
	else
		RequestMoveItem(bagIdFrom, slotIdFrom, bagIdTo, slotIdTo, qtyToMove)
	end
end

function InventoryManager:FinishMoves()
	local result
	if self.moveStatus == "limited" then
		result = GetString(IM_BANK_LIMITED)
	elseif self.moveStatus == "deadlock" then
		result = GetString(IM_BANK_DEADLOCK)
	elseif self.moveStatus == "partial" then
		result = GetString(IM_BANK_PARTIAL)
	elseif self.moveStatus == "ok" then
		result = GetString(IM_BANK_OK)
	end
	
	if result ~= "" then
		CHAT_SYSTEM:AddMessage(result)
	end
end

function InventoryManager:BalanceCurrency(currencyType, minCur, maxCur, curName)
	local carried = GetCarriedCurrencyAmount(currencyType)
	local banked = GetBankedCurrencyAmount(currencyType)
	
	local move = 0
	if(carried < minCur) then
		move = carried - minCur
	elseif(carried > maxCur) then
		move = carried - maxCur
	end
	
	if move == 0 then
		return
	elseif move > 0 then
		CHAT_SYSTEM:AddMessage(
			zo_strformat(GetString(IM_CUR_DEPOSIT), move, curName))
		DepositCurrencyIntoBank(currencyType, move)
	else
		move = -move
		if move > banked then move = banked end
		if move == 0 then return end
		CHAT_SYSTEM:AddMessage(
			zo_strformat(GetString(IM_CUR_WITHDRAW), move, curName))
		WithdrawCurrencyFromBank(currencyType, move)
	end
end

local function event_filter_fn(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) 
	-- Bank moves fire two events, react only if we got the receiver side.
	if not stackCountChange or stackCountChange > 0 then
		return true
	end
	return false
end

function InventoryManager:OnBankOpened()
	local moves
	self.moveStatus, moves = CalculateMoves()
	
	-- Flip the list. The processors start from the end, and the sequence is important here.
	for i = 1, #moves / 2, 1 do
		local tmp = moves[i]
		moves[i] = moves[(#moves+1) - i]
		moves[(#moves+1) - i] = tmp
	end

	self:BalanceCurrency(CURT_MONEY, self.settings.minGold, self.settings.maxGold, GetString(IM_CUR_GOLD))
	self:BalanceCurrency(CURT_TELVAR_STONES, self.settings.minTV, self.settings.maxTV, GetString(IM_CUR_TVSTONES))
	
	zo_callLater(
		function()
			IM:DoEventProcessing(moves, 
				ProcessMove,
				function() IM:FinishMoves() end,
				EVENT_INVENTORY_SINGLE_SLOT_UPDATE,
				EVENT_CLOSE_BANK,
				InventoryManager.settings.bankMoveDelay,
				event_filter_fn)
		end,
		InventoryManager.settings.bankInitDelay)
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_BANK, function() InventoryManager:OnBankOpened() end)
