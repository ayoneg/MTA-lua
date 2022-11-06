--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2022 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt pozarów i gaszenia BETA.
]]--

function zgasogien()
    object=getElementsByType('object')
    for i,v in pairs(object) do
		local obj = getElementData(v,"FIRE") or false;
		if obj then
			sphare = getElementData(v,"FIRE")
			destroyElement(sphare)
			destroyElement(v)
		end
    end		
end

addCommandHandler("fire", function(plr,cmd)
    if getElementData(plr,"admin:poziom") >= 6 then
        if getElementData(plr,"admin:zalogowano") == "true" then
			local x,y,z = getElementPosition(plr)
			for i=0, 8 do
				rand1 = math.random(-5,5)
				rand2 = math.random(-5,5)
				obj=createObject(math.random(1912,1914),x+rand1,y+rand2,z-0.6)
				sphr=createColSphere(x+rand1,y+rand2,z, 1.4)
				setElementCollisionsEnabled(obj, false)
				setElementData(obj,"FIRE",sphr)
				setElementData(sphr,"FIRE",true)
				setElementDimension(sphr, 0)
				setElementInterior(sphr, 0)
			end
			if isTimer(czasfire) then killTimer(czasfire) end
			czas = 60000 * 60 * 1.5; -- 1.5h
			-- gdyby nikt go nie zgasil
			czasfire = setTimer(zgasogien, czas, 1)
        end
    end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--       TODO: losowe pozary na mapie dla PSP         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


function delSphare(ID)
    sphare=getElementsByType('colshape')
    for i,v in pairs(sphare) do
		local obj = getElementData(v,"FIRE") or false;
		if obj and obj == ID then
		    destroyElement(v)
		end
    end	
end

local blokadatest = {}

-- usuwanie
addEvent("removeFireFromWorld", true)
addEventHandler("removeFireFromWorld",resourceRoot,function(element,plr)
	if blokadatest[element] and getTickCount() < blokadatest[element] then return end
	if element then
		blokadatest[element] = getTickCount()+10000;
		local fire = getElementData(element,"FIRE") or false;
		destroyElement(fire)
--		delSphare(fire)
		destroyElement(element)
		
		local uid = getElementData(plr,"player:dbid") or 0;
		if uid > 0 then
			local plr_money = getPlayerMoney(plr)
			cena = 1260 -- 12,60$ za płomyk
			calosc = plr_money + cena;
			if calosc > 99999999 then return end
			local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_money=user_money+? WHERE user_id=?",cena,uid);
			local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_bankmoney=user_bankmoney+? WHERE user_id = '22'",cena); -- zapis
			local query = exports["aj-dbcon"]:upd("INSERT INTO lbk SET lbank_userid='22', lbank_touserid=?, lbank_kwota=?, lbank_data=NOW(), lbank_desc='Gaszenie płomieni.', lbank_type='1'",uid,cena);
			givePlayerMoney(plr, cena)
		end
		
	end
end)

-- podpalenie
addEventHandler("onColShapeHit", root, function(el,md)
	if not md or not el then return end
    if getElementType(el) ~= "player" then return end
	local fire = getElementData(source,"FIRE") or false;
	if fire then
		setPedOnFire(el, true)
	end
end)


--------------

