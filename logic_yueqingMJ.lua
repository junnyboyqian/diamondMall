local skynet = require "skynet"
local logic = require 'lg_yueqingMJ'

local gameMode
local gameBase
local gameCount

local maxScore
local maxPlayers

local gamePlayers

local gameState
local playerState

local gameBanker

local  specialuid ={}

local _outed_cards

local game = {}

local function get_men_feng(seat)
	local pos = ((seat-1) + maxPlayers - (gameState.banker-1)) % maxPlayers + 1
	return 16*4 + pos
end

local function append_points(points, add)
	for i = 1, #add do
		points[#points+1] = add[i]
	end
end

local function is_duidui_hun(seat, combin)
	local outside = logic.get_combin_card(seat)
	for i = 1, #outside do
		if outside[i].combin ~= "peng" and outside[i].combin ~= "gang" then
			return false
		end
	end

	for i = 1, #combin do
		if combin[i].combin ~= "peng" and combin[i].combin ~= "dui" then
			return false
		end
	end

	return true
end

local function is_qingyise_hun(seat, combin)
	local se = 0
	local outside = logic.get_combin_card(seat)
	for i = 1, #outside do
		local s = math.floor(outside[i].card/16)
		if outside[i].card ~= gameState.dragon then
			if s == 4 then
				return false
			elseif se == 0 then
				se = s
			elseif se ~= s then
				return false
			end
		end
	end

	if #combin then
		for i = 1, #combin do
			local s = math.floor(combin[i].card/16)
			if combin[i].card ~= gameState.dragon then
				if s == 4 then
					return false
				elseif se == 0 then
					se = s
				elseif se ~= s then
					return false
				end
			end
		end
	end

	return true
end

local function is_hunyise_hun(seat, combin)
	local se = 0
	local outside = logic.get_combin_card(seat)
	for i = 1, #outside do
		local s = math.floor(outside[i].card/16)
		if s > 0 and s < 4 and outside[i].card ~= gameState.dragon then
			if se == 0 then
				se = s
			elseif se ~= s then
				return false
			end
		end
	end

	for i = 1, #combin do
		local s = math.floor(combin[i].card/16)
		if s > 0 and s < 4 and combin[i].card ~= gameState.dragon then
			if se == 0 then
				se = s
			elseif se ~= s then
				return false
			end
		end
	end
	
	return true
end

local function is_forbid_start()
	if gameState.forbid > 0 and gameState.forbid_num == 0 then
		return true
	end
	return false
end 

local function get_forbid_seat()
	return gameState.forbid
end

local function is_quanzi_hun(seat, combin)
	local outside = logic.get_combin_card(seat)
	for i = 1, #outside do
		if outside[i].card ~= gameState.dragon and outside[i].card < 16*4 then
			return false
		end
	end

	for i = 1, #combin do
		if combin[i].card < 16*4 then
			return false
		end
	end
	
	return true
end

local function is_four_bai(seat)
	local number = 0
	local flower = logic.get_flower_card(seat)
	for i = 1, #flower do
		if flower[i] == gameState.flower then
			number = number + 1
		end
	end
	return number > 3
end

local function count_base_flower(seat, combin_)
	local number = 0
	local points = {}

	local flower = logic.get_flower_card(seat)
	local num_show = 0
	local num_flower = 0
	for i = 1, #flower do
		if flower[i] == gameState.show then
			num_show = num_show + 1
		elseif flower[i] == gameState.flower then
			num_flower = num_flower + 1
		end
	end
	if num_show > 0 then
		number = number + num_show
		points[#points+1] = {hun="show", point=num_show}
	end
	if num_flower > 0 then
		
		if gameState.flower == 16*4+7 then
			number = number + num_flower
			points[#points+1] = {hun="bai", point=num_flower}
		elseif gameState.flower == 16*4+5 then
			number = number + num_flower
			points[#points+1] = {hun="zhong", point=num_flower}
		end
		
	end

	local num_dragon = 0
	local card = logic.get_hand_card(seat)
	for i = 1, #card do
		if card[i] == gameState.dragon then
			num_dragon = num_dragon + 1
		end
	end
	if num_dragon > 0 then
		number = number + num_dragon
		points[#points+1] = {hun="dragon", point=num_dragon}
	end

	local num_gang = 0
	local num_an = 0
	local feng = get_men_feng(seat)
	local combin = logic.get_combin_card(seat)
	for i = 1, #combin do
		if combin[i].combin == "peng" then
			if combin[i].card == feng then
				number = number + 1
				points[#points+1] = {hun="feng_peng", point=1}
			elseif combin[i].card == 16*4+5 then
				number = number + 1
				points[#points+1] = {hun="zhong_peng", point=1}
			elseif combin[i].card == 16*4+6 then
				number = number + 1
				points[#points+1] = {hun="fa_peng", point=1}
			end
		elseif combin[i].combin == "gang" then
			if combin[i].out == seat then
				if combin[i].card == feng then
					number = number + 3
					points[#points+1] = {hun="feng_an", point=1}
				elseif combin[i].card == 16*4+5 then
					number = number + 3
					points[#points+1] = {hun="zhong_an", point=1}
				elseif combin[i].card == 16*4+6 then
					number = number + 3
					points[#points+1] = {hun="fa_an", point=1}
				else
					num_an = num_an + 1
				end
			else
				if combin[i].card == feng then
					number = number + 2
					points[#points+1] = {hun="feng_gang", point=1}
				elseif combin[i].card == 16*4+5 then
					number = number + 2
					points[#points+1] = {hun="zhong_gang", point=1}
				elseif combin[i].card == 16*4+6 then
					number = number + 2
					points[#points+1] = {hun="fa_gang", point=1}
				else
					num_gang = num_gang + 1
				end
			end
		end
	end

	for i = 1, #combin_ do
		if combin_[i].combin == "peng" then
			if combin_[i].card == feng then
				number = number + 1
				points[#points+1] = {hun="feng_peng", point=1}
			elseif combin_[i].card == 16*4+5 then
				number = number + 1
				points[#points+1] = {hun="zhong_peng", point=1}
			elseif combin_[i].card == 16*4+6 then
				number = number + 1
				points[#points+1] = {hun="fa_peng", point=1}
			end
		elseif combin_[i].combin == "gang" then
			if combin_[i].out == seat then
				if combin_[i].card == feng then
					number = number + 3
					points[#points+1] = {hun="feng_an", point=1}
				elseif combin_[i].card == 16*4+5 then
					number = number + 3
					points[#points+1] = {hun="zhong_an", point=1}
				elseif combin_[i].card == 16*4+6 then
					number = number + 3
					points[#points+1] = {hun="fa_an", point=1}
				else
					num_an = num_an + 1
				end
			else
				if combin_[i].card == feng then
					number = number + 2
					points[#points+1] = {hun="feng_gang", point=1}
				elseif combin_[i].card == 16*4+5 then
					number = number + 2
					points[#points+1] = {hun="zhong_gang", point=1}
				elseif combin_[i].card == 16*4+6 then
					number = number + 2
					points[#points+1] = {hun="fa_gang", point=1}
				else
					num_gang = num_gang + 1
				end
			end
		end
	end

	if num_gang > 0 then
		number = number + num_gang
		points[#points+1] = {hun="gang", point=num_gang}
	end
	if num_an > 0 then
		number = number + 2*num_an
		points[#points+1] = {hun="an", point=num_an}
	end

	return number, points
end

local function count_big_flower(seat, combin_)
	local number, points = count_base_flower(seat, combin_)

	local num_gang = 0
	local num_an = 0
	for i = 1, #points do
		if points[i].hun == "show" then
			if points[i].point > 3 then
				number = number + 6
			elseif points[i].point > 2 then
				number = number + 5
			end
		elseif points[i].hun == "zhong" or points[i].hun == "bai" then
			if points[i].point > 3 then
				number = number + 6
			elseif points[i].point > 2 then
				number = number + 3
			end
		elseif points[i].hun == "dragon" then
			if points[i].point > 3 then
				number = number + 8
			elseif points[i].point > 2 then
				number = number + 5
			end
		elseif points[i].hun == "gang" then
			num_gang = num_gang + points[i].point
		elseif points[i].hun == "an" then
			num_an = num_an + points[i].point
		elseif points[i].hun == "feng_gang" or points[i].hun == "zhong_gang" or points[i].hun == "fa_gang" then
			num_gang = num_gang + 1
		elseif points[i].hun == "feng_an" or points[i].hun == "zhong_an" or points[i].hun == "fa_an" then
			num_an = num_an + 1
		end
	end

	if num_an > 2 then
		number = number + 8
	elseif num_gang + num_an > 2 then
		number = number + 6
		if num_an > 0 then
			number = number + 1
		end
	end

	return number, points
end

local function count_small_flower(seat, combin_)
	local number, points = count_base_flower(seat, combin_)

	for i = 1, #points do
		if points[i].hun == "show" then
			if points[i].point > 3 then
				number = number + 4
			elseif points[i].point > 2 then
				number = number + 3
			end
		elseif points[i].hun == "zhong" or points[i].hun == "bai" then
			if points[i].point > 3 then
				number = number + 4
			elseif points[i].point > 2 then
				number = number + 3
			end
		elseif points[i].hun == "dragon" then
			if points[i].point > 3 then
				number = number + 6
			elseif points[i].point > 2 then
				number = number + 3
			end
		end
	end

	return number, points
end


local function count_dragon_point(seat, combin, points_)
	local point = 0
	local points = {}

	local dragon = 0
	local card = logic.get_hand_card(seat)
	for i = 1, #card do
		if card[i] == gameState.dragon then
			dragon = dragon + 1
		end
	end

	local not_replace = 0
	local dragon_ke = 0
	local dragon_dui = 0
	for i = 1, #combin do
		-- replace = replace + combin[i].replace
		-- 财神归位计算
		if combin[i].not_replace and 
			(combin[i].combin == "left" or combin[i].combin == "center" or combin[i].combin == "right") then
			not_replace = not_replace + 1
		end
		if combin[i].card == gameState.dragon then
			if combin[i].combin == "peng" then
				dragon_ke = 1
			elseif combin[i].combin == "dui" then
				dragon_dui = 1
			end
		end
	end

	if not_replace == 4 then
		point = point + 500
		points[#points+1] = {hun="4_dragon_restore", point=500}
	elseif not_replace == 3 then
		point = point + 200
		points[#points+1] = {hun="3_dragon_restore", point=200}
	elseif not_replace == 2 then
		point = point + 30
		points[#points+1] = {hun="2_dragon_restore", point=30}
	elseif not_replace == 1 then
		if dragon == 3 then
			point = point + 16
			points[#points+1] = {hun="3_dragon_1_restore", point=16}
		elseif dragon == 2 then
			points[#points+1] = {hun="2_dragon_1_restore", point=2}
		else
			points[#points+1] = {hun="1_dragon_restore", point=1}
		end
	end

	if dragon_ke > 0 then
		point = point + 45
		points[#points+1] = {hun="3_dragon_ke", point=45}
	elseif dragon_dui > 0 then
		point = point + 15
		points[#points+1] = {hun="2_dragon_dui", point=15}
	end

	--[[ 以下情况不计算四财神、三财神、双财神、无财神：
		1、财神全归位
		2、只有三个财神，且为三财神刻
		3、只有2个财神，且为财神做牛
		4、之前计算了三财神一归位和双财神一归位
	--]]
	if (dragon ~= not_replace or dragon == 0) and 
		not (dragon == 3 and dragon_ke > 0) and 
		not (dragon == 2 and dragon_dui > 0) and 
		not (dragon ~= 4 and not_replace == 1) then
		if dragon == 4 then
			point = point + 45
			points[#points+1] = {hun="4_dragon", point=45}
		elseif dragon == 3 then
			point = point + 15
			points[#points+1] = {hun="3_dragon", point=15}
		elseif dragon == 2 then
			points[#points+1] = {hun="2_dragon", point=1}
		elseif dragon == 0 then
			local ying_single = false
			for i = 1, #points_ do
				if points_[i].hun == "ying_single" then
					ying_single = true
				end
			end
			if not ying_single then
				points[#points+1] = {hun="0_dragon", point=1}
			end
		end
	end

	return point, points
end



local function count_meiren_point(seat, combin)
	local point = 0
	local points = {}

	local card_zh = 0
	local card_fa = 0
	local card_ba = 0

	local hand = logic.get_combin_card(seat)
	for i = 1, #hand do
		if hand[i].combin == "peng" or hand[i].combin == "gang" then
			if hand[i].card == 16*4+5 then
				card_zh = card_zh + 1
			elseif hand[i].card == 16*4+6 then
				card_fa = card_fa + 1
			end
		end
	end

	for i = 1, #combin do
		if combin[i].combin == "peng" and combin[i].card ~= gameState.dragon then
			if combin[i].card == 16*4+5 then
				card_zh = card_zh + 1
			elseif combin[i].card == 16*4+6 then
				card_fa = card_fa + 1
			end
		end
	end

	local flower = logic.get_flower_card(seat)
	for i = 1, #flower do
		if flower[i] == 16*4+7 then
			card_ba = card_ba + 1
		end
	end

	if card_zh > 0 and card_fa > 0 then
		if card_ba > 3 then
			point = point + 200
			points[#points+1] = {hun="4_meiren", point=200}
		elseif card_ba > 2 then
			point = point + 45
			points[#points+1] = {hun="3_meiren", point=45}
		end
	end

	return point, points
end

local function count_tiandi_point(seat, mode)
	local point = 0
	local points = {}

	if gameState.number == 0 and seat == gameState.banker and mode > 2 then
		point = point + 45
		points[#points+1] = {hun="tian_hun", point=45}
	elseif gameState.number == 1 and seat ~= gameState.banker and mode >0 and mode < 3 then
		point = point + 45
		points[#points+1] = {hun="di_hun", point=45}
	end

	return point, points
end

local function count_single_point(seat, mode)
	local point = 0
	local points = {}

	local card = logic.get_hand_card(seat)
	--luadump(hand)
	if #card == 2 then
		if card[1] == gameState.dragon then
			point =  point + 15
			points[#points+1] = {hun="dragon_single", point=15}
		else
			if card[2] == gameState.dragon then
				point =  point + 30
				points[#points+1] = {hun="single_dragon", point=30}
			else
				point =  point + 45
				points[#points+1] = {hun="ying_single", point=45}
			end
		end
	end
	return point, points
end

local function check_count_single_point(seat, mode,outcard)
	local point = 0
	local points = {}

	local card = logic.get_hand_card(seat)
	
	LOG_INFO("check_count_single_point cardsize:%d,outcard:%d",#card,outcard)

	if #card == 2 then
		if card[1] == gameState.dragon then
			point =  point + 15
			points[#points+1] = {hun="dragon_single", point=15}
		else
			if card[2] == gameState.dragon then
				point =  point + 30
				points[#points+1] = {hun="single_dragon", point=30}
			else
				point =  point + 45
				points[#points+1] = {hun="ying_single", point=45}
			end
		end
	end

	if #card == 1 and outcard>0 then
		if card[1] == gameState.dragon then
			point =  point + 15
			points[#points+1] = {hun="dragon_single", point=15}
		else
			point =  point + 45
			points[#points+1] = {hun="ying_single", point=45}
		end
	end

	return point, points
end

local function count_fourfeng_point(seat, combin)
	local _, dragon = logic.get_banker_dragon()
	local point = 0
	local points = {}

	-- 若有风位做财神，则无法出现四风影，四风齐
	if dragon > 16*4 and dragon < 16*4+5 then
		return point, points
	end

	local number = {0, 0, 0, 0}
	local hand = logic.get_combin_card(seat)
	for i = 1, #hand do
		if hand[i].combin == "peng" or hand[i].combin == "gang" then
			local card = hand[i].card
			if card > 16*4 and card < 16*4+5 then
				number[card-16*4] = 2
			end
		end
	end

	for i = 1, #combin do
		if combin[i].combin == "peng" then
			local card = combin[i].card
			if card > 16*4 and card < 16*4+5 then
				number[card-16*4] = 2
			end
		elseif combin[i].combin == "dui" then
			local card = combin[i].card
			if card > 16*4 and card < 16*4+5 then
				number[card-16*4] = 1
			end
		end
	end

	local feng = get_men_feng(seat)
	if feng < 16*4+1 or feng > 16*4+4 then
		return point, points
	end

	local result = 2
	for i=1,#number do
		if number[i] == 0 then
			result = 0
			break
		elseif number[i] == 1 and i + 16*4 == feng then
			result = 1
		end
	end

	if result == 2 then
		point = point + 45
		points[#points+1] = {hun="4_feng_qi", point=45}
	elseif result == 1 then
		point = point + 15
		points[#points+1] = {hun="4_feng_ying", point=15}
	end

	return point, points
end

local function check_quan_zi(points)
	for i = 1, #points do
		if points[i].hun == "quan_zi" then
			return true
		end
	end
	return false
end
-- todo fmg
local function count_higher_points(info, combin)
	local point = 0
	local points = {}
	local pot = 0
	local pots = {}
	--cx
	pot, pots = count_single_point(info.hun, info.mode)
	point = point + pot
	append_points(points, pots)

	pot, pots  = count_dragon_point(info.hun, combin, points)
	point = point + pot
	append_points(points, pots)

	pot, pots = count_meiren_point(info.hun, combin)
	point = point + pot
	append_points(points, pots)

	if is_quanzi_hun(info.hun, combin) then
		point = point + 200
		points[#points+1] = {hun="quan_zi", point=200}
	end

	pot, pots = count_tiandi_point(info.hun, info.mode)
	point = point + pot
	append_points(points, pots)

	if is_four_bai(info.hun) then
		point = point + 45
		points[#points+1] = {hun="four_bai", point=45}
	end

	pot, pots = count_fourfeng_point(info.hun, combin)
	point = point + pot
	append_points(points, pots)

	if not check_quan_zi(points) then
		if is_qingyise_hun(info.hun, combin) then
			point = point + 45
			points[#points+1] = {hun="qingyise", point=45}
		elseif is_hunyise_hun(info.hun, combin) then
			point = point + 15
			points[#points+1] = {hun="hunyise", point=15}
		end

		if is_duidui_hun(info.hun, combin) then
			point = point + 15
			points[#points+1] = {hun="duidui", point=15}
		end
	end
	
	return point, points
end

local function check_count_higher_points(info, combin,outcard)
	local point = 0
	local points = {}
	local pot = 0
	local pots = {}
	--cx
	pot, pots = check_count_single_point(info.hun, info.mode,outcard)
	point = point + pot
	append_points(points, pots)
	
	pot, pots  = count_dragon_point(info.hun, combin, points)
	point = point + pot
	append_points(points, pots)

	pot, pots = count_meiren_point(info.hun, combin)
	point = point + pot
	append_points(points, pots)

	if is_quanzi_hun(info.hun, combin) then
		point = point + 200
		points[#points+1] = {hun="quan_zi", point=200}
	end

	pot, pots = count_tiandi_point(info.hun, info.mode)
	point = point + pot
	append_points(points, pots)

	if is_four_bai(info.hun) then
		point = point + 45
		points[#points+1] = {hun="four_bai", point=45}
	end

	pot, pots = count_fourfeng_point(info.hun, combin)
	point = point + pot
	append_points(points, pots)

	if not check_quan_zi(points) then
		if is_qingyise_hun(info.hun, combin) then
			point = point + 45
			points[#points+1] = {hun="qingyise", point=45}
		elseif is_hunyise_hun(info.hun, combin) then
			point = point + 15
			points[#points+1] = {hun="hunyise", point=15}
		end

		if is_duidui_hun(info.hun, combin) then
			point = point + 15
			points[#points+1] = {hun="duidui", point=15}
		end
	end
	
	return point, points
end

local function be_men_feng_ke(seat, combin)
	local feng = get_men_feng(seat)
	local hand = logic.get_combin_card(seat)
	for i = 1, #hand do
		if hand[i].combin == "peng" or hand[i].combin == "gang" then
			if hand[i].card == feng then
				return true
			end
		end
	end

	for i = 1, #combin do
		if combin[i].combin == "peng" or combin[i].combin == "gang" then
			if combin[i].card == feng then
				return true
			end
		end
	end
	return false
end

local function is_ping_hun(seat, combin)
	local cards = logic.get_hand_card(seat)
	if #cards == 0 then
		return false
	end

	local card = cards[#cards]
	if card == gameState.dragon or card > 16*4 then
		return false
	end

	local hand = logic.get_combin_card(seat)
	for i = 1, #hand do
		if hand[i].combin == "peng" or hand[i].combin == "gang" then
			return false
		end
	end

	local feng = get_men_feng(seat)
	for i = 1, #combin do
		if combin[i].combin == "dui" then
			if combin[i].card == feng or combin[i].card > 16*4+4 then
				return false
			end
		elseif combin[i].combin == "peng" then
			return false
		end
	end

	for i = 1, #combin do
		if combin[i].combin == "left" and combin[i].card == card and card % 16 < 7 then
			return true
		elseif combin[i].combin == "right" and combin[i].card == card and card % 16 > 3 then
			return true
		end
	end

	return false
end

local function count_zi_ke(seat, combin, total_points)
	local point = 0
	local points = {}

	for i,v in ipairs(total_points) do
		if v.hun == "3_meiren" or v.hun == "4_meiren" then
			return point, points
		end
	end

	local hand = logic.get_combin_card(seat)
	for i = 1, #hand do
		if hand[i].combin == "peng" or hand[i].combin == "gang" then
			if hand[i].card == 16*4+5 then
				point = point + 1
				points[#points+1] = {hun="zhong_ke", point=1}
			elseif hand[i].card == 16*4+6 then
				point = point + 1
				points[#points+1] = {hun="fa_ke", point=1}
			end
		end
	end

	for i = 1, #combin do
		if combin[i].combin == "peng" or combin[i].combin == "gang" then
			if combin[i].card == 16*4+5 then
				point = point + 1
				points[#points+1] = {hun="zhong_ke", point=1}
			elseif combin[i].card == 16*4+6 then
				point = point + 1
				points[#points+1] = {hun="fa_ke", point=1}
			end
		end
	end
	return point, points
end

local function select_dragon_point(points)
	for i = 1, #points do
		if points[i].hun == "0_dragon" or points[i].hun == "2_dragon" or points[i].hun == "1_dragon_restore" or points[i].hun == "2_dragon_1_restore" then
			return points[i].point, {}
		end
	end

	return 0, {}
end

local function count_common_point(info, combin, points_)
	local point = 0
	local points = {}

	if info.mode > 0 then
		local num_show = 0
		local num_flower = 0
		local flower = logic.get_flower_card(info.hun)
		for i = 1, #flower do
			if flower[i] == gameState.show then
				num_show = num_show + 1
			elseif flower[i] == gameState.flower then
				num_flower = num_flower + 1
			end
		end
		if num_flower > 0 then
			point = point + num_flower
			local count_flower = true
			for i,v in ipairs(points_) do
				if v.hun == "3_meiren" or v.hun == "4_meiren" or v.hun == "four_bai" then
					count_flower = false
					break
				end
			end

			if count_flower then
				if gameState.flower == 16*4+7 then
					points[#points+1] = {hun="flower_bai_num", point=num_flower}
				else
					points[#points+1] = {hun="flower_zhong_num", point=num_flower}
				end
			end
		end
		if num_show > 0 then
			-- 三明牌15台
			if num_show == 3 then
				num_show = 15
			end
			point = point + num_show
			points[#points+1] = {hun="show_num", point=num_show}
		end

		if be_men_feng_ke(info.hun, combin) then
			if not check_quan_zi(points_) then
				point = point + 1
				points[#points+1] = {hun="men_feng_ke", point=1}
			end
		end

		local pot, pots = count_zi_ke(info.hun, combin, points_)
		point = point + pot
		append_points(points, pots)

		pot, pots = select_dragon_point(points_)
		point = point + pot
		append_points(points, pots)

		if info.mode == 4 then
			point = point + 1
			points[#points+1] = {hun="gang_hun", point=1}
		elseif info.mode == 2 then
			point = point + 1
			points[#points+1] = {hun="qiang_hun", point=1}
		end

		if is_ping_hun(info.hun, combin) then
			point = point + 1
			points[#points+1] = {hun="ping_hun", point=1}
		end
	end

	return point, points
end

local function calculate_total_point(n, m)
	local n_point = 0
	if n > 10 then
		n_point = 15 + 10 - 6
	elseif n > 5 then
		n_point = 15 + n - 6
	else
		n_point = n
	end
	local m_point = m

	if n_point < 6 and m_point == 0 then
		return n_point
	else
		return (n_point + m_point) * 2
	end
end

local function count_dragon_all_points(info, combin)
	local point = 0
	local points = {}

	local dragon = 0
	local card = logic.get_hand_card(info.hun)
	for i = 1, #card do
		if card[i] == gameState.dragon then
			dragon = dragon + 1
		end
	end

	local point_ = 0
	local points_ = {}
	if dragon > 3 then
		point_ = 45
		points_[#points_+1] = {hun="4_dragon", point=45}
	elseif dragon > 2 then
		point_ = 15
		points_[#points_+1] = {hun="3_dragon", point=15}
	end

	local point, points = count_common_point(info, combin, points_)
	if point > 5 then point = 5 end

	point = calculate_total_point(point, point_)
	append_points(points, points_)

	return point, points
end

local function count_forbid_all_points(info, combin)
	local point = 0
	local points = {}

	local point_, points_ = count_higher_points(info, combin)
	point_ = 0
	for i = 1, #points_ do
		if points_[i].point > 10 then
			point_ = point_ + 5
		end
	end

	local point, points = count_common_point(info, combin, points_)
	if point > 5 then point = 5 end

	point = calculate_total_point(point, point_)
	append_points(points, points_)

	return point, points
end

local function count_common_all_points(info, combin)
	local point = 0
	local points = {}

	local point_, points_ = count_higher_points(info, combin)

	local point, points = count_common_point(info, combin, points_)

	point = calculate_total_point(point, point_)
	append_points(points, points_)

	return point, points
end

local function check_count_common_all_points(info, combin,outcard)
	local point = 0
	local points = {}

	local point_, points_ = check_count_higher_points(info, combin,outcard)

	local point, points = count_common_point(info, combin, points_)

	point = calculate_total_point(point, point_)
	append_points(points, points_)

	return point, points
end

local function count_all_points(info, combin)
	local point = 0
	local points = {}

	if gameState.forbid > 0 and info.hun ~= gameState.forbid then
		if gameState.number == 0 and info.mode > 2 then
			point, points = count_common_all_points(info, combin)
		elseif gameState.number == 1 and info.mode > 0 and info.mode < 3 then
			point, points = count_common_all_points(info, combin)
		elseif gameState.forbid_num == 0 and info.mode > 0 and info.mode < 3 then
			point, points = count_common_all_points(info, combin)
		else
			local dragon = 0
			local card = logic.get_hand_card(info.hun)
			for i = 1, #card do
				if card[i] == gameState.dragon then
					dragon = dragon + 1
				end
			end
			if dragon > 2 then
				point, points = count_dragon_all_points(info, combin)
			else
				point, points = count_forbid_all_points(info, combin)
			end
		end
	else
		point, points = count_common_all_points(info, combin)
	end

	return point, points
end

local function count_all_flower(seat, combin)
	local flower = 0
	local points = {}
	if gameMode > 0 then
		flower, points = count_big_flower(seat, combin)
	else
		flower, points = count_small_flower(seat, combin)
	end
	return flower*flower, points
end

local function calculate_common_number(seat)
	local number = {0, 0, 0 , 0, 0, 0, 0, 0, 0}
	local feng = get_men_feng(seat)

	local card = logic.get_hand_card(seat)
	for i = 1, #card do
		if card[i] > 16*4 and card[i] ~= gameState.dragon then
			if card[i] == feng or card[i] == 16*4+5 or card[i] == 16*4+6 then
				local pos = card[i] % 16
				if pos > 0 and pos < 10 then
					number[pos] = number[pos] + 1
				end
			end
		end
	end

	local combin = {}
	for i = 1, #number do
		if number[i] > 2 then
			combin[#combin+1] = {combin="peng", card=16*4+i, out=0, replace=0}
		end
	end

	return count_all_flower(seat, combin)
end
--fmg
local function calculate_hun_number(info)
	local flower = 0
	local flowers = {}
	local point = 0
	local points = {}
	local hand = {}

	local combin = logic.hun_card_combin(info.hun)
	-- luadump(combin)
	for i = 1, #combin do
		local num_flower, points_flower = count_all_flower(info.hun, combin[i])
		local num_point, arr_point = count_all_points(info, combin[i])
		if num_flower + num_point >= flower + point then
			flower = num_flower
			flowers = points_flower
			point = num_point
			points = arr_point
			hand = combin[i]
		end
	end
	--luadump(hand)

	for i = 1, #hand do
		gameState.hun[#gameState.hun+1] = hand[i]
		-- LOG_DEBUG("+++++++++++++++++++++hun:" .. i .. " combin:" .. hand[i].combin .. " card:" .. hand[i].card)
	end

	if point == 0 then
		points[#points+1] = {hun="zero", point=0}
	end

	return flower, flowers, point, points
end

local function is_single_bao(seat, card)
	if playerState[seat].single ~= 1 then
		return false
	end

	local out = playerState[seat].single_out
	if out > 16*4 then
		if out ~= card then
			return false
		end
	else
		if card < out - 2 or card > out + 2 then
			return false
		end
	end

	return true
end

local function is_show_bao(seat, card, points)
	local count = #points
	for i = 1, count do
		if points[i].hun == "4_meiren" then
			if card > 16*4+4 and card < 16*4+8 then
				local number = 0
				local combin = logic.get_combin_card(seat)
				for i = 1, #combin do
					if combin[i].combin == "peng" or combin[i].combin == "gang" then
						if combin[i].card > 16*4+4 then
							number = number + 1
						end
					end
				end
				if number == 1 then
					return true
				end
			end
		elseif points[i].hun == "3_meiren" then
			if card > 16*4+4 and card < 16*4+8 then
				local number = 0
				local combin = logic.get_combin_card(seat)
				for i = 1, #combin do
					if combin[i].combin == "peng" or combin[i].combin == "gang" then
						if combin[i].card > 16*4+4 then
							number = number + 1
						end
					end
				end
				if number == 1 then
					return true
				end
			end
		elseif points[i].hun == "4_feng_qi" then
			if card > 16*4 and card < 16*4+5 then
				local number = 0
				local combin = logic.get_combin_card(seat)
				for i = 1, #combin do
					if combin[i].combin == "peng" or combin[i].combin == "gang" then
						if combin[i].card > 16*4 and combin[i].card < 16*4+5 then
							number = number + 1
						end
					end
				end
				if number == 3 then
					return true
				end
			end
		elseif points[i].hun == "4_feng_ying" then
			if card > 16*4 and card < 16*4+5 then
				local number = 0
				local combin = logic.get_combin_card(seat)
				for i = 1, #combin do
					if combin[i].combin == "peng" or combin[i].combin == "gang" then
						if combin[i].card > 16*4 and combin[i].card < 16*4+5 then
							number = number + 1
						end
					end
				end
				if number == 3 then
					return true
				end
			end
		end
	end
	return false
end

local function is_chi_out_bao(seat, card)
	if playerState[seat].forbid_out > 0 and playerState[seat].forbid_out == card then
		return true
	end
	return false
end

local function is_same_bao(seat, out)
	local combin = logic.get_combin_card(seat)
	local out_number = {}
	for i,v in ipairs(combin) do
		if not out_number[v.out] then
			out_number[v.out] = 0
		end
		out_number[v.out] = out_number[v.out] + 1
	end

	for k,v in pairs(out_number) do
		if v >= 4 then
			return true, k
		elseif v >= 3 and k == out then
			return true, k
		end
	end

	return false, 0
end

local function check_bao_card(info, points)
	local bao = 0
	local reason = 0

	if info.mode > 0 and info.mode < 3 then
		if is_single_bao(info.hun, info.card) then
			bao = info.out
			reason = 1
		elseif is_show_bao(info.hun, info.card, points) then
			bao = info.out
			reason = 2
		elseif is_chi_out_bao(info.out, info.card) then
			bao = info.out
			reason = 3
		else
			local ok, out = is_same_bao(info.hun, info.out)
			if ok then
				bao = out
				reason = 4
			end
		end
	end

	return bao, reason
end

local function count_hun_result(info)
	local total_flower = 0
	local flower = 0
	local flowers = {}
	local point = 0
	local points = {}
	local number = {}

	for i = 1, maxPlayers do
		if info.mode > 0 and i == info.hun then
			flower, flowers, point, points = calculate_hun_number(info)
			number[i] = {0, 0, 0, 0, flower, point, flowers} -- result bao number_flower number_point flower point
			total_flower = total_flower + flower
		else
			flower, flowers = calculate_common_number(i)
			number[i] = {0, 0, 0, 0, flower, 0, flowers}
			total_flower = total_flower + flower
		end
	end

	for i = 1, maxPlayers do
		number[i][3] = number[i][5]*maxPlayers - total_flower
		if info.mode > 0 then
			if i == info.hun then
				if info.hun == gameState.banker then
					number[i][4] = (point+2) * (maxPlayers-1)
				else
					number[i][4] = (point+2) * (maxPlayers-1)
				end
			else
				if info.hun == gameState.banker then
					number[i][4] = -(point+2)
				elseif i == gameState.banker then
					number[i][4] = -(point+2)
				else
					number[i][4] = -(point+2)
				end
			end
		end
	end

	local bao, reason = check_bao_card(info, points)
	if bao > 0 and reason > 0 then
		local total = 0
		for i = 1, maxPlayers do
			local num = number[i][4] 
			if num > 0 then
				number[i][1] = number[i][3] + num
			elseif num < 0 then
				number[i][1] = number[i][3]
				total = total + num
			end
		end
		number[bao][1] = number[bao][1] + total
		number[bao][2] = reason
	else
		for i = 1, maxPlayers do
			number[i][1] = number[i][3] + number[i][4]
		end
	end

	return points, number
end

local function count_score_result(info)
	local scores = {}
	local golds = {}
	local chips = {}
	local points, result = count_hun_result(info)
	if #result == maxPlayers then
		for i = 1, maxPlayers do
			if gamePlayers[i].gold <= 0 then
				return points, scores, golds, chips
			end
		end

		local total_win = 0
		local total_lose = 0
		for i = 1, maxPlayers do
			chips[i] = gameState.score * result[i][1]
			local mul = gameState.score * result[i][1]
			if mul > 0 then
				golds[i] = mul
				total_win = total_win + golds[i]
			elseif mul < 0 then
				if gamePlayers[i].gold + mul >= 0 then
					golds[i] = mul
				else
					golds[i] = -gamePlayers[i].gold
				end
				total_lose = total_lose + golds[i]
			else
				golds[i] = 0
			end
		end

		
		if total_win > 0 and total_lose < 0 then
			local total = 0 - total_lose
			for i = 1, maxPlayers do
				if golds[i] > 0 then
					golds[i] = math.floor(total * golds[i] / total_win)
				end
			end
		end
		

		for i = 1, maxPlayers do
			if i == info.hun then
				if result[i][1] > 0 then
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score="+" .. gameState.score*result[i][1], hu=1, points=result[i][7]}
				else
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score=gameState.score*result[i][1], hu=1, points=result[i][7]}
				end
			elseif result[i][2] > 0 then
				if result[i][1] > 0 then
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score="+" .. gameState.score*result[i][1] .. "(包牌)", hu=0, points=result[i][7]}
				else
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score=gameState.score*result[i][1] .. "(包牌)", hu=0, points=result[i][7]}
				end
			else
				if result[i][1] > 0 then
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score="+" .. gameState.score*result[i][1], hu=0, points=result[i][7]}
				else
					scores[i] = {name=gamePlayers[i].nickname, flower=result[i][5], bao=result[i][6], score=gameState.score*result[i][1], hu=0, points=result[i][7]}
				end
			end
		end
	end

	return points, scores, golds, chips
end


local function be_show_gang()
	for i = 1, maxPlayers do
		local combin = logic.get_combin_card(i)
		for j = 1, #combin do
			if combin[j].combin == "gang" then
				return true
			end
		end
	end
	return false
end

local function number_forbid_hun(seat)
	if gameState.forbid > 0 then
		gameState.forbid_num = gameState.forbid_num + 1
		return
	end

	local num_show = 0
	local num_flower = 0
	local flower = logic.get_flower_card(seat)
	for i = 1, #flower do
		if flower[i] == gameState.show then
			num_show = num_show + 1
		elseif flower[i] == gameState.flower then
			num_flower = num_flower + 1
		end
	end

	if num_show > 2 then
		gameState.forbid = seat
		return
	elseif num_flower > 3 then
		gameState.forbid = seat
		return
	end

	local num_zi = 0
	local num_feng = 0
	local num_men = 0
	local feng = get_men_feng(seat)
	local combin = logic.get_combin_card(seat)
	for i = 1, #combin do
		if combin[i].combin == "peng" and combin[i].combin == "gang" then
			if combin[i].card > 16*4+4 then
				num_zi = num_zi + 1
			elseif combin[i].card > 16*4 then
				num_feng = num_feng + 1
				if combin[i].card == feng then
					num_men = num_men + 1
				end
			end
		end
	end

	if num_show + num_flower + num_zi + num_men > 5 then
		gameState.forbid = seat
		return
	elseif num_zi > 1 and num_flower > 2 then
		gameState.forbid = seat
		return
	elseif num_feng > 3 then
		gameState.forbid = seat
		return
	end

	local card = logic.get_hand_card(seat)
	if #card < 2 then
		gameState.forbid = seat
		return
	end
end

local function show_hand_card()
	local card = {}
	for i = 1, maxPlayers do
		card[i] = {seat=i, card=logic.get_hand_card(i)}
	end
	game.send_msg(0, "MaJiang.ShowCard", {hand=card})
	game.send_msg_w(nil, "MaJiang.ShowCard", {hand=card})
end

local function finish_card(info)
	if gameState.state ~= "game" then
		return
	end 

	local points = {}
	local cards = {}
	local combins = {}
	local scores={}
	local golds = {}
	local chips = {}

	if info.mode > 0 and info.mode < 3 then
		logic.append_hand_card(info.hun, info.card)
	end
	
	show_hand_card()

	points, scores, golds, chips = count_score_result(info)
	if info.mode > 0 then
		for i = 1, #gameState.hun do
			logic.add_combin_card_test(info.hun, gameState.hun[i].combin, gameState.hun[i].card, gameState.hun[i].out, gameState.hun[i].replace)
		end

		cards = logic.get_hand_card(info.hun)
		combins = logic.get_combin_card(info.hun)
	end

	

	if info.hun > 0 then
		if info.hun == gameState.banker then
			if gameBanker.banker ~= gameState.banker then
				gameBanker.banker = gameState.banker
				gameBanker.count = 0
			else
				gameBanker.count = gameBanker.count + 1
			end
		else
			gameBanker.banker = gameState.banker % maxPlayers + 1
			gameBanker.count = 0
		end
	else
		if be_show_gang() then
			gameBanker.banker = gameState.banker % maxPlayers + 1
			gameBanker.count = 0
		elseif gameBanker.banker ~= gameState.banker then
			gameBanker.banker = gameState.banker
			gameBanker.count = 0
		end
	end

	

	local result1 = {}
	local result2 = {}
	for i = 1, maxPlayers do
		result1[i] = 0
		result2[i] = 0
	end
	if #chips ==  maxPlayers then
		for i = 1, maxPlayers do
			result1[i] = chips[i]
		end
	end
	if #golds ==  maxPlayers then
		for i = 1, maxPlayers do
			result2[i] = golds[i]
		end
	end

	local finish = game.end_game(result1, result2)

	game.send_msg(0, "MaJiang.EndGame", {finish=finish, mode=info.mode, hun=info.hun, chao=0, points=points, cards=cards, combins=combins, scores=scores})
	game.send_msg_w(nil, "MaJiang.EndGame", {finish=finish, mode=info.mode, hun=info.hun, chao=0, points=points, cards=cards, combins=combins, scores=scores})

	gameState = {state=""}

	game.ended_game(finish)
end

local function set_game_state(seat, phase, out, card, mode)
	gameState.phase = phase
	gameState.seat = seat
	gameState.out = out
	gameState.card = card
	gameState.time = skynet.now()
	gameState.index = gameState.index + 1
	gameState.mode = mode
end

local function allow_out_card(seat)
	set_game_state(seat, "out", 0, 0, 0)
	game.send_msg(0, "MaJiang.AllowOut", {seat=seat, card={gameState.dragon}, time=20})
	game.send_msg_w(nil, "MaJiang.AllowOut", {seat=seat, card={gameState.dragon}, time=20})
end

local function result_draw_card(seat, card)
	set_game_state(seat, "draw", seat, card, 0)
	local number = logic.card_number()
	for i = 1, maxPlayers do
		if i == seat then
			game.send_msg(i, "MaJiang.DrawCard", {seat=seat, card=card, number=number})
		else
			game.send_msg(i, "MaJiang.DrawCard", {seat=seat, card=0, number=number})
		end
	end
	game.send_msg_w(nil, "MaJiang.DrawCard", {seat=seat, card=0, number=number})
end

local function result_out_card(seat, card)
	set_game_state(seat, "outing", seat, card, 0)

	game.send_msg(0, "MaJiang.OutCard", {seat=seat, card=card})
	game.send_msg_w(nil, "MaJiang.OutCard", {seat=seat, card=card})
end

local function result_outed_card(seat, card)
	set_game_state(seat, "outed", seat,  card, 0)
	game.send_msg(0, "MaJiang.OutedCard", {seat=seat, card=card})
	game.send_msg_w(nil, "MaJiang.OutedCard", {seat=seat, card=card})
	table.insert(_outed_cards, card)
end

local function result_combin_card(combin)
	set_game_state(combin.seat, "combined", 0, 0, 0)
	game.send_msg(0, "MaJiang.CombinCard", {seat=combin.seat, combin={combin=combin.combin, card=combin.card, out=combin.out, replace=combin.replace}})
	game.send_msg_w(nil, "MaJiang.CombinCard", {seat=combin.seat, combin={combin=combin.combin, card=combin.card, out=combin.out, replace=combin.replace}})
end

local function complement_hand_flower(seat)
	local flower = {}
	local cards = logic.get_hand_card(seat)
	local count = #cards
	for i = 1, count do
		if cards[i] == gameState.flower or cards[i] == gameState.show then
			flower[#flower+1] = cards[i]
		end
	end
	count = #flower
	for i = 1, count do
		logic.remove_hand_card(seat, flower[i])
		logic.add_flower_card(seat, flower[i])
	end

	local draw = {}
	local draw_ = {}
	for i = 1, count do
		while true do
			local card = logic.add_hand_card(seat)
			if card ~= gameState.flower and card ~= gameState.show then
				draw[#draw+1] = card
				draw_[#draw_+1] = 0
				break
			end
			flower[#flower+1] = card
			logic.remove_hand_card(seat, card)
			logic.add_flower_card(seat, card)
		end
	end

	if #flower > 0 then
		local number = logic.card_number()
		for i = 1, maxPlayers do
			if i == seat then
				game.send_msg(i, "MaJiang.ComplementCard", {seat=seat, flower=flower, card=draw, number=number})
			else
				game.send_msg(i, "MaJiang.ComplementCard", {seat=seat, flower=flower, card=draw_, number=number})
			end
		end
		game.send_msg_w(nil, "MaJiang.ComplementCard", {seat=seat, flower=flower, card=draw_, number=number})
	end
end

local function check_hand_flower(seat, card, gang)
	if gang then
		set_game_state(seat, "complement", 0, card, 4)
	else
		set_game_state(seat, "complement", 0, card, 3)
	end

	for i = 1, maxPlayers do
		if i == seat then
			game.send_msg(i, "MaJiang.AllowFlower", {seat=seat, card=card, time=10})
		else
			game.send_msg(i, "MaJiang.AllowFlower", {seat=seat, card=0, time=10})
		end
	end
	game.send_msg_w(nil, "MaJiang.AllowFlower", {seat=seat, card=0, time=10})
end

local function check_max_point(seat,card)

	local info = {mode=0, hun=seat, out=0, card=0}
	local combin = logic.check_hun_card_combin(seat,card)

--  fmg
	info.mode = gameState.mode
	if info.mode == 0 then
		info.mode = 1
	end

	local hand = {}
	local  maxpoint = 0
	for k=1 ,#combin do
		hand = combin[k]						
		local point ,points = check_count_common_all_points(info,hand,card)

		if point > maxpoint then
			maxpoint = point
		end

		if maxpoint > 15 then
			--LOG_INFO("out_card_combin size:%d,hand size:%d,seat:%d,hun:%d,point:%d,maxpoint:%d",#combin,#hand,seat,info.hun,point,maxpoint)
			break
			
		end

	end
	return maxpoint
end

--fmg
local function check_hand_card(seat, gang)
	local respon = logic.check_hand_card(seat)
	---[[
	if #respon > 0 then
	--二人游戏 限制15台
		for j=1,#respon do
			if maxPlayers ==2 and respon[j].combin == "hun" then

				LOG_INFO("hand card check_hun_card_combin seat:%d",seat)

				local maxpoint = check_max_point(seat,0)

				if maxpoint<15 then
						---respon[j] = nil
						table.remove(respon,j)
				end
				
			end
		end
	end
	---]]

	LOG_INFO("check_hand_card respon:%d",#respon)

	if #respon >0 then

		if gang then
			set_game_state(seat, "combin", 0, 0, 4)
		else
			set_game_state(seat, "combin", 0, 0, 3)
		end

		for i = 1, maxPlayers do
			if i == seat then
				game.send_msg(i, "MaJiang.AllowCombin", {combin=respon, allowOut=seat, time=20})
			else
				game.send_msg(i, "MaJiang.AllowCombin", {combin={}, allowOut=seat, time=20})
			end
		end
		game.send_msg_w(nil, "MaJiang.AllowCombin", {combin={}, allowOut=seat, time=20})
		return
	end

	allow_out_card(seat)
end

local function draw_hand_card(seat, gang)
	local card = 0
	if logic.card_number() > 16 then
		card = logic.add_hand_card(seat)
	end
	
	if card > 0 then
		result_draw_card(seat, card)
		if card == gameState.flower or card == gameState.show then
			check_hand_flower(seat, card, gang)
		else
			check_hand_card(seat, gang)
		end
	else
		set_game_state(0, "finish", 0,  0, 0)
		skynet.fork(finish_card, {mode=0, hun=0, out=0, card=0})
	end
end

local function distribute_card()
	set_game_state(0, "distribute", 0,  0, 0)
	local banker, _ = logic.get_banker_dragon()
	logic.distribute_card()
	for i = 1, maxPlayers do
		local cur = (banker - 1 + i - 1) % maxPlayers + 1
		local finish = 0
		if i == maxPlayers then
			finish = 1
		end
		local cards = logic.get_hand_card(cur)
		local number = logic.card_number()
		local card_0 = {}
		local card_1 = {}
		for i = 1, #cards do
			card_0[i] = cards[i]
			card_1[i] = 0
		end
		game.send_msg(cur, "MaJiang.DistributeCard", {seat=cur, card=card_0, number=number, finish=finish})

		for j = 1, maxPlayers do
			if j ~= cur then
				game.send_msg(j, "MaJiang.DistributeCard", {seat=cur, card=card_1, number=number, finish=finish})
			end
		end
		game.send_msg_w(nil, "MaJiang.DistributeCard", {seat=cur, card=card_1, number=number, finish=finish})
	end

	for i = 1, maxPlayers do
		local current = ((banker-1) + (i-1)) % maxPlayers + 1
		complement_hand_flower(current)

		if gameState.forbid == 0 then
			number_forbid_hun(current)
		end
	end

	check_hand_card(banker, false)
end

local function start_game()
	if not game.start_game() then
		return
	end
	
	_outed_cards = {}
	gameState = {state="game", seat=0, phase="", out=0, card=0, score=0, time=0, index=0, mode=0, dragon=0, flower=0, show=0, banker=0, gang=0, hun={}, number=0, forbid=0, forbid_num=0}
	playerState = {}
	for i = 1, maxPlayers do
		playerState[i] = {single=0, single_out=0, forbid=false, forbid_out=0, managed = 1}
	end

	if gameMode > 0 then
		game.send_msg(0, "MaJiang.MajiangInfo", {majiang="big", room=0})
		game.send_msg_w(nil, "MaJiang.MajiangInfo", {majiang="big", room=0})
	else
		game.send_msg(0, "MaJiang.MajiangInfo", {majiang="small", room=0})
		game.send_msg_w(nil, "MaJiang.MajiangInfo", {majiang="small", room=0})
	end

	local specialseatid = 0
	for i=1,#specialuid do
		for j=1, maxPlayers do
			if specialuid[i] == gamePlayers[j].uid then
				specialseatid = j
				break
			end
		end
	end

	LOG_INFO("specialuid=%d",specialseatid)

	logic.start_game(maxPlayers,specialseatid)

	if gameBanker.banker == 0 then
		gameBanker.banker = math.random(maxPlayers)
		gameBanker.count = 0
	end
	logic.decide_banker(gameBanker.banker)
	local banker, _ = logic.get_banker_dragon()
	gameState.banker = banker
	
	gameState.score = gameBase
	
	local points = {math.random(6), math.random(6)}

	game.send_msg(0, "MaJiang.StartGame", {banker=banker, score=gameState.score, continue=gameBanker.count,points=points})
	game.send_msg_w(nil, "MaJiang.StartGame", {banker=banker, score=gameState.score, continue=gameBanker.count,points=points})
	

	gameState.show = logic.decide_dragon()
	local banker, dragon = logic.get_banker_dragon()
	gameState.dragon = dragon
	if dragon == 16*4+7 then
		gameState.flower = 16*4+5
	elseif dragon == 16*4+1 then
		gameState.flower = 16*4+5
	else
		gameState.flower = 16*4+7
	end
	game.send_msg(0, "MaJiang.DragonCard", {dragon=dragon, show=gameState.show})
	game.send_msg_w(nil, "MaJiang.DragonCard", {dragon=dragon, show=gameState.show})

	distribute_card()
end

local function check_start_game()
	if gameState.state == "game" then
		return
	end

	for i = 1, maxPlayers do
		local  p = gamePlayers[i]
		if p == nil or p.uid == 0 or p.ready ~= 1 then
			return
		end
	end

	start_game()
end

local function check_gang_hun(seat, card)
	local num = 0
	local respon = {}
	for i = 1, maxPlayers do
		respon[i] = logic.check_gang_hun(i, seat, card)
		
		if #respon[i] then
			--二人游戏 限制15台
			for j=1,#respon[i] do
				if maxPlayers ==2 and respon[i][j].combin == "hun" then

					LOG_INFO("gang_hun check_hun_card_combin seat:%d,card:%d",i,card)

					local maxpoint = check_max_point(i,card)

					if maxpoint<15 then
						---respon[i][j] = nil
						table.remove(respon[i],j)
					end
					
				end
			end
		end


		num = num + #respon[i]
	end
	if num > 0 then
		set_game_state(0, "combin", seat,  card, 2)
		for i = 1, maxPlayers do
			game.send_msg(i, "MaJiang.AllowCombin", {combin=respon[i], allowOut=0, time=10})
		end
		game.send_msg_w(nil, "MaJiang.AllowCombin", {combin={}, allowOut=0, time=10})
		return true
	end
	return false
end

local function check_gang(seat)
	local combin = logic.check_hand_gang(seat)
	if #combin > 0 then
		set_game_state(seat, "combin", 0, 0, 0)
		for i = 1, maxPlayers do
			if i == seat then
				game.send_msg(i, "MaJiang.AllowCombin", {combin=combin, allowOut=seat, time=20})
			else
				game.send_msg(i, "MaJiang.AllowCombin", {combin={}, allowOut=seat, time=20})
			end
		end
		game.send_msg_w(nil, "MaJiang.AllowCombin", {combin={}, allowOut=seat, time=20})
		return true
	end

	return false
end

local function number_single_card(seat, card)
	local hand = logic.get_hand_card(seat)
	if #hand == 1 then
		playerState[seat].single = playerState[seat].single + 1
		playerState[seat].single_out = card
	end
end

local function forbid_chi_card(seat, combin, card)
	if combin == "left" then
		local val = (card + 3) % 16 
		if val > 0 and val < 10 then
			playerState[seat].forbid = true
			playerState[seat].forbid_out = card + 3
		end
	elseif combin == "right" then
		local val = (card - 3) % 16 
		if val > 0 and val < 10 then
			playerState[seat].forbid = true
			playerState[seat].forbid_out = card - 3
		end
	end
end

local function on_deal_combin(combin)
	local mode = gameState.mode
	if combin.combin == "" then
		if mode > 2 then
			allow_out_card(gameState.seat)
		elseif mode > 1 then
			draw_hand_card(gameState.out, true)
		elseif mode > 0 then
			logic.add_out_card(gameState.out, gameState.card)
			result_outed_card(gameState.out, gameState.card)

			local current = (gameState.out - 1 + 1) % maxPlayers + 1
			draw_hand_card(current, false)
		end
	elseif combin.combin == "hun" then
		set_game_state(combin.seat, "finish", 0,  0, 0)
		skynet.fork(finish_card, {mode=mode, hun=combin.seat, out=combin.out, card=combin.card})
	elseif combin.combin == "gang" then
		gameState.gang = gameState.gang + 1
		logic.add_combin_card(combin.seat, combin.combin, combin.card, combin.out, combin.replace)
		local append = logic.remove_combin_card(combin.seat, "peng", combin.card)
		for i = 1, 4 do
			logic.remove_hand_card(combin.seat, combin.card)
		end

		result_combin_card(combin)
		if not append or not check_gang_hun(combin.seat, combin.card) then
			draw_hand_card(combin.seat, true)
		else
			number_single_card(combin.seat, combin.card)
			number_forbid_hun(combin.seat)
		end
	elseif combin.combin == "peng" then
		logic.add_combin_card(combin.seat, combin.combin, combin.card, combin.out, combin.replace)
		for i = 1, 2 do
			logic.remove_hand_card(combin.seat, combin.card)
		end
		result_combin_card(combin)

		if not check_gang(combin.seat) then
			allow_out_card(combin.seat)
		end
	elseif combin.combin == "left" then
		forbid_chi_card(combin.seat, combin.combin, combin.card)

		logic.add_combin_card(combin.seat, combin.combin, combin.card, combin.out, combin.replace)
		
		logic.remove_hand_card(combin.seat, combin.card+1)
		logic.remove_hand_card(combin.seat, combin.card+2)
		
		result_combin_card(combin)

		if not check_gang(combin.seat) then
			allow_out_card(combin.seat)
		end
	elseif combin.combin == "center" then
		logic.add_combin_card(combin.seat, combin.combin, combin.card, combin.out, combin.replace)
		
		logic.remove_hand_card(combin.seat, combin.card-1)
		logic.remove_hand_card(combin.seat, combin.card+1)
	
		result_combin_card(combin)

		if not check_gang(combin.seat) then
			allow_out_card(combin.seat)
		end
	elseif combin.combin == "right" then
		forbid_chi_card(combin.seat, combin.combin, combin.card)

		logic.add_combin_card(combin.seat, combin.combin, combin.card, combin.out, combin.replace)
		
		logic.remove_hand_card(combin.seat, combin.card-1)
		logic.remove_hand_card(combin.seat, combin.card-2)

		result_combin_card(combin)

		if not check_gang(combin.seat) then
			allow_out_card(combin.seat)
		end
	end
end

local function on_ignore_card(seat)
	if gameState.phase ~= "combin" then
		return
	end

	if gameState.seat > 0 and gameState.seat ~= seat then
		return
	end

	local combin = logic.ignore_combin(seat)
	if combin == nil then
		return
	end

	on_deal_combin(combin)
end

local function on_out_flower(seat, card)
	if gameState.phase ~= "complement" then
		return
	end

	if gameState.seat ~= seat then
		return
	end

	if not logic.remove_hand_card(seat, card) then
		return
	end

	logic.add_flower_card(seat, card)

	set_game_state(seat, "complemented", 0, card, 0)
	local number = logic.card_number()
	for i = 1, maxPlayers do
		game.send_msg(i, "MaJiang.ComplementCard", {seat=seat, flower={card}, card={}, number=number})
	end
	game.send_msg_w(nil, "MaJiang.ComplementCard", {seat=seat, flower={card}, card={}, number=number})

	draw_hand_card(seat, gameState.mode==4)
end


local function forbid_out_card(seat, card)
	if playerState[seat].forbid then
		playerState[seat].forbid = false
		if playerState[seat].forbid_out ~= card then
			playerState[seat].forbid_out = 0
		end
	else
		playerState[seat].forbid_out = 0
	end
end
--- fmg
local function on_out_card(seat, card)
	if gameState.phase ~= "out" and gameState.phase ~= "combin" then
		return
	end

	if gameState.seat ~= seat then
		return
	end

	if card == gameState.dragon then
		return
	end

	if not logic.remove_hand_card(seat, card) then
		return
	end

	gameState.number = gameState.number + 1
	number_single_card(seat, card)
	forbid_out_card(seat, card)
	number_forbid_hun(seat)

	result_out_card(seat, card)

	local num = 0
	local respon = {}
	for i = 1, maxPlayers do
		respon[i] = logic.check_combin_card(i, seat, card)
		if #respon[i] then
			--二人游戏 限制15台
			for j=1,#respon[i] do
				if maxPlayers ==2 and respon[i][j].combin == "hun" then
					local maxpoint = check_max_point(i,card)

					LOG_INFO("out card check_hun_card_combin seat:%d,card:%d,max:%d",i,card,maxpoint)
					if maxpoint<15 then
						--respon[i][j] = nil
						table.remove(respon[i],j)
					end
					
				end
			end
		end
		num = num + #respon[i]
	end


	if num > 0 then
		set_game_state(0, "combin", seat,  card, 1)
		for i = 1, maxPlayers do
			game.send_msg(i, "MaJiang.AllowCombin", {combin=respon[i], allowOut=0, time=10})
		end
		game.send_msg_w(nil, "MaJiang.AllowCombin", {combin={}, allowOut=0, time=10})
	else
		logic.add_out_card(seat, card)
		result_outed_card(seat, card)

		local current = (seat - 1 + 1) % maxPlayers + 1
		draw_hand_card(current, false)
	end
end

local function on_combin_card(seat, combin)
	if gameState.phase ~= "combin" then
		return
	end

	if gameState.seat > 0 and gameState.seat ~= seat then
		return
	end

	local combin = logic.combin_card(seat, combin.combin, combin.card, combin.replace)
	if combin == nil then
		return
	end

	on_deal_combin(combin)
end

local function on_hu_card(seat)
	if gameState.phase ~= "combin" then
		return
	end

	if gameState.seat > 0 and gameState.seat ~= seat then
		return
	end

	local combin = logic.hun_card(seat)
	if combin == nil then
		return
	end

	on_deal_combin(combin)
end



function game.dispatch(seatid, name, msg)
	LOG_DEBUG("recv msg seat:" .. seatid .. " name:" .. name)
	if gameState.state == "game" then
		if playerState[seatid].managed ~= 1 then
			playerState[seatid].managed = 1
		end
		if name == "MaJiang.OutCard" then
			if gameState.phase == "complement" then
				on_out_flower(seatid, msg.card)
			else
				on_out_card(seatid, msg.card)
			end
		elseif name == "MaJiang.CombinCard" then
			on_combin_card(seatid, msg.combin)
		elseif name == "MaJiang.HuCard" then
			on_hu_card(seatid)
		elseif name == "MaJiang.IgnoreCard" then
			on_ignore_card(seatid)
		elseif name == "MaJiang.Managed" then
			if playerState[seatid].managed == 0 then
				playerState[seatid].managed = 2
				game.send_msg(0, "MaJiang.Managed", {seat=seatid, state=playerState[seatid].managed})

				if gameState.phase == "out" then
					game.send_msg(seatid, "MaJiang.AllowOut", {seat=gameState.seat, card={gameState.dragon}, time=0})
				elseif gameState.phase == "combin" then
					game.send_msg(seatid, "MaJiang.AllowCombin", {combin=logic.get_respon_combin(seatid), allowOut=gameState.seat, time=0})
				end
			end
		end
	else
		if name == "MaJiang.Ready" then
			local p = gamePlayers[seatid]
			if p == nil or p.uid == 0 then
				return
			end
			if p.ready == 1 then
			end
			game.send_msg(seatid, "MaJiang.Ready", {})
		end
	end
end

function game.tick()
	if gameState.state == "game" and gameState.time and gameState.time > 0 then
		if gameState.phase == "out" or gameState.phase == "complement" then
			local delay_time = 2000
			if gameState.phase == "complement" then
				delay_time = 1000
			end
			if playerState[gameState.seat].managed == 0 then
				delay_time = delay_time / 2
			end
			if skynet.now() > gameState.time + delay_time then
				if playerState[gameState.seat].managed > 0 then
					playerState[gameState.seat].managed = playerState[gameState.seat].managed - 1

					if playerState[gameState.seat].managed == 0 then
						game.send_msg(0, "MaJiang.Managed", {seat=gameState.seat, state=playerState[gameState.seat].managed})
					end
				end
				local cards = logic.get_hand_card(gameState.seat)
				if gameState.phase == "complement" then
					on_out_flower(gameState.seat, cards[#cards])
				else
					for i = 1, #cards do
						local c = cards[#cards-i+1]
						if c ~= gameState.dragon then
							on_out_card(gameState.seat, c)
							break
						end
					end
				end
			end
		elseif gameState.phase == "combin"  then
			local index = gameState.index
			local time = skynet.now()
			for i = 1, maxPlayers do
				if gameState.index == index then
					local delay_time = 1000
					if playerState[i].managed == 0 then
						delay_time = delay_time / 2
					end
					local respon = logic.get_respon_combin(i)
					if time > gameState.time + delay_time and #respon > 0 then
						if playerState[i].managed > 0 then
							playerState[i].managed = playerState[i].managed - 1

							if playerState[i].managed == 0 then
								game.send_msg(0, "MaJiang.Managed", {seat=i, state=playerState[i].managed})
							end
						end
						on_ignore_card(i)
					end
				end
			end
		end
	end
end

function game.watched(p)
	if gameState.state ~= "game" then
		return
	end

	if gameMode > 0 then
		game.send_msg_w(p, "MaJiang.MajiangInfo", {majiang="big", room=0})
	else
		game.send_msg_w(p, "MaJiang.MajiangInfo", {majiang="small", room=0})
	end

	local banker, dragon = logic.get_banker_dragon()
	local  number = logic.card_number()
	game.send_msg_w(p, "MaJiang.GameInfo", {
		banker = banker, 
		dragon = dragon, 
		points = {0,0}, 
		score = gameState.score, 
		number = number, 
		continue = gameBanker.count, 
		show = gameState.show,
		outs = _outed_cards,
	})
	for i = 1, maxPlayers do
		local cards = {}
		local count = #logic.get_hand_card(i)
		for j = 1, count do
			cards[j] = 0
		end
		game.send_msg_w(p, "MaJiang.PlayerInfo", {seat=i, cards=cards, outs=logic.get_out_card(i), flower=logic.get_flower_card(i), combins=logic.get_combin_card(i)})
	end
	
	local time = math.floor((skynet.now() - gameState.time)/100)
	if gameState.phase == "out" then
		if time < 20 then time = 20 - time else time = 1 end
		game.send_msg_w(p, "MaJiang.AllowOut", {seat=gameState.seat, card={gameState.dragon}, time=time})
	elseif gameState.phase == "complement" then
		if time < 10 then time = 10 - time else time = 1 end
		game.send_msg_w(p, "MaJiang.AllowFlower", {seat=gameState.seat, card=0, time=time})
	elseif gameState.phase == "combin"  then
		if gameState.seat > 0 then
			if time < 20 then time = 20 - time else time = 1 end
		else
			if time < 10 then time = 10 - time else time = 1 end
		end
		game.send_msg_w(p, "MaJiang.AllowCombin", {combin={}, allowOut=gameState.seat, time=time})
	end
end

function game.reconnect(seatid)
	if gameState.state ~= "game" then
		return
	end

	if gameMode > 0 then
		game.send_msg(seatid, "MaJiang.MajiangInfo", {majiang="big", room=0})
	else
		game.send_msg(seatid, "MaJiang.MajiangInfo", {majiang="small", room=0})
	end

	local banker, dragon = logic.get_banker_dragon()
	local  number = logic.card_number()
	game.send_msg(seatid, "MaJiang.GameInfo", {
		banker = banker, 
		dragon = dragon, 
		points = {0,0}, 
		score = gameState.score, 
		number = number, 
		continue = gameBanker.count, 
		show = gameState.show, 
		outs = _outed_cards,
	})
	for i = 1, maxPlayers do
		if i == seatid then
			game.send_msg(seatid, "MaJiang.PlayerInfo", {seat=i, cards=logic.get_hand_card(i), outs=logic.get_out_card(i), flower=logic.get_flower_card(i), combins=logic.get_combin_card(i)})
		else
			local cards = {}
			local count = #logic.get_hand_card(i)
			for j = 1, count do
				cards[j] = 0
			end
			game.send_msg(seatid, "MaJiang.PlayerInfo", {seat=i, cards=cards, outs=logic.get_out_card(i), flower=logic.get_flower_card(i), combins=logic.get_combin_card(i)})
		end
	end

	for i = 1, maxPlayers do
		game.send_msg(seatid, "MaJiang.Managed", {seat=i, state=playerState[i].managed})
	end

	local time = math.floor((skynet.now() - gameState.time)/100)
	if gameState.phase == "out" then
		if time < 20 then time = 20 - time else time = 1 end
		game.send_msg(seatid, "MaJiang.AllowOut", {seat=gameState.seat, card={gameState.dragon}, time=time})
	elseif gameState.phase == "complement" then
		if time < 10 then time = 10 - time else time = 1 end
		game.send_msg(seatid, "MaJiang.AllowFlower", {seat=gameState.seat, card=gameState.card, time=time})
	elseif gameState.phase == "combin" then
		if gameState.seat > 0 then
			if time < 20 then time = 20 - time else time = 1 end
		else
			if time < 10 then time = 10 - time else time = 1 end
		end
		game.send_msg(seatid, "MaJiang.AllowCombin", {combin=logic.get_respon_combin(seatid), allowOut=gameState.seat, time=time})
	end
end

function game.joined(seatid)
end

function game.readied(seatid)
	if gameState.state == "game" then
		return
	end
	skynet.fork(check_start_game)
end

function game.leave(seatid)
	if gameState.state ~= "game" then
		gameBanker = {banker=0, count=0}
		return
	end
	playerState[seatid].managed = 0
end

function game.offline(seatid)
	if gameState.state ~= "game" then
		return
	end
	playerState[seatid].managed = 0
end

function game.init(ps, cfg)
	gamePlayers = ps
	maxPlayers = cfg.maxPlayer
	maxScore = cfg.maxSettle
	gameBase = 1
	gameMode = 0

	specialuid  = cfg.specialuid

	gameState = {state=""} 
	playerState = {}
	gameBanker = {banker=0, count=0}
	_outed_cards = {}
end

function game.create(base, count, rule)
	gameBase = base
	gameCount = count
	gameMode = rule

	gameState = {state=""} 
	playerState = {}
	gameBanker = {banker=0, count=0}
	_outed_cards = {}
end

function game.clear()
end

return game