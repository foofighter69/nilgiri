module('ring', package.seeall)

local ring = {}
--- 
--
function ring:new()

	o = {}
	setmetatable(o, self)
	self.__index = self
	self._act = nil
	o.ST={}

	return o
end


function ring:addTable(t)
	self.ST = t
end
function ring:remove()

	table.remove(self.ST, self._act)
	self._act = self._act - 1
	if self_act == 0 then
		self._act = #self.ST
	end
	self:dump(self.ST)
	
end
function ring:add(entry)
	if DEBUG then print('[*] ring:add(entry)') end
	table.insert(self.ST, entry)
end
function ring:next()

	if self._act == nil then
		self._act = 0
	end
	if self._act == #self.ST then
		self._act = 1
	else
		self._act = self._act + 1
	end
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

return ring


