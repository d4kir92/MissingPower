-- LIB Math
local _, MissingPower = ...
function MissingPower:MathR(num, dec)
	dec = dec or 2

	return tonumber(string.format("%." .. dec .. "f", num))
end

function MissingPower:MathC(input, min, max)
	if input < min then
		input = min
	elseif input > max then
		input = max
	end

	return input
end