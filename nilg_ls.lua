
module("nilg_ls", package.seeall)

local LS = {}
--- LS: LearningSet. Ez az a halmaz, amit lehetőség
-- szerint egyhuzamban megszeretnénk tanulni
-- Három állapota lehet a szavaknak:
-- (1) tanulás előtti (2) tanulás alatti (3) megtanult
function LS:new()
	
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
--- Feltöltöm a megtanulandó szavakat
-- Lehetőség szerint ezt fájlból olvasom ki
-- A tábla mérete fix.
function LS:addTable(t)
	
	local ls = {}
	for _,v in ipairs(t) do
		tmp = {}
		tmp.status = 1
		tmp.entry = v
		table.insert(ls, tmp)
	end
	self._ls = ls
end
--- Ez válogatja ki a soronkövetkező elemet
-- popnál.
function LS:next()
	if #self._ls == 1 or self._act == nil then
		self._act = 1
		return 1
	end
	if #self._ls > self._act then
		self._act = self._act+1
		return self._act
	end
	
end
--- A következő elemet adja vissza az állapt
-- infók nélkül és beépítve az elem sorszámát ahhoz,
-- hogy később sorszám alapján tudjuk változtatni
-- állapotát.
function LS:pop()
	idx = self:next()
	if idx then
		self._ls[idx].state = 2
		self._ls[idx].entry.idx = idx
		return self._ls[idx].entry
	end
end
--- A tanulási ablakot megjárt és megtanult elem
-- felveszi a megtanult állapotot
function LS:push(idx)
	
	self._ls[idx].state = 3
end
--- A megtanultak százalékos arányát adja vissza
-- 0 és 1 közötti számban
function LS:getLearntProcentNbr()
	local c = 0
	for _,v in ipairs(self._ls) do
		if 	v.state == 3 then
			c = c + 1
		end
	end
	nbr = (c / #self._ls)
	return nbr
end
--- A megtanultak százalékos arányát adja vissza
-- százalékban
function LS:getLearntProcent()
	-- poor man's math.round --
	s_nbr = string.format("%.2f", self:getLearntProcentNbr())
	
	s_nbr = tonumber(s_nbr)
	return s_nbr*100
end


--- Fájlból betölti a tanulandót, ha
-- szo1=szo2 formátumban vannak a fájlban 
function LS:loadFile(filename)

	local coll = {}
	h = io.open(filename, 'r')
	while h do
		
		line = h:read('*line')
		if line == nil then break end
		table.insert(coll, line)
	end
	h:close()
	local t_ls = {}
	for _,v in ipairs(coll) do
		
		szo1, szo2 = string.match(v, "^([^=]+)=([^=]+)$")
		if szo1 and szo2 then
			t = {}
			t.szo1 = szo1
			t.szo2 = szo2
			table.insert(t_ls, t) 
		end
	end
	if #t_ls > 0 then 
		self:addTable(t_ls)
	end
	return #self._ls
end
return LS