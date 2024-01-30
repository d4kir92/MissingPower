-- LIB Design
local _, MissingPower = ...
local ltab = {}
function MissingPower:GetLangTab()
	return ltab
end

function MissingPower:GT(str, tab)
	local strid = string.lower(str)
	local result = MissingPower:GetLangTab()[strid]
	if result ~= nil then
		if tab ~= nil then
			for i, v in pairs(tab) do
				local find = i -- "[" .. i .. "]"
				local replace = v
				if find ~= nil and replace ~= nil then
					result = string.gsub(result, find, replace)
				end
			end
		end

		return result
	else
		return str
	end
end

function MissingPower:UpdateLanguage()
	MissingPower:Lang_enUS()
	if GetLocale() == "enUS" then
		--MissingPower:MSG("Language detected: enUS (English)")
		MissingPower:Lang_enUS()
	elseif GetLocale() == "deDE" then
		--MissingPower:MSG("Language detected: deDE (Deutsch)")
		MissingPower:Lang_deDE()
	elseif GetLocale() == "koKR" then
		--MissingPower:MSG("Language detected: koKR (Korean)")
		MissingPower:Lang_koKR()
	elseif GetLocale() == "ruRU" then
		--MissingPower:MSG("Language detected: ruRU (Russian)")
		MissingPower:Lang_ruRU()
	elseif GetLocale() == "zhCN" then
		--MissingPower:MSG("Language detected: zhCN (Simplified Chinese)")
		MissingPower:Lang_zhCN()
	elseif GetLocale() == "zhTW" then
		--MissingPower:MSG("Language detected: zhTW (Traditional Chinese)")
		MissingPower:Lang_zhTW()
	else
		MissingPower:MSG("Language not found (" .. GetLocale() .. "), using English one!")
		MissingPower:MSG("If you want your language, please visit the cursegaming site of this project!")
	end
end

MissingPower:UpdateLanguage()