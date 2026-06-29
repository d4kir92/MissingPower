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
local _ActionButton_GetPagedID = getglobal("ActionButton_GetPagedID")
local _ActionButton_CalculateAction = getglobal("ActionButton_CalculateAction")
function MissingPower:GetActionFromButton(button, action, isMAI)
	if isMAI then
		local id = button.sbsid or button.spellid
		local at = "spell"

		return id, at
	end

	local abslot = nil
	if _ActionButton_GetPagedID and _ActionButton_CalculateAction then
		abslot = action or button.action or button:GetAttribute("action") or _ActionButton_GetPagedID(button) or _ActionButton_CalculateAction(button) or 0
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
				sel:SetAlpha(0)
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
		ActionButtons[BTNNAME].isStance = string.find(name, "StanceButton") ~= nil and string.find(name, "MAIStanceButton") == nil
		ActionButtons[BTNNAME].isMAI = string.find(name, "MAI") ~= nil
		ActionButtons[BTNNAME].frameRef = obtn
		ActionButtons[BTNNAME].oomRef = _G[BTNNAME]
		ActionButtons[BTNNAME].counterRef = _G[BTNNAME .. "AmountCounter"]
	end
end

local _roundMult = {
	[0] = 1,
	[1] = 10,
	[2] = 100,
	[3] = 1000
}

local function SpecialRound(number, decimalPlaces)
	local multiplier = _roundMult[decimalPlaces] or (10 ^ decimalPlaces)

	return math.floor(number * multiplier) / multiplier
end

