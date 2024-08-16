local id = require("util.ui.inventory.bag.items.id");

local M = {};

function M.slot(slot)
    local slot_id = id .. ":" .. tostring(slot);

    return getUI(slot_id);
end

return M;
