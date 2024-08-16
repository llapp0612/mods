local thread = require("util.thread")
local lib = require("util.lib")
local config = require("tools.autobars.config")
local print = require("util.print")
local color = require("util.print.color")

local location = "tools.autobars"

local M = {}

function M.exist()
    return true
end
-------------------------------------------------------------------
function M.autoload()
    return true
end
-------------------------------------------------------------------
function M.setShortcutBars()
    thread.register("inGame", function()
        local cTc = nltime.getLocalTime() / 1000
	    M.luc = M.luc or 0

        if(cTc - M.luc > 1)then
		    M.luc = cTc

            if(isInGame())then
                lib.selectShortcutBar(config.bar_1, 1)
                lib.selectShortcutBar(config.bar_2, 2)

                print("Setup ShortcutBars", color.orange)
                print("ShortcutBar -> " .. config.bar_1 .. " - ShortcutBar2 -> " .. config.bar_2, color.orange)

                thread.unregister("inGame")
            end
        end
    end)
end
-------------------------------------------------------------------
M.setShortcutBars()
-------------------------------------------------------------------
return M