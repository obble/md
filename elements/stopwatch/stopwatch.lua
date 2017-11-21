

	local x, y 			= 0, -100
	local visible 		= false
	local t0
	local saved_time 	= 0
	local MAX_TIMER_SEC = 99*3600 + 59*60 + 59
	local pad  			= function(n) return strlen(n) == 2 and n or '0'..n end
	local var			= MODUI_VAR['elements']['clock']
	local skin			= MODUI_VAR['elements']['bu_skin']
	local H = {}

	local OnUpdate = function()
		local time 	= GetTime()
		local  f 	= _G['modstopwatch']
		local h, m, s
		if  time - 0 > 1 then
			if  f.play.reverse then
				s = (f.play.timer + t0) - time
				if  s <= 0 then 
					s = 0 
					Reset() 
				end
			else 
				s = (t0 and floor(time - t0) or 0) + saved_time 

			end
			h = floor(s/3600)
			s = s - h*3600
			m = floor(s/60)
			s = s - m*60

			f.t:SetText(string.format('%d:%d:%d', pad(h), pad(m), pad(s)))
			f:SetWidth(f.t:GetStringWidth() + f.play:GetWidth() + f.reset:GetWidth() + 10)
		end
	end

	local SetCountdown = function(h, m, s)
		local f 	= _G['modstopwatch']
		local sec 	= 0
		local text

		if h then sec = h*3600 end
		if m then sec = sec + m*60 end
		if s then sec = sec + s end

		-- if s == 0 then Show() return end

		if  sec > MAX_TIMER_SEC then
			f.play.timer = MAX_TIMER_SEC
			t0 = GetTime()
		elseif sec < 0 then
			f.play.timer = 0
			t0 = nil
		else
			f.play.timer = sec
			t0 = GetTime()
		end

		f.play.reverse = sec > 0
		f.play.playing = true

		f.play:SetText'Pause'
		f:SetScript('OnUpdate', OnUpdate)
		f:Show()

		visible = true
	end

	local Stop = function()
		local  f = _G['modstopwatch']
		if not f.play.playing then return end
		f.play.playing = false
		f.play:SetText'Start'
		if t0 then saved_time = floor(saved_time + GetTime() - t0) end
		t0 = nil
		f:SetScript('OnUpdate', nil)
	end

	local Reset = function()
		local  f = _G['modstopwatch']
		f:SetScript('OnUpdate', nil)
		f.play.reverse, t0 = nil
		Stop()
		f:SetWidth(132)
		f.t:SetText'0:0:0'
		saved_time = 0
	end

	local Start = function()
		local  f = _G['modstopwatch']
		if f.play.playing then return end
		f.play.playing = true
		f.play:SetText'Pause'
		t0 = GetTime()
		f:SetScript('OnUpdate', OnUpdate)
	end

	local Toggle = function()
		if  this.playing then
			Stop()
			PlaySound'igMainMenuOptionCheckBoxOff'
		else
			Start()
			PlaySound'igMainMenuOptionCheckBoxOn'
		end
	end

	local Show = function(bu)
		if  IsShiftKeyDown() then
			if  TwentyFourHourTime then
				TwentyFourHourTime 	= false
				var.twentyfour 		= false
			else
				TwentyFourHourTime 	= true
				var.twentyfour 		= true
			end
		else
			if  var.stopwatch then
				local f = _G['modstopwatch']
				if  visible then
					f:Hide()
					visible = false
				else
					f:Show()
					f.t:SetText'0:0:0'
					visible = true
				end
			end
		end
	end

	local OnEvent = function()
		local f = CreateFrame('Frame', 'modstopwatch', UIParent)
		f:EnableMouse(true) 
		f:SetMovable(true)
		f:SetWidth(132)
		f:SetHeight(24)
		f:RegisterForDrag'LeftButton'
		f:SetPoint('CENTER', x, y)
		f:SetBackdrop(
			{
				bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
				insets = {
					left 	= -1,
					right 	= -1, 
					top 	= -1, 
					bottom 	= -1
				}
			}
		)
		f:SetBackdropColor(0, 0, 0, .8)
		f:Hide()

		if  skin.enable then
			modSkin(f)
			modSkinColor(f, skin.r, skin.g, skin.b)
		end

		f.t = f:CreateFontString(nil, 'OVERLAY')
		f.t:SetFontObject'GameFontNormalLarge'
		f.t:SetPoint('LEFT', 5, 0)

		f.reset = CreateFrame('Button', 'modstopwatch_reset', f, 'UIPanelButtonTemplate')
		f.reset:SetWidth(40) 
		f.reset:SetHeight(20)
		f.reset:SetPoint('RIGHT', -2, 0)
		f.reset:SetText'Reset'

		f.play = CreateFrame('Button', 'modstopwatch_playpause', f, 'UIPanelButtonTemplate')
		f.play:SetWidth(40) 
		f.play:SetHeight(20)
		f.play:SetPoint('RIGHT', f.reset, 'LEFT', -2, 0)
		f.play:SetText'Start'

		f:SetScript('OnDragStart', function() f:StartMoving() end)
		f:SetScript('OnDragStop',  function() f:StopMovingOrSizing() end)

		f.play:SetScript('OnClick',  Toggle)
		f.reset:SetScript('OnClick', Reset)

		GameTimeFrame:SetScript('OnMouseDown', Show)
	end

	local UpdateTooltip = function(h, m)
		-- TODO: format local time & offer option between it and server time

		-- local time = time()
		-- print(time)

		if  var.twentyfour == 1 or TwentyFourHourTime then
			GameTooltip:AddDoubleLine(date'%H:%M', '|cffffffffLocal Time|r')
			GameTooltip:AddDoubleLine(format(TEXT(TIME_TWENTYFOURHOURS), h, m), '|cffffffffServer Time|r')
		else
			local pm = 0

			if h >= 12 then pm = 1 		end
			if h >  12 then h = h - 12 	end
			if h ==  0 then h = 12 		end

			GameTooltip:AddDoubleLine(date'%I:%M %p', '|cffffffffLocal Time|r')
			GameTooltip:AddDoubleLine(format(TEXT(pm == 0 and TIME_TWELVEHOURAM or TIME_TWELVEHOURPM), h, m), '|cffffffffServer Time|r')
		end

		if  var.stopwatch then
			GameTooltip:AddLine('Click to Toggle Stopwatch.', .3, 1, .6)
		end

		GameTooltip:AddLine('Shift + Click to Toggle 24hr Time.', .3, 1, .6)
		GameTooltip:Show()
	end

	local SlashCmd = function(msg)
		if  var.stopwatch then
			if  msg == '' then 
				Show()
			else
				local t = strlower(msg)
				if  string.find(t, 'play') or string.find(t, 'start') then
					Start() return
				end
				if  string.find(t, 'pause') then
					Stop()  return
				end
				if  string.find(t, 'stop') 
				or  string.find(t, 'reset') 
				or  string.find(t, 'clear') then
					Reset() return
				end
				local y, _, h, m, s = string.find(arg, '(%d+):(%d+):(%d+)')
				if  y then 
					AddCountdown(tonumber(h), tonumber(m), tonumber(s))
				else
					local y, _, m, s = string.find(arg, '(%d+):(%d+)')
					if  y then 
						AddCountdown(0, tonumber(m), tonumber(s))
					else
						local y, _, s = string.find(arg, '(%d+)')
						if  y then 
							AddCountdown(0, 0, tonumber(s))
						else 
							Show()
						end
					end
				end
			end
		end
	end

	GameTimeFrame_UpdateTooltip = UpdateTooltip

	SLASH_STOPWATCH1 			= '/stopwatch'
	SLASH_STOPWATCH2 			= '/sw'
	SLASH_STOPWATCH3 			= '/timer'
	SlashCmdList['STOPWATCH'] 	= SlashCmd

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)

	--
