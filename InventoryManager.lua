local DEBUG =
function() end
-- d

local function _tr(str)
	return str
end

InventoryManager = {}

local IM = InventoryManager

InventoryManager.LAM = LibStub:GetLibrary("LibAddonMenu-2.0")

InventoryManager.name = "InventoryManager"
InventoryManager.loadedAddons = {}

-- The current inventory we're working on
InventoryManager.currentInventory = nil
InventoryManager.currentBagType = nil

-- The current ruleset we're working with
InventoryManager.currentRuleset = { }

function InventoryManager:ProcessSingleItem(dryrun, data)
	local action = data.action
	
	if not dryrun then 
		-- Destroying is only done as an afterthought, junk at most for now.
		if action == self.ACTION_DESTROY then
			action = self.ACTION_JUNK
		end

		if action == self.ACTION_JUNK then
			SetItemIsJunk(data.bagId, data.slotId, true)
		elseif action == self.ACTION_SELL then
			SellInventoryItem(data.bagId, data.slotId, data.count ) 
		elseif action == self.ACTION_LAUNDER then
			LaunderItem(data.bagId, data.slotId, data.count ) 
		end
	end
	IM:ReportAction(data, dryrun, action, data.index, data.text)
end

function InventoryManager:ReportAction(data, dryrun, action, rIndex, rString)
	local index = (dryrun and 0) or 1
	if self.FCOISL:IsProtectedAction(data.action, data.bagId, data.slotId) then
		index = 2
	end
	CHAT_SYSTEM:AddMessage(zo_strformat(GetString("IM_TAKENACTION", index),
			GetString("IM_ACTIONTXT",action),
			data.icon, 
			data.lnk,
			rIndex or "",
			rString or ""))
end

function InventoryManager:SetCurrentInventory(bagType)
	self.currentInventory = SHARED_INVENTORY:GetOrCreateBagCache(bagType)

	self.currentBagType = bagType

end

function InventoryManager:SetShownInventory()
	local bagType = nil
	
	if SCENE_MANAGER.currentScene == SCENE_MANAGER.scenes.inventory then
		bagType = BAG_BACKPACK
	elseif SCENE_MANAGER.currentScene == SCENE_MANAGER.scenes.bank then
		if INVENTORY_FRAGMENT:IsShowing() then
			bagType = BAG_BACKPACK
		elseif BANK_FRAGMENT:IsShowing() then
			bagType = BAG_BANK			
		end
	end

	if not bagType then
		return nil
	end
	self:SetCurrentInventory(bagType)
	return bagType
end

function InventoryManager:GetItemData(slotId, _inv)
	local data = {}
	local inv = nil
	
	if _inv then
		inv = _inv
	else
		inv = self.currentInventory
	end
	
	if not inv or not inv[slotId] then
		return nil
	end
	
	local itemLink = GetItemLink(self.currentBagType, slotId)

	data.bagId = self.currentBagType
	data.slotId = slotId
	
	data.name = inv[slotId].name
	data.lnk = itemLink
	data.itemInstanceId = inv[slotId].itemInstanceId
	
	data.count, data.maxCount = GetSlotStackSize(self.currentBagType, slotId)
	data.locked = IsItemPlayerLocked(self.currentBagType, slotId)
	data.junk = IsItemJunk(self.currentBagType, slotId)
	
	data.itemType, data.specialitemtype = GetItemLinkItemType(itemLink)
	data.value = GetItemLinkValue(itemLink, false)

	data.icon, _, _, data.equipType, data.itemStyle = GetItemLinkInfo(itemLink)
	
	if data.itemType == ITEMTYPE_ARMOR then
		data.armorType = GetItemLinkArmorType(itemLink)
	elseif data.itemType == ITEMTYPE_WEAPON then
		data.weaponType = GetItemLinkWeaponType(itemLink)
	end

	data.traitType = GetItemLinkTraitInfo(itemLink)

	data.isSet, data.set = GetItemLinkSetInfo(itemLink)
	
	data.quality = GetItemLinkQuality(itemLink)
	data.stolen = IsItemLinkStolen(itemLink)

	data.unknownself, data.unknownothers = self.CSL:isUnknown(itemLink)
	return data
