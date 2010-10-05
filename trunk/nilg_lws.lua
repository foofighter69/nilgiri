----------
-- learning window set = lws
-------
RING = require 'ring'

module("nilg_lws", package.seeall)

local LWS = {}

function LWS:dump(t)
	
	local list = ''
	for _,v in ipairs(t) do
		list = v .. ","
	end
	return list
end
function LWS:new()
	
	o = {}
	setmetatable(o, self)
	self.__index = self
	o._onStateChange = function (self, item, pre, nxt)
		--print("....",pre, nxt)
		if nxt == self._stopvalue then
			--print("Removed?")
			self:_removeEntry()
			
		end
	end
	o._onRemoveEvent = nil
	o._ring =  RING:new()
	
	return o
end

function LWS:setFSM(fsm_table)
	
	self._fsm = fsm_table
end
--- Szótártábla hozzáadása
-- A ring-be gyömöszöljük a szo1 és szo2 bejegyzéseket 
-- tartalmazó táblát. Az állapotok tárolása ennek az LWS-nek
-- a sajátja, így a tábla [1].entry vagy [1].state értéke mindig
-- kiolvasható
function LWS:addDictTable(dict_table)

	local LW = {}
	for _,v in ipairs(dict_table) do
		local t = {}
		t.entry   = v 
		t.state = 1
		table.insert(LW, t)
	end
	self._ring:addTable(LW)
end
function LWS:stateChange(event)
		
		item = self._ring:get()
		
		if item then  -- nil if called first, before next()
		
		prev_state = item.state
		next_state = self._fsm:getNextState(prev_state, event)
		item.state = next_state
		self._ring:set(item)
		
		if self._onStateChange then
			self:_onStateChange(item, prev_state, next_state)
		end
		
		end
	
end
function LWS:setOnStateChange(func)
	self._onStateChange=func
end
function LWS:next()
	return self._ring:next()
end
function LWS:addEntryOnRemoveEventFromLS(ls)
	
	self._ls = ls 
	
	if self._ls==nil then error('Missing LS') end
	ls = self._ls
	self._onRemoveEvent = function(self, ls)
		entry = ls:pop()
		if entry then  self:addEntry(entry) end
	end
end
function LWS:addEntry(entry)
	local t={}
	t.entry = entry
	t.state = 1
	self._ring:add(t)
end
function LWS:setStopValue(nbr)
	self._stopvalue = nbr
end

function LWS:_removeEntry()
	self._ring:remove()
	if self._onRemoveEvent then
		self:_onRemoveEvent(self._ls)
	end
end
function LWS:size()
	return self._ring:size()
end
function LWS:setSelectAlgorithm(algorithm)
	self._ring:setSelectAlgorithm(algorithm)
end

return LWS
