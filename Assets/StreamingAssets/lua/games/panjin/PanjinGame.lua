PanjinGame = { }
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(PanjinGame, mt)
function PanjinGame:SetRoomRemark()
	local roomvo = RoomData;
	local str = "房间号：\n" .. roomvo.roomId .. "\n"
	.. "圈数:" .. roomvo.roundNumber .. "\n\n"
	self.roomRemark.text = str;
end
-- 创建房间
function PanjinGame:CreateRoomAddAvatarVO(avatar)
	self.avatarList = { }
	self:AddAvatarVOToList(avatar);
	self:SetRoomRemark();
	if (RoomData.duanMen or RoomData.jiaGang) then
		self.ReadySelect[1].gameObject:SetActive(RoomData.duanMen)
		self.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang)
		self.btnReadyGame:SetActive(true);
		self.ReadySelect[1].interactable = true;
	else
		self:ReadyGame();
	end
end

-- 加入房间
function PanjinGame:JoinToRoom(avatars)
	self.avatarList = avatars;
	for i = 1, #avatars do
		self:SetSeat(avatars[i])
	end
	self:SetRoomRemark();
	if (RoomData.jiaGang) then
		self.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
		self.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
		self.btnReadyGame:SetActive(true);
		self.ReadySelect[1].interactable = false;
	else
		self:ReadyGame();
	end
end

function PanjinGame:ReEnterRoom()
	if (RoomData.enterType == 3) then
		-- 服务器的坑
		if (RoomData.gui <= 0) then
			RoomData.guiPai = -1
		end
		self:SetRoomRemark();
		-- 设置座位
		self.avatarList = RoomData.playerList
		for i = 1, #self.avatarList do
			self:SetSeat(self.avatarList[i]);
		end
		local selfIndex = self:GetMyIndexFromList()
		LoginData.account.roomcard = self.avatarList[selfIndex].account.roomcard;
		local selfPaiArray = self.avatarList[selfIndex].paiArray;
		if (selfPaiArray == nil or #selfPaiArray == 0) then
			-- 游戏还没有开始
			if (not self.avatarList[selfIndex].isReady) then
				-- log("bankerIndex=" + bankerIndex + "     self.GetMyIndexFromList()=" +  self.GetMyIndexFromList());
				if (RoomData.duanMen or RoomData.jiaGang) then
					self.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
					self.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
					self.btnReadyGame:SetActive(true);
					self.ReadySelect[1].interactable = self.avatarList[self:GetMyIndexFromList()].main;
				else
					-- self.ReadyGame();
				end
			end
			-- 牌局已开始
		else
			self:SetAllPlayerReadImgVisbleToFalse();
			self:CleanGameplayUI();
			-- 显示打牌数据
			self:DisplayTableCards();
			-- 显示鬼牌
			self:DisplayGuiPai();
			-- 显示其他玩家的手牌
			self:DisplayOtherHandercard();
			-- 显示杠牌
			self:DisplayallGangCard();
			-- 显示碰牌
			self:DisplayPengCard();
			-- 显示吃牌
			self:DisplayChiCard();
			self:DispalySelfhanderCard();
			networkMgr:SendMessage(ClientRequest.New(APIS.REQUEST_CURRENT_DATA, "dd"));
		end
	end
end

function PanjinGame:ReadyGame()
	soundMgr:playSoundByActionButton(1);
	local readyvo = { };
	readyvo.duanMen = self.ReadySelect[1].isOn;
	readyvo.jiaGang = self.ReadySelect[2].isOn;
	log("self.ReadySelect[1].isOn=" .. tostring(self.ReadySelect[1].isOn) .. "self.ReadySelect[2].isOn=" .. tostring(self.ReadySelect[2].isOn));
	self.ReadySelect[1].gameObject:SetActive(false);
	self.ReadySelect[2].gameObject:SetActive(false);
	self.btnReadyGame:SetActive(false);
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end

function PanjinGame:StartGame(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local sgvo = json.decode(message);
self.LeavedRoundNumText.text = tostring(sgvo.surplusRounds)
	self:CleanGameplayUI();
	self:UpateTimeReStart();
	self:InitLeftCard();
	self:ShowRuleText(sgvo)

	RoomData.guiPai = sgvo.gui;
	RoomData.surplusTimes = sgvo.surplusRounds
	RoomData.isOverByPlayer = false;

	self.avatarList[sgvo.bankerId + 1].main = true;
	local LocalIndex = self:GetLocalIndex(sgvo.bankerId);
	self.playerItems[LocalIndex].bankerImg.enabled = true
	self:SetDirGameObjectAction(LocalIndex);
	self:DisplayTouzi(sgvo.touzi, sgvo.gui);
	self:InitMyCard(sgvo.paiArray);
	for i = 2, 4 do
		if i == LocalIndex then
			self:InitOtherCardList(i, 14);
		else
			self:InitOtherCardList(i, 13);
		end
	end
	for i = 1, #self.playerItems do
		self.playerItems[self:GetLocalIndex(i - 1)].jiaGang.enabled = sgvo.jiaGang[i]
	end
	self.imgDuanMen.enabled = sgvo.duanMen;
end

function PanjinGame:HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	self:HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		self:PengGangHuEffectCtrl("hu");
		local huPaiPoint = 0;
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = self:GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].cardPoint > -1) then
				huPaiPoint = RoundOverData.avatarList[i].cardPoint;
				if (RoundOverData.avatarList[i].uuid ~= RoundOverData.avatarList[i].dianPaoId) then
					soundMgr:playSoundByAction("hu", self.avatarList[i].account.sex);
				else
					soundMgr:playSoundByAction("zimo", self.avatarList[i].account.sex);
				end
				self.playerItems[LocalIndex].HuFlag.enabled = true
			else
				self.playerItems[LocalIndex].HuFlag.enabled = false
			end
		end
		local allMas = RoundOverData.allMas;
		-- 盘锦麻将绝
		if (RoomData.jue) then
			OpenPanel(ZhuaMaPanel, huPaiPoint)
		coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,7)
		else
			coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
		end
	elseif (RoundOverData.type == "1") then
		soundMgr:playSoundByAction("liuju", LoginData.account.sex);
		self:PengGangHuEffectCtrl("liuju");
coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
	else
coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
	end
end

function PanjinGame:CleanGameplayUI()
	log(tostring(self).. ":CleanGameplayUI")
	RoomData.enterType = 4
	-- weipaiImg.transform.gameObject:SetActive(false);
	self.btnInviteFriend:SetActive(false);
	self.btnJieSan:SetActive(false);
	self.ExitRoomButton.transform.gameObject:SetActive(false);
	self.live1.gameObject:SetActive(true);
	self.liveQuan.gameObject:SetActive(true);
	-- tab.transform.gameObject:SetActive(true);
	self.centerImage.transform.gameObject:SetActive(true);
	self.liujuEffectGame:SetActive(false);
	self:SetAllPlayerReadImgVisbleToFalse();
	self.ruleText.text = "";
	self.lbRoomNum.text = ""
end

function PanjinGame:Recovery()
	self.ReadySelect[1].group = self.ReadySelectGroup
	self.ReadySelect[2].group = self.ReadySelectGroup
end

function PanjinGame:Change()
	self.lbReadySelect[1].text = "买断门"
	self.lbReadySelect[2].text = "加钢"
	self.ReadySelect[1].group = nil
	self.ReadySelect[2].group = nil
end

