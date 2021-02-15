--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
]]--

local PANEL = {}

color_transparent = color_transparent or Color(255,255,255,0)

function PANEL:Init()

    methamphetamine.mods["Aim"]["Key"] = 0
    methamphetamine.mods["Aim"]["enabled"] = false
    methamphetamine.mods["Aim"]["Silent"] = 1
    methamphetamine.mods["Aim"]["hook"] = function() end
    methamphetamine.mods["Aim"]["Rage"] = false
    methamphetamine.mods["Aim"]["Autofire"] = false
    methamphetamine.mods["Aim"]["Nospread"] = false
    methamphetamine.mods["Aim"]["NoRecoil"] = false
    methamphetamine.mods["Aim"]["TargetLock"] = false
    methamphetamine.mods["Aim"]["DisableOnKill"] = false
    methamphetamine.mods["Aim"]["AutoWall"] = false
    methamphetamine.mods["Aim"]["FOV"] = 0
    methamphetamine.mods["Aim"]["Priority"] = "Field of View" 
    methamphetamine.mods["Aim"]["Jittering"] = 0
    methamphetamine.mods["Aim"]["Smooth"] = 0
    methamphetamine.mods["Aim"]["RecoilControl"] = 0
    methamphetamine.mods["Aim"]["Limb"] = "Head"
    methamphetamine.mods["Aim"]["Teams"] = {}
    methamphetamine.mods["Aim"]["Ignore"] = {
        Friends = false,
        Noclipping = false,
        OppositeTeam = false,
        SameTeam = false,
        Transparent = false,
        Invisible = false,
        Party = false,
        SelectedTeams = false,
    }


    self.masterpanel = self:Add("Panel")
    self.masterpanel:Dock(TOP)
    self.masterpanel:SetTall(25)
    self.mastertoggle = self.masterpanel:Add("methamphetamine.checkbox")
    self.mastertoggle:SetPos(0,0)
    self.mastertoggle:SetSize(20,20)
    self.mastertoggle:MethToolTip("Enables the aimbot.")
    self.mastertoggle.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].enabled = state
    end
    self.mastertoggle:Configure("Aim","enabled")

    print( methamphetamine.mods["Aim"] )

    

    self.options = self:Add("methamphetamine.panel")
    self.options:Dock(LEFT)
    self.options:SetPos(0,7)
    self.options.lblpnl = self.options:Add("Panel")
    self.options.lblpnl:Dock(TOP)
    self.options.lblpnl:SetTall(23)
    self.options.lblpnl.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(5,h-1,w-10,1)
    end
    self.options.label = self.options.lblpnl:Add("DLabel")
    self.options.label:Dock(BOTTOM)
    self.options.label:SetText( "Options" )
    self.options.label:SetFont( methamphetamine.default.font )
    self.options.label:SetTextColor( methamphetamine.colors.text )
    self.options.label:DockMargin(8,0,0,0)
    self.options.label:SizeToContents()
    local options = self.options
    options.Key = options:Add("Panel")
    options.Key:Dock(TOP)
    options.Key:SetTall(41)
    options.Key:DockMargin(8,5,60,0)
    
    options.Key.Label = options.Key:Add("DLabel")
    options.Key.Label:Dock(TOP)
    options.Key.Label:SetText("Key")
    options.Key.Label:SetTextColor( methamphetamine.colors.text )
    options.Key.Label:SetFont( methamphetamine.default.font )
    
    options.Key.Button = options.Key:Add("methamphetamine.binder")
    options.Key.Button:Dock(TOP)
    options.Key.Button:SetTall(20)
    options.Key.Button:MethToolTip("Enables the aimbot only when this key is pressed.")
    options.Key.Button:SetText("Always")
    options.Key.Button:SetValue( methamphetamine.mods["Aim"].Key )
    options.Key.Button:SetTextColor( methamphetamine.colors.text )
    options.Key.Button:SetFont( methamphetamine.default.font )
    options.Key.Button.Paint = function(pnl,w,h)
        surface.SetDrawColor( (pnl:IsHovered() and  methamphetamine.colors.activetoggle) or methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
    end
    options.Key.Button.OnChange = function(pnl,new)
        print("Selected ", new , input.GetKeyName( new ) )
        methamphetamine.mods["Aim"]["Key"] = new
    end
    options.Key.Button:Configure("Aim","Key")


    options.Silent = options:Add("Panel")
    options.Silent:Dock(TOP)
    options.Silent:SetTall(42)
    options.Silent:DockMargin(8,0,60,0)
    --options.Silent.Paint = function(pnl,w,h) draw.RoundedBox(0,0,0,w,h,color_white) end

    options.Silent.Label = options.Silent:Add("DLabel")
    options.Silent.Label:Dock(TOP)
    options.Silent.Label:SetText("Silent")
    options.Silent.Label:SetTextColor( methamphetamine.colors.text )
    options.Silent.Label:SetFont( methamphetamine.default.font )

    options.Silent.Dropdown = options.Silent:Add("methamphetamine.dropdown")
    options.Silent.Dropdown:Dock(TOP)
    options.Silent.Dropdown:SetTall(20)
    options.Silent.Dropdown:AddChoice("Disabled", function() methamphetamine.mods["Aim"].Silent = 0  end)
    options.Silent.Dropdown:AddChoice("Client", function() methamphetamine.mods["Aim"].Silent = 1  end)
    options.Silent.Dropdown:AddChoice("Server", function() methamphetamine.mods["Aim"].Silent = 2  end)
    options.Silent.Dropdown:SetValue( methamphetamine.mods["Aim"].Silent or 0 )
    options.Silent.Dropdown:Configure("Aim","Silent")


    options.autofirepnl = options:Add("Panel")
    options.autofirepnl:Dock(TOP)
    options.autofirepnl:SetTall(21)
    --options.autofirepnl.Paint = function(pnl,w,h) draw.RoundedBox(0,0,0,w,h,color_white) end
    options.autofirepnl.autofire = options.autofirepnl:Add("methamphetamine.checkbox")
    options.autofirepnl.autofire:SetSize(20,20)
    options.autofirepnl.autofire:SetPos(8,0)
    options.autofirepnl.autofire:SetLabel("Autofire")
    options.autofirepnl.autofire:SetState( methamphetamine.mods["Aim"].Autofire )
    options.autofirepnl.autofire.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"]["Autofire"] = state
    end
    options.autofirepnl.autofire:Configure("Aim","Autofire")

    options.ignorepnl = options:Add("Panel")
    options.ignorepnl:Dock(TOP)
    options.ignorepnl:DockMargin(8,1,0,0)
    options.ignorepnl:SetTall(20)
    options.ignorepnl.ignore = options.ignorepnl:Add("methamphetamine.miscdrop")
    --options.ignorepnl.ignore:SetTall(20)
    options.ignorepnl.ignore:SetLabel("When Spectated")
    options.ignorepnl.ignore:Dock(LEFT)
    options.ignorepnl.ignore:AddOption("Toggle",{
        panel = "methamphetamine.checkbox",
        text = "Change on Spectation",
        tooltip = "Forces aimbot settings to the ones below while being spectated",
    })
    options.ignorepnl.ignore:AddOption("ToggleAimbot",{
        panel = "methamphetamine.checkbox",
        text = "Enabled",
        tooltip = "Enables the aimbot.",
    })
    options.ignorepnl.ignore:AddOption("Toggle3",{
        panel = "methamphetamine.slider",
        text = "Change on Spectation",
        tooltip = "Forces aimbot settings to the ones below while being spectated",
        max = 10
    })

    
    




    self.accuracy = self:Add("methamphetamine.panel")
    self.accuracy:Dock(LEFT)
    self.accuracy:SetPos(0,7)
    self.accuracy.lblpnl = self.accuracy:Add("Panel")
    self.accuracy.lblpnl:Dock(TOP)
    self.accuracy.lblpnl:SetTall(23)
    self.accuracy.lblpnl.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(5,h-1,w-10,1)
    end
    self.accuracy.label = self.accuracy.lblpnl:Add("DLabel")
    self.accuracy.label:Dock(BOTTOM)
    self.accuracy.label:SetText( "Accuracy" )
    self.accuracy.label:SetFont( methamphetamine.default.font )
    self.accuracy.label:SetTextColor( methamphetamine.colors.text )
    self.accuracy.label:DockMargin(8,0,0,0)
    self.accuracy.label:SizeToContents() 
    local accuracy = self.accuracy

    accuracy.nos = accuracy:Add("Panel")
    accuracy.nos:Dock(TOP)
    accuracy.nos:SetTall(20)
    accuracy.nos:DockMargin(0,4,0,1)
    accuracy.nospread = accuracy.nos:Add("methamphetamine.checkbox")
    accuracy.nospread:SetLabel("No Spread")
    accuracy.nospread:MethToolTip("Just a placebo unfortunately")
    accuracy.nospread:SetState( methamphetamine.mods["Aim"].Nospread )
    accuracy.nospread:SetPos(8,0)
    accuracy.nospread:SetSize(20,20)
    accuracy.nospread.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].NoSpread = state
    end
    accuracy.nospread:Configure("Aim","NoSpread")


    accuracy.nor = accuracy:Add("Panel")
    accuracy.nor:Dock(TOP)
    accuracy.nor:SetTall(20)
    accuracy.nor:DockMargin(0,1,0,1)
    accuracy.norecoil = accuracy.nor:Add("methamphetamine.checkbox")
    accuracy.norecoil:SetLabel("No Recoil")
    accuracy.norecoil:MethToolTip("Shit barely works with cw\nI will need to make it more reliable later.")
    accuracy.norecoil:SetState( methamphetamine.mods["Aim"].Norecoil )
    accuracy.norecoil:SetPos(8,0)
    accuracy.norecoil:SetSize(20,20)
    accuracy.norecoil.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].NoRecoil = state
    end 
    accuracy.norecoil:Configure("Aim","NoRecoil")

    accuracy.recoilcontrol = accuracy:Add("Panel")
    accuracy.recoilcontrol:Dock(TOP)
    accuracy.recoilcontrol:SetTall(35)
    --accuracy.recoilcontrol:DockPadding(8,0,8,0)
    accuracy.recoilcontrol:DockMargin(8,1,8,1)
    accuracy.recoilcontrollbl = accuracy.recoilcontrol:Add("DLabel")
    accuracy.recoilcontrollbl:Dock(TOP)
    accuracy.recoilcontrollbl:SetText("Recoil Control")
    accuracy.recoilcontrollbl:SetTextColor(methamphetamine.colors.text)
    accuracy.recoilcontrollbl:SetFont(methamphetamine.default.font)
    accuracy.recoilcontrollbl:SizeToContents()
    accuracy.recoilcontrol = accuracy.recoilcontrol:Add("methamphetamine.slider")
    accuracy.recoilcontrol:SetMax(1.5)
    accuracy.recoilcontrol:SetRound(false)
    accuracy.recoilcontrol:Dock(TOP)
    accuracy.recoilcontrol:SetTall(20)
    accuracy.recoilcontrol:SetValue( methamphetamine.mods["Aim"].RecoilControl )
    accuracy.recoilcontrol.OnValueChanged = function(pnl,frac)
        methamphetamine.mods["Aim"].RecoilControl = frac*5
    end
    accuracy.recoilcontrol:Configure("Aim","RecoilControl")


    accuracy.smo = accuracy:Add("Panel")
    accuracy.smo:Dock(TOP)
    accuracy.smo:SetTall(35)
    --accuracy.smo:DockPadding(8,0,8,0)
    accuracy.smo:DockMargin(8,1,8,1)
    accuracy.smolbl = accuracy.smo:Add("DLabel")
    accuracy.smolbl:Dock(TOP)
    accuracy.smolbl:SetText("Smoothing")
    accuracy.smolbl:SetTextColor(methamphetamine.colors.text)
    accuracy.smolbl:SetFont(methamphetamine.default.font)
    accuracy.smolbl:SizeToContents()
    accuracy.smooth = accuracy.smo:Add("methamphetamine.slider")
    accuracy.smooth:SetMax(50)
    accuracy.smooth:Dock(TOP)
    accuracy.smooth:SetTall(20)
    accuracy.smooth:SetValue( methamphetamine.mods["Aim"].Smooth )
    accuracy.smooth.OnValueChanged = function(pnl,frac)
        methamphetamine.mods["Aim"].Smooth = frac*50
    end
    accuracy.smooth:Configure("Aim","Smooth")

    accuracy.jit = accuracy:Add("Panel")
    accuracy.jit:Dock(TOP)
    accuracy.jit:SetTall(35)
    --accuracy.jit:DockPadding(8,0,8,0)
    accuracy.jit:DockMargin(8,1,8,1)
    accuracy.jitlbl = accuracy.jit:Add("DLabel")
    accuracy.jitlbl:Dock(TOP)
    accuracy.jitlbl:SetText("Jittering")
    accuracy.jitlbl:SetTextColor(methamphetamine.colors.text)
    accuracy.jitlbl:SetFont(methamphetamine.default.font)
    accuracy.jitlbl:SizeToContents()
    accuracy.jittering = accuracy.jit:Add("methamphetamine.slider")
    accuracy.jittering:SetMax(10)
    accuracy.jittering:Dock(TOP)
    accuracy.jittering:SetValue(methamphetamine.mods["Aim"].Jittering)
    accuracy.jittering:SetTall(20)
    accuracy.jittering.OnValueChanged = function(pnl,frac)
        methamphetamine.mods["Aim"].Jittering = frac*50
    end
    accuracy.jittering:Configure("Aim","Jittering")

    accuracy.hitbox = accuracy:Add("Panel")
    accuracy.hitbox:Dock(TOP)
    accuracy.hitbox:SetTall(35)
    accuracy.hitbox:DockMargin(8,1,8,1)
    accuracy.hitboxlabel = accuracy.hitbox:Add("DLabel")
    accuracy.hitboxlabel:Dock(TOP)
    accuracy.hitboxlabel:SetText("Hitbox")
    accuracy.hitboxlabel:SetTextColor(methamphetamine.colors.text)
    accuracy.hitboxlabel:SetFont(methamphetamine.default.font)
    accuracy.hitboxlabel:SizeToContents()
    accuracy.hitbox = accuracy.hitbox:Add("methamphetamine.dropdown")
    accuracy.hitbox:AddChoice("Head", function() methamphetamine.mods["Aim"].Limb = "Head" end)
    accuracy.hitbox:AddChoice("Hitscan", function() methamphetamine.mods["Aim"].Limb = "Spine" end)
    accuracy.hitbox:AddChoice("Body", function() methamphetamine.mods["Aim"].Limb = "Spine" end)
    accuracy.hitbox:SetValue( methamphetamine.mods["Aim"].Limb )
    accuracy.hitbox:Dock(TOP)
    accuracy.hitbox:SetTall(20)
    accuracy.smooth:Configure("Aim","Smooth")
  

    self.target = self:Add("methamphetamine.panel")
    self.target:Dock(LEFT)
    self.target.lblpnl = self.target:Add("Panel")
    self.target.lblpnl:Dock(TOP)
    self.target.lblpnl:SetTall(23)
    self.target.lblpnl.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(5,h-1,w-10,1)
    end
    self.target.label = self.target.lblpnl:Add("DLabel")
    self.target.label:Dock(BOTTOM)
    self.target.label:SetText( "Target" )
    self.target.label:SetFont( methamphetamine.default.font )
    self.target.label:SetTextColor( methamphetamine.colors.text )
    self.target.label:DockMargin(8,0,0,0)
    self.target.label:SizeToContents()
    local target = self.target


    target.fov = target:Add("Panel")
    target.fov:Dock(TOP)
    target.fov:SetTall(35)
    --target.fov:DockPadding(8,0,8,0)
    target.fov:DockMargin(8,4,8,1)
    target.fovlbl = target.fov:Add("DLabel")
    target.fovlbl:Dock(TOP)
    target.fovlbl:SetText("FoV")
    target.fovlbl:SetTextColor(methamphetamine.colors.text)
    target.fovlbl:SetFont(methamphetamine.default.font)
    target.fovlbl:SizeToContents()
    target.fov = target.fov:Add("methamphetamine.slider")
    target.fov:SetMax(180)
    target.fov:Dock(TOP)
    target.fov:SetTall(20)
    target.fov:SetValue( methamphetamine.mods["Aim"].FOV )
    target.fov.OnValueChanged = function(pnl,frac)
        methamphetamine.mods["Aim"].FOV = frac*180
    end
    target.fov:Configure("Aim","FOV")

    
    target.TLock = target:Add("Panel")
    target.TLock:Dock(TOP)
    target.TLock:SetTall(20)
    target.TLock:DockMargin(0,1,0,1)
    target.TargetLock = target.TLock:Add("methamphetamine.checkbox")
    target.TargetLock:SetLabel("Target Lock")
    target.TargetLock:MethToolTip("Makes the aimbot aim at one target unless dead or not visible.")
    target.TargetLock:SetPos(8,0)
    target.TargetLock:SetState( methamphetamine.mods["Aim"].TargetLock )
    target.TargetLock:SetSize(20,20)
    target.TargetLock.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].TargetLock = state
    end 
    target.TargetLock:Configure("Aim","TargetLock")

    target.priority = target:Add("Panel")
    target.priority:Dock(TOP)
    target.priority:SetTall(35)
    target.priority:DockMargin(8,1,8,1)
    target.prioritylabel = target.priority:Add("DLabel")
    target.prioritylabel:Dock(TOP)
    target.prioritylabel:SetText("Priority")
    target.prioritylabel:SetTextColor(methamphetamine.colors.text)
    target.prioritylabel:SetFont(methamphetamine.default.font)
    target.prioritylabel:SizeToContents()
    target.priority = target.priority:Add("methamphetamine.dropdown")
    target.priority:AddChoice("Closest Distance", function() methamphetamine.mods["Aim"].Priority = "Closest Distance" end)
    target.priority:AddChoice("Least Health", function() methamphetamine.mods["Aim"].Priority = "Least Health" end)
    target.priority:AddChoice("Most Health", function() methamphetamine.mods["Aim"].Priority = "Most Health" end)
    target.priority:AddChoice("Field of View", function() methamphetamine.mods["Aim"].Priority = "Field of View" end)
    target.priority:Dock(TOP)
    target.priority:SetTall(20)
    target.priority:SetValue( methamphetamine.mods["Aim"].Priority )
    target.priority:Configure("Aim","Priority")

    target.DOK = target:Add("Panel")
    target.DOK:Dock(TOP)
    target.DOK:SetTall(20)
    target.DOK:DockMargin(0,1,0,1)
    target.DOK = target.DOK:Add("methamphetamine.checkbox")
    target.DOK:SetLabel("Disable on Kill")
    target.DOK:MethToolTip("Makes the aimbot aim at one target unless dead or not visible.")
    target.DOK:SetPos(8,0)
    target.DOK:SetState( methamphetamine.mods["Aim"].DisableOnKill )
    target.DOK:SetSize(20,20)
    target.DOK.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].DisableOnKill = state
    end 
    target.DOK:Configure("Aim","DisableOnKill")

    target.AutoWall = target:Add("Panel")
    target.AutoWall:Dock(TOP)
    target.AutoWall:SetTall(20)
    target.AutoWall:DockMargin(0,1,0,1)
    target.AutoWall = target.AutoWall:Add("methamphetamine.checkbox")
    target.AutoWall:SetLabel("Auto Wall")
    target.AutoWall:MethToolTip("Makes the aimbot aim at one target unless dead or not visible.")
    target.AutoWall:SetPos(8,0)
    target.AutoWall:SetState( methamphetamine.mods["Aim"].AutoWall )
    target.AutoWall:SetSize(20,20)
    target.AutoWall.OnToggle = function(pnl,state)
        methamphetamine.mods["Aim"].AutoWall = state
    end 
    target.AutoWall:Configure("Aim","Autowall")

    target.ignore = target:Add("Panel")
    target.ignore:Dock(TOP)
    target.ignore:SetTall(20)
    target.ignore:DockMargin(0,1,0,1)
    target.ignore.ignore = target.ignore:Add("methamphetamine.miscdrop")
    target.ignore.ignore:SetPos(8,0)    
    target.ignore.ignore:SetLabel("Ignore")
    target.ignore.ignore:AddOption("Friends",{
        panel = "methamphetamine.checkbox",
        text = "Friends",
        tooltip = "Makes the Aimbot not target players who are marked as friends.",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["Friends"] = state
        end,
        Configure = {"Aim","Ignore","Friends"}
    })
    target.ignore.ignore:AddOption("Party Members",{
        panel = "methamphetamine.checkbox",
        text = "Party Members",
        tooltip = "Makes the Aimbot not target players who are in your party.",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["Party"] = state
        end,
        Configure = {"Aim","Ignore","Party"}
    })
    target.ignore.ignore:AddOption("Same Team",{
        panel = "methamphetamine.checkbox",
        text = "Same Team",
        tooltip = "Makes the Aimbot not target players who are the same team as you.",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["SameTeam"] = state
        end,
        Configure = {"Aim","Ignore","SameTeam"}

    })
    target.ignore.ignore:AddOption("Selected Teams",{
        panel = "methamphetamine.checkbox",
        text = "Selected Teams",
        tooltip = "Makes the Aimbot not target players on the teams you've selected on the Teams List.",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["SelectedTeams"] = state
        end,
        Configure = {"Aim","Ignore","SelectedTeams"}
    })
    target.ignore.ignore:AddOption("Opposite Teams",{
        panel = "methamphetamine.checkbox",
        text = "Opposite Teams",
        tooltip = "Makes the Aimbot not target players who are on any other team but yours..",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["OppositeTeam"] = state
        end,
        Configure = {"Aim","Ignore","OppositeTeam"}
    })
    target.ignore.ignore:AddOption("Noclipping",{
        panel = "methamphetamine.checkbox",
        text = "Noclipping",
        tooltip = "Makes the Aimbot not target players who are no-clipping.",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["Noclipping"] = state
        end,
        Configure = {"Aim","Ignore","Noclipping"}
    })
    target.ignore.ignore:AddOption("Transparent",{
        panel = "methamphetamine.checkbox",
        text = "Transparent",
        tooltip = "Makes the Aimbot not target players who are transparent (Typically spawn protected).",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["Transparent"] = state
        end,
        Configure = {"Aim","Ignore","Transparent"}
    })
    target.ignore.ignore:AddOption("Invisible",{
        panel = "methamphetamine.checkbox",
        text = "Invisible",
        tooltip = "Makes the Aimbot not target players who are invisible. (Typically admins or anti-cheat bots)",
        OnToggle = function(pnl,state)
            methamphetamine.mods["Aim"]["Ignore"]["Invisible"] = state
        end,
        Configure = {"Aim","Ignore","Invisible"}
    })

