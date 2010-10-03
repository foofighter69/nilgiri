module("nilg_fsm", package.seeall)

local FSM = {}

--- Példányosítja az FSM objektumot
-- Az FSM szó a Finite State Machine-ből jön, ami
-- véges állapotú automatát jelent. Tulajdonképpen két
-- fontos táblát tartalmaz. Az állapotok és állapotátmenetek 
-- tábláját.
function FSM:new()

	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
--- Állapotok tábla hozzáadása
-- A metódus elnevezése azért addNodeTable, mert itt 
-- tulajdonképpen egy gráfról és azok csúcsairól
-- van szó.
-- @param node_table csúcsok táblája, számokkal indexelt tömb
function FSM:addNodeTable(node_table)
	
	self.nodes = node_table 
end
--- Állapotátmenetek tábla hozzáadása
-- A paraméterként várt tábla indexe az állapotoknál
-- meghatározott számok, értéke egy olyan tábla, aminek
-- indexe az 'esemény', értéke a következő állapot
-- @param trans_table átmenetek tábla
function FSM:addTransitionTable(trans_table)
	
	self.transitions = trans_table
end
--- Következő állapot
-- Ha korábban megadtuk az állapotok és állapotátmenetek táblát
-- akkor a megadott paraméterek alapján a következő állapotot 
-- meg tudja mondani. Ha a kért állapot+esemény kombóhoz nincs
-- következő állapot nil a visszatérési érték
-- @param state lekért állapot
-- @param event esemény
function FSM:getNextState(state, event)
	if self.nodes[state] == nil then
		local errmsg = "not existent node"
		return nil, errmsg
	end
	if self.transitions[state] == nil then
		local errmsg = "no transitions for node"
		return nil, errmsg
	end
	return self.transitions[state][event], "not existent event"
end
--- Állapot leírása
-- A számindexnél több információt nyújt az adott állapotról
-- @param state állapot
function FSM:getStateDescription(state)

	return self.nodes[state]
end

return FSM

