--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2021 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt pracy gemmologa TEST.
]]--

--######################
-- PREMIA GLOBALNA
local global_premia = 0
-- PREMIA GLOBALNA
--######################

local postaw_prace = {
	{ -- fc #1
		kordy={-227.173828125, 1220, 19.735198974609, 180},  -- x,y,z, 
    	cube={-222.8603515625, 1211.7724609375, 19.735198974609}, -- x,y,z
		dimint={0,0}, -- int / dim
		blip=0,
	},
	{ -- fc #2
		kordy={-232.7353515625, 1220, 19.735198974609, 180},  -- x,y,z, 
    	cube={-229.8603515625, 1211.7724609375, 19.735198974609}, -- x,y,z
		dimint={0,0}, -- int / dim
		blip=1,
	},
	{ -- fc #2
		kordy={-238.115234375, 1220, 19.7421875, 180},  -- x,y,z, 
    	cube={-236.8603515625, 1211.7724609375, 19.735198974609}, -- x,y,z
		dimint={0,0}, -- int / dim
		blip=0,
	},
}

for i,v in ipairs(postaw_prace) do
	if v.blip == 1 then praca = createBlip(v.kordy[1], v.kordy[2], v.kordy[3]+0.2, 51, 2, 255, 0, 0, 155, -1, 500) end
	resp = createColCuboid(v.cube[1], v.cube[2], v.cube[3]-1, 4, 8, 4)
	setElementPosition(resp, v.kordy[1]-2, v.kordy[2]-4, v.kordy[3]-1)
	setElementData(resp,"gemo:id",i)
	t = createElement("text")
	setElementData(t,"name","Punkt respienia - Nie zastawiać!")
	setElementPosition(t, v.kordy[1], v.kordy[2], v.kordy[3]+2.5)
	setElementInterior(t, v.dimint[1])
	setElementDimension(t, v.dimint[2])
end

local pojazdy = {}

function unnA(cars)
	if #cars > 0 then
		for i,v in pairs(cars) do
			local salon = getElementData(v,"vehicle:salon") or false;
			if not salon then
				return true
			end
		end
	end
	return false
end

function colid(id)
	for i,v in pairs(getElementsByType('colshape')) do
		local sid = getElementData(v,"gemo:id") or false;
		if sid and sid == id then
			return v
		end
	end
	return false
end

function respPoj()
	for i,v in pairs(postaw_prace) do
		if not pojazdy[i] then	
			local col = colid(i)
			local poj=getElementsWithinColShape(col,"vehicle")
			local zwrot = unnA(poj)
			if zwrot then
				setTimer(startTimer, 1000, 1)
				triggerEvent("addAdmNoti",root,"GEMMOLOG","Nie mogę zrespić nowego pojazdu, spawn["..i.."] zablokowany!")
--				return
			end
			if not zwrot then
				local veh = createVehicle(482, v.kordy[1], v.kordy[2], v.kordy[3]+0.1, 0, 0, v.kordy[4])
				setElementInterior(veh, 0)
				setElementDimension(veh, 0)
				setElementData(veh,"vehicle:id", ""..math.random(1000000,9999999).."")
				setElementData(veh,"vehicle:owner", "Serwer")
				setElementData(veh,"vehicle:spawnID",i)
				setElementData(veh,"vehicle:paliwo", 10)
				setElementData(veh,"vehicle:przebieg", 150500)
				setElementData(veh,"vehicle:odznaczone",false)
				setElementData(veh,"vehicle:salon",true)
				setElementData(veh,"vehicle:jobcode", "gemmolog-sa")
				setVehiclePlateText(veh,"LV "..getElementData(veh,"vehicle:id").."")
				setVehicleColor(veh, 102, 153, 153)
				setElementFrozen(veh, true)
				setVehicleDamageProof(veh, true)
				pojazdy[i] = true;
			end
		end
	end
end

function startTimer()
	if isTimer(holtimer) then return end
	holtimer=setTimer(respPoj, 25000, 1)
end

addEventHandler("onResourceStart", root, startTimer)