end

function PANEL:PerformLayout(w,h)
    self.options:SetWide( 192 )
    self.options:DockMargin(0,0,4,0)

    self.accuracy:SetWide( 215 )
    self.accuracy:DockMargin(0,0,0,0)

    self.target:SetWide( 205 )
    self.target:DockMargin(4,0,0,0)
end

PANEL.Paint = nil

vgui.Register("methamphetamine.aim.aimbot", PANEL )


local PANEL = {}
AccessorFunc(PANEL,"m_color","Color")
function PANEL:Init()
    self.box = self:Add("DColorMixer")
    self.box:SetSize( 230-16,215-16 )
    self.box:SetPos(8,8)
    self.box:SetPalette(false)
    self.box:SetAlphaBar(false)
    self.box:SetWangs( false )
    self.box.OnFocusChanged = function(pnl,gained)
        if gained then return end
        timer.Simple(0,function()
            local panel = vgui.GetKeyboardFocus()
            if panel.isTooltip or panel == pnl then return end
            pnl:Remove()
        end)
    end

    self.bigcircle = methamphetamine.circles.New( CIRCLE_OUTLINED,8 , 0,0 )
    self.box.HSV.Knob.Paint = function(pnl,w,h)
        if pnl:IsHovered() and input.IsMouseDown( MOUSE_LEFT ) then
            surface.DrawCircle( w/2 , h/2 , w/2 , 255,255,255,255 )
        else
            surface.DrawCircle( w/2 , h/2 , 4 , 255,255,255,255 )
        end
    end
    self.box.HSV.OnUserChanged = function(pnl,col)
        self:SetColor( col )
        if pnl.OnColourChanged then
            pnl:OnColourChanged( col )
        end
    end

    self.hex = self:Add("Panel")
    self.hex:Dock(BOTTOM)
    self.hex:SetTall(20)
    self.hex:DockMargin(8,1,8,8)
    self.hex.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
        local col = self:GetColor()
        draw.SimpleText( string.upper(string.format("#%x%x%x", col.r,col.g,col.b )) , methamphetamine.default.font , 4, h/2, methamphetamine.colors.text , 0 , 1 )
    end


    self.rgb = self:Add("Panel")
    self.rgb:Dock(BOTTOM)
    self.rgb:DockPadding(8,0,8,0)
    self.rgb:SetTall(20)

    local w = (230-16)/4


    self.rgb.r = self.rgb:Add("DPanel")
    self.rgb.r:Dock(LEFT)
    self.rgb.r:DockMargin(0,1,1,1)
    self.rgb.r:SetWide(w)  
    self.rgb.r.Paint = function(pnl,w,h)
        
        surface.SetDrawColor( methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( string.format("R: %d", self:GetColor().r ), methamphetamine.default.font , 4,h/2,methamphetamine.colors.text,0,1 )
    end
    
    self.rgb.g = self.rgb:Add("DPanel")
    self.rgb.g:Dock(LEFT)
    self.rgb.g:DockMargin(0,1,1,1)
    self.rgb.g:SetWide(w)  
    self.rgb.g.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( string.format("G: %d", self:GetColor().g ), methamphetamine.default.font , 4,h/2,methamphetamine.colors.text,0,1 )
    end

    self.rgb.b = self.rgb:Add("DPanel")
    self.rgb.b:Dock(LEFT)
    self.rgb.b:DockMargin(0,1,1,1)
    self.rgb.b:SetWide(w)  
    self.rgb.b.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( string.format("B: %d", self:GetColor().b ), methamphetamine.default.font , 4,h/2,methamphetamine.colors.text,0,1 )
    end
    
    self.rgb.a = self.rgb:Add("DPanel")
    self.rgb.a:Dock(LEFT)
    self.rgb.a:DockMargin(0,1,0,1)
    self.rgb.a:SetWide(w-1) 
    self.rgb.a.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.buttonidle )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( string.format("A: %d", self:GetColor().a ), methamphetamine.default.font , 4,h/2,methamphetamine.colors.text,0,1 )
    end 

