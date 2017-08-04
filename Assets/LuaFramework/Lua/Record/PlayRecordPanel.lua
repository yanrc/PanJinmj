
PlayRecordPanel = UIBase(define.Panels.PlayRecordPanel, define.PopUI);
local this = PlayRecordPanel;
local transform;
local gameObject;

local usedList
local handerCardList
local tableCardList
local PengGangList

local indexList
local cardCount
local roomRemark
local CastNumText
local stepNum
-- local myIndex
-- 启动事件--
function PlayRecordPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)

	-- btnExit = transform:FindChild('Image_Bg/Button_Sure').gameObject
	-- btnCancel = transform:FindChild('Image_Bg/Button_Cancle').gameObject
	-- title = transform:FindChild('Image_Bg/Title'):GetComponent('Text')
	-- content = transform:FindChild('Image_Bg/Content'):GetComponent('Text')
	-- this.lua:AddClick(btnCancel, this.CloseClick)
end



function PlayRecordPanel.PlayRecord(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message)
	this.InitArrayList()
	local avatarList = this.ReBuild(data.playerItems)
	this.SetRoomRemark(data, avatarList[1].gameRound)
	this.InitPlayerItem(avatarList)
	this.InitCard(avatarList)
	coroutine.start(this.Play)
end

function PlayRecordPanel.InitPlayerItem(avatarList)
	for i = 1, #avatarList do
		playerItems[i]:SetAvatarVo(avatarList[i])
	end
end

function PlayRecordPanel.InitCard(avatarList)
	for i = 1, #avatarList do
		local cardList = string.split(avatarList[i].cardList, ',')
		for j = 1, #cardList do
			local num = tonumber(cardList[j])
			if (num > 0) then
				for k = 1, num do
					local obj = newObject(UIManager.HandCard)
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
		[1] = function(i) return Vector2.New(-606 + i * 80, -292) end,
		[2] = function(i) return Vector2.New(0, -361 + i * 30) end,
		[3] = function(i) return Vector2.New(300 - 37 * i, 0) end,
		[4] = function(i) return Vector2.New(0, 315 - i * 30) end,
	}
	for i = 1, count do
		tempList[i].gameObject.transform.localPosition = switch[LocalIndex](i)
	end
	if (count % 3 == 2) then
		tempList[count].gameObject.transform.localPosition = switch[LocalIndex](count + 1)
	end
end

function PlayRecordPanel.SortCard(list)
	table.sort(list,
	function(a, b)
		return a.CardPoint < b.CardPoint
	end )
end

function PlayRecordPanel.SetRoomRemark(data, CurrentRound)
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
	CastNumText.text = cardCount
	imgDuanMen.enabled = data.duanmen;
	RoundNumText.text = roomvo.roundNumber - CurrentRound;
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

-- 调整playerItems的顺序
function PlayRecordPanel.ReBuild(playerItems)
	local avatarList = { }
	local temp = { { 1, 2, 3, 4 }, { 2, 3, 4, 1 }, { 3, 4, 1, 2 }, { 4, 1, 2, 3 } }
	local myIndex = 1
	for i = 1, #playerItems do
		if playerItems[i].uuid == LoginData.account.uuid then
			myIndex = i;
		end
	end
	indexList = temp[myIndex]
	for i = 1, #playerItems do
		local index = indexList[i]
		avatarList[i] = playerItems[index]
	end
	return avatarList
end


function PlayRecordPanel.Play()
	stepNum = 0
	while (true) do
		if stepNum < #behavieList then
			this.ForwardClick()
			coroutine.wait(2)
		else
			processText.text = "播放进度：100%";
			return
		end
	end
end


function PlayRecordPanel.PlayClick()
	btnPlay.SetActive(false);
	btnStop.SetActive(true);
	coroutine.start(this.Play)
end

function PlayRecordPanel.StopClick()
	btnPlay.SetActive(true);
	btnStop.SetActive(false);
	coroutine.stop(this.Play)
end

function PlayRecordPanel.ForwardClick(behavieList)
	local temp = behavieList[stepNum];
	table.insert(usedList, temp)
	local LocalIndex = indexList[temp.accountindex_id]
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
	stepNum = stepNum + 1
	processText.text = "播放进度：" +(int)(stepNum * 100 / aa.behavieList.Count) + "%";
end

function PlayRecordPanel.BackwardClick()
	if #usedList > 0 then
		local temp = usedList[#usedList];
		table.remove(usedList)
		local LocalIndex = indexList[temp.accountindex_id]
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
		processText.text = "播放进度：" .. stepNum * 100 / #behavieList .. "%";
	end
end


function PlayRecordPanel.OutCard(LocalIndex, temp)

end
function PlayRecordPanel.PickCard(LocalIndex, temp)


end
function PlayRecordPanel.ChiCard(LocalIndex, temp)

end
function PlayRecordPanel.PengCard(LocalIndex, temp)

end
function PlayRecordPanel.GangCard(LocalIndex, temp)

end
function PlayRecordPanel.HuCard(LocalIndex, temp)

end
function PlayRecordPanel.QiangGangHu(LocalIndex, temp)

end
function PlayRecordPanel.Zhuama(temp)

end
function PlayRecordPanel.Liuju()

end
			    
function PlayRecordPanel.FrontOutCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontPickCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontChiCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontPengCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontGangCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontHuCard(LocalIndex, temp)

end
function PlayRecordPanel.FrontQiangGangHu(LocalIndex, temp)

end
function PlayRecordPanel.FrontZhuama(temp)

end
function PlayRecordPanel.FrontLiuju()

end


function PlayRecordPanel.ExitClick()
	OpenPanel(ExitPanel, "提示", "您确定要退出回放吗？", this.CloseClick)
end
-------------------模板-------------------------
function PlayRecordPanel.CloseClick()
	ClosePanel(ExitPanel)
	ClosePanel(this)
	soundMgr:playSoundByActionButton(1);
end

function PlayRecordPanel.OnOpen()

end
-- 移除事件--
function PlayRecordPanel.RemoveListener()
	UpdateBeat:Remove(this.Update);
	Event.RemoveListener(tostring(APIS.GAME_BACK_PLAY_RESPONSE), this.PlayRecord)
end

-- 增加事件--
function PlayRecordPanel.AddListener()
	UpdateBeat:Add(this.Update);
	Event.AddListener(tostring(APIS.GAME_BACK_PLAY_RESPONSE), this.PlayRecord)
end
