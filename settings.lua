-- By D4KiR
local _, MissingPower = ...
local mpset = nil
local DEFAULT_WIDTH = 520
local DEFAULT_HEIGHT = 520
function MissingPower:ToggleSettings()
	if mpset == nil then return end
	mpset:Toggle()
end

local function GetCollapsed(key)
	if key == nil then return nil end
	if type(MIPOPC) ~= "table" then return nil end
	if type(MIPOPC["COLLAPSED"]) ~= "table" then return nil end
	return MIPOPC["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(MIPOPC) ~= "table" then return end
	if type(MIPOPC["COLLAPSED"]) ~= "table" then MIPOPC["COLLAPSED"] = {} end
	if collapsed then
		MIPOPC["COLLAPSED"][key] = true
	else
		MIPOPC["COLLAPSED"][key] = nil
	end
end

local function AddCategory(key, level)
	mpset:AddCategory({
		["label"] = "LID_" .. key,
		["key"] = key,
		["search"] = key,
		["level"] = level
	})
end

local function AddCheckbox(key, default, func)
	mpset:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = MissingPower:GetConfig(key, default),
		["func"] = function(value)
			MissingPower:SV(MIPOPC, key, value)
			if func then func() end
		end
	})
end

local function AddSlider(key, default, min, max, step, decimals, func)
	mpset:AddSlider({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = MissingPower:GetConfig(key, default),
		["min"] = min,
		["max"] = max,
		["step"] = step,
		["decimals"] = decimals,
		["func"] = function(value)
			MissingPower:SV(MIPOPC, key, value)
			if func then func() end
		end
	})
end

local function AddDropdown(key, default, choices, func)
	mpset:AddDropdown({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = MissingPower:GetConfig(key, default),
		["choices"] = choices,
		["func"] = function(value)
			MissingPower:SV(MIPOPC, key, value)
			if func then func() end
		end
	})
end

local function AnchorChoices()
	local choices = {}
	local anchors = MissingPower:GetAnchorTab()
	for id = 0, 8 do
		if anchors[id] then
			tinsert(choices, {
				["value"] = id,
				["label"] = "LID_" .. anchors[id]
			})
		end
	end
	return choices
end

local function AddColorPicker(key, default, func)
	if MIPOPC[key .. "_R"] == nil then MissingPower:SetColor(key, default.R, default.G, default.B, default.A) end
	local r, g, b, a = MissingPower:GetColor(key, "AddColorPicker")
	mpset:AddColorPicker({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = {
			["r"] = r,
			["g"] = g,
			["b"] = b,
			["a"] = a
		},
		["func"] = function(newR, newG, newB, newA)
			MissingPower:SetColor(key, newR, newG, newB, newA)
			if func then func() end
		end
	})
end