end

vgui.Register("methamphetamine.colorbox",PANEL, "methamphetamine.panel")

local PANEL = {}
AccessorFunc(PANEL,"m_defaultCol","Color")
function PANEL:Init()
    if !self:GetColor() then self:SetColor( color_white ) end   
    self:SetText("")
end

function PANEL:Paint(w,h)
    local col = self:GetColor()
    surface.SetDrawColor(  col.r,col.g,col.b )
    surface.DrawRect(0,0,w,h)
end

function PANEL:OnCursorEntered()
    if IsValid( self.preivew ) then self.preview:Remove() end
    local col = color_white
    self.preview = vgui.Create("methamphetamine.panel")

    self.preview.isPreview = true
    local x,y = input.GetCursorPos()
    self.preview:SetPos( x + 20 , y )
    self.preview:SetSize(230,60)
    self.preview:MakePopup()
    self.preview.col = self.preview:Add("Panel")
    self.preview.col:SetPos(8,8)
    self.preview.col:SetSize(44,44)
    self.preview.col.Paint = function(pnl,w,h)
        local col = self:GetColor()
        surface.SetDrawColor( col.r, col.g, col.b, 255 ) 
        surface.DrawRect( 0,0,w,h )
    end
    self.preview.hex = self.preview:Add("DLabel")
    self.preview.hex:SetPos( 60 , 8 )
    self.preview.hex:SetFont( methamphetamine.default.font )
    self.preview.hex:SetTextColor( methamphetamine.colors.text )

    self.preview.rgb = self.preview:Add("DLabel")
    self.preview.rgb:SetPos( 60 , 22 )
    self.preview.rgb:SetFont( methamphetamine.default.font )
    self.preview.rgb:SetTextColor( methamphetamine.colors.text )

    self.preview.ratio = self.preview:Add("DLabel")
    self.preview.ratio:SetPos( 60 , 35 )
    self.preview.ratio:SetFont( methamphetamine.default.font )
    self.preview.ratio:SetTextColor( methamphetamine.colors.text )