------------- punkty pracy (przednioty engine)
local gdzie_respic = {
{-377.4306640625, 1221.2099609375, 19.796318054199},
{385.7138671875, 887.7919921875, 20.77173614502},
{544.109375, 907.4404296875, -42.9609375},
{588.69140625, 919.982421875, -42.215572357178},
{695.314453125, 898.2705078125, -38.969764709473},
{578.15625, 790.79296875, -29.037809371948},
{493.4189453125, 786.5322265625, -22.120824813843},
{1016.7958984375, 165.240234375, 31.986864089966},
{1293.2587890625, 101.2939453125, 21.135335922241},
{1359.732421875, 90.111328125, 25.926292419434},
{1424.484375, 103.880859375, 25.586391448975},
{1583.771484375, 275.3349609375, 17.733787536621},
{2121.7197265625, -76.5205078125, 1.2428045272827},
{2143.3583984375, -109.2763671875, 1.3134984970093},
{2814.97265625, -313.8056640625, 10.334465026855},
{2834.6044921875, 63.5400390625, 20.34211730957},
{2525.47265625, 278.154296875, 30.072313308716},
{2363.7236328125, 333.8330078125, 24.059946060181},
{2367.7451171875, 306.421875, 21.997522354126},
{2327.6669921875, 301.6171875, 26.837375640869},
{2323.55078125, 316.16796875, 26.549831390381},
{2487.103515625, 699.583984375, 10.8203125},
{2520.80078125, 636.453125, 10.966394424438},
{2543.7705078125, 629.0927734375, 11.136650085449},
{2562.501953125, 625.1630859375, 10.576333999634},
{2647.9169921875, 619.6943359375, 9.4033489227295},
{2680.3125, 610.181640625, 9.6021518707275},
{2714.296875, 615.837890625, 10.8203125},
{905.0283203125, 2552.3955078125, 13.300006866455},
{893.6572265625, 2537.96875, 14.809081077576},
{889.5068359375, 2644.7255859375, 13.407402038574},
{932.6591796875, 2655.3154296875, 13.482969284058},
{763.333984375, 2595.81640625, 21.468580245972},
{749.310546875, 2578.125, 23.201961517334},
{752.60546875, 2567.025390625, 25.514472961426},
{609.7822265625, 2577.896484375, 33.287147521973},
{596.935546875, 2603.0029296875, 36.547546386719},
{576.13671875, 2613.82421875, 43.393070220947},
{555.4013671875, 2620.515625, 49.077201843262},
{587.4970703125, 2492.6328125, 36.030326843262},
{605.9296875, 2455.74609375, 32.306579589844},
{540.728515625, 2272.1513671875, 35.270313262939},
{322.072265625, 2158.4091796875, 22.530773162842},
{274.4287109375, 2158.37890625, 20.40104675293},
{235.33203125, 2159.296875, 19.371000289917},
{190.5361328125, 2166.353515625, 19.999052047729},
}

function delShape(gracz)
    shape=getElementsByType('colshape')
    for i,v in pairs(shape) do
		local data = getElementData(v,"gemmolog:player") or 0;
		local uid = getElementData(gracz,"player:dbid") or 0;
		if uid > 0 and data == uid then
		    destroyElement(v)
		end
    end	
end

function delBlip(gracz)
    blip=getElementsByType('blip')
    for i,v in pairs(blip) do
		local data = getElementData(v,"gemmolog:player") or 0;
		local uid = getElementData(gracz,"player:dbid") or 0;
		if uid > 0 and data == uid then
		    destroyElement(v)
		end
    end	
end

function delMarker(gracz)
    marker=getElementsByType('marker')
    for i,v in pairs(marker) do
        local m = getElementData(v,"gemmolog:player") or 0
		local p = getElementData(gracz,"player:dbid") or 0
		if m > 0 and m == p then
		    destroyElement(v)
		end
    end	
end

function znajdz(id)
	for i,v in pairs(gdzie_respic) do
		if i==id then
			return v
		end
	end
	return false
end

