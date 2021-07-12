# Bullyware

NOTE: THIS IS NOT THE SOURCE CODE FOR METHAMPHETAMINE SOLUTIONS. I AM NOT AFFILIATED WITH THEM IN ANY WAY SHAPE OR FORM NOR IS THIS STOLEN CODE. THIS USED TO BE A PROJECT OF MINE JUST TO RECREATE METH AS I ADMIRED THEIR INTERFACE AND I WAS INTERESTED IN MAKING A CHEAT SO THERE CAME A METHAMPHETAMINE REMAKE WHICH WAS LATER RENAMED TO 'Bullyware'.

More formally known as Bullyware.
This is just a little project of mine. Its a work in progress, it is not finished. There are missing pages and there may be errors.
I dont mind if someone doesn't like it



**Not updating this anymore. Yes, it has errors such as when you try to use no-recoil n what not. Feel free to paste from this cheat or something or use it as a meth.sol framework if u really wanna.**
**Might upload my personal version with more features at some point... or at least make add some shit to this version to make it less detectable such as entirely un-screengrabbable visuals at some point**



> Didn't think that i'd have to mention this but this cheat is not meant to be the best cheat in the world. Yes, it is made in Lua and I am very well aware that this is not made in C++. This was a project made for fun, not for commercial purposes. I couldn't give less of a shit if someone has something against this project I had fun making, but if you insist you want to cry about it, be my guest.

Instructions:
- Put the materials within `methamphetamine-public/materials` into `garrysmod/materials` so it should be `garrysmod/materials/meth/mascots/`. 
- Put the 'meth' lua folder within `garrysmod/lua` so it should be `garrysmod/lua/meth/core.lua`
- Install 'Raleway' font from google :)
    - https://fonts.google.com/specimen/Raleway?preview.text_type=custom


To use you run `lua_openscript_cl meth/core.lua` in the console.
Press `0` to open the menu, anticheats may detect you pressing insert. Better safe than sorry :)

If you are on a server where sv_allowcslua is 0 then you must use a 3rd party lua executor or bypasser.
- Bypasser:
- Pretty sure it only works on 32 bit gmod but hay hoe:
- Detected by the glorious bSecure
- https://cdn.discordapp.com/attachments/837060748282691654/860513289150267452/gmod_allowcslua_bypasser.exe
- If it gets picked up as a virus, its a false positive. The reason it gets picked up as a virus is because ~~it reads and writes to memory~~ it is one, for the full meth experience :)

Preview(s):
- https://imgur.com/usi8SIO
- https://imgur.com/OwDDxzd

Features:
- Exploit Menu (net messages):
    - Unlock pVault
    - Chat spammer
    - Easy to add exploits
    - Net message listener
    - Net message list (list of all cached network strings)
    - Spam rcon
    - Get superadmin
- Entity ESP:
    - Updates internal table of entities every 15 seconds to minimize lag
    - Add entities via the environemnt list
- ESP:
    - Colors:
        - Rainbow
        - Selected Color
        - Health Color (MOST SUPPORT THIS)
        - Team Color (MOST SUPPORT THIS)
    - Box:
        - draws bounding box
    - Chams:
        - Player chams
        - Weapon chams
    - Others:
        - Include many features not made yet
- Aimbot:
    - Hitbox Aim:
        - Head
        - Torso
        - Hitscan (torso, needs to be made)
    - Silent Aim:
        - Does jack shit
    - Smooth Aim:
        - Uses Lerp to make your aim smooth
    - Ignore filter:
        - Transparent players
        - Friends
        - Party members (does nothing)
        - Same team
        - Selected teams
        - Noclipping players
        - Invisible (Same as transparent)
    - Autofire:
        - OP as balls if used correctly
    
- Recoil Control (WIP)
- AntiScreengrab:
    - Serverguard screengrabber
- Radar
- Radio station player
- Environment list:
    - Whitelist teams to the aimbot
    - Add entities to the entity ESP list
    - Add players to your friends list
- configs (stored in data/methamphetamine/configs)
- Shows spectators, sometimes
- Debug console that doesn't do too much

