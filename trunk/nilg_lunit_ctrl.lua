require 'lunit'

local CTRL = require 'nilg_ctrl'


module('nilg_lunit_ctrl', lunit.testcase, package.seeall)

function hpt (tt, indent, done)
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
        hpt (value, indent + 7, done)
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


function setup()
	

	
	
	tst_lws = LWS:new()
	tst_fsm = FSM:new()	
	tst_ls = LS:new()
	tst_ls:loadFile('test.txt')

	


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
			no   = 2
		},
		[4] = { -- második szó megkérdezve beírás nélkül
			yes  = 5,
			no   = 2
		},
		[5] = { -- elso szó megkérdezve beírás nélkül
			yes  = 6,
			no   = 2
		},
		[6] = { -- második szó megkérdezve beírás nélkül
			yes  = 7,
			no   = 2
		},
		[7] = { -- elso szó megkérdezve (éles)
			yes  = 8,
			no   = 2
		},
		[8] = { -- második szó megkérdezve (éles)
			yes  = 9, --> nirvana :D
			no   = 2
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

	tst_fsm:addNodeTable(allapotok)
	tst_fsm:addTransitionTable(allapot_atmenetek)

	tst_lws:setFSM(tst_fsm)	
	tst_lws:setStopValue(8)
	
	tst_ctrl = CTRL:new()	
	tst_ctrl:setLWS(tst_lws)
	tst_ctrl:setLS(tst_ls)
	
	tst_ctrl:init()

end
function test_constructor()
	
	assert_not_nil(tst_ctrl)
	assert_not_nil(tst_lws)
	assert_not_nil(tst_fsm)
	
end
function test_next()
	function randomevent()
		if math.random(1,100) > 50 then
			return "yes"
		else
			return "no"
		end
		
	end
	
	--print(tst_ctrl._lws._fsm)
	
	
	
	while true do
		tst_ctrl:statechange(randomevent())
		prev_item = item
		item = tst_ctrl:next()
		
		print("---------")
		if item==nil then break end
		--if item==prev_item then break end
		hpt(item)
		
	end
	


end