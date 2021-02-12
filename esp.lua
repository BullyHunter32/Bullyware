local GetAllPlayers = player.GetAll
local ipairs = ipairs
local addHook = hook.Add
local getPosition =  FindMetaTable("Entity").GetPos
local CurTime = CurTime
local drawSurfaceLine = surface.DrawLine
local bones = methamphetamine.bones
local surface = surface
local DrawRect = surface.DrawRect
local DrawText = surface.DrawText
local SetDrawColor = surface.SetDrawColor
local SetTextColor = surface.SetTextColor
local GetTeamColor = team.GetColor
local AddHalo = halo.Add

local function drawBones( ply )
    local Bones = {}
    for k, v in ipairs(bones) do
        if ply:LookupBone(v) != nil && ply:GetBonePosition(ply:LookupBone(v)) != nil then
            table.insert( Bones, ply:GetBonePosition(ply:LookupBone(v)):ToScreen() )
        else
            return
        end
    end

    drawSurfaceLine( Bones[1].x, Bones[1].y, Bones[2].x, Bones[2].y )
    drawSurfaceLine( Bones[2].x, Bones[2].y, Bones[3].x, Bones[3].y )
    drawSurfaceLine( Bones[3].x, Bones[3].y, Bones[4].x, Bones[4].y )
    drawSurfaceLine( Bones[4].x, Bones[4].y, Bones[5].x, Bones[5].y )
    drawSurfaceLine( Bones[5].x, Bones[5].y, Bones[6].x, Bones[6].y )
    drawSurfaceLine( Bones[6].x, Bones[6].y, Bones[7].x, Bones[7].y )
    drawSurfaceLine( Bones[7].x, Bones[7].y, Bones[14].x, Bones[14].y )
    drawSurfaceLine( Bones[14].x, Bones[14].y, Bones[15].x, Bones[15].y )
    drawSurfaceLine( Bones[15].x, Bones[15].y, Bones[16].x, Bones[16].y )
    drawSurfaceLine( Bones[16].x, Bones[16].y, Bones[17].x, Bones[17].y )
    drawSurfaceLine( Bones[7].x, Bones[7].y, Bones[18].x, Bones[18].y )
    drawSurfaceLine( Bones[18].x, Bones[18].y, Bones[19].x, Bones[19].y )
    drawSurfaceLine( Bones[19].x, Bones[19].y, Bones[20].x, Bones[20].y )
    drawSurfaceLine( Bones[20].x, Bones[20].y, Bones[21].x, Bones[21].y )
    drawSurfaceLine( Bones[3].x, Bones[3].y, Bones[8].x, Bones[8].y )
    drawSurfaceLine( Bones[8].x, Bones[8].y, Bones[9].x, Bones[9].y )
    drawSurfaceLine( Bones[9].x, Bones[9].y, Bones[10].x, Bones[10].y )
    drawSurfaceLine( Bones[3].x, Bones[3].y, Bones[11].x, Bones[11].y )
    drawSurfaceLine( Bones[11].x, Bones[11].y, Bones[12].x, Bones[12].y )
    drawSurfaceLine( Bones[12].x, Bones[12].y, Bones[13].x, Bones[13].y )
    ::skipdrawbone::
end

local function getBounds( Ent )
    local Points = {
        Vector( Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z ),
        Vector( Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMins().z ),
        Vector( Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMins().z ),
        Vector( Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMaxs().z ),
        Vector( Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMins().z ),
        Vector( Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMaxs().z ),
        Vector( Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMins().z ),
        Vector( Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z )
    }
    local MaxX, MaxY, MinX, MinY
    local V1, V2, V3, V4, V5, V6, V7, V8
    for k, v in ipairs( Points ) do
        local ScreenPos = Ent:LocalToWorld( v ):ToScreen()
        if MaxX != nil then
            MaxX, MaxY, MinX, MinY = math.max( MaxX, ScreenPos.x ), math.max( MaxY, ScreenPos.y), math.min( MinX, ScreenPos.x ), math.min( MinY, ScreenPos.y)
        else
            MaxX, MaxY, MinX, MinY = ScreenPos.x, ScreenPos.y, ScreenPos.x, ScreenPos.y
        end

        if V1 == nil then
            V1 = ScreenPos
        elseif V2 == nil then
            V2 = ScreenPos
        elseif V3 == nil then
            V3 = ScreenPos
        elseif V4 == nil then
            V4 = ScreenPos
        elseif V5 == nil then
            V5 = ScreenPos
        elseif V6 == nil then
            V6 = ScreenPos
        elseif V7 == nil then
            V7 = ScreenPos
        elseif V8 == nil then
            V8 = ScreenPos
        end
    end
    return MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8
