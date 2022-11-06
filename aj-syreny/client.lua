--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2022 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt syren alarmowych dla frakcji. (v2)
]]--

local blokada = {}
local aktywne = {}
local aktywne_horn = {}

local pojazdy = {
    --     carID, modelID, 1, 2, 3, horn (r)	[dajemy albo model albo id, nie 2 na raz!!!]
    {0, 597, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
	{0, 416, "samc1.ogg", "Dc259.ogg", 0, "samchorn.wav"}, -- SAMC
	
	{0, 407, 0, 0, 0, "traby.ogg"}, -- PSP
	
--	{103, 0, "siren-strom-1.wav", "babyshark.wav", "hespirates.wav", "ultrakox.wav"}, -- test
	{52, 0, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
	{103, 0, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
	{134, 0, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
	{135, 0, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
	{136, 0, "policja1.ogg", "syrenasapd.ogg", 0, "sapdhorn.wav"}, -- SAPD
}

function sprSiren(veh,type,id)
	for i,v in ipairs(pojazdy) do 
	local veh_model = getElementModel(veh) or false;
		if v[2]==veh_model or v[1]==id then 
		     return v[type]
--			 print(v[2])
		end 
	end
end

function sirensTest(key, state, var, horn)
	if localPlayer then
	    local vehicle = getPedOccupiedVehicle(localPlayer) or false
		if vehicle ~= false then
		    local veh_id = getElementData(vehicle,"vehicle:id") or 0;
			if tonumber(veh_id) > 999999 then return end
			if getElementModel(vehicle) == sprSiren(vehicle,2) or veh_id == sprSiren(vehicle,1,veh_id) then
			if blokada[localPlayer] and getTickCount() < blokada[localPlayer] then return end
			if horn == 1 then
				local sprdata33 = getElementData(vehicle,"vehicle:hornON") or false;
				if not sprdata33 then
					local wyb = sprSiren(vehicle,6,veh_id) or 0;
					if wyb ~= 0 then -- ver 2.0 (odbugowane) -- tutaj sprawdzamy, nie przy bindach
				    	setElementData(vehicle,"vehicle:hornType",wyb)
						setElementData(vehicle,"vehicle:hornON",true)
						blokada[localPlayer] = getTickCount()+1000; -- 1 sek zabezpieczenia
					end
				else
					setElementData(vehicle,"vehicle:hornON",false)
				end
			else
				local sprdata33 = getElementData(vehicle,"vehicle:syrenyON") or false;
				if not sprdata33 then
					local wyb = sprSiren(vehicle,var,veh_id) or 0;
					if wyb ~= 0 then -- ver 2.0 (odbugowane) -- tutaj sprawdzamy, nie przy bindach
				    	setElementData(vehicle,"vehicle:syrenyType",wyb)
						setElementData(vehicle,"vehicle:syrenyON",true)
						blokada[localPlayer] = getTickCount()+1000; -- 1 sek zabezpieczenia
					end
				else
					setElementData(vehicle,"vehicle:syrenyON",false)
				end
			end -- end horn
			end
		end
	end	
end

-- dodaj binda (max 3 sygnały + horn)
function enterCar(plr, seat, jacked)
    if seat ~= 0 then return end
	if plr==localPlayer then
	local veh_id = getElementData(source,"vehicle:id") or 0
	if tonumber(veh_id) > 999999 then return end
	if source and getElementModel(source) == sprSiren(source,2) or tonumber(veh_id) == sprSiren(source,1,veh_id) then

		unbindKey("1", "down", sirensTest)
		unbindKey("2", "down", sirensTest)
		unbindKey("3", "down", sirensTest)
		unbindKey("r", "down", sirensTest)
		-- bind nowe
		bindKey("1", "down", sirensTest, 3, 0)
		bindKey("2", "down", sirensTest, 4, 0)
		bindKey("3", "down", sirensTest, 5, 0)
		bindKey("r", "down", sirensTest, 0, 1)
		-- czyba dzialaa

	end
	end
end
addEventHandler("onClientVehicleEnter", root, enterCar)

-- usun binda (max 3 sygnały + horn)
function exitCar(plr, seat, jacked)
    if seat ~= 0 then return end
	if plr==localPlayer then
	local veh_id = getElementData(source,"vehicle:id") or 0
	if tonumber(veh_id) > 999999 then return end
	if source and getElementModel(source) == sprSiren(source,2) or tonumber(veh_id) == sprSiren(source,1,veh_id) then
		-- ver 2.0 (odbugowana)
		unbindKey("1", "down", sirensTest)
		unbindKey("2", "down", sirensTest)
		unbindKey("3", "down", sirensTest)
		unbindKey("r", "down", sirensTest)
		-- czyba dzialaa
	end
	end
end
addEventHandler("onClientVehicleExit", root, exitCar)

addEventHandler("onClientElementDataChange",root,function(eleData, _)
	if getElementType(source) ~= "vehicle" then return end
	if eleData == "vehicle:syrenyON" then
	local getData = getElementData(source,eleData)
	if getData == true then
		local sirID = getElementData(source,"vehicle:syrenyType");
		aktywne[source] = playSound3D(sirID, 0, 0, 2000, true)
		setSoundVolume(aktywne[source], 1.0)
		setSoundEffectEnabled(aktywne[source],"compressor",true)
  	    setSoundMinDistance(aktywne[source],10)
  	    setSoundMaxDistance(aktywne[source],220)
		setElementDimension(aktywne[source],getElementDimension(source))
		setElementInterior(aktywne[source],getElementInterior(source))
		attachElements(aktywne[source], source) -- nakladam
	else
		if not aktywne[source] then return end
		stopSound(aktywne[source])
	end
	end
	if eleData == "vehicle:hornON" then
	local getData = getElementData(source,eleData)
	if getData == true then
--	    if blokada[localPlayer] and getTickCount() < blokada[localPlayer] then return end
		local sirID = getElementData(source,"vehicle:hornType");
		aktywne_horn[source] = playSound3D(sirID, 0, 0, 2000, false)
		setSoundVolume(aktywne_horn[source], 1.0)
		setSoundEffectEnabled(aktywne_horn[source],"compressor",true)
  	    setSoundMinDistance(aktywne_horn[source],10)
  	    setSoundMaxDistance(aktywne_horn[source],220)
		setElementDimension(aktywne_horn[source],getElementDimension(source))
		setElementInterior(aktywne_horn[source],getElementInterior(source))
		attachElements(aktywne_horn[source], source) -- nakladam
		setTimer(timerEnd, 1000, 1, source)
	end
	end
end)

function timerEnd(veh)
	setElementData(veh,"vehicle:hornON",false)
end

addEventHandler("onClientElementDestroy",root,function()
	if getElementType(source) ~= "vehicle" then return end
		local getData = getElementData(source,"vehicle:syrenyON")
		if getData == true then
			if not aktywne[source] then return end
			stopSound(aktywne[source])
		end
end)
