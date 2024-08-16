--[[return function( module )
    package.loaded[ module ] = nil;

    return require(module);
end]]

return function(moduleName)
    local modsPath = "/user/mods/"

    local function isModInModsPath(moduleName)
        local modulePath = package.searchpath(moduleName, package.path)
        return modulePath and modulePath:find(modsPath, 1, true)
    end

    if(moduleName)then
        if(isModInModsPath(moduleName) and moduleName ~= "util.thread")then
            print("Neuladen des Moduls: " .. moduleName)

            package.loaded[moduleName] = nil

            local success, reloadedModule = pcall(require, moduleName)

            if(success)then
                print("Modul " .. moduleName .. " erfolgreich neu geladen", "#00EE00")
                return reloadedModule
            else
                print("Fehler beim Neuladen des Moduls: " .. moduleName .. " - " .. reloadedModule, "#EE3B3B")
                return nil
            end
        else
            print("Modul " .. moduleName .. " befindet sich nicht im '" .. modsPath .. "' Verzeichnis", "#EE3B3B")
            return nil
        end
    else
        for loadedModuleName in pairs(package.loaded) do
            if(isModInModsPath(loadedModuleName) and loadedModuleName ~= "util.thread")then
                print("Neuladen des Moduls: " .. loadedModuleName)
                package.loaded[loadedModuleName] = nil

                local success, reloadedModule = pcall(require, loadedModuleName)

                if(success)then
                    print("Modul " .. loadedModuleName .. " erfolgreich neu geladen", "#00EE00")
                else
                    print("Fehler beim Neuladen des Moduls: " .. loadedModuleName .. " - " .. reloadedModule, "#EE3B3B")
                end
            end
        end
    end
end

--[[return function(moduleName)
    if(package.searchpath(moduleName, package.path))then
        print("Neuladen des Moduls: " .. moduleName, "#00EE00")

        package.loaded[moduleName] = nil

        local success, reloadedModule = pcall(require, moduleName)

        if(success)then
            print("Modul " .. moduleName .. " erfolgreich neu geladen", "#00EE00")
            return reloadedModule
        else
            print("Fehler beim Neu laden des Moduls: " .. moduleName, "#EE3B3B")
            return nil
        end
    else
        print("Modul " .. moduleName .. "nicht gefunden im package.path", "#EE3B3B")
        return nil
    end
end]]

