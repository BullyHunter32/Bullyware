local mods = {
    [0]  = {}
}

function mods:Add( name , func )
    mods[ #mods+1 ] = {
        isToggled = false,
        func = func,
        name = name,
    }   
    mods[0][name] = mods[#mods]
    return mods[0][name]
end

mods:Add("Spectators", function( mod, toggle )
    if not toggle then
        mod.panel:Remove()
        timer.Remove("methamphetamine.spectaterefresh")
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(120,200)
    mod.panel:Center()
    mod.panel:SetTitle("Spectator List")
    mod.panel:SetResizeable( true )
    mod.panel:SetZPos(-1)
    mod.panel.names = {}
    timer.Create("methamphetamine.spectaterefresh",5,0, function()
        if not IsValid( mod.panel ) then timer.Remove("methamphetamine.spectaterefresh") return end 
        for k , v in ipairs(mod.panel.names) do
            v:Remove()
        end
        for k , v in ipairs( player.GetAll() ) do
            if v:GetObserverTarget() == LocalPlayer() then
                mod.panel.names[#mod.panel.names + 1] = mod.panel:Add("DLabel")
                local pnl = mod.panel.names[#mod.panel.names]
                pnl:Dock(TOP)
                pnl:DockMargin(4,2,4,2)
                pnl:SetFont( methamphetamine.default.font )
                pnl:SetText( v:Nick() )
                pnl:SizeToContents()
            end
        end
    end)
    
end)
local plyarrow = Material("meth/player-arrow.png")
surface.CreateFont("methamphetamine.radar", {
    font = "Raleway",
    size = 12,
    weight = 100,
})
mods:Add("Radar", function( mod, toggle )
    if not toggle then
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(290,290)
    mod.panel:Center()
    mod.panel:SetTitle("Radar")
    mod.panel:SetResizeable( true )
    mod.panel:SetZPos(-1)
    mod.panel.scale = 0.1
    local plycol = color_white
    local deadplayerarrow = Color(240,90,90)
    mod.panel.PaintOver = function(pnl,w,h)

        local angs = LocalPlayer():GetAngles()
        surface.SetMaterial( plyarrow ) 
        surface.SetDrawColor( plycol ) -- YOU
        surface.DrawTexturedRectRotated(w/2-8,h/2-8,16,16, angs.y  )
        for k , v in ipairs( player.GetAll() ) do
            --if LocalPlayer():GetPos():DistToSqr( v:GetPos() ) > 300*300 or v == LocalPlayer() then return end
            if v == LocalPlayer() then goto skip end

            local plypos = (LocalPlayer():GetShootPos() - v:GetPos())
            --print( plypos )
            local plyang = v:EyeAngles()
            surface.SetMaterial( plyarrow ) 
            surface.SetDrawColor( not v:Alive() and deadplayerarrow or plycol )
            surface.DrawTexturedRectRotated( w/2 + (plypos.y * pnl.scale) - 8 , h/2 + (plypos.x*pnl.scale) - 8 ,16,16, plyang.y )
            draw.SimpleText( v:Nick() , "methamphetamine.radar", w/2 + (plypos.y * pnl.scale) - 8 , h/2 + (plypos.x*pnl.scale) , color_white, 1 )
            ::skip::
        end
    end
    
end)

mods:Add("Test Search", function( mod , toggle )
    if not toggle then
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(450,292)
    mod.panel:Center()
    mod.panel:SetTitle("Test Search")
    mod.panel:SetResizeable( true )
    mod.panel.search = mod.panel:Add("methamphetamine.search")
    mod.panel.search:Dock(TOP)
    mod.panel.search:SetTall(20)
    mod.panel.search:DockMargin(6,6,6,6)
  
end)    

local radiostations = {}
if not file.Exists("methamphetamine/radio", "DATA") then
    file.CreateDir("methamphetamine/radio")
end
local txt = file.Read("methamphetamine/radio/recent.txt", "DATA")
if not file.Exists("methamphetamine/radio/recent.txt", "DATA") then file.Write("methamphetamine/radio/recent.txt", util.TableToJSON({}) ) end
local function recent( name , url )
    local data = file.Read("methamphetamine/radio/recent.txt", "DATA")
    local tbl = util.JSONToTable( data )
    tbl[#tbl + 1] = {name = name, url = url}
    file.Write( "methamphetamine/radio/recent.txt", util.TableToJSON(tbl,true) )
end
local data = function()
    return util.JSONToTable(file.Read("methamphetamine/radio/recent.txt","DATA"))
end
--methamphetamine.currentradiostation = methamphetamine.currentradiostation 
methamphetamine.currentradiostationname = 'Nothing'

local function PlaySong( link )
    if IsValid( methamphetamine.currentradiostation ) then
        methamphetamine.currentradiostation:Stop()
    end
    sound.PlayURL( link , "noblock", function(chan, err, errstr)
        if IsValid( chan ) then
            hook.Add("Think","methamphetamine.radio",function()
            
                chan:SetPos(  LocalPlayer():GetPos() )

            end)
            methamphetamine.currentradiostation = chan
        else
            MsgC("Invalid URL (" .. link .. ")"  )
        end
    end)    

end
--PlaySong("https://dl5.youtubetomp3music.com/file/youtubeszrDcTGvp7o128.mp3?fn=STORMZY%20%E2%80%93%20RAINFALL%20(FEAT.%20TIANA%20MAJOR9).mp3")
local function playYTUrl( url )
    local _,start = string.find( url, "youtube.com/")
    local url = "https://www.320youtube.com/v7".. string.sub( url , start, #url )
    print( url )
    local newURL = ""
    http.Fetch( url , function( body, len, headers, code )
        local start,_end = ( string.find( body , ".ytapivmp3.com/download") )
        local megaEnd = string.find( string.sub(body, start) , "/1\"" )
        --print( start, megaEnd )
        --print( string.sub( body , start, start + megaEnd  ) )
        local urlStart = string.find( string.sub( body , start - 61 , start ), "https:" )
        newURL = ( string.sub( body , start + urlStart - 60 , start + megaEnd ) )
        --print("URL START = ", string.sub( body , start + urlStart - 60 , start + megaEnd ) )
        --print("URL START = ", "ht"..newURL )
        newURL = "ht"..newURL
        --local newURL = string.sub( body  , urlStart, megaEnd ) 
        --print( newURL )
        sound.PlayURL ( newURL , "noblock", function( station )
            --print("CALLED_123213")
            -- if _station then
            if ( IsValid( station ) ) then
                if IsValid( methamphetamine.currentradiostation ) then
                    methamphetamine.currentradiostation:Stop()
                end
                methamphetamine.currentradiostation = station

            --         _station:Stop()
            --     end
            --     _station = station
        
                hook.Add("Think", "methamphetamine.radiofollow", function()
                    if IsValid( methamphetamine.currentradiostation ) then
                        methamphetamine.currentradiostation:SetPos( EyePos() )
                    else
                        hook.Remove("Think", "methamphetamine.radiofollow")
                    end
                end)
            
                methamphetamine.currentradiostation:Play()

                http.Fetch(newURL,	function( body, length, headers, code )
                    local start,ends,_ = string.find( body , "<title>",20,true)
                    local _end,_,_ = string.find( body , "</title", 20, true )
                    local title = string.sub(body,ends+1,_end-1)
                    local removestart,removeend,_ = string.find(title,"| 320")
                    local title = string.sub(title,0,removestart-1)
                    methamphetamine.currentradiostationname = title 
             
                end)
                
            
            else
        
                LocalPlayer:ChatPrint( "Invalid URL!" )
        
            end
        end )
    end)
    print("\n\nPLAYING  ", tostring(newURL) , "\n\n")
    
end



methamphetamine.radiostations = {
	{
		Name = "Drive Radio",
        Link = "http://listen.radionomy.com/drive.m3u",
        Description = "the radio station striictly for driving",
	},
	{
		Name = "Classic Rock Florida",
        Link = "https://vip2.fastcast4u.com/proxy/classicrockdoug?mp=/1",
        Description = "tends to be a little gay",
	},
	{
		Name = "Soma.fm",
        Link = "http://somafm.com/groovesalad.pls",
        Description = "soma fm",
	},
	{
		Name = "Chillhop",
        Link = "https://stream.amazingradios.com/chillhop",
        Description = "chill hop",
	},
	{
		Name = "Smooth Jazz",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us4.internet-radio.com:8266/listen.pls&t=.m3u",
        Description = "Smooth jazz",
	},
	{
		Name = "Oldies",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://uk3.internet-radio.com:8405/live.m3u&t=.m3u",
        Description = "Old people music or something",
	},
	{
		Name = "Radio Charwell",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://uk6.internet-radio.com:8144/listen.pls&t=.m3u",
        Description = "Radio yes",
	},
	{
		Name = "Reggae",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://uk6.internet-radio.com:8213/listen.pls&t=.m3u",
        Description = "Jamaica",
	},
	{
		Name = "Meagton Cafe",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://us2.internet-radio.com:8443/listen.pls&t=.m3u",
        Description = "Piano songs i guess",
	},
	{
		Name = "K-Pop",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://167.114.64.181:8325/listen.pls?sid=1&t=.m3u",
        Description = "Nani",
	},
	{
		Name = "Telemedellin Radio",
        Link = "https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://51.222.14.10:8058/listen.pls?sid=1&t=.m3u",
        Description = "Telemedellin"
	},
}

local pausemat = Material("meth/pause.png")
local playmat = Material("meth/play.png")
local skipmat = Material("meth/skip.png")
local skipbackmat = Material("meth/skipback.png")

local PANEL = {}
function PANEL:Init()
    self.contents = self:Add("Panel")
    self.contents:Dock(FILL)
    self.scroll = self.contents:Add("DScrollPanel")
    self.scroll:Dock(FILL)
    local vbar = self.scroll:GetVBar()
    vbar:SetHideButtons( true )
    vbar.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.gripbackground)
    end
    vbar.btnGrip.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.grip)
    end
    vbar:SetWide(4)
    vbar:DockMargin(1,1,1,1)
    for k , v in ipairs(methamphetamine.radiostations) do
        local song = self.scroll:Add("DPanel")
        song:Dock(TOP)
        song:SetTall(40)
        song.table = v
        song.Paint = function(pnl,w,h)
            draw.SimpleText(v.Name,methamphetamine.default.font,8,8,methamphetamine.colors.text,0,0)
            draw.SimpleText(v.Description,methamphetamine.default.font,8,25,methamphetamine.colors.activebutton,0,2)
        end
        song.play = song:Add("DButton")
        song.play:Dock(RIGHT)
        song.play:SetWide( song:GetTall() )
        song.play:SetText("")
        song.play.Paint = function(pnl,w,h)
            surface.SetMaterial( playmat )
            surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.disabledtext or methamphetamine.colors.activebutton )
            surface.DrawTexturedRect(8,8,w-16,h-16)
        end
        song.play.DoClick = function(pnl)
            methamphetamine.currentradiostationname = v.Name
            PlaySong( v.Link )
        end
    end
end
vgui.Register("methamphetamine.radiopage", PANEL)


mods:Add("Radio Stations", function( mod , toggle )
    if not toggle then 
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(350,400)
    mod.panel:Center()
    mod.panel:SetTitle("Radio Stations")
    mod.panel.current = mod.panel:Add("Panel")
    mod.panel.current:Dock(TOP)
    mod.panel.current:DockMargin(0,5,0,0)
    mod.panel.current:SetTall(80)
    mod.panel.current.Paint =  function(pnl,w,h)
        draw.SimpleText("Currently Playing \"" .. methamphetamine.currentradiostationname .. "\"" , methamphetamine.default.font, w/2, h*0.2, methamphetamine.colors.text,1,1 )
        draw.RoundedBox(4,w*0.15,h*0.4,w*0.7,4, methamphetamine.colors.border )
        if IsValid(methamphetamine.currentradiostation) then
            draw.RoundedBox(6,w*0.15 + (methamphetamine.currentradiostation:GetTime()/methamphetamine.currentradiostation:GetLength()) * w*0.7,h*0.4-3,6,6, methamphetamine.colors.border)
            draw.RoundedBox( 6,w*0.15,h*0.4, (methamphetamine.currentradiostation:GetTime()/methamphetamine.currentradiostation:GetLength()) * w*0.7,4, methamphetamine.colors.activebutton )
            draw.RoundedBox(8,w*0.15 + (methamphetamine.currentradiostation:GetTime()/methamphetamine.currentradiostation:GetLength()) * w*0.7 - 2, h*0.4 -2 , 8,8, methamphetamine.colors.activebutton)
            draw.SimpleText( string.FormattedTime(methamphetamine.currentradiostation:GetLength()-(methamphetamine.currentradiostation:GetLength()-methamphetamine.currentradiostation:GetTime()), "%02i:%02i" ), methamphetamine.default.font , w*0.15 , h*0.4+3 , methamphetamine.colors.text, 0,2 )
            draw.SimpleText(  (methamphetamine.currentradiostation:GetLength() < 0 and "Inf") or string.FormattedTime(methamphetamine.currentradiostation:GetLength(), "%02i:%02i" ), methamphetamine.default.font , w*0.85 , h*0.4+3 , methamphetamine.colors.text, TEXT_ALIGN_RIGHT,2 )
        end
    end
    -- mod.panel.current.slider = mod.panel.current:Add("DButton")
    -- --mod.panel.current.slider:SetPos(8,w*0.15 + (methamphetamine.currentradiostation:GetTime()/methamphetamine.currentradiostation:GetLength()) * w*0.7 - 2)
    -- mod.panel.current.slider:SetSize(8,8)
    -- mod.panel.current.slider.Paint = function(pnl,w,h)
    --     draw.RoundedBox(8,0,0,w,h,methamphetamine.colors.activebutton)
    -- end
    -- mod.panel.current.slider.ypos = mod.panel.current:GetTall()*0.4-3
    -- mod.panel.current.slider.Think = function(pnl)  
    --     if IsValid( methamphetamine.currentradiostation ) then
    --         pnl:SetPos(mod.panel.current:GetWide()*0.15 + (methamphetamine.currentradiostation:GetTime()/methamphetamine.currentradiostation:GetLength()) * mod.panel.current:GetWide()*0.7, pnl.ypos )     
    --     end
    -- end
    -- mod.panel.current.slider.DoClick = function(pnl)
    --     if IsValid( methamphetamine.currentradiostation ) then
    --         local x,y = input.GetCursorPos()
    --         local w,h = mod.panel.current:GetSize()
    --         local x1,y1 = mod.panel.current:LocalToScreen()
    --         local sx,sy = pnl:GetSize()
    --         local diff = ((x-x1)/(w))*methamphetamine.currentradiostation:GetLength()
    --         methamphetamine.currentradiostation:SetTime( diff )
    --     end
    -- end 

    mod.panel.current.toggle = mod.panel.current:Add("DButton")
    mod.panel.current.toggle:SetSize(26,26) 
    mod.panel.current.toggle:SetText("")
    mod.panel.current.toggle.Paint = function(pnl,w,h)
        surface.SetMaterial( not pnl.Paused and pausemat or playmat )
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.disabledtext or methamphetamine.colors.activebutton )
        surface.DrawTexturedRect(0,0,w-0,h-0)
    end
    mod.panel.current.toggle.Paused = false
    mod.panel.current.toggle.DoClick = function(pnl)
        if not IsValid( methamphetamine.currentradiostation ) then return end
        if not pnl.Paused then
            methamphetamine.currentradiostation:Pause()
            pnl.Paused = true
            return
        end
        methamphetamine.currentradiostation:Play()
        pnl.Paused = false
    end

    mod.panel.current.skip = mod.panel.current:Add("DButton")
    mod.panel.current.skip:SetSize(26,26) 
    mod.panel.current.skip:SetText("")
    mod.panel.current.skip.Paint = function(pnl,w,h)
        surface.SetMaterial( skipmat )
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.disabledtext or methamphetamine.colors.activebutton )
        surface.DrawTexturedRect(1,1,w-2,h-2)
    end
    mod.panel.current.skip.DoClick = function(pnl)
        if not IsValid( methamphetamine.currentradiostation ) then return end
        
    end

    mod.panel.current.skipback = mod.panel.current:Add("DButton")
    mod.panel.current.skipback:SetSize(26,26) 
    mod.panel.current.skipback:SetText("")
    mod.panel.current.skipback.Paint = function(pnl,w,h)
        surface.SetMaterial( skipbackmat )
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.disabledtext or methamphetamine.colors.activebutton )
        surface.DrawTexturedRect(1,1,w-2,h-2)
    end
    mod.panel.current.skipback.DoClick = function(pnl)
        if not IsValid( methamphetamine.currentradiostation ) then return end
        
    end


    mod.panel.current.PerformLayout = function(pnl,w,h)
        mod.panel.current.toggle:SetPos( w /2 - 13, h *0.62 )
        mod.panel.current.skip:SetPos( w /2 + 13 + 3, h *0.62 )
        mod.panel.current.skipback:SetPos( w/2 - 26 - 13 -3, h *0.62 )
    end

    mod.panel.channels = mod.panel:Add("methamphetamine.submods")
    mod.panel.channels:Dock(FILL)
    mod.panel.channels:AddCheat("Radio", "methamphetamine.radiopage")
    mod.panel.channels:AddCheat("Youtube", "DButton")
    mod.panel.channels:AddCheat("History", "DButton")
