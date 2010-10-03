require 'lunit'
local LS = require 'nilg_ls'

module('nilg_lunit_ls', lunit.testcase, package.seeall)

function setup()

	test_ls = LS:new()
	function helper(idx_exp, word_exp)
			entry= test_ls:pop()
			assert_equal(idx_exp, entry.idx)
			assert_equal(word_exp, entry.szo1)
	end
	
end

function test_oneelement()
	test_ls:addTable({[1] = { szo1 = "fork", szo2 = "villa" } } )
	
	entry = test_ls:pop()
	assert_equal(1, entry.idx)	
	assert_equal("fork", entry.szo1)
	
end
function test_popandpush()

	ls = {
		[1] = { szo1 = "fork", szo2 = "villa" },
		[2] = { szo1 = "space", szo2 = "űr" },
		[3] = { szo1 = "hot", szo2 = "forró2" }
	} 
	test_ls:addTable(ls)
	for i=1,3 do
		helper(i, ls[i].szo1)
	end
	
	-- end of --
	
	entry, idx = test_ls:pop()
	assert_nil(entry)

	test_ls:push(2)
	assert_equal(test_ls:getLearntProcent(), 33)
	test_ls:push(1)
	assert_equal(test_ls:getLearntProcent(), 67)
	test_ls:push(3)
	assert_equal(test_ls:getLearntProcent(), 100)
end
function test_loadfile()

	assert_equal(10, test_ls:loadFile('test.txt'))
	helper(1, "facepalm")
	
end