local print = require("util.print")
local color = require("util.print.color")
local thread = require("util.thread")
local lib = require("util.lib")
local interface = require("util.ui.id")

local enabled = false;
local location = "tools.scanner"
local state = nil
local entity = {}

local named = require("tools.scanner.list.named")
local boss = require("tools.scanner.list.boss")
local pat = require("tools.scanner.list.pat")
local egg = require("tools.scanner.list.egg")

local sounds = {"bam", "baaam"}
local sounds2 = {"holyshit", "godlike", "finishhim", "ownage", "prepare", "unstoppable", "wickedsick"}
local seen = {}
local oldTarget = ""

-------------------------------------------------------------------
local M = {}

M.alarmTriggered = false

function M.exist()
    return true
end

-------------------------------------------------------------------
function M.doScan()
    if(state == nil)then M.disable() end
	if(state == 1)then entity = boss end
	if(state == 2)then entity = named end
	if(state == 3)then entity = pat end
    if(state == 4)then entity = egg end
    if(entity == nil)then return end

    -- cTc is the current time clock, luc is last update time clock
    local cTc = nltime.getLocalTime() / 1000
	M.luc = M.luc or 0
    if(cTc - M.luc > 5)then
		M.luc = cTc
		M.alarmTriggered = false
		local validTar = false

		if(isTargetPlayer() or isTargetNPC())then
            oldTarget = getTargetName()
		end

		for k, v in pairs(entity) do
		    if(v ~= '' or v ~= nil)then
		        runAH(nil,  'target', 'entity='.. v .. '|quiet=true')

				if(state == 3)then
					M.PatFinder(entity)
				else
					M.Finder(entity)
				end
			end
		end

		if(state == 3 and not M.alarmTriggered)then
		    if(M.countTrue(seen) < 4)then
			    seen = {}
			    validTar = true
		    end
		elseif(isTargetPlayer() or isTargetNPC())then
			validTar = true
	    end

		if(validTar)then
			if(oldTarget ~= "")then
				runAH(nil,  'target', 'entity=' .. oldTarget .. '|quiet=true')
				oldTarget = ""
			else
				runAH(nil, 'no_target', '')
			end
		end
	end
end

-------------------------------------------------------------------
function M.Finder(ent)
    for k,v in pairs(ent) do
	    if(getTargetName() == v)then
			print('ALARM! ' .. v .. ' in ' .. lib.getTargetDistance() .. 'm.', color.turquoise, 'BC')
			M.playSound(sounds2)
			M.reset()
		end
	end
end
-------------------------------------------------------------------
function M.PatFinder(ent)
	for k,v in pairs(ent) do
	    if(getTargetName() == v and not seen[v])then
            seen[v] = true

			if(M.countTrue(seen) >= 4)then
				M.alarmTriggered = true
				print('ALARM! Patrouille in ' .. lib.getTargetDistance() .. 'm.', color.turquoise, 'BC')
				M.playSound(sounds)
                M.reset()
			end			
		end
	end
end
-------------------------------------------------------------------
function M.playSound(sound)
	lib.playSound(sound[math.random(#sound)] .. ".ogg")
end
-------------------------------------------------------------------
function M.countTrue(saw)
    local count = 0

    for k, v in pairs(saw) do
        if(v)then
            count = count + 1
        end
    end

    return count
end
-------------------------------------------------------------------
function M.reset()
    M.disable()
	oldTarget = ""
	entity = {}
	state = nil
	seen = {}
	enabled = false
end

-------------------------------------------------------------------
function M.StateC()
    local v
    if(state == 1)then v = "Boss scan" end
	if(state == 2)then v = "Named scan" end
	if(state == 3)then v = "Pat scan" end
    if(state == 4)then v = "Egg scan" end
	if(state == nil)then v = "Scanner" end
	return v
end

-------------------------------------------------------------------
function M.enable()
    thread.register("scanner", function() M.doScan() end)

    print(location .. " : " .. M.StateC() .. " activated", color.green, "BC")
end

-------------------------------------------------------------------
function M.disable()
	if(thread.exist("scanner"))then
        thread.unregister('scanner')
	end

    print(location .. " : " .. M.StateC() .. " deactivated", color.red, "BC")
end

-------------------------------------------------------------------
function M.scan(val)
	if(enabled)then
        M.disable()
		state = nil
		enabled = false
    else
		state = val
        M.enable()
		enabled = true
	end
end
-------------------------------------------------------------------
if(thread.exist("scanner"))then
    M.disable()
end
-------------------------------------------------------------------
return M