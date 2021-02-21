# methamphetamine-public

More formally known as Bullyware.
This is just a little project of mine. Its a work in progress, it is not finished. There are misising pages and there may be errors.
I dont mind if someone doesn't like it

> Didn't think that i'd have to mention this but this cheat is not meant to be the best cheat in the world. Yes, it is made in Lua and I am very well aware that this is not made in C++. This was a project made for fun, not for commercial purposes. I couldn't give less of a shit if someone has something against this project I had fun making, but if you insist you want to cry about it, be my guest.

Instructions:
- Put the materials within `methamphetamine-public/materials` into `garrysmod/materials` so it should be `garrysmod/materials/meth/mascots/`. 
- Put the 'meth' lua folder within `garrysmod/lua` so it should be `garrysmod/lua/meth/core.lua`
- Install 'Raleway' font from google :)
    - https://fonts.google.com/specimen/Raleway?preview.text_type=custom


To use you run `lua_openscript_cl meth/core.lua` in the console.
Press `0` to open the menu, anticheats may detect you pressing insert. Better safe than sorry :)

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

