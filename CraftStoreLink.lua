local DEBUG = 
function() end
-- d

local CSL = {}

InventoryManager.CSL = CSL

local function SplitLink(link,nr)
	local split = {SplitString(':', link)}
	if split[nr] then return tonumber(split[nr]) else return false end
end

function CSL:hasCSAddon()
	return CS and CS.GetTrait and CS.account and CS.account.crafting and true
end

function CSL:IsTraitNeeded(itemLink)
	local need = { }
	local craft, row, trait = CS.GetTrait(itemLink)
	-- Loop all chars known by CS
	for char, data in pairs(CS.account.crafting.studies) do
		--if a char study this item
		if data[craft] and data[craft][row] and (data[craft][row]) then
			-- If this char didn't yet researched this item
			local csr = CS.account.crafting.research
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
		for _, char in pairs(CS.GetCharacters()) do
			if CS.account.style.tracking[char] and not CS.account.style.knowledge[char][id] then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
end

function CSL:IsRecipeNeeded(link)
	local id, need = SplitLink(link,3), { }
	if id then
		for char,data in pairs(CS.account.cook.knowledge) do
			if not data[id] and CS.account.cook.tracking[char] then
				need[char] = true
				need[#need + 1] = char
			end
		end
	end
	return need
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