end
function PANEL:OnCursorExited()
    if IsValid( self.preview ) then self.preview:Remove() return end
end
function PANEL:Think()
    if IsValid( self.preview ) then
        self.preview:MoveToFront()
        local col = self:GetColor()
        print( col )
        self.preview.hex:SetText( "#" .. string.upper(string.format("#%x%x%x", col.r, col.g, col.b )) )
        self.preview.rgb:SetText( string.format("R:%d, G:%d, B:%d, A:%d", col.r,col.g,col.b,col.a) )
        self.preview.ratio:SetText( string.format("(%.3f, %.3f, %.3f, %.3f)", col.r/255,col.g/255,col.b/255,col.a/255) )
        self.preview.ratio:SizeToContents()
        self.preview.rgb:SizeToContents()
        self.preview.hex:SizeToContents()

    end
end

function PANEL:OnCursorMoved()
    if not IsValid( self.preview ) then return end
    local x,y = input.GetCursorPos()
    self.preview:SetPos( x + 20 , y )
end
function PANEL:DoClick()
    if IsValid( self.menu ) then self.menu:SetVisible( not self.menu:IsVisible() ) self.menu:MakePopup() local x,y = input.GetCursorPos() self.menu:SetPos(x+1,y+1) return end
    if IsValid(self.preview) then self.preview:Remove() end
    local x,y = input.GetCursorPos()
    self.menu = vgui.Create("methamphetamine.colorbox")
    self.menu:SetSize( 230,260 )
    self.menu:SetPos( x+1, y+1 )
    self.menu:MakePopup()
    self.menu:SetColor( self:GetColor() )
    self.menu.box.HSV.OnUserChanged = function(pnl,col)
        self.menu:SetColor( col )
        self:SetColor( col )
        self:OnColourChanged( col )
    end
    self.menu.OnFocusChanged = function(pnl,gained)
        if gained then return end
        timer.Simple(0,function()
            local panel = vgui.GetKeyboardFocus()
            if not IsValid( panel ) then return end
            if panel.isTooltip or panel == pnl or panel.isPreview then return end
            pnl:SetVisible( false )
        end)
    end
