-- By D4KiR
local _, MissingPower = ...
MissingPower.DEBUG = false
-- ### CONFIG START ### 
--
local CONFIG = {}
-- General 
-- Time for start setup
CONFIG.waittime = 2
-- Transparency Fade 
-- Minimum Transparency
CONFIG.min = 0.1
-- Maximum Transparency
CONFIG.max = 0.9
-- Transparency distance
CONFIG.dir = 0.1
-- Transparency tick
CONFIG.tick = 0.1
-- ActionBars 
local MIPOActionBars = {"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton", "MultiBarLeftButton", "MultiBarBottomLeftActionButton", "MultiBarBottomRightActionButton", "MultiBarRightActionButton", "MultiBarLeftActionButton", "StanceButton", "AB", "DominosActionButton", "BT4", "ElvUI_Bar1Button", "ElvUI_Bar2Button", "ElvUI_Bar3Button", "ElvUI_Bar4Button", "ElvUI_Bar5Button", "ElvUI_Bar6Button", "ElvUI_StanceBar", "ActionBar1", "ActionBar2", "ActionBar3", "ActionBar4", "ActionBar5", "ActionBar6", "ActionBar7", "ActionBar8", "ActionBar9", "ActionBar10", "MAActionBar1", "MAActionBar2", "MAActionBar3", "MAActionBar4", "MAActionBar5", "MAActionBar6", "MAActionBar7", "MAActionBar8", "MAActionBar9", "MAActionBar10", "MAIStance", "MultiBar1", "MultiBar2", "MultiBar3", "MultiBar4", "MultiBar5", "MultiBar6", "MultiBar7", "MultiBar8", "MultiBar9", "MultiBar10", "DragonflightUIMultiactionBar1Button", "DragonflightUIMultiactionBar2Button", "DragonflightUIMultiactionBar3Button", "DragonflightUIMultiactionBar4Button", "DragonflightUIMultiactionBar5Button", "DragonflightUIMultiactionBar6Button", "DragonflightUIMultiactionBar7Button", "DragonflightUIMultiactionBar8Button"}
-- ### CONFIG END ### 
-- Functions, do not change, write me! 
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
	local ActionButton_GetPagedID = getglobal("ActionButton_GetPagedID")
	local ActionButton_CalculateAction = getglobal("ActionButton_CalculateAction")
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
		OOMAmountCounter.text:SetFont(STANDARD_TEXT_FONT, tonumber(MissingPower:GetConfig("fontsize", 12)), "OUTLINE")
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

