LWS = require 'nilg_lws'
FSM = require 'nilg_fsm'
LS  = require 'nilg_ls'

nilg_wxc = {} -- wxController

function nilg_wxc:new()

	o = {}
	setmetatable(o, self)
	self.__index = self
	o._guistates = {}
	o._dialog = nil
	o._lws = nil
	return o
end
function nilg_wxc:setGuiStates(states)
	self._guistates = states
end
function nilg_wxc:setDialog(dialog)
	self._dialog = dialog
end	
function nilg_wxc:setGui(gui)
	self.gui = gui
end
function nilg_wxc:setCallback(cb)
	self._callback = cb
end
function nilg_wxc:setLWS(lws)
	self._lws = lws
end
function nilg_wxc:setSkipped(bool)
	self._skipped = bool
end
function nilg_wxc:skipped()
	return self._skipped
end
function nilg_wxc:storeItem(item)
	self._item = item
end
function nilg_wxc:getItem(item)
	return self._item
end
function nilg_wxc:setCheckFunction(func)
	self._checkFunction = func
end
function nilg_wxc:checkAnswer(item)
	
	--print(self.gui.szo1:GetValue(), item.entry.szo1)
	
	if item.state == 6 then
		
		if self._checkFunction(self.gui.szo1:GetValue(), item.entry.szo1) then 
			return "yes"
		else
			return "no"
		end
	end
	if item.state == 7 then
		if self._checkFunction(self.gui.szo2:GetValue(), item.entry.szo2) then 
			return "yes"
		else
			return "no"
		end
	end
	
	
end
function nilg_wxc:displayDialog()
	self._dialog:Connect(wx.wxEVT_CLOSE_WINDOW, function (e) 
		e:Skip() 
		self._dialog:Show(false)
		self._dialog:Destroy()
	end)
	self._dialog:Connect(xmlResource.GetXRCID("YES"), wx.wxEVT_COMMAND_BUTTON_CLICKED, self._callback)
	self._dialog:Connect(xmlResource.GetXRCID("NO"), wx.wxEVT_COMMAND_BUTTON_CLICKED, self._callback)
	self._dialog:Connect(xmlResource.GetXRCID("SZO1"), wx.wxEVT_COMMAND_TEXT_ENTER, self._callback)
	self._dialog:Connect(xmlResource.GetXRCID("SZO2"), wx.wxEVT_COMMAND_TEXT_ENTER, self._callback)
	
	--self._dialog:Connect(xmlResource.GetXRCID("MAIN"), wx.wxEVT_KEY_DOWN, function(e) 
	--	print(e:GetKeyCode(e)) 
	--end )
	
	
	
	self._dialog:Centre()
	self._dialog:Show()
end
function nilg_wxc:display(item, state)

	--gs.szo1.value = gs.szo1.value or 
	if state == nil then
		
		error('[-] state must be not nil')
		
	end
	if type(state) == 'number' and state > 7 then
		error('[-] state must be less than 8')
	end
	
	gs = self._guistates[state]
	
	szo1 = gs.szo1.value or item.entry.szo1
	szo2 = gs.szo2.value or item.entry.szo2
	--gs.szo2.value = gs.szo2.value or item.entry.szo2
	
	if gs.button1 and gs.button1.label then self.gui.button1:SetLabel(gs.button1.label) end
	if gs.button2 and gs.button2.label then self.gui.button2:SetLabel(gs.button2.label) end
	
	if gs.button1 and gs.button1.show~=nil then self.gui.button1:Show(gs.button1.show) end
	if gs.button2 and gs.button2.show~=nil then self.gui.button2:Show(gs.button2.show) end
	
	if gs.button2 and gs.button2.hide~=nil then self.gui.button2:Hide() end
	
	if gs.button1 and gs.button1.enabled~=nil then self.gui.button1:Enable(gs.button1.enabled) end
	if gs.button2 and gs.button2.enabled~=nil then self.gui.button2:Enable(gs.button2.enabled) end


	
	self.gui.szo1:SetValue(szo1)
	self.gui.szo2:SetValue(szo2)
	
	if gs.szo1.enabled~=nil then self.gui.szo1:Enable(gs.szo1.enabled) end
	if gs.szo2.enabled~=nil then self.gui.szo2:Enable(gs.szo2.enabled) end
	
	if gs.szo1.focus then self.gui.szo1:SetFocus() end
	if gs.szo2.focus then self.gui.szo2:SetFocus() end
	
	
	
end
function nilg_wxc:getEvent(event)
	t = {
		[104] = "yes",
		[105] = "no"
	}
	return t[event:GetId()]
end
function nilg_wxc:call(event)
	
	if self:getEvent(event) == "no" then
		self:setSkipped(true)
	end
	
	if self.gui.button2:GetLabel() == "OK" then
		self:setSkipped(false)
	end
	
	if not self:skipped() then
		prevItem = self:getItem()
		

		-- feldolgozas --
		if prevItem then
			
			if prevItem.state >= 6 and self._check then
				
				direction = self:checkAnswer(prevItem)
				
				if direction == "no" then
					if prevItem.state == 6 then
					print("[*] Bad answer: "..prevItem.entry.szo2.. " / "..self.gui.szo1:GetValue())
					elseif prevItem.state == 7 then
					print("[*] Bad answer: "..prevItem.entry.szo1.. "/"..self.gui.szo2:GetValue())
					end
					self:setSkipped(true)
					self._check = false
					self:display(self:getItem(), "BadAnswer")
					return 
				else
					print("[*] Good answer: "..prevItem.entry.szo1.." : "..prevItem.entry.szo2)
				end
				
				self._check = true
			else
				direction = self:getEvent(event)
			end
		
		
		self._lws:stateChange(direction) 
		end
		self._check = true
 		-- kiiras --
		item = self._lws:next()	
		
		if item==nil then 
			print('Item can\'t be nil, only when there is no more element') 
			self.gui.header:SetLabel('Gratulálok! A tesztverzió véget ért.')
		end

		--print(tostring(item.state)..'~', item.entry.szo1)
		self:storeItem(item)
		
	
		self:display(item, item.state)		
		self.gui.header:SetLabel('Állapot: '..tostring(item.state)..'.'..' Méret: '..tostring(self._lws:size()))
		
	else
		self:setSkipped(false)
		self._check=false
		self:display(self:getItem(), "BadAnswer")
		
	end
		
