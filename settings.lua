-- By D4KiR
local _, MissingPower = ...
local mp_settings = {}
function MissingPower:ToggleSettings()
	if mp_settings then
		if mp_settings:IsShown() then
			mp_settings:Hide()
		else
			mp_settings:Show()
		end
	end
end

function MissingPower:InitSetting()
	MIPOPC = MIPOPC or {}
	MissingPower:SetVersion(136048, "1.2.51")
	mp_settings = MissingPower:CreateWindow(
		{
			["name"] = "MissingPower",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("|T136048:16:16:0:0|t M|cff3FC7EBissing|rP|cff3FC7EBower|r v|cff3FC7EB%s", MissingPower:GetVersion())
		}
	)

	mp_settings.SF = CreateFrame("ScrollFrame", "mp_settings_SF", mp_settings, "UIPanelScrollFrameTemplate")
	mp_settings.SF:SetPoint("TOPLEFT", mp_settings, 8, -26)
	mp_settings.SF:SetPoint("BOTTOMRIGHT", mp_settings, -32, 8)
	mp_settings.SC = CreateFrame("Frame", "mp_settings_SC", mp_settings.SF)
	mp_settings.SC:SetSize(mp_settings.SF:GetSize())
	mp_settings.SC:SetPoint("TOPLEFT", mp_settings.SF, "TOPLEFT", 0, 0)
	mp_settings.SF:SetScrollChild(mp_settings.SC)
	local y = 0
	MissingPower:SetAppendY(y)
	MissingPower:SetAppendParent(mp_settings.SC)
	MissingPower:SetAppendTab(MIPOPC)
	MissingPower:AppendCategory("GENERAL")
	MissingPower:AppendCheckbox(
		"MMBTN",
		MissingPower:GetWoWBuild() ~= "RETAIL",
		function(sel, checked)
			if checked then
				MissingPower:ShowMMBtn("MissingPower")
			else
				MissingPower:HideMMBtn("MissingPower")
			end
		end
	)

	MissingPower:AppendCategory("POWERCOST")
	MissingPower:AppendCheckbox(
		"hideoverlap",
		true,
		function()
			MissingPower:UpdateUi("hideoverlap")
		end
	)

	MissingPower:AppendCheckbox(
		"showamountcounter",
		true,
		function()
			MissingPower:UpdateUi("showamountcounter")
		end
	)

	MissingPower:AppendSlider(
		"poweralpha",
		0.7,
		0.0,
		1.0,
		0.02,
		2,
		function()
			MissingPower:UpdateUi("poweralpha")
		end
	)

	MissingPower:AppendSlider(
		"displayiflowerthanx",
		10,
		0,
		99,
		1,
		0,
		function()
			MissingPower:UpdateUi("lowerthenx")
		end
	)

	MissingPower:AppendSlider(
		"decimals",
		1,
		0.0,
		2.0,
		1,
		0,
		function()
			MissingPower:UpdateUi("decimals")
		end
	)

	MissingPower:AppendSlider(
		"fontsize",
		12,
		6,
		16,
		1,
		0,
		function()
			MissingPower:UpdateUi("fontsize")
		end
	)

	MissingPower:AppendSlider(
		"fontanchor",
		0,
		0,
		8,
		1,
		0,
		function()
			MissingPower:UpdateUi("fontanchor")
		end
	)

	MissingPower:AppendSlider(
		"textoffsetx",
		1,
		-100,
		100,
		1,
		0,
		function()
			MissingPower:UpdateUi("x")
		end
	)

	MissingPower:AppendSlider(
		"textoffsety",
		1,
		-100,
		100,
		1,
		0,
		function()
			MissingPower:UpdateUi("y")
		end
	)

	MissingPower:AppendCheckbox(
		"customcolor",
		false,
		function()
			MissingPower:UpdateUi("customcolor")
		end
	)

	MissingPower:AppendColorPicker(
		"CMPCol",
		{
			["R"] = 1,
			["G"] = 1,
			["B"] = 1,
			["A"] = 1
		}, function() end, 5
	)

	if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
		MissingPower:AppendCategory("FIVESECONDRULE")
		MissingPower:AppendCheckbox(
			"showtickbar",
			true,
			function()
				MissingPower:UpdateUi("showtickbar")
			end
		)

		MissingPower:AppendColorPicker(
			"TickbarColor",
			{
				["R"] = 1,
				["G"] = 1,
				["B"] = 1,
				["A"] = 1
			}, function() end, 5
		)

		MissingPower:AppendCheckbox("showtickbarbg", true)
		MissingPower:AppendColorPicker(
			"TickbarBorderColor",
			{
				["R"] = 0,
				["G"] = 0,
				["B"] = 0,
				["A"] = 1
			}, function() end, 5
		)

		MissingPower:AppendCategory("HEALTHREGEN")
		MissingPower:AppendCheckbox(
			"showhealthreg",
			false,
			function()
				MissingPower:UpdateUi("showhealthreg")
			end
		)

		MissingPower:AppendCategory("ENERGYTICKS")
		MissingPower:AppendCheckbox("showenergyticks", true)
		MissingPower:AppendColorPicker(
			"EnergyTickbarColor",
			{
				["R"] = 1,
				["G"] = 1,
				["B"] = 1,
				["A"] = 1
			}, function() end, 5
		)

		MissingPower:AppendCheckbox("showenergyticksbg", true)
		MissingPower:AppendColorPicker(
			"EnergyTickbarBorderColor",
			{
				["R"] = 0,
				["G"] = 0,
				["B"] = 0,
				["A"] = 1
			}, function() end, 5
		)

		MissingPower:AppendCategory("SWINGTIMERS")
		MissingPower:AppendCheckbox("showswingtimer", false)
	end

	MissingPower:CreateMinimapButton(
		{
			["name"] = "MissingPower",
			["icon"] = 136048,
			["dbtab"] = MIPOPC,
			["vTT"] = {{"|T136048:16:16:0:0|t M|cff3FC7EBissing|rP|cff3FC7EBower|r", "v|cff3FC7EB" .. MissingPower:GetVersion()}, {MissingPower:Trans("LID_LEFTCLICK"), MissingPower:Trans("LID_OPENSETTINGS")}, {MissingPower:Trans("LID_RIGHTCLICK"), MissingPower:Trans("LID_HIDEMINIMAPBUTTON")}},
			["funcL"] = function()
				MissingPower:ToggleSettings()
			end,
			["funcR"] = function()
				MissingPower:SV(MIPOPC, "MMBTN", false)
				MissingPower:MSG("Minimap Button is now hidden.")
				MissingPower:HideMMBtn("MissingPower")
			end,
			["dbkey"] = "MMBTN"
		}
	)

	MissingPower:AddSlash("mp", MissingPower.ToggleSettings)
	MissingPower:AddSlash("MissingPower", MissingPower.ToggleSettings)
end
