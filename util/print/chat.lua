function hexToDec(hex)
    return tonumber(hex, 16)
end

function decToHex(dec)
    return string.format("%X", dec)
end

function convertHex6To4(hex)
    hex = hex:gsub("#", "")

    local r1, r2 = hex:sub(1, 1), hex:sub(2, 2)
    local g1, g2 = hex:sub(3, 3), hex:sub(4, 4)
    local b1, b2 = hex:sub(5, 5), hex:sub(6, 6)

    local r = decToHex(math.floor((hexToDec(r1 .. r2)) / 17))
    local g = decToHex(math.floor((hexToDec(g1 .. g2)) / 17))
    local b = decToHex(math.floor((hexToDec(b1 .. b2)) / 17))
    local a = "F"

    return string.format("%s%s%s%s", r, g, b, a)
end

return function(msg, msgType, color)
    if(msgType == nil)then
        msgType = 'SYS';
    end

    if(color == nil)then
        color = "FFFF";
    else
        color = convertHex6To4(color)
    end

    local colored_text = "@{" .. color .. "}" .. tostring(msg);

    displaySystemInfo(ucstring(colored_text), tostring(msgType));
end
