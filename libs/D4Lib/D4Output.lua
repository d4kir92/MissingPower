local _, D4 = ...
local nam = ""
local ico = ""
function D4:SetAddonOutput(name, icon)
    nam = name
    ico = icon
end

function D4:MSG(...)
    print(string.format("[|cFFA0A0FF%s|r |T%s:0:0:0:0|t]", nam, ico), ...)
end
