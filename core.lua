-- By D4KiR
local _, MissingPower = ...
--[[ ### CONFIG START ### ]]
--
local CONFIG = {}
--[[ General ]]
--
-- Time for start setup
CONFIG.waittime = 2
--[[ Transparency Fade ]]
--
-- Minimum Transparency
CONFIG.min = 0.1
-- Maximum Transparency
CONFIG.max = 0.9
-- Transparency distance
CONFIG.dir = 0.1
-- Transparency tick
CONFIG.tick = 0.1
--[[ ActionBars ]]
--
local MIPOActionBars = {"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "StanceButton", "AB", "DominosActionButton", "BT4", "ElvUI_Bar1Button", "ElvUI_Bar2Button", "ElvUI_Bar3Button", "ElvUI_Bar4Button", "ElvUI_Bar5Button", "ElvUI_Bar6Button", "ElvUI_StanceBar", "ActionBar1", "ActionBar2", "ActionBar3", "ActionBar4", "ActionBar5", "ActionBar6", "ActionBar7", "ActionBar8", "ActionBar9", "ActionBar10", "MAActionBar1", "MAActionBar2", "MAActionBar3", "MAActionBar4", "MAActionBar5", "MAActionBar6", "MAActionBar7", "MAActionBar8", "MAActionBar9", "MAActionBar10", "MAIStance"}
--[[ ### CONFIG END ### ]]
--
--[[ Functions, do not change, write me! ]]
--
local setup = true
local ready = false
local ActionButtons = {}
local MIPOActionButtons = {}
local color = {}
color.r = 0.3
color.g = 0.3
color.b = 1.0
color.a = 1
function MissingPower:GetActionFromButton(button, action)
	if strfind(button:GetName(), "MAI") then
		local id = button.sbsid or button.spellid
		local at = "spell"

		return id, at
	end

	local abslot = nil
	if ActionButton_GetPagedID and ActionButton_CalculateAction then
		abslot = action or button.action or button:GetAttribute("action") or ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or 0
	else
		abslot = action or button.action or button:GetAttribute("action") or 0
	end

	if abslot ~= nil then
		local at, id, _
		if type(abslot) == "number" and HasAction(abslot) then
			at, id, _ = GetActionInfo(abslot)

			return id, at
		end

		if button.GetAction then
			at, id = button:GetAction()
		end

		if button.GetID then
			id = button:GetID()
		end

		return id, at
	else
		return
	end
end

local loaded = false
function MissingPower:CreateOOM(obtn, name, nr)
	local BTNNAME = name .. "OOM"
	if _G[BTNNAME] == nil then
		-- OOM
		_G[BTNNAME] = CreateFrame("FRAME", BTNNAME, obtn)
		local OOM = _G[BTNNAME]
		OOM:SetWidth(obtn:GetWidth())
		OOM:SetHeight(obtn:GetHeight())
		OOM:ClearAllPoints()
		OOM:SetPoint("TOPLEFT", obtn, "TOPLEFT", 0, -obtn:GetHeight())
		OOM.texture = OOM:CreateTexture("OOM.texture", "ARTWORK")
		if OOM.texture.SetColorTexture then
			OOM.texture:SetColorTexture(color.r, color.g, color.b, color.a)
		else
			OOM.texture:SetTexture(color.r, color.g, color.b, color.a)
		end

		OOM.texture:SetAllPoints(OOM)
		OOM:SetFrameStrata("BACKGROUND")
		OOM.OldHide = OOM.OldHide or OOM.Hide
		OOM.Hide = function(sel, forced)
			if forced == true then
				sel:SetAlpha(0)
			end
		end

		OOM.OldShow = OOM.OldShow or OOM.Show
		OOM.Show = function(sel, forced)
			if forced == true then
				sel:SetAlpha(MissingPower:GetConfig("poweralpha", 0.7))
			end
		end

		-- AmountCounter
		local BTNNAMEAMOUNTCOUNTER = BTNNAME .. "AmountCounter"
		_G[BTNNAMEAMOUNTCOUNTER] = CreateFrame("FRAME", BTNNAMEAMOUNTCOUNTER, obtn)
		local OOMAmountCounter = _G[BTNNAMEAMOUNTCOUNTER]
		OOMAmountCounter:SetWidth(obtn:GetWidth())
		OOMAmountCounter:SetHeight(obtn:GetHeight())
		OOMAmountCounter:ClearAllPoints()
		OOMAmountCounter:SetPoint("CENTER", obtn, "CENTER", 0, 0)
		OOMAmountCounter.text = OOMAmountCounter:CreateFontString(nil, "ARTWORK")
		OOMAmountCounter.text:SetFont(STANDARD_TEXT_FONT, MissingPower:GetConfig("fontsize", 12), "OUTLINE")
		OOMAmountCounter.text:SetText("")
		OOMAmountCounter.text:SetTextColor(1, 1, 1, 0.9)
		OOMAmountCounter.text:SetPoint("CENTER", obtn, "CENTER", 0, 0)
		OOMAmountCounter:SetFrameStrata("BACKGROUND")
		OOMAmountCounter.OldHide = OOMAmountCounter.OldHide or OOMAmountCounter.Hide
		OOMAmountCounter.Hide = function(sel, forced)
			if forced == true then
				sel:SetAlpha(0)
			end
		end

		OOMAmountCounter.OldShow = OOMAmountCounter.OldShow or OOMAmountCounter.Show
		OOMAmountCounter.Show = function(sel, forced)
			if forced == true then
				sel:SetAlpha(0.9)
			end
		end

		OOMAmountCounter:Show(true)
		OOM:Hide(true)
		OOMAmountCounter:Hide(true)
	end

	if ActionButtons[BTNNAME] == nil then
		ActionButtons[BTNNAME] = {}
		ActionButtons[BTNNAME].name = name
		ActionButtons[BTNNAME].btn = _G[BTNNAME]
		ActionButtons[BTNNAME].nr = nr
	end
end

local function SpecialRound(number, decimalPlaces)
	local multiplier = 10 ^ decimalPlaces

	return math.floor(number * multiplier) / multiplier
end

local MIPOUpdate = true
function MissingPower:UpdateUi(from, init)
	MIPOUpdate = true -- Update
	MissingPower:ShowOOM(init, from)
end

local anchorTab = {
	[0] = "CENTER",
	[1] = "TOPLEFT",
	[2] = "TOP",
	[3] = "TOPRIGHT",
	[4] = "RIGHT",
	[5] = "BOTTOMRIGHT",
	[6] = "BOTTOM",
	[7] = "BOTTOMLEFT",
	[8] = "LEFT",
}

function MissingPower:GetAnchorTab()
	return anchorTab
end

function MissingPower:GetAnchor(id)
	return anchorTab[id]
end

function MissingPower:HideOOM(btnname, from)
	local OOM = _G[btnname]
	OOM:SetHeight(0.1)
	OOM:Hide(true)
	OOM:SetFrameStrata("BACKGROUND")
	OOM:SetAlpha(0)
end

local offsets = {
	["TOPLEFT"] = {-1, 1},
	["TOP"] = {0, 1},
	["TOPRIGHT"] = {1, 1},
	["RIGHT"] = {1, 0},
	["BOTTOMRIGHT"] = {1, -1},
	["BOTTOM"] = {0, -1},
	["BOTTOMLEFT"] = {-1, -1},
	["LEFT"] = {-1, 0},
	["CENTER"] = {0, 1},
}

function MissingPower:GetOffsetXY(anchor, offset, sw, sh)
	local tab = offsets[anchor]
	local x = tab[1] * offset * sw / 100
	local y = tab[2] * offset * sh / 100

	return x, y
end

function MissingPower:GetSpellPowerCost(spellId)
	if spellId == nil then return nil end
	local GetSpellPowerCost = GetSpellPowerCost or C_Spell and C_Spell.GetSpellPowerCost

	return GetSpellPowerCost(spellId)
end

function MissingPower:ShowOOM(init, from)
	if init then
		loaded = true
	end

	if loaded then
		if setup then
			setup = false
			for _, ab in pairs(MIPOActionBars) do
				for i = 1, 120 do
					local NAME = ab .. i
					local obtn = _G[NAME]
					if obtn == nil then
						NAME = ab .. "Button" .. i
						obtn = _G[NAME]
					end

					if obtn ~= nil then
						obtn.id = obtn:GetID()
						local atype, aid = GetActionInfo(obtn.id)
						obtn.actionType = atype
						obtn.actionID = aid
						function obtn:ActionChanged()
							local actionType, actionID = GetActionInfo(obtn.id)
							if obtn.id ~= obtn:GetID() or obtn.actionType ~= actionType or obtn.actionID ~= actionID then
								obtn.id = obtn:GetID()
								obtn.actionType = actionType
								obtn.actionID = actionID
								MissingPower:UpdateUi("ID CHANGE")
							end

							C_Timer.After(0.1, obtn.ActionChanged)
						end

						obtn.ActionChanged()
						MissingPower:CreateOOM(obtn, NAME, i)
					end
				end
			end

			ready = true
			MissingPower:InitSetting()
			MissingPower:ShowOOM(nil, "SETUP")
		elseif ready then
			if UnitInVehicle and UnitInVehicle("PLAYER") then return end
			if MIPOUpdate then
				MIPOUpdate = false
				MIPOActionButtons = {} -- new table
				for btnname, ab in pairs(ActionButtons) do
					local ABTN = _G[ab.name]
					local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action)
					local name = nil
					local spellId = nil
					if at == "macro" and GetMacroSpell(id) then
						id = GetMacroSpell(id)
					end

					name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
					if string.find(ab.name, "StanceButton") and not string.find(ab.name, "MAIStanceButton") and id ~= nil then
						_, _, _, id = GetShapeshiftFormInfo(ab.nr)
						name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
					end

					local cost = -1
					if name then
						local costs = MissingPower:GetSpellPowerCost(spellId)
						if costs ~= nil and costs[1] ~= nil and (at == "spell" or at == "macro") then
							local ptid, _ = UnitPowerType("PLAYER")
							cost = costs[1].cost
							if costs[2] ~= nil and costs[2].type == ptid and costs[2].cost ~= 0 then
								cost = costs[2].cost
							end

							if costs[3] ~= nil and costs[3].type == ptid and costs[3].cost ~= 0 then
								cost = costs[3].cost
							end
						end
					end

					if cost >= 0 then
						MIPOActionButtons[btnname] = ActionButtons[btnname]
					else
						MissingPower:HideOOM(btnname, "No Costs")
						local OOMAmountCounter = _G[btnname .. "AmountCounter"]
						if OOMAmountCounter and OOMAmountCounter.text then
							OOMAmountCounter.text:SetText("")
						end
					end
				end
			end

			for btnname, ab in pairs(MIPOActionButtons) do
				local ABTN = _G[ab.name]
				--local layer, sublevel = _G[ab.name .. "Icon"]:GetDrawLayer()
				local OOM = _G[btnname]
				local OOMAmountCounter = _G[btnname .. "AmountCounter"]
				OOM:Hide(true)
				if OOMAmountCounter.text.fs ~= MissingPower:GetConfig("fontsize", 12) then
					OOMAmountCounter.text.fs = MissingPower:GetConfig("fontsize", 12)
					OOMAmountCounter.text:SetFont(STANDARD_TEXT_FONT, MissingPower:GetConfig("fontsize", 12), "OUTLINE")
				end

				local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action)
				local name = nil
				local spellId = nil
				if at == "macro" and GetMacroSpell(id) then
					id = GetMacroSpell(id)
				end

				name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
				if string.find(ab.name, "StanceButton") and not string.find(ab.name, "MAIStanceButton") and id ~= nil then
					_, _, _, id = GetShapeshiftFormInfo(ab.nr)
					name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
				end

				local ph = 0
				local p = 0
				local cost = 0
				local typ = 0
				local regen = 0
				local amount = 0
				if name then
					local costs = MissingPower:GetSpellPowerCost(spellId)
					if costs ~= nil and costs[1] ~= nil and (at == "spell" or at == "macro") then
						cost = costs[1].cost
						typ = costs[1].type
						for i, c in pairs(costs) do
							if c and UnitPower("player", c.type) > 0 and c.cost ~= 0 then
								cost = c.cost
								typ = c.type
							end
						end

						-- COLOR
						local r = 1.0
						local g = 1.0
						local b = 1.0
						local pbc = PowerBarColor[typ]
						if pbc ~= nil then
							r = pbc.r or r
							g = pbc.g or g
							b = pbc.b or b
						end

						r = MissingPower:MathC(r, 0.3, 1.0)
						g = MissingPower:MathC(g, 0.3, 1.0)
						b = MissingPower:MathC(b, 0.3, 1.0)
						-- TYPES
						local mana = UnitPower("player", Enum.PowerType.Mana)
						local rage = UnitPower("player", Enum.PowerType.Rage)
						local ener = UnitPower("player", Enum.PowerType.Energy)
						local focu = UnitPower("player", Enum.PowerType.Focus)
						local rune = UnitPower("player", Enum.PowerType.RunicPower)
						local luna = UnitPower("player", Enum.PowerType.LunarPower)
						local pain = UnitPower("player", Enum.PowerType.Pain)
						local fury = UnitPower("player", Enum.PowerType.Fury)
						local mael = UnitPower("player", Enum.PowerType.Maelstrom)
						local insa = UnitPower("player", Enum.PowerType.Insanity)
						local holy = UnitPower("player", Enum.PowerType.HolyPower)
						--local chi = UnitPower("player", Enum.PowerType.Chi)
						local ess = UnitPower("player", Enum.PowerType.Essence)
						if typ == Enum.PowerType.Mana then
							color.r = r
							color.g = g
							color.b = b
							if cost > mana then
								p = mana / cost
							else
								p = 0
							end

							regen = GetPowerRegen() * 2
							if cost > 0 then
								amount = mana / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Rage then
							color.r = r
							color.g = g
							color.b = b
							if cost > rage then
								p = rage / cost
							else
								p = 0
							end

							regen = GetPowerRegen() / -2
							if cost > 0 then
								amount = rage / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Energy or typ == Enum.PowerType.ComboPoints then
							color.r = r
							color.g = g
							color.b = b
							if cost > ener then
								p = ener / cost
							else
								p = 0
							end

							if GetPowerRegen then
								regen = GetPowerRegen()
							else
								regen = 20
							end

							if cost > 0 then
								amount = ener / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Focus then
							color.r = r
							color.g = g
							color.b = b
							if cost > focu then
								p = focu / cost
							else
								p = 0
							end

							regen = GetPowerRegen() / -2
							if cost > 0 then
								amount = focu / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.RunicPower or typ == Enum.PowerType.Runic_Power then
							color.r = r
							color.g = g
							color.b = b
							if cost > rune then
								p = rune / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = rune / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.LunarPower then
							color.r = r
							color.g = g
							color.b = b
							if cost > luna then
								p = luna / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = luna / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Pain then
							color.r = r
							color.g = g
							color.b = b
							if cost > pain then
								p = pain / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = pain / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Fury then
							color.r = r
							color.g = g
							color.b = b
							if cost > fury then
								p = fury / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = fury / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Maelstrom then
							color.r = r
							color.g = g
							color.b = b
							if cost > mael then
								p = mael / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = mael / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.HolyPower then
							color.r = r
							color.g = g
							color.b = b
							if cost > holy then
								p = holy / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = holy / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Insanity then
							color.r = r
							color.g = g
							color.b = b
							if cost > insa then
								p = insa / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = insa / cost
							else
								amount = 0
							end
						elseif typ == Enum.PowerType.Essence then
							color.r = r
							color.g = g
							color.b = b
							if cost > ess then
								p = ess / cost
							else
								p = 0
							end

							regen = GetPowerRegen()
							if cost > 0 then
								amount = ess / cost
							else
								amount = 0
							end
						elseif typ > 0 and typ ~= 5 and typ ~= 7 and typ ~= 10 and typ ~= 12 and typ ~= 15 and typ ~= 16 and typ < 20 then
							local _, englishClass, _ = UnitClass("player")
							MissingPower:MSG("Send this to the Developer: [POWERTYP]: " .. typ .. " Class: " .. englishClass .. " WoW-Version: " .. tostring(MissingPower:GetWoWBuild()) .. " UnitPowerType: " .. UnitPowerType("PLAYER"))
							if Enum.PowerType[typ] then
								MissingPower:MSG(Enum.PowerType[typ])
							end
						end

						if OOM.texture ~= nil then
							if OOM.texture.SetColorTexture then
								OOM.texture:SetColorTexture(color.r, color.g, color.b)
							else
								OOM.texture:SetTexture(color.r, color.g, color.b)
							end

							if MissingPower:GetConfig("customcolor", false) then
								OOMAmountCounter.text:SetTextColor(MissingPower:GetConfig("ccolr", 0), MissingPower:GetConfig("ccolg", 0), MissingPower:GetConfig("ccolb", 0))
							else
								OOMAmountCounter.text:SetTextColor(color.r + 0.2, color.g + 0.2, color.b + 0.2)
							end
						end
					end

					OOMAmountCounter:ClearAllPoints()
					OOMAmountCounter:SetPoint("CENTER", ABTN, "CENTER", 0, 0)
					OOMAmountCounter:Show(true)
					OOMAmountCounter:SetFrameStrata(ABTN:GetFrameStrata())
					if amount > 0 and at ~= nil and MissingPower:GetConfig("showamountcounter", true) and (at == "spell" or at == "macro") then
						OOMAmountCounter:SetAlpha(1)
					else
						OOMAmountCounter:SetAlpha(0)
					end

					local decimals = MissingPower:GetConfig("decimals", 1)
					local amo = -1
					if decimals == 0 or amount > 99 then
						amo = SpecialRound(amount, 0)
					else
						amo = format("%." .. string.format("%.0f", decimals) .. "f", SpecialRound(amount, decimals))
					end

					if tonumber(MissingPower:GetConfig("displayiflowerthanx", 10)) > 0 then
						if amount < tonumber(MissingPower:GetConfig("displayiflowerthanx", 10)) then
							OOMAmountCounter.text:SetText(amo)
						else
							OOMAmountCounter.text:SetText("")
						end
					else
						OOMAmountCounter.text:SetText(amo)
					end

					local anchor = MissingPower:GetAnchor(MissingPower:GetConfig("fontanchor", 0))
					local offsetX = MissingPower:GetConfig("textoffsetx", 0)
					local offsetY = MissingPower:GetConfig("textoffsety", 0)
					--local offsetX, offsetY = MissingPower:GetOffsetXY(anchor, offset, ABTN:GetWidth(), ABTN:GetHeight())
					--local textAlignH = (anchor == "LEFT" or anchor == "TOPLEFT" or anchor == "BOTTOMLEFT") and "LEFT" or (anchor == "RIGHT" or anchor == "TOPRIGHT" or anchor == "BOTTOMRIGHT") and "RIGHT" or "CENTER"
					--local textAlignV = (anchor == "TOP" or anchor == "TOPLEFT" or anchor == "TOPRIGHT") and "TOP" or (anchor == "BOTTOM" or anchor == "BOTTOMLEFT" or anchor == "BOTTOMRIGHT") and "BOTTOM" or "CENTER"
					OOMAmountCounter.text:SetSize(OOM:GetWidth(), OOM:GetWidth())
					OOMAmountCounter.text:ClearAllPoints()
					OOMAmountCounter.text:SetPoint("CENTER", ABTN, anchor, offsetX, offsetY)
					if from == "Settings:fontanchor1" or from == "Settings:textoffset" then
						local oldText = OOMAmountCounter.text:GetText()
						OOMAmountCounter.text:SetText("TEST")
						OOMAmountCounter.text:SetText(oldText)
					end

					if p <= 0 then
						MissingPower:HideOOM(btnname, "No P")
					else
						OOM:Show(true)
						OOM:SetFrameStrata(ABTN:GetFrameStrata())
						OOM:SetAlpha(MissingPower:GetConfig("poweralpha", 0.7))
						local h = ABTN:GetHeight()
						local y = h * p - h
						OOM:ClearAllPoints()
						OOM:SetPoint("TOPLEFT", ABTN, "TOPLEFT", 0, y)
						OOM:SetHeight(h * p)
						h = ABTN:GetHeight()
						ph = h / cost * regen
						y = y + ph
						if y > 0 and MissingPower:GetConfig("hideoverlap", true) then
							ph = ph - y
							y = 0
						end
					end
				else
					MissingPower:HideOOM(btnname, "Invalid")
				end
			end
		end
	end
end

local power = -1
local mana = -1
local lastSF = 0
function MissingPower:Think()
	if lastSF ~= GetShapeshiftForm() then
		lastSF = GetShapeshiftForm()
		C_Timer.After(
			0.05,
			function()
				MissingPower:UpdateUi("SHAPESHIFT")
			end
		)
	end

	local enum = 0
	if Enum and Enum.PowerType and Enum.PowerType.Mana then
		enum = Enum.PowerType.Mana
	end

	if power ~= UnitPower("PLAYER") or mana ~= UnitPower("PLAYER", enum) then
		power = UnitPower("PLAYER")
		mana = UnitPower("PLAYER", enum)
		MissingPower:ShowOOM(nil, "Think")
	end

	C_Timer.After(0.1, MissingPower.Think)
end

MissingPower:Think()
local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
--frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM") -- spams in tbc
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("UNIT_SPELLCAST_START")
--frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
frame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
--frame:RegisterEvent("SPELL_UPDATE_USABLE")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
--frame:RegisterEvent("ACTIONBAR_SLOT_CHANGED") -- SPAMS
local MPLoaded = false
hooksecurefunc(
	"PickupAction",
	function(id)
		C_Timer.After(
			0.01,
			function()
				MissingPower:UpdateUi("PickupAction")
			end
		)
	end
)

hooksecurefunc(
	"PlaceAction",
	function(id)
		C_Timer.After(
			0.01,
			function()
				MissingPower:UpdateUi("PlaceAction")
			end
		)
	end
)

hooksecurefunc(
	"ClearCursor",
	function(id)
		C_Timer.After(
			0.01,
			function()
				MissingPower:UpdateUi("ClearCursor")
			end
		)
	end
)

local function OnEvent(self, event, unit, powertype, ...)
	if event == "PLAYER_ENTERING_WORLD" and not MPLoaded then
		MPLoaded = true
		C_Timer.After(
			1,
			function()
				MissingPower:UpdateUi("PLAYER_ENTERING_WORLD", true)
			end
		)
	elseif MPLoaded then
		if event == "ACTIONBAR_PAGE_CHANGED" then
			C_Timer.After(
				0.05,
				function()
					MissingPower:UpdateUi("ACTIONBAR_PAGE_CHANGED")
				end
			)
		else
			C_Timer.After(
				0.05,
				function()
					MissingPower:ShowOOM(nil, "ELSE: " .. event)
				end
			)
		end
	end
end

frame:SetScript("OnEvent", OnEvent)
local frame2 = CreateFrame("FRAME")
frame2:RegisterEvent("UNIT_POWER_UPDATE")
--frame2:RegisterEvent("UNIT_POWER_FREQUENT")
local function OnEvent2(self, event, unit, powertype, ...)
	if event == "UNIT_POWER_UPDATE" and unit == "player" and ready then
		MissingPower:ShowOOM(nil, "UNIT_POWER_UPDATE")
	end
end

frame2:SetScript("OnEvent", OnEvent2)
