local print = require("util.print")
local json = require("util.dkjson.dkjson")
local file = require("map.mapmarker.file")
local chat = require("util.print.chat")
local location = "map.mapmarker"
local parseParameters = require(location .. ".setup")

if(game==nil)then
	game = {}
end

----------------------------------------------------------------------------------------------------------------
local function splitString(inputstr, sep)
    if(sep == nil)then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

----------------------------------------------------------------------------------------------------------------
function setMarker(arr, desc, icon, stype)
    for faction, factionData in pairs(arr) do
        for key, pos in pairs(factionData) do
            local title = pos.title --.. "\n\nx: " .. pos.x .. "\ny: " .. pos.y

            if(stype == "Boss")then
                --title = string.gsub(pos.title, "/", " ")
                title = ""
            end

            if(stype == "Mat")then
                pos.title = string.gsub(pos.title, "%f[%a]Sp%f[%A]", "Spring")
                pos.title = string.gsub(pos.title, "%f[%a]Su%f[%A]", "Summer")
                pos.title = string.gsub(pos.title, "%f[%a]Au%f[%A]", "Autumn")
                pos.title = string.gsub(pos.title, "%f[%a]Wi%f[%A]", "Winter")
                pos.title = string.gsub(pos.title, "%-+", "No Data")

                local stp = splitString(pos.title, "/")

                title = string.format("@{%s}%s\n\n@{%s}%s\n Weather:%s\n\n@{%s}%s\n Weather:%s",
                    convertHex6To4("#E0FFFF"), stp[2],
                    convertHex6To4("#7fff00"), stp[3], stp[4],
                    convertHex6To4("#FFFF00"), stp[5], stp[6])

                if(faction == "sources")then
                    title = string.format("@{%s} %s\n\n@{%s}%s\n Weather:%s\n\n@{%s}%s\n Weather:%s\n\n@{%s}%s\n Weather:%s",
                        convertHex6To4("#E0FFFF"), stp[1],
                        convertHex6To4("#7fff00"), stp[2], stp[3],
                        convertHex6To4("#FFFF00"), stp[4], stp[5],
                        convertHex6To4("#FFFFFF"), stp[6], stp[7])
                end
            end

            game:addMapArkPoint(desc, tonumber(pos.x), tonumber(pos.y), key, title, icon)
        end
    end
end


----------------------------------------------------------------------------------------------------------------
local function decodeJSON(input)
    local success, data = pcall(json.decode, input)
    if(success)then
        return data
    else
        return nil, data
    end
end

----------------------------------------------------------------------------------------------------------------
local function parseJSON(input, menuName, icon, stype)
    local data

    if(file.fileExists(input))then
        local jsonString = file.readFile(input)
        if(jsonString)then
            data, err = decodeJSON(jsonString)
            if(not data)then
                print(location .. " : Fehler beim Decodieren der JSON-Datei '" .. input .. "': " .. err, "#EE3B3B")
                return
            end
        else
            print(location .. " : Fehler beim Lesen der Datei '" .. input .. "'", "#EE3B3B")
            return
        end
    else
        data, err = decodeJSON(input)
        if(not data)then
            print(location .. " : Fehler beim Decodieren des JSON-Strings", "#EE3B3B")
            return
        end
    end

    if(data)then
        setMarker(data, menuName, icon, stype)
    else
        print(location .. " : Fehler beim Verarbeiten der JSON-Daten", "#EE3B3B")
    end
end

----------------------------------------------------------------------------------------------------------------
for _, params in ipairs(parseParameters) do
    parseJSON(params[1], params[2], params[3], params[4])
end

----------------------------------------------------------------------------------------------------------------
local M = {};

function M.exist()
    return true
end
----------------------------------------------------------------------------------------------------------------
function M.getPlayerPosition()
    local x, y, z = getPlayerPos()

    print("x: " .. x, "#FFA500")
    print("y: " .. y, "#FFA500")
end
----------------------------------------------------------------------------------------------------------------
return M;