local MIPOUpdate = true
local pointsNeedReset = false
local powerCache = {}
local pendingRetry = {}
function MissingPower:UpdateUi(from, init)
	MIPOUpdate = true
	pointsNeedReset = true
	MissingPower:InvalidateConfigCache()
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
					local ABTN = ab.frameRef
					local btnSlot = ABTN._state_action or ABTN.action
					-- skip GetActionFromButton entirely if slot unchanged AND we already
					-- resolved a valid cost for it (avoid getting stuck on transient nil
					-- spell info right after a page switch / login)
					if btnSlot == ab._lastBtnSlot and ab.cachedCosts ~= nil then
						MIPOActionButtons[btnname] = ab
					else
						ab._lastBtnSlot = btnSlot
						local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action, ab.isMAI)
						if id and at == "macro" then
							local ms = GetMacroSpell(id)
							if ms then
								id = ms
							end
						end

						local resolvedId = id
						if ab.isStance and id ~= nil then
							_, _, _, resolvedId = GetShapeshiftFormInfo(ab.nr)
						end

						-- skip expensive GetSpellInfo/GetSpellPowerCost if spell unchanged
						if resolvedId == ab._lastResolvedId and at == ab._lastAt and ab.cachedCosts ~= nil then
							MIPOActionButtons[btnname] = ab
						else
							ab._lastResolvedId = resolvedId
							ab._lastAt = at
							local name, _, _, _, _, _, spellId
							if ab.isStance then
								name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(resolvedId)
							else
								name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
							end

							local hasCost = false
							local cachedCosts = nil
							local cachedR, cachedG, cachedB = 1.0, 1.0, 1.0
							if name and (at == "spell" or at == "macro") then
								local costs = MissingPower:GetSpellPowerCost(spellId)
								if costs ~= nil and costs[1] ~= nil then
									hasCost = true
									cachedCosts = costs
									local typ = costs[1].type
									local pbc = PowerBarColor[typ]
									if pbc ~= nil then
										cachedR = MissingPower:MathC(pbc.r or 1.0, 0.3, 1.0)
										cachedG = MissingPower:MathC(pbc.g or 1.0, 0.3, 1.0)
										cachedB = MissingPower:MathC(pbc.b or 1.0, 0.3, 1.0)
									end
								end
							end

							if hasCost then
								ab.cachedAt = at
								ab.cachedSpellId = spellId
								ab.cachedCosts = cachedCosts
								ab.cachedR = cachedR
								ab.cachedG = cachedG
								ab.cachedB = cachedB
								MIPOActionButtons[btnname] = ab
								pendingRetry[btnname] = nil
							else
								ab.cachedCosts = nil
								-- spell info may not be ready yet (transient nil right after
								-- a page change / login); retry cheaply on later ShowOOM calls
								pendingRetry[btnname] = ab
								MissingPower:HideOOM(btnname, "No Costs")
								local OOMAmountCounter = _G[btnname .. "AmountCounter"]
								if OOMAmountCounter and OOMAmountCounter.text then
									OOMAmountCounter.text:SetText("")
								end
							end
						end
					end
					-- btnSlot cache check
				end
			end

			if next(pendingRetry) ~= nil then
				for btnname, ab in pairs(pendingRetry) do
					local ABTN = ab.frameRef
					local id, at = MissingPower:GetActionFromButton(ABTN, ABTN._state_action, ab.isMAI)
					if id and at == "macro" then
						local ms = GetMacroSpell(id)
						if ms then
							id = ms
						end
					end

					local resolvedId = id
					if ab.isStance and id ~= nil then
						_, _, _, resolvedId = GetShapeshiftFormInfo(ab.nr)
					end

					local name, _, _, _, _, _, spellId
					if ab.isStance then
						name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(resolvedId)
					else
						name, _, _, _, _, _, spellId = MissingPower:GetSpellInfo(id)
					end

					ab._lastResolvedId = resolvedId
					ab._lastAt = at
					if name and (at == "spell" or at == "macro") then
						local costs = MissingPower:GetSpellPowerCost(spellId)
						if costs ~= nil and costs[1] ~= nil then
							local typ = costs[1].type
							local pbc = PowerBarColor[typ]
							local cachedR, cachedG, cachedB = 1.0, 1.0, 1.0
							if pbc ~= nil then
								cachedR = MissingPower:MathC(pbc.r or 1.0, 0.3, 1.0)
								cachedG = MissingPower:MathC(pbc.g or 1.0, 0.3, 1.0)
								cachedB = MissingPower:MathC(pbc.b or 1.0, 0.3, 1.0)
							end

							ab.cachedAt = at
							ab.cachedSpellId = spellId
							ab.cachedCosts = costs
							ab.cachedR = cachedR
							ab.cachedG = cachedG
							ab.cachedB = cachedB
							MIPOActionButtons[btnname] = ab
							pendingRetry[btnname] = nil
						end
					end
				end

				if next(pendingRetry) ~= nil and not MissingPower._retryScheduled then
					MissingPower._retryScheduled = true
					MissingPower:After(
						0.1,
						function()
							MissingPower._retryScheduled = false
							MissingPower:ShowOOM(nil, "RETRY")
						end, "MIPO_RETRY"
					)
				end
			end

			if pointsNeedReset then
				pointsNeedReset = false
				for _, ab in pairs(ActionButtons) do
					local counter = ab.counterRef
					if counter then
						counter._pointSet = nil
						if counter.text then
							counter.text._pointSet = nil
						end
					end

					ab.cachedHeight = nil
					ab.lastColorR = nil
				end
			end

			local cfg = MissingPower:GetConfigCache()
			local fontsize = cfg.fontsize
			local showamountcounter = cfg.showamountcounter
			local decimals = cfg.decimals
			local displayiflowerthanx = cfg.displayiflowerthanx
			local anchor = cfg.anchor
			local offsetX = cfg.offsetX
			local offsetY = cfg.offsetY
			local poweralpha = cfg.poweralpha
			local hideoverlap = cfg.hideoverlap
			local customcolor = cfg.customcolor
			local CMPColR = cfg.CMPColR
			local CMPColG = cfg.CMPColG
			local CMPColB = cfg.CMPColB
			local CMPColA = cfg.CMPColA
			local baseRegen = GetPowerRegen and GetPowerRegen() or 20
			-- reuse table to avoid GC pressure; wipe before each render pass
			for k in next, powerCache do
				powerCache[k] = nil
			end

			for btnname, ab in pairs(MIPOActionButtons) do
				local ABTN = ab.frameRef
				local OOM = ab.oomRef
				local OOMAmountCounter = ab.counterRef
				if OOMAmountCounter.text.fs ~= fontsize then
					OOMAmountCounter.text.fs = fontsize
					OOMAmountCounter.text:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
				end

				local ph = 0
				local p = 0
				local cost = 0
				local typ = 0
				local regen = baseRegen
				local amount = 0
				local costs = ab.cachedCosts
				if costs ~= nil then
					cost = costs[1].cost
					typ = costs[1].type
					if #costs > 1 then
						for i = 1, #costs do
							local c = costs[i]
							local cp = powerCache[c.type]
							if cp == nil then
								cp = UnitPower("player", c.type)
								powerCache[c.type] = cp
							end

							if c and cp > 0 and c.cost ~= 0 then
								cost = c.cost
								typ = c.type
							end
						end
					end

					local currentPower = powerCache[typ]
					if currentPower == nil then
						currentPower = UnitPower("player", typ)
						powerCache[typ] = currentPower
					end

					if cost > currentPower then
						p = currentPower / cost
					end

					amount = cost > 0 and (currentPower / cost) or 0
					if typ == Enum.PowerType.Mana then
						regen = baseRegen * 2
					elseif typ == Enum.PowerType.Rage or typ == Enum.PowerType.Focus then
						regen = baseRegen / -2
					end
				end

				if not OOMAmountCounter._pointSet then
					OOMAmountCounter._pointSet = true
					OOMAmountCounter:ClearAllPoints()
					OOMAmountCounter:SetPoint("CENTER", ABTN, "CENTER", 0, 0)
					OOMAmountCounter:Show(true)
					OOMAmountCounter:SetFrameStrata(ABTN:GetFrameStrata())
				end

				local wantCounterAlpha = (amount > 0 and showamountcounter) and 1 or 0
				if ab.lastCounterAlpha ~= wantCounterAlpha then
					ab.lastCounterAlpha = wantCounterAlpha
					OOMAmountCounter:SetAlpha(wantCounterAlpha)
				end

				local amo = SpecialRound(amount, (decimals == 0 or amount > 99) and 0 or decimals)
				local wantText = (displayiflowerthanx <= 0 or amount < displayiflowerthanx) and amo or ""
				if ab.lastText ~= wantText then
					ab.lastText = wantText
					OOMAmountCounter.text:SetText(wantText)
				end

				local wantR, wantG, wantB, wantA
				if customcolor then
					wantR, wantG, wantB, wantA = CMPColR, CMPColG, CMPColB, CMPColA
				else
					wantR, wantG, wantB, wantA = ab.cachedR, ab.cachedG, ab.cachedB, 0.9
				end

				if ab.lastColorR ~= wantR or ab.lastColorG ~= wantG or ab.lastColorB ~= wantB or ab.lastColorA ~= wantA then
					ab.lastColorR = wantR
					ab.lastColorG = wantG
					ab.lastColorB = wantB
					ab.lastColorA = wantA
					OOMAmountCounter.text:SetTextColor(wantR, wantG, wantB, wantA)
				end

				if not OOMAmountCounter.text._pointSet then
					OOMAmountCounter.text._pointSet = true
					OOMAmountCounter.text:SetSize(OOM:GetWidth(), OOM:GetWidth())
					OOMAmountCounter.text:ClearAllPoints()
					OOMAmountCounter.text:SetPoint("CENTER", ABTN, anchor, offsetX, offsetY)
				end

				if p <= 0 then
					if ab.lastVisible then
						ab.lastVisible = false
						ab.lastOOMY = nil
						ab.lastOOMH = nil
						MissingPower:HideOOM(btnname, "No P")
					end
				else
					if not ab.lastVisible then
						ab.lastVisible = true
						OOM:Show(true)
						local abStrata = ABTN:GetFrameStrata()
						if OOM._cachedStrata ~= abStrata then
							OOM._cachedStrata = abStrata
							OOM:SetFrameStrata(abStrata)
						end
					end

					if OOM._lastAlpha ~= poweralpha then
						OOM._lastAlpha = poweralpha
						OOM:SetAlpha(poweralpha)
					end

					local h = ab.cachedHeight
					if h == nil then
						h = ABTN:GetHeight()
						ab.cachedHeight = h
					end

					local hp = h * p
					local y = hp - h
					if ab.lastOOMY ~= y or ab.lastOOMH ~= hp then
						ab.lastOOMY = y
						ab.lastOOMH = hp
						OOM:ClearAllPoints()
						OOM:SetPoint("TOPLEFT", ABTN, "TOPLEFT", 0, y)
						OOM:SetHeight(hp)
					end

					ph = h / cost * regen
					y = y + ph
					if y > 0 and hideoverlap then
						ph = ph - y
					end
				end
			end
		end
	end
