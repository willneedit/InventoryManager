local DEBUG =
-- function() end
d

local function _tr(str)
	return str
end

local ST_OK = 0
local ST_TGTFULL = 1
local ST_SPAM = 2

local InvCache = nil
local Moves = nil

local function ScanInventory(bagType)
	local _empties = { }
	local _stackCount = { }
	local inv = SHARED_INVENTORY:GetOrCreateBagCache(bagType)
	for i = 0, GetBagSize(bagType)-1, 1 do
		if not inv[i] then
			_empties[#_empties + 1] = i 
		else
			local curStack, maxStack = GetSlotStackSize(bagType, i)
			_stackCount[i] = {
				["id"] = inv[i].itemInstanceId,
				["current"] = curStack,
				["max"] = maxStack
			}
		end
	end
	-- Empties is a list of empty slots, items an overview over stack counts in specific slots
	return { ["empties"] = _empties, ["items"] = _stackCount }
end

local function FindTargetSlot(srcBagType, srcSlotId, tgtBagType)
	local srcInv = InvCache[srcBagType]
	local tgtInv = InvCache[tgtBagType]

	local iId = srcInv["items"][srcSlotId]["id"]
	local count = srcInv["items"][srcSlotId]["current"]
	
	-- Try to fill up existing stacks, return even incomplete transfers doing so
	for k,v in pairs(tgtInv["items"]) do
		local missing = v["max"] - v["current"]
		if iId == v["id"] and missing > 0 then
			local empties = missing >= count
			return empties, false, k, (empties and count) or missing
		end
	end
	
	-- No incomplete stack found, return an empty slot or a failure
	local emptyslots = tgtInv["empties"]

	if #emptyslots == 0 then
		return false, false, -1, 0
	end

	-- We'd start another stack, but we're sure it'll be a complete transfer
	return true, true, emptyslots[#emptyslots], count
end


local function CollectSingleDirection(action)
	local bagType = (action == InventoryManager.IM_Ruleset.ACTION_STASH and BAG_BACKPACK) or BAG_BANK
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

local function PrepareMoveCaches()
	InvCache = { 
		[BAG_BACKPACK] = ScanInventory(BAG_BACKPACK),
		[BAG_BANK] = ScanInventory(BAG_BANK)
	}
	
	Moves = {
		["stash"] = CollectSingleDirection(InventoryManager.IM_Ruleset.ACTION_STASH),
		["retrieve"] = CollectSingleDirection(InventoryManager.IM_Ruleset.ACTION_RETRIEVE)
	}
	
end

local function CalculateSingleMove(direction)
	local IMR = InventoryManager.IM_Ruleset
	local srcBagType = (direction == 1 and BAG_BACKPACK) or BAG_BANK
	local tgtBagType = (direction == 1 and BAG_BANK) or BAG_BACKPACK
	
	local srcSlotRepo = Moves[(direction == 1 and "stash") or "retrieve"]
	if #srcSlotRepo == 0 then
		return "src_empty"
	end

	local srcSlotId = srcSlotRepo[#srcSlotRepo]
	
	local empties, newSlot, tgtSlotId, count = FindTargetSlot(srcBagType, srcSlotId, tgtBagType) 
	if count == 0 then
		return "tgt_full"
	end
	
	InventoryManager:SetCurrentInventory(srcBagType)
	local data = InventoryManager:GetItemData(srcSlotId)
	
	if count > 0 then
	end
	
	if empties then
		-- Empties source slot, remove from pending moves
		InvCache[srcBagType]["items"][srcSlotId] = nil
		
		local emptyslots = InvCache[srcBagType]["empties"]
		emptyslots[#emptyslots + 1] = srcSlotId

		srcSlotRepo[#srcSlotRepo] = nil
	else
		-- Incomplete move, deduce count in source cache
		local srcslot = InvCache[srcBagType]["items"][srcSlotId]
		srcslot["current"] = srcslot["current"] - count
	end
	
	if newSlot then
		-- Filled up a new slot in the target
		InvCache[tgtBagType]["items"][tgtSlotId] = {
				["id"] = data.itemInstanceId,
				["current"] = count,
				["max"] = data.maxCount
		}

		local emptyslots = InvCache[tgtBagType]["empties"]
		emptyslots[#emptyslots] = nil
	else
		-- Stashed onto existing stack, increase count
		local tgtslot = InvCache[tgtBagType]["items"][tgtSlotId]
		tgtslot["current"] = tgtslot["current"] + count
	end

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
	PrepareMoveCaches()
	local continue = true
	local _moveStack = { }
	
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

-- Pending slots for time delayed actions
InventoryManager.pendingMoves = nil
InventoryManager.moveStatus = nil

function InventoryManager:ProcessMoves()
	if not self.pendingMoves or self.currentMove > #self.pendingMoves then
		return self:FinishMoves()
	end

	local IMR = InventoryManager.IM_Ruleset
	
	local move = self.pendingMoves[self.currentMove]
		
	local bagIdFrom = move["srcbag"]
	local slotIdFrom = move["srcslot"]
	local bagIdTo = move["tgtbag"]
	local slotIdTo = move["tgtslot"]
	local qtyToMove = move["count"]
	local action = (bagIdFrom == BAG_BACKPACK and IMR.ACTION_STASH) or IMR.ACTION_RETRIEVE
	
	local data = self:GetItemData(slotIdFrom, SHARED_INVENTORY:GetOrCreateBagCache(bagIdFrom))
	self:ReportAction(data, false, action)
	
	if IsProtectedFunction("RequestMoveItem") then
		CallSecureProtected("RequestMoveItem", bagIdFrom, slotIdFrom, bagIdTo, slotIdTo, qtyToMove)
	else
		RequestMoveItem(bagIdFrom, slotIdFrom, bagIdTo, slotIdTo, qtyToMove)
	end

	self.currentMove = self.currentMove + 1
	zo_callLater(
		function() InventoryManager:ProcessMoves() end,
		InventoryManager.settings.bankMoveDelay)
end

function InventoryManager:FinishMoves()
	local result
	if self.moveStatus == "limited" then
		result = GetString("IM_BANK_LIMITED")
	elseif self.moveStatus == "deadlock" then
		result = GetString("IM_BANK_DEADLOCK")
	elseif self.moveStatus == "partial" then
		result = GetString("IM_BANK_PARTIAL")
	elseif self.moveStatus == "ok" then
		result = GetString("IM_BANK_OK")
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
			zo_strformat(GetString("IM_CUR_DEPOSIT"), move, curName))
		DepositCurrencyIntoBank(currencyType, move)
	else
		move = -move
		if move > banked then move = banked end
		if move == 0 then return end
		CHAT_SYSTEM:AddMessage(
			zo_strformat(GetString("IM_CUR_WITHDRAW"), move, curName))
		WithdrawCurrencyFromBank(currencyType, move)
	end
end

function InventoryManager:OnBankOpened()
	self.moveStatus, self.pendingMoves = CalculateMoves()
	self.currentMove = 1
	
	self:BalanceCurrency(CURT_MONEY, self.settings.minGold, self.settings.maxGold, GetString("IM_CUR_GOLD"))
	self:BalanceCurrency(CURT_TELVAR_STONES, self.settings.minTV, self.settings.maxTV, GetString("IM_CUR_TVSTONES"))
	
	zo_callLater(function() InventoryManager:ProcessMoves() end, 100)
end

local function OnBankOpened(eventCode)
	InventoryManager:OnBankOpened()
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_BANK, OnBankOpened)
