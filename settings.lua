-- By D4KiR
local AddonName, MissingPower = ...
local MIPOSettings = {}
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
	MissingPower:SetVersion(AddonName, 136048, "1.2.18")
	mp_settings = MissingPower:CreateFrame(
		{
			["name"] = "MissingPower",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("MissingPower |T136048:16:16:0:0|t v|cff3FC7EB%s", "1.2.18")
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
		true,
		function(sel, checked)
			if checked then
				MissingPower:ShowMMBtn("MissingPower")
			else
				MissingPower:HideMMBtn("MissingPower")
			end
		end
	)

	MissingPower:AppendCategory("DESIGN")
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

	if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
		MissingPower:AppendCheckbox(
			"showtickbar",
			true,
			function()
				MissingPower:UpdateUi("showtickbar")
			end
		)

		MissingPower:AppendCheckbox(
			"showhealthreg",
			false,
			function()
				MissingPower:UpdateUi("showhealthreg")
			end
		)
	end

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

	MissingPower:AppendCategory("TEXT")
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

	MissingPower:AppendCategory("COLORS")
	MissingPower:AppendCheckbox(
		"customcolor",
		false,
		function()
			MissingPower:UpdateUi("customcolor")
		end
	)

	MissingPower:AppendSlider(
		"ccolr",
		1,
		0,
		1.0,
		0.01,
		2,
		function()
			MissingPower:UpdateUi("r")
		end
	)

	MissingPower:AppendSlider(
		"ccolg",
		1,
		0,
		1.0,
		0.01,
		2,
		function()
			MissingPower:UpdateUi("g")
		end
	)

	MissingPower:AppendSlider(
		"ccolb",
		1,
		0,
		1.0,
		0.01,
		2,
		function()
			MissingPower:UpdateUi("b")
		end
	)

	MissingPower:CreateMinimapButton(
		{
			["name"] = "MissingPower",
			["icon"] = 136048,
			["dbtab"] = MIPOPC,
			["vTT"] = {{"MissingPower |T136048:16:16:0:0|t", "v|cff3FC7EB1.2.18"}, {"Leftclick", "Toggle Settings"}, {"Rightclick", "Hide Minimap Icon"}},
			["funcL"] = function()
				MissingPower:ToggleSettings()
			end,
			["funcR"] = function()
				MissingPower:SV(MIPOPC, "MMBTN", false)
				MissingPower:MSG("Minimap Button is now hidden.")
				MissingPower:HideMMBtn("MissingPower")
			end,
		}
	)

	if MissingPower:GV(MIPOPC, "MMBTN", true) then
		MissingPower:ShowMMBtn("MissingPower")
	else
		MissingPower:HideMMBtn("MissingPower")
	end

	MissingPower:AddSlash("mp", MissingPower.ToggleSettings)
	MissingPower:AddSlash("MissingPower", MissingPower.ToggleSettings)
end
