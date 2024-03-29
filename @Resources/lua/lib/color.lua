-- CITATIONS: https://gist.github.com/GigsD4X/8513963
--            https://www.rapidtables.com/convert/color/rgb-to-hsv.html
local function HSVToRGB(hue, saturation, value)
	-- Returns the RGB equivalent of the given HSV-defined color
	-- (adapted from some code found around the web)

    -- adjustments
    hue = hue % 360
    saturation = saturation / 100
    value = (value / 100) * 255

	-- If it's achromatic, just return the value
	if saturation == 0 then
		return value, value, value
	end

	-- Get the hue sector
	local hue_sector = math.floor( hue / 60 )
	local hue_sector_offset = ( hue / 60 ) - hue_sector

	local p = value * ( 1 - saturation )
	local q = value * ( 1 - saturation * hue_sector_offset )
	local t = value * ( 1 - saturation * ( 1 - hue_sector_offset ) )

	if hue_sector == 0 then
		return value, t, p
	elseif hue_sector == 1 then
		return q, value, p
	elseif hue_sector == 2 then
		return p, value, t
	elseif hue_sector == 3 then
		return p, q, value
	elseif hue_sector == 4 then
		return t, p, value
	elseif hue_sector == 5 then
		return value, p, q
	end
end

-- CITATIONS: https://gist.github.com/GigsD4X/8513963
--            https://www.rapidtables.com/convert/color/rgb-to-hsv.html
local function RGBToHSV(red, green, blue)
	-- Returns the HSV equivalent of the given RGB-defined color

	local modr, modg, modb = red / 255, green / 255, blue / 255
	local hue, saturation

	local min_value = math.min( modr, modg, modb )
	local max_value = math.max( modr, modg, modb )

	local value_delta = max_value - min_value

	if modr == max_value then
		hue = ((( modg - modb ) / value_delta) % 6)
	elseif modg == max_value then
		hue = 2 + ( modb - modr ) / value_delta
	else
		hue = 4 + ( modr - modg ) / value_delta
	end

	if value_delta == 0 then
		hue = 0
	end

	hue = hue * 60
    if max_value == 0 then
		saturation = 0
		hue = 0
	else
		saturation = value_delta / max_value
	end

	return hue, saturation * 100, max_value * 100
end

-- Generates and returns a full color set given an RGBA string "r,g,b,a"
-- Returns multiple values in order of R, G, B, H, S, V, A, HEX as individual values, NOT A TABLE
local function fullSet(rgba)
    rgba = rgba or '0,0,0,0'
    local colorstring = {}

    for i in rgba:gmatch("%d+") do
        table.insert(colorstring, i)
    end

    local red, green, blue, alpha = colorstring[1], colorstring[2], colorstring[3], colorstring[4]

    local hue, saturation, value = RGBToHSV(red, green, blue)

	local hex = ('%02X'):format(red) .. ('%02X'):format(green) .. ('%02X'):format(blue)

    return red, green, blue, hue, saturation, value, alpha, hex
end

local color = {}
color.__index = color

function color.new(rgba_string)
    local o = setmetatable({}, color)

    o.r, o.g, o.b, o.h, o.s, o.v, o.a, o.x = fullSet(rgba_string)

    return o
end

-- Returns color values requested from [typetable]
-- EXAMPLE: If a [typetable] of { g, b, r } is passed for #ff0000, it will return the STRING '0,0,255'
-- NOTE: HEX requests are best done as a independent request (i.e. { x })
function color:getValues(typetable)
    local data = {}
    for _, v in ipairs(typetable) do
		local val = self[v]
		if type(val) == 'number' then val = math.floor(val) end
        table.insert(data, val)
    end

    return table.concat(data, ',')
end

-- Returns a "normalized" color value to be used in a 2D spectrum
function color:getBase()
    return HSVToRGB(self.h, 100, 100)
end

-- Changes the stored [color] values to [newval]
-- NOTES: [modifier] refers to the adjustment between different ranges such as [0-100] to [0-255]
--        [colortype] specifies between RGB or HSV
function color:setValue(newval, modifier, colortype)

	-- Edge case for the Eyedropper tool. Assumes alpha is never passed
	if colortype == 'rgb' then
		local oldfullval = self.r .. ',' .. self.g .. ','  .. self.b .. ','  .. self.a
		self.r, self.g, self.b, self.h, self.s, self.v, self.a, self.x = fullSet(newval .. ',' .. self.a)

		return oldfullval
	end

    local oldval = self[colortype]

    if colortype == 'x' then
        if string.match(newval, '%x+') ~= newval or string.len(newval) ~= 6 then return -1 end
        self.r = tonumber('0x' .. newval:sub(1,2))
		self.g = tonumber('0x' .. newval:sub(3,4))
		self.b = tonumber('0x' .. newval:sub(5,6))
        self.h, self.s, self.v = RGBToHSV(self.r, self.g, self.b)
    else
        self[colortype] = (self[colortype] * modifier) + newval

        if colortype == 's' or colortype == 'v' then
            self[colortype] = math.max(math.min(self[colortype], 100), 0)
        elseif colortype == 'h' then
            self[colortype] = math.max(math.min(self[colortype], 360), 0)
        else
            self[colortype] = math.max(math.min(self[colortype], 255), 0)
        end

        if colortype == 'r' or colortype == 'g' or colortype == 'b' then
            self.h, self.s, self.v = RGBToHSV(self.r, self.g, self.b)
        elseif colortype == 'h' or colortype == 's' or colortype == 'v' then
            self.r, self.g, self.b = HSVToRGB(self.h, self.s, self.v)
        end
    end

    self.x = ('%02X'):format(self.r) ..('%02X'):format(self.g) .. ('%02X'):format(self.b)

    return oldval
end

-- Overrides stored [color] values to the newly passed [rgba_string]
function color:setAll(rgba_string)
    self.r, self.g, self.b, self.h, self.s, self.v, self.a, self.x = fullSet(rgba_string)

    return 1
end

return color