local hookedBtns = {}
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
						if hookedBtns[obtn] == nil then
							hookedBtns[obtn] = true
							hooksecurefunc(
								obtn,
								"SetID",
								function()
									obtn:ActionChanged()
								end
							)

							function obtn:ActionChanged()
								local actionType, actionID = GetActionInfo(obtn.id)
								if obtn.id ~= obtn:GetID() or obtn.actionType ~= actionType or obtn.actionID ~= actionID then
									obtn.id = obtn:GetID()
									obtn.actionType = actionType
									obtn.actionID = actionID
									MissingPower:UpdateUi("ID CHANGE")
								end
							end

							obtn:ActionChanged()
						end

						MissingPower:CreateOOM(obtn, NAME, i)
					end
				end
			end

			ready = true
			MissingPower:ShowOOM(nil, "SETUP")
		elseif ready then
			if UnitInVehicle and UnitInVehicle("PLAYER") then return end
			if MIPOUpdate then
				MIPOUpdate = false
				MIPOActionButtons = {}
				for btnname, ab in pairs(ActionButtons) do
					local ABTN = _G[ab.name]
					local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action)
					if id and at == "macro" and GetMacroSpell(id) then
						id = GetMacroSpell(id)
					end

					local name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
					if string.find(ab.name, "StanceButton") and not string.find(ab.name, "MAIStanceButton") and id ~= nil then
						_, _, _, id = GetShapeshiftFormInfo(ab.nr)
						name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
					end

					local cost = -1
					if name then
						local costs = MissingPower:GetSpellPowerCost(spellId)
						if costs ~= nil and costs[1] ~= nil and (at == "spell" or at == "macro") then
							local ptid = UnitPowerType("PLAYER")
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

			-- Read config once per ShowOOM call, not per button
			local fontsize = tonumber(MissingPower:GetConfig("fontsize", 12))
			if type(fontsize) ~= "number" then
				MissingPower:SV(MIPOPC, "fontsize", 12)
				fontsize = 12
			end

			if fontsize < 6 then
				MissingPower:SV(MIPOPC, "fontsize", 6)
				fontsize = 6
			end

			local showamountcounter = MissingPower:GetConfig("showamountcounter", true)
			local decimals = MissingPower:GetConfig("decimals", 1)
			local displayiflowerthanx = tonumber(MissingPower:GetConfig("displayiflowerthanx", 10))
			local anchor = MissingPower:GetAnchor(MissingPower:GetConfig("fontanchor", 0))
			local offsetX = MissingPower:GetConfig("textoffsetx", 0)
			local offsetY = MissingPower:GetConfig("textoffsety", 0)
			local poweralpha = MissingPower:GetConfig("poweralpha", 0.7)
			local hideoverlap = MissingPower:GetConfig("hideoverlap", true)
			local customcolor = MissingPower:GetConfig("customcolor", false)
			local baseRegen = GetPowerRegen and GetPowerRegen() or 20
			for btnname, ab in pairs(MIPOActionButtons) do
				local ABTN = _G[ab.name]
				local OOM = _G[btnname]
				local OOMAmountCounter = _G[btnname .. "AmountCounter"]
				OOM:Hide(true)
				if OOMAmountCounter.text.fs ~= fontsize then
					OOMAmountCounter.text.fs = fontsize
					OOMAmountCounter.text:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
				end

				local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action)
				if id and at == "macro" and GetMacroSpell(id) then
					id = GetMacroSpell(id)
				end

				local name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
				if string.find(ab.name, "StanceButton") and not string.find(ab.name, "MAIStanceButton") and id ~= nil then
					_, _, _, id = GetShapeshiftFormInfo(ab.nr)
					name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
				end

				local ph = 0
				local p = 0
				local cost = 0
				local typ = 0
				local regen = baseRegen
				local amount = 0
				if name then
					local costs = MissingPower:GetSpellPowerCost(spellId)
					if costs ~= nil and costs[1] ~= nil and (at == "spell" or at == "macro") then
						cost = costs[1].cost
						typ = costs[1].type
						for _, c in pairs(costs) do
							if c and UnitPower("player", c.type) > 0 and c.cost ~= 0 then
								cost = c.cost
								typ = c.type
							end
						end

						local r = 1.0
						local g = 1.0
						local b = 1.0
						local pbc = PowerBarColor[typ]
						if pbc ~= nil then
							r = MissingPower:MathC(pbc.r or r, 0.3, 1.0)
							g = MissingPower:MathC(pbc.g or g, 0.3, 1.0)
							b = MissingPower:MathC(pbc.b or b, 0.3, 1.0)
						end

						color.r = r
						color.g = g
						color.b = b
						local currentPower = UnitPower("player", typ)
						if cost > currentPower then
							p = currentPower / cost
						end

						amount = cost > 0 and (currentPower / cost) or 0
						if typ == Enum.PowerType.Mana then
							regen = baseRegen * 2
						elseif typ == Enum.PowerType.Rage or typ == Enum.PowerType.Focus then
							regen = baseRegen / -2
						end

						if OOM.texture ~= nil then
							if OOM.texture.SetColorTexture then
								OOM.texture:SetColorTexture(color.r, color.g, color.b)
							else
								OOM.texture:SetTexture(color.r, color.g, color.b)
							end

							if customcolor then
								OOMAmountCounter.text:SetTextColor(MissingPower:GetColor("CMPCol", "CMPCol"))
							else
								OOMAmountCounter.text:SetTextColor(color.r + 0.2, color.g + 0.2, color.b + 0.2)
							end
						end
					end
				end

				OOMAmountCounter:ClearAllPoints()
				OOMAmountCounter:SetPoint("CENTER", ABTN, "CENTER", 0, 0)
				OOMAmountCounter:Show(true)
				OOMAmountCounter:SetFrameStrata(ABTN:GetFrameStrata())
				if amount > 0 and at ~= nil and showamountcounter and (at == "spell" or at == "macro") then
					OOMAmountCounter:SetAlpha(1)
				else
					OOMAmountCounter:SetAlpha(0)
				end

				local amo
				if decimals == 0 or amount > 99 then
					amo = SpecialRound(amount, 0)
				else
					amo = tonumber(format("%." .. string.format("%.0f", decimals) .. "f", SpecialRound(amount, decimals))) or 0
				end

				if displayiflowerthanx > 0 then
					if amount < displayiflowerthanx then
						OOMAmountCounter.text:SetText(amo)
					else
						OOMAmountCounter.text:SetText("")
					end
				else
					OOMAmountCounter.text:SetText(amo)
				end

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
					OOM:SetAlpha(poweralpha)
					local h = ABTN:GetHeight()
					local y = h * p - h
					OOM:ClearAllPoints()
					OOM:SetPoint("TOPLEFT", ABTN, "TOPLEFT", 0, y)
					OOM:SetHeight(h * p)
					h = ABTN:GetHeight()
					ph = h / cost * regen
					y = y + ph
					if y > 0 and hideoverlap then
						ph = ph - y
						y = 0
					end
				end
			end
		end
	end
