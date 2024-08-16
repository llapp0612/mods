local M = {};

function M.exist()
    return true
end

function M.readFile(fileName)
    local file = assert(io.open(fileName, "r"))
    local content = file:read("*all")
    file:close()
    return content
end

function M.fileExists(fileName)
    local file = io.open(fileName, "r")
    if(file)then
        file:close()
        return true
    else
        return false
    end
end

return M;