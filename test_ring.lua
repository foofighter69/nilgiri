require 'lunit'
RING = require 'ring'


module('test_ring', lunit.testcase, package.seeall)

function setup()
	r = RING:new()
	r:addTable({[1]="a",[2]="b",[3] = "c",[4] ="d",[5]="e",[6]="f",[7]="g"})
end

function test_remove()
	
	assert_equal("a", r:next())
	assert_equal("b", r:next())
	assert_equal("c", r:next())
	r:remove() -- c deleted

	assert_equal("d", r:next()) 
	assert_equal("e", r:next()) 
	r:remove() -- e deleted

	assert_equal("f", r:next()) 
	assert_equal("g", r:next())
	assert_equal("a", r:next())
	assert_equal("b", r:next())
	r:remove() -- b deleted

	assert_equal("d", r:next())
	assert_equal("f", r:next())
	r:remove() -- f deleted
	
	assert_equal("g", r:next())
	r:remove() -- g deleted

	assert_equal("a", r:next())
	r:remove() -- a deleted

	assert_equal("d", r:next())
	r:remove() -- d deleted

	assert_equal(nil, r:next())  
end
function test_add()
	
	assert_equal("a", r:next())
	r:add("m")
	r:add("o")
	assert_equal("b", r:next())
	assert_equal("c", r:next())
	assert_equal("d", r:next())
	assert_equal("e", r:next())
	assert_equal("f", r:next())
	assert_equal("g", r:next())
	assert_equal("m", r:next())
	assert_equal("o", r:next())
	assert_equal("a", r:next())
end	
function test_addandremove()
	
	assert_equal("a", r:next())
	r:remove() -- a deleted
	r:add("m")
	
	assert_equal("b", r:next())
	assert_equal("c", r:next())
	assert_equal("d", r:next())
	assert_equal("e", r:next())
	r:remove()
	
	assert_equal("f", r:next())
	assert_equal("g", r:next())
	assert_equal("m", r:next())
	assert_equal("b", r:next())
end
function test_random_firstnumber()
	
	r:setSelectAlgorithm("random")
	assert_not_nil(r:next())
	
end
function test_random_notnil()
	r:setSelectAlgorithm("random")
	
	for i=1,8 do
	assert_not_nil(r:next())
	end
end
function test_random_repeatcheck_innercycle()
	r:setSelectAlgorithm("random")
	
	--local test_table = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7 }
	--local test_table = {[1] = "e", [2] = "c", [3] = "a", [4] = "d", [5] = "b", [6] = "g", [7] = "f" }
	--local test_table = {[1]="a",[2]="b",[3] = "c",[4] ="d",[5]="e",[6]="f",[7]="g"}
	

	--r:addTable(test_table)
	function c()
		
		local t_i = {}
		for i=1,7 do 
			entry = r:next()
			
			for _,v in ipairs(t_i) do
				
				assert_not_equal(v, entry, "[-] v: ".. v..", e: "..entry) --..#r._t_randomshadow)
				
			end
			--io.write(entry)
			table.insert(t_i, entry)
		end

	end
	for s=1,7 do
	
		c()
		--print("---")
		
	end
end	
function test_random_remove()
	r:setSelectAlgorithm("random")

		
	function tst()
		assert_not_nil(r:next())
		r:remove()
		--print(r)
	end
	for i=1,7 do
	tst()
	end
	local test_table = {[1]="a",[2]="b",[3] = "c",[4] ="d",[5]="e",[6]="f",[7]="g"}
	

	r:addTable(test_table)	

	
end
function test_random_removeinsert()
	r:setSelectAlgorithm("random")
	
	r:next()
	print(r)
	
	r:next()
	print(r)
	
	r:remove()
	print(r)
	
	r:add("u")
	r:next()
	
	print(r)
	
	
end
	