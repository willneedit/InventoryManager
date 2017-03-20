local DEBUG =
-- function() end
d

local function _tr(str)
	return str
end
local IM = InventoryManager
local SE = IM.UI.Settings

function SE:GetControls()
	return {
		{
			type = "slider",
			name = GetString("IM_SET_MIN_GOLD"),
			tooltip = GetString("IM_SET_MIN_GOLD_TOOLTIP"),
			min = 0,
			max = 100000,
			getFunc = function() return IM.settings.minGold end,
			setFunc = function(value) IM.settings.minGold = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "slider",
			name = GetString("IM_SET_MAX_GOLD"),
			tooltip = GetString("IM_SET_MAX_GOLD_TOOLTIP"),
			min = 0,
			max = 100000,
			getFunc = function() return IM.settings.maxGold end,
			setFunc = function(value) IM.settings.maxGold = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "slider",
			name = GetString("IM_SET_MIN_TV"),
			tooltip = GetString("IM_SET_MIN_TV_TOOLTIP"),
			min = 0,
			max = 100000,
			getFunc = function() return IM.settings.minTV end,
			setFunc = function(value) IM.settings.minTV = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "slider",
			name = GetString("IM_SET_MAX_TV"),
			tooltip = GetString("IM_SET_MAX_TV_TOOLTIP"),
			min = 0,
			max = 100000,
			getFunc = function() return IM.settings.maxTV end,
			setFunc = function(value) IM.settings.maxTV = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "slider",
			name = GetString("IM_SET_BANK"),
			tooltip = GetString("IM_SET_BANK_TOOLTIP"),
			min = 2,
			max = 200,
			getFunc = function() return IM.settings.bankMoveDelay end,
			setFunc = function(value) IM.settings.bankMoveDelay = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "slider",
			name = GetString("IM_SET_DEST"),
			tooltip = GetString("IM_SET_DEST_TOOLTIP"),
			min = 0,
			max = 500,
			getFunc = function() return IM.settings.destroyThreshold end,
			setFunc = function(value) IM.settings.destroyThreshold = value end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "checkbox",
			name = GetString("IM_SET_AUTOSELL"),
			tooltip = GetString("IM_SET_AUTOSELL_TOOLTIP"),
			width = "half",
			getFunc = function() return IM.settings.autosell end,
			setFunc = function(value) IM.settings.autosell = value end,
		},
		{
			type = "description",
			text = "",
			width = "half",
		},
		{
			type = "button",
			name = GetString("IM_SET_LIST"),
			tooltip = GetString("IM_SET_LIST_TOOLTIP"),
			func = function() IM:listrules() end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "button",
			name = GetString("IM_SET_UNJUNK"),
			tooltip = GetString("IM_SET_UNJUNK_TOOLTIP"),
			func = function() IM:UnJunk() end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "button",
			name = GetString("IM_SET_DRYRUN"),
			tooltip = GetString("IM_SET_DRYRUN_TOOLTIP"),
			func = function() IM:dryrun() end,
			width = "half",	--or "half" (optional)
		},
		{
			type = "button",
			name = GetString("IM_SET_RUN"),
			tooltip = GetString("IM_SET_RUN_TOOLTIP"),
			func = function() IM:WorkBackpack(false) end,
			width = "half",	--or "half" (optional)
		},
	}
end

function SE:PopulateUI()
end
