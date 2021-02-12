local x = ScrW()/2 - 1
local y = ScrH()/2 - 1


local gap = 4
local size = 8 + gap

local lasthit = 0
local duration = 0.8
hook.Add("HUDPaint","methamphetamine.hitmarker",function()
    if CurTime() - lasthit < duration then
        surface.SetDrawColor( Color(255,255,255, (1 - ((CurTime() - lasthit)/duration)) * 255 ) )
        surface.DrawLine(x - size, y - size, x - gap, y - gap)
        surface.DrawLine(x - size, y + size, x - gap, y + gap)
        surface.DrawLine(x + size, y - size, x + gap, y - gap)
        surface.DrawLine(x + size, y + size, x + gap, y + gap)
    end
end)

local LocalPlayer = LocalPlayer()
gameevent.Listen( "player_hurt" )
hook.Add( "player_hurt", "player_hurt_example", function( data ) 
    if Player(data.attacker) == LocalPlayer then
        lasthit = CurTime()
        print( lasthit )
    end
end )