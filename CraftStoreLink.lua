local DEBUG = 
function() end
-- d

local function _tr(str)
	return str
end

if not InventoryManager then InventoryManager = {} end
local IM = InventoryManager

local CSL = {}

local Used_CS
local Used_CSA

local hasCS = nil

IM.CSL = CSL

local function SplitLink(link,nr)
	local split = {SplitString(':', link)}
	if split[nr] then return tonumber(split[nr]) else return false end
end

function CSL:hasCSAddon()
	if hasCS ~= nil then 
	
		-- This variable is late initialized, update if needed
		if hasCS == "old" then
			Used_CSA = Used_CS.account
		elseif hasCS == "new" then
			Used_CSA = Used_CS.Account
		end
		
		return hasCS ~= false and true
	end
	
	if CS then
		Used_CS  = CS
		Used_CSA = Used_CS.account
		CHAT_SYSTEM:AddMessage(GetString(IM_INIT_DETECTED_CS_OLD))
		hasCS = "old"
	elseif CraftStoreFixedAndImprovedLongClassName then
		Used_CS  = CraftStoreFixedAndImprovedLongClassName
		Used_CSA = Used_CS.Account
		CHAT_SYSTEM:AddMessage(GetString(IM_INIT_DETECTED_CS_NEW))
		hasCS = "new"
	else
		hasCS = false
	end
	return hasCS
end

function CSL:IsTraitNeeded(itemLink)
	local need = { }
	local craft, row, trait = Used_CS.GetTrait(itemLink)
	-- Loop all chars known by CS
	for char, data in pairs(Used_CSA.crafting.studies) do
		--if a char study this item
		if data[craft] and data[craft][row] and (data[craft][row]) then
			-- If this char didn't yet researched this item
			local csr = Used_CSA.crafting.research
			if csr[char][craft] and csr[char][craft][row] and csr[char][craft][row][trait] == false then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
end

local CURRENT_PLAYER = GetUnitName("player")

function CSL:IsStyleNeeded(link)
	local id, need = SplitLink(link,3), { }
	if id then
		for _, char in pairs(Used_CS.GetCharacters()) do
			if Used_CSA.style.tracking[char] and not Used_CSA.style.knowledge[char][id] then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
end

function CSL:IsCookRecipeNeeded(link)
	local id, need = SplitLink(link,3), { }
	if id then
		for char,data in pairs(Used_CSA.cook.knowledge) do
			if data[id] ~= nil and not data[id] and Used_CSA.cook.tracking[char] then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
end

function CSL:IsBlueprintNeeded(link)
	local id, need = SplitLink(link,3), { }

	if not Used_CSA.furnisher then
		return need
	end

	if id then
		for char,data in pairs(Used_CSA.furnisher.knowledge) do
			-- Workaround for CS fixed and Improved: It still has a common switch for cooking and furniture recipes
			if data[id] ~= nil and not data[id] and (Used_CSA.cook.tracking[char] or Used_CSA.furnisher.tracking[char]) then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
end

function CSL:IsRecipeNeeded(link)
	local collate1 = self:IsCookRecipeNeeded(link)
	local collate2 = self:IsBlueprintNeeded(link)
	local all = { }
	for k, v in pairs(collate1) do
		if type(k) == "string" then all[k] = true end
	end
	for k, v in pairs(collate2) do
		if type(k) == "string" then all[k] = true end
	end
	for k, v in pairs(all) do
		all[#all+1] = k
	end
	return all
end

function CSL:isUnknown(itemLink)
	local chars
	local itemType
	
	if not CSL:hasCSAddon() then
		return false, false
	end

	itemType, _ = GetItemLinkItemType(itemLink)
	if itemType == ITEMTYPE_RECIPE then
		chars = CSL:IsRecipeNeeded(itemLink)
	elseif itemType == ITEMTYPE_RACIAL_STYLE_MOTIF then
		chars = CSL:IsStyleNeeded(itemLink)
	elseif itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR then
		chars = CSL:IsTraitNeeded(itemLink)
	end

	if not chars then
		return false, false
	end

	local oneself = (chars[CURRENT_PLAYER] or false)
	local numothers = #chars - ((oneself and 1) or 0)
	local others = numothers > 0
	DEBUG(oneself, #chars, numothers, others)
	return oneself, others
end