end

local frame = CreateFrame("FRAME")
MissingPower:RegisterEvent(frame, "PLAYER_ENTERING_WORLD")
MissingPower:RegisterEvent(frame, "SPELLS_CHANGED")
MissingPower:RegisterEvent(frame, "UNIT_SPELLCAST_START", "player")
MissingPower:RegisterEvent(frame, "ACTIONBAR_PAGE_CHANGED")
MissingPower:RegisterEvent(frame, "SPELL_UPDATE_USABLE")
MissingPower:RegisterEvent(frame, "MODIFIER_STATE_CHANGED")
MissingPower:RegisterEvent(frame, "ACTIONBAR_SLOT_CHANGED")
MissingPower:RegisterEvent(frame, "PLAYER_GAINS_VEHICLE_DATA", "player")
-- UPDATE_SHAPESHIFT_FORM spams in TBC, use only on other builds
if MissingPower:GetWoWBuild() ~= "TBC" then
	MissingPower:RegisterEvent(frame, "UPDATE_SHAPESHIFT_FORM")
end

-- PLAYER_MOUNT_CHANGED exists in Wrath and newer
if MissingPower:GetWoWBuild() ~= "CLASSIC" and MissingPower:GetWoWBuild() ~= "TBC" then
	MissingPower:RegisterEvent(frame, "PLAYER_MOUNT_CHANGED")
