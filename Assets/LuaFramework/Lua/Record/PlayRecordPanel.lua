
PlayRecordPanel = UIBase(define.Panels.PlayRecordPanel, define.PopUI);
local this = PlayRecordPanel;
local transform;
local gameObject;
-- 手牌的父对象
local parentList
-- 出牌的父对象
local outparentList
-- 吃碰杠牌的父对象
local cpgParent
local roomRemark
local LeftCard
local LeftRound
local imgDuanMen
local playerItems
-- 方向指示
local dirObj
local LiujuEffect
local btnStop
local btnPlay
local btnForward
local btnBackward
local btnExit
local processText
------------------------------------------
local Pointer-- 指针
-- 手牌模板
local BottomPrefabs
-- 桌牌模板
local ThrowPrefabs
-- 吃碰杠牌模板
local CPGPrefabs
-- 暗杠牌模板
local BackPrefabs
------------------------------------------
local usedList
local handerCardList
local tableCardList
local PengGangList
-- 下标转换数组
local indexList
-- 玩家列表
local avatarList
local cardCount
local stepNum
local behavieList
------------------------------------------
local co




-- 启动事件--
function PlayRecordPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	dirObj, parentList, outparentList, cpgParent, playerItems = { }, { }, { }, { }, { }
	dirObj[1] = transform:FindChild('table/Down/Red1').gameObject
	dirObj[2] = transform:FindChild('table/Right/Red2').gameObject
	dirObj[3] = transform:FindChild('table/Up/Red3').gameObject
	dirObj[4] = transform:FindChild('table/Left/Red4').gameObject
	imgDuanMen = transform:FindChild('imgDuanMen'):GetComponent('Image')
	LeftCard = transform:FindChild('table/LeftCard/Text'):GetComponent('Text')
	LeftRound = transform:FindChild('table/LeftRound/Text'):GetComponent('Text')
	roomRemark = transform:FindChild('RoomText'):GetComponent('Text')
	processText = transform:FindChild('process/Text'):GetComponent('Text')
	for i = 1, 4 do
		parentList[i] = transform:FindChild('HandCardParent/parent' .. i)
		outparentList[i] = transform:FindChild('throwCardParent/parent' .. i)
		cpgParent[i] = transform:FindChild('pengGangParent/parent' .. i)
		playerItems[i] = RecordPlayerItem.New(transform:FindChild('playList/Player' .. i).gameObject)
	end
	LiujuEffect = transform:FindChild('LiujuEffect').gameObject
	btnPlay = transform:FindChild('playCtrlPanel/btnPlay').gameObject
	btnStop = transform:FindChild('playCtrlPanel/btnStop').gameObject
	btnForward = transform:FindChild('playCtrlPanel/btnForward').gameObject
	btnBackward = transform:FindChild('playCtrlPanel/btnBackward').gameObject
	btnExit = transform:FindChild('playCtrlPanel/btnExit').gameObject
	this.lua:AddClick(btnStop, this.StopClick)
	this.lua:AddClick(btnPlay, this.PlayClick)
	this.lua:AddClick(btnForward, this.ForwardClick)
	this.lua:AddClick(btnBackward, this.BackwardClick)
	this.lua:AddClick(btnExit, this.ExitClick)
end



function PlayRecordPanel.PlayRecord(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message)
	behavieList = data.behavieList
	this.InitArrayList()
	this.ReBuild(data.playerItems)
	this.SetRoomRemark(data)
	this.InitPlayerItem()
	this.InitCard()
	stepNum = 1
	co = coroutine.start(this.Play)
end

function PlayRecordPanel.InitPlayerItem()
	for i = 1, #avatarList do
		playerItems[i]:SetAvatarVo(avatarList[i])
	end
end