end

local scrw,scrh = ScrW(),ScrH()


print("CREATING ENTITIES TABLE ")
local vguicolors = methamphetamine.colors
methamphetamine.mods["ESP"].Entities = {}
function methamphetamine.GetESPEntites()
    local returned = {}
    for k ,v in ipairs( ents.GetAll() ) do
        --print( k,v:GetClass() )
        if methamphetamine.mods["ESP"].Entities[ v:GetClass() ] then
            print(k,v)
            returned[#returned + 1] = v
        end
    end
    return returned
end
methamphetamine.espentities = methamphetamine.GetESPEntites()
-- timer.Create("methamphetamine.updateentityesp", 15, 0 , function()
--     methamphetamine.espentities = methamphetamine.GetESPEntites()
-- end)


-- addHook("HUDPaint","methamphetamine.esp",function()
--     if methamphetamine.screengrab then return end

--     if CurTime() - methamphetamine.lastscreengrab < 5 then
--         surface.SetDrawColor( vguicolors.background )
--         surface.DrawRect(ScrW() /2 - 110,0,220,30)
--         surface.SetDrawColor( vguicolors.border )
--         surface.DrawOutlinedRect(ScrW() / 2 - 110,0,220,30)
--         surface.SetFont( methamphetamine.default.font )
--         surface.SetTextColor( vguicolors.text )
--         surface.SetTextPos( ScrW() / 2 - 75,8 )
--         surface.DrawText("You were screengrabbed")
--     end

    -- --local rainbowcol = HSVToColor( CurTime() * 100 % 360, 1, 1 )
    
    -- surface.SetDrawColor( methamphetamine.mods["ESP"].colors.crosshair )
    -- drawSurfaceLine( scrw/2 - 14 , scrh / 2 , scrw/2 + 15 , scrh / 2 )
    -- drawSurfaceLine( scrw/2 , scrh / 2 - 14 , scrw/2 , scrh/2 + 15 )
    -- for k , v in ipairs( GetAllPlayers() ) do
    --     if not v:Alive() or v == LocalPlayer() then goto skipdrawing end

    --     surface.SetDrawColor( Color(20,200,40) )
    --     local headpos = v:LookupBone( methamphetamine.bones[1] )
    --     if headpos then
    --         headpos = v:GetBonePosition(v:LookupBone(methamphetamine.bones[1]))
    --         local diff = headpos - LocalPlayer():GetShootPos()
    --         if LocalPlayer():GetAimVector():Dot(diff) / diff:Length() >= 0.75 then
    --             headpos = headpos:ToScreen()
    --             surface.DrawLine(ScrW()/2,ScrH()/2,headpos.x,headpos.y)
    --         end
    --     end

    --     if LocalPlayer():GetPos():DistToSqr( v:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end

    --     local activecol = team.GetColor( v:Team() )
    --     surface.SetDrawColor( activecol )
    --     drawBones( v )
    --     local MaxX, MaxY, MinX, MinY = getBounds( v )
    --     surface.DrawLine( MaxX, MaxY, MinX, MaxY )
    --     surface.DrawLine( MaxX, MaxY, MaxX, MinY )
    --     surface.DrawLine( MinX, MinY, MaxX, MinY )
    --     surface.DrawLine( MinX, MinY, MinX, MaxY )
    --     local headpos = v:LookupBone(bones[1]) 
    --     if headpos != nil then
    --         headpos = v:GetBonePosition(v:LookupBone(bones[1])):ToScreen()
    --         surface.SetFont( methamphetamine.default.font )
    --         local name = v:Nick() .. " {".. v:GetUserGroup() .. "} "
    --         local namewide,nametall = surface.GetTextSize(name)
    --         surface.SetTextColor( activecol )
    --         surface.SetTextPos(  ((MaxX-MinX)/2)+MinX - namewide/2, MinY-30 )
    --         surface.DrawText( name )

    --         local health = "HP: "..v:Health() 
    --         local healthwide,healthtall = surface.GetTextSize(health)
    --         surface.SetTextPos(  ((MaxX-MinX)/2)+MinX - healthwide/2, MinY-18 )
    --         surface.DrawText( health )
    --     else
    --         --headpos = v:GetBonePosition(v:LookupBone(bones[1])):ToScreen()
    --         surface.SetFont( methamphetamine.default.font )
    --         local name = v:Nick() .. " {".. v:GetUserGroup() .. "} "
    --         local namewide,nametall = surface.GetTextSize(name)
    --         surface.SetTextColor( activecol )
    --         surface.SetTextPos(  ((MaxX-MinX)/2)+MinX - namewide/2, MinY-30 )
    --         surface.DrawText( name )

    --         local health = "HP: "..v:Health() 
    --         local healthwide,healthtall = surface.GetTextSize(health)
    --         surface.SetTextPos(  ((MaxX-MinX)/2)+MinX - healthwide/2, MinY-18 )
    --         surface.DrawText( health )
    --     end
    --     ::skipdrawing::
    -- end

--     for k , v in ipairs(methamphetamine.espentities) do
--         if not IsValid(v) then table.remove(methamphetamine.espentities,k) return end
--         local entpos = (v:GetPos() + v:OBBCenter()):ToScreen()
--         local text = v:GetClass()
--         surface.SetFont( methamphetamine.default.font )
--         surface.SetTextColor( color_white )
--         local textwide,texttall = surface.GetTextSize( text)
--         surface.SetTextPos( entpos.x - textwide/2,entpos.y-texttall/2 )
--         surface.DrawText( text )
--     end
-- end)
local colors 
addHook("HUDPaint","methamphetamine.esp",function()
    if methamphetamine.screengrab then return end
    colors = methamphetamine.mods and methamphetamine.mods["ESP"] and methamphetamine.mods["ESP"].colors or {}


    if CurTime() - methamphetamine.lastscreengrab < 5 then
        surface.SetDrawColor( vguicolors.background )
        surface.DrawRect(ScrW() /2 - 110,0,220,30)
        surface.SetDrawColor( vguicolors.border )
        surface.DrawOutlinedRect(ScrW() / 2 - 110,0,220,30)
        surface.SetFont( methamphetamine.default.font )
        surface.SetTextColor( vguicolors.text )
        surface.SetTextPos( ScrW() / 2 - 75,8 )
        surface.DrawText("You were screengrabbed")
    end
    if not methamphetamine.mods["ESP"].MasterToggle then return end
    local rainbow = HSVToColor( (CurTime()*20)%360,1,1 )
    for k , v in ipairs( GetAllPlayers() ) do
        if v:Health() <= 0 or v == LocalPlayer() then goto skiprender end
        if LocalPlayer():GetPos():DistToSqr( v:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skiprender end
        local teamcolor = GetTeamColor( v:Team() )
        local healthcolor = Color( 255 * (1 - (v:Health() / v:GetMaxHealth())) , 255 * (v:Health()/v:GetMaxHealth()), 0 )
        local MaxX,MaxY,MinX,MinY,V1,V2,V3,V4,V5,V6,V7,V8 = getBounds( v )

        if methamphetamine.mods["ESP"].enabled["Box"] then
            if methamphetamine.mods["ESP"].colortype["Box"] == "Selected Color" then
                SetDrawColor( colors.Box or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Box"] == "Team Color" then
                SetDrawColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Box"] == "Health Color" then
                SetDrawColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Box"] == "Rainbow" then
                SetDrawColor( rainbow )
            end
            if methamphetamine.mods["ESP"].types["Box"] == "2D [None]" then
                drawSurfaceLine( MaxX, MaxY, MinX, MaxY )
                drawSurfaceLine( MaxX, MaxY, MaxX, MinY )
                drawSurfaceLine( MinX, MinY, MaxX, MinY )
                drawSurfaceLine( MinX, MinY, MinX, MaxY )
            elseif methamphetamine.mods["ESP"].types["Box"] == "3D [None]" then
                drawSurfaceLine( V4.x, V4.y, V6.x, V6.y )
                drawSurfaceLine( V1.x, V1.y, V8.x, V8.y )
                drawSurfaceLine( V6.x, V6.y, V8.x, V8.y )
                drawSurfaceLine( V4.x, V4.y, V1.x, V1.y )

        
                drawSurfaceLine( V3.x, V3.y, V5.x, V5.y )
                drawSurfaceLine( V2.x, V2.y, V7.x, V7.y )
                drawSurfaceLine( V3.x, V3.y, V2.x, V2.y )
                drawSurfaceLine( V5.x, V5.y, V7.x, V7.y )

          
                drawSurfaceLine( V3.x, V3.y, V4.x, V4.y )
                drawSurfaceLine( V2.x, V2.y, V1.x, V1.y )
                drawSurfaceLine( V7.x, V7.y, V8.x, V8.y )
                drawSurfaceLine( V5.x, V5.y, V6.x, V6.y )
            end
        end

        if methamphetamine.mods["ESP"].enabled["Skeleton"] then
            if methamphetamine.mods["ESP"].colortype["Skeleton"] == "Selected Color" then
                SetDrawColor( colors.Skeleton or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Skeleton"] == "Team Color" then
                SetDrawColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Skeleton"] == "Health Color" then
                SetDrawColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Skeleton"] == "Rainbow" then
                SetDrawColor( rainbow )
            end
            drawBones( v )
        end


        if methamphetamine.mods["ESP"].enabled["Health [Bar]"] then
            --print("Drawing health bar")
            local width = 6
            local diff = (MaxY - MinY) - ((MaxY - MinY) * math.min( math.max(v:Health(),0) / v:GetMaxHealth(),1))
            local poly = {
                { x = MaxX + width, y = MaxY  },
                { x = MaxX + (width*2) , y = MaxY },
                { x = MaxX + (width*2) , y = MinY },
                { x = MaxX + (width) , y = MinY }, 
            }
            surface.SetDrawColor( color_black )
            surface.DrawPoly(poly)

            if methamphetamine.mods["ESP"].colortype["Health [Bar]"] == "Selected Color" then
                SetDrawColor( colors["Health [Bar]"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Health [Bar]"] == "Team Color" then
                SetDrawColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Health [Bar]"] == "Health Color" then
                SetDrawColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Health [Bar]"] == "Rainbow" then
                SetDrawColor( rainbow )
            end

            surface.DrawPoly({
                { x = MaxX + width + 1, y = MaxY - 1  },
                { x = MaxX + (width*2 - 1), y = MaxY - 1 },
                { x = MaxX + (width*2 - 1), y = MinY + diff + 1 },
                { x = MaxX + (width + 1), y = MinY + diff + 1 }, 
            })
        end

        

        ::skiprender::
    end
end)


hook.Add( "PostDrawOpaqueRenderables", "methamphetamine.chams", function()
    if not methamphetamine then return end
    if methamphetamine.screengrab then return end
    if not methamphetamine.mods or not methamphetamine.mods.ESP or not methamphetamine.mods.ESP.enabled then return end

    if (methamphetamine.mods["ESP"].enabled["Chams [P.]"]   ) then 
        render.SetStencilWriteMask( 0xFF )
        render.SetStencilTestMask( 0xFF )
        render.SetStencilReferenceValue( 0 )
        render.SetStencilCompareFunction( STENCIL_ALWAYS )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.ClearStencil()
        render.SetStencilEnable( true )
        render.SetStencilReferenceValue( 1 )
        render.SetStencilCompareFunction( STENCIL_EQUAL )
        render.SetStencilFailOperation( STENCIL_REPLACE )
    
        local champcol = color_white
        for _, ent in ipairs( GetAllPlayers() ) do
            if not ent:Alive() then goto skipdrawing end
            if LocalPlayer():GetPos():DistToSqr( ent:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
            if methamphetamine.mods["ESP"].colortype["Chams [P.]"] == "Selected Color" then
                champcol = ( colors["Chams [P.]"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Chams [P.]"] == "Rainbow" then
                champcol = HSVToColor( (CurTime()*20)%360,1,1 )
            end
            ent:DrawModel() 
            ::skipdrawing::
        end
        render.ClearBuffersObeyStencil( champcol.r,champcol.g,champcol.b, 255, false )
        render.SetStencilEnable( false )
    end

    if (methamphetamine.mods["ESP"].enabled["Chams [W.]"] or false) then 
        render.SetStencilWriteMask( 0xFF )
        render.SetStencilTestMask( 0xFF )
        render.SetStencilReferenceValue( 0 )
        render.SetStencilCompareFunction( STENCIL_ALWAYS )
        render.SetStencilPassOperation( STENCIL_KEEP )
        render.SetStencilFailOperation( STENCIL_KEEP )
        render.SetStencilZFailOperation( STENCIL_KEEP )
        render.ClearStencil()
        render.SetStencilEnable( true )
        render.SetStencilReferenceValue( 1 )
        render.SetStencilCompareFunction( STENCIL_EQUAL )
        render.SetStencilFailOperation( STENCIL_REPLACE )

        
        local champcol = color_white
        for _, ent in ipairs( GetAllPlayers() ) do
            ent = ent:GetActiveWeapon()
            if not IsValid( ent ) then goto skipdrawing end
            if LocalPlayer():GetPos():DistToSqr( ent:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
            if methamphetamine.mods["ESP"].colortype["Chams [W.]"] == "Selected Color" then
                champcol = ( colors["Chams [W.]"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Chams [W.]"] == "Rainbow" then
                champcol = HSVToColor( (CurTime()*20)%360,1,1 )
            end
            ent:DrawModel() 
            ::skipdrawing::
        end
        render.ClearBuffersObeyStencil( champcol.r,champcol.g,champcol.b, 255, false )
        render.SetStencilEnable( false )

    end


    
end )	

addHook("PreDrawHalos","methamphetamine.halos",function()
    if not methamphetamine then return end
    if methamphetamine.screengrab then return end
    if not methamphetamine.mods or not methamphetamine.mods.ESP or not methamphetamine.mods.ESP.enabled then return end
    if not methamphetamine.mods["ESP"].enabled["Glow"] then return end


    for k , v in ipairs( GetAllPlayers() ) do
        if LocalPlayer():GetPos():DistToSqr( v:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
        local teamcolor = GetTeamColor( v:Team() )
        local healthcolor = Color( 255 * (1 - (v:Health() / v:GetMaxHealth())) , 255 * (v:Health()/v:GetMaxHealth()), 0 )
        local rainbow = HSVToColor( (CurTime()*20)%360,1,1 )
        local c = color_white
        if methamphetamine.mods["ESP"].colortype["Glow"] == "Selected Color" then
            c = ( colors.Glow or color_white )
        elseif methamphetamine.mods["ESP"].colortype["Glow"] == "Team Color" then
            c = ( teamcolor )
        elseif methamphetamine.mods["ESP"].colortype["Glow"] == "Health Color" then
            c = ( healthcolor )
        elseif methamphetamine.mods["ESP"].colortype["Glow"] == "Rainbow" then
            c = ( rainbow )
        end
        AddHalo( {v} , c ,0.1 , 0.1, 0.1,true, true )
        ::skipdrawing::
    end
end)