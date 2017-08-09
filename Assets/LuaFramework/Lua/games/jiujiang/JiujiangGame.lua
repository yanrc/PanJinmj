JiujiangGame = { }
local this = JiujiangGame
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(this, mt)

function JiujiangGame.InitLeftCard()
	this.LeavedCardsNum = 120
	this.LeavedCardsNum = this.LeavedCardsNum - 53;
	this.LeavedCastNumText.text = tostring(this.LeavedCardsNum);
end

function JiujiangGame.GangCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	this.SetDirGameObjectAction(LocalIndex);
	this.PengGangHuEffectCtrl("gang");
	soundMgr:playSoundByAction("gang", this.avatarList[cardVo.avatarId + 1].account.sex)
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	local gangKind = cardVo.type;
	local cardPoint = cardVo.cardPoint
	-- 暗杠
	if (gangKind == 1) then
		-- 去掉四张手牌
		this.RemoveHandCard(LocalIndex, cardPoint, 4)
		-- 九江麻将不显示暗杠牌
		this.AddCPGToTable(LocalIndex, cardPoint, 0, 4)
		-- 明杠
	elseif (this.GetPaiInpeng(cardPoint, LocalIndex) == -1) then
		-- 销毁桌上被碰的牌
		this.RemoveLastCardOnTable()
		-- 去掉三张手牌
		this.RemoveHandCard(LocalIndex, cardPoint, 3)
		this.AddCPGToTable(LocalIndex, cardPoint, 4, 0)
		-- 补杠
	else
		this.RemoveHandCard(LocalIndex, cardPoint, 1)
		this.AddCPGToTable(LocalIndex, cardPoint)
	end
	this.SetPosition(LocalIndex);
end
-- 创建房间
function JiujiangGame.CreateRoomAddAvatarVO(avatar)
	GamePanel.avatarList = { }
	this.AddAvatarVOToList(avatar);
	this.SetRoomRemark();
	if (RoomData.piaofen > 0) then
		this.ReadySelect[1].gameObject:SetActive(true)
		if RoomData.piaofen > 1 then
			this.ReadySelect[2].gameObject:SetActive(true)
		end
		this.btnReadyGame:SetActive(true);
	else
		this.ReadyGame();
	end
end

-- 加入房间
function JiujiangGame.JoinToRoom(avatars)
	GamePanel.avatarList = avatars;
	for i = 1, #avatars do
		this.SetSeat(avatars[i])
	end
	this.SetRoomRemark();
	if (RoomData.piaofen > 0) then
		this.ReadySelect[1].gameObject:SetActive(true)
		if RoomData.piaofen > 1 then
			this.ReadySelect[2].gameObject:SetActive(true)
		end
		this.btnReadyGame:SetActive(true);
	else
		this.ReadyGame();
	end
