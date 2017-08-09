PanjinGame = { }
local this = PanjinGame
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(this, mt)

-- 创建房间
function PanjinGame.CreateRoomAddAvatarVO(avatar)
	GamePanel.avatarList = { }
	this.AddAvatarVOToList(avatar);
	this.SetRoomRemark();
	if (RoomData.duanMen or RoomData.jiaGang) then
		this.ReadySelect[1].gameObject:SetActive(RoomData.duanMen)
		this.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang)
		this.btnReadyGame:SetActive(true);
		this.ReadySelect[1].interactable = true;
	else
		this.ReadyGame();
	end
end

-- 加入房间
function PanjinGame.JoinToRoom(avatars)
	GamePanel.avatarList = avatars;
	for i = 1, #avatars do
		this.SetSeat(avatars[i])
	end
	this.SetRoomRemark();
	if (RoomData.jiaGang) then
		this.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
		this.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
		this.btnReadyGame:SetActive(true);
		this.ReadySelect[1].interactable = false;
	else
		this.ReadyGame();
	end
end

function PanjinGame.ReEnterRoom()
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
				if (RoomData.duanMen or RoomData.jiaGang) then
					this.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
					this.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
					this.btnReadyGame:SetActive(true);
					this.ReadySelect[1].interactable = this.avatarList[this.GetMyIndexFromList()].main;
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

function PanjinGame.ReadyGame()
	soundMgr:playSoundByActionButton(1);
	local readyvo = { };
	readyvo.duanMen = this.ReadySelect[1].isOn;
	readyvo.jiaGang = this.ReadySelect[2].isOn;
	log("this.ReadySelect[1].isOn=" .. tostring(this.ReadySelect[1].isOn) .. "this.ReadySelect[2].isOn=" .. tostring(this.ReadySelect[2].isOn));
	this.ReadySelect[1].gameObject:SetActive(false);
	this.ReadySelect[2].gameObject:SetActive(false);
	this.btnReadyGame:SetActive(false);
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end

function PanjinGame.StartGame(buffer)
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
	for i = 1, #playerItems do
		playerItems[this.GetLocalIndex(i - 1)].jiaGang.enabled = sgvo.jiaGang[i]
	end
	this.imgDuanMen.enabled = sgvo.duanMen;
end

function PanjinGame.HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	this.HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		this.PengGangHuEffectCtrl("hu");
		local huPaiPoint = 0;
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = this.GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].uuid == RoundOverData.winnerId) then
				huPaiPoint = RoundOverData.avatarList[i].cardPoint;
				if (RoundOverData.winnerId ~= RoundOverData.dianPaoId) then
					soundMgr:playSoundByAction("hu", this.avatarList[i].account.sex);
				else
					soundMgr:playSoundByAction("zimo", this.avatarList[i].account.sex);
				end
				this.playerItems[LocalIndex].HuFlag.enabled = true
			else
				this.playerItems[LocalIndex].HuFlag.enabled = false
			end
		end
		local allMas = RoundOverData.allMas;
		-- 盘锦麻将绝
		if (RoomData.jue) then
			OpenPanel(ZhuaMaPanel,huPaiPoint)
			coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 7, allMas)
		else
			coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3, allMas)
		end
	elseif (RoundOverData.type == "1") then
		soundMgr:playSoundByAction("liuju", LoginData.account.sex);
		this.PengGangHuEffectCtrl("liuju");
		coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3)
	else
		coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3)
	end
end

function PanjinGame.Start()
	this.AddListener()
	this.SetUI()
end
function PanjinGame.End()
	this.RemoveListener()
end

function PanjinGame.SetUI()
	this.lbReadySelect[1].text = "买断门"
	this.lbReadySelect[2].text = "加钢"
end

-- 增加事件--
function PanjinGame.AddListener()
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
	Event.AddListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.OtherGang)
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
function PanjinGame.RemoveListener()
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
	Event.RemoveListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.OtherGang)
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