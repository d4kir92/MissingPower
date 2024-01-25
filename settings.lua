-- By D4KiR
local AddonName, MissingPower = ...
local BuildNr = select(4, GetBuildInfo())
local Build = "CLASSIC"
if BuildNr >= 100000 then
	Build = "RETAIL"
elseif BuildNr > 29999 then
	Build = "WRATH"
elseif BuildNr > 19999 then
	Build = "TBC"
end

function MissingPower:GetWoWBuildNr()
	return BuildNr
end

function MissingPower:GetWoWBuild()
	return Build
end

local MIPOSettings = {}
function MissingPower:InitSetting()
	D4:SetVersion(AddonName, 136048, "1.1.25")
	local settingname = "MissingPower |T136048:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t"
	MIPOSettings.panel = CreateFrame("Frame", settingname, UIParent)
	MIPOSettings.panel.name = settingname
	local Y = -14
	local H = 16
	local BR = 34
	local settings_header = {}
	settings_header.frame = MIPOSettings.panel
	settings_header.parent = MIPOSettings.panel
	settings_header.x = 10
	settings_header.y = Y
	settings_header.text = settingname
	settings_header.textsize = 24
	MissingPower:CreateText(settings_header)
	Y = Y - BR
	local settings_showoverlap = {}
	settings_showoverlap.name = "hideoverlap"
	settings_showoverlap.parent = MIPOSettings.panel
	settings_showoverlap.checked = MissingPower:GetConfig("hideoverlap", true)
	settings_showoverlap.text = "hideoverlap"
	settings_showoverlap.x = 10
	settings_showoverlap.y = Y
	settings_showoverlap.dbvalue = "hideoverlap"
	MissingPower:CreateCheckBox(settings_showoverlap)
	Y = Y - H
	local settings_showamountcounter = {}
	settings_showamountcounter.name = "showamountcounter"
	settings_showamountcounter.parent = MIPOSettings.panel
	settings_showamountcounter.checked = MissingPower:GetConfig("showamountcounter", true)
	settings_showamountcounter.text = "showamountcounter"
	settings_showamountcounter.x = 10
	settings_showamountcounter.y = Y
	settings_showamountcounter.dbvalue = "showamountcounter"
	MissingPower:CreateCheckBox(settings_showamountcounter)
	Y = Y - BR
	local settings_poweralpha = {}
	settings_poweralpha.name = "poweralpha"
	settings_poweralpha.parent = MIPOSettings.panel
	settings_poweralpha.value = MissingPower:GetConfig("poweralpha", 0.7)
	settings_poweralpha.text = "poweralpha"
	settings_poweralpha.x = 10
	settings_poweralpha.y = Y
	settings_poweralpha.min = 0.0
	settings_poweralpha.max = 1.0
	settings_poweralpha.decimals = 2
	settings_poweralpha.steps = 0.02
	settings_poweralpha.dbvalue = "poweralpha"
	MissingPower:OldCreateSlider(settings_poweralpha)
	Y = Y - BR
	local settings_decimals = {}
	settings_decimals.name = "decimals"
	settings_decimals.parent = MIPOSettings.panel
	settings_decimals.value = MissingPower:GetConfig("decimals", 1)
	settings_decimals.text = "decimals"
	settings_decimals.x = 10
	settings_decimals.y = Y
	settings_decimals.min = 0
	settings_decimals.max = 2
	settings_decimals.decimals = 0
	settings_decimals.steps = 1
	settings_decimals.dbvalue = "decimals"
	MissingPower:OldCreateSlider(settings_decimals)
	Y = Y - BR
	local settings_fontsize = {}
	settings_fontsize.name = "fontsize"
	settings_fontsize.parent = MIPOSettings.panel
	settings_fontsize.value = MissingPower:GetConfig("fontsize", 10)
	settings_fontsize.text = "fontsize"
	settings_fontsize.x = 10
	settings_fontsize.y = Y
	settings_fontsize.min = 6
	settings_fontsize.max = 16
	settings_fontsize.decimals = 0
	settings_fontsize.steps = 1
	settings_fontsize.dbvalue = "fontsize"
	MissingPower:OldCreateSlider(settings_fontsize)
	Y = Y - BR
	MissingPower:CreateSlider(
		MIPOSettings.panel,
		10,
		Y,
		"fontanchor",
		"fontanchor",
		MissingPower:GetConfig("fontanchor", 0),
		1,
		0,
		8,
		function()
			C_Timer.After(
				0.01,
				function()
					MissingPower:UpdateUi("Settings:fontanchor1")
				end
			)
		end, MissingPower:GetAnchorTab()
	)

	Y = Y - BR
	MissingPower:CreateSlider(
		MIPOSettings.panel,
		10,
		Y,
		"textoffsetX",
		"textoffsetX",
		MissingPower:GetConfig("textoffsetX", 0),
		1.0,
		-100,
		100,
		function()
			C_Timer.After(
				0.01,
				function()
					MissingPower:UpdateUi("Settings:textoffsetX")
				end
			)
		end
	)

	Y = Y - BR
	MissingPower:CreateSlider(
		MIPOSettings.panel,
		10,
		Y,
		"textoffsetY",
		"textoffsetY",
		MissingPower:GetConfig("textoffsetY", 0),
		1.0,
		-100,
		100,
		function()
			C_Timer.After(
				0.01,
				function()
					MissingPower:UpdateUi("Settings:textoffsetY")
				end
			)
		end
	)

	Y = Y - BR
	if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
		local settings_showtickbar = {}
		settings_showtickbar.name = "showtickbar"
		settings_showtickbar.parent = MIPOSettings.panel
		settings_showtickbar.checked = MissingPower:GetConfig("showtickbar", true)
		settings_showtickbar.text = "showtickbar"
		settings_showtickbar.x = 10
		settings_showtickbar.y = Y
		settings_showtickbar.dbvalue = "showtickbar"
		MissingPower:CreateCheckBox(settings_showtickbar)
		Y = Y - BR
		local settings_showhealthreg = {}
		settings_showhealthreg.name = "showhealthreg"
		settings_showhealthreg.parent = MIPOSettings.panel
		settings_showhealthreg.checked = MissingPower:GetConfig("showhealthreg", false)
		settings_showhealthreg.text = "showhealthreg"
		settings_showhealthreg.x = 10
		settings_showhealthreg.y = Y
		settings_showhealthreg.dbvalue = "showhealthreg"
		MissingPower:CreateCheckBox(settings_showhealthreg)
		Y = Y - BR
	end

	local settings_customcolor = {}
	settings_customcolor.name = "customcolor"
	settings_customcolor.parent = MIPOSettings.panel
	settings_customcolor.checked = MissingPower:GetConfig("customcolor", false)
	settings_customcolor.text = "customcolor"
	settings_customcolor.x = 10
	settings_customcolor.y = Y
	settings_customcolor.dbvalue = "customcolor"
	MissingPower:CreateCheckBox(settings_customcolor)
	Y = Y - BR
	local settings_ccolr = {}
	settings_ccolr.name = "ccolr"
	settings_ccolr.parent = MIPOSettings.panel
	settings_ccolr.value = MissingPower:GetConfig("ccolr", 0)
	settings_ccolr.text = "ccolr"
	settings_ccolr.x = 10
	settings_ccolr.y = Y
	settings_ccolr.min = 0
	settings_ccolr.max = 1
	settings_ccolr.decimals = 2
	settings_ccolr.steps = 0.01
	settings_ccolr.dbvalue = "ccolr"
	MissingPower:OldCreateSlider(settings_ccolr)
	Y = Y - BR
	local settings_ccolg = {}
	settings_ccolg.name = "ccolg"
	settings_ccolg.parent = MIPOSettings.panel
	settings_ccolg.value = MissingPower:GetConfig("ccolg", 0)
	settings_ccolg.text = "ccolg"
	settings_ccolg.x = 10
	settings_ccolg.y = Y
	settings_ccolg.min = 0
	settings_ccolg.max = 1
	settings_ccolg.decimals = 2
	settings_ccolg.steps = 0.01
	settings_ccolg.dbvalue = "ccolg"
	MissingPower:OldCreateSlider(settings_ccolg)
	Y = Y - BR
	local settings_ccolb = {}
	settings_ccolb.name = "ccolb"
	settings_ccolb.parent = MIPOSettings.panel
	settings_ccolb.value = MissingPower:GetConfig("ccolb", 0)
	settings_ccolb.text = "ccolb"
	settings_ccolb.x = 10
	settings_ccolb.y = Y
	settings_ccolb.min = 0
	settings_ccolb.max = 1
	settings_ccolb.decimals = 2
	settings_ccolb.steps = 0.01
	settings_ccolb.dbvalue = "ccolb"
	MissingPower:OldCreateSlider(settings_ccolb)
	Y = Y - BR
	Y = Y - BR
	local settings_displayiflowerthanx = {}
	settings_displayiflowerthanx.name = "displayiflowerthanx"
	settings_displayiflowerthanx.parent = MIPOSettings.panel
	settings_displayiflowerthanx.value = MissingPower:GetConfig("displayiflowerthanx", 10)
	settings_displayiflowerthanx.text = "displayiflowerthanx"
	settings_displayiflowerthanx.x = 10
	settings_displayiflowerthanx.y = Y
	settings_displayiflowerthanx.min = 0
	settings_displayiflowerthanx.max = 99
	settings_displayiflowerthanx.decimals = 0
	settings_displayiflowerthanx.steps = 1
	settings_displayiflowerthanx.dbvalue = "displayiflowerthanx"
	MissingPower:OldCreateSlider(settings_displayiflowerthanx, "   [0 = unlimited]")
	Y = Y - BR
	InterfaceOptions_AddCategory(MIPOSettings.panel)
end