local DEBUG =
-- function() end
d

local function _tr(str)
	return str
end

local Sells = nil
local StartGold = 0

local function ProcessMoves()
	if not Sells or #Sells == 0 then
		local gain = GetCarriedCurrencyAmount(CURT_MONEY) - StartGold
		CHAT_SYSTEM:AddMessage(zo_strformat(GetString("IM_CUR_SOLDJUNK"), gain))
		return
	end
	
	local entry = Sells[#Sells]
	local slotId = entry[1]
	local count = entry[2]
	
	SellInventoryItem(BAG_BACKPACK, slotId, count)
	Sells[#Sells] = nil
	zo_callLater(ProcessMoves, InventoryManager.settings.bankMoveDelay)
end

function InventoryManager:SellJunk(stolen)
	Sells = { }
	StartGold = GetCarriedCurrencyAmount(CURT_MONEY)
	self:SetCurrentInventory(BAG_BACKPACK)
	for i,_ in pairs(self.currentInventory) do
		if #Sells > 90 then
			break
		end
		local data = self:GetItemData(i)
		if data.junk and data.stolen == stolen then
			Sells[#Sells + 1] = { i, data.count }
		end
	end
	zo_callLater(ProcessMoves, InventoryManager.settings.bankMoveDelay)
end

local function OnOpenStore(eventCode)
	InventoryManager:SellJunk(false)
end

local function OnOpenFence(eventCode)
	InventoryManager:SellJunk(true)
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_STORE, OnOpenStore)
EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_OPEN_FENCE, OnOpenFence)