end

function PANEL:OnColourChanged( colour )

end
vgui.Register("methamphetamine.colorselector", PANEL, "DButton" )

local PANEL = {}

function PANEL:Init()
    self.m_Text = ""
    self.toggle = self:Add("methamphetamine.checkbox")
    self.toggle:Dock(LEFT)
    self.toggle:DockMargin(2,0,2,0)
    self.toggle:SetWide( 20 )
    self.toggle:SetLabel("Box")

    self.activecol = self:Add("methamphetamine.colorselector")
    self.activecol:Dock(RIGHT)
    self.activecol:SetWide(20)
    self.activecol:DockMargin(1,1,1,1)
    self.activecol.OnColourChanged = function( panel, colour )
        self:OnColourChanged( colour )
    end

    self.espcol = self:Add("methamphetamine.dropdown")
    self.espcol:Dock(RIGHT)
    self.espcol:SetWide(101)
    self.espcol:DockMargin(0,0,0,0)
    self.espcol:HideDiamond(true)
    

    self.esptype = self:Add("methamphetamine.dropdown")
    self.esptype:Dock(RIGHT)
    self.esptype:SetWide(106)
    self.esptype:HideDiamond(true)
    self.esptype:DockMargin(2,0,2,0)
end

function PANEL:AddChoice( name , func )
    self.esptype:AddChoice( name , func )
