local printChat = require("util.print.chat");
local color = require("util.console.color");

local M = {};

local function stdout(color, msg)
    printChat(msg, "SYS", color);
end

function M.log(msg)
    stdout(color.log, msg);
end

function M.info(msg)
    stdout(color.info, msg);
end

function M.warn(msg)
    stdout(color.warn, msg);
end

function M.error(msg)
    stdout(color.error, msg);
end

function M.assert(test, msg)
    if (not test) then
        local text = "Assertion Error";
        if (msg ~= nil) then
            text = text .. ": " .. msg;
        end

        M.error(text);
    end
end

return M;