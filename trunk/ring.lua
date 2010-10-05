module('ring', package.seeall)

local ring = {}
--- 
--
function ring:new()

	o = {}
	setmetatable(o, self)
	self.__index = self
	o._act = nil
	o._shadow = {}
	o._selector = 'linear'
	o.ST={}

	return o
end


function ring:addTable(t)
	self.ST = t
end
--- Eltávolítja azt a bejegyzést, amire
-- a self._act mutat.
function ring:remove()
	print("[*] entry removed")
	
	
	if self._selector == 'linear' then
		table.remove(self.ST, self._act)
		self._act = self._act - 1
		if self_act == 0 then
			self._act = #self.ST
		end
	elseif self._selector == 'random' then
		-- fixing shadowtable --
		for k,v in ipairs(self._shadow) do
			if v == self._act then
				table.remove(self._shadow, v)
			end
		end
		for k,v in ipairs(self._shadow) do
			if v > self._act then
				
				self._shadow[k] = v-1
			end
		end
		
		table.remove(self.ST, self._act)
		self._act = self._act - 1
		if self_act == 0 then
			self._act = #self.ST
		end

	end
	--self:dump(self.ST)
	
end
function ring:add(entry)
	print("[*] entry added")
	table.insert(self.ST, entry)
	table.insert(self._shadow, #self.ST)
end
function ring:select()

	if self._selector == 'linear' then
		if self._act == nil then
			self._act = 0
		end
		if self._act == #self.ST then
			self._act = 1
		else
			self._act = self._act + 1
		end
		
	elseif self._selector == 'random' then
		
		if #self.ST == 0 then
			return nil, "ST is empty..."
		end
		
		if not self._shadow or #self._shadow == 0 then
			self._shadow = {}
			for k in ipairs(self.ST) do
				table.insert(self._shadow, k)
			end
		end
		rnd = math.random(1, #self._shadow)
		
		self._act = self._shadow[rnd]
		
		--print(" YYY",self._shadow, self._act)
		table.remove(self._shadow, rnd)
		
	end
	
	
end

function ring:next()

	self:select()
	return self.ST[self._act]
end
function ring:get()
	if self._act then
		return self.ST[self._act]
	else
		return nil, 'ring: internal pointer is nil'
	end
end
function ring:set(entry)
	if self._act ~= nil then
		self.ST[self._act] = entry
	end
end
function ring:size()
	return #self.ST
end

function ring:dump(tt, indent, done)

	local tt = tt or self.ST

  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      io.write(string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        io.write(string.format("[%s] => table\n", tostring (key)));
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write("(\n");
        self:dump(value, indent + 7, done)
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write(")\n");
      else
        io.write(string.format("[%s] => %s\n",
            tostring (key), tostring(value)))
      end
    end
  else
    io.write(tt .. "\n")
  end

end
function ring:dumpshadow()

	self:dump(self._t_randomshadow)
end

function ring:setSelectAlgorithm(algo_name)
	self._selector = algo_name
end

--- Kilistázom az self.ST és self._shadow
-- táblák tartalmát
function ring:__tostring()
	local result='self._shadow: \n'
	for k,v in ipairs(self._shadow) do
		result = result .. " " .. k ..":".. v.."\n"
	end
	result = result .. "self.ST:\n"
	for k,v in ipairs(self.ST) do
		result = result .. " " .. k ..":".. v.."\n"
	end
	return result
end

return ring


