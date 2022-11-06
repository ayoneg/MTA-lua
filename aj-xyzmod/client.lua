--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2021 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt przebijania opon.
]]--

-- LISTA MAT GDZIE OPONA MOZE JEBNAC
local materials = {
    [6]=true,[9]=true,[10]=true,[11]=true,[12]=true,[13]=true,[14]=true,[149]=true,[123]=true,[26]=true,[147]=true,[33]=true,[79]=true,[76]=true,[77]=true,[15]=true,[30]=true,[85]=true,[178]=true,[150]=true,[128]=true,[99]=true,[125]=true,[16]=true,[115]=true,[83]=true,[109]=true,[40]=true,[188]=true,
}
-- LISTA POJAZDOW SPECJALNYCH
local speccars = {
    [468]=true,[424]=true,[471]=true,[568]=true,
}

-- funkcja #1 [ wykrywa material, na którym znajduje się pojazd ]
function getSurfaceVehicleIsOn(vehicle)
    if isElement(vehicle) and (isVehicleOnGround(vehicle) or isElementInWater(vehicle)) then -- czy w ogole jest na ziemi
        local cx, cy, cz = getElementPosition(vehicle) -- pojazd
        local gz = getGroundPosition(cx, cy, cz) - 0.001 -- pobieram pozycje Z (-0.001 because of processLineOfSight)
        local hit, _, _, _, _, _, _, _, surface = processLineOfSight(cx, cy, cz, cx, cy, gz, true, false) -- pobieram material gdzie jest pojazd
        if hit then
            return surface -- jesli all jest git wyciagam id
        end
    end
    return false -- jesli cos poszło nie tak
end

--spr upgrades [offroad]
function upgradesV(veh,ID)
    for _,upgr in ipairs(getVehicleUpgrades(veh)) do 
		if upgr==ID then
			return true
		end
	end
	return false
end

--[[ funkcja #2
	@ INFO
	@ funkcja sprawdza szereg informacji, zanim przebije nam oponę.
]]--
function przebijamseXD()
    local uid = getElementData(localPlayer,"player:dbid") or 0;
	if uid > 0 then
	    local vehicle = getPedOccupiedVehicle(localPlayer) or false
		if vehicle ~= false then
			local kiero = getVehicleOccupant(vehicle) or false
			if kiero == localPlayer then
				local sx,sy,sz = getElementVelocity(vehicle)
				speed = (sx^2 + sy^2 + sz^2)^(0.5);
				kmh = speed*180;
				if tonumber(kmh) > 30 and not speccars[getElementModel(vehicle)] then -- jesli auto jedzie conajmniej 30km/h i nie jest z listy speccar
					local returned = getSurfaceVehicleIsOn(vehicle)
					if returned then
						local offroad = upgradesV(vehicle,1025) -- id 1025 offroad
						if materials[tonumber(returned)] and not offroad then
							local randomIT = math.random(0,1000)
							if randomIT >= 0 and randomIT < 250 then -- 25% szansy
								-- biore aktualne oponki
								local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(vehicle)
								-- jesli jakakolwiek jest cała losowanie start
								if frontLeft == 0 or rearLeft == 0 or frontRight == 0 or rearRight == 0 then
									local losowanieopony = math.random(1,4);
									-- przebijam oponę
									if losowanieopony == 1 and frontLeft == 0 then setVehicleWheelStates(vehicle, 1, rearLeft, frontRight, rearRight) end
									if losowanieopony == 2 and rearLeft == 0 then setVehicleWheelStates(vehicle, frontLeft, 1, frontRight, rearRight) end
									if losowanieopony == 3 and frontRight == 0 then setVehicleWheelStates(vehicle, frontLeft, rearLeft, 1, rearRight) end
									if losowanieopony == 4 and rearRight == 0 then setVehicleWheelStates(vehicle, frontLeft, rearLeft, frontRight, 1) end
									ograniczfure()
								end
							end
						end
					end
				end
			end
		end
	end
end

-- nadawanie ograniczenia predkosci
function ograniczfure()
    local uid = getElementData(localPlayer,"player:dbid") or 0;
	if uid > 0 then
	    local vehicle = getPedOccupiedVehicle(localPlayer) or false
		if vehicle ~= false then
			local kiero = getVehicleOccupant(vehicle) or false
			if kiero == localPlayer then
--				setElementData(localPlayer,"player:vehicleogranicznik",79)
				local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(vehicle)
				if frontLeft ~= 0 or rearLeft ~= 0 or frontRight ~= 0 or rearRight ~= 0 then
					setElementData(localPlayer,"player:vehicleogranicznik",50)
				else
					setElementData(localPlayer,"player:vehicleogranicznik",0)
				end
			end
		end
	end
end
--setTimer(ograniczfure, 1500, 0)

-- dzięki temu, funkcja bedzie działac tylko w aucie, a nie cały czas :)
addEventHandler("onClientVehicleEnter", getRootElement(),function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if isTimer(opony) then killTimer(opony) end -- gdyby jednak okazało się, że taki istnieje (??)
		if isTimer(przebijopony) then killTimer(przebijopony) end -- gdyby jednak okazało się, że taki istnieje (??)
        opony = setTimer(przebijamseXD, 10000, 0)
		przebijopony = setTimer(ograniczfure, 1500, 0)
    end
end)
addEventHandler("onClientVehicleExit", getRootElement(),function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if isTimer(opony) then killTimer(opony) end
		if isTimer(przebijopony) then killTimer(przebijopony) end
    end
end)


-- text test command // wykrywanie mats oraz czy jest czy nie
addCommandHandler("root.test",function(cmd)
	veh = getPedOccupiedVehicle(localPlayer)
	if not veh then
		outputChatBox("* Użycie: /root.test")
		return
	end
    local returned = getSurfaceVehicleIsOn(veh)
	if returned ~= false then
		if materials[tonumber(returned)] then
			outputChatBox("* JEST DODANY: "..tonumber(returned))
		else
			outputChatBox("* BRAK: "..tonumber(returned))
		end
	end
end)

-- ES, lua to kox