end)    

local PANEL = {}
function PANEL:Init()
    self.list = self:Add("DScrollPanel")
    local vbar = self.list:GetVBar()
    vbar:SetHideButtons( true )
    vbar.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.gripbackground)
    end
    vbar.btnGrip.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.grip)
    end
    vbar:SetWide(4)
    vbar:DockMargin(0,2,2,2)
    self.list:Dock(FILL)
    self:AddLine("Name","SteamID","Team","Friend",nil,true)
    for k , v in ipairs( player.GetAll()) do
        self:AddLine( v:Name(),v:SteamID(), team.GetName(v:Team()), methamphetamine.friends[v] and "Yes" or "No",v ) 
    end
end

function PANEL:AddLine( name,sid,team,friend,obj,underline )
    local line = self.list:Add("DPanel")
    line:Dock(TOP)
    line:SetTall(20)
    line.ply = obj
    line.friendtxt = friend
    line:DockMargin(0,0,0,0)
    line.Paint = function(pnl,w,h)
        if underline then
            surface.SetDrawColor( methamphetamine.colors.activebutton )
            surface.DrawRect(0,h-1,w,1)
        end
        surface.DrawRect((550/4)*1,0,1,h)
        surface.DrawRect((550/4)*2,0,1,h)
        surface.DrawRect((550/4)*3,0,1,h)
        surface.DrawRect((550/4)*4,0,1,h)
    end
    line.name = line:Add("DButton")
    line.name:Dock(LEFT)
    line.name:SetText("")
    line.name:SetWide( 550/4 )
    line.name.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( name, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end
    line.sid = line:Add("DButton")
    line.sid:Dock(LEFT)
    line.sid:SetText("")
    line.sid:SetWide( 550/4 )
    line.sid.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )

        draw.SimpleText( sid , methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )

    end
    line.team = line:Add("DButton")
    line.team:Dock(LEFT)
    line.team:SetText("")
    line.team:SetWide( 550/4 )
    line.team.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )

        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( team, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end

    line.friend = line:Add("DButton")
    line.friend:Dock(LEFT)
    line.friend:SetText("")
    line.friend:SetWide( 550/4 )
    line.friend.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( line.friendtxt, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end
    line.friend.DoClick = function(pnl)
        if line.ply then
            methamphetamine.friends[line.ply] = not (methamphetamine.friends[line.ply] or false)
            line.friendtxt = methamphetamine.friends[line.ply] and "Yes" or "No"
        end
    end
end
vgui.Register("methamphetamine.playerlist", PANEL)
local PANEL = {}

function PANEL:Init()
    self.list = self:Add("DScrollPanel")
    local vbar = self.list:GetVBar()
    vbar:SetHideButtons( true )
    vbar.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.gripbackground)
    end
    vbar.btnGrip.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.grip)
    end
    vbar:SetWide(4)
    vbar:DockMargin(0,2,2,2)
    self.list:Dock(FILL)
    self:AddLine("Name","Shown on ESP",true)
    for k , v in SortedPairs(scripted_ents.GetList()) do
        print(k,v)
        self:AddLine( v.t.ClassName, methamphetamine.mods["ESP"].Entities[v.ClassName] or false ) 
    end
