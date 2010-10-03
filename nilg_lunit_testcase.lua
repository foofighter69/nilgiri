require 'lunit'
FSM = require 'nilg_fsm'

module('nilg_lunit_testcase', lunit.testcase, package.seeall)

local test_fsm

function setup()
		
		
	test_fsm = FSM:new()

	allapot_atmenetek = {
		[1] = { -- start
			yes  = 2,
			no   = 2
		},
		[2] = { -- bemutatva
			yes  = 3,
			no   = 3
		},
		[3] = { -- els? szó megkérdezve beírás nélkül
			yes  = 4,
			no   = 1
		},
		[4] = { -- második szó megkérdezve beírás nélkül
			yes  = 5,
			no   = 1
		},
		[5] = { -- els? szó megkérdezve beírás nélkül
			yes  = 6,
			no   = 1
		},
		[6] = { -- második szó megkérdezve beírás nélkül
			yes  = 7,
			no   = 1
		},
		[7] = { -- els? szó megkérdezve (éles)
			yes  = 8,
			no   = 1
		},
		[8] = { -- második szó megkérdezve (éles)
			yes  = 9, --> nirvana :D
			no   = 1
		}

	}
	allapotok = {

		[1] = "start",
		[2] = "bemutatva",
		[3] = "elso szo egyszer megkerdezve",
		[4] = "masodik szo egyszer megkerdezve",
		[5] = "elso szo megegyszer megkerdezve",
		[6] = "masodik szo megegyszer megkerdezve",
		[7] = "[eles] elso szo megkerdezve",
		[8] = "[eles] masodik szo megkerdezve",
		[9] = "stop"
	}

	test_fsm:addNodeTable(allapotok)
	test_fsm:addTransitionTable(allapot_atmenetek)
end

function test_nilg_fsm_normal()

	assert_equal(test_fsm:getNextState(3, "yes"),4)
	assert_equal(test_fsm:getNextState(5, "yes"),6)
	assert_equal(test_fsm:getNextState(3, "yes"),4)
	
end
function test_nilg_fsm_notransitions_for_node()

	assert_nil(test_fsm:getNextState(9,"yes"))
end
function test_nilg_fsm_state_with_nonexistent_transition()
	
	assert_nil(test_fsm:getNextState(8,"sabadaba"))
end
-- check error msgs --
function test_nilg_fsm_error_nonexistentnode()
	_, msg = test_fsm:getNextState(17,"yepp")
	assert_equal(msg, "not existent node")
end
function test_nilg_fsm_error_notransitionfornode()
	_, msg = test_fsm:getNextState(9, "no")
	assert_equal(msg, "no transitions for node")
end
function test_nilg_fsm_error_nonexistentevent()
	_, msg = test_fsm:getNextState(6, "cancel")
	assert_equal(msg, "not existent event")
end