local location = "util.lib";
local interface = require("util.ui.id");

local uiVars = "UI:VARIABLES"
local teamUI = uiVars ..":BARS:TEAM"
local targetUI = uiVars ..":BARS:TARGET"
local statsUI = {"HP", "SAP", "STA"}
local defaultStat = 1.27;

local M = {}

function M.exist()
    return true
end

-------------------------------------------------------------------
-- the follow command
-------------------------------------------------------------------
function M.follow()
    runAH(nil, "talk", "mode=0|text=/follow");
end
-------------------------------------------------------------------
-- plays an ogg soundfile
-------------------------------------------------------------------
function M.playSound(file)
	runAH(nil, "play_event_music", "music=" .. file)
end
-------------------------------------------------------------------
-- get the stats of teammember per id - hp, sap, st
-------------------------------------------------------------------
function M.getTeamMemberStats(id)
    local values = {}

    for _, stat in ipairs(statsUI) do
        values[stat:lower()] = (tonumber(getDbProp(teamUI .. ":" .. tostring(id) .. ":" .. stat)) / defaultStat) or 0
    end

    return values
end
-------------------------------------------------------------------
-- get a valid teammember count
-------------------------------------------------------------------
function M.getTeamMemberCount()
    local numTeamMembers = -1;

    for i = 0, 7 do
        local stats = M.getTeamMemberStats(i)
        local present = getDbProp("SERVER:GROUP:" .. tostring(i) .. ":PRESENT")

        if(stats.hp ~= 0 and stats.sap ~= 0 and stats.sta ~= 0 and present ~= 0)then
            numTeamMembers = i
        end
    end

    return numTeamMembers
end
-------------------------------------------------------------------
-- get the 3d vector from i64
-------------------------------------------------------------------
function M.getPos(encodedValue)
    local x = encodedValue >> 32
    local y = (encodedValue - (x << 32)) - (2^32)

    local scaleFactor = 1000.0
    x = x / scaleFactor
    y = y / scaleFactor
    z = getGroundZ(x, y)

    return {x = x, y = y, z = z}
end
-------------------------------------------------------------------
-- get the distance between player an pos
-------------------------------------------------------------------
function M.getPosDistance(pos)
    local function round(x)
        return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
    end

    local px, py, pz = getPlayerPos()
    local tx, ty, tz = pos.x, pos.y, pos.z

    local dx = tx - px
    local dy = ty - py
    local dz = tz - pz

    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    return round(distance)
end
-------------------------------------------------------------------
-- get the stats of the target - hp, sap, sta
-------------------------------------------------------------------
function M.getTargetStats()
    local values = {}

    for _, stat in ipairs(statsUI) do
        values[stat:lower()] = (tonumber(getDbProp(targetUI .. ":"  .. stat)) / defaultStat) or 0
    end

    return values
end
-------------------------------------------------------------------
-- get the name of a teammember per teammember id
-------------------------------------------------------------------
function M.getTeamMemberName(id)
    return getUI(interface .. ":team_list_" .. id).title
end
-------------------------------------------------------------------
-- get the distance between player and target
-------------------------------------------------------------------
function M.getTargetDistance()
    local function round(x)
        return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
    end

    local px, py, pz = getPlayerPos()
    local tx, ty, tz = getTargetPos()

    local dx = tx - px
    local dy = ty - py
    local dz = tz - pz

    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    return round(distance)
end
-------------------------------------------------------------------
-- set the teammember as target per teammember id
-------------------------------------------------------------------
function M.targetTeamMate(id)
    if((id >= 1) and (id <= 8))then
        runAH(nil, "target_teammate_shortcut", "indexInTeam=" .. id);
    end
end
-------------------------------------------------------------------
-- set a target without sysinfo log
-------------------------------------------------------------------
function M.setTarget(name)
    if(name ~= nil or name ~= "")then
        runCommand('tarq', tostring(name));
    end
end
-------------------------------------------------------------------
-- run a shortcut in shortcutbar
-------------------------------------------------------------------
function M.runShortcut(number)
    if((number >= 1) and (number <= 40))then
        runAH(nil, "run_shortcut", number - 1);
    end
end
-------------------------------------------------------------------
-- set the shortcutbar
-------------------------------------------------------------------
function M.selectShortcutBar(number, barType)
    if (number >= 1 and number <= 10) then
        local command = barType == 2 and "select_shortcut_bar_2" or "select_shortcut_bar"
        runAH(nil, command, number)
    end
end
-------------------------------------------------------------------
-- get the player hp value in percent
-------------------------------------------------------------------
function getHpInPercent()
    local ui = getUI('ui:interface:player')
    local plyHp = tonumber(ui:find('jlife'):find('val').text)
    local plyHpMax = tonumber(ui:find('jlife'):find('max').text)

    return math.floor((plyHp / plyHpMax) * 100)
end
-------------------------------------------------------------------
-- get the target
-------------------------------------------------------------------
function M.getTarget()
    return getUI(interface .. ":target");
end
-------------------------------------------------------------------
-- get the name of the target
-------------------------------------------------------------------
function M.getTargetName()
    return M.getTarget().title;
end
-------------------------------------------------------------------
-- using to show in chat and on screen
-------------------------------------------------------------------
function M.sysinfo(txt, mtd)
    if(mtd == nil)then mtd = 'SYS' end;
    displaySystemInfo(ucstring(tostring(txt)), mtd);
end
-------------------------------------------------------------------
-- splits a string
-------------------------------------------------------------------
function M.split(s,t)
	local l={n=0};
	local f=function(s)
		l.n=l.n+1;
		l[l.n]=s;
	end
	local p="%s*(.-)%s*"..t.."%s*";
	s=string.gsub(s,"^%s+","");
	s=string.gsub(s,"%s+$","");
	s=string.gsub(s,p,f);
	l.n=l.n+1;
	l[l.n]=string.gsub(s,"(%s%s*)$","");
	return l
end
-------------------------------------------------------------------
return M