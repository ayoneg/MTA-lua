--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2022 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt pozarów i gaszenia BETA.
]]--

local bbgs = {}
local modeleFire = { [1912]=true,[1913]=true,[1914]=true, }

addEventHandler("onClientPlayerWeaponFire",localPlayer,function(wep,_,_,hitX,hitY,hitZ)
	if bbgs[localPlayer] and getTickCount() < bbgs[localPlayer] then return end
	if wep == 42 and math.random(1,1000)<=75 then -- 7,5% szans
		for k, v in ipairs(getElementsByType("object",resourceRoot)) do
			if modeleFire[getElementModel(v)] then
				local fX,fY,fZ = getElementPosition(v)
				local dist = getDistanceBetweenPoints2D(hitX,hitY,fX,fY)
				if dist < 1 then
					triggerServerEvent("removeFireFromWorld",resourceRoot,v,source)
					bbgs[localPlayer] = getTickCount()+3500;
				end
			end
		end
	end
end)