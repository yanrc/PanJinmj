JiujiangGame = { }
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(JiujiangGame, mt)

function JiujiangGame:InitLeftCard()
	self.LeavedCardsNum = 120
	self.LeavedCardsNum = self.LeavedCardsNum - 53;
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end

function JiujiangGame:GangCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local LocalIndex = self:GetLocalIndex(cardVo.avatarId);
	local gangKind = cardVo.type;
	local cardPoint = cardVo.cardPoint
	self:SetDirGameObjectAction(LocalIndex);
	self:PengGangHuEffectCtrl("gang");
	soundMgr:playSoundByAction("gang", self.avatarList[cardVo.avatarId + 1].account.sex)
	-- 暗杠
	if (gangKind == 1) then
		-- 去掉四张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 4)
		-- 九江麻将不显示暗杠牌
		self:AddCPGToTable(LocalIndex, cardPoint, 0, 4)
		-- 明杠
	elseif (self:GetPaiInpeng(cardPoint, LocalIndex) == -1) then
		-- 销毁桌上被碰的牌
		self:RemoveLastCardOnTable()
		-- 去掉三张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 3)
		self:AddCPGToTable(LocalIndex, cardPoint, 4, 0)
		-- 补杠
	else
		self:RemoveHandCard(LocalIndex, cardPoint, 1)
		self:AddCPGToTable(LocalIndex, cardPoint)
	end
	self:SetPosition(LocalIndex);
end
-- 创建房间
function JiujiangGame:CreateRoomAddAvatarVO(avatar)
	self.avatarList = { }
	self:AddAvatarVOToList(avatar);
	self:SetRoomRemark();
	if (RoomData.piaofen > 0) then
		self.ReadySelect[1].gameObject:SetActive(true)
		if RoomData.piaofen > 1 then
			self.ReadySelect[2].gameObject:SetActive(true)
		end
		self.btnReadyGame:SetActive(true);
	else
		self:ReadyGame();
	end
end

-- 加入房间
function JiujiangGame:JoinToRoom(avatars)
	self.avatarList = avatars;
	for i = 1, #avatars do
		self:SetSeat(avatars[i])
	end
	self:SetRoomRemark();
	if (RoomData.piaofen > 0) then
		self.ReadySelect[1].gameObject:SetActive(true)
		if RoomData.piaofen > 1 then
			self.ReadySelect[2].gameObject:SetActive(true)
		end
		self.btnReadyGame:SetActive(true);
	else
		self:ReadyGame();
	end
end
function JiujiangGame:ReEnterRoom()
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
				if (RoomData.piaofen > 0) then
					self.ReadySelect[1].gameObject:SetActive(true)
					if RoomData.piaofen > 1 then
						self.ReadySelect[2].gameObject:SetActive(true)
					end
					self.btnReadyGame:SetActive(true);
				else
					--self.ReadyGame();
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
-- 发准备消息
function JiujiangGame:ReadyGame()
	soundMgr:playSoundByActionButton(1);
	local readyvo = { };
	readyvo.piaofen = 0
	for i = 1, #self.ReadySelect do
		if self.ReadySelect[i].isOn then
			readyvo.piaofen = i
		end
		self.ReadySelect[i].gameObject:SetActive(false);
	end
	self.btnReadyGame:SetActive(false);
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end
function JiujiangGame:StartGame(buffer)
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
end


function JiujiangGame:Recovery()
	self.lbReadySelect[1].text = ""
	self.lbReadySelect[2].text = ""
end

function JiujiangGame:Change()
	self.lbReadySelect[1].text = "捆1分"
	self.lbReadySelect[2].text = "捆2分"
end

