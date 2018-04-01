

    -- written by kuurtzen (& modernist (mostly kuurtzen))

    local skin      = MODUI_VAR['elements']['bu_skin']

    local Cast 		= {} 	local casts 		= {}
    local Heal 		= {} 	local heals 		= {}
	local InstaBuff = {} 	local iBuffs 		= {}
	local buff 		= {} 	local buffList 		= {}
	local buffQueue	= {}	local buffQueueList = {}
	local dreturns 	= {} 	local dreturnsList 	= {}

    Cast.__index 		= modcast
    Heal.__index 		= Heal
	InstaBuff.__index 	= InstaBuff
	buff.__index		= buff
	buffQueue.__index	= buffQueue
	dreturns.__index	= dreturns

	local schools = {
		['physical'] 	= {.9, .9,  0},
		['frost']		= {.4, .9, .9},
		['shadow'] 		= {.4, .4, .9},
		['holy'] 		= {.9, .4, .9}
	}

	local events = {
		'PLAYER_ENTERING_WORLD',
		'CHAT_MSG_MONSTER_EMOTE',
		'CHAT_MSG_SPELL_SELF_BUFF',
		'CHAT_MSG_SPELL_SELF_DAMAGE',
		'CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF',
		'CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF',
		'CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF',
		'CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE',
		'CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF',
		'CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE',
		'CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF',
		'CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE',
		'CHAT_MSG_SPELL_PARTY_BUFF',
		'CHAT_MSG_SPELL_PARTY_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS',
		'CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE',
		'CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS',
		'CHAT_MSG_SPELL_BREAK_AURA',
		'CHAT_MSG_SPELL_AURA_GONE_SELF',
		'CHAT_MSG_SPELL_AURA_GONE_PARTY',
		'CHAT_MSG_SPELL_AURA_GONE_OTHER',
		'CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF',
		'CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS',
		'CHAT_MSG_COMBAT_HOSTILE_DEATH',
		'CHAT_MSG_COMBAT_FRIENDLY_DEATH',
	}

    Cast.create = function(caster, spell, info, timeMod, time, inv)
        local acnt = {}
		setmetatable(acnt, modcast)
		acnt.caster     = caster
		acnt.spell      = spell
		acnt.icon       = info[1]
		acnt.timeStart  = time
		acnt.timeEnd    = time + info[2]*timeMod
		acnt.tick	    = info[3] and info[3] or 0 
		acnt.nextTick	= info[3] and time + acnt.tick or acnt.timeEnd 
		acnt.inverse    = inv	
		acnt.class		= info[4]
		acnt.school		= info[5] and schools[info[5]]
		acnt.borderClr	= info[6] and {.45, .45, .3} or skin.enable and {skin.r, skin.g, skin.b} or {.1, .1, .1}
		return acnt
    end

    Heal.create = function(n, no, crit, time)
       local acnt = {}
	   setmetatable(acnt,Heal)
	   acnt.target    = n
	   acnt.amount    = no
	   acnt.crit      = crit
	   acnt.timeStart = time
	   acnt.timeEnd   = time + 2
	   acnt.y         = 0
	   return acnt
    end

	InstaBuff.create = function(c, b, list, time)
       local acnt = {}
       setmetatable(acnt, InstaBuff)
       acnt.caster    	= c
       acnt.buff      	= b
	   acnt.timeMod 	= list[1]
	   acnt.spellList 	= list[2]
       acnt.timeStart	= time
       acnt.timeEnd   	= time + 10	--planned obsolescence
       return acnt
    end

     buff.create = function(tar, t, s, buffType, factor, time)
		local acnt     = {}
		setmetatable(acnt, buff)
		acnt.target    	= tar
		acnt.caster    	= tar	-- facilitate entry removal
		acnt.spell      = t
		acnt.stacks		= s
		acnt.icon      	= buffType[1]
		acnt.timeStart 	= time
		acnt.timeEnd   	= time + buffType[2] * factor	-- and buffType[4] * factor or 0
		acnt.prio		= buffType[3] and buffType[3] or 0
		acnt.border		= buffType[4] and RGB_BORDER_DEBUFFS_COLOR[buffType[4]] or {.1, .1, .1}	-- border rgb values depending on type of buff/debuff
		acnt.display 	= buffType[5] and buffType[5] or true
		return acnt
	end

	buffQueue.create = function(tar, spell, buffType, d, time)
		local acnt     = {}
		setmetatable(acnt, buffQueue)
		buffType['duration'] 	= buffType['cp'][d]
		acnt.target    			= tar
		acnt.buffName			= spell
		acnt.timeStart 			= time
		acnt.timeEnd   			= time + 1 
		acnt.buffData   		= buffType
		-- acnt.duration		=  nil
		return acnt
	end

	dreturns.create = function(tar, t, tEnd)
		local acnt = {}
		setmetatable(acnt, dreturns)
		acnt.target 	= tar
		acnt.type 		= t
		acnt.factor 	= 1
		acnt.k 			= 15
		acnt.timeEnd 	= tEnd + acnt.k
		return acnt
	end

	--/script down, up, lagHome, lagWorld = GetNetStats() print(lagHome)
	local GetAvgLatency = function()
		local _, _, lat = GetNetStats()
		return lat / 1000
	end
	
	local GetTimeMinusPing = function()
		return GetTime() -- GetAvgLatency() --- standby for now
	end

	local RemoveEndedSpells = function(time, tab)
		local i = 1
		for k, v in pairs(tab) do
			if  time > v.timeEnd then
				table.remove(tab, i) 
			end
			i = i + 1
		end
	end

	 local UpdateDR = function(time, dr, buff)
		for k, v in pairs(dr) do
			for  i, j in pairs(buff) do
				if  j.target == v.target and MODUI_BUFFS_TO_TRACK[j.spell] and MODUI_BUFFS_TO_TRACK[j.spell]['dr'] then
					if  MODUI_BUFFS_TO_TRACK[j.spell]['dr'] == v.type then
						v.timeEnd = time + v.k
					end
				end
			end
		end
	end

	 local TableMaintenance = function(reset)
		if  reset then
			for _, v in pairs(
				{
					casts,
					heals,
					iBuffs,
					buffList,
					dreturnsList
				}
			) do
				v = {}
			end
		else
			-- CASTS -- casts have a different removal parameter
			local time = GetTime()
			local i = 1

			for k, v in pairs(casts) do
				if  time > v.timeEnd or time > v.nextTick + GetAvgLatency() then
					table.remove(casts, i)
				end
				i = i + 1
			end

			UpdateDR(time, dreturnsList, buffList)

			for _, v in pairs(
				{
					heals,
					iBuffs,
					buffList,
					buffQueueList,
					dreturnsList
				}
			) do
				RemoveEndedSpells(time, v)
			end
		end
	end

	local RemoveDoubleCast = function(caster)
		local k = 1
		for  i, j in casts do
			if  j.caster == caster then table.remove(casts, k) end
			k = k + 1
		end
	end

	local CheckForChannels = function(caster, spell)
		local k = 1
		for  i, j in casts do
			if  j.caster  == caster and j.spell == spell then	-- and (SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK[spell] ~= nil or SPELLINFO_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[spell] ~= nil) then 
				j.nextTick = GetTime() + j.tick 				-- GetTime() + j.tick + getAvgLatency()--j.nextTick + j.tick --+ getAvgLatency()
				-- print(j.nextTick - j.timeStart)
				return true 
			end
			k = k + 1
		end
		return false
	end

	 local CheckforCastTimeModBuffs = function(caster, spell)
		local k = 1
		for  i, j in iBuffs do
			if  j.caster == caster then 
				if  j.spellList[1] ~= 'all' then
					local a, lastT = 1, 1		
					for  b, c in j.spellList do
						if  c == spell then
							if  lastT ~= 0 then			-- priority to instantly cast buffs
								lastT = j.timeMod
							end
						end
					end
					return lastT
				else
					return j.timeMod
				end
				-- return false
			end
			k = k + 1
		end
		return 1
	end


	local AddCast = function(caster, spell, channel)
		local info = nil
		
		if  channel then
			info = MODUI_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[spell] or MODUI_CHANNELED_SPELLCASTS_TO_TRACK[spell] or nil
		else
			RemoveDoubleCast(caster)
			info = MODUI_SPELLCASTS_TO_TRACK[spell] or nil
		end
		
		if  info then
			if  not CheckForChannels(caster, spell) then
				RemoveDoubleCast(caster)
				local tmod = CheckforCastTimeModBuffs(caster, spell)
				if  tmod > 0 then
					local n = Cast.create(caster, spell, info, tmod, GetTimeMinusPing(), channel)
					table.insert(casts, n)
				end
			end
		end
	end

	local AddHeal = function(n, no, crit)
		local h = Heal.create(n, no, crit, GetTime())
		table.insert(heals, h)
	end

	local AddIBuff = function(caster, buff)
		local b = InstaBuff.create(caster, buff, MODUI_TIME_MODIFIER_BUFFS_TO_TRACK[buff], GetTimeMinusPing())
		table.insert(iBuffs, b)
	end

	local AddDR = function(time, tar, b, cast)
		if not MODUI_BUFFS_TO_TRACK[b]['dr'] then return 1 end
		
		for  k, v in pairs(dreturnsList) do
			if  v.target == tar and v.type == MODUI_BUFFS_TO_TRACK[b]['dr'] then
				v.factor = v.factor > .25 and v.factor / 2 or 0
				--	if  v.factor > 0 then
				-- 		v.timeEnd = time + SPELLINFO_BUFFS_TO_TRACK[b]['duration'] * v.factor + v.k
				--	end
				return v.factor
			end
		end
		
		if cast then return 0 end		-- avoids creating a new DR entry if none was found
		table.insert(dreturnsList, dreturns.create(tar, MODUI_BUFFS_TO_TRACK[b]['dr'], SPELLINFO_BUFFS_TO_TRACK[b]['duration'] + time))
		return 1
	end

	local CheckQueueBuff = function(tar, b)
		for  k, v in pairs(buffQueueList) do
			if  v.target == tar and v.buffName == b then
				return true
			end
		end
		return false
	end

	local AddBuff = function(tar, b, s, cast)
		-- check buff queue
		if CheckQueueBuff(tar, b) then return end
		
		local dr = AddDR(time, tar, b, cast)
		
		if  dr > 0 then		
			-- remove buff if it exists
			for  k, v in pairs(buffList) do
				if  v.caster == tar and v.spell == b then
					table.remove(buffList, k)
				end
			end
			
			table.insert(buffList, buff.create(tar, b, s, MODUI_BUFFS_TO_TRACK[b], dr, GetTimeMinusPing()))
		end
	end

	local RefreshBuff = function(tar, b, s)
		--  refresh if it exists
		for  i, j in pairs(MODUI_DEBUFF_REFRESHING_SPELLS[b]) do
			for  k, v in pairs(buffList) do
				if  v.caster == tar and v.spell == j then
					AddBuff(tar, j, s, false)
					return
				end
			end
		end
	end

	local QueueBuff = function(tar, spell, b, d)
		local bq 	= buffQueue.create(tar, spell, b, d, GetTimeMinusPing())
		table.insert(buffQueueList, bq) 
	end

	 local ProcessQueuedBuff = function(tar, b)
		for  k, v in pairs(buffQueueList) do
			if  v.target == tar and v.buffName == b then
				table.insert(buffList, buff.create(v.target, v.buffName, 1, v.buffData, 1, GetTimeMinusPing()))
				table.remove(buffQueueList, k)
				return 
			end
		end
	end

	 local ForceHideSpell = function(tab, caster, spell)
		local time = GetTime()
		for  k, v in pairs(tab) do
			if  time < v.timeEnd and  v.caster == caster then
				if  spell then 
					if  v.spell == spell then	
						v.timeEnd = time 	-- 10000 end
					end 
				else
					v.timeEnd = time 		-- 10000 -- force hide
				end
			end
		end
	end

	local CastCraftPerform = function()
		local pcast 	= 'You cast (.+).'
		local cast		= '(.+) casts (.+).'
		local bcast 	= '(.+) begins to cast (.+).'
		local craft 	= '(.+) -> (.+).'
		local perform 	= '(.+) performs (.+).'
		local bperform 	= '(.+) begins to perform (.+).'
		local operform 	= '(.+) performs (.+) on (.+).'

		local pcastfin 	= 'You cast (.+) on (.+).'
		local castfin 	= '(.+) casts (.+) on (.+).'
		
		local fpcast 	= string.find(arg1, pcast)
		local fcast 	= string.find(arg1, cast)
		local fbcast 	= string.find(arg1, bcast)
		local fcraft 	= string.find(arg1, craft)
		local fcraft 	= string.find(arg1, craft)
		local fperform 	= string.find(arg1, perform)
		local fbperform = string.find(arg1, bperform)
		local foperform = string.find(arg1, operform)
		local fpcastfin = string.find(arg1, pcastfin)
		local fcastfin 	= string.find(arg1, castfin)

		if  fbcast or fcraft then
			local m = fbcast and bcast or fcraft and craft or fperform and perform
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			AddCast(c, s, false)
			-- print('modui castcatch: '..arg1)
			
		elseif fperform or fbperform or foperform then
			local m = fperform and perform or fbperform and bperform or foperform and operform
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			AddCast(c, s, fperform and true or false)
			
		--  objects or summons
		elseif fcast then
			local m = cast
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			if  MODUI_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, false)
			else
				ForceHideSpell(casts, c, nil)
			end

		-- on standby
		-- finished casts CC(?)	
		--[[	
		elseif fpcastfin or fcastfin then
			local m = fpcastfin and pcastfin or fcastfin and castfin
			local t = fpcastfin and gsub(arg1, m, '%2') or gsub(arg1, m, '%3')
			local s = fpcastfin and gsub(arg1, m, '%1') or gsub(arg1, m, '%2')
			
			if SPELLINFO_BUFFS_TO_TRACK[s] then
				newbuff(t, s, true)
			end]]--
		end
		
		return fcast or fbcast or fpcast or fcraftor or fperform or fbperform or fpcastfin or fcastfin or foperform
	end

	local HandleHeal = function()
		local h   	 	= 'Your (.+) heals (.+) for (.+).'
		local c   	 	= 'Your (.+) critically heals (.+) for (.+).'
		local hot 	 	= '(.+) gains (.+) health from your (.+).'
		local oheal  	= '(.+)\'s (.+) heals (.+) for (.+).'
		local ocheal 	= '(.+)\'s (.+) critically heals (.+) for (.+).'
		
		local fh 	 	= string.find(arg1, h)
		local fc 	 	= string.find(arg1, c)
		local fhot 	 	= string.find(arg1, hot)
		local foheal 	= string.find(arg1, oheal)
		local focheal 	= string.find(arg1, ocheal)

		if  fh or fc then
			local n  = gsub(arg1, h, '%2')
			local no = gsub(arg1, h, '%3')
			AddHeal(n, no, fc and 1 or 0)
		elseif fhot then
			local m  = fhot and hot		
			local n  = gsub(arg1, m, '%1')
			local no = gsub(arg1, m, '%2')
			AddHeal(n, no, 0)
			-- other's heals (insta heals)
		elseif foheal or focheal then
			local m  = foheal and oheal or focheal and ocheal
			local c  = gsub(arg1, m, '%1')
			local s  = gsub(arg1, m, '%2')
			
			if  MODUI_INSTANT_SPELLCASTS_TO_TRACK[s] then
				ForceHideSpell(casts, c, nil)
			end
		end
		
		return fh or fc or fhot or foheal or focheal
	end


	local DirectInterrupt = function()
		local pi 	= 'You interrupt (.+)\'s (.+).'
		local i  	= '(.+) interrupts (.+)\'s (.+).'

		local fpi 	= string.find(arg1, pi)
		local fi  	= string.find(arg1, i)
	
		if  fpi  or fi then
			local m = fpi and pi or i
			local t = fpi and gsub(arg1, m, '%1') or gsub(arg1, m, '%2') 
			local s = fpi and gsub(arg1, m, '%2') or gsub(arg1, m, '%3') 
			ForceHideSpell(casts, t, nil)
		end	
		
		return fpi  or fi
	end

	 local GainAfflict = function()
		local gain 		= '(.+) gains (.+).'
		local pgain 	= 'You gain (.+).'
		local afflict 	= '(.+) is afflicted by (.+).'
		local pafflict 	= 'You are afflicted by (.+).'
		
		local fgain 	= string.find(arg1, gain)
		local fpgain 	= string.find(arg1, pgain)
		local fafflict 	= string.find(arg1, afflict)
		local fpafflict = string.find(arg1, pafflict)

		-- start channeling based on buffs (evocation, first aid, ..)
		if  fgain or fpgain then
			local m = fgain and gain or fpgain and pgain
			local c = fgain and gsub(arg1, m, '%1') or fpgain and playerName
			local s = fgain and gsub(arg1, m, '%2') or fpgain and gsub(arg1, m, '%1')
			
			-- buffs/debuffs to be displayed
			if  MODUI_BUFFS_TO_TRACK[s] then
				AddBuff(c, s, 1, false)
			end
			-- self-cast buffs that interrupt cast (blink, ice block ...)
			if  MODUI_INTERRUPTS_TO_TRACK[s] then
				ForceHideSpell(casts, c, nil)
			end
			-- specific channeled spells (evocation ...)
			if MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end
			-- buffs that alter spell casting speed
			if  MODUI_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
				AddIBuff(c, s)
			end
				
		-- cast-interruting CC
		elseif fafflict or fpafflict then
			local m = fafflict and afflict or fpafflict and pafflict
			local c = fafflict and gsub(arg1, m, '%1') or fpafflict and playerName
			local s = fafflict and gsub(arg1, m, '%2') or fpafflict and gsub(arg1, m, '%1')
			
			-- rank & stacks
			local auxS, st = s, 1
			if  not MODUI_BUFFS_TO_TRACK[s] then
				--local buffRank = '(.+) (.+)'
				--if string.find(s, buffRank) then print(gsub(s, buffRank, '%1'))	print(gsub(s, buffRank, '%2'))	end
				local spellstacks = '(.+) %((.+)%)'	
				if  string.find(s, spellstacks) then 
					s = gsub(s, spellstacks, '%1')	st = tonumber(gsub(auxS, spellstacks, '%2'), 10)	-- print(s) print(st)	
				end
			end
			--  debuffs to be displayed
			if  MODUI_BUFFS_TO_TRACK[s] then
				--if st > 1 then
				--	refreshBuff(c, s, st)
				--else
					AddBuff(c, s, st, false)
				--end		
			end
			
			s = auxS
			
			-- spell interrupting debuffs (stuns, incapacitates ...)
			if  MODUI_INTERRUPTS_TO_TRACK[s] then
				ForceHideSpell(casts, c, nil)
			end
			
			-- debuffs that slow spellcasting speed (tongues ...)
			if  MODUI_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
				AddIBuff(c, s)
			end
			
			-- process debuffs in queueBuff
			ProcessQueuedBuff(c, s)
		end
		
		return fgain or fpgain or fafflict or fpafflict
	end

	 local FadeOrRemoved = function()
		local fade 	= '(.+) fades from (.+).'
		local rem 	= '(.+)\'s (.+) is removed'
		local prem 	= 'Your (.+) is removed'
		
		local ffade = string.find(arg1, fade)
		local frem 	= string.find(arg1, rem)
		local fprem = string.find(arg1, prem)

		-- end channeling based on buffs (evocation ..)
		if  ffade then
			local m = fade
			local c = gsub(arg1, m, '%2')
			local s = gsub(arg1, m, '%1')
			
			c = c == 'you' and UnitName'player' or c
			
			-- buffs/debuffs to be displayed
			if  MODUI_BUFFS_TO_TRACK[s] then
				ForceHideSpell(buffList, c, s)
			end
			-- buff channeling casts fading
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				ForceHideSpell(casts, c, nil)
			end
			
			if  MODUI_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
				ForceHideSpell(iBuffs, c, s)
			end
		elseif frem or fprem then
			local m = frem and rem or fprem and prem
			local c = frem and gsub(arg1, m, '%1') or fprem and UnitName'player'
			local s = frem and gsub(arg1, m, '%2') or fprem and gsub(arg1, m, '%1')
			
			-- buffs/debuffs to be displayed
			if  MODUI_BUFFS_TO_TRACK[s] then
				ForceHideSpell(buffList, c, s)
			end
			
			if  MODUI_TIME_MODIFIER_BUFFS_TO_TRACK[s] then
				ForceHideSpell(iBuffs, c, s)
			end
		end
		
		return ffade or frem or fprem
	end

	 local HitsCrits = function()
		local hits 				= '(.+)\'s (.+) hits (.+) for (.+)'
		local crits 			= '(.+)\'s (.+) crits (.+) for (.+)'
		local absb 				= '(.+)\'s (.+) is absorbed by (.+).'
		local phits 			= 'Your (.+) hits (.+) for (.+)'
		local pcrits 			= 'Your (.+) crits (.+) for (.+)'
		local pabsb 			= 'Your (.+) is absorbed by (.+).'	
		local channelDotRes 	= '(.+)\'s (.+) was resisted by (.+).'
		local pchannelDotRes 	= '(.+)\'s (.+) was resisted.'
		
		local fhits 			= string.find(arg1, hits)
		local fcrits 			= string.find(arg1, crits)
		local fabsb 			= string.find(arg1, absb)
		local fphits 			= string.find(arg1, phits)
		local fpcrits 			= string.find(arg1, pcrits)
		local fpabsb 			= string.find(arg1, pabsb)
		local fchannelDotRes 	= string.find(arg1, channelDotRes)
		local fpchannelDotRes 	= string.find(arg1, pchannelDotRes)

		-- other hits/crits
		if  fhits or fcrits or fabsb then
			local m = fhits and hits or fcrits and crits or fabsb and absb
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			local t = gsub(arg1, m, '%3')
			
			t = t == 'you' and UnitName'player' or t
			
			-- instant spells that cancel casted ones
			if  MODUI_INSTANT_SPELLCASTS_TO_TRACK[s] then 
				ForceHideSpell(casts, c, nil)
			end
			
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end			
			
			-- interrupt dmg spell
			if  MODUI_INTERRUPTS_TO_TRACK[s] then
				ForceHideSpell(casts, t, nil)
			end
			
			-- spells that refresh debuffs
			if  MODUI_DEBUFF_REFRESHING_SPELLS[s] then
				RefreshBuff(t, s)
			end
		end
		
		-- self hits/crits
		if fphits or fpcrits or fpabsb then
			local m = fphits and phits or fpcrits and pcrits or fpabsb and pabsb
			local s = gsub(arg1, m, '%1')
			local t = gsub(arg1, m, '%2')
			
			-- interrupt dmg spell
			if  MODUI_INTERRUPTS_TO_TRACK[s] then
				ForceHideSpell(casts, t, nil)
			end
			
			-- spells that refresh debuffs
			if  MODUI_DEBUFF_REFRESHING_SPELLS[s] then
				RefreshBuff(t, s)
			end
		end
		
		-- resisted channeling dmg spells (arcane missiles ITS A VERY SPECIAL AND UNIQUE SNOWFLAKE SPELL)
		if  fchannelDotRes or fpchannelDotRes then
			local m = fchannelDotRes and channelDotRes or fpchannelDotRes and pchannelDotRes
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end			
		end
		
		return fhits or fcrits or fphits or fpcrits or fabsb or fpabsb --or ffails
	end


	local ChannelDot = function()
		local channelDot 	= '(.+) suffers (.+) from (.+)\'s (.+).'
		local channelpDot 	= '(.+) suffers (.+) from your (.+).'
		local pchannelDot 	= 'You suffer (.+) from (.+)\'s (.+).'		
		local MDrain 		= '(.+)\'s (.+) drains (.+) Mana from'

		local fchannelDot 	= string.find(arg1, channelDot)
		local fchannelpDot	= string.find(arg1, channelpDot)
		local fpchannelDot 	= string.find(arg1, pchannelDot)
		local fMDrain 		= string.find(arg1, MDrain)
		
		-- channeling dmg spells on other (mind flay, life drain(?))
		if  fchannelDot then
			local m = channelDot
			local c = gsub(arg1, m, '%3')
			local s = gsub(arg1, m, '%4')
			local t = gsub(arg1, m, '%1')	
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end			
		end
		
		-- channeling dmg spells on self (mind flay, life drain(?))
		if  fpchannelDot then
			local m = pchannelDot
			local c = gsub(arg1, m, '%2')
			local s = gsub(arg1, m, '%3')
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end			
		end
			
		-- drain mana 
		if  fMDrain then
			local m = MDrain
			local c = gsub(arg1, m, '%1')
			local s = gsub(arg1, m, '%2')
			if  MODUI_CHANNELED_SPELLCASTS_TO_TRACK[s] then
				--print(arg1)
				AddCast(c, s, true)
			end	
		end
		return fchannelDot or fpchannelDot or fchannelpDot or fMDrain
	end


	local ChannelHeal = function()
		local hot 	= '(.+) gains (.+) health from (.+)\'s (.+).'
		local phot 	= 'You gain (.+) health from (.+)\'s (.+).'
		local shot 	= 'You gain (.+) health from (.+).'	
		
		local fhot 	= string.find(arg1, hot)
		local fphot = string.find(arg1, phot)
		local fshot = string.find(arg1, shot)

		if  fhot or fphot then
			local m = fhot and hot or fphot and phot
			local c = fhot and gsub(arg1, m, '%3') or fphot and gsub(arg1, m, '%2')
			local s = fhot and gsub(arg1, m, '%4') or fphot and gsub(arg1, m, '%3')
			--local t = fhot and gsub(arg1, m, '%1') or nil		
			if  MODUI_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end	
		elseif fshot then
			local m = shot
			local c = playerName
			local s = gsub(arg1, m, '%2')
			if  MODUI_CHANNELED_HEALS_SPELLCASTS_TO_TRACK[s] then
				AddCast(c, s, true)
			end
		end
		
		return fhot or fphot or fshot
	end

	 local PlayerDeath = function()
		local pdie 		= 'You die.'
		local dies		= '(.+) dies.'
		local slain 	= '(.+) is slain by (.+).'
		local pslain 	= 'You have slain (.+).'

		local fpdie		= string.find(arg1, pdie)
		local fdies		= string.find(arg1, dies)
		local fslain 	= string.find(arg1, slain)
		local fpslain 	= string.find(arg1, pslain)

		if  fpdie or fdies or fslain or fpslain then
			local m = fpdie and UnitName'player' or fdies and dies or fslain and slain or fpslain and pslain
			local c = fpdie and playerName or gsub(arg1, m, '%1')
			ForceHideSpell(casts, c, nil)
			ForceHideSpell(buffList, c, nil)
		end
		
		return fpdie or fdies or fslain or fpslain
	end

	local Fear = function()
		local f 	= '(.+) attempts to run away in fear!'
		local ff 	= string.find(arg1, f)

		if  ff then
			local t = arg2			
			ForceHideSpell(casts, t)	
		end
		
		return ff
	end

	local HandleVanish = function()
		local v  = '(.+) performs Vanish'
		local fv = string.find(arg1, v)

		if  fv then
			local  c = gsub(arg1, v, '%1')
			for k, v in pairs(SPELLINFO_ROOTS_SNARES) do
				ForceHideSpell(buffList, c, k)
			end
		end

		return fv
	end

	local ParsingCheck = function(out, display)
		if  (not out) and display then
			print'Parsing failed:'
			print(event)
			print(arg1)
		end
	end

	local CombatLogParser = function()	
		local pSpell 		= 'CHAT_MSG_SPELL_PERIODIC_(.+)'
		local breakAura 	= 'CHAT_MSG_SPELL_BREAK_AURA'
		local auraGone		= 'CHAT_MSG_SPELL_AURA_GONE_(.+)'
		local dSpell 		= 'CHAT_MSG_SPELL_(.+)'	
		local death			= 'CHAT_MSG_COMBAT_(.+)_DEATH'
		local mEmote		= 'CHAT_MSG_MONSTER_EMOTE'

		local fpSpell 		= string.find(event, pSpell)
		local fbreakAura 	= string.find(event, breakAura)
		local fauraGone 	= string.find(event, auraGone)
		local fdSpell 		= string.find(event, dSpell)
		local fdeath 		= string.find(event, death)
		local fmEmote		= string.find(event, mEmote)
		
		-- periodic damage/buff spells
		if  fpSpell then	
			ParsingCheck(
				ChannelDot() or ChannelHeal() or GainAfflict() or HandleHeal(), 
				false
			)
		-- fade/remove buffs
		elseif fbreakAura or fauraGone then
			ParsingCheck(
				FadeOrRemoved(), 
				false
			)
		-- direct damage/buff spells
		elseif fdSpell then
			ParsingCheck(
				HandleVanish() or CastCraftPerform() or HandleHeal() or DirectInterrupt() or HitsCrits(), 
				false
			)
		-- player death
		elseif fdeath then
			ParsingCheck(
				PlayerDeath(), 
				false
			)
		-- creature runs in fear
		elseif fmEmote then
			ParsingCheck(
				Fear(),
				false
			)
		else
			--unparsed event!
			--print('untreated event')
			--ParsingCheck(
			--	false, 
			--	true
			--)
		end
	end

	local SortBuffPriority = function(tab, b)
		for  k, v in pairs(tab) do
			if  b.prio > v.prio then	
				table.insert(tab, k, b)
				return tab
			end
		end
		table.insert(tab, b)
		return tab
	end

	MODUI_GetCast = function(caster)
		if  caster == nil then return nil end
		for  k, v in pairs(casts) do
			if  v.caster == caster then
				return v
			end
		end
		return nil
	end
	
	MODUI_GetHeal = function(target)
		for  k, v in pairs(heals) do
			if  v.target == target then
				return v
			end
		end
		return nil
	end
	
	MODUI_GetBuffPriority = function(name, n)
		local b = {}
		for  j, e in pairs(buffList) do
			if  e.target == name and e.display then
				b = sortPriobuff(b, e)
			end
		end
		local l = {}
		for  k, v in pairs(b) do
			table.insert(l, v)
			if k == n then return l end
		end
		return l
	end
	
	MODUI_GetBuffs = function(name)
		local list = {}
		for  j, e in ipairs(buffList) do
			if  e.target == name then
				table.insert(list, e)
			end
		end
		return list
	end
	
	MODUI_RefreshBuffs = function(t, b, s)
		if  MODUI_DEBUFF_REFRESHING_SPELLS[b] then
			RefreshBuff(t, b, s)
		end
	end
	
	MODUI_QueueBuff = function(t, b, d)
		if  MODUI_UNIQUE_DEBUFFS[b] then	
			QueueBuff(t, b, SPELLINFO_UNIQUE_DEBUFFS[b], d)
			return true
		end
		return false
	end

	local OnUpdate = function()
		TableMaintenance(false)
	end

	local OnEvent = function()
		if  event == 'PLAYER_ENTERING_WORLD' then
			TableMaintenance(true)
		else
			CombatLogParser()
		end
	end

	local e = CreateFrame('Frame', 'modui_spellhandler', UIParent)
	for _, v in pairs(events) do e:RegisterEvent(v) end

	e:SetScript('OnUpdate', OnUpdate)
	e:SetScript('OnEvent',  OnEvent)

	SLASH_PROCESSCAST1 = '/pct'
	SlashCmdList['PROCESSCAST'] = function(msg)
		for k, v in pairs(buffList) do
			print(v.caster .. ' ' .. v.spell)
		end
		print(' test')
	end

    --
