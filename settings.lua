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
	MissingPower:SetVersion(AddonName, 136048, "1.2.6")
	mp_settings = MissingPower:CreateFrame(
		{
			["name"] = "MissingPower",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("MissingPower |T136048:16:16:0:0|t v|cff3FC7EB%s", "1.2.6")
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
	MissingPower:AppendCheckbox("hideoverlap", true)
	MissingPower:AppendCheckbox("showamountcounter", true)
	MissingPower:AppendCheckbox("showtickbar", true)
	if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
		MissingPower:AppendCheckbox("showtickbar", true)
		MissingPower:AppendCheckbox("showhealthreg", false)
	end

	MissingPower:AppendSlider("poweralpha", 0.7, 0.0, 1.0, 0.02, 2)
	MissingPower:AppendSlider("displayiflowerthanx", 10, 0, 99, 1, 0)
	MissingPower:AppendCategory("TEXT")
	MissingPower:AppendSlider("decimals", 1, 0.0, 2.0, 1, 0)
	MissingPower:AppendSlider("fontsize", 0.7, 6, 16, 1, 0)
	MissingPower:AppendSlider("fontanchor", 0, 0, 8, 1, 0)
	MissingPower:AppendSlider("textoffsetx", 1, -100, 100, 1, 0)
	MissingPower:AppendSlider("textoffsety", 1, -100, 100, 1, 0)
	MissingPower:AppendCategory("COLORS")
	MissingPower:AppendCheckbox("customcolor", false)
	MissingPower:AppendSlider("ccolr", 0, 0, 1.0, 0.01, 2)
	MissingPower:AppendSlider("ccolg", 0, 0, 1.0, 0.01, 2)
	MissingPower:AppendSlider("ccolb", 0, 0, 1.0, 0.01, 2)
	MissingPower:CreateMinimapButton(
		{
			["name"] = "MissingPower",
			["icon"] = 136048,
			["dbtab"] = MIPOPC,
			["vTT"] = {{"MissingPower |T136048:16:16:0:0|t", "v|cff3FC7EB1.2.6"}, {"Leftclick", "Toggle Settings"}, {"Rightclick", "Hide Minimap Icon"}},
			["funcL"] = function()
				MissingPower:ToggleSettings()
			end,
			["funcSR"] = function()
				MissingPower:SV(MIPOPC, "MMBTN", false)
				MissingPower:MSG("Minimap Button is now hidden.")
				MissingPower:HideMMBtn("MissingPower")
			end,
		}
	)

	MissingPower:AddSlash("mp", MissingPower.ToggleSettings)
	MissingPower:AddSlash("MissingPower", MissingPower.ToggleSettings)
	if MissingPower:GV(MIPOPC, "MMBTN", true) then
		MissingPower:ShowMMBtn("MissingPower")
	else
		MissingPower:HideMMBtn("MissingPower")
	end
end