function MissingPower:InitSetting()
	MIPOPC = MIPOPC or {}
	MissingPower:SetVersion(136048, "1.3.2")
	MissingPower:SetAppendTab(MIPOPC)
	mpset = MissingPower:CreateUIWindow({
		["name"] = "MissingPowerSettings",
		["pTab"] = {"CENTER"},
		["width"] = MissingPower:GetConfig("WINDOWWIDTH", DEFAULT_WIDTH),
		["height"] = MissingPower:GetConfig("WINDOWHEIGHT", DEFAULT_HEIGHT),
		["minWidth"] = 360,
		["minHeight"] = 240,
		["onResize"] = function(width, height)
			MissingPower:SV(MIPOPC, "WINDOWWIDTH", width)
			MissingPower:SV(MIPOPC, "WINDOWHEIGHT", height)
		end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["title"] = format("|T136048:16:16:0:0|t Missing|rPower|r v%s", MissingPower:GetVersion())
	})

	mpset:SuspendLayout()
	mpset:AddSearch()
	AddCategory("GENERAL")
	AddCheckbox("MMBTN", MissingPower:GetWoWBuild() ~= "RETAIL", function()
		if MIPOPC["MMBTN"] then
			MissingPower:ShowMMBtn("MissingPower")
		else
			MissingPower:HideMMBtn("MissingPower")
		end
	end)

	AddCategory("POWERCOST")
	AddCheckbox("showamountcounter", true, function() MissingPower:UpdateUi("showamountcounter") end)
	AddCheckbox("hideoverlap", true, function() MissingPower:UpdateUi("hideoverlap") end)
	AddSlider("displayiflowerthanx", 10, 0, 99, 1, 0, function() MissingPower:UpdateUi("lowerthenx") end)
	AddSlider("poweralpha", 0.7, 0.0, 1.0, 0.02, 2, function() MissingPower:UpdateUi("poweralpha") end)
	AddCategory("TEXT", 2)
	AddSlider("fontsize", 12, 6, 16, 1, 0, function() MissingPower:UpdateUi("fontsize") end)
	AddSlider("decimals", 1, 0.0, 2.0, 1, 0, function() MissingPower:UpdateUi("decimals") end)
	MissingPower:SV(MIPOPC, "fontanchor", tonumber(MissingPower:GetConfig("fontanchor", 0)) or 0)
	AddDropdown("fontanchor", 0, AnchorChoices(), function() MissingPower:UpdateUi("fontanchor") end)
	AddSlider("textoffsetx", 1, -100, 100, 1, 0, function() MissingPower:UpdateUi("x") end)
	AddSlider("textoffsety", 1, -100, 100, 1, 0, function() MissingPower:UpdateUi("y") end)
	AddCategory("COLORS", 2)
	AddCheckbox("customcolor", false, function() MissingPower:UpdateUi("customcolor") end)
	AddColorPicker("CMPCol", {
		["R"] = 1,
		["G"] = 1,
		["B"] = 1,
		["A"] = 1
	}, function() MissingPower:UpdateUi("CMPCol") end)

	if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
		AddCategory("REGENERATION")
		AddCategory("FIVESECONDRULE", 2)
		AddCheckbox("showtickbar", true, function() MissingPower:UpdateUi("showtickbar") end)
		AddCheckbox("showtickbarbg", true)
		AddColorPicker("TickbarColor", {
			["R"] = 1,
			["G"] = 1,
			["B"] = 1,
			["A"] = 1
		})

		AddColorPicker("TickbarBorderColor", {
			["R"] = 0,
			["G"] = 0,
			["B"] = 0,
			["A"] = 1
		})

		AddCategory("ENERGYTICKS", 2)
		AddCheckbox("showenergyticks", true)
		AddCheckbox("showenergyticksbg", true)
		AddColorPicker("EnergyTickbarColor", {
			["R"] = 1,
			["G"] = 1,
			["B"] = 1,
			["A"] = 1
		})

		AddColorPicker("EnergyTickbarBorderColor", {
			["R"] = 0,
			["G"] = 0,
			["B"] = 0,
			["A"] = 1
		})

		AddCategory("HEALTHREGEN", 2)
		AddCheckbox("showhealthreg", false, function() MissingPower:UpdateUi("showhealthreg") end)
		AddCategory("SWINGTIMERS")
		AddCheckbox("showswingtimer", false)
	end

	mpset:ResumeLayout()
	MissingPower:CreateMinimapButton({
		["name"] = "MissingPower",
		["icon"] = 136048,
		["dbtab"] = MIPOPC,
		["vTT"] = {{"|T136048:16:16:0:0|t Missing|rPower|r", "v" .. MissingPower:GetVersion()}, {MissingPower:Trans("LID_LEFTCLICK"), MissingPower:Trans("LID_OPENSETTINGS")}, {MissingPower:Trans("LID_RIGHTCLICK"), MissingPower:Trans("LID_HIDEMINIMAPBUTTON")}},
		["funcL"] = function() MissingPower:ToggleSettings() end,
		["funcR"] = function()
			MissingPower:SV(MIPOPC, "MMBTN", false)
			MissingPower:MSG("Minimap Button is now hidden.")
			MissingPower:HideMMBtn("MissingPower")
		end,
		["dbkey"] = "MMBTN"
	})

	MissingPower:AddSlash("mp", MissingPower.ToggleSettings)
	MissingPower:AddSlash("MissingPower", MissingPower.ToggleSettings)
end
