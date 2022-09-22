-- By D4KiR

MIPO = MIPO or {}
MIPOPC = MIPOPC or {}

MIPOname = "MissingPower |T136048:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t"

SetCVar("ScriptErrors", 1)
MIPO.DEBUG = false

MIPOPC["DEBUG"] = false

function MIPOGetConfig(str, val)
	local setting = val
	if MIPOPC ~= nil then
		if MIPOPC[str] == nil then
			MIPOPC[str] = val
		end
		setting = MIPOPC[str]
	end
	return setting
end