function los_respa(gracz)
	local rng = math.random(1,#gdzie_respic)
	local v = znajdz(rng)
	if v then
		-- profilaktyczne delete
		delBlip(gracz)
		delShape(gracz)
		delMarker(gracz)
		removeElementData(gracz,"player:JOBpoints")
		unbindKey(gracz, "z", "down", zacznijkopac)
		outputChatBox(" ", plr,231, 217, 176,true)
		outputChatBox("#e7d9b0* Otrzymałeś nowe zlecenie, udaj się do punktu GPS (#EBB85DC#e7d9b0) na mapie.", plr, 255, 255, 255, true)
		
		-- blip
		blip = createBlip(v[1], v[2], v[3], 12, 0, 0, 0, 0, 255, 1, 4000, gracz)
		setElementData(blip,"gemmolog:player",getElementData(gracz,"player:dbid"))
		playSoundFrontEnd(gracz, 20)
		-- obaszr
		obszar = createColSphere(v[1], v[2], v[3], 5) -- 5 powinien byc ok
		setElementData(obszar,"gemmolog:player",getElementData(gracz,"player:dbid"))
		-- corona VIRUS
		point = createMarker(v[1], v[2], v[3], "corona", 2, 233, 22, 44, 166, gracz)
		setElementData(point,"gemmolog:player",getElementData(gracz,"player:dbid"))
	end
end

function animacja(kto,co,co2,var,var2,var3)
	setPedAnimation(kto,co,co2,var,var2,var3)
end

function zacznijkopac(kto)
	if kto then
		local kopie = getElementData(kto,"player:czyonkopie") or false;
		if not kopie and not isPedInVehicle(kto) then
			local points = getElementData(kto,"player:JOBpoints") or 0;
			if points >= 2500 then
				outputChatBox("* Nie masz już miejsca.", kto, 255, 0, 0)
				return
			end
			outputChatBox("* Kopie...", kto, 150, 150, 150)
--			setPedAnimation(kto,"CARRY","crry_prtial")
			setTimer(animacja, 1, 1, kto, "DEALER", "DEALER_IDLE", -1, true, false)
			setTimer(animacja, 2500, 1, kto, "CAMERA", "camstnd_to_camcrch", -1, false, false)
			setTimer(animacja, 4300, 1, kto, "COP_AMBIENT", "Copbrowse_nod", -1, true, false)
			setTimer(tinyStopAnim, 7800, 1, kto)
			setElementData(kto,"player:czyonkopie",true)
		end
	end
end

function tinyStopAnim(kto)
	if kto then
		setPedAnimation(kto)
		local rng = math.random(1,10000)
		local points = getElementData(kto,"player:JOBpoints") or 0;
		if rng >= 1 and rng < 100 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To odłamek diamentu!", kto, 231, 217, 176,true)
			points = points + 349;
			jtype = 15
		elseif rng >= 100 and rng < 300 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To odłamek rubinu!", kto, 231, 217, 176,true)
			points = points + 275;
			jtype = 11
		elseif rng >= 300 and rng < 1000 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To odłamki złota!", kto, 231, 217, 176,true)
			points = points + 686;
			jtype = 8
		elseif rng >= 1000 and rng < 2200 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To czyste srebro!", kto, 231, 217, 176,true)
			points = points + 516;
			jtype = 6
		elseif rng >= 2200 and rng < 4400 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To odłamek ebonitu!", kto, 231, 217, 176,true)
			points = points + 71;
			jtype = 2
		elseif rng >= 4400 and rng < 9500 then
			outputChatBox("#808080* Coś wydobyto... #e7d9b0To zwykły kawałek kamyka!", kto, 231, 217, 176,true)
			points = points + 299;
			jtype = 1
		else
			outputChatBox("#e7d9b0* Nic tutaj nie było.", kto, 231, 217, 176,true)
			points = points + 0;
			jtype = 0
		end
		-- add mysql
		local uid = getElementData(kto,"player:dbid") or 0
		local code = "gemmolog-sa"
		local query = exports["aj-dbcon"]:upd("INSERT INTO jbsl SET joblog_code=?, joblog_data=NOW(), joblog_value=1, joblog_userid=?, joblog_type=?",code,uid,jtype);
			
		setElementData(kto,"player:JOBpoints",points)
		local points = getElementData(kto,"player:JOBpoints") or 0;
		-- jesli wyczerpie punkty
		if points >= 2500 then 
--			los_respa(kto)
--			setTimer(los_respa, math.random(2500,5000), 1, kto)
--			removeElementData(kto,"player:JOBpoints")
			outputChatBox(" ", kto, 231, 217, 176,true)
			outputChatBox("#e7d9b0* Masz za dużo wydobytych przedmiotów przy sobię, odnieś je do pojazdu.", kto, 231, 217, 176,true)
			outputChatBox("#e7d9b0* Wejdź jako #EBB85Dpasażer#e7d9b0 do tylniej części pojazdu.", kto, 231, 217, 176,true)
			if points >= 2600 then
				setControlState(kto, "walk", true)
				toggleControl(kto, "jump", false)
				toggleControl(kto, "sprint", false)
			end
		end
		removeElementData(kto,"player:czyonkopie")
	end
end

addEventHandler("onColShapeHit", root, function(gracz,md)
	if not md then return end
	if isElement(gracz) and getElementType(gracz) == "player" then
		local uidsh = getElementData(source,"gemmolog:player")
		local uid = getElementData(gracz,"player:dbid")
		if uidsh and uidsh == uid then
			bindKey(gracz, "z", "down", zacznijkopac, gracz)
			triggerClientEvent("praca:infoZ",root,gracz,true)
		end
	end
end)

addEventHandler("onColShapeLeave", root, function(gracz,md)
	if isElement(gracz) and getElementType(gracz) == "player" then
		local uidsh = getElementData(source,"gemmolog:player")
		local uid = getElementData(gracz,"player:dbid")
		if uidsh and uidsh == uid then
			unbindKey(gracz, "z", "down", zacznijkopac)
			triggerClientEvent("praca:infoZ",root,gracz,false)
		end
	end
end)

-- setPedAnimation(plr,"CARRY","crry_prtial",1,true,false,true,false)

------------- rozładunek

local obszar = createColSphere(-296.95703125, 1211.5107421875, 19.738185882568, 4) -- 5 powinien byc ok
setElementData(obszar,"gemmolog:rozladunek",true)
local obszarvisu = createMarker(-296.95703125, 1211.5107421875, 19.738185882568-6, "cylinder", 7, 77, 199, 25, 44) 
setElementData(obszar,"gemmolog:startjob",true)
	t = createElement("text")
	setElementData(t,"name","Rozładunek pojazdów gemmologa, nie zastawiać!")
	setElementData(t,"scale",1)
	setElementData(t,"distance",17)
	setElementPosition(t,-296.95703125, 1211.5107421875, 19.738185882568+3)
	


addEventHandler("onColShapeHit", root, function(veh,md)
	if not md then return end
	if isElement(veh) and getElementType(veh) == "vehicle" then
		local gemmolog = getElementData(source,"gemmolog:rozladunek") or false;
		if gemmolog then
			local jobCode = getElementData(veh,"vehicle:jobcode") or false;
			if jobCode == "gemmolog-sa" then
				local plr = getVehicleOccupant(veh)
				if isElement(plr) and getElementType(plr) == "player" then
					local vehp = getElementData(veh,"vehicle:JOBpoints") or 0;
					local plrp = getElementData(plr,"player:JOBpoints") or 0;
					
					local suma = vehp + plrp;
					local sum22a = suma*1.55;
					local sumalad = string.format("%.2f", suma/100)
					local kwota = (suma * 1.55);
					
					local sprvalue = getPlayerMoney(plr)
					local sprvalue = sprvalue + sum22a
					if 99999999 < sprvalue then 
						outputChatBox("#841515✖#e7d9b0 Błąd, gracz osiągną limit gotówki przy sobie!", plr,231, 217, 176,true) 
						outputChatBox(" ", plr,231, 217, 176,true)
						outputChatBox("#388E00✔#e7d9b0 Rozładowano pojazd z #EBB85D"..sumalad.." kg#e7d9b0.", plr,231, 217, 176,true)
						removeElementData(veh,"vehicle:JOBpoints")
						removeElementData(plr,"player:JOBpoints")
						return 
					end
					
					outputChatBox("#388E00✔#e7d9b0 Rozładowano pojazd z #EBB85D"..sumalad.." kg#e7d9b0.", plr,231, 217, 176,true)
					givePlayerMoney(plr, kwota)
					local uid = getElementData(plr,"player:dbid") or 0;
					if uid > 0 then
						local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_money=user_money+'"..kwota.."'  WHERE user_id = '"..uid.."'");
						local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_bankmoney=user_bankmoney+"..kwota.." WHERE user_id = '22'");
						local query = exports["aj-dbcon"]:upd("INSERT INTO lbk SET lbank_userid = '22', lbank_touserid = '"..uid.."', lbank_kwota='"..kwota.."', lbank_data=NOW(), lbank_desc='Praca dorywcza gemmolog.', lbank_type='1'");
					end
					
					removeElementData(veh,"vehicle:JOBpoints")
					removeElementData(plr,"player:JOBpoints")
				end
			end
		end
	end
end)

------------- sekcja jubliera etc (zarobek/sprzedawanie)

local diamenty_cena = 0
local rubiny_cena = 0
local zloto_cena = 0
local srebro_cena = 0
local ebonit_cena = 0

-- rng
function rotacja(kasa)
	local kasa1 = kasa * 0.25; -- 25% kwoty
	local kasa2 = kasa * 0.65; -- 65% kwoty
	local losowanie = math.random(-kasa2,kasa1)
	return losowanie
end

function generujceny()
	-- tabela cen
	diamenty_cena = 99059 + (rotacja(99059))
	rubiny_cena = 47899 + (rotacja(47899))
	zloto_cena = 12899 + (rotacja(12899))
	srebro_cena = 6909 + (rotacja(6909))
	ebonit_cena = 2549 + (rotacja(2549))
end
-- timer
generujceny()
local jubiler = setTimer(generujceny, (60000*60*12), 0) -- raz na 12h

addCommandHandler("root.jubiler",function(plr,cmd)
	local perm = tonumber(getElementData(plr,"admin:poziom")) or 0;
	if perm >= 10 then
		generujceny()
		outputChatBox("* Generownie nowych cen...",plr)
	end
end)

local blip = createBlip(2262.103515625, 2036.1669921875, 10, 43, 0, 0, 0, 0, 255, 1, 300)
local marker = createMarker(2262.103515625, 2036.1669921875, 10.8203125-2, "cylinder", 2, 78, 188, 0, 22) -- tylko visu
local sphe = createColSphere(2262.103515625, 2036.1669921875, 10.8203125, 1)
	setElementData(sphe,"jubiler",true)
	t = createElement("text")
	setElementData(t,"name","Pierwszy oddział jubilerski w LV.")
	setElementData(t,"scale",1)
	setElementData(t,"distance",17)
	setElementPosition(t,2262.103515625, 2036.1669921875, 10.8203125+1)

function matName(type)
	if type then
		if type==2 then name="Ebonit"; end
		if type==6 then name="Srebro"; end
		if type==8 then name="Zloto"; end
		if type==11 then name="Rubiny"; end
		if type==15 then name="Diamenty"; end
		return name
	end
	return false
end

function matCost(type)
	if type then
		if type==2 then cost=ebonit_cena; end
		if type==6 then cost=srebro_cena; end
		if type==8 then cost=zloto_cena; end
		if type==11 then cost=rubiny_cena; end
		if type==15 then cost=diamenty_cena; end
		return cost
	end
	return false
end


function kamien(code,uid,type)
	if type and uid and code then
		local mat = exports["aj-dbcon"]:wyb("SELECT * FROM jbsl WHERE joblog_code=? AND joblog_userid=? AND joblog_value=1 AND joblog_type=?",code,uid,type);
		local mat = #mat;
		return mat
	end
	return false
end

addEvent("job:gemmolog:sprzedaj",true)
addEventHandler("job:gemmolog:sprzedaj",root,function(plr,type)
	if isElement(plr) then
		local uid = getElementData(plr,"player:dbid") or 0;
		if uid > 0 then
			-- wyciagamy cale wydobycie gracza
			local code = "gemmolog-sa"
			local mat = kamien(code,uid,type);
			if mat > 0 then
				local calycost = (matCost(type)*mat)
				outputChatBox("#388E00✔#e7d9b0 Sprzedano #EBB85D"..matName(type).."#e7d9b0 za #388E00"..string.format("%.2f", calycost/100).."$#e7d9b0.", plr,231, 217, 176,true)
				local mycash = getPlayerMoney(plr)
				local fullcost = mycash + (calycost)
				if fullcost > 99999999 then
					outputChatBox("", plr,231, 217, 176,true)
					outputChatBox("#841515✖#e7d9b0 Błąd, gracz osiągną limit gotówki przy sobie!", plr,231, 217, 176,true) 
					return 
				end
				givePlayerMoney(plr,calycost)
				local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_money=user_money+'"..calycost.."'  WHERE user_id = '"..uid.."'");
				local query = exports["aj-dbcon"]:upd("UPDATE usr SET user_bankmoney=user_bankmoney+"..calycost.." WHERE user_id = '22'");
				local query = exports["aj-dbcon"]:upd("INSERT INTO lbk SET lbank_userid = '22', lbank_touserid = '"..uid.."', lbank_kwota='"..calycost.."', lbank_data=NOW(), lbank_desc='Sprzedaż surowców (jubiler).', lbank_type='1'");
				
				local query = exports["aj-dbcon"]:upd("UPDATE jbsl SET joblog_value=0 WHERE joblog_code=? AND joblog_userid=? AND joblog_value=1 AND joblog_type=?",code,uid,type);
				refreshdane(plr,uid)
			end
		end
	end
end)

function refreshdane(plr,uid)
	if uid > 0 then
		local code = "gemmolog-sa"
		--local jubi = exports["aj-dbcon"]:wyb("SELECT * FROM server_jobslog WHERE joblog_code=? AND joblog_userid=? AND joblog_value=1 AND joblog_type>1",code,uid);
		--if #jubi > 0 then
			-- wyciagamy cale wydobycie gracza
			local ebonit = kamien(code,uid,2) or 0
			local srebro = kamien(code,uid,6) or 0
			local zloto = kamien(code,uid,8) or 0
			local rubin = kamien(code,uid,11) or 0
			local diament = kamien(code,uid,15) or 0
				
			setElementData(plr,"jubiler:test",{	
			{ -- diament
				nazwa="Diament",
				ilosc=diament,		
				cena=(matCost(15)*diament),
				cenaone=matCost(15),
				id=15,
			},
			{ -- rubin
				nazwa="Rubin",
				ilosc=rubin,		
				cena=(matCost(11)*rubin),
				cenaone=matCost(11),
				id=11,
			},
			{ -- rubin
				nazwa="Złoto",
				ilosc=zloto,		
				cena=(matCost(8)*zloto),
				cenaone=matCost(8),
				id=8,
			},
			{ -- rubin
				nazwa="Srebro",
				ilosc=srebro,		
				cena=(matCost(6)*srebro),
				cenaone=matCost(6),
				id=6,
			},
			{ -- rubin
				nazwa="Ebonit",
				ilosc=ebonit,		
				cena=(matCost(2)*ebonit),
				cenaone=matCost(2),
				id=2,
			},
			})
		--end
		
		triggerClientEvent("job:gemmolog:jubilerrefresh",root,plr)
	end
end

addEventHandler("onColShapeHit", root, function(plr,md)
	if not md then return end
    if getElementType(plr) ~= "player" then return end
	local jubiler = getElementData(source,"jubiler") or false;
	if jubiler then
		local veh = isPedInVehicle(plr) or false;
		if veh then return end
		local uid = getElementData(plr,"player:dbid") or 0;
		if uid > 0 then
			local code = "gemmolog-sa"
			local jubi = exports["aj-dbcon"]:wyb("SELECT * FROM jbsl WHERE joblog_code=? AND joblog_userid=? AND joblog_value=1 AND joblog_type>1",code,uid);
			if #jubi > 0 then
				-- wyciagamy cale wydobycie gracza
				refreshdane(plr,uid)
			end
			triggerClientEvent("job:gemmolog:jubilershop",root,plr,false)
		end
	end
end)

addEventHandler("onColShapeLeave", root, function(plr,md)
	local jubiler = getElementData(source,"jubiler") or false;
	if jubiler then
		local uid = getElementData(plr,"player:dbid") or 0;
		if uid > 0 then
			triggerClientEvent("job:gemmolog:jubilershop",root,plr,true)
		end
	end
end)

------------- wsiadanie / wysiadanie / quit 
local timer = {}

function startenter(plr, seat, jacked)
	local uid = getElementData(plr,"player:dbid") or 0;
    if seat == 0 then
		if source then
			local jobCode = getElementData(source,"vehicle:jobcode") or false;
			if jobCode == "gemmolog-sa" then
				local vehov = tostring(getElementData(source,"vehicle:owner"))
				if isTimer(timer[plr]) and vehov=="Serwer" then 
					cancelEvent()
					return 
				end
			end
		end
	elseif seat == 2 or seat == 3 then -- jak zaczyna oddawac staff reset timera
		if source then
			local jobCode = getElementData(source,"vehicle:jobcode") or false;
			local jobOwner = getElementData(source,"vehicle:owner") or false;
			if jobCode == "gemmolog-sa" and uid == jobOwner then
				if isTimer(timer[plr]) then killTimer(timer[plr]) end
				timer[plr] = setTimer(usuwaniePracy, 180000, 1, plr)
			end
		end
	end
end
addEventHandler("onVehicleStartEnter", root, startenter)

function enter(plr, seat, jacked)
--    if seat ~= 0 then return end
	local uid = getElementData(plr,"player:dbid") or 0;
	if seat == 2 or seat == 3 then 
		if source then
			local jobCode = getElementData(source,"vehicle:jobcode") or false;
			local jobOwner = getElementData(source,"vehicle:owner") or false;
			if jobCode == "gemmolog-sa" and uid==jobOwner then
				local points = getElementData(plr,"player:JOBpoints") or 0;
				if points >= 2500 then
					carpoints = getElementData(source,"vehicle:JOBpoints") or 0;
					if carpoints < 25000 then
						setTimer(los_respa, math.random(2500,5000), 1, plr)
						delBlip(plr)
						delShape(plr)
						delMarker(plr)
						suma = carpoints + points;
						setElementData(source,"vehicle:JOBpoints",suma)
						removeElementData(plr,"player:JOBpoints")
						outputChatBox(" ", plr, 231, 217, 176,true)
						outputChatBox("#e7d9b0* Udało Ci się odłożyć wydobyte przedmioty.", plr, 231, 217, 176,true)
						if isTimer(timer[plr]) then killTimer(timer[plr]) end
						timer[plr] = setTimer(usuwaniePracy, 180000, 1, plr)
						setControlState(plr, "walk", false)
						toggleControl(plr, "jump", true)
						toggleControl(plr, "sprint", true)
					else
						outputChatBox("#e7d9b0* Pojazd jest przepełniony, udaj się na baze w celu rozładunku!", plr, 255, 0, 0,true)
						-- blip
						blip = createBlip(-296.95703125, 1211.5107421875, 19.738185882568, 12, 0, 0, 0, 0, 255, 1, 4000, plr)
						setElementData(blip,"gemmolog:player",getElementData(plr,"player:dbid"))
						playSoundFrontEnd(plr, 20)
					end
				end
			else
				cancelEvent()
			end
		end
	end
	if source and seat==0 then
		local jobCode = getElementData(source,"vehicle:jobcode") or false;
		local jobOwner = getElementData(source,"vehicle:owner") or false;
		if jobCode == "gemmolog-sa" then
			local uid = getElementData(plr,"player:dbid") or 0;
--			local vehicle = getPedOccupiedVehicle(source) or false
			if jobOwner == "Serwer" then
				removeElementData(source,"vehicle:salon")
				setElementData(source,"vehicle:owner", uid)
				setElementData(source,"vehicle:ogranicznik",105)
				setElementFrozen(source, false)
				setVehicleEngineState(source, true)
				setTimer(los_respa, math.random(2500,5000), 1, plr)
--				setElementData(plr,"player:pracuje",true)
				triggerClientEvent("praca:info",root,plr)
				
				setElementData(plr,"player:jobCAR", source)
				
				local code = "gemmolog-sa";
				local spr_mnoznik = exports["aj-dbcon"]:wyb("SELECT IFNULL(SUM(joblog_value),0) ilosc FROM jbsl WHERE joblog_userid='"..uid.."' AND joblog_code='"..code.."'");
				local ilosc = tonumber(spr_mnoznik[1].ilosc);
					if spr_mnoznik and ilosc >= 11000 then poziom = "4 LVL"; end
					if spr_mnoznik and ilosc >= 5000 and ilosc < 11000 then poziom = "3 LVL"; end
					if spr_mnoznik and ilosc >= 2500 and ilosc < 5000 then poziom = "2 LVL"; end
					if spr_mnoznik and ilosc >= 0 and ilosc < 2500 then poziom = "1 LVL"; end
				outputChatBox(" ", plr,231, 217, 176,true)
				outputChatBox("#388E00✔#e7d9b0 Aktualnie w pracy dorywczej #EBB85Dgemmolog#e7d9b0, posiadasz #EBB85D"..ilosc.."#e7d9b0 punktów (#EBB85D"..poziom.."#e7d9b0).", plr,231, 217, 176,true)
			end
			local gbid = getElementData(source,"vehicle:spawnID") or false;
			if gbid then
				pojazdy[gbid] = false;
				startTimer()
				removeElementData(source,"vehicle:spawnID")
			end
			if isTimer(timer[plr]) then killTimer(timer[plr]) end
			triggerClientEvent("praca:infodwa",root,plr)
		end
	end
end
addEventHandler("onVehicleEnter", root, enter)

local obszar = createColSphere(-245.21211242676, 1223.0107421875, 23.5750961303715, 1)
local obszarvisu = createMarker(-245.21211242676, 1223.0107421875, 23.575096130371-1, "cylinder", 1.6, 77, 199, 25, 44) 
setElementData(obszar,"gemmolog:startjob",true)
	t = createElement("text")
	setElementData(t,"name","Zakończ prace Gemmologa.")
	setElementData(t,"scale",1)
	setElementData(t,"distance",17)
	setElementPosition(t,-245.21211242676, 1223.0107421875, 23.575096130371+1.2)
	
addEventHandler("onColShapeHit", root, function(plr,md)
	if not md then return end
    if getElementType(plr) ~= "player" then return end
	local spr = getElementData(source,"gemmolog:startjob") or false;
	if spr then
		if isTimer(timer[plr]) then
			usuwaniePracy(plr)
		end
	end
end)

function usuwaniePracy(kto)
	if isElement(kto) then
		delBlip(kto)
		delShape(kto)
		delMarker(kto)
--		removeElementData(kto,"player:pracuje")
		unbindKey(kto, "z", "down", zacznijkopac)
		triggerClientEvent("praca:infostop",root,kto)
		triggerClientEvent("praca:infostopdwa",root,kto)
		outputChatBox("* Praca została przerwana.", kto)
		local pojazd = getElementData(kto,"player:jobCAR") or false;
		if pojazd then
			if isElement(pojazd) then
				destroyElement(pojazd)
			end
		end
		if isTimer(timer[kto]) then killTimer(timer[kto]) end
	end
end

function exitcar(plr, seat, jacked)
    if seat ~= 0 then return end
	if source then
		local jobCode = getElementData(source,"vehicle:jobcode") or false;
		if jobCode == "gemmolog-sa" then
			if isTimer(timer[plr]) then return end
			timer[plr] = setTimer(usuwaniePracy, 180000, 1, plr)
			outputChatBox(" ", plr,231, 217, 176,true)
			outputChatBox("#e7d9b0* Masz #EBB85D3 minuty#e7d9b0, aby powrócić do pojazdu.", plr, 231, 217, 176,true)
			triggerClientEvent("praca:infostopdwa",root,plr)
		end
	end
end
addEventHandler("onVehicleExit", root, exitcar)

function quitPlayer() -- jak wyjdzie / connection lost ?
    local uid = getElementData(source,"player:dbid") or 0;
	if uid > 0 then
		delBlip(source)
		delShape(source)
		delMarker(source)
		if isTimer(timer[source]) then killTimer(timer[source]) end
	    local vehicle = getElementData(source,"player:jobCAR") or false
		if vehicle then
			if isElement(vehicle) then
				destroyElement(vehicle)
			end
		end
	end
end
addEventHandler("onPlayerQuit", root, quitPlayer)

gracze=getElementsByType('player')
for i,v in pairs(gracze) do
--	removeElementData(v,"player:pracuje")
	removeElementData(v,"player:czyonkopie")
end	







