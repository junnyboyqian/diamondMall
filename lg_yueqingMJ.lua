local logic = {}

local maxPlayers

local gameState

local specialseat = 0


local cardsArray

local playerCards

local function is_dragon_three(numbers)
	local dragon = 0
	for i = 1, 9 do
		if numbers[i] > 2 then
            numbers[i] = numbers[i] - 3
        end
        
		if numbers[i] > 0 and numbers[i] < 3 then
			dragon = dragon + 3 - numbers[i]
		end
	end
	return dragon
end

local function is_dragon_three_ex(counts)
	local dragon = 0
	local numbers = {counts[1],counts[2],counts[3],counts[4],counts[5],counts[6],counts[7],counts[8],counts[9], 0, 0}
	for i = 1, 9 do
		if numbers[i] > 2 then
			numbers[i] = numbers[i] - 3
		end

		if numbers[i] > 1 then
			local num = numbers[i]
			numbers[i] = 0
			local dragon1 = 1 + is_dragon_three_ex(numbers)

			local dragon2 = 0
			if num > numbers[i+1] then
				dragon2 = dragon2 + num - numbers[i+1]
				numbers[i+1] = 0
			else
				numbers[i+1] = numbers[i+1] - num
			end
			if num > numbers[i+2] then
				dragon2 = dragon2 + num - numbers[i+2]
				numbers[i+2] = 0
			else
				numbers[i+2] = numbers[i+2] - num
			end
			dragon2 = dragon2 + is_dragon_three_ex(numbers)

			if dragon1 > dragon2 then
				return dragon + dragon2
			else
				return dragon + dragon1
			end
		elseif numbers[i] >  0 then
			if numbers[i] > numbers[i+1] then
				dragon = dragon + numbers[i] - numbers[i+1]
				numbers[i+1] = 0
			else
				numbers[i+1] = numbers[i+1] - numbers[i]
			end
			if numbers[i] > numbers[i+2] then
				dragon = dragon + numbers[i] - numbers[i+2]
				numbers[i+2] = 0
			else
				numbers[i+2] = numbers[i+2] - numbers[i]
			end
			numbers[i] = 0
		end	
	end
	return dragon
end

local function is_dragon_add(counts)
	local numbers = {counts[1],counts[2],counts[3],counts[4],counts[5],counts[6],counts[7],counts[8],counts[9]}
	local dragon = is_dragon_three(numbers)
	local result = 2 + dragon
	for i = 1, 9 do
		if numbers[i] > 1 then
			numbers[i] = numbers[i] - 2
			local temp = is_dragon_three(numbers)
			if temp < result then
				result = temp
			end
			numbers[i] = numbers[i] + 2
		elseif numbers[i] > 0 then
			numbers[i] = 0
			local temp = 1 + is_dragon_three(numbers)
			if temp < result then
				result = temp
			end
			numbers[i] = 1
		end
	end
	return result, dragon
end

local function is_dragon_add_ex(counts)
	local numbers = {counts[1],counts[2],counts[3],counts[4],counts[5],counts[6],counts[7],counts[8],counts[9]}
	local dragon = is_dragon_three_ex(numbers)
	local result = 2 + dragon
	for i = 1, 9 do
		if numbers[i] > 1 then
			numbers[i] = numbers[i] - 2
			local temp = is_dragon_three_ex(numbers)
			if temp < result then
				result = temp
			end
			numbers[i] = numbers[i] + 2
		elseif numbers[i] > 0 then
			numbers[i] = 0
			local temp = 1 + is_dragon_three_ex(numbers)
			if temp < result then
				result = temp
			end
			numbers[i] = 1
		end
	end
	return result, dragon
end

local function check_dragon_hun(seat, out)
	local count = #playerCards[seat].cards

	if count == 0 then
		return false
	end

	local dragon = 0
	local ban = 0
	local cards = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
	for i = 1, count do
		local card = playerCards[seat].cards[i]
		if card == gameState.dragon then
			dragon = dragon + 1
		else
			local pos = math.floor(card/16)
			local val = card % 16
			if pos > 0 and pos < 5 and val > 0 and val < 10 then
				cards[pos][val] = cards[pos][val] + 1
			end
		end
	end

	if out > 0 then
		local pos = math.floor(out/16)
		local val = out % 16
		if pos > 0 and pos < 5 and val > 0 and val < 10 then
			cards[pos][val] = cards[pos][val] + 1
		end
	end

	local dragon_pos = math.floor(gameState.dragon/16)
	local dragon_val = gameState.dragon % 16
	if dragon_pos > 0 and dragon_pos < 5 and dragon_val > 0 and dragon_val < 10 then
		for n = 0, ban do
			local result = {{0, 0}, {0, 0}, {0, 0}, {0, 0}}
			local temp = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
			for i = 1, 4 do
				for j = 1, 9 do
					temp[i][j] = cards[i][j]
				end
			end
			for i = 1, ban do
				if i <= n then
					temp[dragon_pos][dragon_val] = temp[dragon_pos][dragon_val] + 1
				else
					temp[4][7] = temp[4][7] + 1
				end
			end
			for i = 1, 4 do
				if i < 4 then
					result[i][1], result[i][2] = is_dragon_add_ex(temp[i])
				else
					result[i][1], result[i][2] = is_dragon_add(temp[i])
				end
			end
			for i = 1, 4 do
				local num = 0
				for j = 1, 4 do
					if i == j then
						num = num + result[j][1]
					else
						num = num + result[j][2]
					end
				end
				if dragon >= num then
					return true
				end
			end
		end
	end
	
	return false
end

local function check_can_hun(dragon, ban, number)
	local dragon_pos = math.floor(gameState.dragon/16)
	local dragon_val = gameState.dragon % 16
	if dragon_pos > 0 and dragon_pos < 5 and dragon_val > 0 and dragon_val < 10 then
		for n = 0, ban do
			local result = {{0, 0}, {0, 0}, {0, 0}, {0, 0}}
			local temp = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
			for i = 1, 4 do
				for j = 1, 9 do
					temp[i][j] = number[i][j]
				end
			end
			for i = 1, ban do
				if i <= n then
					temp[dragon_pos][dragon_val] = temp[dragon_pos][dragon_val] + 1
				else
					temp[4][7] = temp[4][7] + 1
				end
			end
			for i = 1, 4 do
				if i < 4 then
					result[i][1], result[i][2] = is_dragon_add_ex(temp[i])
				else
					result[i][1], result[i][2] = is_dragon_add(temp[i])
				end
			end
			for i = 1, 4 do
				local num = 0
				for j = 1, 4 do
					if i == j then
						num = num + result[j][1]
					else
						num = num + result[j][2]
					end
				end
				if dragon >= num then
					return true
				end
			end
		end
	end
	return false
