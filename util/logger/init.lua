local console = require("util.console");
local print = require("util.print");

local LogLevel = require("util.logger.level");

local M = {
    level = LogLevel
};

M.currentLevel = LogLevel.DEBUG;

function M.log(level, msg, location)
    console.assert(LogLevel.OFF < level, "Invalid LogLevel: OFF >= " .. tostring(level));
    console.assert(LogLevel.ALL > level, "Invalid LogLevel: ALL <= " .. tostring(level));

    if ( location == nil ) then
        location = "Unknown";
    end

    if (level <= M.currentLevel) then
        local line = location .. " : " .. msg;
        print( line );
    end
end

return M;