-- deDE German Deutsch

local AddOnName, MissingPower = ...

function MissingPower:Lang_deDE()
	local lang = MissingPower:GetLangTab()

	lang.hideoverlap = "Überlappen verstecken"
	lang.shownextready = "Nächste Fertig anzeigen"
	lang.showamountcounter = "Zähler anzeigen"
	lang.poweralpha = "Macht - Alpha: VALUE"
	lang.decimals = "Dezimalstellen: VALUE"
	lang.fontsize = "Schriftgröße: VALUE"
	lang.fontx = "Position X: VALUE"
	lang.fonty = "Position Y: VALUE"
	lang.showtickbar = "Tickbar anzeigen"
	lang.customcolor = "Benutzerdefinierte Farbe"
	lang.ccolr = "Farbe Rot: VALUE"
	lang.ccolg = "Farbe Grün: VALUE"
	lang.ccolb = "Farbe Blau: VALUE"
	lang.displayiflowerthanx = "Anzeigen, wenn niedriger als VALUE"
end
