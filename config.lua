-- By D4KiR
local _, MissingPower = ...
MissingPower:SetAddonOutput("MissingPower", 136048)
function MissingPower:GetConfig(str, val)
	MIPO = MIPO or {}
	MIPOPC = MIPOPC or {}
	MIPOPC.DEBUG = false
	MIPO.DEBUG = false
	local setting = val
	if MIPOPC ~= nil then
		if MIPOPC[str] == nil then
			MIPOPC[str] = val
		end

		setting = MIPOPC[str]
	end

	return setting
end
