local ui = require("util.ui.loot");

local M = {};

local function set(command)
    setOnDraw(ui, command);
end

function M.disable()
    setOnDraw(ui, "");
end

function M.all()
    runAH(nil, "inv_temp_all", "");
end

function M.none()
    runAH(nil, "inv_temp_none", "");
end

return M;