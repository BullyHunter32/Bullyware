--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
]]--

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
local sqrt = math.sqrt
local floor = math.floor
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
        if methamphetamine.mods["ESP"].Entities[ v:GetClass() ] then
            print(k,v)
            returned[#returned + 1] = v
        end
    end
    return returned
end
methamphetamine.espentities = methamphetamine.GetESPEntites()

timer.Create("methamphetamine.updateentityesp", 15, 0 , function()
    methamphetamine.espentities = methamphetamine.GetESPEntites()
end)

addHook("HUDPaint","methamphetamine.entityesp",function()
    if methamphetamine.screengrab then return end
    for k , v in ipairs(methamphetamine.espentities) do
        if not IsValid(v) then table.remove(methamphetamine.espentities,k) return end
        if v:GetPos():DistToSqr(LocalPlayer():GetPos()) > methamphetamine.mods.ESP.Range*methamphetamine.mods.ESP.Range then goto skipEntityRendering end
        local entpos = (v:GetPos() + v:OBBCenter()):ToScreen()
        local text = v:GetClass()
        surface.SetFont( methamphetamine.default.font )
        surface.SetTextColor( color_white )
        local textwide,texttall = surface.GetTextSize( text)
        surface.SetTextPos( entpos.x - textwide/2,entpos.y-texttall/2 )
        surface.DrawText( text )
        ::skipEntityRendering::
    end
end)

local cachedTeamColors = {}
methamphetamine.GetTeamColor = function(iTeam)
    if not cachedTeamColors[iTeam] then
        cachedTeamColors[iTeam] = GetTeamColor(iTeam)
    end
    return cachedTeamColors[iTeam]
end

local cachedTeamNames = {}
methamphetamine.GetTeamName = function(iTeam)
    if not cachedTeamNames[iTeam] then
        cachedTeamNames[iTeam] = team.GetName(iTeam)
    end
    return cachedTeamNames[iTeam]
end

local function calculateTextOffSet( strText, strFont, iAlignX, iAlignY ) -- 1 and 4 is pretty much all i use
    iAlignX = iAlignX or 0
    iAlignY = iAlignY or 0
    surface.SetFont(strFont)
    local textWide,textTall = surface.GetTextSize(strText)
    local offsetx,offsety = 0,0
    if iAlignX == 1 then
        offsetx = offsetx - (textWide/2)
    elseif iAlignX == 2 then
        offsetx = offsetx - textWide
    end
    if iAlignY == 4 then
        offsety = offsety + textTall
    elseif iAlignY == 2 then
        offsety = offsety - (textTall/2)
    end
    return offsetx,offsety
end

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
        local LEFT_MARGIN = 0
        local TOP_MARGIN = 0
        local RIGHT_MARGIN = 0
        local BOTTOM_MARGIN = 0
        local teamcolor = methamphetamine.GetTeamColor(v:Team())
        local healthcolor = Color( 255 * (1 - (v:Health() / v:GetMaxHealth())) , 255 * (v:Health()/v:GetMaxHealth()), 0 )
        local MaxX,MaxY,MinX,MinY,V1,V2,V3,V4,V5,V6,V7,V8 = getBounds( v )
        local distance = floor(sqrt(LocalPlayer():GetPos():DistToSqr(v:GetPos())))
        
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
            local margin = width*2
            local diff = (MaxY - MinY) - ((MaxY - MinY) * math.min( math.max(v:Health(),0) / v:GetMaxHealth(),1))
            surface.SetDrawColor( color_black )
            surface.DrawPoly({
                { x = MaxX + margin, y = MaxY  },
                { x = MaxX + width , y = MaxY },
                { x = MaxX + width, y = MinY },
                { x = MaxX + margin , y = MinY }, 
            })

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
                { x = MaxX + margin - 1, y = MaxY - 1},
                { x = MaxX + width + 1, y = MaxY - 1},
                { x = MaxX + width + 1, y = MinY + 1 + diff},
                { x = MaxX + margin - 1, y = MinY + 1 + diff}, 
            })
        end
        surface.SetFont(methamphetamine.default.font)
        local _,TEXT_MARGIN_INCREMENT = surface.GetTextSize("012376543")
        if methamphetamine.mods["ESP"].enabled["Name"] then
            if methamphetamine.mods["ESP"].colortype["Name"] == "Selected Color" then
                SetTextColor( colors["Name"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Name"] == "Team Color" then
                SetTextColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Name"] == "Health Color" then
                SetTextColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Name"] == "Rainbow" then
                SetTextColor( rainbow )
            end
            local nameRenderType = methamphetamine.mods["ESP"].types["Name"]
            local str = v.SteamName and v:SteamName() or v:Nick()
            if nameRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif nameRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif nameRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
                RIGHT_MARGIN = RIGHT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif nameRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
        end
        if methamphetamine.mods["ESP"].enabled["Rank"] then
            if methamphetamine.mods["ESP"].colortype["Rank"] == "Selected Color" then
                SetDrawColor( colors["Rank"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Rank"] == "Team Color" then
                SetDrawColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Rank"] == "Health Color" then
                SetDrawColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Rank"] == "Rainbow" then
                SetDrawColor( rainbow )
            end
            local rankRenderType = methamphetamine.mods["ESP"].types["Rank"]
            local str = v:GetUserGroup()
            if rankRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif rankRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif rankRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
            elseif rankRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
        end
        if methamphetamine.mods["ESP"].enabled["Team"] then
            if methamphetamine.mods["ESP"].colortype["Team"] == "Selected Color" then
                SetDrawColor( colors["Team"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Team Color" then
                SetDrawColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Health Color" then
                SetDrawColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Rainbow" then
                SetDrawColor( rainbow )
            end
            local teamRenderType = methamphetamine.mods["ESP"].types["Team"]
            local str = methamphetamine.GetTeamName(v:Team())
            if teamRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif teamRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif teamRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
            elseif teamRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
        end
        if methamphetamine.mods["ESP"].enabled["Health [Txt]"] then
            if methamphetamine.mods["ESP"].colortype["Health [Txt]"] == "Selected Color" then
                SetTextColor( colors["Health [Txt]"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Health [Txt]"] == "Team Color" then
                SetTextColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Health [Txt]"] == "Health Color" then
                SetTextColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Health [Txt]"] == "Rainbow" then
                SetTextColor( rainbow )
            end
            local healthRenderType = methamphetamine.mods["ESP"].types["Health [Txt]"]
            local str ="HP: "..v:Health()
            if healthRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif healthRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif healthRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
            elseif healthRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
        end
        if methamphetamine.mods["ESP"].enabled["Weapon"] then
            if methamphetamine.mods["ESP"].colortype["Weapon"] == "Selected Color" then
                SetTextColor( colors["Weapon"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Weapon"] == "Team Color" then
                SetTextColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Weapon"] == "Health Color" then
                SetTextColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Weapon"] == "Rainbow" then
                SetTextColor( rainbow )
            end
            local weaponRenderType = methamphetamine.mods["ESP"].types["Weapon"]
            local str = IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() or "NONE"
            if weaponRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif weaponRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif weaponRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
            elseif weaponRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
        end
        if methamphetamine.mods["ESP"].enabled["Distance"] then
            if methamphetamine.mods["ESP"].colortype["Distance"] == "Selected Color" then
                SetTextColor( colors["Distance"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Distance"] == "Team Color" then
                SetTextColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Distance"] == "Health Color" then
                SetTextColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Distance"] == "Rainbow" then
                SetTextColor( rainbow )
            end
            local distanceRenderType = methamphetamine.mods["ESP"].types["Distance"]
            local str = "Distance: "..distance
            if distanceRenderType == "Top" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,4)
                surface.SetTextPos(x + offsetx,MinY-TOP_MARGIN-offsety)
                surface.DrawText(str)
                TOP_MARGIN = TOP_MARGIN + TEXT_MARGIN_INCREMENT
            elseif distanceRenderType == "Left" then
                local x = MinX - 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,2,1)
                surface.SetTextPos(x + offsetx,MinY-LEFT_MARGIN+offsety)
                surface.DrawText(str)
                LEFT_MARGIN = LEFT_MARGIN - TEXT_MARGIN_INCREMENT
            elseif distanceRenderType == "Right" then
                local x = MaxX + 1
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,0,1)
                surface.SetTextPos(x + offsetx,MinY-RIGHT_MARGIN+offsety)
                surface.DrawText(str)
            elseif distanceRenderType == "Bottom" then
                local x = MinX - ((MinX-MaxX)/2)
                local offsetx,offsety = calculateTextOffSet(str,methamphetamine.default.font,1,0)
                surface.SetTextPos(x + offsetx,MaxY+BOTTOM_MARGIN+offsety)
                surface.DrawText(str)
                BOTTOM_MARGIN = BOTTOM_MARGIN + TEXT_MARGIN_INCREMENT
            end
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
        local teamcolor = methamphetamine.GetTeamColor( v:Team() )
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
