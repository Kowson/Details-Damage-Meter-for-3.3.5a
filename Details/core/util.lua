--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _table_insert = table.insert --lua local
	local _upper = string.upper --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _math_floor = math.floor --lua local
	local _math_max = math.max --lua local
	local _math_abs = math.abs --lua local
	local _math_random = math.random --lua local
	local _type = type --lua local
	local _string_match = string.match --lua local
	local _string_byte = string.byte --lua local
	local _string_len = string.lenv
	local _string_format = string.format --lua local
	local loadstring = loadstring --lua local
	local _select = select
	local _tonumber = tonumber
	local _strsplit = strsplit
	
	local _UnitClass = UnitClass --wow api local
	local _IsInRaid = IsInRaid --wow api local TODO: REMOVE ALL OCCURENCES of IsInRaid
	local _IsInGroup = IsInGroup --wow api local
	local _GetNumGroupMembers = GetNumGroupMembers --wow api local
	local _UnitAffectingCombat = UnitAffectingCombat --wow api local
	local _GameTooltip = GameTooltip --wow api local
	local _UIFrameFadeIn = UIFrameFadeIn --wow api local
	local _UIFrameFadeOut = UIFrameFadeOut --wow api local
	local _InCombatLockdown = InCombatLockdown --wow api local

	local gump = _details.gump --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> get the npc id from guid
	function _details:GetNpcIdFromGuid(guid)
		if (guid) then
			return _tonumber(guid:sub(9, 12), 16)
		end
		return 0
	end


	--> get the fractional number representing the alphabetical letter
	function _details:GetOrderNumber(src_name)
		--local name = _upper(src_name .. "zz")
		--local byte1 = _math_abs(_string_byte(name, 2)-91)/1000000
		--return byte1 + _math_abs(_string_byte(name, 1)-91)/10000
		return _math_random(1000, 9000) / 1000000
	end
	
	--/script print(tonumber(4/1000000)) - 4e-006
	--0.000004
	--> set all table keys to lower
	local temptable = {}
	function _details:LowerizeKeys(_table)
		for key, value in _pairs(_table) do
			temptable[string.lower(key)] = value
		end
		temptable, _table = table.wipe(_table), temptable
		return _table
	end

	--> short numbers
	function _details:ToK(number)
		if (number > 1000000) then
			return _string_format("%.2f", number/1000000) .."M"
		elseif (number > 1000) then
			return _string_format("%.1f", number/1000) .."K"
		end
		return _string_format("%.1f", number)
	end
	function _details:ToK2(number)
		if (number > 999999) then
			return _string_format("%.2f", number/1000000) .. "M"
		elseif (number > 99999) then
			return _math_floor(number/1000) .. "K"
		elseif (number > 999) then
			return _string_format("%.1f",(number/1000)) .. "K"
		end
		return _string_format("%.1f", number)
	end
	--> short numbers no numbers after comma
	function _details:ToK0(number)
		if (number > 1000000) then
			return _string_format("%.0f", number/1000000) .."M"
		elseif (number > 1000) then
			return _string_format("%.0f", number/1000) .."K"
		end
		return _string_format("%.0f", number)
	end
	
	function _details:ToKMin(number)
		if (number > 1000000) then
			return _string_format("%.2f", number/1000000) .."m"
		elseif (number > 1000) then
			return _string_format("%.1f", number/1000) .."k"
		end
		return _string_format("%.1f", number)
	end
	function _details:ToK2Min(number)
		if (number > 999999) then
			return _string_format("%.2f", number/1000000) .. "m"
		elseif (number > 99999) then
			return _math_floor(number/1000) .. "k"
		elseif (number > 999) then
			return _string_format("%.1f",(number/1000)) .. "k"
		end
		return _string_format("%.1f", number)
	end
	--> short numbers no numbers after comma
	function _details:ToK0Min(number)
		if (number > 1000000) then
			return _string_format("%.0f", number/1000000) .."m"
		elseif (number > 1000) then
			return _string_format("%.0f", number/1000) .."k"
		end
		return _string_format("%.0f", number)
	end
	--> short numbers no numbers after comma
	function _details:ToKReport(number)
		if (number > 1000000) then
			return _string_format("%.2f", number/1000000) .."M"
		elseif (number > 1000) then
			return _string_format("%.1f", number/1000) .."K"
		end
		return number
	end
	--> no changes
	function _details:NoToK(number)
		return _math_floor(number)
	end
	-- thanks http://richard.warburton.it
	function _details:comma_value(n)
		n = _math_floor(n)
		local left,num,right = _string_match(n,'^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	end
	
	_details.ToKFunctions = {_details.NoToK, _details.ToK, _details.ToK2, _details.ToK0, _details.ToKMin, _details.ToK2Min, _details.ToK0Min, _details.comma_value}

	--> replacing data
	local args
	local replace_arg = function(i)
		return args[tonumber(i)]
	end
	local run_function = function(str)
		local r = loadstring(str)(args[4])
		return r or 0
	end
	function string:ReplaceData(...)
		args = {...}
		return(self:gsub("{data(%d+)}", replace_arg):gsub("{func(.-)}", run_function)) 
	end

	--local usertext = "i got the time: {data2}, {data3}% of {data1} minutes"
	--local expanded = usertext:expand(50000, 1000, 20)
	
	--> remove a index from a hash table
	function _details:tableRemove(table, indexName)
		local newtable = {}
		for hash, value in _pairs(table) do 
			if (hash ~= indexName) then
				newtable[hash] = value
			end
		end
		return newtable
	end

	--> return if the numeric table have an object
	function _details:tableIN(table, objeto)
		for index, valor in _ipairs(table) do
			if (valor == objeto) then
				return index
			end
		end
		return false
	end
	
	_details.table = {}
	
	function _details.table.copy(t1, t2)
		local table_deepcopy = table_deepcopy
		for key, value in pairs(t2) do 
			if (type(value) == "table") then
				t1[key] = table_deepcopy(value)
			else
				t1[key] = value
			end
		end
	end
	
	function _details.table.deploy(t1, t2)
		for key, value in pairs(t2) do 
			if (type(value) == "table") then
				t1[key] = t1[key] or {}
				_details.table.deploy(t1[key], t2[key])
			else
				t1[key] = value
			end
		end
	end
	
	function _details:hex(num)
		local hexstr = '0123456789abcdef'
		local s = ''
		while num > 0 do
			local mod = math.fmod(num, 16)
			s = string.sub(hexstr, mod+1, mod+1) .. s
			num = math.floor(num / 16)
		end
		if s == '' then s = '00' end
		if (string.len(s) == 1) then
			s = "0"..s
		end
		return s
	end

	--> unpack more than 1 table
	-- http://www.dzone.com/snippets/lua-unpack-multiple-tables
	function _details:unpacks(...)
		local values = {}
		for i = 1, select('#', ...) do
			for _, value in _ipairs(select(i, ...)) do
				values[ #values + 1] = value
			end
		end
		return unpack(values)
	end

	--> trim http://lua-users.org/wiki/StringTrim
	function _details:trim(s)
		local from = s:match"^%s*()"
		return from > #s and "" or s:match(".*%S", from)
	end
	
	--> reverse numerical table
	function _details:reverse_table(t)
		local new = {}
		local index = 1
		for i = #t, 1, -1 do
			new[index] = t[i]
			index = index + 1
		end
		return new
	end

-- lua base64 codec(c) 2006-2008 by Alex Kloss - http://www.it-rfc.de - licensed under the terms of the LGPL2 - http://lua-users.org/wiki/BaseSixtyFour
do
	_details._encode = {}
	
	-- shift left
	local function lsh(value,shift)
		return(value*(2^shift)) % 256
	end

	-- shift right
	local function rsh(value,shift)
		return math.floor(value/2^shift) % 256
	end

	-- return single bit(for OR)
	local function bit(x,b)
		return(x % 2^b - x % 2^(b-1) > 0)
	end

	-- logic OR for number values
	local function lor(x,y)
		result = 0
		for p=1,8 do result = result +(((bit(x,p) or bit(y,p)) == true) and 2^(p-1) or 0) end
		return result
	end

	-- encryption table
	local base64chars = {[0]='A',[1]='B',[2]='C',[3]='D',[4]='E',[5]='F',[6]='G',[7]='H',[8]='I',[9]='J',[10]='K',[11]='L',[12]='M',[13]='N',[14]='O',[15]='P',[16]='Q',[17]='R',[18]='S',[19]='T',[20]='U',[21]='V',[22]='W',[23]='X',[24]='Y',[25]='Z',[26]='a',[27]='b',[28]='c',[29]='d',[30]='e',[31]='f',[32]='g',[33]='h',[34]='i',[35]='j',[36]='k',[37]='l',[38]='m',[39]='n',[40]='o',[41]='p',[42]='q',[43]='r',[44]='s',[45]='t',[46]='u',[47]='v',[48]='w',[49]='x',[50]='y',[51]='z',[52]='0',[53]='1',[54]='2',[55]='3',[56]='4',[57]='5',[58]='6',[59]='7',[60]='8',[61]='9',[62]='-',[63]='_'}

	-- function encode
	-- encodes input string to base64.
	function _details._encode:enc(data)
		local bytes = {}
		local result = ""
		for spos=0,string.len(data)-1,3 do
			for byte=1,3 do bytes[byte] = string.byte(string.sub(data,(spos+byte))) or 0 end
			result = string.format('%s%s%s%s%s',result,base64chars[rsh(bytes[1],2)],base64chars[lor(lsh((bytes[1] % 4),4), rsh(bytes[2],4))] or "=",((#data-spos) > 1) and base64chars[lor(lsh(bytes[2] % 16,2), rsh(bytes[3],6))] or "=",((#data-spos) > 2) and base64chars[(bytes[3] % 64)] or "=")
		end
		return result
	end

	-- decryption table
	local base64bytes = {['A']=0,['B']=1,['C']=2,['D']=3,['E']=4,['F']=5,['G']=6,['H']=7,['I']=8,['J']=9,['K']=10,['L']=11,['M']=12,['N']=13,['O']=14,['P']=15,['Q']=16,['R']=17,['S']=18,['T']=19,['U']=20,['V']=21,['W']=22,['X']=23,['Y']=24,['Z']=25,['a']=26,['b']=27,['c']=28,['d']=29,['e']=30,['f']=31,['g']=32,['h']=33,['i']=34,['j']=35,['k']=36,['l']=37,['m']=38,['n']=39,['o']=40,['p']=41,['q']=42,['r']=43,['s']=44,['t']=45,['u']=46,['v']=47,['w']=48,['x']=49,['y']=50,['z']=51,['0']=52,['1']=53,['2']=54,['3']=55,['4']=56,['5']=57,['6']=58,['7']=59,['8']=60,['9']=61,['-']=62,['_']=63,['=']=nil}

	-- function decode
	-- decode base64 input to string
	function _details._encode:Decode(data)
		local chars = {}
		local result=""
		for dpos=0,string.len(data)-1,4 do
			for char=1,4 do chars[char] = base64bytes[(string.sub(data,(dpos+char),(dpos+char)) or "=")] end
			result = string.format('%s%s%s%s',result,string.char(lor(lsh(chars[1],2), rsh(chars[2],4))),(chars[3] ~= nil) and string.char(lor(lsh(chars[2],4), rsh(chars[3],2))) or "",(chars[4] ~= nil) and string.char(lor(lsh(chars[3],6) % 192,(chars[4]))) or "")
		end
		return result
	end

	function _details._encode:Encode(s)
		return _details._encode:enc(s)
	end
end

	--> scale
	function _details:Scale(rangeMin, rangeMax, scaleMin, scaleMax, x)
		return 1 +(x - rangeMin) *(scaleMax - scaleMin) /(rangeMax - rangeMin)
	end

	--> font color
	function _details:SetFontColor(fontString, r, g, b, a)
		r, g, b, a = gump:ParseColors(r, g, b, a)
		fontString:SetTextColor(r, g, b, a)
	end
	
	--> font size
	function _details:SetFontSize(fontString, ...)
		local source, _, flags = fontString:GetFont()
		fontString:SetFont(source, _math_max(...), flags)
	end
	function _details:GetFontSize(fontString)
		local _, size = fontString:GetFont()
		return size
	end

	--> font face
	function _details:SetFontFace(fontString, fontface)
		local _, size, flags = fontString:GetFont()
		fontString:SetFont(fontface, size, flags)
	end
	function _details:GetFontFace(fontString)
		local fontface = fontString:GetFont()
		return fontface
	end	
	
	--> font outline
	function _details:SetFontOutline(fontString, outline)
		local source, size = fontString:GetFont()
		if (outline) then
			if (_type(outline) == "boolean" and outline) then
				outline = "OUTLINE"
			elseif (outline == 1) then
				outline = "OUTLINE"
			elseif (outline == 2) then
				outline = "THICKOUTLINE"
			end
		end

		fontString:SetFont(source, size, outline)
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

	local LastDamage = 0
	local LastDamageRecord = 0

	--> record raid/party/player damage every second
	function _details:LogDps()

		LastDamageRecord = LastDamageRecord + 1

		if (LastDamageRecord > 1) then
			LastDamageRecord = 0
			
			local NowDamage =(_details.table_current.totals_group[1] - LastDamage) /2
			
			_table_insert(_details.table_current.DpsGraphic, NowDamage)
			if (NowDamage > _details.table_current.DpsGraphic.max) then 
				_details.table_current.DpsGraphic.max = NowDamage
			end
			
			LastDamage = _details.table_current.totals_group[1]
		end
	end

	--> is in combat yet?
	function _details:EstaEmCombate()

		_details:TimeDataTick()
		_details:BrokerTick()

		if (_details.zone_type == "pvp" or _details.zone_type == "arena" or _InCombatLockdown()) then
			return true
		elseif (_UnitAffectingCombat("player")) then
			return true
		elseif (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers(), 1 do
				if (_UnitAffectingCombat("raid"..i)) then
					return true
				end
			end
		elseif (GetNumPartyMembers() > 0) then
			for i = 1, GetNumPartyMembers(), 1 do
				if (_UnitAffectingCombat("party"..i)) then
					return true
				end
			end
		end

		_details:EndCombat()
	end
	
	function _details:FindGUIDFromName(name)
		if (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers(), 1 do
				local this_name, _ = UnitName("raid"..i)
				if (this_name == name) then
					return UnitGUID("raid"..i)
				end
			end
		elseif (GetNumPartyMembers() > 0) then
			for i = 1, GetNumPartyMembers(), 1 do
				local this_name, _ = UnitName("party"..i)
				if (this_name == name) then
					return UnitGUID("party"..i)
				end
			end
		end
		if (UnitName("player") == name) then
			return UnitGUID("player")
		end
		return nil
	end

	local function frame_task(self, elapsed)

		self.FrameTime = self.FrameTime + elapsed

		if (self.HaveGradientEffect) then
			
			local done = false
			
			for index, ThisGradient in _ipairs(self.gradientes) do
			
				if (self.FrameTime >= ThisGradient.NextStepAt and not ThisGradient.done) then
				
					--> effects
					if (ThisGradient.ObjectType == "frame") then
						local r, g, b, a = ThisGradient.Object:GetBackdropColor()
						ThisGradient.Object:SetBackdropColor(r + ThisGradient.Colors.Red, g + ThisGradient.Colors.Green, b + ThisGradient.Colors.Blue, a + ThisGradient.Colors.Alpha)
					elseif (ThisGradient.ObjectType == "texture") then
						local r, g, b, a = ThisGradient.Object:GetVertexColor()
						ThisGradient.Object:SetVertexColor(r + ThisGradient.Colors.Red, g + ThisGradient.Colors.Green, b + ThisGradient.Colors.Blue, a + ThisGradient.Colors.Alpha)
					end
					
					ThisGradient.OnStep = ThisGradient.OnStep + 1
					if (ThisGradient.FinishStep == ThisGradient.OnStep) then
						if (ThisGradient.Func) then
							if (type(ThisGradient.Func) == "string") then
								local f = loadstring(ThisGradient.Func)
								f()
							else
								ThisGradient.Func()
							end
						end
						ThisGradient.done = true
						done = true
					else
						ThisGradient.NextStepAt = self.FrameTime + ThisGradient.SleepTime
					end
				end
			end
			
			if (done) then
				local _iter = {index = 1, data = self.gradientes[1]}
				while(_iter.data) do 
					if (_iter.data.done) then
						_iter.data.Object.HaveGradientEffect = false
						table.remove(self.gradientes, _iter.index)
						_iter.data = self.gradientes[_iter.index]
					else
						_iter.index = _iter.index + 1
						_iter.data = self.gradientes[_iter.index]
					end
				end
				
				if (#self.gradientes < 1) then
					self.HaveGradientEffect = false
				end
			end
		end
		
		if (not self.HaveGradientEffect) then
			self:SetScript("OnUpdate", nil)
		end
		
	end

	--[[ test grayscale ]]
	function _details:test_grayscale()
		local instance = _details.table_instances[1]
		for i = 1, instance.rows_created, 1 do
			local bar = instance.bars[i]
			local red, green, blue, alpha = bar.texture:GetVertexColor()
			local grayscale =(red*0.03+green+blue) / 3 --> grayscale lightness method
			gump:GradientEffect( bar.texture, "texture", red, green, blue, alpha, grayscale, grayscale, grayscale, alpha, 1)
		end
	end

	function gump:GradientEffect( Object, ObjectType, StartRed, StartGreen, StartBlue, StartAlpha, EndRed, EndGreen, EndBlue, EndAlpha, Duration, EndFunction, FuncParam)
		
		if (type(StartRed) == "table" and type(StartGreen) == "table") then
			Duration, EndFunction = StartBlue, StartAlpha
			EndRed, EndGreen, EndBlue, EndAlpha = unpack(StartGreen)
			StartRed, StartGreen, StartBlue, StartAlpha = unpack(StartRed)
			
		elseif (type(StartRed) == "table") then
			EndRed, EndGreen, EndBlue, EndAlpha, Duration, EndFunction = StartGreen, StartBlue, StartAlpha, EndRed, EndGreen, EndBlue
			StartRed, StartGreen, StartBlue, StartAlpha = unpack(StartRed)
			
		elseif (type(EndRed) == "table") then
			Duration, EndFunction = EndGreen, EndBlue
			EndRed, EndGreen, EndBlue, EndAlpha = unpack(EndRed)
		end
		
		if (not EndAlpha) then
			EndAlpha = 1.0
		end
		if (not StartAlpha) then
			StartAlpha = 1.0
		end
		
		if (EndRed > 1.0) then
			EndRed = 1.0
		end
		if (EndGreen > 1.0) then
			EndGreen = 1.0
		end
		if (EndBlue > 1.0) then
			EndBlue = 1.0
		end	
		
		local GradientFrameControl = _details.listener
		GradientFrameControl.gradientes = GradientFrameControl.gradientes or {}
		
		for index = 1, #GradientFrameControl.gradientes do
			if (GradientFrameControl.gradientes[index].Object == Object) then
				GradientFrameControl.gradientes[index].done = true
			end
		end

		local MinFramesPerSecond = 10 --> at least 10 frames will be necessary
		local ExecTime = Duration * 1000 --> value in miliseconds
		local SleepTime = 100 --> 100 miliseconds
		
		local FrameAmount = _math_floor(ExecTime/100) --> amount of frames
		
		if (FrameAmount < MinFramesPerSecond) then
			FrameAmount = MinFramesPerSecond
			SleepTime = ExecTime/FrameAmount
		end
		
		local ColorStep = {}
		ColorStep.Red =(EndRed - StartRed) / FrameAmount
		ColorStep.Green =(EndGreen - StartGreen) / FrameAmount
		ColorStep.Blue =(EndBlue - StartBlue) / FrameAmount
		ColorStep.Alpha =(EndAlpha - StartAlpha) / FrameAmount

		GradientFrameControl.gradientes[#GradientFrameControl.gradientes+1] = {
			OnStep = 1,
			FinishStep = FrameAmount,
			SleepTime = SleepTime/1000,
			NextStepAt = GradientFrameControl.FrameTime +(SleepTime/1000),
			Object = Object,
			ObjectType = string.lower(ObjectType),
			Colors = ColorStep,
			Func = EndFunction,
			FuncParam = FuncParam}
		
		Object.HaveGradientEffect = true
		GradientFrameControl.HaveGradientEffect = true
		
		if (not GradientFrameControl:GetScript("OnUpdate")) then
			GradientFrameControl:SetScript("OnUpdate", frame_task)
		end

	end
	
	--> work around to solve the UI Frame Flashes
	local onFinish = function(self)
		if (self.showWhenDone) then
			self.frame:SetAlpha(1)
		else
			self.frame:SetAlpha(0)
			self.frame:Hide()
		end
		
		if (self.onFinishFunc) then
			self:onFinishFunc(self.frame)
		end
	end
	
	local stop = function(self)
		local FlashAnimation = self.FlashAnimation
		FlashAnimation:Stop()
	end

	local flash = function(self, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, loopType)
		
		local FlashAnimation = self.FlashAnimation
		
		local fadeIn = FlashAnimation.fadeIn
		local fadeOut = FlashAnimation.fadeOut
		
		fadeIn:Stop()
		fadeOut:Stop()
	
		fadeIn:SetDuration(fadeInTime or 1)
		fadeIn:SetEndDelay(flashInHoldTime or 0)
		
		fadeOut:SetDuration(fadeOutTime or 1)
		fadeOut:SetEndDelay(flashOutHoldTime or 0)

		FlashAnimation.duration = flashDuration
		FlashAnimation.loopTime = FlashAnimation:GetDuration()
		FlashAnimation.finishAt = GetTime() + flashDuration
		FlashAnimation.showWhenDone = showWhenDone
		
		FlashAnimation:SetLooping(loopType or "REPEAT")
		
		self:Show()
		self:SetAlpha(0)
		FlashAnimation:Play()
	end
	
	function gump:CreateFlashAnimation(frame, onFinishFunc, onLoopFunc)
	
		local FlashAnimation = frame:CreateAnimationGroup() 
		
		FlashAnimation.fadeOut = FlashAnimation:CreateAnimation("Alpha") --> fade out anime
		FlashAnimation.fadeOut:SetOrder(1)
		FlashAnimation.fadeOut:SetChange(1)
		
		FlashAnimation.fadeIn = FlashAnimation:CreateAnimation("Alpha") --> fade in anime
		FlashAnimation.fadeIn:SetOrder(2)
		FlashAnimation.fadeIn:SetChange(-1)
		
		frame.FlashAnimation = FlashAnimation
		FlashAnimation.frame = frame
		FlashAnimation.onFinishFunc = onFinishFunc
		
		FlashAnimation:SetScript("OnLoop", onLoopFunc)
		FlashAnimation:SetScript("OnFinished", onFinish)
		
		frame.Flash = flash
		frame.Stop = stop
	
	end

	--> todo: remove the function creation everytime this function run.
	function gump:Fade(frame, type, velocidade, parametros)
		
		--if (frame.GetObjectType and frame:GetObjectType() == "Frame" and frame.GetName and type(frame:GetName()) == "string" and frame:GetName():find("DetailsBaseFrame")) then
		--	print(debugstack())
		--end
		
		if (_type(frame) == "table") then 
			if (frame.mine_id) then --> ups, � uma inst�ncia
				if (parametros == "bars") then --> hida todas as bars da inst�ncia
					if (velocidade) then
						for i = 1, frame.rows_created, 1 do
							gump:Fade(frame.bars[i], type, velocidade)
						end
						return
					else
						velocidade = velocidade or 0.3
						for i = 1, frame.rows_created, 1 do
							gump:Fade(frame.bars[i], type, 0.3+(i/10))
						end
						return
					end
				elseif (parametros == "hide_bars") then --> hida todas as bars da inst�ncia
					for i = 1, frame.rows_created, 1 do
						local this_bar = frame.bars[i]
						if (this_bar.fading_in or this_bar.fading_out) then
							this_bar.fadeInfo.finishedFunc = nil
							_UIFrameFadeIn(this_bar, 0.01, this_bar:GetAlpha(), this_bar:GetAlpha())
						end
						this_bar.hidden = true
						this_bar.faded = true
						this_bar.fading_in = false
						this_bar.fading_out = false
						this_bar:Hide()
						this_bar:SetAlpha(0)
					end
					return
				end
			elseif (frame.dframework) then
				frame = frame.widget
			end
		end
		
		velocidade = velocidade or 0.3
		
		--> esse ALL aqui pode dar merda com as inst�ncias n�o activedas
		if (frame == "all") then --> todas as inst�ncias
			for _, instance in _ipairs(_details.table_instances) do
				if (parametros == "bars") then --> hida todas as bars da inst�ncia
					for i = 1, instance.rows_created, 1 do
						gump:Fade(instance.bars[i], type, velocidade+(i/10))
					end
				end
			end
		
		elseif (_upper(type) == "IN") then

			if (frame:GetAlpha() == 0 and frame.hidden and not frame.fading_out) then --> ja this escondida
				return
			elseif (frame.fading_in) then --> ja this com uma anima��o, se for true
				return
			end
			
			if (frame.fading_out) then --> se tiver uma anima��o de aparecer em andamento se for true
				frame.fading_out = false
			end

			_UIFrameFadeIn(frame, velocidade, frame:GetAlpha(), 0)
			frame.fading_in = true
			frame.fadeInfo.finishedFunc = 
			function()
				frame.hidden = true
				frame.faded = true
				frame.fading_in = false
				frame:Hide()
			end
			
		elseif (_upper(type) == "OUT") then --> aparecer
			if (frame:GetAlpha() == 1 and not frame.hidden and not frame.fading_in) then --> ja this na tela
				return
			elseif (frame.fading_out) then --> j� ta com fading out
				return
			end
			
			if (frame.fading_in) then --> se tiver uma anima��o de hidar em andamento se for true
				frame.fading_in = false
			end
			
			frame:Show()
			_UIFrameFadeOut(frame, velocidade, frame:GetAlpha(), 1.0)
			frame.fading_out = true
			frame.fadeInfo.finishedFunc = 
				function() 
					frame.hidden = false
					frame.faded = false
					frame.fading_out = false
				end
				
		elseif (type == 0) then --> for�a o frame a ser mostrado
			frame.hidden = false
			frame.faded = false
			frame.fading_out = false
			frame.fading_in = false
			frame:Show()
			frame:SetAlpha(1)
			if (frame.fadeInfo) then --> limpa a fun��o de fade se tiver alguma
				frame.fadeInfo.finishedFunc = nil
			end
			
		elseif (type == 1) then --> for�a o frame a ser hidado

			frame.hidden = true
			frame.faded = true
			frame.fading_out = false
			frame.fading_in = false
			frame:Hide()
			frame:SetAlpha(0)
			if (frame.fadeInfo) then --> limpa a fun��o de fade se tiver alguma
				frame.fadeInfo.finishedFunc = nil
			end
			
		elseif (type == -1) then --> apenas da fade sem hidar
			if (frame:GetAlpha() == 0 and frame.hidden and not frame.fading_out) then --> ja this escondida
				return
			elseif (frame.fading_in) then --> ja this com uma anima��o, se for true
				return
			end
			
			if (frame.fading_out) then --> se tiver uma anima��o de aparecer em andamento se for true
				frame.fading_out = false
			end

			_UIFrameFadeIn(frame, velocidade, frame:GetAlpha(), 0)
			frame.fading_in = true
			frame.fadeInfo.finishedFunc = 
			function()
				frame.hidden = false
				frame.faded = true
				frame.fading_in = false
			end
			
		elseif (_upper(type) == "ALPHAANIM") then

			local value = velocidade
			local currentApha = frame:GetAlpha()
			frame:Show()
			
			if (currentApha < value) then
				if (frame.fading_in) then --> se tiver uma anima��o de hidar em andamento se for true
					frame.fading_in = false
					frame.fadeInfo.finishedFunc = nil
				end
				UIFrameFadeOut(frame, 0.3, currentApha, value)
				frame.fading_out = true
				frame.fadeInfo.finishedFunc = 
				function()
					frame.fading_out = false
				end
			else
				if (frame.fading_out) then --> se tiver uma anima��o de hidar em andamento se for true
					frame.fading_out = false
					frame.fadeInfo.finishedFunc = nil
				end
				UIFrameFadeIn(frame, 0.3, currentApha, value)
				frame.fading_in = true
				frame.fadeInfo.finishedFunc = 
				function()
					frame.fading_in = false
				end
			end

		elseif (_upper(type) == "ALPHA") then --> setando um alpha determinado
			if (frame.fading_in or frame.fading_out) then
				frame.fadeInfo.finishedFunc = nil
				_UIFrameFadeIn(frame, velocidade, frame:GetAlpha(), frame:GetAlpha())
			end
			frame.hidden = false
			frame.faded = false
			frame.fading_in = false
			frame.fading_out = false
			frame:Show()
			frame:SetAlpha(velocidade)
		end
	end

	function _details:name_space(bar)
		--if (bar.icon_secundario_active) then
		--	local tamanho = bar:GetWidth()-bar.text_right:GetStringWidth()-16-bar:GetHeight()
		--	bar.text_left:SetSize(tamanho-2, 15)
		--else
			bar.text_left:SetSize(bar:GetWidth()-bar.text_right:GetStringWidth()-18, 15)
		--end
	end

	function _details:name_space_info(bar)
		if (bar.icon_secundario_active) then
			local tamanho = bar:GetWidth()-bar.text_right:GetStringWidth()-16-bar:GetHeight()
			bar.text_left:SetSize(tamanho-10, 15)
		else
			local tamanho = bar:GetWidth()-bar.text_right:GetStringWidth()-16
			bar.text_left:SetSize(tamanho-10, 15)
		end
	end

	function _details:name_space_generic(bar, separador)
		local text_right_tamanho = bar.text_right:GetStringWidth()
		local tamanho = bar:GetWidth()-text_right_tamanho-16
		if (separador) then 
			bar.text_left:SetSize(tamanho+separador, 10)
			bar.text_right:SetSize(text_right_tamanho+15, 10)
		else
			bar.text_left:SetSize(tamanho-10, 15)
			bar.text_right:SetSize(text_right_tamanho+5, 15)
		end
	end

