-- CITATION: https://gist.github.com/GigsD4X/8513963
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

-- CITATION: https://gist.github.com/GigsD4X/8513963
local function RGBToHSV(red, green, blue)
	-- Returns the HSV equivalent of the given RGB-defined color
	-- (adapted from some code found around the web)

	local hue, saturation, value

	local min_value = math.min( red, green, blue )
	local max_value = math.max( red, green, blue )

    -- VALUE adjustment
	value = max_value / 255

	local value_delta = max_value - min_value

	-- If the color is not black
	if max_value ~= 0 then
		saturation = value_delta / max_value

	-- If the color is purely black
	else
		saturation = 0
		hue = 0
		return hue, saturation, value
	end;

	if red == max_value then
		hue = ( green - blue ) / value_delta
	elseif green == max_value then
		hue = 2 + ( blue - red ) / value_delta
	else
		hue = 4 + ( red - green ) / value_delta
	end

	hue = hue * 60
	if hue < 0 then
		hue = hue + 360
	end

    if value_delta == 0 then
        hue = 0
        saturation = 0
    end

	return hue, saturation * 100, value * 100
end

local function fullSet(rgba)
    local rgba = rgba or '0,0,0,0'
    local colorstring = {}

    for i in rgba:gmatch("%d+") do
        table.insert(colorstring, i)
    end

    local red = colorstring[1]
    local green = colorstring[2]
    local blue = colorstring[3]
    local alpha = colorstring[4]

    local hue, saturation, value = RGBToHSV(red, green, blue)
    
    return red, green, blue, hue, saturation, value, alpha, ('%02X'):format(red) ..('%02X'):format(green) .. ('%02X'):format(blue)
end

local color = {}
color.__index = color

function color.new(rgba_string)
    local o = setmetatable({}, color)

    o.r, o.g, o.b, o.h, o.s, o.v, o.a, o.x = fullSet(rgba_string)

    return o
end

function color:getHex(prefix)
	prefix = prefix or ''

	return prefix .. self.x
end

function color:getValues(typetable)
    local data = {}
    for k, v in ipairs(typetable) do
        if v == 'x' then
            return self[v]
        else
            table.insert(data, math.floor(self[v]))
        end
    end

    return table.concat(data, ',')
end

function color:getBase()
    return HSVToRGB(self.h, 100, 100)
end

function color:setValue(newval, modifier, colortype)
    local oldval = self[colortype]

    if colortype == 'x' then
        if string.match(newval, '%x+') ~= newval or string.len(newval) ~= 6 then return -1 end
        self.r, self.g, self.b = tonumber("0x" .. newval:sub(1,2)), tonumber("0x" .. newval:sub(3,4)), tonumber("0x" .. newval:sub(5,6))
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

function color:setAll(rgba_string)
    self.r, self.g, self.b, self.h, self.s, self.v, self.a, self.x = fullSet(rgba_string)

    return 0
end

return color