end

function InventoryManager:listrules()
	CHAT_SYSTEM:AddMessage(GetString(IM_LIST_NUM_RULES) .. #InventoryManager.currentRuleset.rules)
	
	for i = 1, #InventoryManager.currentRuleset.rules, 1 do
		if not InventoryManager.currentRuleset.rules[i] then
			break
		end
		CHAT_SYSTEM:AddMessage(GetString(IM_LIST_RULE) .. i .. ":" .. InventoryManager.currentRuleset.rules[i]:ToString())
	end
end

function InventoryManager:dryrun()
	self:WorkBackpack(true)
end

function InventoryManager:run()
	self:WorkBackpack(false)
end

function InventoryManager:OpenSettings()
	self.LAM:OpenToPanel(self.UI.panel)
end

function InventoryManager:help()	
	-- self:SetCurrentInventory(BAG_BACKPACK)
	-- for i, entry in pairs(self.currentInventory) do
		-- local knownString = ""
		-- local oneself, others = self.CSL:isUnknown(entry.lnk)
		-- if oneself then
			-- knownString = " (unknown to you)"
		-- end
		-- if others then
			-- knownString = knownString .. " (unknown to others)"
		-- end
		-- CHAT_SYSTEM:AddMessage("  Item " .. i .. ": " .. entry.lnk .. knownString);
	-- end
	CHAT_SYSTEM:AddMessage("/im listrules - list the rules currently defined")
	CHAT_SYSTEM:AddMessage("/im dryrun    - show what the currently defined rules would do to your inventory")
	CHAT_SYSTEM:AddMessage("/im run       - make a pass of the filters over your inventory")
	CHAT_SYSTEM:AddMessage("/im settings  - Open up the settings menu")
end

function InventoryManager:SlashCommand(argv)
    local options = {}
    local searchResult = { string.match(argv,"^(%S*)%s*(.-)$") }
    for i,v in pairs(searchResult) do
        if (v ~= nil and v ~= "") then
            options[i] = string.lower(v)
        end
    end
	
	if #options == 0 or options[1] == "help" then
		self:help()
	elseif options[1] == "listrules" then
		self:listrules()
	elseif options[1] == "dryrun" then
		self:dryrun()
	elseif options[1] == "run" then
		self:run()
	elseif options[1] == "settings" then
		self:OpenSettings()
	else
		CHAT_SYSTEM:AddMessage("Unknown parameter '" .. argv .. "'")
	end
end

InventoryManager.UI = { }
InventoryManager.UI.RuleEdit = { }
InventoryManager.UI.ProfileEdit = { }
InventoryManager.UI.Settings = { }

local RuleEdit = InventoryManager.UI.RuleEdit
local ProfileEdit = InventoryManager.UI.ProfileEdit
local Settings = InventoryManager.UI.Settings

function InventoryManager:InitializeUI()
	local panelData = {
		type = "panel",
		name = "InventoryManager",
		registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
	}	
		
	local mainPanel = {
		{
			type = "submenu",
			name = GetString(IM_UI_PM),
			tooltip = GetString(IM_UI_PM_TOOLTIP),	--(optional)
			controls = ProfileEdit:GetControls(),
		},
		{
			type = "submenu",
			name = GetString(IM_UI_RM),
			tooltip = GetString(IM_UI_RM_TOOLTIP),	--(optional)
			controls = RuleEdit:GetControls(),
		},
		{
			type = "submenu",
			name = GetString(IM_UI_SETTINGS),
			tooltip = GetString(IM_UI_SETTINGS_TOOLTIP),	--(optional)
			controls = Settings:GetControls(),
		},
		
	}
	
	self.UI.panel = self.LAM:RegisterAddonPanel("iwontsayInventoryManager", panelData)
	self.LAM:RegisterOptionControls("iwontsayInventoryManager", mainPanel)
end

local function ctorandload(ctor, ctorob, data)
	local _new = ctor(ctorob)
	for k,v in pairs(data) do
		if v then _new[k] = v end
	end
	return _new
end

local function loadRule(ruleData)
	return ctorandload(InventoryManager.IM_Ruleset.NewRule, InventoryManager.IM_Ruleset, ruleData)
end

local function loadRulelist(rulelistData)
	local _new = { }
	for k,v in pairs(rulelistData) do
		_new[k] = loadRule(v)
	end
	return _new
end

local function loadProfile(profileData)
	local _new = { }
	for k,v in pairs(profileData) do
		_new[k] = { }
		_new[k]["name"] = v["name"]
		_new[k]["rules"] = loadRulelist(v["rules"])
	end
	return _new
end

function InventoryManager:Update()
	local version = self.settings.Version or 1
	if version < 2 then
		local _rule = self.IM_Ruleset:NewRule()
		_rule.action = self.ACTION_SELL
		_rule.junk = true
		local rs = self.currentRuleset.rules
		table.insert(rs, 1, _rule)
		CHAT_SYSTEM:AddMessage(GetString(IM_INIT_UPDATE_V2_NOTE))
	end
	
	self.settings.Version = 2
	self:Save()
end

function InventoryManager:Init()
	self.currentRuleset			= self.IM_Ruleset:New()

	self.charDefaults = {
		["currentRules"]	= self.currentRuleset["rules"],
		["settings"]		= {
			["destroyThreshold"]	= 5,
			["bankMoveDelay"]		= 20,
			["bankInitDelay"]		= 1000,
			["statusChangeDelay"]	= 20,
			["maxGold"]				= 5000,
			["minGold"]				= 1000,
			["maxTV"]				= 10,
			["minTV"]				= 0,
			["autosell"]			= true,
		}
	}
	
	self.accDefaults = {
		["Profiles"] = { }
	}
	
	self.accVariables = ZO_SavedVars:NewAccountWide(
		"IMSavedVars",
		1,
		nil,
		self.accDefaults)
	
	self.charVariables = ZO_SavedVars:New(
		"IMSavedVars",
		1,
		nil,
		self.charDefaults)
		
	self.Profiles 				= loadProfile(self.accVariables.Profiles)
	self.currentRuleset.rules	= loadRulelist(self.charVariables.currentRules)
	self.settings				= self.charVariables.settings
	
	self.presetProfiles			= loadProfile(self.presetProfiles)

	self.CSL.hasCSAddon()
	self.FCOISL:hasAddon()
	
	self:Update()
	self:InitializeUI()
	
	CHAT_SYSTEM:AddMessage(self.name .. " Addon Loaded.")
	CHAT_SYSTEM:AddMessage("Use /im help for an overview")
	
end

function InventoryManager:Save()
	self.charVariables.settings		= self.settings
	self.charVariables.currentRules	= self.currentRuleset.rules
	self.charVariables.Profiles		= nil
	
	self.accVariables.Profiles 		= self.Profiles
	self.accVariables.currentRules	= nil
end

local function OnAddOnLoaded(eventCode, addonName)
	if addonName == InventoryManager.name then
		InventoryManager:Init()
	else
		InventoryManager.loadedAddons[addonName] = true
	end
end

local function OnPCCreated()
	RuleEdit:PopulateUI()
	ProfileEdit:PopulateUI()
	Settings:PopulateUI()
end

EVENT_MANAGER:RegisterForEvent(InventoryManager.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

SLASH_COMMANDS["/im"] = function(argv) InventoryManager:SlashCommand(argv) end

CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", OnPCCreated)
