local _, MissingPower = ...

if (MissingPower:GetWoWBuild() == "CLASSIC" or MissingPower:GetWoWBuild() == "TBC") and MissingPower:GetConfig("showtickbar", true) then
	local hpReg = 1.7
	local tickRate = 0.01
	local p = 0
	local movingElement = CreateFrame("Frame", nil, PlayerFrameHealthBar)
	movingElement:SetSize(10, 10)
	movingElement:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 0, 0)
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

		local _, sh = PlayerFrameHealthBar:GetSize()
		movingElement:SetSize(1, sh)
		movingElement:ClearAllPoints()
		movingElement:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", p * PlayerFrameHealthBar:GetWidth(), 0)
		C_Timer.After(tickRate, UpdatePos)
	end

	C_Timer.After(tickRate, UpdatePos)

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
				end
			end
		end
	end

	local f = CreateFrame("FRAME")
	f:RegisterEvent("UNIT_HEALTH")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:SetScript("OnEvent", OnEvent)
end