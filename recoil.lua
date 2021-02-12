  local cw_values = {
  ["cw_m14"] = 1.02,
  --['cw_ar15'] = 1,
  ["cw_g36c"] = 0.85,
  ["cw_g3a3"] = 0.8
}

function methamphetamine.CalculateRecoilCompensation( player )
  print("X")
  if not methamphetamine.mods["Aim"].NoRecoil then return end
  print("Y")
  if not player == LocalPlayer() then return end
  local wep = player:GetActiveWeapon()
  local weaponclass = wep:GetClass()
  local cw = wep._attach
  print(cw)
  if cw then
    print("CW")
    ang = player:EyeAngles()
    ang.p = ang.p + wep.Recoil * ( methamphetamine.mods["Aim"]["RecoilControl"] or 0.73 )
    ang.y = ang.y - math.Rand(-1, 1) * wep.Recoil * 0.5 * 1
  
    return ang
  end
  print("not cw")
  return Angle(0,0,0)
end

-- function methamphetamine.NoRecoil( player , data )
--   if not methamphetamine.mods["Aim"].NoRecoil then return end
--   if not player == LocalPlayer() then return end
--   local wep = player:GetActiveWeapon()
--   local weaponclass = wep:GetClass()
--   local m9k = string.find( weaponclass , "m9k" ) 
--   local cw = wep._attach
--   local tfa = string.find( weaponclass , "tfa" )
--   wep.meth = wep.meth or {}
--   if m9k then
--       wep.meth.down = wep.Primary.KickDown 
--       wep.meth.horizontal = wep.Primary.KickHorizontal 
--       wep.meth.up = wep.Primary.KickUp 

--       wep.Primary.KickDown = 0
--       wep.Primary.KickHorizontal = 0
--       wep.Primary.KickUp = 0

--       local anglo = -Angle(math.Rand(-wep.meth.down,-wep.meth.up), math.Rand(-wep.meth.horizontal,wep.meth.horizontal), 0)

--       -- LocalPlayer():ViewPunch(anglo1)

--       local eyes = LocalPlayer():EyeAngles()
--       eyes.pitch = eyes.pitch - (anglo.pitch/3)
--       eyes.yaw = eyes.yaw - (anglo.yaw/3)
--       LocalPlayer():SetEyeAngles(eyes)

--   end
--   if cw then


    

   
--   end
--   if tfa then
--     wep.Recoil = function() return 0 end
--   end
-- end
-- hook.Add("EntityFireBullets","methamphetamine.antirecoil", methamphetamine.NoRecoil )

function methamphetamine.NoSpread( player ,_, wep )
  if not methamphetamine.mods["Aim"].NoSpread then return end
  if not player == LocalPlayer() then return end
  local weaponclass = wep:GetClass()
  local m9k = string.find( weaponclass , "m9k" ) 
  local cw = string.find( weaponclass , "cw" )
  local tfa = string.find( weaponclass , "tfa" )
  -- if m9k then
  --     wep.Primary.KickDown = 0
  --     wep.Primary.KickHorizontal = 0
  --     wep.Primary.KickUp = 0
  -- end
  if cw then
    wep.HipSpread = 0
    wep.AimSpread = 0
    wep.MaxSpreadInc = 0.0000001
    wep.SpreadPerShot = 0
    wep.SpreadCooldown = 0

  elseif tfa then
    wep.Recoil = function() return 0 end
  end
end
hook.Add( "PlayerSwitchWeapon", "methamphetamine.nospread", methamphetamine.NoSpread)