end

function PANEL:SetText( txt )
    self.m_Text = txt
    self.toggle:SetLabel( txt )
end

function PANEL:GetText()
    return self.m_Text
end

function PANEL:OnColourChanged( colour )

end
function PANEL:SetColor( col )

end
vgui.Register("methamphetamine.espoption", PANEL)

local espdata = {
    presets = {
        {
            {
                name = "2D [None]",
            },
            {
                name = "2D [Inner]",
            },
            {
                name = "2D [Outer]",
            },
            {
                name = "2D [Both]",
            },
            {
                name = "Cornered [None]",
            },
            {
                name = "Cornered [Inner]",
            },
            {
                name = "3D [None]",
            },
        },
        {
            {
                name = "Top",
            },
            {
                name = "Left",
            },
            {
                name = "Bottom",
            },
            {
                name = "Right",
            },
        },
        {
            {
                name = "Flat",
            },
            {
                name = "Texture",
            },
            {
                name = "Wallhack",
            },
            {
                name = "Wireframe",
            },
        },
        {
            {
                name = "Selected Color",
            },
            {
                name = "Rainbow",
            },
        },
        {
            {
                name = "Selected Color",
            },
            {
                name = "Team Color",
            },
            {
                name = "Health Color",
            },
            {
                name = "Rainbow",
            }
        }
    },
}
espdata.options = {
    {
        name = "Box",
        options = espdata.presets[1],
    },
    {
        name = "Health [Txt]",
        options = espdata.presets[2],
    },
    {
        name = "Health [Bar]",
        options = espdata.presets[2],
    },
    {
        name = "Weapon",
        options = espdata.presets[2],

    },
    {
        name = "Chams [P.]",
        options = espdata.presets[3],
        colors = espdata.presets[4]
        
    },
    {
        name = "Chams [W.]",
        options = espdata.presets[3],
        colors = espdata.presets[4]

    },
    {
        name = "Glow",
        options = espdata.presets[3],

    },
    {
        name = "Name",
        options = espdata.presets[2],

    },
    {
        name = "Distance",
        options = espdata.presets[2],

    },
    {
        name = "Team",
        options = espdata.presets[2],

    },
    {
        name = "Rank",
        options = espdata.presets[2],

    },
    {
        name = "Skeleton",
        options = {
            { name = "None" }   
        },
    },
}


