if(package_path_native == nil)then
    package_path_native = package.path

    package.path = package.path .. ';./user/mods/?.lua;./user/mods/?/init.lua;./data/?.lua;./data/?/init.lua'
end

local printClient = require('util.print')
local reload = require('util.reload')
_G.reload = reload

require('autoload')

if(print_native == nil)then
    print_native = print

    print = printClient
end

function listLuaFiles(folderPath)
    local files = {}
    local command

    if(package.config:sub(1, 1) == '\\')then
        -- Windows
        command = 'dir "' .. folderPath .. '" /s /b /a-d *.lua'
    else
        -- Unix-based systems (Linux, macOS)
        command = 'find "' .. folderPath .. '" -type f -name "*.lua"'
    end

    local p = io.popen(command)
    for file in p:lines() do
        table.insert(files, file)
    end
    p:close()
    return files
end

local modsFolderPath = "./user/mods/"

local luaFiles = listLuaFiles(modsFolderPath)

print("Geladene Module im 'mods'-Ordner und seinen Unterordnern:", "#76EE00")
for _, file in ipairs(luaFiles) do
    local _, startIndex = file:find("\\Ryzom\\")
    if(file:sub(-4) == ".lua")then
        if(startIndex)then
            print(file:sub(startIndex + 1), "#76EE00")
        else
            print(file, "#76EE00")
        end
    end
end