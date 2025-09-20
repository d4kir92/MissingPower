-- FSR
local _, MissingPower = ...
local wOnce = true
function MissingPower:GetManaBar()
	local PlayerFrameManaBar = getglobal("PlayerFrameManaBar")
	local ElvUF_Player = getglobal("ElvUF_Player")
	local SUFUnitplayer = getglobal("SUFUnitplayer")
	local XPerl_PlayerstatsFramemanaBar = getglobal("XPerl_PlayerstatsFramemanaBar")
	local mb = PlayerFrameManaBar
	if ElvUF_Player ~= nil and ElvUF_Player:IsShown() then
		mb = ElvUF_Player.Power
		if mb == nil and wOnce then
			wOnce = false
			MissingPower:MSG("ElvUi Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	elseif SUFUnitplayer ~= nil and SUFUnitplayer:IsShown() then
		mb = SUFUnitplayer.powerBar
		if SUFUnitplayer == nil and wOnce then
			wOnce = false
			MissingPower:MSG("ShadowUnitFrames Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	elseif XPerl_PlayerstatsFramemanaBar ~= nil and XPerl_PlayerstatsFramemanaBar:IsShown() then
		mb = XPerl_PlayerstatsFramemanaBar
		if mb == nil and wOnce then
			wOnce = false
			MissingPower:MSG("XPerl Renamed PlayerFrame, please tell Missing Power Dev to fix it")
		end
	end

	if mb == nil then
		mb = PlayerFrameManaBar
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
			if true then
				local lastMb = nil
				local tick = 0.03
				local now = GetTime()
				local nexttick = now + 2
				local oldmana = 0
				local mpt = 2
				local fsr = 5
				local max = 2
				local gain = true
				local mana = 0
				local manamax = 0
				local frame = CreateFrame("FRAME")
				MissingPower:RegisterEvent(frame, "UNIT_SPELLCAST_SUCCEEDED", "player")
				local tex = frame:CreateTexture(nil, "BACKGROUND")
				tex:SetAllPoints()
				tex:SetColorTexture(1, 1, 1, 0)
				local function eventHandler(self, event, unit, a, b, c, ...)
					now = GetTime()
					if event == "UNIT_SPELLCAST_SUCCEEDED" then
						mana = UnitPower("player", Enum.PowerType.Mana)
						manamax = UnitPowerMax("player", Enum.PowerType.Mana)
						if unit == "player" and event == "UNIT_SPELLCAST_SUCCEEDED" and oldmana ~= mana then
							oldmana = mana
							--local name, rank, icon, castTime, minRange, maxRange = MissingPower:GetSpellInfo(b)
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
				function MissingPower:FSR()
					now = GetTime()
					mana = UnitPower("player", Enum.PowerType.Mana)
					manamax = UnitPowerMax("player", Enum.PowerType.Mana)
					local t = UnitPowerType("player")
					local full = false
					if t == Enum.PowerType.Mana then
						frame:Show()
						if mana < manamax then
							if gain then
								-- GAIN MANA
								if oldmana + 10 < mana or oldmana - 10 > mana or now >= nexttick then
									oldmana = mana
									max = mpt
									nexttick = now + mpt
								end
							elseif not gain then
								-- LOSE MANA
								gain = true
							end
							--max = mpt
						else
							full = true
						end
					else
						frame:Hide()
					end

					local percent = 0
					if max > 2 then
						percent = (nexttick - now) / max
					else
						percent = (max - (nexttick - now)) / max
					end

					if percent > 1 then
						full = true
					end

					if MissingPower:GetConfig("showtickbar", true) == false then
						full = true
					end

					local mb = MissingPower:GetManaBar()
					if lastMb ~= mb then
						lastMb = mb
						glowBg:SetHeight(mb:GetHeight())
						glow:SetHeight(mb:GetHeight() - 2)
					end

					if mb then
						if full then
							frame:Hide()
						else
							glowBg:SetColorTexture(MissingPower:GetColor("TickbarBorderColor", "TickbarBorderColor"))
							glow:SetColorTexture(MissingPower:GetColor("TickbarColor", "TickbarColor"))
							frame:SetParent(mb)
							frame:SetHeight(mb:GetHeight())
							frame:SetWidth(mb:GetWidth())
							frame:SetPoint("LEFT", mb, "LEFT")
							if MissingPower:GetConfig("showtickbarbg", true) then
								glowBg:SetWidth(3)
								glowBg:SetPoint("RIGHT", frame, "RIGHT", 1, 0)
							else
								glowBg:SetWidth(1)
								glowBg:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
							end

							glow:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
							local newsize = mb:GetWidth() * percent
							frame:SetWidth(newsize)
							frame:Show()
						end
					end

					MissingPower:After(
						tick,
						function()
							MissingPower:FSR()
						end, "FSR"
					)
				end

				MissingPower:FSR()
			end

			if true then
				local EnergyTickTracker = CreateFrame("Frame")
				EnergyTickTracker:RegisterEvent("UNIT_POWER_UPDATE")
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
				local function OnUpdateHandler(self, elapsed)
					local currentEnergyMax = UnitPowerMax("player", Enum.PowerType.Energy)
					local powerType = UnitPowerType("player")
					if powerType ~= Enum.PowerType.Energy then
						glowEnergy:Hide()
						glowEnergyBg:Hide()

						return
					end

					if MissingPower:GetConfig("showenergyticks", true) == false or currentEnergyMax <= 0 then
						glowEnergy:Hide()
						glowEnergyBg:Hide()

						return
					end

					glowEnergy:Show()
					glowEnergyBg:Show()
					glowEnergyBg:SetColorTexture(MissingPower:GetColor("EnergyTickbarBorderColor", "EnergyTickbarBorderColor"))
					glowEnergy:SetColorTexture(MissingPower:GetColor("EnergyTickbarColor", "EnergyTickbarColor"))
					mb = MissingPower:GetManaBar()
					if mb and lastMB ~= mb then
						lastMB = mb
						progressBar:SetParent(mb)
						glowEnergy:SetHeight(mb:GetHeight() - 2)
						glowEnergyBg:SetHeight(mb:GetHeight())
					end

					local currentTime = GetTime()
					local timeSinceLastTick = currentTime - lastTickTime
					if mb then
						local progress = timeSinceLastTick * mb:GetWidth() / 2
						if progress < 1 then
							progress = 1
						end

						if progress >= mb:GetWidth() then
							lastTickTime = GetTime()
							progress = mb:GetWidth()
						end

						progressBar:SetWidth(progress)
						if MissingPower:GetConfig("showenergyticksbg", true) then
							glowEnergyBg:SetWidth(3)
							glowEnergyBg:SetPoint("RIGHT", progressBar, "RIGHT", 1, 0)
						else
							glowEnergyBg:SetWidth(1)
							glowEnergyBg:SetPoint("RIGHT", progressBar, "RIGHT", 0, 0)
						end

						glowEnergy:SetPoint("RIGHT", progressBar, "RIGHT", 0, 0)
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
			end

			if true then
				local SwingTimerPrimary = CreateSwingTimer("SwingTimerPrimary", -200, 1, 0, 0)
				local SwingTimerSecondary = CreateSwingTimer("SwingTimerSecondary", -222, 0, 1, 0)
				local SwingTimerRanged = CreateSwingTimer("SwingTimerRanged", -244, 0, 0, 1)
				local SwingTimerLogic = CreateFrame("Frame")
				SwingTimerLogic:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				SwingTimerLogic:SetScript(
					"OnEvent",
					function(self, event, ...)
						if MissingPower:GetConfig("showswingtimer", false) == false or MissingPower:GetConfig("showswingtimer", true) == false then
							SwingTimerPrimary:Hide()
							SwingTimerSecondary:Hide()
							SwingTimerRanged:Hide()

							return
						end

						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo()
							if sourceGUID == UnitGUID("player") then
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
		end
	end, "FSR INIT"
)