end
function JiujiangGame.ReEnterRoom()
	if (RoomData.enterType == 3) then
		-- 服务器的坑
		if (RoomData.gui <= 0) then
			RoomData.guiPai = -1
		end
		this.SetRoomRemark();
		-- 设置座位
		GamePanel.avatarList = RoomData.playerList
		for i = 1, #this.avatarList do
			this.SetSeat(this.avatarList[i]);
		end
		local selfIndex = this.GetMyIndexFromList()
		LoginData.account.roomcard = this.avatarList[selfIndex].account.roomcard;
		local selfPaiArray = this.avatarList[selfIndex].paiArray;
		if (selfPaiArray == nil or #selfPaiArray == 0) then
			-- 游戏还没有开始
			if (not this.avatarList[selfIndex].isReady) then
				-- log("bankerIndex=" + bankerIndex + "     this.GetMyIndexFromList()=" +  this.GetMyIndexFromList());
				if (RoomData.piaofen > 0) then
					this.ReadySelect[1].gameObject:SetActive(true)
					if RoomData.piaofen > 1 then
						this.ReadySelect[2].gameObject:SetActive(true)
					end
					this.btnReadyGame:SetActive(true);
				else
					this.ReadyGame();
				end
			end
			-- 牌局已开始
		else
			this.SetAllPlayerReadImgVisbleToFalse();
			this.CleanGameplayUI();
			-- 显示打牌数据
			this.DisplayTableCards();
			-- 显示鬼牌
			this.DisplayGuiPai();
			-- 显示其他玩家的手牌
			this.DisplayOtherHandercard();
			-- 显示杠牌
			this.DisplayallGangCard();
			-- 显示碰牌
			this.DisplayPengCard();
			-- 显示吃牌
			this.DisplayChiCard();
			this.DispalySelfhanderCard();
			networkMgr:SendMessage(ClientRequest.New(APIS.REQUEST_CURRENT_DATA, "dd"));
		end
	end
end
-- 发准备消息
function JiujiangGame.ReadyGame()
	soundMgr:playSoundByActionButton(1);
	local readyvo = { };
	readyvo.piaofen = 0
	for i = 1, #this.ReadySelect do
		if this.ReadySelect[i].isOn then
			readyvo.piaofen = i
		end
		this.ReadySelect[i].gameObject:SetActive(false);
	end
	this.btnReadyGame:SetActive(false);
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end
function JiujiangGame.StartGame(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local sgvo = json.decode(message);
	this.CleanGameplayUI();
	this.UpateTimeReStart();
	this.LeavedRoundNumText.text = tostring(sgvo.surplusRounds)
	this.InitLeftCard();
	this.ShowRuleText(sgvo)

	RoomData.guiPai = sgvo.gui;
	RoomData.surplusTimes = sgvo.surplusRounds
	RoomData.isOverByPlayer = false;

	this.avatarList[sgvo.bankerId + 1].main = true;
	local LocalIndex = this.GetLocalIndex(sgvo.bankerId);
	this.playerItems[LocalIndex].bankerImg.enabled = true
	this.SetDirGameObjectAction(LocalIndex);
	this.DisplayTouzi(sgvo.touzi, sgvo.gui);
	this.InitMyCard(sgvo.paiArray);
	for i = 2, 4 do
		if i == LocalIndex then
			this.InitOtherCardList(i, 14);
		else
			this.InitOtherCardList(i, 13);
		end
	end
end


function JiujiangGame.Start()
	this.AddListener()
	this.SetUI()
end
function JiujiangGame.End()
	this.RemoveListener()
	this.RecoveryUI()
end

function JiujiangGame.RecoveryUI()
	this.lbReadySelect[1].text = ""
	this.lbReadySelect[2].text = ""
end

function JiujiangGame.SetUI()
	this.lbReadySelect[1].text = "捆1分"
	this.lbReadySelect[2].text = "捆2分"
end


-- 增加事件--
function JiujiangGame.AddListener()
	UpdateBeat:Add(this.Update);
	FixedUpdateBeat:Add(MicPhone.FixedUpdate);
	Event.AddListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
	Event.AddListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
	Event.AddListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
	Event.AddListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
	Event.AddListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
	Event.AddListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
	Event.AddListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
	Event.AddListener(tostring(APIS.GANGPAI_RESPONSE), this.GangCard)
	Event.AddListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.GangCard)
	Event.AddListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
	Event.AddListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
	Event.AddListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
	Event.AddListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
	Event.AddListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
	Event.AddListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
	Event.AddListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
	Event.AddListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
	Event.AddListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
	Event.AddListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
	Event.AddListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
	Event.AddListener(tostring(APIS.HUPAIALL_RESPONSE), this.HUPAIALL_RESPONSE)
	

	this.lua:AddClick(this.huBtn, this.HubtnClick)
	this.lua:AddClick(this.gangBtn, this.GangBtnClick)
	this.lua:AddClick(this.pengBtn, this.PengBtnClick)
	this.lua:AddClick(this.chiBtn, this.ChiBtnClick)
	this.lua:AddClick(this.passBtn, this.PassBtnClick)
	this.lua:AddClick(this.btnBu, this.BuBtnClick)
	this.lua:AddClick(this.ChiSelect1, this.ChiBtnClick2, 1)
	this.lua:AddClick(this.ChiSelect2, this.ChiBtnClick2, 2)
	this.lua:AddClick(this.ChiSelect3, this.ChiBtnClick2, 3)
	this.lua:AddClick(this.btnReadyGame, this.ReadyGame)
end
-- 移除事件--
function JiujiangGame.RemoveListener()
	UpdateBeat:Remove(this.Update);
	FixedUpdateBeat:Remove(MicPhone.FixedUpdate);
	Event.RemoveListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
	Event.RemoveListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
	Event.RemoveListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
	Event.RemoveListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
	Event.RemoveListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
	Event.RemoveListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
	Event.RemoveListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
	Event.RemoveListener(tostring(APIS.GANGPAI_RESPONSE), this.GangCard)
	Event.RemoveListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.GangCard)
	Event.RemoveListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
	Event.RemoveListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
	Event.RemoveListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
	Event.RemoveListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
	Event.RemoveListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
	Event.RemoveListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
	Event.RemoveListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
	Event.RemoveListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
	Event.RemoveListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
	Event.RemoveListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
	Event.RemoveListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
	Event.RemoveListener(tostring(APIS.HUPAIALL_RESPONSE), this.HUPAIALL_RESPONSE)
	this.lua:ResetClick(this.huBtn)
	this.lua:ResetClick(this.gangBtn)
	this.lua:ResetClick(this.pengBtn)
	this.lua:ResetClick(this.chiBtn)
	this.lua:ResetClick(this.passBtn)
	this.lua:ResetClick(this.btnBu)
	this.lua:ResetClick(this.ChiSelect1)
	this.lua:ResetClick(this.ChiSelect2)
	this.lua:ResetClick(this.ChiSelect3)
	this.lua:ResetClick(this.btnReadyGame)
end