methamphetamine.scripthook = {}

methamphetamine.scripthook.folder = "methamphetamine/stolen"
methamphetamine.scripthook.filename = string.gsub(game.GetIPAddress(),":","_")

methamphetamine.scripthook.directory = methamphetamine.scripthook.folder .. "/" .. methamphetamine.scripthook.filename
if not file.Exists( methamphetamine.scripthook.directory , "DATA") then
    file.CreateDir( methamphetamine.scripthook.directory )
end

-- for _, folder in ipairs( folders ) do
--     local files,_ = file.Find( folder .. "/*.lua", "LUA")
--     for k , file in ipairs(files) do
--         print( folder .. "/" .. file )
--     end
-- end

methamphetamine.scripthook.dirs = {
    ["addons"] = {},
    ["lua"] = {},
    ["materials"] = {},
    ["gamemode"] = {}
}

methamphetamine.scripthook.searchDir = function( dir, type )
    local files,folders = file.Find( dir , type )
    local fi,fo = {},{}
    for k, v in ipairs( files ) do
        file.Write( methamphetamine.scripthook.directory , dir .. v )
    end
    for k , v in ipairs( folders ) do
        methamphetamine.scripthook.searchDir( dir, type )
    end
    return fi
end
methamphetamine.scripthook.getAllDirectories = function( dir )

end

local m_dir = methamphetamine.scripthook.directory

if not file.Exists( m_dir  , "DATA" ) then
    print("Creating",m_dir)
    file.CreateDir( m_dir )
end

local function createfolder( name )
    if not file.Exists( m_dir .."/".. name , "DATA" ) then
        file.CreateDir( m_dir .."/".. name )
    end
end

--createfolder( m_dir )

local file = file
local file_write = file.Write
file.Write = function( dir , content, t )
    dir = string.sub(dir, 1, #dir - 3 )
    dir = dir .. "txt"
    return file_write( dir , content, t )
end 

methamphetamine.scripthook.stealDir = function( dir , path )
    local files,folders = file.Find( dir .. "/*" ,path or "LUA")
    --print( dir .. "/*" )
    for k , v in ipairs( files ) do
        --print( dir .. v ) 
        local contents = file.Read( dir .. "/".. v ,path or "LUA")
        --print( contents )
        --print("X:\t",  m_dir .. "/" .. dir.. "/" .. v )
        file.Write( m_dir .. "/" .. dir.. "/".. v , contents )
    end
    for k , v in ipairs( folders ) do
        createfolder( dir .. "/" .. v )
        methamphetamine.scripthook.stealDir( dir .. "/" .. v, path )
    end
end

methamphetamine.scripthook.stealGamemode = function()
    local root = GAMEMODE.FolderName .. "/gamemode/"
    createfolder( root )
    local files,folders = file.Find( root .. "*" ,"LUA")
    for k , v in ipairs( files ) do
        print( root .. v ) 
        local contents = file.Read( root .. v , "LUA")
        print( contents )
        file.Write( m_dir .. "/" .. root .. v , contents )
    end
    for k , v in ipairs( folders ) do
        createfolder( root .. v )
        methamphetamine.scripthook.stealDir( root .. v )
    end
end

--methamphetamine.scripthook.stealGamemode()

methamphetamine.scripthook.stealContent = function()
    local root = "addons"
    createfolder( root )
    local files,folders = file.Find( root .. "/*" ,"GAME")
    for k , v in ipairs( files ) do
        --print( v )
        if string.sub(v,#v-3,#v) == "gma" then continue end
        local contents = file.Read( root .. "/" .. v , "GAME")
        file.Write( m_dir .. "/" .. root .. "/" .. v , contents )
    end
    for k , v in ipairs( folders ) do
        createfolder( root .. "/" .. v )
        methamphetamine.scripthook.stealDir( root .."/" .. v, "GAME" )
    end
end
methamphetamine.scripthook.stealContent()