end

local function check_hand_have(seat, cards)
	local temp = cards
	local count = #playerCards[seat].cards
	for i = 1, count do
		for j = 1, #temp do
			if playerCards[seat].cards[i] == temp[j] and temp[j] ~= gameState.dragon then
				table.remove(temp, j)
				break
			end
		end
	end
	return #temp == 0
end

local function check_hand_have_replace(seat, cards)
	local dragon = 0
	local temp = cards
	local count = #playerCards[seat].cards
	for i = 1, count do
		if playerCards[seat].cards[i] ~= gameState.dragon then
			for j = 1, #temp do
				if playerCards[seat].cards[i] == temp[j] and temp[j] ~= gameState.dragon then
					table.remove(temp, j)
					break
				end
			end
		end
	end
	return #temp == 0 and dragon > 0
end

local function check_group_card(cards)
	local group = 0
	local count = #cards
	for i = 1, count do
		local temp = math.floor(cards[i]/16)
		if group > 0 then
			if group ~= temp then
				return false
			end
		else
			group = temp
		end

		temp = cards[i] % 16
		if temp < 1 or temp > 9 then
			return false
		end
	end
	return true
end

local function select_respon_hun()
	local index = 0
	for i = 1, maxPlayers do
		local cur = (gameState.current - 1 + i) % maxPlayers + 1
		local count = #playerCards[cur].respon
		for j = 1, count do
			if playerCards[cur].respon[j].combin == "hun" then
				index = i
				break
			end
		end
		if index > 0 then
			break
		end
	end

	for i = 1, maxPlayers do
		local cur = (gameState.current - 1 + i) % maxPlayers + 1
		local count = #gameState.combin
		for j = 1, count do
			if gameState.combin[j].combin == "hun" and gameState.combin[j].seat == cur then
				if index > 0 and i > index then
					return false, nil
				end
				return true, gameState.combin[j]
			end
		end
	end
	return index == 0, nil
end

local function select_respon_combin()
	local count = #gameState.combin
	if count > 0 then
		for i = 1, count do
			if gameState.combin[i].combin == "peng"  or  gameState.combin[i].combin == "gang" then
				return true, gameState.combin[i]
			end
		end

		for i = 1, maxPlayers do
			local number = #playerCards[i].respon
			for j = 1, number do
				if playerCards[i].respon[j].combin == "peng" or playerCards[i].respon[j].combin == "gang" then
					return false, nil
				end
			end
		end

		return true, gameState.combin[1]
	end

	for i = 1, maxPlayers do
		if #playerCards[i].respon > 0 then
			return false, nil
		end
	end

	return true, nil
end

local function check_combin_respon()
	local ok, combin = select_respon_hun()
	if not ok then
		return nil
	end

	if combin == nil then
		ok, combin = select_respon_combin()
		if not ok then
			return nil
		end
	end

	gameState.current = 0
	gameState.combin = {}
	for i = 1, maxPlayers do
		playerCards[i].respon = {}
	end

	if combin ~= nil then
		return combin
	end
	return {combin="", card=0, out=0, seat=0, replace=0}
end

local function ignor_hun(seat)
	return false
end

local function init_card()
	cardsArray.index = 0
	cardsArray.number = 0

	for num = 1, 4 do
		for tp = 1, 4 do
			for val = 1, 9 do
				local card = tp*16 + val

				if tp < 4 then
					cardsArray.number = cardsArray.number + 1
					cardsArray.cards[cardsArray.number] = card
				elseif val < 8 then
					cardsArray.number = cardsArray.number + 1
					cardsArray.cards[cardsArray.number] = card
				end
			end
		end
	end

	for count = 1, 3 do
		for pos = 1, cardsArray.number do
			local ran = math.random(cardsArray.number)
			if pos ~= ran then
				local card = cardsArray.cards[pos]
				cardsArray.cards[pos] = cardsArray.cards[ran]
				cardsArray.cards[ran] = card
			end
		end
	end


	-- local function test_first_player_cards(cards, show)
	-- 	for i=1,#cards do
	-- 		local x = math.floor((i-1) / 4) * 16 + ((i-1) % 4) + 1
	-- 		if i > 20 then
	-- 			x = 68 + (i - 20)
	-- 		end
	-- 		cardsArray.cards[x] = cards[i]
	-- 	end

	-- 	cardsArray.cards[cardsArray.number] = show
	-- end

	-- test_first_player_cards({
	-- 		2*16+3,
	-- 		2*16+4,
	-- 		2*16+5,
	-- 		2*16+6,
	-- 		2*16+7,
	-- 		2*16+2,
	-- 		2*16+2,
	-- 		2*16+7,
	-- 		2*16+7,
	-- 		2*16+9,
	-- 		2*16+9,
	-- 		4*16+3,
	-- 		4*16+3,
	-- 		4*16+3,
	-- 		4*16+3,
	-- 	},
	-- 2*16+8)
end

local function decide_banker(seat)
	if seat > 0 then
		gameState.banker = seat
	else
		gameState.banker = math.random(maxPlayers)
	end
end

local function decide_dragon()
	local card = cardsArray.cards[cardsArray.number]
	local val = card % 16

	if card > 16*4 then
		if val < 7 then
			gameState.dragon = card + 1
		else
			gameState.dragon = card - 6
		end
	else
		if val < 9 then
			gameState.dragon = card + 1
		else
			gameState.dragon = card - 8
		end
	end
	gameState.show = card
	return card
end

