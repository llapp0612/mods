local id = require("util.ui.inventory.pa0.items.id");

local M = {};

function M.slot(slot)
    local slot_id = id .. ":" .. tostring(slot);

    return getUI(slot_id);
end

return M;
