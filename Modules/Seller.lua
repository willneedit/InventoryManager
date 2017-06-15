local DEBUG =
-- function() end
d

local function _tr(str)
	return str
end

local _Gain = nil

local function do_sell(data, eventCode, itemName, itemQuantity, money) 
	if eventCode ~= nil then
		_Gain = _Gain + money
	end
	InventoryManager:ProcessSingleItem(false, data)
end

local function filter_for_sale(fence, data)
	if data.stolen ~= fence then return false end
	
	if InventoryManager.FCOISL:IsProtectedAction(
		InventoryManager.ACTION_SELL,
		data.bagId,
		data.slotId,
		fence) then return false end
	return true
end

local function filter_for_launder(data)
	if InventoryManager.FCOISL:IsProtectedAction(
		InventoryManager.ACTION_LAUNDER,
		data.bagId,
		data.slotId) then return false end
	return true
end

function InventoryManager:SellItems(stolen)
	local list = { }
	local end_fn = function(abort, eventCode, itemName, itemQuantity, money)
			if eventCode ~= nil then
				_Gain = _Gain + money
			end
			CHAT_SYSTEM:AddMessage(zo_strformat(GetString(IM_CUR_SOLDJUNK), _Gain))
		end

	local launder_run = function(abort, eventCode, itemName, itemQuantity, money)
		if eventCode ~= nil then
			_Gain = _Gain + money
		end
		InventoryManager.currentRuleset:ResetCounters()
		InventoryManager:EventProcessBag(BAG_BACKPACK, InventoryManager.ACTION_LAUNDER,
			filter_for_launder,
			function(data) InventoryManager:ProcessSingleItem(false, data) end,
			function(abort) end_fn(abort) end,
			EVENT_ITEM_LAUNDER_RESULT,
			EVENT_CLOSE_STORE,
			InventoryManager.settings.bankMoveDelay)
		end

	_Gain = 0
	InventoryManager.currentRuleset:ResetCounters()
	self:EventProcessBag(BAG_BACKPACK, InventoryManager.ACTION_SELL,
		function(data) return filter_for_sale(stolen, data) end,
		do_sell,
		((stolen and launder_run) or end_fn),
		EVENT_SELL_RECEIPT,
		EVENT_CLOSE_STORE,
		InventoryManager.settings.bankMoveDelay)
		
end

local function OnOpenStore(eventCode)
	if InventoryManager.settings.autosell then
		InventoryManager:SellItems(false)
	end
end

local function OnOpenFence(eventCode)
	if InventoryManager.settings.autosell then
		InventoryManager:SellItems(true)
	end
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_STORE, OnOpenStore)
EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_FENCE, OnOpenFence)
