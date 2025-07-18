local _, MissingPower = ...
MissingPower:After(
	5,
	function()
		if (MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC") and MissingPower:GetConfig("showhealthreg", false) then
			local hb = PlayerFrameHealthBar
			if ElvUF_Player ~= nil and ElvUF_Player:IsShown() then
				hb = ElvUF_Player.Health
			elseif SUFUnitplayer ~= nil and SUFUnitplayer:IsShown() then
				hb = SUFUnitplayer.healthBar
			elseif XPerl_PlayerstatsFramehealthBar ~= nil and XPerl_PlayerstatsFramehealthBar:IsShown() then
				hb = XPerl_PlayerstatsFramehealthBar
			end

			local hpReg = 1.66
			local tickRate = 0.01
			local p = 0
			local movingElement = CreateFrame("Frame", nil, hb)
			movingElement:SetSize(10, 10)
			movingElement:SetPoint("LEFT", hb, "LEFT", 0, 0)
			movingElement:SetFrameStrata("HIGH")
			movingElement:Hide()
			local glow = movingElement:CreateTexture(nil, "OVERLAY")
			glow:SetDrawLayer("OVERLAY", 7)
			glow:SetColorTexture(1, 1, 1, 1)
			glow:SetWidth(1)
			glow:SetAllPoints(movingElement)
			local function UpdatePos()
				p = p + tickRate / hpReg
				if p > 1 then
					p = 0
				end

				local _, sh = hb:GetSize()
				movingElement:SetSize(1, sh)
				movingElement:ClearAllPoints()
				movingElement:SetPoint("LEFT", hb, "LEFT", p * hb:GetWidth(), 0)
				if MissingPower.DEBUG then
					print("Timer12")
				end

				MissingPower:After(tickRate, UpdatePos, "UpdatePos2")
			end

			if MissingPower.DEBUG then
				print("Timer13")
			end

			MissingPower:After(tickRate, UpdatePos, "UpdatePos1")
			local function OnEvent(self, event, ...)
				if event == "PLAYER_REGEN_ENABLED" then
					p = 0
					movingElement:Show()
				elseif event == "PLAYER_REGEN_DISABLED" then
					p = 0
					movingElement:Hide()
				elseif event == "UNIT_HEALTH" then
					local unit = ...
					if unit == "player" then
						p = 0
						if UnitHealth("player") == UnitHealthMax("player") then
							movingElement:Hide()
						elseif not InCombatLockdown() then
							movingElement:Show()
						end
					end
				end
			end

			local f = CreateFrame("FRAME")
			MissingPower:RegisterEvent(f, "UNIT_HEALTH", "player")
			MissingPower:RegisterEvent(f, "PLAYER_REGEN_ENABLED")
			MissingPower:RegisterEvent(f, "PLAYER_REGEN_DISABLED")
			f:SetScript("OnEvent", OnEvent)
		end
	end, "healthRegen"
)