local function combin_three_exx(index, dragons, count)
	local result = {}
	local result_list = {}

	local total = 0
	local number = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for i = 1, 9 do
		total = total + count[i]
		number[i] = count[i]
	end

	if total == 0 then
		return dragons==0, {}
	end

	for i = 1, 9 do
		if number[i] > 4 then
			return false, {}
		end

		if number[i] > 0 then
			local ok_1 = false
			local ok_2 = false
			local ok_3 = false
			local combin = {}
			local num = number[i]
			if num > 0 then
				if num + dragons > 2 then
					if num > 2 then
						number[i] = num - 3
						ok_1, combin = combin_three_exx(index, dragons, number)
					else
						number[i] = 0
						ok_1, combin = combin_three_exx(index, dragons - (3 - num), number)
					end	

					if ok_1 then
						local len = #combin
						for j = 0, len do
							local temp = {}
							if 16*index+i == gameState.dragon then
								temp[#temp+1] = {combin="peng", card=16*index+i, replace=3-num}
							else
								temp[#temp+1] = {combin="peng", card=16*index+i, replace=3-num}
							end
							for k = 1, #result do
								temp[#temp+1] = result[k]
							end
							if j > 0 and #combin[j] > 0 then
								for k = 1, #combin[j] do
									temp[#temp+1] = combin[j][k]
								end
							end
							if #temp > 0 then
								if len > 0 and j > 0 then
									result_list[#result_list+1] = temp
								elseif len == 0 and j == 0 then
									result_list[#result_list+1] = temp
								end
							end
						end
					end
				end

				number[i] = 0
				local dragon1 = 0 
				if number[i+1] >= num then
					number[i+1] = number[i+1] - num
				else
					dragon1 = (num - number[i+1])
					number[i+1] = 0
				end

				local dragon2 = 0 
				if  number[i+2] >= num then
					number[i+2] = number[i+2] - num
				else
					dragon2 = (num - number[i+2])
					number[i+2] = 0
				end

				if dragons >= dragon1+dragon2 then
					ok_2, combin = combin_three_exx(index, dragons-(dragon1+dragon2), number)
					if ok_2 then
						local len = #combin
						for j = 0, len do
							local temp = {}
							if i == 1 then
								if num > 3 then
									local replace = 0
									local not_replace = false
									if dragon1 > 3 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 3 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 2 then
									local replace = 0
									local not_replace = false
									if dragon1 > 2 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 2 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 1 then
									local replace = 0
									local not_replace = false
									if dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 1 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 0 then
									local replace = 0
									local not_replace = false
									if dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 0 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
								end
							elseif i == 2 then
								if num > 3 then
									local replace = 0
									local not_replace = false
									if dragon1 > 3 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 3 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 2 then
									local replace = 0
									local not_replace = false
									if dragon1 > 2 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 2 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 1 then
									local replace = 0
									local not_replace = false
									if dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 1 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 0 then
									local replace = 0
									local not_replace = false
									if dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 0 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
							elseif i < 8 then
								if num > 3 then
									local replace = 0
									local not_replace = false
									if dragon1 > 3 and dragon2 > 3 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											not_replace = true
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1, not_replace=not_replace}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1, not_replace=not_replace}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2, not_replace=not_replace}
										end
									elseif dragon1 > 3 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									elseif dragon2 > 3 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 2 then
									local replace = 0
									local not_replace = false
									if dragon1 > 2 and dragon2 > 2 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											not_replace = true
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1, not_replace=not_replace}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1, not_replace=not_replace}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2, not_replace=not_replace}
										end
									elseif dragon1 > 2 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									elseif dragon2 > 2 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 1 then
									local replace = 0
									local not_replace = false
									if dragon1 > 1 and dragon2 > 1 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											not_replace = true
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1, not_replace=not_replace}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1, not_replace=not_replace}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2, not_replace=not_replace}
										end
									elseif dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									elseif dragon2 > 1 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 0 then
									local replace = 0
									local not_replace = false
									if dragon1 > 0 and dragon2 > 0 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											not_replace = true
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1, not_replace=not_replace}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1, not_replace=not_replace}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2, not_replace=not_replace}
										end
									elseif dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									elseif dragon2 > 0 then
										if index*16+i-1 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
							elseif i == 8 then
								if num > 3 then
									local replace = 0
									local not_replace = false
									if dragon2 > 3 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end

									if dragon1 > 3 then
										if index*16+i-2 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 2 then
									local replace = 0
									local not_replace = false
									if dragon2 > 2 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
											else
												not_replace = true
										end
									end

									if dragon1 > 2 then
										if index*16+i-2 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 1 then
									local replace = 0
									local not_replace = false
									if dragon2 > 1 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end

									if dragon1 > 1 then
										if index*16+i-2 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
									end
								end
								if num > 0 then
									local replace = 0
									local not_replace = false
									if dragon2 > 0 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon1 > 0 then
										if index*16+i-2 == gameState.dragon then
											not_replace = true
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											else
												not_replace = true
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace, not_replace=not_replace}
									end
									
								end
							elseif i == 9 then
								if num > 3 then
									local replace = 0
									local not_replace = false
									if dragon1 > 3 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 3 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 2 then
									local replace = 0
									local not_replace = false
									if dragon1 > 2 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 2 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 1 then
									local replace = 0
									local not_replace = false
									if dragon1 > 1 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 1 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
								end
								if num > 0 then
									local replace = 0
									local not_replace = false
									if dragon1 > 0 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									if dragon2 > 0 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										else
											not_replace = true
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace, not_replace=not_replace}
								end
							end
							for k = 1, #result do
								temp[#temp+1] = result[k]
							end
							if j > 0 and #combin[j] > 0 then
								for k = 1, #combin[j] do
									temp[#temp+1] = combin[j][k]
								end
							end
							if #temp > 0 then
								if len > 0 and j > 0 then
									result_list[#result_list+1] = temp
								elseif len == 0 and j == 0 then
									result_list[#result_list+1] = temp
								end
							end
						end
					end
				end
			else
				ok_3, combin = combin_three_exx(index, dragons, number)
				if ok_3 then
					local len = #combin
					for j = 0, len do
						local temp = {}
						for k = 1, #result do
							temp[#temp+1] = result[k]
						end
						if j > 0 and #combin[j] > 0 then
							for k = 1, #combin[j] do
								temp[#temp+1] = combin[j][k]
							end
						end
						if #temp > 0 then
							if len > 0 and j > 0 then
								result_list[#result_list+1] = temp
							elseif len == 0 and j == 0 then
								result_list[#result_list+1] = temp
							end
						end
					end
				end
			end
			return ok_1 or ok_2 or ok_3, result_list
		end
	end

	return false, {}

end

local function combin_three_ex(index, dragons, count)
	local result = {}
	local result_list = {}

	local total = 0
	local number = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for i = 1, 9 do
		total = total + count[i]
		number[i] = count[i]
	end

	if total == 0 then
		return dragons==0, {}
	end

	for i = 1, 9 do
		if number[i] > 4 then
			return false, {}
		end

		if number[i] > 0 then
			if number[i] > 2 then
				number[i] = number[i] - 3
				result[#result+1] = {combin="peng", card=16*index+i, replace=0}
			end

			local ok_1 = false
			local ok_2 = false
			local ok_3 = false
			local combin = {}
			local num = number[i]
			if num > 0 then
				number[i] = 0
				if num + dragons > 2 then	
					ok_1, combin = combin_three_ex(index, dragons - (3 - num), number)
					if ok_1 then
						local len = #combin
						for j = 0, len do
							local temp = {}
							if 16*index+i == gameState.dragon then
								temp[#temp+1] = {combin="peng", card=16*index+i, replace=3-num}
							else
								temp[#temp+1] = {combin="peng", card=16*index+i, replace=3-num}
							end
							for k = 1, #result do
								temp[#temp+1] = result[k]
							end
							if j > 0 and #combin[j] > 0 then
								for k = 1, #combin[j] do
									temp[#temp+1] = combin[j][k]
								end
							end
							if #temp > 0 then
								if len > 0 and j > 0 then
									result_list[#result_list+1] = temp
								elseif len == 0 and j == 0 then
									result_list[#result_list+1] = temp
								end
							end
						end
					end
				end

				local dragon1 = 0 
				if number[i+1] >= num then
					number[i+1] = number[i+1] - num
				else
					dragon1 = (num - number[i+1])
					number[i+1] = 0
				end

				local dragon2 = 0 
				if  number[i+2] >= num then
					number[i+2] = number[i+2] - num
				else
					dragon2 = (num - number[i+2])
					number[i+2] = 0
				end

				if dragons >= dragon1+dragon2 then
					ok_2, combin = combin_three_ex(index, dragons-(dragon1+dragon2), number)
					if ok_2 then
						local len = #combin
						for j = 0, len do
							local temp = {}
							if i == 1 then
								if num > 1 then
									local replace = 0
									if dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 1 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
								end
								if num > 0 then
									local replace = 0
									if dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 0 then
										if index*16+i+2 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
								end
							elseif i == 2 then
								if num > 1 then
									local replace = 0
									if dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 1 then
										if index*16+i-1 == gameState.dragon then
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									end
								end
								if num > 0 then
									local replace = 0
									if dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 0 then
										if index*16+i-1 == gameState.dragon then
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									end
								end
							elseif i < 8 then
								if num > 1 then
									local replace = 0
									if dragon1 > 1 and dragon2 > 1 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2}
										end
									elseif dragon1 > 1 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									elseif dragon2 > 1 then
										if index*16+i-1 == gameState.dragon then
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									end
								end
								if num > 0 then
									local replace = 0
									if dragon1 > 0 and dragon2 > 0 then
										if gameState.dragon >= 16*index+i+1 and gameState.dragon <= 16*index+i+2 then
											temp[#temp+1] = {combin="left", card=16*index+i, replace=1}
										elseif gameState.dragon >= 16*index+i-2 and gameState.dragon <= 16*index+i-1 then
											temp[#temp+1] = {combin="right", card=16*index+i, replace=1}
										else
											temp[#temp+1] = {combin="left", card=16*index+i, replace=2}
										end
									elseif dragon1 > 0 then
										if index*16+i+1 ~= gameState.dragon then
											replace = replace + 1
										end
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									elseif dragon2 > 0 then
										if index*16+i-1 == gameState.dragon then
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										else
											if index*16+i+2 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="left", card=16*index+i, replace=replace}
									end
								end
							elseif i == 8 then
								if num > 1 then
									local replace = 0
									if dragon2 > 1 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										end
									end

									if dragon1 > 1 then
										if index*16+i-2 == gameState.dragon then
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
									end
								end
								if num > 0 then
									local replace = 0
									if dragon2 > 0 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon1 > 0 then
										if index*16+i-2 == gameState.dragon then
											temp[#temp+1] = {combin="right", card=16*index+i, replace=replace}
										else
											if index*16+i+1 ~= gameState.dragon then
												replace = replace + 1
											end
											temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
										end
									else
										temp[#temp+1] = {combin="center", card=16*index+i, replace=replace}
									end
									
								end
							elseif i == 9 then
								if num > 1 then
									local replace = 0
									if dragon1 > 1 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 1 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace}
								end
								if num > 0 then
									local replace = 0
									if dragon1 > 0 then
										if index*16+i-1 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									if dragon2 > 0 then
										if index*16+i-2 ~= gameState.dragon then
											replace = replace + 1
										end
									end
									temp[#temp+1] = {combin="right", card=16*index+i, replace=replace}
								end
							end
							for k = 1, #result do
								temp[#temp+1] = result[k]
							end
							if j > 0 and #combin[j] > 0 then
								for k = 1, #combin[j] do
									temp[#temp+1] = combin[j][k]
								end
							end
							if #temp > 0 then
								if len > 0 and j > 0 then
									result_list[#result_list+1] = temp
								elseif len == 0 and j == 0 then
									result_list[#result_list+1] = temp
								end
							end
						end
					end
				end
			else
				ok_3, combin = combin_three_ex(index, dragons, number)
				if ok_3 then
					local len = #combin
					for j = 0, len do
						local temp = {}
						for k = 1, #result do
							temp[#temp+1] = result[k]
						end
						if j > 0 and #combin[j] > 0 then
							for k = 1, #combin[j] do
								temp[#temp+1] = combin[j][k]
							end
						end
						if #temp > 0 then
							if len > 0 and j > 0 then
								result_list[#result_list+1] = temp
							elseif len == 0 and j == 0 then
								result_list[#result_list+1] = temp
							end
						end
					end
				end
			end
			return ok_1 or ok_2 or ok_3, result_list
		end
	end

	return false, {}
end

local function combin_three(dragons, count)
	local result = {}
	local dragon = dragons
	local number = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for i = 1, 7 do
		number[i] = count[i]
	end
	for i = 1, 7 do
		if number[i] > 2 then
			number[i] = number[i] - 3
			result[#result+1] = {combin="peng", card=16*4+i, replace=0}
		end
		if number[i] > 1 then
			if dragon > 0 then
				number[i] = 0
				dragon = dragon - 1
				if gameState.dragon == 16*4+i then
					result[#result+1] = {combin="peng", card=16*4+i, replace=1}
				else
					result[#result+1] = {combin="peng", card=16*4+i, replace=1}
				end
			else
				return false, {}
			end
		elseif number[i] > 0 then
			if dragon > 1 then
				number[i] = 0
				dragon = dragon - 2
				if gameState.dragon == 16*4+i then
					result[#result+1] = {combin="peng", card=16*4+i, replace=2}
				else
					result[#result+1] = {combin="peng", card=16*4+i, replace=2}
				end
			else
				return false, {}
			end
		end
	end

	if dragon==0 then
		if #result > 0 then
			return true, {result}
		end
		return true, {}
	end

	return false, {}
end

local function result_three_combin(combin1, combin2)
	if #combin1 > 0 and #combin2 > 0 then
		local result = {}
		for i = 1, #combin1 do
			for j = 1, #combin2 do
				local temp = {}
				for n = 1, #combin1[i] do
					temp[#temp+1] = combin1[i][n]
				end
				for n = 1, #combin2[j] do
					temp[#temp+1] = combin2[j][n]
				end
				result[#result+1] = temp
			end
		end
		return result
	elseif #combin1 > 0 then
		return combin1
	elseif #combin2 > 0 then
		return combin2
	end
	return {}
end

local function hun_three_combin(dragons, counts)
	local result = {}
	local dragon = dragons
	for i_1 = 0, dragon do
		local ok_1, combin_1 = combin_three_exx(1, i_1, counts[1])
		if ok_1 then
			for i_2 = 0, dragon-i_1 do
				local ok_2, combin_2 = combin_three_exx(2, i_2, counts[2])
				if ok_2 then
					for i_3 = 0, dragon-i_1-i_2 do
						local ok_3, combin_3 = combin_three_exx(3, i_3, counts[3])
						if ok_3 then
							for i_4 = 0, dragon-i_1-i_2-i_3 do
								local ok_4, combin_4 = combin_three(i_4, counts[4])
								if ok_4 and i_1+i_2+i_3+i_4==dragon then
									local combins = result_three_combin(combin_1, combin_2)
									combins = result_three_combin(combins, combin_3)
									combins = result_three_combin(combins, combin_4)
									for n = 1, #combins do
										result[#result+1] = combins[n]
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return result
end

local function hun_three_combin_ex(dragons, counts)
	local  result = {}
	local dragon = dragons
	if dragon > 2 then
		dragon = dragon - 3
		local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
		for i = 1, 4 do
			for j = 1, 9 do
				number[i][j] = counts[i][j]
			end
		end
		local combins = hun_three_combin(dragon, number)
		for i = 1, 4 do
			for j = 1, 9 do
				if i < 4 or j < 8 then
					for n = 1, #combins do
						local temp = {}
						if 16*i+j == gameState.dragon then
							temp[#temp+1] = {combin="peng", card=16*i+j , replace=3}
						else
							temp[#temp+1] = {combin="peng", card=16*i+j , replace=3}
						end
						for m = 1, #combins[n] do
							temp[#temp+1] = combins[n][m]
						end
						result[#result+1] = temp
					end
				end
			end
		end
	end

	dragon = dragons
	local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
	for i = 1, 4 do
		for j = 1, 9 do
			number[i][j] = counts[i][j]
		end
	end
	local combins = hun_three_combin(dragon, number)
	for i = 1, #combins do
		result[#result+1] = combins[i]
	end
	return result
end

local function hun_common_combin(dragons, counts)
	local result = {}
	for i = 1, 4 do
		for j = 1, 9 do
			if i < 4 or j < 8 then
				local dragon = dragons
				local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
				local card_num = 0
				for m = 1, 4 do
					for n = 1, 9 do
						number[m][n] = counts[m][n]
						card_num = card_num + number[m][n]
					end
				end
				local combin = nil
				if number[i][j] > 1 then
					number[i][j] = number[i][j] - 2
					combin = {combin="dui", card=16*i+j, replace=0}
					card_num = card_num - 2
				elseif number[i][j] > 0 and dragon > 0 then
					number[i][j] = number[i][j] - 1
					dragon = dragon - 1
					if gameState.dragon == 16*i+j then
						combin = {combin="dui", card=16*i+j, replace=1}
					else
						combin = {combin="dui", card=16*i+j, replace=1}
					end
					card_num = card_num - 1
				end
				if combin ~= nil then
					local combins = hun_three_combin_ex(dragon, number)
					for i = 1, #combins do
						combins[i][#combins[i]+1]  = combin
						result[#result+1] = combins[i]
					end
					if card_num == 0 then
						result[#result+1] = {combin}
					end
				end
			end
		end
	end

	if dragons > 1 then
		local dragon = dragons - 2
		local combin = {combin="dui", card=gameState.dragon, replace=2}
		local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
		local card_num = 0
		for i = 1, 4 do
			for j = 1, 9 do
				number[i][j] = counts[i][j]
				card_num = card_num + number[i][j]
			end
		end
		local combins = hun_three_combin_ex(dragon, number)
		for i = 1, #combins do
			combins[i][#combins[i]+1]  = combin
			result[#result+1] = combins[i]
		end
		if card_num == 0 then
			result[#result+1] = {combin}
		end
	end

	return result
end

local function hun_combin_list(card, dragons, ban, counts)
	local result = {}
	local dragon_pos = math.floor(gameState.dragon/16)
	local dragon_val = gameState.dragon % 16
	if dragon_pos > 0 and dragon_pos < 5 and dragon_val > 0 and dragon_val < 10 then
		for n = 0, ban do
			local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
			for i = 1, 4 do
				for j = 1, 9 do
					number[i][j] = counts[i][j]
				end
			end
			
			local dragon = dragons
			local combins = hun_common_combin(dragon, number)
			for i = 1, #combins do
				result[#result+1] = combins[i]
			end

			if card > 0 and card == gameState.dragon then
				for i = 1, 3 do
					for j = 1, 7 do
						for m = 1, 4 do
							for n = 1, 9 do
								number[m][n] = counts[m][n]
							end
						end
						local dragon = 1
						local replace = 0
						if 16*i+j ~= gameState.dragon then
							replace = replace + 1
						end
						if number[i][j+1] > 0 then
							number[i][j+1] = number[i][j+1] - 1
						else
							dragon = dragon + 1
							if 16*i+j+1 ~= gameState.dragon then
								replace = replace + 1
							end
						end
						if number[i][j+2] > 0 then
							number[i][j+2] = number[i][j+2] - 1
						else
							dragon = dragon + 1
							if 16*i+j+2 ~= gameState.dragon then
								replace = replace + 1
							end
						end
						if dragon > 0 and dragon < 3 and dragons >= dragon then
							local combins = hun_common_combin(dragons-dragon, number)
							for t = 1, #combins do
								combins[t][#combins[t]+1]  = {combin="left", card=16*i+j, replace=replace}
								result[#result+1] = combins[t]
							end
						end
					end
				end
			end

			if card > 0 and card == gameState.dragon then
				for i = 1, 3 do
					for j = 3, 9 do
						for m = 1, 4 do
							for n = 1, 9 do
								number[m][n] = counts[m][n]
							end
						end
						local dragon = 1
						local replace = 0
						if 16*i+j ~= gameState.dragon then
							replace = replace + 1
						end
						if number[i][j-1] > 0 then
							number[i][j-1] = number[i][j-1] - 1
						else
							dragon = dragon + 1
							if 16*i+j-1 ~= gameState.dragon then
								replace = replace + 1
							end
						end
						if number[i][j-2] > 0 then
							number[i][j-2] = number[i][j-2] - 1
						else
							dragon = dragon + 1
							if 16*i+j-2 ~= gameState.dragon then
								replace = replace + 1
							end
						end
						if dragon > 0 and dragon < 3 and dragons >= dragon then
							local combins = hun_common_combin(dragons-dragon, number)
							for t = 1, #combins do
								combins[t][#combins[t]+1]  = {combin="right", card=16*i+j, replace=replace}
								result[#result+1] = combins[t]
							end
						end
					end
				end
			end

			if card > 0 and card ~= gameState.dragon then
				for i = 1, 4 do
					for j = 1, 9 do
						number[i][j] = counts[i][j]
					end
				end

				local combin = nil
				local center = 0
				dragon = dragons
				if card < 16*4 then
					local val = card % 16
					local pos = math.floor(card/16)
					if pos > 0 and pos < 4 and val > 1 and val < 9 then
						if card == gameState.dragon then
							if dragons > 0 then
								dragon = dragons - 1
								center = card
							end
						else
							if number[pos][val] > 0 then
								number[pos][val] = number[pos][val] - 1
								center = card
							end
						end
					end
				end
				local val = center % 16
				local pos = math.floor(center/16)
				if pos > 0 and pos < 4 and val > 0 and val < 8 then
					if number[pos][val+1] > 0 and number[pos][val+2] > 0 then
						number[pos][val+1] = number[pos][val+1] - 1
						number[pos][val+2] = number[pos][val+2] - 1
						combin = {combin="left", card=card, replace=0}
					elseif number[pos][val+1] > 0 and dragon > 0 then
						number[pos][val+1] = number[pos][val+1] - 1
						dragon = dragon - 1
						combin = {combin="left", card=card, replace=1}
					elseif number[pos][val+2] > 0 and dragon > 0 then
						number[pos][val+2] = number[pos][val+2] - 1
						dragon = dragon - 1
						combin = {combin="left", card=card, replace=1}
					elseif dragon > 1 then
						dragon = dragon - 2
						combin = {combin="left", card=card, replace=2}
					end
				end
				if combin ~= nil then
					local combins = hun_common_combin(dragon, number)
					for i = 1, #combins do
						combins[i][#combins[i]+1]  = combin
						result[#result+1] = combins[i]
					end
				end
			end

			if card > 0 and card ~= gameState.dragon then
				for i = 1, 4 do
					for j = 1, 9 do
						number[i][j] = counts[i][j]
					end
				end

				local combin = nil
				local center = 0
				dragon = dragons
				if card < 16*4 then
					local val = card % 16
					local pos = math.floor(card/16)
					if pos > 0 and pos < 4 and val > 1 and val < 9 then
						if card == gameState.dragon then
							if dragons > 0 then
								dragon = dragons - 1
								center = card
							end
						else
							if number[pos][val] > 0 then
								number[pos][val] = number[pos][val] - 1
								center = card
							end
						end
					end
				end
				local val = center % 16
				local pos = math.floor(center/16)
				if pos > 0 and pos < 4 and val > 2 and val < 9 then
					if number[pos][val-1] > 0 and number[pos][val-2] > 0 then
						number[pos][val-1] = number[pos][val-1] - 1
						number[pos][val-2] = number[pos][val-2] - 1
						combin = {combin="right", card=card, replace=0}
					elseif number[pos][val-1] > 0 and dragon > 0 then
						number[pos][val-1] = number[pos][val-1] - 1
						dragon = dragon - 1
						combin = {combin="right", card=card, replace=1}
					elseif number[pos][val-2] > 0 and dragon > 0 then
						number[pos][val-2] = number[pos][val-2] - 1
						dragon = dragon - 1
						combin = {combin="right", card=card, replace=1}
					elseif dragon > 1 then
						dragon = dragon - 2
						combin = {combin="right", card=card, replace=2}
					end
				end
				if combin ~= nil then
					local combins = hun_common_combin(dragon, number)
					for i = 1, #combins do
						combins[i][#combins[i]+1]  = combin
						result[#result+1] = combins[i]
					end
				end
			end

		end
	end
	return result
end

local function changecard(seat,index)

	LOG_INFO("seat =%d,index=%d",seat,index)

	local dragon = gameState.dragon
	local opencard = gameState.show
	local flower   = 71 
	if dragon == flower then
		flower = 69
	end

	local card = 0
	local num = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}
	for i=1,#playerCards[seat].cards do
		card = playerCards[seat].cards[i]
		if card ~= dragon  and card ~= opencard and card ~= flower then
			local x = math.floor(card/16)
			local y = card % 16
			num[x][y] = num[x][y] + 1
		end
	end

	
	local x = 0
	local y = 0
	local sucess = false
	if index == 1 then
		-- 换财神
		for i=cardsArray.index,#cardsArray.cards do
			if cardsArray.cards[i] == dragon then
				for j=1,#playerCards[seat].cards do
					card = playerCards[seat].cards[j]
					x = math.floor(card/16)
					y = card % 16
			 		if num[x][y] <4 and card ~= dragon and card ~= opencard and card ~= flower then
						playerCards[seat].cards[j] = dragon
						cardsArray.cards[i] = card
						LOG_INFO("index =%d,card=%d,xcard=%d",index,card,dragon)
						sucess = true
						break
					end
				end
			end
			if sucess then
				break
			end
		end
	elseif index == 2 then
				-- 换明牌
		for i=cardsArray.index,cardsArray.number do
			if cardsArray.cards[i] == opencard and i ~= cardsArray.number then
				for j=1,#playerCards[seat].cards do
					card = playerCards[seat].cards[j]
					x = math.floor(card/16)
					y = card % 16
			 		if num[x][y] <4 and card ~= dragon and card ~= opencard and card ~= flower then
						playerCards[seat].cards[j] = opencard
						cardsArray.cards[i] = card
						LOG_INFO("index =%d,card=%d,xcard=%d,i=%d,j=%d",index,card,opencard,i,j)
						sucess = true
						break
					end
				end
			end
			if sucess then
				break
			end
		end
	end
	
end
-----------------------------------------------------------------------------------------------------------------
-- logic function
-----------------------------------------------------------------------------------------------------------------

function logic.start_game(max,spseat)
	maxPlayers = max
	specialseat = tonumber(spseat)

	--LOG_INFO("start specialseat=%d",specialseat)

	gameState = {banker=0, dragon=0, combin={}, current=0,show=0}
	cardsArray = {cards={}, number=0, index=0}
	playerCards = {}
	for i = 1, max do
		playerCards[i] = {respon={}, cards={}, combin={}, flower={}, out={}}
	end

	init_card()
end

function logic.end_game()
end

function logic.distribute_card()
	for num = 1, 4 do
		for pos = 1, maxPlayers do
			local seat = (gameState.banker - 1 + pos - 1) % maxPlayers + 1
			for i = 1, 4 do
				playerCards[seat].cards[#playerCards[seat].cards+1] = cardsArray.cards[cardsArray.index+i]
			end
			cardsArray.index = cardsArray.index + 4
		end
	end

	for pos = 1, maxPlayers do
		local seat = (gameState.banker - 1 + pos - 1) % maxPlayers + 1
		if seat == gameState.banker then
			for i = 1, 1 do
				playerCards[seat].cards[#playerCards[seat].cards+1] = cardsArray.cards[cardsArray.index+i]
			end
			cardsArray.index = cardsArray.index + 1
		end
	end

	LOG_INFO("specialseat=%d",specialseat)

	if specialseat < 1 or specialseat > maxPlayers then
		return
	end

	local dragon = gameState.dragon
	local opencard = gameState.show
	local flower   = 71 
	if dragon == flower then
		flower = 69
	end


	local sucess ={0,0,0,0}
	local num = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}

	-- 检查财神 名牌 花牌
	for i=1,#playerCards[specialseat].cards do
		if playerCards[specialseat].cards[i] == dragon then
			sucess[1] = sucess[1]+ 1
		end
		if playerCards[specialseat].cards[i] == opencard then
			sucess[2] = sucess[2]+1
		end

		if playerCards[specialseat].cards[i] == flower then
			sucess[3] = sucess[3]+1
		end
	end

	

	if sucess[1] <=0 then
		changecard(specialseat,1)
		changecard(specialseat,1)
	end

	if sucess[1] == 1 then
		changecard(specialseat,1)
	end

--	if sucess[2] <=0 then
--		changecard(specialseat,2)
--		changecard(specialseat,2)
--	end

--	if(sucess[2] == 1) then
--		changecard(specialseat,2)
--	end
end

function logic.decide_banker(seat)
	decide_banker(seat)
end

function logic.decide_dragon()
	return decide_dragon()
end

function logic.card_number()
	return cardsArray.number - cardsArray.index
end

function logic.get_banker_dragon()
	return gameState.banker, gameState.dragon
end

function logic.check_hand_card(seat)
	gameState.current = seat
	gameState.combin = {}
	for i = 1, maxPlayers do
		playerCards[i].respon = {}
	end
	
	
	local out = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}
	local num = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}

	local count = #playerCards[seat].combin
	for i = 1, count do
		if playerCards[seat].combin[i].combin == "peng" then
			local x = math.floor(playerCards[seat].combin[i].card/16)
			local y = playerCards[seat].combin[i].card % 16
			num[x][y] = num[x][y] + 3
			out[x][y] = playerCards[seat].combin[i].out
		end
	end

	count = #playerCards[seat].cards
	for i = 1, count do
		if playerCards[seat].cards[i] ~= gameState.dragon then
			local x = math.floor(playerCards[seat].cards[i]/16)
			local y = playerCards[seat].cards[i] % 16
			
			if x>0 and x<5 and y>0 and y<10 then
				num[x][y] = num[x][y] + 1
			end
		end
	end

	for i = 1, 4 do
		for j = 1, 9 do
			if num[i][j] > 3 then
				if out[i][j] > 0 then
					playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="gang", card=i*16+j, out=out[i][j], replace=0}
				else
					playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="gang", card=i*16+j, out=seat, replace=0}
				end
			end
		end
	end


	if check_dragon_hun(seat, 0) then
		playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="hun", card=0, out=seat, replace=0}
	end

	return playerCards[seat].respon
end

function logic.check_hand_gang(seat)
	gameState.current = seat
	gameState.combin = {}
	for i = 1, maxPlayers do
		playerCards[i].respon = {}
	end
	
	local out = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}
	local num = {{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0}}

	local count = #playerCards[seat].combin
	for i = 1, count do
		if playerCards[seat].combin[i].combin == "peng" then
			local x = math.floor(playerCards[seat].combin[i].card/16)
			local y = playerCards[seat].combin[i].card % 16
			num[x][y] = num[x][y] + 3
			out[x][y] = playerCards[seat].combin[i].out
		end
	end

	count = #playerCards[seat].cards
	for i = 1, count do
		if playerCards[seat].cards[i] ~= gameState.dragon then
			local x = math.floor(playerCards[seat].cards[i]/16)
			local y = playerCards[seat].cards[i] % 16

			if x>0 and x<5 and y>0 and y<10 then
				num[x][y] = num[x][y] + 1
			end
		end
	end

	for i = 1, 4 do
		for j = 1, 9 do
			if num[i][j] > 3 then
				if out[i][j] > 0 then
					playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="gang", card=i*16+j, out=out[i][j], replace=0}
				else
					playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="gang", card=i*16+j, out=seat, replace=0}
				end
			end
		end
	end

	return playerCards[seat].respon
end

function logic.add_hand_card(seat)
	-- local function test_first_add_card(seat, card)
	-- 	if seat == gameState.banker and cardsArray.index > 80 then
	-- 		return 16*2+9
	-- 	else
	-- 		return card
	-- 	end
	-- end

	local card = 0
	if cardsArray.index < cardsArray.number then
		card = cardsArray.cards[cardsArray.index+1]
		cardsArray.index = cardsArray.index + 1

		-- card = test_first_add_card(seat, card)
	end
	
	if card > 0 then
		playerCards[seat].cards[#playerCards[seat].cards+1] = card
	end

	return card
end

function logic.append_hand_card(seat, card)
	if card > 0 then
		playerCards[seat].cards[#playerCards[seat].cards+1] = card
	end
end

function logic.remove_hand_card(seat, card)
	local count = #playerCards[seat].cards
	for i = 1, count do
		if card == playerCards[seat].cards[i] then
			table.remove(playerCards[seat].cards, i)
			return true
		end
	end
	return false
end


function logic.get_hand_card(seat)
	return playerCards[seat].cards
end

function logic.get_hand_end(seat)
	return playerCards[seat].cards[#playerCards[seat].cards]
end

function logic.add_out_card(seat, card)
	playerCards[seat].out[#playerCards[seat].out+1] = card
end

function logic.get_out_card(seat)
	return playerCards[seat].out
end

function logic.add_combin_card(seat, combin, card, out, replace)
	playerCards[seat].combin[#playerCards[seat].combin+1] = {combin=combin, card=card, out=out, replace=replace}
end

function logic.add_combin_card_test(seat, combin, card, out, replace)
	-- playerCards[seat].combin[#playerCards[seat].combin+1] = {combin=combin, card=card, out=seat, replace=0}
end

function logic.remove_combin_card(seat, combin, card)
	local count = #playerCards[seat].combin
	for i = 1, count do
		if playerCards[seat].combin[i].combin == combin and playerCards[seat].combin[i].card == card then
			table.remove(playerCards[seat].combin, i)
			return true
		end
	end
	return false
end

function logic.get_combin_card(seat)
	return playerCards[seat].combin
end

function logic.add_flower_card(seat, card)
	playerCards[seat].flower[#playerCards[seat].flower+1] = card
end

function logic.get_flower_card(seat)
	return playerCards[seat].flower
end

function logic.check_gang_hun(seat, out, card)
	gameState.current = out
	gameState.combin = {}
	playerCards[seat].respon = {}

	if seat ~= out and card ~= gameState.dragon then
		if not ignor_hun(seat) and check_dragon_hun(seat, card) then
			playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="hun", card=card, out=out, replace=0}
		end
	end

	return playerCards[seat].respon
end


function logic.check_combin_card(seat, out, card)
	gameState.current = out
	gameState.combin = {}
	playerCards[seat].respon = {}

	if seat ~= out and card ~= gameState.dragon then
		if seat == out % maxPlayers + 1 then
			if card < 16*4 then
				if check_group_card({card, card+1, card+2}) then
					if check_hand_have(seat, {card+1, card+2}) then
						playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="left", card=card, out=out, replace=0}
					end
				end
				
				if check_group_card({card-1, card, card+1}) then
					if check_hand_have(seat, {card-1, card+1}) then
						playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="center", card=card, out=out, replace=0}
					end
				end

				if check_group_card({card-2, card-1, card}) then
					if check_hand_have(seat, {card-2, card-1}) then
						playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="right", card=card, out=out, replace=0}
					end
				end
			end
		end

		if check_hand_have(seat, {card, card}) then
			playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="peng", card=card, out=out, replace=0}
		end

		if check_hand_have(seat, {card, card, card}) then
			playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="gang", card=card, out=out, replace=0}
		end

		if not ignor_hun(seat) and check_dragon_hun(seat, card) then
			playerCards[seat].respon[#playerCards[seat].respon+1] = {combin="hun", card=card, out=out, replace=0}
		end
	end

	return playerCards[seat].respon
end

function logic.get_respon_combin(seat)
	return playerCards[seat].respon
end

function logic.ignore_combin(seat)
	playerCards[seat].respon = {}
	return check_combin_respon()
end

function logic.combin_card(seat, combin, card, replace)
	local count = #playerCards[seat].respon
	for i = 1, count do
		if playerCards[seat].respon[i].combin == combin and playerCards[seat].respon[i].card == card and playerCards[seat].respon[i].replace == replace then
			gameState.combin[#gameState.combin+1] = {seat=seat, combin=combin , card=card, out=playerCards[seat].respon[i].out, replace=playerCards[seat].respon[i].replace}
			playerCards[seat].respon = {}
			return check_combin_respon()
		end
	end
	return nil
end

function logic.hun_card(seat)
	local count = #playerCards[seat].respon
	for i = 1, count do
		if playerCards[seat].respon[i].combin == "hun" then
			gameState.combin[#gameState.combin+1] = {seat=seat, combin="hun", card=playerCards[seat].respon[i].card, out=playerCards[seat].respon[i].out, replace=playerCards[seat].respon[i].replace}
			playerCards[seat].respon = {}
			return check_combin_respon()
		end
	end
	return nil
end

function logic.hun_card_combin(seat)
	local cards = logic.get_hand_card(seat)
	local count = #cards
	if count < 2 then
		return {}
	end 

	--luadump(cards)

	--LOG_INFO("hun_card_combin size:%d,seat:%d",count,seat)

	local ban = 0
	local dragon = 0
	local end_card = cards[count]
	local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
	for i = 1, count do
		if cards[i] == gameState.dragon then
			dragon = dragon + 1
		else
			local p = math.floor(cards[i]/16)
			local v = cards[i] % 16
			if p > 0 and p < 5 and v > 0 and v < 10 then
				number[p][v] = number[p][v] + 1
			end
		end
	end

	if end_card == gameState.dragon then
		return hun_combin_list(end_card, dragon, ban, number)
	elseif end_card < 16*4 then
		return hun_combin_list(end_card, dragon, ban, number)
	else
		return hun_combin_list(0, dragon, ban, number)
	end

	return {}
end

--other out card add hand card
function logic.check_hun_card_combin(seat,card)
	local cards = logic.get_hand_card(seat)
	local count = #cards

	--LOG_INFO("check_hun_card_combin size:%d,seat:%d,card:%d",count,seat,card)

	--if count < 2 then
	--	return {}
	--end 

	local ban = 0
	local dragon = 0
	local end_card = cards[count]
	local number = {{0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}}
	for i = 1, count do
		if cards[i] == gameState.dragon then
			dragon = dragon + 1
		else
			local p = math.floor(cards[i]/16)
			local v = cards[i] % 16
			if p > 0 and p < 5 and v > 0 and v < 10 then
				number[p][v] = number[p][v] + 1
			end
		end
	end

	if card>0 then
		end_card = card;
		if card == gameState.dragon then
			dragon = dragon + 1
		else
			local p = math.floor(card/16)
			local v = card % 16
			if p > 0 and p < 5 and v > 0 and v < 10 then
				number[p][v] = number[p][v] + 1
			end
		end
	end

	if end_card == gameState.dragon then
		return hun_combin_list(end_card, dragon, ban, number)
	elseif end_card < 16*4 then
		return hun_combin_list(end_card, dragon, ban, number)
	else
		return hun_combin_list(0, dragon, ban, number)
	end

	return {}
end

function logic.check_can_hun(dragon, ban, number)
	return check_can_hun(dragon, ban, number)
end

return logic