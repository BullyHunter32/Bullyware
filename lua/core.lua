--[[
    ____        ______     _       __              
   / __ )__  __/ / / /_  _| |     / /___ _________ 
  / __  / / / / / / / / / / | /| / / __ `/ ___/ _ \
 / /_/ / /_/ / / / / /_/ /| |/ |/ / /_/ / /  /  __/
/_____/\__,_/_/_/_/\__, / |__/|__/\__,_/_/   \___/ 
                  /____/                           
]]--


methamphetamine = {}
methamphetamine.configs = {}
methamphetamine.mods = {}
methamphetamine.friends = {}
methamphetamine.entityesp = {}
methamphetamine.teams = {}
methamphetamine["colors"] = {
    ["border"] = Color(80,80,80),
    ["text"] = Color(179,179,179),
    ["disabledtext"] = Color(179,179,179),
    ["menubar"] = Color(30,30,30),
    ["background"] = Color(28,28,28),
    ["backgroundopaque"] = Color(25,25,25,170),
    ["hovered"] = Color(90,90,90),
    ["divider"] = Color(97,97,97),
    ["activebutton"] = Color(103,103,103),
    ["buttonidle"] = Color(46,46,46),
    ["activetoggle"] = Color(90,90,90),
    ["grip"] = Color(90,90,90),
    ["gripbackground"] = Color(37,37,37),
    ["backgroundmascot"] = Color(255,255,255,70)
}
include("essentials.lua")

methamphetamine["default"] = {
    ["title"] = "methamphetamine.solutions",
    ["font"] = "methamphetamine.font",
    ["_font"] = "Raleway",--"Raleway",
    ["tickmat"] =  Material("meth/tick.png"),
    ["outlinefont"] = "metamphetamine.font.outline"
}

local mascots = {
    ["zerotwo"] = Material("meth/mascots/zerotwo.png"),
    ["slavcat"] =  Material("meth/mascots/bcat.png"),
    ["pepesquat"]  = Material("meth/mascots/slavpepe.png"),
    ["obama"] = Material("meth/mascots/obama.png"),
}
methamphetamine["mascots"] = { -- may need some configuring for your resolution
    ["active"] = "obama",
    ["zerotwo"] = {
        mat = mascots["zerotwo"],
        x = ScrW() - mascots["zerotwo"]:Width() * 0.6,
        y = ScrH() - mascots["zerotwo"]:Height()*0.6,
        w = mascots["zerotwo"]:Width() * 0.6,
        h = mascots["zerotwo"]:Height() * 0.6,
    },
    ["slavcat"] = {
        mat = mascots["slavcat"],
        x = ScrW() - mascots["slavcat"]:Width()*1.2,
        y = ScrH() - mascots["slavcat"]:Height()*1.2,
        w = mascots["slavcat"]:Width()*1.2,
        h = mascots["slavcat"]:Height()*1.4,
    },
    ["pepesquat"] = {
        mat = mascots["pepesquat"],
        x = ScrW() - mascots["pepesquat"]:Width()*1,
        y = ScrH() - mascots["pepesquat"]:Height()*0.6,
        w = mascots["pepesquat"]:Width()*1,
        h = mascots["pepesquat"]:Height()*1,
    },
    ["obama"] = {
        mat = mascots["obama"],
        x = ScrW() - mascots["obama"]:Width()*0.2   ,
        y = ScrH() - mascots["obama"]:Height()*0.2,
        w = mascots["obama"]:Width()*0.2,
        h = mascots["obama"]:Height()*0.2,
    }
}

methamphetamine.DebugLogs = {}
methamphetamine.Log = function (text)
    local tbl = {text = text,time = os.time(), id = #methamphetamine.DebugLogs + 1}
    table.insert( methamphetamine.DebugLogs , tbl )
    if #methamphetamine.DebugLogs > 200 then
        table.remove( methamphetamine.DebugLogs )
    end
    hook.Run("methamphetamine.log", tbl )
end

hook._add = hook._add or hook.Add
function hook.Add( x , y , z )
    if methamphetamine.Log then methamphetamine.Log("Hook Added\n["..x.."] ".. tostring(y) ) end
    return hook._add(x,y,z)
end

surface.CreateFont( methamphetamine.default.font , {
    font = methamphetamine.default._font,
    size = 15,
    weight = 150,
})



local panelMetaTable = FindMetaTable("Panel")
function panelMetaTable:MethToolTip( text )
    self._hasToolTip = true
    self.OnCursorEntered = function(self)
        print("Entered")
        self._tooltip = vgui.Create("DPanel")
        print( self._tooltip )
        local x,y = input.GetCursorPos()
        self._tooltip:SetPos( x+20,y )
        self._tooltip.isTooltip = true
        self._tooltip:SetSize(1000,1000)
        self._tooltip:SetKeyboardInputEnabled( true )
        self._tooltip:MakePopup()
        self._tooltip.markup = markup.Parse("<font="..methamphetamine.default.font.."><colour=179,179,179,255>"..text.."</colour></font>")   
        self._tooltip.Paint = function(pnl,w,h)
            surface.SetDrawColor( methamphetamine.colors.background )
            surface.DrawRect(0,0,w,h)
            surface.SetDrawColor( methamphetamine.colors.border )
            surface.DrawOutlinedRect( 0,0,w,h )
            pnl.markup:Draw(15 , 7 , 0 , 0 )
        end
        self._tooltip.Think = function(pnl)
            if not self:IsHovered() then pnl:Remove() end
        end
        self._tooltip.PerformLayout = function(pnl,w,h) 
            self._tooltip:SetSize( pnl.markup:GetWidth() + 30 , pnl.markup:GetHeight() + 15 )
        end
    end

    self.OnCursorExited = function(pnl)
        if IsValid( self._tooltip ) then
            self._tooltip:Remove()
            print("Removed!")
        end
    end

    self.OnCursorMoved = function(pnl)
        if not IsValid(self._tooltip) then return end
        local x,y = input.GetCursorPos()
        self._tooltip:SetPos( x+20 , y )
    end
end

function panelMetaTable:ConfigUpdate(func)
    local s = debug.getinfo(2).source
    methamphetamine.Log("Use of deprecated function at\n".. s )
end

function panelMetaTable:Configure( ... )
    if not ispanel(self) then 
        PrintTable( debug.getinfo(2) )
        print(
        [[
        ///////////////////
        // INVALID PANEL //
        ///////////////////
        ]] )
        return
    end 
    local tbl = {...}
    hook.Add("methamphetamine.configLoaded",self,function( mods )
        if not IsValid(self) then 
            hook.Remove("methampheteamine.configLoaded",self)
            return 
        end
        local str = "methamphetamine.mods"
        local index = methamphetamine.mods
        for k , v in ipairs(tbl) do
            if not index then
                print("Invalid index!\t".. str )
                return
            end
            str = str .. "[".. tostring(v) .. "]"
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
                PrintTable( index )
                print("ZZ")
                self:SetColor( Color( index.r,index.g,index.b,index.a ) )
            else
                methamphetamine.Log("[ERROR] SETTING COLOR NOT TABLE: " .. tostring(index) )
            end 
        end
        
    end)
end


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
    surface.DrawRect(2,2,w-4,h-4)
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
    if (!pnl.Depressed) then return end
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
function PANEL:SetValue( x )
    self.fraction = math.Clamp(x/self:GetMax(),0,1)
end
function PANEL:SetRound( bool )
    self.floor = tobool(bool)
end
function PANEL:OnValueChanged(fraction,val) end

function PANEL:Paint(w, h)
  local height = self:GetHeight()   
  local y = h / 2 - height / 2
  surface.SetDrawColor(methamphetamine.colors.buttonidle)
  surface.DrawRect(0,0,w,h)
  local width = self.fraction * w 
  draw.SimpleText( self.floor and math.floor(self.fraction * self:GetMax()) or string.format("%.3f",self.fraction*self:GetMax()), methamphetamine.default.font,w/2,h/2,methamphetamine.colors.text,1,1 )
end

function PANEL:PerformLayout(w, h)
  self.grip:SetTall(h,h)
  self.grip:SetPos(self.fraction * (w - self.grip.size*2) )
end

vgui.Register( "methamphetamine.slider", PANEL, "DButton" )



local PANEL = {}
function PANEL:Init()
    local cx,cy = input.GetCursorPos()
    self:SetText("Default Text")
    self:SetFont(methamphetamine.default.font)
    self:SetTextColor(methamphetamine.colors.text)
    self._menu = vgui.Create("methamphetamine.panel")
    -- self._menu.Think = function(pnl)
    --     if not (methamphetamine.master:IsVisible()) then
    --         pnl:SetVisible(false)
    --     end
    -- end
    self._menu.OnFocusChanged = function(pnl,gained)
        if gained then return end
        timer.Simple(0,function()
            local panel = vgui.GetKeyboardFocus()
            if not IsValid( panel ) then return end
            if panel.isTooltip or panel == pnl or self.boolops[panel] or panel == self._menu then return end
            pnl:SetVisible( false )
        end)
    end
    self._menu:SetPos(cx+1,cy+1)
    self._menu:SetSize(240,225)
    self._menu:MakePopup()
    self._menu:DockPadding(8,8,8,8)
    self._menu:SetVisible(false)
    self.ops = {}
    self.oplen = 0
    self.boolops = {}
end

function  PANEL:SetLabel( text )
    self:SetText( text )
    self:SetFont(methamphetamine.default.font)
    self:SizeToContentsX(10)
end

function PANEL:DoClick()
    if IsValid(self._menu) then
        self._menu:SetVisible( not self._menu:IsVisible() )
        local cx,cy = input.GetCursorPos()
        self._menu:SetPos(cx+1,cy+1)
        self._menu:MakePopup()
        return
    end
end

function PANEL:AddOption( name , data )
    
    self.ops[name] = self._menu:Add( "Panel" )
    self.ops[name]:Dock(TOP)
    self.ops[name]:DockMargin(0,1,0,1)
    self.ops[name]:SetTall(20)
    self.ops[name].content = self.ops[name]:Add( data.panel )
    self.boolops[self.ops[name].content] = true
    self.boolops[self.ops[name]] = true
    if data.panel == "methamphetamine.checkbox" then
        self.ops[name].content:Dock(LEFT)
        self.ops[name].content:SetWide(20)
        self.ops[name].content:SetLabel( data.text )
        self.ops[name].content.OnToggle = data.OnToggle
    end
    if data.panel == "methamphetamine.slider" then
        self.ops[name].content:Dock(TOP)
        self.ops[name].content:SetTall(20)
        --self.ops[name].content:SetLabel( data.text )
        self.ops[name].content:SetMax( data.max )
        self.ops[name].content.OnValueChanged = data.OnValueChanged
    end
    if data.tooltip then
        self.ops[name].content:MethToolTip( data.tooltip ) 
    end
    --print("\n\n\n\n\n".. tostring(data.ConfigUpdate) .. "\n\n\n\n\n")
    self.ops[name].content.ConfigUpdate = data.ConfigUpdate
    self.oplen = self.oplen + 1
    self._menu:SetTall( math.max(self.oplen * 22 + 16,20) )
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(self:IsHovered() and methamphetamine.colors.hovered or methamphetamine.colors.border)
    surface.DrawRect(0,0,w,h)

end
vgui.Register("methamphetamine.miscdrop",PANEL,"DButton")

local PANEL = {}
local downarrowmat = Material("meth/down-arrow.png")
function PANEL:Init()
    self.m_HideDiamond = false
    self:SetFont( methamphetamine.default.font )
    self:SetTextColor( color_transparent )
    self.m_DropdownXPos = 0
    self.m_DropdownYPos = 0
    self.m_Choices = {}
end
function PANEL:Paint(w,h)
    surface.SetDrawColor( self:IsHovered() and methamphetamine.colors.activebutton or methamphetamine.colors.buttonidle )
    surface.DrawRect(0,0,w,h)
    if not self.m_HideDiamond then
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        surface.DrawRect(w-h,0,h,h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(downarrowmat)
        surface.DrawTexturedRect(w-h + 3,3,h-6,h-6)
    end

    draw.SimpleText( self.value.name , methamphetamine.default.font, 6,h/2, methamphetamine.colors.text,0,1 )
end
function PANEL:PerformLayout(w,h)
    local x,y = self:LocalToScreen()
    self.m_DropdownXPos = x
    self.m_DropdownYPos = y+h
end
function PANEL:AddChoice( name , onclick )
    self.m_Choices[#self.m_Choices+1] = {}
    local choice = self.m_Choices[#self.m_Choices]
    choice.name = name
    choice.id = #self.m_Choices
    choice.onclick = onclick
    self:SetValue(1)
end
function PANEL:SetValue( int )
    methamphetamine.Log("Setting value using var ".. tostring(int) )
    if type(int) == "string" then
        for k , v in ipairs( self.m_Choices ) do
            if v.name == int then
                int = v.id
                break
            end
        end
    end
    if not self.m_Choices[int] then
        return methamphetamine.Log("Attempting to index nil value " )
    end
    self:SetText( self.m_Choices[ int ].name )
    self.value = self.m_Choices[int]
end

function PANEL:GetValue()
    return self.value.id
end


function PANEL:DoClick()
    if IsValid( self.DropDownPanel ) then
        self.DropDownPanel:Remove()
        return
    end
    self.DropDownPanel = vgui.Create("methamphetamine.panel")
    self.DropDownPanel:SetSize( self:GetWide() ,30 )
    self.DropDownPanel:SetPos( self.m_DropdownXPos , self.m_DropdownYPos )
    self.DropDownPanel:MakePopup()
    self.DropDownPanel.OnFocusChanged = function(pnl,gained)
        if gained then return end
        timer.Simple(0,function()
            local panel = vgui.GetKeyboardFocus()
            if not IsValid( panel ) then return end
            if panel.isTooltip or panel == pnl or panel.isPreview then return end
            pnl:Remove()
        end)
    end
    self.DropDownPanel.Choices = {}
    for k , v in ipairs( self.m_Choices ) do
        self.DropDownPanel.Choices[#self.DropDownPanel.Choices + 1] = self.DropDownPanel:Add("DButton")
        local choice = self.DropDownPanel.Choices[#self.DropDownPanel.Choices]
        choice:Dock(TOP)
        choice.id = v.id
        choice:SetTall(20)
        choice.DoClick = function(pnl)
   
            v.onclick( choice , v.id, v.name )
            self:SetValue( pnl.id )
            self.DropDownPanel:Remove()
        end
        choice:SetText("")
        choice.Paint = function(pnl,w,h)
            surface.SetDrawColor( tonumber(self.value.id) == tonumber(pnl.id) and methamphetamine.colors.active or pnl:IsHovered() and methamphetamine.colors.hovered or color_transparent )
            surface.DrawRect(0,0,w,h)

            draw.SimpleText( v.name, methamphetamine.default.font, 6,h/2, methamphetamine.colors.text,0,1 )
        end
    end
    self.DropDownPanel:SetTall( #self.m_Choices * 20 )
end

function PANEL:HideDiamond( bool )
    self.m_HideDiamond = bool
end

vgui.Register("methamphetamine.dropdown", PANEL , "DButton" )

local PANEL = {}
function PANEL:Init()

end

vgui.Register("methamphetamine.list", PANEL , "EditablePanel" )

local PANEL = {}

function PANEL:Init()
    self:SetFont( methamphetamine.default.font )
    self:SetTextColor( methamphetamine.colors.text )
    -- self:SetMouseInputEnabled( true ) 
    -- self:SetKeyboardInputEnabled( true )
end

-- function PANEL:OnMousePressed()
--     self:MoveToFront()
--     self:RequestFocus()
-- end

function PANEL:Paint(w,h)
    surface.SetDrawColor( methamphetamine.colors.buttonidle )
    surface.DrawRect(0,0,w,h)
    self:DrawTextEntryText( methamphetamine.colors.text ,methamphetamine.colors.border,methamphetamine.colors.border )
end


vgui.Register("methamphetamine.search", PANEL , "DTextEntry")


local PANEL = {}

AccessorFunc( PANEL, "m_iSelectedNumber", "SelectedNumber" )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetSelectedNumber( 0 )
	self:SetSize( 60, 30 )

    self:SetTextColor( methamphetamine.colors.text )
    self:SetFont( methamphetamine.default.font )

end

function PANEL:UpdateText()

	local str = input.GetKeyName( self:GetSelectedNumber() or -1 )
	if ( !str ) then str = "None" end

	str = language.GetPhrase( str )

	self:SetText( string.upper(str) )

end

function PANEL:DoClick()

	self:SetText( "Press a key" )
	input.StartKeyTrapping()
	self.Trapping = true

end

function PANEL:DoRightClick()

	self:SetText( "Always" )
	self:SetValue( 0 )

end

function PANEL:SetSelectedNumber( iNum )

	self.m_iSelectedNumber = iNum
	self:ConVarChanged( iNum )
	self:UpdateText()
	self:OnChange( iNum )

end

function PANEL:Think()

	if ( input.IsKeyTrapping() && self.Trapping ) then

		local code = input.CheckKeyTrapping()
		if ( code ) then

			if ( code == KEY_ESCAPE ) then

                self:SetValue( 0 )
                self:SetText("Always")

			else

				self:SetValue( code )

			end

			self.Trapping = false

		end

	end

	self:ConVarNumberThink()

end

function PANEL:SetValue( iNumValue )

	self:SetSelectedNumber( iNumValue )

end

function PANEL:GetValue()

	return self:GetSelectedNumber()

end

function PANEL:OnChange()
end

function PANEL:Paint(w,h)
    surface.SetDrawColor( (self:IsHovered() and  methamphetamine.colors.activetoggle) or methamphetamine.colors.buttonidle )
    surface.DrawRect(0,0,w,h)

end

vgui.Register("methamphetamine.binder", PANEL , "DButton" )

local PANEL = {}

function PANEL:Init()

end

function PANEL:Paint(w,h)
    surface.SetDrawColor( methamphetamine.colors.background )
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor( methamphetamine.colors.border )
    surface.DrawOutlinedRect( 0,0,w,h )
end


vgui.Register("methamphetamine.panel", PANEL)


local PANEL = {}

function PANEL:Init()
    self.state = false
    self:SetText("")
    self.mat = Material("meth/tick.png")
    self:NoClipping( true )
end

function PANEL:SetState( newstate )
    self.state = newstate or self.state
end

function  PANEL:SetLabel( text )
    self.text = text
end


function PANEL:OnToggle()
end

function PANEL:DoClick()
    self.state = not self.state
    self:OnToggle( self.state )
end

function PANEL:Paint(w,h)
    surface.SetDrawColor( self:IsHovered() and  methamphetamine.colors.activetoggle or methamphetamine.colors.buttonidle )
    surface.DrawRect(0,0,w,h)
    if self.state then
        surface.SetMaterial( self.mat )
        surface.SetDrawColor( methamphetamine.colors.activebutton )
        surface.DrawTexturedRect(3,3,w-6,h-6)
    end
    draw.SimpleText( self.text or "Enabled" , methamphetamine.default.font , w + 5, h/2 , methamphetamine.colors.text , 0 , 1 )
end

vgui.Register("methamphetamine.checkbox", PANEL, "DButton" )



local PANEL = {}

function PANEL:Init()
    self.mods = self:Add("DPanel")
    self.mods:Dock(TOP)
    self.mods:SetTall(20)
    self.mods:DockMargin(0,0,0,0)
    self.mods.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(0,h-2,w,2)
    end
    self.mods:DockPadding(2 ,0,0,0)

   
    self.pages = {}
end
PANEL.Paint = nil

function PANEL:SetActive( i )
    local btn = self.pages[i]
    if IsValid( self.pages.active ) then
        self.pages.active:SetVisible( false )
    end
    btn.panel:SetVisible( true )
    self.pages.active = btn.panel
end
function PANEL:AddCheat( name , panel )
    local i = #self.pages + 1
    self.pages[i] = self.mods:Add("DButton")
    local btn = self.pages[i] 
    btn:Dock(LEFT)
    btn:DockMargin(1,3,1,2)
    btn:SetText( "" )
    surface.SetFont( methamphetamine.default.font )
    local wide,tall = surface.GetTextSize( name )
    btn:SetWide( wide + 8 )
    btn.Paint = function(pnl,w,h)
        surface.SetDrawColor( (pnl:IsHovered() or pnl.panel == self.pages.active) and methamphetamine.colors.activebutton or methamphetamine.colors.border )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( name , methamphetamine.default.font , w/2,h/2, methamphetamine.colors.disabledtext , 1,1 )
    end
    btn.DoClick = function(pnl)
        if self.pages.active == pnl.panel then return end
        btn.panel:SetVisible( true )
        if IsValid(self.pages.active) then
            self.pages.active:SetVisible(false)
        end
        self.pages.active = btn.panel
    end
    
    btn.panel = self:Add( panel or "DButton" )
    btn.panel:Dock(FILL)
    btn.panel:DockMargin(5,5,5,5    )
    btn.panel:SetVisible( false )
    return self.pages[i]
end

vgui.Register("methamphetamine.submods", PANEL)



local PANEL = {}

AccessorFunc( PANEL, "mResizeable", "Resizeable", FORCE_BOOL )
AccessorFunc( PANEL, "mShowCloseButton", "ShowCloseButton", FORCE_BOOL )

function PANEL:Init()

    self.bar = self:Add("DButton")
    self.bar:Dock(TOP)
    self.bar:SetTall(20)
    self.bar.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect( 0,0,w,h )
        draw.SimpleText( self.title or methamphetamine.default.title,methamphetamine.default.font,w/2,h/2,  methamphetamine.colors.disabledtext,1,1 )
    end
    self.bar:SetText("")


    local oldpress = self.OnMousePressed
    self.OnMousePressed = function(pnl,code)
        self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
        self:MouseCapture( true )       
    end

    self.OnMouseReleased = function(pnl,k)

        pnl.Dragging = nil
        pnl.Sizing = nil
        pnl:MouseCapture( false )
   
    end


    
    self.Think = function(pnl)
        local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
        local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )
    
        if ( pnl.Dragging ) then
    
            local x = mousex - pnl.Dragging[1]
            local y = mousey - pnl.Dragging[2]
    
            -- Lock to screen bounds if screenlock is enabled
            --if ( self:GetScreenLock() ) then
    
                x = math.Clamp( x, 0, ScrW() - self:GetWide() )
                y = math.Clamp( y, 0, ScrH() - self:GetTall() )
    
            --end
    
            self:SetPos( x, y )
    
        end
    end
    self.bar:SetCursor("arrow")
    self.bar.OnMousePressed = self.OnMousePressed
    self.bar.OnMouseReleased = self.OnMouseReleased
    self.bar.Think = self.Think
    self:SetCursor("arrow")

    self.diamond = self:Add("DButton")
    self.diamond:SetSize(20,20)
    self.diamond.mat = Material("meth/drag.png")
    self.diamond:SetText("")
    self.diamond.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.SetMaterial( pnl.mat )
        surface.DrawTexturedRect(0,0,w,h)
    end
    self.diamond:SetCursor("arrow")

    local oldpress_ = self.diamond.OnMousePressed
    self.diamond.OnMousePressed = function(pnl,code)
        
        pnl.Sizing = { gui.MouseX() - pnl.x - 20, gui.MouseY() - pnl.y - 20 }
        pnl:MouseCapture( true )


        oldpress_(pnl,code)
    end

    self.diamond.OnMouseReleased = function(pnl,k)

        pnl.Dragging = nil
        pnl.Sizing = nil
        pnl:MouseCapture( false )

    end
    self.diamond.m_iMinHeight = 80
    self.diamond.m_iMinWidth = 80
    
    self.diamond.Think = function(pnl)  

    local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
    local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

        if pnl.Sizing then
            
            local x = mousex - pnl.Sizing[1]
            local y = mousey - pnl.Sizing[2]
            local px, py = pnl:GetPos()

            if ( x < pnl.m_iMinWidth ) then x = pnl.m_iMinWidth elseif ( x > ScrW() - 10 && true ) then x = ScrW() - px  end
            if ( y < pnl.m_iMinHeight ) then y = pnl.m_iMinHeight elseif ( y > ScrH() - 10 && true ) then y = ScrH() - py  end

        self:SetSize( x, y )

        end
        
    end 


end


function PANEL:Paint(w,h)

    surface.SetDrawColor( methamphetamine.colors.background )
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor( methamphetamine.colors.border )
    surface.DrawOutlinedRect(0,0,w,h)
end

function PANEL:SetTitle( text )
    self.title = text
end

function PANEL:PerformLayout(w,h)
    if not self:GetResizeable() then
        self.diamond:Remove()
    end
    if IsValid( self.diamond ) then
        self.diamond:SetPos( w - 20,h - 20 ) 
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
    self.menubar.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.menubar )
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawOutlinedRect(0,0,w,h)
    end
    
    self.menubar.version = self.menubar:Add("Panel")
    self.menubar.version:Dock(LEFT)

    self.menubar.version:SetWide( 225 )
    self.menubar.version.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border ) 
        surface.DrawOutlinedRect(0,0,w,h)
    end
    self.menubar.version = self.menubar.version:Add("DLabel")
    self.menubar.version:SetFont( methamphetamine.default.font )
    self.menubar.version:SetText("Bullyware[WIP] ")
    self.menubar.version:SetTextColor( methamphetamine.colors.text )
    self.menubar.version:Dock(LEFT)
    self.menubar.version:DockMargin(5,0,0,0)
    self.menubar.version:SizeToContents()
    
    self.menubar.windows = self.menubar:Add("DButton")
    self.menubar.windows:Dock(LEFT)
    self.menubar.windows:SetFont( methamphetamine.default.font )
    self.menubar.windows:SetText("Windows")
    self.menubar.windows:SetTextColor( methamphetamine.colors.text )
    self.menubar.windows:SizeToContentsX(10)
    local opaque = Color(255,255,255,0)
    self.menubar.windows.Paint = function(pnl,w,h)
        surface.SetDrawColor( (pnl:IsHovered() or pnl.dropdown:IsVisible()) and methamphetamine.colors.activebutton or opaque )
        surface.DrawRect(0,0,w,h)
    end

    self.menubar.windows.dropdown = self:Add("methamphetamine.panel")
    local dropdown = self.menubar.windows.dropdown
    dropdown:SetWide( 130 )
    self.menubar.windows.DoClick = function( pnl )
        pnl.dropdown:SetVisible( not pnl.dropdown:IsVisible() )
    end

    local dropdown = include("windows.lua")
    for k, v in ipairs( dropdown ) do
        local dd = self.menubar.windows.dropdown:Add("DButton")
        dd:Dock(TOP)
        dd:SetTall(15)
        dd:DockMargin(4,0,4,0)
        dd:SetText("")
        dd.Paint = function(pnl,w,h)
            surface.SetDrawColor( pnl:IsHovered() and methamphetamine.colors.hovered or methamphetamine.colors.background )
            surface.DrawRect(0,0,w,h)
            draw.SimpleText( v.name , methamphetamine.default.font , 8,h/2, methamphetamine.colors.disabledtext , 0,1 )
            if v.isToggled then
                surface.SetDrawColor( methamphetamine.colors.activebutton )
                surface.SetMaterial( methamphetamine.default.tickmat )
                surface.DrawTexturedRect( w-h,0,h,h )
            end
        end
        dd.DoClick = function(pnl)
            v.isToggled = not v.isToggled 
            v.func( v , v.isToggled )
        end
    end
    self.menubar.windows.dropdown:SetTall( #dropdown * 15 + 8 )
    self.menubar.windows.dropdown:SetVisible( false )
    self.menubar.windows.dropdown:DockPadding(0,4,0,0)
end

function PANEL:PerformLayout(w,h)
    local mwx,mwy = self.menubar.windows:GetPos()
    local mww,mwh = self.menubar.windows:GetSize()
    self.menubar.windows.dropdown:SetPos( mwx , mwy + mwh )


end


function PANEL:OnKeyCodePressed(keyCode )
    if keyCode == KEY_0 then
        if CurTime() - self.lastopen > 0.4 then
            self:SetVisible( false )
            hook.Run("methamphetamine.mastertoggle",false)
            self.lastopen = CurTime()
        end
    end
end

function PANEL:Paint(w,h)
    surface.SetDrawColor( methamphetamine.colors.backgroundopaque )
    surface.DrawRect(0,0,w,h)
    local mascot = methamphetamine.mascots[methamphetamine.mascots.active]
    local mat = mascot.mat
    surface.SetDrawColor( methamphetamine.colors.backgroundmascot )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( mascot.x,mascot.y,mascot.w,mascot.h )
end

vgui.Register("methamphetamine.solutions", PANEL)

local PANEL = {}

function PANEL:Init()
    self:SetSize(640,460)
    self:SetPos( ScrW() / 2 - 640 / 2, ScrH() / 2 - 460 / 2 )
    self:SetResizeable( false )
    self.mainmods = self:Add("DPanel")
    self.mainmods:Dock(TOP)
    self.mainmods:SetTall(20)
    self.mainmods:DockMargin(5,8,5,0)
    self.mainmods.Paint = function(pnl,w,h)
        surface.SetDrawColor( methamphetamine.colors.border )
        surface.DrawRect(0,h-2,w,2)
    end
    self.mainmods:DockPadding(2,0,0,0)
    self.cheats = {}
end

function PANEL:AddCheat( name , panel , subPagesTable )
    methamphetamine.mods[name] = {
         _panel = panel, 
        _name = name,
    }
    local CHEAT = methamphetamine.mods[name]
    local subPagesTable = subPagesTable or false
    self.cheats[ #self.cheats + 1 ] = self.mainmods:Add("DButton")
    local i = #self.cheats
    local btn = self.cheats[i]
    btn:Dock(LEFT)
    btn:DockMargin(1,0,1,2)
    btn:SetText( "" )
    surface.SetFont( methamphetamine.default.font )
    local wide,tall = surface.GetTextSize( name )
    btn:SetWide( wide + 8 )
    btn.Paint = function(pnl,w,h)
        surface.SetDrawColor( (pnl:IsHovered() or pnl.panel == self.cheats.active) and methamphetamine.colors.activebutton or methamphetamine.colors.border )
        surface.DrawRect(0,0,w,h)
        draw.SimpleText( name , methamphetamine.default.font , w/2,h/2, methamphetamine.colors.disabledtext , 1,1 )
    end
    
    btn.panel = self:Add( panel or "DButton" )
    btn.panel:Dock(FILL)
    btn.panel:SetVisible( false )
    if panel == "methamphetamine.submods" then
        btn.panel:DockMargin(5,0,5,5)
    else
        btn.panel:DockMargin(8,8,8,8)
    end
    btn.DoClick = function(pnl)
        if self.cheats[i].panel == self.cheats.active and self.cheats[i].panel:IsVisible() then return end
        self.cheats[i].panel:SetVisible( true )
        if self.cheats.active then 
            self.cheats.active:SetVisible( false )
        end
        self.cheats.active = self.cheats[i].panel
    end

    if subPagesTable and panel == "methamphetamine.submods" then
        for k , v in ipairs( subPagesTable ) do
            btn.panel:AddCheat( v.name, v.panel )
        end
        --PrintTable( subPagesTable )
        if subPagesTable[0] and subPagesTable[0].master == true then
            btn.panel.mods:DockMargin(0,0,0,0)
            btn.panel.mods.master = btn.panel:Add("DPanel")
            local master = btn.panel.mods.master
            master:Dock(TOP)
            master:SetTall(33)
            master:SetZPos(-1)
            master.Paint = nil

            master.contents = master:Add("Panel")
            master.contents:Dock(LEFT)
            master.contents:DockMargin(5,8,5,5)
            master.contents:SetWide(300)

            master.toggle = master.contents:Add("methamphetamine.checkbox")
            master.toggle:Dock(LEFT)
            master.toggle:SetWide(20)
            master.toggle.OnToggle = function(pnl,state)    
                methamphetamine.mods[name].MasterToggle = state
                print("MasterToggle = ", state )
            end
            master.toggle:DockMargin(0,0,60,0)

            master.bindLabel = master.contents:Add("DLabel")
            master.bindLabel:Dock(LEFT)
            master.bindLabel:SetFont( methamphetamine.default.font )
            master.bindLabel:SetTextColor( methamphetamine.colors.text )
            master.bindLabel:SetText("| Key to toggle visuals")
            master.bindLabel:SizeToContents()

            master.keybind = master.contents:Add("methamphetamine.binder")
            master.keybind:Dock(LEFT)
            master.keybind:SetWide(80)
            master.keybind:DockMargin(4,0,0,0)
            master.keybind:SetValue( methamphetamine.mods[name].masterToggleKeybind )
            master.keybind.OnChange = function(pnl,val)
                methamphetamine.mods[name].masterToggleKeybind = val
            end
            hook.Add( "PlayerButtonUp", "methamphetamine.visualsToggle", function( ply, key )
                if key == methamphetamine.mods[name].masterToggleKeybind then
                    methamphetamine.mods[name].MasterToggle = not (methamphetamine.mods[name].MasterToggle or false)
                    master.keybind:SetValue( methamphetamine.mods[name].masterToggleKeybind )
                end
            end )
        end
        if subPagesTable[0] and subPagesTable[0].defaultPage then
            btn.panel:SetActive( subPagesTable[0].defaultPage )
        end


    end

end

function PANEL:SetActive( i )
    self.cheats[i].panel:SetVisible( true )
    if self.cheats.active then 
        self.cheats.active:SetVisible( false )
    end
    self.cheats.active = self.cheats[i].panel
end

vgui.Register("methamphetamine.solutions.main", PANEL , "methamphetamine.frame")

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
pp:SetActive( 1 )


function meth_toggle( mode )
    frame:SetVisible( mode  )
end

hook.Add( "PlayerButtonDown", "methamphetamine.toggle", function( ply, key )
    if key == KEY_0 then 
        
        if frame:IsVisible() then return end
        if CurTime() - (frame.lastopen or 1) > 0.4 then

            frame:SetVisible( true )
            hook.Run("methamphetamine.mastertoggle",true)
            frame.lastopen = CurTime()
        end
        
      
    end
end)

include("cheats.lua")
include("esp.lua") 
