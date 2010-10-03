LWS = require 'nilg_lws'
FSM = require 'nilg_fsm'
LS  = require 'nilg_ls'

module("nilg_ctrl", package.seeall)

local CTRL = {}

--- Az LWS és LS együttműködésével
-- végigmegy a megtanulásra szánt
-- anyagon.
function CTRL:new()
	
	o = {}
	setmetatable(o, self)
	self.__index = self
	
	o._lws = nil
	o._ls  = nil
	
	return o
end

function CTRL:setLS(ls)
	
	o._ls = ls
end
function CTRL:setLWS(lws)

	o._lws = lws
end
function CTRL:init()
	
	for i=1,7 do
		self._lws:addEntry(self._ls:pop())
	end
	self._lws:addEntryOnRemoveEventFromLS(self._ls)
end
function CTRL:next()
	return self._lws:next()
end
function CTRL:statechange(event)
	self._lws:stateChange(event)
end


return CTRL