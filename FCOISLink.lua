local DEBUG = 
-- function() end
d

local function _tr(str)
	return str
end

local TXT_NO_CARE
local TXT_NO_MARK
local TXT_ANY_MARK

local I_NO_CARE = -3
local I_NO_MARK = -2
local I_ANY_MARK = -1

local FCOISL = {}

local hasFCOIS = nil

InventoryManager.FCOISL = FCOISL

local DIList = nil
local DIChoices = nil

function FCOISL:hasAddon()
	if hasFCOIS ~= nil then return hasFCOIS end

	TXT_NO_CARE = GetString("IM_FCOIS_NOCAREMARK")
	TXT_NO_MARK = GetString("IM_FCOIS_NOMARK")
	TXT_ANY_MARK = GetString("IM_FCOIS_ANYMARK")
	
	hasFCOIS = ( FCOIS ~= nil and FCOIsMarked ~= nil and FCOGetDynamicInfo ~= nil and FCOGetIconText ~= nil)
	
	return hasFCOIS
end

function FCOISL:GetDynamicIconList()
	if DIList then return DIList end
	
	DIList = { }
	if not self:hasAddon() then return DIList end

	local totalNumberOfDynamicIcons, numberToDynamicIconNr = FCOGetDynamicInfo()
	for index, dynamicIconNr in pairs(numberToDynamicIconNr) do
        local dynIconName = FCOGetIconText(dynamicIconNr)
		DIList[#DIList + 1] = { dynamicIconNr, dynIconName }
		DIList[dynIconName] = dynamicIconNr
    end
	
	return DIList
end


function FCOISL:GetIndexedMark(mark)
	if mark == I_NO_MARK then return TXT_NO_MARK
	elseif mark == I_ANY_MARK then return TXT_ANY_MARK
	end
	
	return (FCOISL:hasAddon() and FCOGetIconText(mark)) or TXT_NO_CARE
end

function FCOISL:GetMarkIndex(markText)
	if not FCOISL:hasAddon() then return nil end
	
	if markText == TXT_NO_CARE then return nil
	elseif markText == TXT_NO_MARK then return I_NO_MARK
	elseif markText == TXT_ANY_MARK then return I_ANY_MARK
	else return FCOISL:GetDynamicIconList()[markText]
	end
end

function FCOISL:GetDefaultMark() return I_NO_CARE end

function FCOISL:IsNoMark(mark) return mark == I_NO_MARK end

function FCOISL:IsAnyMark(mark) return mark == I_ANY_MARK end

function FCOISL:GetDynamicIconChoices()
	if DIChoices then return DIChoices end
	
	DIChoices = { TXT_NO_CARE, TXT_NO_MARK, TXT_ANY_MARK }
	if not self:hasAddon() then return DIChoices end

	local totalNumberOfDynamicIcons, numberToDynamicIconNr = FCOGetDynamicInfo()
	for index, dynamicIconNr in pairs(numberToDynamicIconNr) do
        local dynIconName = FCOGetIconText(dynamicIconNr)
		DIChoices[#DIChoices + 1] = dynIconName
    end
	
	return DIChoices
end

function FCOISL:FitMark(instanceId, mark)
	-- If we have switched off this addon, render this filter setting as irrelevant
	if not FCOISL:hasAddon() then return true end

	if not mark then return true end

	if mark == I_NO_MARK then return not FCOISL:HasMark(instanceId, nil)
	elseif mark == I_ANY_MARK then return FCOISL:HasMark(instanceId, nil)
	end

	return FCOISL:HasMark(instanceId, mark)
end

function FCOISL:HasMark(instanceId, mark)
	local _tab = self:GetDynamicIconList()

	if mark then
		return FCOIsMarked(instanceId, mark)
	end
	
	for i = 1, #_tab, 1 do
		if FCOIsMarked(instanceId, _tab[i][1]) then return true end
	end
	
	return false
end
