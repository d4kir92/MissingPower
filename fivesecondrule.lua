-- By D4KiR
local _, MissingPower = ...
local wOnce = true
function MissingPower:GetManaBar()
	local mb = getglobal("PlayerFrameManaBar")
	local _ElvUF_Player = getglobal("ElvUF_Player")
	local _SUFUnitplayer = getglobal("SUFUnitplayer")
	local _XPerl_PlayerstatsFramemanaBar = getglobal("XPerl_PlayerstatsFramemanaBar")
	if _ElvUF_Player ~= nil and _ElvUF_Player:IsShown() then
		mb = _ElvUF_Player.Power
		if mb == nil and wOnce then
			wOnce = false
			MissingPower:MSG("ElvUi Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	elseif _SUFUnitplayer ~= nil and _SUFUnitplayer:IsShown() then
		mb = _SUFUnitplayer.powerBar
		if mb == nil and wOnce then
			wOnce = false
			MissingPower:MSG("ShadowUnitFrames Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	elseif _XPerl_PlayerstatsFramemanaBar ~= nil and _XPerl_PlayerstatsFramemanaBar:IsShown() then
		mb = _XPerl_PlayerstatsFramemanaBar
		if mb == nil and wOnce then
			wOnce = false
			MissingPower:MSG("XPerl Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	end

	if mb == nil then
		mb = getglobal("PlayerFrameManaBar")
	end

	return mb
end

MissingPower:After(
	1,
	function()
		local function CreateSwingTimer(name, y, cr, cg, cb)
			local SwingTimer = CreateFrame("Frame", name, UIParent)
			SwingTimer:SetSize(200, 20)
			SwingTimer:SetPoint("CENTER", UIParent, "CENTER", 0, y)
			SwingTimer:Hide()
			SwingTimer.bg = SwingTimer:CreateTexture(nil, "BACKGROUND")
			SwingTimer.bg:SetAllPoints(SwingTimer)
			SwingTimer.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
			SwingTimer.bar = SwingTimer:CreateTexture(nil, "ARTWORK")
			SwingTimer.bar:SetPoint("LEFT", SwingTimer, "LEFT", 0, 0)
			SwingTimer.bar:SetSize(200, 20)
			SwingTimer.bar:SetColorTexture(cr, cg, cb, 1)
			SwingTimer.text = SwingTimer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			SwingTimer.text:SetPoint("CENTER", SwingTimer, "CENTER", 0, 0)
			SwingTimer.text:SetText("Swing Timer")
			local startTime = 0
			local swingDuration = 0
			local isSwinging = false
			local function UpdateSwingTimer(self, elapsed)
				if not isSwinging then return end
				local remaining = (startTime + swingDuration) - GetTime()
				if remaining <= 0 then
					SwingTimer:Hide()
					isSwinging = false

					return
				end

				local progress = remaining / swingDuration
				SwingTimer.bar:SetWidth(200 * progress)
				SwingTimer.text:SetText(string.format("%.1f", remaining))
			end

			SwingTimer:SetScript("OnUpdate", UpdateSwingTimer)
			function SwingTimer:StartTimer(duration)
				if duration == nil then return end
				swingDuration = duration
				startTime = GetTime()
				isSwinging = true
				SwingTimer:Show()
			end

			return SwingTimer
		end

		if MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC" then
			local lastMb = nil
			local now = GetTime()
			local nexttick = now + 2
			local oldmana = 0
			local mpt = 2
			local fsr = 5
			local max = 2
			local gain = true
			local mana = 0
			local manamax = 0
			local cachedPowerType = UnitPowerType("player")
			local frame = CreateFrame("FRAME")
			MissingPower:RegisterEvent(frame, "UNIT_SPELLCAST_SUCCEEDED", "player")
			MissingPower:RegisterEvent(frame, "UNIT_DISPLAYPOWER", "player")
			local tex = frame:CreateTexture(nil, "BACKGROUND")
			tex:SetAllPoints()
			tex:SetColorTexture(1, 1, 1, 0)
			local function eventHandler(self, event, unit, a, b, c, ...)
				now = GetTime()
				if event == "UNIT_DISPLAYPOWER" then
					cachedPowerType = UnitPowerType("player")
				elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
					mana = UnitPower("player", Enum.PowerType.Mana)
					manamax = UnitPowerMax("player", Enum.PowerType.Mana)
					if unit == "player" and oldmana ~= mana then
						oldmana = mana
						local costs = MissingPower:GetSpellPowerCost(b)
						if costs and costs[1] ~= nil and costs[1].cost > 0 then
							max = fsr
							gain = false
							nexttick = now + fsr
						end
					end
				end
			end

			frame:SetScript("OnEvent", eventHandler)
			frame:SetFrameStrata("HIGH")
			local glowBg = frame:CreateTexture(nil, "OVERLAY")
			glowBg:SetDrawLayer("OVERLAY", 6)
			local glow = frame:CreateTexture(nil, "OVERLAY")
			glow:SetDrawLayer("OVERLAY", 7)
			glow:SetWidth(1)
			local fsrCfgShowTickBar = MissingPower:GetConfig("showtickbar", true)
			local fsrCfgShowTickBarBg = MissingPower:GetConfig("showtickbarbg", true)
			local fsrColorBg = {MissingPower:GetColor("TickbarBorderColor", "TickbarBorderColor")}
			local fsrColor = {MissingPower:GetColor("TickbarColor", "TickbarColor")}
			local fsrColorDirty = true
			hooksecurefunc(
				MissingPower,
				"InvalidateConfigCache",
				function()
					fsrCfgShowTickBar = MissingPower:GetConfig("showtickbar", true)
					fsrCfgShowTickBarBg = MissingPower:GetConfig("showtickbarbg", true)
					fsrColorBg = {MissingPower:GetColor("TickbarBorderColor", "TickbarBorderColor")}
					fsrColor = {MissingPower:GetColor("TickbarColor", "TickbarColor")}
					lastMb = nil
					fsrColorDirty = true
				end
			)

			local fsrDriver = CreateFrame("FRAME")
			fsrDriver:Show()
			local fsrAccum = 0
			fsrDriver:SetScript(
				"OnUpdate",
				function(self, elapsed)
					fsrAccum = fsrAccum + elapsed
					if fsrAccum < 0.03 then return end
					fsrAccum = fsrAccum - 0.03
					now = GetTime()
					if cachedPowerType ~= Enum.PowerType.Mana then
						frame:Hide()

						return
					end

					mana = UnitPower("player", Enum.PowerType.Mana)
					manamax = UnitPowerMax("player", Enum.PowerType.Mana)
					local full = false
					frame:Show()
					if mana < manamax then
						if gain then
							if oldmana + 10 < mana or oldmana - 10 > mana or now >= nexttick then
								oldmana = mana
								max = mpt
								nexttick = now + mpt
							end
						elseif not gain then
							gain = true
						end
					else
						full = true
					end

					local percent = 0
					if max > 2 then
						percent = (nexttick - now) / max
					else
						percent = (max - (nexttick - now)) / max
					end

					if percent > 1 or fsrCfgShowTickBar == false then
						full = true
					end

					local mb = MissingPower:GetManaBar()
					if lastMb ~= mb then
						lastMb = mb
						local mbH = mb:GetHeight()
						glowBg:SetHeight(mbH)
						glow:SetHeight(mbH - 2)
						frame:SetParent(mb)
						frame:SetHeight(mbH)
						frame:SetPoint("LEFT", mb, "LEFT")
						glow:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
						if fsrCfgShowTickBarBg then
							glowBg:SetWidth(3)
							glowBg:SetPoint("RIGHT", frame, "RIGHT", 1, 0)
						else
							glowBg:SetWidth(1)
							glowBg:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
						end
					end

					if mb then
						if full then
							frame:Hide()
						else
							if fsrColorDirty then
								fsrColorDirty = false
								glowBg:SetColorTexture(fsrColorBg[1], fsrColorBg[2], fsrColorBg[3], fsrColorBg[4])
								glow:SetColorTexture(fsrColor[1], fsrColor[2], fsrColor[3], fsrColor[4])
							end

							local newW = mb:GetWidth() * percent
							if frame._lastW ~= newW then
								frame._lastW = newW
								frame:SetWidth(newW)
							end

							frame:Show()
						end
					end
				end
			)

			local EnergyTickTracker = CreateFrame("Frame")
			EnergyTickTracker:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			local lastTickTime = GetTime()
			local tickInterval = 2
			local playerUnit = "player"
			local mb = MissingPower:GetManaBar()
			local progressBar = CreateFrame("StatusBar", nil, mb)
			progressBar:SetSize(118, 18)
			progressBar:SetPoint("LEFT", mb, "LEFT")
			progressBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
			progressBar:SetStatusBarColor(0, 0, 0, 0)
			progressBar:SetMinMaxValues(0, tickInterval)
			progressBar:SetValue(0)
			local glowEnergyBg = progressBar:CreateTexture(nil, "OVERLAY")
			glowEnergyBg:SetDrawLayer("OVERLAY", 6)
			local glowEnergy = progressBar:CreateTexture(nil, "OVERLAY")
			glowEnergy:SetDrawLayer("OVERLAY", 7)
			glowEnergy:SetWidth(1)
			local lastMB = nil
			local lastEnergy = -1
			local euShowTicks = MissingPower:GetConfig("showenergyticks", true)
			local euShowTicksBg = MissingPower:GetConfig("showenergyticksbg", true)
			local euColorBg = {MissingPower:GetColor("EnergyTickbarBorderColor", "EnergyTickbarBorderColor")}
			local euColor = {MissingPower:GetColor("EnergyTickbarColor", "EnergyTickbarColor")}
			local euColorDirty = true
			hooksecurefunc(
				MissingPower,
				"InvalidateConfigCache",
				function()
					euShowTicks = MissingPower:GetConfig("showenergyticks", true)
					euShowTicksBg = MissingPower:GetConfig("showenergyticksbg", true)
					euColorBg = {MissingPower:GetColor("EnergyTickbarBorderColor", "EnergyTickbarBorderColor")}
					euColor = {MissingPower:GetColor("EnergyTickbarColor", "EnergyTickbarColor")}
					lastMB = nil
					euColorDirty = true
				end
			)

			local euAccum = 0
			local function OnUpdateHandler(self, elapsed)
				euAccum = euAccum + elapsed
				if euAccum < 0.03 then return end
				euAccum = euAccum - 0.03
				if cachedPowerType ~= Enum.PowerType.Energy then
					glowEnergy:Hide()
					glowEnergyBg:Hide()

					return
				end

				local currentEnergyMax = UnitPowerMax("player", Enum.PowerType.Energy)
				if euShowTicks == false or currentEnergyMax <= 0 then
					glowEnergy:Hide()
					glowEnergyBg:Hide()

					return
				end

				glowEnergy:Show()
				glowEnergyBg:Show()
				if euColorDirty then
					euColorDirty = false
					glowEnergyBg:SetColorTexture(euColorBg[1], euColorBg[2], euColorBg[3], euColorBg[4])
					glowEnergy:SetColorTexture(euColor[1], euColor[2], euColor[3], euColor[4])
				end

				mb = MissingPower:GetManaBar()
				if mb and lastMB ~= mb then
					lastMB = mb
					progressBar:SetParent(mb)
					glowEnergy:SetHeight(mb:GetHeight() - 2)
					glowEnergyBg:SetHeight(mb:GetHeight())
					glowEnergy:SetPoint("RIGHT", progressBar, "RIGHT", 0, 0)
					if euShowTicksBg then
						glowEnergyBg:SetWidth(3)
						glowEnergyBg:SetPoint("RIGHT", progressBar, "RIGHT", 1, 0)
					else
						glowEnergyBg:SetWidth(1)
						glowEnergyBg:SetPoint("RIGHT", progressBar, "RIGHT", 0, 0)
					end
				end

				local currentTime = GetTime()
				local timeSinceLastTick = currentTime - lastTickTime
				if mb then
					local mbW = mb:GetWidth()
					local progress = timeSinceLastTick * mbW / 2
					if progress < 1 then
						progress = 1
					end

					if progress >= mbW then
						lastTickTime = currentTime
						progress = mbW
					end

					progressBar:SetWidth(progress)
				end
			end

			local function InitializeTracker()
				lastTickTime = GetTime() - 0.45
				progressBar:SetScript("OnUpdate", OnUpdateHandler)
			end

			EnergyTickTracker:SetScript(
				"OnEvent",
				function(self, event, unit, powerType, ...)
					if event == "UNIT_POWER_UPDATE" and unit == playerUnit and powerType == "ENERGY" then
						local currentEnergy = UnitPower("player", Enum.PowerType.Energy)
						if lastEnergy < currentEnergy then
							lastTickTime = GetTime()
						end

						lastEnergy = currentEnergy
					end
				end
			)

			InitializeTracker()
			local SwingTimerPrimary = CreateSwingTimer("SwingTimerPrimary", -200, 1, 0, 0)
			local SwingTimerSecondary = CreateSwingTimer("SwingTimerSecondary", -222, 0, 1, 0)
			local SwingTimerRanged = CreateSwingTimer("SwingTimerRanged", -244, 0, 0, 1)
			local swingTimerEnabled = MissingPower:GetConfig("showswingtimer", false)
			hooksecurefunc(
				MissingPower,
				"InvalidateConfigCache",
				function()
					swingTimerEnabled = MissingPower:GetConfig("showswingtimer", false)
				end
			)

			local playerGUID = UnitGUID("player")
			local SwingTimerLogic = CreateFrame("Frame")
			SwingTimerLogic:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			SwingTimerLogic:SetScript(
				"OnEvent",
				function(self, event, ...)
					if swingTimerEnabled == false then
						SwingTimerPrimary:Hide()
						SwingTimerSecondary:Hide()
						SwingTimerRanged:Hide()

						return
					end

					if event == "COMBAT_LOG_EVENT_UNFILTERED" then
						local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo()
						if sourceGUID == playerGUID then
							if subevent == "SWING_DAMAGE" then
								local _, _, _, _, _, _, _, _, _, is_offhand = select(12, CombatLogGetCurrentEventInfo())
								local weaponSpeed, weaponSpeed2 = UnitAttackSpeed("player")
								if is_offhand then
									SwingTimerSecondary:Show()
									SwingTimerSecondary:StartTimer(weaponSpeed2)
								else
									SwingTimerPrimary:Show()
									SwingTimerPrimary:StartTimer(weaponSpeed)
								end
							elseif subevent == "SWING_MISSED" then
								local _, is_offhand = select(12, CombatLogGetCurrentEventInfo())
								local weaponSpeed, weaponSpeed2 = UnitAttackSpeed("player")
								if is_offhand then
									SwingTimerSecondary:Show()
									SwingTimerSecondary:StartTimer(weaponSpeed2)
								else
									SwingTimerPrimary:Show()
									SwingTimerPrimary:StartTimer(weaponSpeed)
								end
							elseif spellId == 75 and subevent == "SPELL_CAST_SUCCESS" then
								local speed, _, _, _, _ = UnitRangedDamage("player")
								SwingTimerRanged:Show()
								SwingTimerRanged:StartTimer(speed)
							end
						end
					end
				end
			)
		end
	end, "FSR INIT"
)