end

local MPLoaded = false
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
			if not MissingPower._updatePending then
				MissingPower._updatePending = true
				MissingPower:After(
					0.15,
					function()
						MissingPower._updatePending = false
						MissingPower:UpdateUi(event)
					end, "ACTIONBAR_PAGE_CHANGED"
				)
			end
		elseif event == "ACTIONBAR_SLOT_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_MOUNT_CHANGED" then
			if not MissingPower._updatePending then
				MissingPower._updatePending = true
				MissingPower:After(
					0.05,
					function()
						MissingPower._updatePending = false
						MissingPower:UpdateUi(event)
					end, "ACTIONBAR_SLOT_CHANGED"
				)
			end
		else
			if not MissingPower._elsePending then
				MissingPower._elsePending = true
				MissingPower:After(
					0.05,
					function()
						MissingPower._elsePending = false
						MissingPower:ShowOOM(nil, "ELSE")
					end, "MIPO_ELSE"
				)
			end
		end
	end
end

frame:SetScript("OnEvent", OnEvent)
local frame2 = CreateFrame("FRAME")
MissingPower:RegisterEvent(frame2, "UNIT_POWER_UPDATE", "player")
local lastPowerRender = 0
local POWER_RENDER_INTERVAL = 0.05
local function OnEvent2(self, event, unit, powertype, ...)
	if event == "UNIT_POWER_UPDATE" and unit == "player" and ready then
		local now = GetTime()
		if now - lastPowerRender >= POWER_RENDER_INTERVAL then
			lastPowerRender = now
			MissingPower:ShowOOM(nil, "UNIT_POWER_UPDATE")
		end
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
