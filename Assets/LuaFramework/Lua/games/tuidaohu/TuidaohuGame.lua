TuidaohuGame = { }
local this = TuidaohuGame
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(this, mt)

function TuidaohuGame.InitLeftCard()
	this.LeavedCardsNum = 112
	this.LeavedCardsNum = this.LeavedCardsNum - 53;
	this.LeavedCastNumText.text = tostring(this.LeavedCardsNum);
end

function TuidaohuGame.Start()
	this.AddListener()
end
function TuidaohuGame.End()
	this.RemoveListener()
end
function TuidaohuGame.StartGame(buffer)
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
function TuidaohuGame.HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	this.HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		this.PengGangHuEffectCtrl("hu");
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = this.GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].uuid == RoundOverData.winnerId) then
				RoundOverData.winnerIndex = LocalIndex
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
		if (RoomData.ma > 0) then
			local malist = string.split(allMas)
			OpenPanel(ZhuaMaPanel)
			ZhuaMaPanel.CreateMaiPai(malist)
			ZhuaMaPanel.MoveMaiPai(RoundOverData.winnerIndex, malist)
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
-- 增加事件--
function TuidaohuGame.AddListener()
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
function TuidaohuGame.RemoveListener()
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