end

function PANEL:AddLine( classname,shown,underline )
    local line = self.list:Add("DPanel")
    line:Dock(TOP)
    line:SetTall(20)
    line:DockMargin(0,0,0,0)
    line.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        if underline then
            surface.DrawRect(0,h-1,w,1)
            draw.SimpleText("Shown on ESP", methamphetamine.default.font , w/2 + 10 , h/2 , methamphetamine.colors.text ,0,1)
        end
        surface.DrawRect((550/2),0,1,h)

    end

    line.name = line:Add("DButton")
    line.name:Dock(LEFT)
    line.name:SetText("")
    line.name:SetWide( (550/2) )
    line.name.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( classname, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end
    if not underline then
        line.shownonesp = line:Add("methamphetamine.checkbox")
        line.shownonesp:NoClipping( false )
        line.shownonesp:SetPos( 550/2+3 + 1,1  )
        line.shownonesp:SetLabel("")
        line.shownonesp:SetSize( 20-2,20-2 ) 
        line.shownonesp:SetState( methamphetamine.mods["ESP"].Entities[classname] or false ) 
        line.shownonesp:Configure("ESP","Entities",classname)
        -- line.shownonesp.Paint = function(pnl,w,h)
        --     surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        --     surface.DrawRect(0,0,w,h)
        --     surface.SetDrawColor( methamphetamine.colors.            activebutton )
        --     -- surface.DrawRect(w-1,0,1,h)
        --     --draw.SimpleText( line.shownonesptxt, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
        -- end
        line.shownonesp.OnToggle = function(pnl,state)   
            methamphetamine.mods["ESP"].Entities[classname] = (state or false)
        end
    end
    
end

vgui.Register("methamphetamine.entitylist",PANEL)

local PANEL = {}

function PANEL:Init()
    self.list = self:Add("DScrollPanel")
    local vbar = self.list:GetVBar()
    vbar:SetHideButtons( true )
    vbar.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.gripbackground)
    end
    vbar.btnGrip.Paint = function(pnl,w,h)
        draw.RoundedBox(4,0,0,w,h,methamphetamine.colors.grip)
    end
    vbar:SetWide(4)
    vbar:DockMargin(0,2,2,2)
    self.list:Dock(FILL)
    self:AddLine(0,"Name","Ignore",true)
    for k , v in SortedPairs(team.GetAllTeams()) do
        print(k,v)
        self:AddLine(k,v.Name, false ) 
    end
end

function PANEL:AddLine( id,name,shown,underline )
    local line = self.list:Add("DPanel")
    line:Dock(TOP)
    line:SetTall(20)
    line:DockMargin(0,0,0,0)
    line.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        if underline then
            surface.DrawRect(0,h-1,w,1)
            draw.SimpleText("Ignore", methamphetamine.default.font , w/2 + 10 , h/2 , methamphetamine.colors.text ,0,1)
        end
        surface.DrawRect((550/2),0,1,h)

    end

    line.name = line:Add("DButton")
    line.name:Dock(LEFT)
    line.name:SetText("")
    line.name:SetWide( (550/2) )
    line.name.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( name, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end
    if not underline then
        line.addteam = line:Add("methamphetamine.checkbox")
        line.addteam:NoClipping( false )
        line.addteam:SetPos( 550/2+3 + 1,1  )
        line.addteam:SetLabel("")
        line.addteam:SetSize( 20-2,20-2 ) 
        line.addteam:SetState( methamphetamine.mods["Aim"].Teams[id] or false )
        line.addteam.OnToggle = function(pnl,state)   
            methamphetamine.mods["Aim"].Teams[id] = (state or false)
        end
    end
    
end


vgui.Register("methamphetamine.teamlist", PANEL )

mods:Add("Environment List", function( mod , toggle )
    if not toggle then 
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(550,480)
    mod.panel:Center()
    mod.panel:SetTitle("Environment List")
    mod.panel.contents = mod.panel:Add("methamphetamine.submods")
    mod.panel.contents:Dock(FILL)
    mod.panel.contents:AddCheat("Player List", "methamphetamine.playerlist")
    mod.panel.contents:AddCheat("Entity List", "methamphetamine.entitylist")
    mod.panel.contents:AddCheat("Team List", "methamphetamine.teamlist")
end)    


hook.Remove("ScalePlayerDamage","methamphetamine.log",function( ply, hitgroup, dmginfo )
    local attacker = dmginfo:GetAttacker()
    methamphetamine.Log( attacker:Nick().. " dealt " .. dmginfo:GetDamage() .. " damage to ".. ply:Nick().. " using a ".. attacker:GetActiveWeapon():GetClass()  )
end)


mods:Add("Debug Console", function (mod,toggle)

    if not toggle then 
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.frame")
    mod.panel:SetSize(550,300)
    mod.panel:SetPos(5,5)
    mod.panel:SetTitle("BullyWare - Console")
    mod.panel.scroll = mod.panel:Add("DScrollPanel")
    mod.panel.scroll:Dock(FILL)
    mod.panel.scroll:DockMargin(4,4,4,4)
    local vbar = mod.panel.scroll:GetVBar()
    function vbar:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, methamphetamine.colors.grip )
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, methamphetamine.colors.gripbackground)
    end
    vbar:SetWide(4)
    vbar:SetHideButtons(true)


    for k , v in ipairs(methamphetamine.DebugLogs) do
        if k == 200 then return end
        if not IsValid(mod.panel) then return end
        local panel = mod.panel.scroll:Add("Panel")
        panel:Dock(TOP)
        panel:SetZPos(6)
        panel.markup = markup.Parse( "<colour=179,179,179,255><font=".. methamphetamine.default.font..">".. "[".. os.date("%X",v.time).."] ".. v.text .. "</font></colour>", mod.panel:GetWide() - 12  )
        panel:SetTall( panel.markup:GetHeight() + 8 )
        panel.Paint = function (pnl,w,h)
            surface.SetDrawColor( v.id % 2 == 0 and methamphetamine.colors.gripbackground or methamphetamine.colors.menubar )
            surface.DrawRect(0,0,w,h)
            pnl.markup:Draw(4,4)
        end
    end
    hook.Add("methamphetamine.log","AddToDebugger",function (tbl)
        if mod.panel.scroll or IsValid(mod.panel.scroll) then
            local panel = mod.panel.scroll:Add("Panel")
            panel:Dock(TOP)
            panel:SetZPos(6)
            -- panel.Label = panel:Add("DLabel")
            -- panel.Label:Dock(FILL)
            -- panel.Label:SetFont(methamphetamine.default.font)
            -- panel.Label:SetTextColor(methamphetamine.colors.text)
            -- panel.Label:SetWrap(true)
            -- panel.Label:SizeToContents()
            -- panel.Label:SetText("[".. os.date("%X",tbl.time).."] ".. tbl.text)
            panel.markup = markup.Parse( "<colour=179,179,179,255><font=".. methamphetamine.default.font..">".. "[".. os.date("%X",tbl.time).."] ".. tbl.text .. "</font></colour>", mod.panel:GetWide() - 12  )

            panel:SetTall( panel.markup:GetHeight() + 8 )
            panel.Paint = function (pnl,w,h)
                surface.SetDrawColor( tbl.id % 2 == 0 and methamphetamine.colors.gripbackground or methamphetamine.colors.menubar )
                surface.DrawRect(0,0,w,h)
                pnl.markup:Draw(4,4)
            end
        end
    end)
end)



mods:Add("Force close", function(mod,toggle)
    methamphetamine.master:SetVisible(false)
end)

return mods


