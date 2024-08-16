local json = require("util.dkjson.dkjson")
local file = require("map.mapmarker.file")
local mapMarkerPath = "./user/mods/map/mapmarker/json/"
local location = "map.mapmarker.setup"

local json_ext = "json"
local png_ext = "png"
local tga_ext = "tga"

local boss = mapMarkerPath .. "Boss." .. json_ext
local dolak = mapMarkerPath .. "Dolak." .. json_ext
local mat = mapMarkerPath .. "Mat." .. json_ext
local tp = mapMarkerPath .. "TP." .. json_ext
local portal = mapMarkerPath .. "Portal." .. json_ext

local icon = {
    "skull_icon_16." .. tga_ext,
    "red_dot_6." .. png_ext,
    "faction_ranger_16." .. png_ext,
    "faction_kami_16." .. png_ext,
    "faction_karavan_16." .. png_ext,
    "faction_marauder_16." .. png_ext,
    "mp_amber_16." .. png_ext,
    "mp_bark_16." .. png_ext,
    "mp_fiber_16." .. png_ext,
    "mp_oil_16." .. png_ext,
    "mp_resin_16." .. png_ext,
    "mp_sap_16." .. png_ext,
    "mp_seed_16." .. png_ext,
    "mp_shell_16." .. png_ext,
    "mp_wood_16." .. png_ext,
    "mp_wood_node_16." .. png_ext,
    "portal_16." .. png_ext
}

local stype = {
    "Boss",
    "Dolak",
    "TP",
    "Mat",
    "Portal"
}

local function searchIcon(array, word)
    for index, value in ipairs(array) do
        if string.find(value, word) then
            return index
        end
    end
    return nil
end

local function searchInTitleAndFilterAsJSON(fileName, word)
    local results = {}
    if(file.fileExists(fileName))then
        local jsonString = file.readFile(fileName)
        local data, pos, err = json.decode(jsonString, 1, nil)

        if(err)then
            print(location .. " : Error: " .. err, "#EE3B3B")
        else
            local combinedJson = "{\n"
            local isFirstFaction = true

            for faction, factionData in pairs(data) do
                --if(faction == "sources" or faction == "terre")then
                    if(not isFirstFaction)then
                        combinedJson = combinedJson .. ",\n"
                    end
                    isFirstFaction = false

                    combinedJson = combinedJson .. string.format('    "%s": {\n', faction)
                    local isFirstEntry = true

                    for id, entry in pairs(factionData) do
                        if entry.title and string.find(entry.title, word) then
                            if not isFirstEntry then
                                combinedJson = combinedJson .. ",\n"
                            end
                            isFirstEntry = false

                            combinedJson = combinedJson .. string.format('        "%s": {\n', id)
                            combinedJson = combinedJson .. string.format('            "type": %d,\n', entry.type)
                            combinedJson = combinedJson .. string.format('            "x": "%s",\n', entry.x)
                            combinedJson = combinedJson .. string.format('            "y": "%s",\n', entry.y)
                            combinedJson = combinedJson .. string.format('            "title": "%s"\n', entry.title)
                            combinedJson = combinedJson .. "        }"
                        end
                    end

                    combinedJson = combinedJson .. "\n    }"
                --end
            end

            combinedJson = combinedJson .. "\n}\n"

            return combinedJson
        end
    end
end


return {
    {boss, "Bossspawn", icon[searchIcon(icon, "skull")], stype[1]},
    {dolak, "Dolak", icon[searchIcon(icon, "red_dot")], stype[2]},
    {portal, "Tryker_Portal", icon[searchIcon(icon, "portal")], stype[5]},

    {searchInTitleAndFilterAsJSON(tp, "Ranger"), "TP" .. "_" .. "Ranger", icon[searchIcon(icon, "ranger")], stype[3]},
    {searchInTitleAndFilterAsJSON(tp, "Kami"), "TP" .. "_" .. "Kami", icon[searchIcon(icon, "kami")], stype[3]},
    {searchInTitleAndFilterAsJSON(tp, "Karavan"), "TP" .. "_" .. "Karavan", icon[searchIcon(icon, "karavan")], stype[3]},
    {searchInTitleAndFilterAsJSON(tp, "Marodeur"), "TP" .. "_" .. "Marauder", icon[searchIcon(icon, "marauder")], stype[3]},

    {searchInTitleAndFilterAsJSON(mat, "Buo"), "Fiber", icon[searchIcon(icon, "fiber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Anete"), "Fiber", icon[searchIcon(icon, "fiber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Dzao"), "Fiber", icon[searchIcon(icon, "fiber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Shu"), "Fiber", icon[searchIcon(icon, "fiber")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Beng"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Hash"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Pha"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Sha"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Soo"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Zun"), "Amber", icon[searchIcon(icon, "amber")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Adriel"), "Bark", icon[searchIcon(icon, "bark")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Beckers"), "Bark", icon[searchIcon(icon, "bark")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Mitexi"), "Bark", icon[searchIcon(icon, "bark")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Oath"), "Bark", icon[searchIcon(icon, "bark")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Perfling"), "Bark", icon[searchIcon(icon, "bark")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Gulatch"), "Oil", icon[searchIcon(icon, "oil")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Irin"), "Oil", icon[searchIcon(icon, "oil")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Koorin"), "Oil", icon[searchIcon(icon, "oil")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Pilan"), "Oil", icon[searchIcon(icon, "oil")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Dung"), "Resin", icon[searchIcon(icon, "resin")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Fung"), "Resin", icon[searchIcon(icon, "resin")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Glue"), "Resin", icon[searchIcon(icon, "resin")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Moon"), "Resin", icon[searchIcon(icon, "resin")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Dante"), "Sap", icon[searchIcon(icon, "sap")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Enola"), "Sap", icon[searchIcon(icon, "sap")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Redhot"), "Sap", icon[searchIcon(icon, "sap")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Silverweed"), "Sap", icon[searchIcon(icon, "sap")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Visc"), "Sap", icon[searchIcon(icon, "sap")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Caprice"), "Seed", icon[searchIcon(icon, "seed")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Sarina"), "Seed", icon[searchIcon(icon, "seed")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Saurona"), "Seed", icon[searchIcon(icon, "seed")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Silvio"), "Seed", icon[searchIcon(icon, "seed")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Big"), "Shell", icon[searchIcon(icon, "shell")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Cuty"), "Shell", icon[searchIcon(icon, "shell")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Horny"), "Shell", icon[searchIcon(icon, "shell")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Smart"), "Shell", icon[searchIcon(icon, "shell")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Splinter"), "Shell", icon[searchIcon(icon, "shell")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Abhaya"), "Wood", icon[searchIcon(icon, "wood")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Eyota"), "Wood", icon[searchIcon(icon, "wood")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Kachine"), "Wood", icon[searchIcon(icon, "wood")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Motega"), "Wood", icon[searchIcon(icon, "wood")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Tama"), "Wood", icon[searchIcon(icon, "wood")], stype[4]},

    {searchInTitleAndFilterAsJSON(mat, "Nita"), "Wood_Node", icon[searchIcon(icon, "wood_node")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Patee"), "Wood_Node", icon[searchIcon(icon, "wood_node")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Scrath"), "Wood_Node", icon[searchIcon(icon, "wood_node")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Tansy"), "Wood_Node", icon[searchIcon(icon, "wood_node")], stype[4]},
    {searchInTitleAndFilterAsJSON(mat, "Yana"), "Wood_Node", icon[searchIcon(icon, "wood_node")], stype[4]}
}