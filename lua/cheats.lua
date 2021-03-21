--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
]]--


methamphetamine = methamphetamine or {}
methamphetamine.adminspectators = {}
methamphetamine.ragevictims = {}
methamphetamine.limbs = {
    ["Head"] = "ValveBiped.Bip01_Head1",
    ["Spine"] = "ValveBiped.Bip01_Spine",
}

methamphetamine.bones = {
    "ValveBiped.Bip01_Head1",
    "ValveBiped.Bip01_Neck1",
    "ValveBiped.Bip01_Spine4",
    "ValveBiped.Bip01_Spine2",
    "ValveBiped.Bip01_Spine1",
    "ValveBiped.Bip01_Spine",
    "ValveBiped.Bip01_Pelvis",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_R_Thigh",
    "ValveBiped.Bip01_R_Calf",
    "ValveBiped.Bip01_R_Foot",
    "ValveBiped.Bip01_R_Toe0",
    "ValveBiped.Bip01_L_Thigh",
    "ValveBiped.Bip01_L_Calf",
    "ValveBiped.Bip01_L_Foot",
    "ValveBiped.Bip01_L_Toe0"  
}

local LocalPlayer = LocalPlayer()

local function meth_getPlayers()
    return player.GetAll()
end

methamphetamine.screengrab = false
methamphetamine.lastscreengrab = 0
local renderv = render.RenderView
local renderc = render.Clear
local rendercap = render.Capture
local vguiworldpanel = vgui.GetWorldPanel

local function screengrab()
	if methamphetamine.screengrab then return end
    methamphetamine.screengrab = true
    surface.PlaySound("physics/metal/paintcan_impact_soft1.wav")
    methamphetamine.lastscreengrab = CurTime()
    print("screen grabbed")
    
 
	renderc( 0, 0, 0, 255, true, true )
	renderv( {
		origin = LocalPlayer:EyePos(),
		angles = LocalPlayer:EyeAngles(),
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH(),
		dopostprocess = true,
		drawhud = true,
		drawmonitors = true,
		drawviewmodel = true
	} )
 
	local vguishits = vguiworldpanel()
 
	if IsValid( vguishits ) then
		vguishits:SetPaintedManually( true )
	end
 
	timer.Simple( 0.1, function()
		vguiworldpanel():SetPaintedManually( false )
		methamphetamine.screengrab = false
	end)
end
 
render.Capture = function(data)
	screengrab()
	local cap = rendercap( data )
	return cap
end
local string_find = string.find
local function screengrab_str(str)
    str = string.lower(str)
    if string_find(str,"screengrab") then return true end
    if string_find(str,"grab") then return true end
    if string_find(str,"scren") then return true end
    if string_find(str,"cheat") then return true end
    if string_find(str,"anti") then return true end
    if string_find(str,"hack") then return true end
    return false
end

concommand.Add("screenshot",function()
    methamphetamine.screengrab = true
    timer.Simple(0.1,function() methamphetamine.screengrab = false end)
end)

local _compress = util.Compress
function util.Compress( str )
    methamphetamine.screengrab = true
    if screengrab_str( str ) then
        methamphetamine.lastscreengrab = CurTime()
    end
    timer.Simple(0.1,function() methamphetamine.screengrab = false end)
    return _compress(str)
end

local _writedata = net.WriteData
function net.WriteData( data,size )
    methamphetamine.screengrab = true
    timer.Simple(0.1,function() methamphetamine.screengrab = false end)
    return _writedata(data,size)
end

-- local _netstart = net.Start
-- function net.Start( str )
--     methamphetamine.screengrab = true
--     methamphetamine.lastscreengrab = CurTime()
--     methamphetamine.screengrab = false
--     return _netstart(str)
-- end