function PlayRecordPanel.InitCard()
	for i = 1, #avatarList do
		local cardList = string.split(avatarList[i].cardList, ',')
		for j = 1, #cardList do
			local num = tonumber(cardList[j])
			if (num > 0) then
				for k = 1, num do
					local obj = newObject(BottomPrefabs[i])
					obj.transform:SetParent(parentList[i]);
					obj.transform.localScale = Vector3.one;
					if (i == 2) then
						obj.transform:SetAsFirstSibling()
					end
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(j - 1, i)
					table.insert(handerCardList[i], objCtrl)
				end
			end
		end
		this.SetPosition(i);
	end
end

-- 设置牌位置
function PlayRecordPanel.SetPosition(LocalIndex)
	local tempList = handerCardList[LocalIndex]
	local count = #tempList;
	switch =
	{
		[1] = function(i) return Vector2.New(-626 + i * 79, 0) end,
		[2] = function(i) return Vector2.New(0, -216 + i * 32) end,
		[3] = function(i) return Vector2.New(525 - 55 * i, 0) end,
		[4] = function(i) return Vector2.New(0, 276 - i * 32) end,
	}
	for i = 1, count do
		tempList[i].gameObject.transform.localPosition = switch[LocalIndex](i)
		if LocalIndex == 2 then
			tempList[i].gameObject.transform:SetAsFirstSibling()
		elseif LocalIndex == 4 then
			tempList[i].gameObject.transform:SetAsLastSibling()
		end
	end
	if (count % 3 == 2) then
		tempList[count].gameObject.transform.localPosition = switch[LocalIndex](count + 1)
	end
