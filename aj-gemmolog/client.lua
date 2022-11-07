--[[
    By AjonEG <ajonoficjalny@gmail.com> @ 2021 (c)
	Wszelkie prawa zastrzeżone.
	
	Skrypt pracy gemmologa TEST.
]]--

local jubiler = {}
local czyon = false

-- dane gui
local opis = "Oddział jubilerski w LV.\n\nTutaj sprzedasz surowce a dokładnie kamienie szlachetne wydobyte w pracy gemmologa.\n\nCeny, które wyświetlają się obok surowców są cenami tymczasowymi i zmiennymi, każdego dnia ceny zmieniają swe wartości na większe bądź mniejsze. To od Ciebie zależy, w jakim momencie sprzedasz surowce.";

	jubiler.okno = guiCreateWindow((screenW - 706) / 2, (screenH - 602) / 2, 706, 602, "Jubiler", false)
	guiWindowSetSizable(jubiler.okno, false)

	jubiler.lista = guiCreateGridList(24, 55, 324, 361, false, jubiler.okno)
	guiGridListAddColumn(jubiler.lista, "Surowiec", 0.3)
	guiGridListAddColumn(jubiler.lista, "Ilość", 0.3)
	guiGridListAddColumn(jubiler.lista, "Cena za ilość", 0.3)
	jubiler.topic = guiCreateLabel(374, 55, 313, 35, "Informacje", false, jubiler.okno)
	jubiler.info = guiCreateMemo(374, 93, 313, 323, "Cena za sztuke: brak danych\n\nOpis: " .. opis, false, jubiler.okno)
	guiMemoSetReadOnly(jubiler.info, true)
	jubiler.btn_sprzedaj = guiCreateButton(25, 456, 323, 54, "Sprzedaj", false, jubiler.okno)
	jubiler.btn_zamknij = guiCreateButton(24, 525, 323, 54, "Zamknij", false, jubiler.okno)
	--jubiler.lbl_ilosc = guiCreateEdit(374, 456, 243, 54, ilosc, false, jubiler.okno)
	--guiEditSetReadOnly(jubiler.lbl_ilosc, true)
	--jubiler.btn_dodaj = guiCreateButton(374, 525, 60, 54, "+", false, jubiler.okno)
	--jubiler.btn_odejmij = guiCreateButton(627, 525, 60, 54, "-", false, jubiler.okno)
	--jubiler.btn_czysc = guiCreateButton(627, 456, 60, 54, "Czyść", false, jubiler.okno)
	--jubiler.btn_dodaj10 = guiCreateButton(444, 525, 60, 54, "+ 10", false, jubiler.okno)
	--jubiler.btn_odejmij10 = guiCreateButton(557, 525, 60, 54, "- 10", false, jubiler.okno)
	guiSetVisible(jubiler.okno, false)


function generujliste()
	guiGridListClear(jubiler.lista) -- me
	local surowce = getElementData(localPlayer, "jubiler:test") or false
	if surowce then
		for i,v in ipairs(surowce) do
			local row = guiGridListAddRow(jubiler.lista)
			guiGridListSetItemText(jubiler.lista, row, 1, v.nazwa, false, false)
			guiGridListSetItemData(jubiler.lista, row, 1, v.id)
			guiGridListSetItemText(jubiler.lista, row, 2, v.ilosc, false, false)
			guiGridListSetItemData(jubiler.lista, row, 2, v.cenaone)
			guiGridListSetItemText(jubiler.lista, row, 3, string.format("%.2f", v.cena/100).."$", false, false)
			guiGridListSetItemData(jubiler.lista, row, 3, v.cena)
		end
	else
		local row = guiGridListAddRow(jubiler.lista)
		guiGridListSetItemText(jubiler.lista, row, 1, "brak", false, false)
		guiGridListSetItemText(jubiler.lista, row, 2, "surowców", false, false)
		guiGridListSetItemText(jubiler.lista, row, 3, "-", false, false)
	end
end

function pokazokno(plr)
	if localPlayer==plr and czyon==false then
		guiSetVisible(jubiler.okno, true)
	end
end

addEvent("job:gemmolog:jubilershop",true)
addEventHandler("job:gemmolog:jubilershop",root,function(plr,type)
	if plr==localPlayer then
		if type then
			guiSetVisible(jubiler.okno, false)
			showCursor(false)
		else
			if czyon then
				if guiGetVisible(jubiler.okno) then
					guiSetVisible(jubiler.okno, false)
					showCursor(false)
				else 
					guiSetVisible(jubiler.okno, true)
					showCursor(true)
					generujliste()
				end
			else
				pokazokno(localPlayer)
				showCursor(true)
				czyon=true
				generujliste()
			end
		end
	end
end)

addEvent("job:gemmolog:jubilerrefresh",true)
addEventHandler("job:gemmolog:jubilerrefresh",root,function(plr)
	if plr==localPlayer then
		generujliste()
	end
end)