local PANEL = {}

function  PANEL:Init()
    methamphetamine.mods["ESP"]["colors"] = {
        ["Box"] = color_white,
        ["Health [Txt]"] = color_white,
        ["Health [Bar]"] = color_white,
        ["Chams [P.]"] = color_white,
        ["Chams [W.]"] = color_white,
        ["Glow"] = color_white,
        ["Name"] = color_white,
        ["Distance"] = color_white,
        ["Team"] = color_white,
        ["Rank"] = color_white,
        ["Skeleton"] = color_white,
    }
    methamphetamine.mods["ESP"]["enabled"] = {
        ["Box"] = false,
        ["Health [Txt]"] = false,
        ["Health [Bar]"] = false,
        ["Chams [P.]"] = false,
        ["Chams [W.]"] = false,
        ["Glow"] = false,
        ["Name"] = false,
        ["Distance"] = false,
        ["Team"] = false,
        ["Rank"] = false,
        ["Skeleton"] = false,
    }
    methamphetamine.mods["ESP"]["types"] = {
        ["Box"] = "2D [None]",
        ["Health [Txt]"] = "Top",
        ["Name"] = "Top",
        ["Distance"] = "Top",
        ["Team"] = "Top",
        ["Rank"] = "Top",
    }
    methamphetamine.mods["ESP"]["colortype"] = {
        ["Box"] = "Selected Color",
        ["Health [Txt]"] = "Selected Color",
        ["Health [Bar]"] = "Selected Color",
        ["Chams [P.]"] = "Selected Color",
        ["Chams [W.]"] = "Selected Color",
        ["Glow"] = "Selected Color",
        ["Name"] = "Selected Color",
        ["Distance"] = "Selected Color",
        ["Team"] = "Selected Color",
        ["Rank"] = "Selected Color",
        ["Skeleton"] = "Selected Color",
    }
    methamphetamine.mods["ESP"]["Range"] = 3000

    
    self.players = self:Add("methamphetamine.panel")
    self.players.espdata = espdata
    self.players:Dock(LEFT)
    self.players:SetPos(0,7)
    self.players.lblpnl = self.players:Add("Panel")
    self.players.lblpnl:Dock(TOP)
    self.players.lblpnl:SetTall(23)
    self.players.lblpnl.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(5,h-1,w-10,1)
    end
    self.players.label = self.players.lblpnl:Add("DLabel")
    self.players.label:Dock(BOTTOM)
    self.players.label:SetText( "Players" )
    self.players.label:SetFont( methamphetamine.default.font )
    self.players.label:SetTextColor( methamphetamine.colors.text )
    self.players.label:DockMargin(8,0,0,0)
    self.players.label:SizeToContents()

    local players = self.players
    
    players.panels = {}
    for k , v in ipairs( players.espdata.options ) do
        players.panels[k] = players:Add("methamphetamine.espoption")
        local option = players.panels[k]
        option:Dock(TOP)
        option:SetTall(20)
        option:DockMargin(4,1,4,1)
        option:SetText( v.name )
        option.OnColourChanged = function(pnl,col)
            methamphetamine.mods["ESP"].colors[ v.name ] = col
        end
        option.activecol:Configure("ESP","colors",v.name)
        option.toggle.OnToggle = function(pnl,state)
            methamphetamine.mods["ESP"].enabled[ v.name ] = state
        end 
        option.toggle:Configure("ESP","enabled",v.name)
        for k , op in ipairs( v.options or { name = "None" } ) do
            option:AddChoice( op.name , function(pnl,id,name) methamphetamine.mods["ESP"].types[ v.name ] = op.name end)
            option:Configure("ESP","types",v.name)
        end
        for k , col in ipairs( v.colors or players.espdata.presets[5] ) do
            option.espcol:AddChoice( col.name , function(panel,id,name) methamphetamine.mods["ESP"].colortype[ v.name ] = name end)
            option.espcol:Configure("ESP","colortype",v.name)
        end
    end
    

    self.miscplayers = self:Add("methamphetamine.panel")
    self.miscplayers:Dock(LEFT)
    self.miscplayers:SetPos(0,7)
    self.miscplayers.lblpnl = self.miscplayers:Add("Panel")
    self.miscplayers.lblpnl:Dock(TOP)
    self.miscplayers.lblpnl:SetTall(23)
    self.miscplayers.lblpnl.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(5,h-1,w-10,1)
    end
    self.miscplayers.label = self.miscplayers.lblpnl:Add("DLabel")
    self.miscplayers.label:Dock(BOTTOM)
    self.miscplayers.label:SetText( "Misc Players" )
    self.miscplayers.label:SetFont( methamphetamine.default.font )
    self.miscplayers.label:SetTextColor( methamphetamine.colors.text )
    self.miscplayers.label:DockMargin(8,0,0,0)
    self.miscplayers.label:SizeToContents()
    local misc = self.miscplayers

