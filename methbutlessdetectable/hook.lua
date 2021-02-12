local Hook = hook
local hook = {}
hook.Hooks = {}
hook.iHooks = {} -- nicer for iterating

local ID = 1
function hook:Add( strEvent, strID, fCallback )
    if !self.Hooks[strEvent] then
        self.Hooks[strEvent] = {}
        self.iHooks[strEvent] = {}
    end
    self.Hooks[strEvent][strID] = {ID,fCallback}
    self.iHooks[strEvent][ID] = {ID,fCallback}
    ID = ID + 1
end

local HUDPaint = GAMEMODE.HUDPaint
function hook:Run(strEvent)
    for k,v in ipairs(self.iHooks[strEvent] or {}) do
        if strEvent == "HUDPaint" then
            GAMEMODE.HUDPaint = function(GAMEMODE)
                v[2]()
            end
            goto skip
        end
        local returnedValue = v[2]()
        if returnedValue then return returnedValue end
        ::skip::
    end
end

function hook:Remove( strEvent, strID )
    local targetID = self.Hooks[strEvent][strID][1]
    for k,v in ipairs(self.iHooks[strEvent]) do
        if v[1] == targetID then
            table.remove(self.iHooks[strEvent],k)
            break
        end
    end
    self.Hooks[strEvent][strID] = nil
end

local GAMEMODE = GAMEMODE
local THINK = GAMEMODE.Think
GAMEMODE.Think = function(GAMEMODE) -- less memory used if GAMEMODE passed manually
    hook.Run(hook,"Think")  -- same with hook
    THINK(GAMEMODE)
end


local POSTDRAWOPAQUERENDERABLES = GAMEMODE.PostDrawOpaqueRenderables
GAMEMODE.PostDrawOpaqueRenderables = function(GAMEMODE)
    hook.Run(hook,"PostDrawOpaqueRenderables")
    POSTDRAWOPAQUERENDERABLES(GAMEMODE)
end

local timer = {timers = {}}
function timer:Create(strID, iDelay, iReps, fCallback)
    self.timers[strID] = {iDelay,iReps,fCallback,0,0}
end
function timer:Remove(strID)
    self.timers[strID] = nil
end
hook:Add("Think","__TIMER__LIB__",function()
    local iTime = CurTime()
    for k,v in pairs(timer.timers) do
        if (iTime - v[4]) > v[1] then
            if v[2] ~= 0 then
                if v[5] >= v[2] then timer.timers[k] = nil break end
            end
            v[3]()
            v[4] = iTime
            v[5] = v[5] + 1
        end
    end
end)

return hook,timer