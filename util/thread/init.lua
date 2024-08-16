local logger = require("util.logger");
local print = require("util.print");
local ui = require("util.ui.player");

local M = {};
local location = "util.thread";
local function log(level, msg)
    logger.log(level, msg, location);
end

local threads = {};
local callbacks = {};

local function tick()
    for i, callback in pairs(threads) do
        callback();
    end
end

local function registerDrawListener()
    if (ui ~= nil) then
        _G.thread_tick = tick;
        setOnDraw(ui, "thread_tick()");
        print(location .. ": registered draw listener");
    else
        print(location .. ": could not get ui");
    end
end

registerDrawListener();

-------------------------------------------------------------------
-- adds a function to the threadtable wich are called every frame
-- @param name of the function
-- @param callback the function
function M.register(name, callback)
    threads[name] = callback;
end

-------------------------------------------------------------------
-- removes a function from the threadtable
-- @param name of the function to remove
function M.unregister(name)
    threads[name] = nil;
end

-------------------------------------------------------------------
-- checks if a thread exists in the threadtable
-- @param name of the thread to check
-- @return boolean indicating whether the thread exists
function M.exist(name)
    local exist = false
    if(threads[name] ~= nil)then
        exist = true
    end

    return exist
end

-------------------------------------------------------------------
-- adds a function to the threadtable wich are called every frame
-- @param callback the function
function M.add(callback)
    table.insert(callbacks, callback);
end

-------------------------------------------------------------------
local function find(callback)
    for i, entry in ipairs(callbacks) do
        if (callback == entry) then
            return i;
        end
    end

    return 0;
end

-------------------------------------------------------------------
-- removes a function from the threadtable
-- @param name of the function to remove
function M.remove(callback)
    local pos = find(callback);
    if (pos > 0) then
        table.remove(callbacks, pos);
    else
        log(logger.level.WARN, "callback not found");
    end
end


return M;