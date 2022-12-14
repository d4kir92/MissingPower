-- enUS English

local AddOnName, MissingPower = ...

function MissingPower:Lang_enUS()
	local lang = MissingPower:GetLangTab()

	lang.hideoverlap = "Hide Overlap"
	lang.shownextready = "Show Next Ready"
	lang.showamountcounter = "Show counter"
	lang.poweralpha = "Power - Alpha: VALUE"
	lang.decimals = "Decimals: VALUE"
	lang.fontsize = "FontSize: VALUE"
	lang.fontx = "Position X: VALUE"
	lang.fonty = "Position Y: VALUE"
	lang.showtickbar = "Show Tickbar"
	lang.customcolor = "Custom Color"
	lang.ccolr = "Color Red: VALUE"
	lang.ccolg = "Color Green: VALUE"
	lang.ccolb = "Color Blue: VALUE"
	lang.displayiflowerthanx = "Display if lower than VALUE"
end