end

function PANEL:PerformLayout(w,h)
    self.players:SetWide(w*0.55-2)
    self.players:DockMargin(0,0,2,0)
    self.miscplayers:SetWide(w*0.45-2)
    self.miscplayers:DockMargin(2,0,0,0)

end


vgui.Register("methamphetamine.esp.player",PANEL)

local PANEL = {}

function PANEL:Init()    
    self.label = self:Add("DLabel")
    self.label:SetFont( methamphetamine.default.font )
    self.label:SetTextColor( methamphetamine.colors.text )
    self.label:SetText("Available configs:")
    self.label:SizeToContents()
    self.label:SetPos(4,0)
    self.configs = self:Add("Panel")
    self.configs:SetPos(4,20)
    self.configs:SetSize(150,270)
    self.configs.Paint = function(pnl,w,h)
        surface.SetDrawColor(methamphetamine.colors.buttonidle)
        surface.DrawRect(0,0,w,h)
    end
    self.configs.list = self.configs:Add("DScrollPanel")
    self.configs.list:Dock(FILL)
    self.configs.list.configs = {}
    self.buttons = self:Add("Panel")
    self.buttons:SetPos(4,294)
    self.buttons:SetSize(150,20)
    self.refresh = self.buttons:Add("DButton")
    self.refresh:Dock(LEFT)
    self.refresh:SetText("Refresh")
    self.refresh:SetFont( methamphetamine.default.font )
    self.refresh:SetTextColor( methamphetamine.colors.text )
    self.refresh:SizeToContents(8)
    self.refresh.Paint = function(pnl,w,h)
        surface.SetDrawColor(pnl:IsHovered() and methamphetamine.colors.border or methamphetamine.colors.hovered)
        surface.DrawRect(0,0,w,h)
    end
    self.refresh.DoClick = function()
        self:Refresh()
    end
    self.new = self.buttons:Add("DButton")
    self.new:Dock(LEFT)
    self.new:DockMargin(4,0,0,0)
    self.new:SetText("New")
    self.new:SetFont( methamphetamine.default.font )
    self.new:SetTextColor( methamphetamine.colors.text )
    self.new:SizeToContents(8)
    self.new.Paint = function(pnl,w,h)
        surface.SetDrawColor(pnl:IsHovered() and methamphetamine.colors.border or methamphetamine.colors.hovered)
        surface.DrawRect(0,0,w,h)
    end
    self.new.DoClick = function(pnl)
        Derma_StringRequest(
            "Save config", 
            "Set a name for this config",
            "",
            function(text) 
                local dir = "methamphetamine/configs/".. text .. ".txt"
                file.Write( dir , util.TableToJSON(methamphetamine.mods,true) )
                self:Refresh()
            end
        )
    end

    self:Refresh()
end

function PANEL:Refresh()
    self.configs.list:Clear()
    local dir = "methamphetamine/configs"
    local files,_ = file.Find( dir .. "/*.txt" , "DATA" )
    methamphetamine.configs = {}
    for k , v in ipairs( files ) do
        methamphetamine.configs[string.sub(v,1,#v-4)] = {util.JSONToTable( file.Read(dir.. "/".. v ) ),v}
    end

    --PrintTable( methamphetamine.configs )
    for k , v in pairs( methamphetamine.configs ) do
        self.configs.list.configs[#self.configs.list.configs + 1] = self.configs.list:Add("DButton")
        local conf = self.configs.list.configs[#self.configs.list.configs ]
        conf:Dock(TOP)
        conf:SetTall(20)    
        conf.config = v[1]
        conf.DoClick = function(pnl)
            methamphetamine.mods = pnl.config

            hook.Run("methamphetamine.configLoaded",pnl.config)
        end
        conf.DoRightClick = function(pnl)
            Derma_Query("Are you sure you want to remove ".. k .. "?","poo","Yes",function()
                file.Delete( "methamphetamine/configs/"..v[2] )
        
                self:Refresh()
            end,"No",function() end)
        end
        conf.Paint = function(pnl,w,h)
            surface.SetDrawColor(pnl:IsHovered() and methamphetamine.colors.border or methamphetamine.colors.hovered)
            surface.DrawRect(0,0,w,h)
            surface.SetTextPos(4,2)
            surface.SetTextColor( methamphetamine.colors.text )
            surface.SetFont( methamphetamine.default.font )
            surface.DrawText( k )
        end
        conf:SetText("")
    end
end
vgui.Register("methamphetamine.configs",PANEL)

