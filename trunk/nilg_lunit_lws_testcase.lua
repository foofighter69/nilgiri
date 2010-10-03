require 'lunit'
LWS = require 'nilg_lws'
FSM = require 'nilg_fsm'

module('nilg_lunit_lws_testcase', lunit.testcase, package.seeall)

function setup()
	le = {}
	table.insert(le, { szo1 = "He saw us all out.", szo2 = "Mindnyájunkat kikísért a kapuig." })
	table.insert(le, { szo1 = "They rushed at enemy.", szo2 = "Rátámadtak az ellenségre." })
	table.insert(le, { szo1 = "He scraped away at the skin until it was clean.", szo2 = "Addig dörzsölte a bőrét, amíg tiszta lett." })
	table.insert(le, { szo1 = "I'll see you in.", szo2 = "Bekísérlek." })
	table.insert(le, { szo1 = "He smiles away his troubles.", szo2 = "Mosollyal űzi el a gondjait." })
	table.insert(le, { szo1 = "I swear to being innocent.", szo2 = "Esküszöm, ártatlan vagyok." })
	table.insert(le, { szo1 = "He can talk away for hours.", szo2 = "Órákig el tud fecsegni." })
	
	test_lws = LWS:new()
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
		[3] = { -- elso szó megkérdezve beírás nélkül
			yes  = 4,
			no   = 1
		},
		[4] = { -- második szó megkérdezve beírás nélkül
			yes  = 5,
			no   = 1
		},
		[5] = { -- elso szó megkérdezve beírás nélkül
			yes  = 6,
			no   = 1
		},
		[6] = { -- második szó megkérdezve beírás nélkül
			yes  = 7,
			no   = 1
		},
		[7] = { -- elso szó megkérdezve (éles)
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


	test_lws:addDictTable(le)
	test_lws:setFSM(test_fsm)
	
	test_lws:setStopValue(4)
end
function helper_test_normalworkflow(szo1_expected, state_expected)
	
	item = test_lws:next()
	assert_equal(szo1_expected, item.entry.szo1)
	assert_equal(state_expected, item.state)
	
end

function test_normalworkflow()

	
	for i=1, 7 do
		helper_test_normalworkflow(le[i].szo1 , 1)
		test_lws:stateChange("yes")
	end	
	
	-- osszes szo bemutatva --
	
	for i=1, 5 do
		helper_test_normalworkflow(le[i].szo1 , 2)
		test_lws:stateChange("yes")
	end	
	for i=6,7 do
		helper_test_normalworkflow(le[i].szo1 , 2)
		test_lws:stateChange("no")
	end
	
	-- osszes szo egyszer megkerdezve
	for i=1,4 do
		helper_test_normalworkflow(le[i].szo1 , 3)
		test_lws:stateChange("yes")
	end
	for i=5,7 do
		helper_test_normalworkflow(le[i].szo1 , 3)
		test_lws:stateChange("no")
	end
	-- ha ideértünk, akkor az első négy kiesik a buliból, tehát --
	for i=5,7 do
		helper_test_normalworkflow(le[i].szo1 , 1)
		test_lws:stateChange("yes")
	end
	

	
	
	
end