function methamphetamine:CheckForSpectators()
    local targets = {}
    for k , v in ipairs(meth_getPlayers()) do
        if v:GetObserverTarget() == LocalPlayer then
            targets[#targets+1] = v
        end
    end
    methamphetamine.adminspectators = targets
    methamphetamine.Log("Checking for spectators")
    return targets
end

timer.Create("methamphetamine.adminspectatorscheck", 6 , 0 , methamphetamine.CheckForSpectators )

function  methamphetamine:IsPlayerWithinFOV( player , fov )
    if not player then return false end
 
    if LocalPlayer:GetEyeTraceNoCursor().Entity == player then return true end

    --local fov = (methamphetamine.mods["Aim"].FOV / 30)
    --print( fov )
    -- local CurAngle = LocalPlayer:EyeAngles()
    -- local CurPos = LocalPlayer:GetShootPos()

    -- local AimSpot = player:GetBonePosition(player:LookupBone(methamphetamine.bones[1]))

    -- local FinAngle = ( AimSpot - CurPos ):Angle()
    -- if FinAngle.y > 180 then
    --     FinAngle.y = FinAngle.y-360
    -- end

    -- local CalcX = FinAngle.y - CurAngle.y
    -- local CalcY = FinAngle.x - CurAngle.x
    -- if CalcY < 0 then CalcY = CalcY * -1 end
    -- if CalcX < 0 then CalcX = CalcX * -1 end
    -- if CalcY > 180 then CalcY = 360 - CalcY end
    -- if CalcX > 180 then CalcX = 360 - CalcX end
    -- if CalcX <= fov/2 && CalcY <= fov*0.4 then
    --     return true 
    -- end

    local head = player:LookupBone("ValveBiped.Bip01_Head1")  

    local headpos,headang = player:GetBonePosition(head or 1) 

    local spine = player:LookupBone("ValveBiped.Bip01_Spine1") 
    local spinepos,spineang = player:GetBonePosition(spine or 1) 

    local shootpos = LocalPlayer:GetShootPos()

    --print("FOV : ", fov )
    if IsValid( spinepos ) then
        if (LocalPlayer:GetAimVector():Dot( player:GetPos() - shootpos ) / ( player:GetPos() - shootpos ):Length() >= (fov or 0.997)) then --or
            -- (LocalPlayer:GetAimVector():Dot( headpos - shootpos ) / ( headpos - shootpos ):Length() >= (fov or 0.997)) or
            -- (LocalPlayer:GetAimVector():Dot( spinepos - shootpos ) / ( spinepos - shootpos ):Length() >= (fov or 0.997)) then
            return true
        end
        else
            if (LocalPlayer:GetAimVector():Dot( player:GetPos() - shootpos ) / ( player:GetPos() - shootpos ):Length() >= (fov or 0.997)) then return true end

        end

    return false
end

function  methamphetamine:GetClosestPlayer()
    local ply

    local tTargets = {}
    for k , v in ipairs(player.GetAll()) do
        if v == LocalPlayer or not v:Alive() then goto skipTargetGathering end
        if not methamphetamine:IsPlayerWithinFOV(v,0.95) then goto skipTargetGathering end
        if methamphetamine.mods["Aim"]["Ignore"]["Friends"] then
            if methamphetamine.friends[v] then goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Noclipping"] then
            if v:GetMoveType() == MOVETYPE_NOCLIP then goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["SelectedTeams"] then
            if methamphetamine.teams[v:Team()] then goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["OppositeTeam"] then
            if v:Team() != LocalPlayer:Team() then print("Skipping") goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["SameTeam"] then
            if v:Team() == LocalPlayer:Team() then print("SameTeam2") goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Transparent"] then
            if v:GetColor().a != 255 then goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Invisible"] then
            if v:GetNoDraw() or v:GetRenderMode() == RENDERMODE_TRANSALPHA or v:GetMaterial() ==  "models/effects/vol_light001" then goto skipTargetGathering end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Party"] then

        end

        if methamphetamine:IsPlayerWithinFOV(v,fov) then
            tTargets[#tTargets+1] = v
        end
        ::skipTargetGathering::
    end


    table.sort(tTargets,function(a,b)
        local aBonePos = a:LookupBone( self.limbs["Spine"] ) and a:GetBonePosition( a:LookupBone( self.limbs["Spine"] ) ) or a:GetPos() + a:OBBCenter()
        local bBonePos = b:LookupBone( self.limbs["Spine"] ) and b:GetBonePosition( b:LookupBone( self.limbs["Spine"] ) ) or b:GetPos() + b:OBBCenter()
        local diff = aBonePos - LocalPlayer:GetShootPos()
        local targetdiff = bBonePos - LocalPlayer:GetShootPos()
        return LocalPlayer:GetAimVector():Dot(diff) / diff:Length() > LocalPlayer:GetAimVector():Dot(targetdiff) / targetdiff:Length()
    end)

    for k,v in ipairs(tTargets) do
        if not ply then ply = v end
        if ply:GetPos():DistToSqr(LocalPlayer:GetPos()) > v:GetPos():DistToSqr(LocalPlayer:GetPos()) then ply = v end
    end

    return ply
end

function methamphetamine:AddFriendByKeyword( keyword )
    for k , v in ipairs(meth_getPlayers()) do
        if v == LocalPlayer then goto skip end
        if string.find(string.lower(v:Nick()),string.lower(keyword)) then
            methamphetamine.friends[v] = true
        end
        ::skip::
    end
end

function methamphetamine:RemoveFriendByKeyword( keyword )
    for k , v in pairs(methamphetamine.friends) do
        if string.find(string.lower(k:Nick()),string.lower(keyword)) then
            methamphetamine.friends[k] = nil
        end
    end
end

function methamphetamine:AddRageVictimByKeyword( keyword )
    for k , v in ipairs(meth_getPlayers()) do
        if v == LocalPlayer then goto skip end
        if keyword == "*" then
            methamphetamine.ragevictims[v] = true
            methamphetamine.Log("Adding rage victim ".. v:Nick() )
        elseif string.find(string.lower(v:Nick()),string.lower(keyword)) then
            methamphetamine.ragevictims[v] = true
            methamphetamine.Log("Adding rage victim ".. v:Nick() )
        end
        ::skip::
    end
end

function methamphetamine:RemoveRageVictimByKeyword( keyword )
    for k , v in pairs(methamphetamine.ragevictims) do
        if string.find(string.lower(k:Nick()),string.lower(keyword)) then
            methamphetamine.Log("Removing rage victim ".. k:Nick() )
            methamphetamine.ragevictims[k] = nil
        end
    end
end


-- concommand.Add("methamphetamine_addfriend", function( ply, cmd, args )
--     if not args[1] then return end
--     methamphetamine:AddFriendByKeyword( args[1] )
-- end)

-- concommand.Add("methamphetamine_removefriend", function( ply, cmd, args )
--     if not args[1] then return end
--     methamphetamine:RemoveFriendByKeyword( args[1] )
-- end)


function  methamphetamine:CalculateCurLimbPos( ply , limb )
    local  bone = ply:LookupBone( self.limbs[limb] )
    local bonepos,ang
    if bone then
        bonepos,ang = ply:GetBonePosition( bone ) 
    end
    if not ( bone ) then
        bonepos = ply:GetPos() + ply:OBBCenter()
    end
    
    local tarFrames, plyFrames = ( RealFrameTime() / 25 ), ( RealFrameTime() / 66 )
    return bonepos + ( ( ply:GetVelocity() * ( tarFrames ) ) - ( LocalPlayer:GetVelocity() * ( plyFrames ) ) )
end

function methamphetamine:GetClosestPlayerToCrosshair()
    local closest
    for k , v in ipairs( meth_getPlayers() ) do
        if v == LocalPlayer then goto skip end
        if not v:Alive() then goto skip end

        if methamphetamine.mods["Aim"]["Ignore"]["Friends"] then
            if methamphetamine.friends[v] then goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Noclipping"] then
            if v:GetMoveType() == MOVETYPE_NOCLIP then goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["SelectedTeams"] then
            if methamphetamine.teams[v:Team()] then goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["OppositeTeam"] then
            if v:Team() != LocalPlayer:Team() then print("Skipping") goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["SameTeam"] then
            if v:Team() == LocalPlayer:Team() then print("SameTeam2") goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Transparent"] then
            if v:GetColor().a != 255 then goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Invisible"] then
            if v:GetNoDraw() or v:GetRenderMode() == RENDERMODE_TRANSALPHA or ply:GetMaterial() ==  "models/effects/vol_light001" then goto skip end
        elseif methamphetamine.mods["Aim"]["Ignore"]["Party"] then

        end
        if not methamphetamine:IsPlayerWithinFOV(v,0.95) then goto skip end
        if not closest then closest = v end
        local bonepos = v:LookupBone( self.limbs["Spine"] ) and v:GetBonePosition( v:LookupBone( self.limbs["Spine"] ) ) or v:GetPos() + v:OBBCenter()
        local closestbonepos = closest:LookupBone( self.limbs["Spine"] ) and closest:GetBonePosition( closest:LookupBone( self.limbs["Spine"] ) ) or closest:GetPos() + closest:OBBCenter()
        local diff = bonepos - LocalPlayer:GetShootPos()
        local targetdiff = closestbonepos - LocalPlayer:GetShootPos()
        if LocalPlayer:GetAimVector():Dot(diff) / diff:Length() > LocalPlayer:GetAimVector():Dot(targetdiff) / targetdiff:Length() then
            closest = v
        end
        ::skip::
    end
    return closest
end

local AimbotTarget 
local lastautoshoot = 0

function  methamphetamine:GetPlayerWithHealth( condition,fov )
    local ply

    local tTargets = {}
    if fov then
        for k , v in ipairs(player.GetAll()) do
            if v == LocalPlayer or not v:Alive() then goto skipTargetGathering end
            if methamphetamine.mods["Aim"]["Ignore"]["Friends"] then
                if methamphetamine.friends[v] then goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["Noclipping"] then
                if v:GetMoveType() == MOVETYPE_NOCLIP then goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["SelectedTeams"] then
                if methamphetamine.teams[v:Team()] then goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["OppositeTeam"] then
                if v:Team() != LocalPlayer:Team() then print("Skipping") goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["SameTeam"] then
                if v:Team() == LocalPlayer:Team() then print("SameTeam2") goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["Transparent"] then
                if v:GetColor().a != 255 then goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["Invisible"] then
                if v:GetNoDraw() or v:GetRenderMode() == RENDERMODE_TRANSALPHA or v:GetMaterial() ==  "models/effects/vol_light001" then goto skipTargetGathering end
            elseif methamphetamine.mods["Aim"]["Ignore"]["Party"] then
    
            end

            if methamphetamine:IsPlayerWithinFOV(v,fov) then
                tTargets[#tTargets+1] = v
            end
            ::skipTargetGathering::
        end
    else
        tTargets = player.GetAll()
    end

    table.sort(tTargets,function(a,b)
        local aBonePos = a:LookupBone( self.limbs["Spine"] ) and a:GetBonePosition( a:LookupBone( self.limbs["Spine"] ) ) or a:GetPos() + a:OBBCenter()
        local bBonePos = b:LookupBone( self.limbs["Spine"] ) and b:GetBonePosition( b:LookupBone( self.limbs["Spine"] ) ) or b:GetPos() + b:OBBCenter()
        local diff = aBonePos - LocalPlayer:GetShootPos()
        local targetdiff = bBonePos - LocalPlayer:GetShootPos()
        return LocalPlayer:GetAimVector():Dot(diff) / diff:Length() > LocalPlayer:GetAimVector():Dot(targetdiff) / targetdiff:Length()
    end)

    for k,v in ipairs(tTargets) do
        if not ply then ply = v end
        if condition == "Highest" then
            if v:Health() > ply:Health() then
                ply = v
            end
        else
            if v:Health() < ply:Health() then
                ply = v
            end
        end
    end

    return ply
end

function methamphetamine.SmoothAim( ang )
    if( methamphetamine.mods["Aim"].Smooth == 0 ) then return ang end
	local speed = RealFrameTime() / ( methamphetamine.mods["Aim"].Smooth / 50 )
	local angl = LerpAngle( speed*2.5, LocalPlayer:EyeAngles(), ang )
	return Angle( angl.p, angl.y, 0 )
end

local lastautoshoot
local delay = {}
hook.Add("Think", "Aimbot", function ()
    if not methamphetamine.mods["Aim"].enabled then return end
    if methamphetamine.mods["Aim"].Rage then return end
    if not ( methamphetamine.mods["Aim"].Key ) then return end
    if not input.IsKeyDown( methamphetamine.mods["Aim"].Key ) and not input.IsMouseDown( methamphetamine.mods["Aim"].Key ) then 
        AimbotTarget = nil
        return 
    end 

    -- local target = methamphetamine:GetClosestPlayer()
    -- if not IsValid( target ) then return end
    -- LocalPlayer:SetEyeAngles( (  methamphetamine:CalculateCurLimbPos( target , "Head" ) - LocalPlayer:GetShootPos() ):Angle() )
    if AimbotTarget then
        if not AimbotTarget:Alive() then AimbotTarget = nil return end 
        if methamphetamine.mods["Aim"]["Autofire"] then
            local wep = LocalPlayer:GetActiveWeapon()
            if LocalPlayer:GetEyeTraceNoCursor().Entity == AimbotTarget then
                RunConsoleCommand("-attack")
                if CurTime() - (lastautoshoot or 0) > (delay[wep] or 0.05) then
                    RunConsoleCommand("+attack") 
                    lastautoshoot = CurTime()
                    delay[wep] = wep.FireDelay or wep.Delay or 0.05
                end
            end
           
        end
        local headpos = methamphetamine:CalculateCurLimbPos( AimbotTarget , methamphetamine.mods["Aim"].Limb )
        local targetpos =  ( headpos  - LocalPlayer:GetShootPos() ):Angle() 
        if methamphetamine.mods["Aim"]["NoRecoil"] and input.IsMouseDown( MOUSE_LEFT ) then
            targetpos = targetpos - Angle(0,methamphetamine.CalculateRecoilCompensation(LocalPlayer).y,0)
        end
        LocalPlayer:SetEyeAngles( methamphetamine.SmoothAim(targetpos) )
    else
        local priority = methamphetamine.mods["Aim"].Priority or "FOV"
        local v
        local log = "Looking for an aimbot target with priority: ".. priority
        -- if methamphetamine.DebugLogs[#methamphetamine.DebugLogs].text != log then
        --     methamphetamine.Log(log)
        -- end
        if priority == "Field of View" then
            v = methamphetamine:GetClosestPlayerToCrosshair()
        elseif priority == "Closest Distance" then
            v = methamphetamine:GetClosestPlayer()
        elseif priority == "Least Health" then
            v = methamphetamine:GetPlayerWithHealth( "Lowest",0.95 )
        elseif priority == "Most Health" then
            v = methamphetamine:GetPlayerWithHealth( "Highest",0.95 )
        end
        -- if methamphetamine:IsPlayerWithinFOV( v , 0.95 ) then
            AimbotTarget = v
        --end
        
    end
end)

local ragetarget 
hook.Add("Think", "AimbotRage", function()
    if not methamphetamine.mods["Aim"].enabled then return end
    if ragetarget and not methamphetamine.mods["Aim"].rage then ragetarget = nil end
    if not methamphetamine.mods["Aim"].Rage then return end
    --print("RAGE")
    for k , v in pairs( methamphetamine.ragevictims ) do
        if not IsValid( k ) then methamphetamine.ragevictims[ v ] = nil goto skiprage end
        if not k:Alive() then goto skiprage end
        if ragetarget then
            if LocalPlayer:GetPos():DistToSqr(k:GetPos()) < LocalPlayer:GetPos():DistToSqr( ragetarget:GetPos() ) then
                ragetarget = k
            end
        else
            ragetarget = k
        end
        local limbpos = (methamphetamine:CalculateCurLimbPos( ragetarget , methamphetamine.mods["Aim"].Limb ))
        LocalPlayer:SetEyeAngles( (( limbpos - LocalPlayer:GetShootPos()) ):Angle() )    
        ::skiprage::
    end
end)

concommand.Add("methamphetamine_rage", function()
    methamphetamine.mods["Aim"].Rage = not methamphetamine.mods["Aim"].Rage
end)

concommand.Add("methamphetamine_removeragevictim", function( ply, cmd, args )
    if not args[1] then return end
    methamphetamine:RemoveRageVictimByKeyword( args[1] )
end)

concommand.Add("methamphetamine_addragevictims", function( ply, cmd, args )
    if not args[1] then return end
    methamphetamine:AddRageVictimByKeyword( args[1] )
end)



--local player = meth_getPlayers()[2]         
hook.Add("HUDPaint", "Aimbot", function()
    if !methamphetamine.mods.ESP.MasterToggle or !methamphetamine.mods.Aim.enabled then return end
    local r = ScrH() * math.tan(math.rad(methamphetamine.mods["Aim"].FOV/2)) / (2*math.tan(math.rad(LocalPlayer:GetFOV()/2))) -- ScrH() * math.tan(math.rad(fov/2)) / (2*math.tan(math.rad(plyFov/2)))
    surface.DrawCircle( ScrW()/2,ScrH()/2,r, 255,255,255 )

end)