addEventHandler("onClientGUIClick", resourceRoot, function()
	if source == jubiler.btn_sprzedaj then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		local id = guiGridListGetItemData(jubiler.lista, slRow, 1)
		if not tonumber(ile) then return end
		local cena = guiGridListGetItemData(jubiler.lista, slRow, 3)
		triggerServerEvent("job:gemmolog:sprzedaj",root,localPlayer,id)
	end

	if source == jubiler.btn_zamknij then
		guiSetVisible(jubiler.okno, false)
		showCursor(false)
	end
	
	if source == jubiler.lista then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		local cena = guiGridListGetItemData(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		--guiSetText(jubiler.lbl_ilosc, ile)
		guiSetText(jubiler.info ,"Cena za sztuke: "..string.format("%.2f", cena/100).."$\n\nOpis: " .. opis)
	end
	
	--[[dodawnia old
	if source == jubiler.btn_dodaj then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		ilosc = ilosc + 1
		if ilosc > tonumber(ile) then 
			ilosc = ilosc - 1
			return 
		end
		guiSetText(jubiler.lbl_ilosc, ilosc)
	end
	if source == jubiler.btn_dodaj10 then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		ilosc = ilosc + 10
		if ilosc > tonumber(ile) then 
			ilosc = ile
			guiSetText(jubiler.lbl_ilosc, ilosc)
			return 
		end
		guiSetText(jubiler.lbl_ilosc, ilosc)
	end
	
	-- odejmowania
	if source == jubiler.btn_odejmij then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		ilosc = ilosc - 1
		if ilosc < 0 then 
			ilosc = ilosc + 1
			return 
		end
		guiSetText(jubiler.lbl_ilosc, ilosc)
	end
	if source == jubiler.btn_odejmij10 then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		ilosc = ilosc - 10
		if ilosc < 0 then 
			ilosc = 0
			guiSetText(jubiler.lbl_ilosc, ilosc)
			return 
		end
		guiSetText(jubiler.lbl_ilosc, ilosc)
	end
	
	-- ogolne
	if source == jubiler.btn_czysc then
		local slRow, slCol = guiGridListGetSelectedItem(jubiler.lista)
		if not slRow then return end
		local ile = guiGridListGetItemText(jubiler.lista, slRow, 2)
		if not tonumber(ile) then return end
		ilosc = 0
		guiSetText(jubiler.lbl_ilosc, ilosc)
	end
	]]--
end)

-- koniec gui jubilera

local widocznosc = false
local widocznosc2 = false
local widocznosc3 = false
local vehicle = false

addEventHandler("onClientRender", root,function()
	if widocznosc2 then
		if vehicle and isElement(vehicle) then
			local pojazd = getElementData(vehicle,"vehicle:JOBpoints") or 0;	
			local pojazd = string.format("%.2f", pojazd/100)
			dxDrawText("Poj. pojazdu: "..pojazd.." na 250.00 kg.", (screenW * 0.3448) + 1, (screenH * 0.9467) + 1, (screenW * 0.6557) + 1, (screenH * 0.9707) + 1, tocolor(0, 0, 0, 255), 1.20, "default", "center", "center", false, false, false, false, false)
			dxDrawText("Poj. pojazdu: #EBB85D"..pojazd.." #FFFFFFna #EBB85D250.00#FFFFFF kg.", screenW * 0.3448, screenH * 0.9467, screenW * 0.6557, screenH * 0.9707, tocolor(255, 255, 255, 255), 1.20, "default", "center", "center", false, false, false, true, false)
		end
	end
	if widocznosc then
		local plecak = getElementData(localPlayer,"player:JOBpoints") or 0;	
		local plecak = string.format("%.2f", plecak/100)
		dxDrawText("Poj. plecaka: "..plecak.." na 25.00 kg.", (screenW * 0.3448) + 1, (screenH * 0.9667) + 1, (screenW * 0.6557) + 1, (screenH * 0.9907) + 1, tocolor(0, 0, 0, 255), 1.20, "default", "center", "center", false, false, false, false, false)
		dxDrawText("Poj. plecaka: #EBB85D"..plecak.." #FFFFFFna #EBB85D25.00#FFFFFF kg.", screenW * 0.3448, screenH * 0.9667, screenW * 0.6557, screenH * 0.9907, tocolor(255, 255, 255, 255), 1.20, "default", "center", "center", false, false, false, true, false)
	end
	if widocznosc3 then
		dxDrawText("Kliknij Z aby rozpocząć kopanie.", (screenW * 0.3448) + 1, (screenH * 0.0467) + 1, (screenW * 0.6557) + 1, (screenH * 0.0707) + 1, tocolor(0, 0, 0, 255), 1.20, "default", "center", "center", false, false, false, false, false)
		dxDrawText("Kliknij #EBB85DZ #FFFFFFaby rozpocząć kopanie.", screenW * 0.3448, screenH * 0.0467, screenW * 0.6557, screenH * 0.0707, tocolor(255, 255, 255, 255), 1.20, "default", "center", "center", false, false, false, true, false)
	end
end)


function zakonczinfo()
	widocznosc = false
end

function zakonczinfo_dwa()
	widocznosc2 = false
	vehicle = false
end

addEvent("praca:infostop",true)
addEventHandler("praca:infostop",root,function(plr)
	if plr and localPlayer then
		if plr == localPlayer then
			zakonczinfo()
		end
	end
end)

addEvent("praca:infostopdwa",true)
addEventHandler("praca:infostopdwa",root,function(plr)
	if plr and localPlayer then
		if plr == localPlayer then
			zakonczinfo_dwa()
		end
	end
end)

addEvent("praca:info",true)
addEventHandler("praca:info",root,function(plr)
	if plr and localPlayer then
		if plr == localPlayer then
			widocznosc = true
		end
	end
end)

addEvent("praca:infoZ",true)
addEventHandler("praca:infoZ",root,function(plr)
	if plr and localPlayer then
		if plr == localPlayer then
			if widocznosc3 then
				widocznosc3 = false
			else
				widocznosc3 = true
			end
		end
	end
end)


addEvent("praca:infodwa",true)
addEventHandler("praca:infodwa",root,function(plr)
	if plr and localPlayer then
		if plr == localPlayer then
			widocznosc2 = true
			vehicle = getPedOccupiedVehicle(plr) or false
		end
	end
end)