end


function nilg_wxc:setLS(ls)
	self._ls=ls
	-- fill the lws --
	for i=1,7 do
		t=self._ls:pop()
		--print(t.szo1)
		self._lws:addEntry(t)
	end
	
end


-- init --
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
	test_lws:setSelectAlgorithm('random')
	
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

	test_fsm:addNodeTable(allapotok)
	test_fsm:addTransitionTable(allapot_atmenetek)


	--test_lws:addDictTable(le)
	test_lws:setFSM(test_fsm)
	
	test_lws:setStopValue(8)
	return test_lws
end
------------
---- init
--
	lws = setup()
	


	xmlResource = wx.wxXmlResource()
	xmlResource:InitAllHandlers()
	xmlResource:Load('nilgiri.xrc')
	
	dialog=wx.wxDialog()
	xmlResource:LoadDialog(dialog, wx.NULL, "nilgiri") 
	
	gui = {}
	
	gui["szo1"]     = dialog:FindWindow(xmlResource.GetXRCID("SZO1")):DynamicCast("wxTextCtrl")
	gui["szo2"]     = dialog:FindWindow(xmlResource.GetXRCID("SZO2")):DynamicCast("wxTextCtrl")
	gui["button1"]  = dialog:FindWindow(xmlResource.GetXRCID("YES")):DynamicCast("wxButton")
	gui["button2"]  = dialog:FindWindow(xmlResource.GetXRCID("NO")):DynamicCast("wxButton")
	gui["header"]   = dialog:FindWindow(xmlResource.GetXRCID("header")):DynamicCast("wxStaticText")
	

		gui_states = {
		[1] = {
			button1 = {
				label = "Következő"
			},
			button2 = {
				hide = true,
				show = false
			},
			szo1 = {
				enabled = false,
			},
			szo2 = {
				enabled = false
			}
		},
		[2] = {
			button1 = {
				label = "Tudom",
				show = true,
			},
			button2 = {
				show = true,
				label = "Nem tudom",
				enabled = true
			}
			,
			szo1 = {
				enabled = false,
				value = "?"
			},
			szo2 = {
				enabled = false,
			}
		},
		[3] = {
			button1 = {
				label = "Tudom",
				show = true
			},
			button2 = {
				show = true,
				label = 'Nem tudom'
			},
			szo1 = {
				enabled = false,				
			},
			szo2 = {
				enabled = false,
				value = "?"
			}
		},
		[4] = {
				
			szo1 = {
				value = "??",
				enabled = false,
			},
			szo2 = {
				enabled = false
			},
			button1 = {
				show = true,
				label = 'Tudom'
			},
			button2 = {
				show = true,
				label = 'Nem tudom'
			}

		},
		[5] = {
			szo1 = {
				enabled = false,
			},
			szo2 = {
				enabled = false,
				value = "??"
			},
			button1 = {
				show = true,
				label = 'Tudom'
			},
			button2 = {
				show = true,
				label = 'Nem tudom'
			}
						
		},
		[6] = {
			szo1 = {
				enabled = true,
				check = true,
				value = '',
				focus = true
			},	
			szo2 = {
				enabled = false
			},
			button1 = {
				show = true,
				label = 'Tudom'
			},
			button2 = {
				show = true,
				label = 'Nem tudom'
			}
			
		},
		[7] = {
			szo1 = {
				enabled = false
			},
			szo2 = {
				enabled = true,
				check = true,
				value = '',
				focus = true
				
			},
			button1 = {
				show = true,
				label = 'Tudom'
			},
			button2 = {
				show = true,
				label = 'Nem tudom'
			}
			
		},
		["BadAnswer"] = {
			szo1 = {
				enabled = false
			},
			szo2 = {
				enabled = false
			},
			button2 = {
				label = 'OK',
				show = true
			},
			button1 = {
				show = false
			}
		}

	}






	
	
	ls = LS:new()
	ls:loadFile('test.txt')
	
	lws:addEntryOnRemoveEventFromLS(ls)
	
	test_wxc = nilg_wxc:new()
	test_wxc:setLWS(lws)
	test_wxc:setLS(ls)
	
	test_wxc:setCheckFunction(function(given, expected)
		
		if (given:lower() == expected:lower()) then
			return true
		else
			return false
		end
	
	end)
	test_wxc:setGuiStates(gui_states)
	test_wxc:setGui(gui)
	
	test_wxc:setDialog(dialog)

	
-- ez itt úgy ronda, ahogy van
-- de kell ahhoz, hogy a callback 
-- függvényben látható legyen a test_wxc!

function callback(event)
	
	print(event:GetEventType())
	test_wxc:call(event)
end	


	test_wxc:setCallback(callback)
	test_wxc:displayDialog()