end
-- 桌牌位置
function PlayRecordPanel.TableCardPosition(LocalIndex)
	local switch =
	{
		[1] = Vector2.New(-261 + #tableCardList[1] % 14 * 37,math.modf(#tableCardList[1] / 14) * 67),
		[2] = Vector2.New((math.modf(#tableCardList[2] / 13) * -54),- 180 + #tableCardList[2] % 13 * 28),
		[3] = Vector2.New(289 - #tableCardList[3] % 14 * 37,math.modf(#tableCardList[3] / 14) * -67),
		[4] = Vector2.New(math.modf(#tableCardList[4] / 13) * 54,152 - #tableCardList[4] % 13 * 28)
	}
	return switch[LocalIndex]
end


-- 吃碰杠牌的位置，i:第几墩，j:第几张牌
function PlayRecordPanel.CPGPosition(LocalIndex, i, j)
	local switch =
	{
		[1] = function(i, j)
			if (j == 4) then
				return Vector2.New(650 - i * 190, 24)
			else
				return Vector2.New(530 - i * 190 + j * 60, 0)
			end
		end,
		[2] = function(i, j)
			if (j == 4) then
				return Vector2.New(0, 267 - i * 95 + 62)
			else
				return Vector2.New(0, 267 - i * 95 + j * 26);
			end
		end,
		[3] = function(i, j)
			if (j == 4) then
				return Vector2.New(-345 + i * 120, 20)
			else
				return Vector2.New(-271 + i * 120 - j * 37, 0);
			end
		end,
		[4] = function(i, j)
			if (j == 4) then
				return Vector2.New(0, -267 + i * 95 - 47)
			else
				return Vector2.New(0, -267 + i * 95 - j * 26);
			end
		end
	}
	local pos = switch[LocalIndex](i, j)
	return pos
end

function PlayRecordPanel.SortCard(LocalIndex)
	local list = handerCardList[LocalIndex]
	table.sort(list,
	function(a, b)
		return a.cardPoint < b.cardPoint
	end )
end

function PlayRecordPanel.SetRoomRemark(data)
	local roomvo = data.roomvo
	local str = "房间号：\n" .. roomvo.roomId .. "\n";
	str = str .. "圈数：" .. roomvo.roundNumber .. "\n";
	if roomvo.pingHu then
		str = str .. "穷胡\n"
	end
	if roomvo.jue then
		str = str .. "绝\n"
	end
	if roomvo.baoSanJia then
		str = str .. "包三家\n"
	end
	if roomvo.jiaGang then
		str = str .. "加钢\n"
	end
	if roomvo.gui == 2 then
		str = str .. "带会儿\n"
	end
	if roomvo.duanMen then
		str = str .. "买断门\n"
	end
	if roomvo.jihu then
		str = str .. "鸡胡\n"
	end
	if roomvo.qingYiSe then
		str = str .. "清一色\n"
	end
	roomRemark.text = str;
	if roomvo.addWordCard then
		cardCount = 83
	else
		cardCount = 55
	end
	imgDuanMen.enabled = data.duanmen;
	LeftCard.text = cardCount
	LeftRound.text = roomvo.roundNumber - roomvo.currentRound;
end

function PlayRecordPanel.InitArrayList()
	usedList = { }
	handerCardList = { };
	tableCardList = { }
	PengGangList = { }
	for i = 1, 4 do
		handerCardList[i] = { }
		tableCardList[i] = { }
		PengGangList[i] = { }
	end
end

-- 调整avatarList的顺序
function PlayRecordPanel.ReBuild(players)
	avatarList = { }
	local temp = { { 1, 2, 3, 4 }, { 4, 1, 2, 3 }, { 3, 4, 1, 2 }, { 2, 3, 4, 1 } }
	local myIndex = 1
	for i = 1, #players do
		if players[i].uuid == LoginData.account.uuid then
			myIndex = i;
		end
	end
	indexList = temp[myIndex]
	for i = 1, #players do
		local index = indexList[i]
		avatarList[index] = players[i]
	end
end


function PlayRecordPanel.Play()
	while (true) do
		if stepNum <= #behavieList then
			this.ForwardClick()
		else
			processText.text = "播放进度：100%";
		end
		coroutine.wait(2)
	end
end


function PlayRecordPanel.PlayClick()
	btnPlay:SetActive(false);
	btnStop:SetActive(true);
	co = coroutine.start(this.Play)
end

function PlayRecordPanel.StopClick()
	btnPlay:SetActive(true);
	btnStop:SetActive(false);
	coroutine.stop(co)
end

function PlayRecordPanel.ForwardClick()
	if stepNum <= #behavieList then
		local temp = behavieList[stepNum];
		table.insert(usedList, temp)
		local LocalIndex = indexList[temp.accountindex_id + 1]
		-- 1出牌，2摸牌，3吃，4碰，5杠，6胡
		local switch =
		{
			[1] = function() this.OutCard(LocalIndex, temp) end,
			[2] = function() this.PickCard(LocalIndex, temp) end,
			[3] = function() this.ChiCard(LocalIndex, temp) end,
			[4] = function() this.PengCard(LocalIndex, temp) end,
			[5] = function() this.GangCard(LocalIndex, temp) end,
			[6] = function() this.HuCard(LocalIndex, temp) end,
			[7] = function() this.QiangGangHu(LocalIndex, temp) end,
			[8] = function() this.Zhuama(temp) end,
			[9] = function() this.Liuju() end,
		}
		switch[temp.type]()
		this.SetDirGameObjectAction(LocalIndex);
		processText.text = "播放进度：" .. math.modf(stepNum * 100 / #behavieList) .. "%";
		stepNum = stepNum + 1
	end
end

function PlayRecordPanel.BackwardClick()
	if #usedList > 0 then
		local temp = usedList[#usedList];
		table.remove(usedList)
		local LocalIndex = indexList[temp.accountindex_id + 1]
		local switch =
		{
			[1] = function() this.FrontOutCard(LocalIndex, temp) end,
			[2] = function() this.FrontPickCard(LocalIndex, temp) end,
			[3] = function() this.FrontChiCard(LocalIndex, temp) end,
			[4] = function() this.FrontPengCard(LocalIndex, temp) end,
			[5] = function() this.FrontGangCard(LocalIndex, temp) end,
			[6] = function() this.FrontHuCard(LocalIndex, temp) end,
			[7] = function() this.FrontQiangGangHu(LocalIndex, temp) end,
			[8] = function() this.FrontZhuama(temp) end,
			[9] = function() this.FrontLiuju() end,
		}
		switch[temp.type]()
		this.SetDirGameObjectAction(LocalIndex);
		stepNum = stepNum - 1
		processText.text = "播放进度：" .. math.modf(stepNum * 100 / #behavieList) .. "%";
	end
end


function PlayRecordPanel.OutCard(Index, temp)
	local cardPoint = tonumber(temp.cardIndex)
	local pos = this.RemoveHandCard(Index, cardPoint, 1)
	log(pos)
	this.PutOutCard(cardPoint, Index, pos)
	this.SortCard(Index)
	this.SetPosition(Index)
end

function PlayRecordPanel.PickCard(Index, temp)
	cardCount = cardCount - 1
	LeftCard.text = cardCount
	local cardPoint = tonumber(temp.cardIndex)
	this.AddHandCard(Index, cardPoint)
	this.SetPosition(Index)
end
function PlayRecordPanel.ChiCard(Index, temp)
	coroutine.start(this.ShowEffect, playerItems[Index].ChiEffect)
	soundMgr:playSoundByAction("chi", avatarList[Index].sex);
	-- 桌上被消除的牌
	this.RemoveLastCardOnTable()
	-- 手牌
	local cards = string.split(temp.cardIndex, '|')
	this.RemoveHandCard(Index, tonumber(cards[2]), 1)
	this.RemoveHandCard(Index, tonumber(cards[3]), 1)
	this.SetPosition(Index);
	-- 牌序列
	local tempList = { }
	tempList.cardPoint = cardPoint
	for i = 1, 3 do
		local obj = newObject(CPGPrefabs[Index])
		obj.transform:SetParent(cpgParent[Index])
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = this.CPGPosition(Index, #PengGangList[Index] + 1, i)
		if Index == 2 then
			obj.transform:SetAsFirstSibling();
		end
		local objCtrl = TopAndBottomCardScript.New(obj);
		if (i == 1) then
			objCtrl:Init(tonumber(cards[1]), Index);
		elseif (i == 2) then
			objCtrl:Init(tonumber(cards[2]), Index);
		elseif (i == 3) then
			objCtrl:Init(tonumber(cards[3]), Index);
		end
		table.insert(tempList, obj)
	end
	table.insert(PengGangList[Index], tempList)
end
function PlayRecordPanel.PengCard(Index, temp)
	coroutine.start(this.ShowEffect, playerItems[Index].PengEffect)
	soundMgr:playSoundByAction("peng", avatarList[Index].sex);
	-- 桌上被消除的牌
	this.RemoveLastCardOnTable()
	-- 手牌
	local cardPoint = tonumber(temp.cardIndex)
	this.RemoveHandCard(Index, cardPoint, 2)
	this.SetPosition(Index);
	-- 牌序列
	local tempList = { }
	tempList.cardPoint = cardPoint
	for i = 1, 3 do
		local obj = newObject(CPGPrefabs[Index])
		obj.transform:SetParent(cpgParent[Index])
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = this.CPGPosition(Index, #PengGangList[Index] + 1, i)
		if Index == 2 then
			obj.transform:SetAsFirstSibling();
		end
		local objCtrl = TopAndBottomCardScript.New(obj);
		objCtrl:Init(cardPoint, Index);
		table.insert(tempList, obj)
	end
	table.insert(PengGangList[Index], tempList)
end

-- 1.明杠，2.暗杠，3.补杠
function PlayRecordPanel.GangCard(Index, temp)
	coroutine.start(this.ShowEffect, playerItems[Index].GangEffect)
	soundMgr:playSoundByAction("gang", avatarList[Index].sex);
	local gangType = temp.gangType
	local cardPoint = tonumber(temp.cardIndex)
	if gangType == 1 then
		-- 桌上被消除的牌	
		this.RemoveLastCardOnTable()
		-- 手牌
		this.RemoveHandCard(Index, cardPoint, 3)
		this.SetPosition(Index);
		-- 牌序列
		local tempList = { }
		tempList.cardPoint = cardPoint
		for i = 1, 4 do
			local obj = newObject(CPGPrefabs[Index])
			obj.transform:SetParent(cpgParent[Index])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = this.CPGPosition(Index, #PengGangList[Index] + 1, i)
			if Index == 2 then
				obj.transform:SetAsFirstSibling();
			end
			local objCtrl = TopAndBottomCardScript.New(obj);
			objCtrl:Init(cardPoint, Index);
			table.insert(tempList, obj)
		end
		table.insert(PengGangList[Index], tempList)
	elseif gangType == 2 then
		-- 手牌
		this.RemoveHandCard(Index, cardPoint, 4)
		this.SetPosition(Index);
		-- 牌序列
		local tempList = { }
		tempList.cardPoint = cardPoint
		for i = 1, 4 do
			local obj
			if (i == 4) then
				obj = newObject(CPGPrefabs[Index])
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, Index);
			else
				obj = newObject(BackPrefabs[Index])
			end
			obj.transform:SetParent(cpgParent[Index])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = this.CPGPosition(Index, #PengGangList[Index] + 1, i)
			if Index == 2 then
				obj.transform:SetAsFirstSibling();
			end
			table.insert(tempList, obj)
		end
		table.insert(PengGangList[Index], tempList)
	elseif gangType == 3 then
		-- 手牌
		this.RemoveHandCard(Index, cardPoint, 1)
		this.SetPosition(Index);
		-- 将杠牌放到对应位置
		local where = this.GetPaiInpeng(cardPoint, Index);
		local obj = newObject(CPGPrefabs[1])
		obj.transform:SetParent(cpgParent[1])
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = this.CPGPosition(Index, where, 4)
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(cardPoint, 1)
		table.insert(PengGangList[Index][where], obj)
	end
end

function PlayRecordPanel.HuCard(Index, temp)
	coroutine.start(this.ShowEffect, playerItems[Index].HuEffect)
	coroutine.start(this.ShowEffect, playerItems[Index].HuFlag)
	soundMgr:playSoundByAction("hu", avatarList[Index].sex);
end
function PlayRecordPanel.QiangGangHu(Index, temp)
	coroutine.start(this.ShowEffect, playerItems[Index].HuEffect)
	coroutine.start(this.ShowEffect, playerItems[Index].HuFlag)
	soundMgr:playSoundByAction("hu", avatarList[Index].sex);
	local cardPoint = tonumber(temp.cardIndex)
	this.AddHandCard(Index, cardPoint)
end
function PlayRecordPanel.Zhuama(temp)

end
function PlayRecordPanel.Liuju()
	coroutine.start(this.ShowEffect, LiujuEffect)
end

function PlayRecordPanel.ShowEffect(effect)
	effect:SetActive(true)
	coroutine.wait(1)
	effect:SetActive(false)
end
		    
function PlayRecordPanel.FrontOutCard(Index, temp)
	local cardPoint = tonumber(temp.cardIndex)
	this.AddHandCard(Index, cardPoint)
	this.SortCard(Index)
	this.SetPosition(Index)
	local tablelist = tableCardList[Index]
	destroy(table.remove(tablelist))
	Pointer:SetActive(false)
end

function PlayRecordPanel.FrontPickCard(Index, temp)
	cardCount = cardCount + 1
	LeftCard.text = cardCount
	local cardPoint = tonumber(temp.cardIndex)
	this.RemoveHandCard(Index, cardPoint, 1)
	this.SetPosition(Index)
end
function PlayRecordPanel.FrontChiCard(Index, temp)
	-- 摧毁牌序列
	this.RemoveCPGOnTable(Index)
	-- 还原手牌
	local cards = string.split(temp.cardIndex, '|')
	for i = 1, 2 do
		local cardPoint = tonumber(cards[i + 1])
		this.AddHandCard(Index, cardPoint)
	end
	this.SortCard(Index)
	this.SetPosition(Index)
	-- 还原桌牌
	local temp = usedList[#usedList]
	local lastIndex = indexList[temp.accountindex_id + 1]
	this.AddCardToTable(tonumber(cards[1]), lastIndex, true)
end
function PlayRecordPanel.FrontPengCard(Index, temp)
	-- 摧毁牌序列
	this.RemoveCPGOnTable(Index)
	-- 还原手牌
	local cardPoint = tonumber(temp.cardIndex)
	for i = 1, 2 do
		this.AddHandCard(Index, cardPoint)
	end
	this.SortCard(Index)
	this.SetPosition(Index)
	-- 还原桌牌
	local temp = usedList[#usedList]
	local lastIndex = indexList[temp.accountindex_id + 1]
	this.AddCardToTable(cardPoint, lastIndex, true)
end
function PlayRecordPanel.FrontGangCard(Index, temp)
	local gangType = temp.gangType
	local cardPoint = tonumber(temp.cardIndex)
	if gangType == 1 then
		-- 摧毁牌序列
		this.RemoveCPGOnTable(Index)
		-- 还原手牌
		for i = 1, 3 do
			this.AddHandCard(Index, cardPoint)
		end
		-- 还原桌牌
		local temp = usedList[#usedList]
		local lastIndex = indexList[temp.accountindex_id + 1]
		this.AddCardToTable(cardPoint, lastIndex, true)
	elseif gangType == 2 then
		-- 摧毁牌序列
		this.RemoveCPGOnTable(Index)
		-- 还原手牌
		for i = 1, 4 do
			this.AddHandCard(Index, cardPoint)
		end
	elseif gangType == 3 then
		-- 还原手牌
		this.AddHandCard(Index, cardPoint)
		local where = this.GetPaiInpeng(cardPoint, Index);
		local templist = PengGangList[Index][where]
		destroy(table.remove(templist))
	end
	this.SortCard(Index)
	this.SetPosition(Index)
end
function PlayRecordPanel.FrontHuCard(Index, temp)
	playerItems[Index].HuFlag:SetActive(false)
end
function PlayRecordPanel.FrontQiangGangHu(Index, temp)
	playerItems[Index].HuFlag:SetActive(false)
	local cardPoint = tonumber(temp.cardIndex)
	this.RemoveHandCard(Index, cardPoint, 1)
end
function PlayRecordPanel.FrontZhuama(temp)

end
function PlayRecordPanel.FrontLiuju()
	LiujuEffect:SetActive(false);
end

function PlayRecordPanel.PutOutCard(cardPoint, Index, position)
	soundMgr:playSound(cardPoint, avatarList[Index].sex);
	-- 飞出去的牌
	local obj = newObject(ThrowPrefabs[Index])
	obj.transform:SetParent(outparentList[Index])
	obj.transform.localPosition = position
	obj.transform.localScale = Vector3.one
	obj.name = "putOutCard";
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, Index);
	if (Index == 2) then
		obj.transform:SetAsFirstSibling();
	end
	-- 显示在桌上的牌
	local destination = this.TableCardPosition(Index)
	local go = this.AddCardToTable(cardPoint, Index, false)
	local tweener = obj.transform:DOLocalMove(destination, 1, false):OnComplete(
	function()
		if (obj ~= nil) then
			destroy(obj)
			objCtrl = nil
		end
		if (not IsNil(go)) then
			go:SetActive(true)
		end
	end );
	tweener:SetEase(Ease.OutExpo);
end


-- 设置顶针
function PlayRecordPanel.SetPointGameObject(parent)
	if (parent ~= nil) then
		Pointer.transform:SetParent(parent.transform);
		Pointer.transform.localScale = Vector3.one;
		Pointer.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		Pointer.transform:SetParent(transform);
		Pointer:SetActive(true)
	end
end

function PlayRecordPanel.AddHandCard(Index, cardPoint)
	local obj = newObject(BottomPrefabs[Index])
	obj.transform:SetParent(parentList[Index]);
	obj.transform.localScale = Vector3.one;
	if (Index == 2) then
		obj.transform:SetAsFirstSibling()
	end
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, Index)
	table.insert(handerCardList[Index], objCtrl)
end

function PlayRecordPanel.RemoveHandCard(Index, cardPoint, count)
	local list = handerCardList[Index]
	log(Test.DumpTab(list))
	local pos = Vector3.zero
	for i = #list, 1, -1 do
		local objCtrl = list[i];
		if (objCtrl.cardPoint == cardPoint) then
			table.remove(list, i)
			pos = objCtrl.transform.localPosition
			destroy(objCtrl.gameObject);
			count = count - 1;
			if (count == 0) then
				return pos
			end
		end
	end
	logError(string.format("Index=%d,cardPoint=%d,count=%d", Index, cardPoint, count))
	return pos
end
-- 创建打到桌上的牌
function PlayRecordPanel.AddCardToTable(cardPoint, Index, isActive)
	local obj = newObject(ThrowPrefabs[Index])
	obj.transform:SetParent(outparentList[Index])
	obj.transform.localPosition = this.TableCardPosition(Index)
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, Index);
	obj.name = cardPoint;
	obj.transform.localScale = Vector3.one;
	if (Index == 2) then obj.transform:SetAsFirstSibling() end
	table.insert(tableCardList[Index], obj)
	if (not isActive) then obj:SetActive(false) end
	this.SetPointGameObject(obj);
	return obj
end
-- 消除打到桌上的牌
function PlayRecordPanel.RemoveLastCardOnTable()
	local temp = usedList[#usedList]
	local lastIndex = indexList[temp.accountindex_id + 1]
	local tablelist = tableCardList[lastIndex]
	destroy(table.remove(tablelist))
	Pointer:SetActive(false)
end

function PlayRecordPanel.AddCPGToTable()

end

function PlayRecordPanel.RemoveCPGOnTable(Index)
	local list = PengGangList[Index]
	local temp = list[#list]
	for i = 1, #temp do
		destroy(temp[i])
	end
	table.remove(list)
end

function PlayRecordPanel.GetPaiInpeng(cardPoint, Index)
	local list = PengGangList[Index]
	for i = 1, #list do
		if (list[i].cardPoint == cardPoint) then
			return i
		end
	end
	return -1;
end

function PlayRecordPanel.SetDirGameObjectAction(Index)
	for i = 1, 4 do
		dirObj[i]:SetActive(false)
	end
	dirObj[Index]:SetActive(true)
end

function PlayRecordPanel.ExitClick()
	OpenPanel(ExitPanel, "提示", "您确定要退出回放吗？", this.CloseClick)
end
-------------------模板-------------------------
function PlayRecordPanel.CloseClick()
	CleanList(handerCardList)
	CleanList(tableCardList)
	CleanList(PengGangList)
	coroutine.stop(co)
	ClosePanel(ExitPanel)
	ClosePanel(this)
	soundMgr:playSoundByActionButton(1);
end

function PlayRecordPanel:OnOpen()
	BottomPrefabs = { UIManager.HandCard_B, UIManager.HandCard_R, UIManager.HandCard_T, UIManager.HandCard_L }
	ThrowPrefabs = { UIManager.TopAndBottomCard, UIManager.ThrowCard_R, UIManager.TopAndBottomCard, UIManager.ThrowCard_L }
	CPGPrefabs = { UIManager.PengGangCard_B, UIManager.PengGangCard_R, UIManager.PengGangCard_T, UIManager.PengGangCard_L }
	BackPrefabs = { UIManager.GangBack, UIManager.GangBack_LR, UIManager.GangBack_T, UIManager.GangBack_LR }
	Pointer = UIManager.Pointer
end
-- 移除事件--
function PlayRecordPanel:RemoveListener()
	Event.RemoveListener(tostring(APIS.GAME_BACK_PLAY_RESPONSE), this.PlayRecord)
end

-- 增加事件--
function PlayRecordPanel:AddListener()
	Event.AddListener(tostring(APIS.GAME_BACK_PLAY_RESPONSE), this.PlayRecord)
end
