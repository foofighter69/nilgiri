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