end

local power = -1
local mana = -1
local lastSF = 0
local lastMount = false
function MissingPower:Think()
	if lastSF ~= GetShapeshiftForm() then
		lastSF = GetShapeshiftForm()
		MissingPower:After(
			0.1,
			function()
				MissingPower:UpdateUi("SHAPESHIFT")
			end, "SHAPESHIFT"
		)
	end

	if IsMounted and lastMount ~= IsMounted() then
		lastMount = IsMounted()
		MissingPower:After(
			0.1,
			function()
				MissingPower:UpdateUi("MOUNTED")
			end, "MOUNTED"
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
end

MissingPower:Think()
local frame = CreateFrame("FRAME")
MissingPower:RegisterEvent(frame, "PLAYER_ENTERING_WORLD")
--MissingPower:RegisterEvent(frame,"UPDATE_SHAPESHIFT_FORM", "player") -- spams in tbc
MissingPower:RegisterEvent(frame, "SPELLS_CHANGED")
MissingPower:RegisterEvent(frame, "UNIT_SPELLCAST_START", "player")
--MissingPower:RegisterEvent(frame,"CURRENT_SPELL_CAST_CHANGED", "player")
MissingPower:RegisterEvent(frame, "ACTIONBAR_PAGE_CHANGED")
MissingPower:RegisterEvent(frame, "SPELL_UPDATE_USABLE")
MissingPower:RegisterEvent(frame, "MODIFIER_STATE_CHANGED")
--MissingPower:RegisterEvent(frame,"ACTIONBAR_SLOT_CHANGED", "player") -- SPAMS
MissingPower:RegisterEvent(frame, "PLAYER_GAINS_VEHICLE_DATA", "player")
local MPLoaded = false
hooksecurefunc(
	"PickupAction",
	function(id)
		MissingPower:After(
			0.01,
			function()
				MissingPower:UpdateUi("PickupAction")
			end, "PickupAction"
		)
	end
)

hooksecurefunc(
	"PlaceAction",
	function(id)
		MissingPower:After(
			0.01,
			function()
				MissingPower:UpdateUi("PlaceAction")
			end, "PlaceAction"
		)
	end
)

hooksecurefunc(
	"ClearCursor",
	function(id)
		MissingPower:After(
			0.01,
			function()
				MissingPower:UpdateUi("ClearCursor")
			end, "ClearCursor"
		)
	end
)

local function OnEvent(self, event, unit, powertype, ...)
	if event == "PLAYER_ENTERING_WORLD" and not MPLoaded then
		MissingPower:InitSetting()
		MPLoaded = true
		MissingPower:After(
			1,
			function()
				MissingPower:UpdateUi("PLAYER_ENTERING_WORLD", true)
			end, "PLAYER_ENTERING_WORLD"
		)
	elseif MPLoaded then
		if event == "ACTIONBAR_PAGE_CHANGED" or event == "SPELLS_CHANGED" then
			MissingPower:After(
				0.15,
				function()
					MissingPower:UpdateUi(event)
				end, "ACTIONBAR_PAGE_CHANGED"
			)
		else
			MissingPower:After(
				0.05,
				function()
					MissingPower:ShowOOM(nil, "ELSE: " .. event)
				end, "ACTIONBAR_PAGE_CHANGED"
			)
		end
	end
end

frame:SetScript("OnEvent", OnEvent)
local frame2 = CreateFrame("FRAME")
MissingPower:RegisterEvent(frame2, "UNIT_POWER_UPDATE", "player")
--MissingPower:RegisterEvent(frame2, "UNIT_POWER_FREQUENT", "player")
local function OnEvent2(self, event, unit, powertype, ...)
	if event == "UNIT_POWER_UPDATE" and unit == "player" and ready then
		MissingPower:ShowOOM(nil, "UNIT_POWER_UPDATE")
	end
end

frame2:SetScript("OnEvent", OnEvent2)
if false then
	MissingPower:After(
		1,
		function()
			MissingPower:SetDebug(true)
			MissingPower:DrawDebug(
				"MissingPower DrawDebug",
				function()
					local text = ""
					for i, v in pairs(MissingPower:GetCountAfter()) do
						if v > 100 then
							text = text .. i .. ": " .. v .. "\n"
						end
					end

					return text
				end, 14, 1440, 1440, "CENTER", UIParent, "CENTER", 400, 0
			)
		end, "DEBUG"
	)
end
