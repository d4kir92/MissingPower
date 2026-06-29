-- By D4KiR
local _, MissingPower = ...
MissingPower:SetAddonOutput("MissingPower", 136048)
function MissingPower:GetConfig(str, val)
	MIPOPC = MIPOPC or {}
	if MIPOPC[str] == nil then
		MIPOPC[str] = val
	end
	return MIPOPC[str]
end

local configCache = {}
local configCacheValid = false

function MissingPower:InvalidateConfigCache()
	configCacheValid = false
end

function MissingPower:GetConfigCache()
	if configCacheValid then return configCache end

	local fontsize = tonumber(MissingPower:GetConfig("fontsize", 12))
	if type(fontsize) ~= "number" then
		MissingPower:SV(MIPOPC, "fontsize", 12)
		fontsize = 12
	end
	if fontsize < 6 then
		MissingPower:SV(MIPOPC, "fontsize", 6)
		fontsize = 6
	end

	configCache.fontsize        = fontsize
	configCache.showamountcounter = MissingPower:GetConfig("showamountcounter", true)
	configCache.decimals          = MissingPower:GetConfig("decimals", 1)
	configCache.displayiflowerthanx = tonumber(MissingPower:GetConfig("displayiflowerthanx", 10))
	configCache.anchor            = MissingPower:GetAnchor(MissingPower:GetConfig("fontanchor", 0))
	configCache.offsetX           = MissingPower:GetConfig("textoffsetx", 0)
	configCache.offsetY           = MissingPower:GetConfig("textoffsety", 0)
	configCache.poweralpha        = MissingPower:GetConfig("poweralpha", 0.7)
	configCache.hideoverlap       = MissingPower:GetConfig("hideoverlap", true)
	configCache.customcolor       = MissingPower:GetConfig("customcolor", false)
	configCacheValid = true
	return configCache
end
