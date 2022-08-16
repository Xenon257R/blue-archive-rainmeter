-- Small script to handle extraneous issues with the update banner.
function Initialize()
    NUMAPPS = SKIN:GetVariable('NUMAPPS')
    CURRENTAPP = 1
    return 1
end

function AssignImage(index)
    SKIN:Bang('!ShowMeter', 'EventDetails')
    SKIN:Bang('!UpdateMeter', 'EventDetails')
    SKIN:Bang('!ShowMeter', 'EventDate')
    SKIN:Bang('!UpdateMeter', 'EventDate')

    SKIN:Bang('!SetOption', 'Banner' .. index, 'ImageName', '[ImageLink' .. index .. ']')
    SKIN:Bang('!ShowMeter', 'EventTab' .. index)
    SKIN:Bang('!UpdateMeter', 'Banner' .. index)
    return 1
end

function Equalize()
    SKIN:Bang('!SetOption', 'RSSFeedParent1', 'URL', 'https://store.steampowered.com/feeds/news/app/#AppID' .. ((CURRENTAPP % NUMAPPS) + 1) .. '#/')
    SKIN:Bang('!SetOption', 'ImageLink1', 'ErrorString', 'https://cdn.cloudflare.steamstatic.com/steam/apps/#AppID' .. ((CURRENTAPP % NUMAPPS) + 1) .. '#/header.jpg')
    SKIN:Bang('!CommandMeasure', 'RSSFeedParent1', 'Update')

    return 1
end

function Step()
    CURRENTAPP = (CURRENTAPP % NUMAPPS) + 1
    SKIN:Bang('!SetOption', 'RSSFeedParent2','URL', 'https://store.steampowered.com/feeds/news/app/#AppID' .. ((CURRENTAPP % NUMAPPS) + 1) .. '#/')
    SKIN:Bang('!SetOption', 'ImageLink2', 'ErrorString', 'https://cdn.cloudflare.steamstatic.com/steam/apps/#AppID' .. ((CURRENTAPP % NUMAPPS) + 1) .. '#/header.jpg')
    SKIN:Bang('!CommandMeasure', 'RSSFeedParent2', 'Update')

    return 1
end