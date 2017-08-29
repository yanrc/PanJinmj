ChangshaGame = { }
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(ChangshaGame, mt)


function ChangshaGame:InitLeftCard()
	self.LeavedCardsNum = 108
	self.LeavedCardsNum = self.LeavedCardsNum - 53;
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end

function ChangshaGame:StartGame(buffer)
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
			self:InitOtherCardList(i, 13);
	end
	--开始不能出牌
	self.CurLocalIndex=0
end

-- 胡，杠，碰，吃，pass按钮显示.
function ChangshaGame:ActionBtnShow(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	log("GamePanel ActionBtnShow:msg =" .. tostring(message));
	self.passStr = "";
	local strs = string.split(message, ',')
	self:ShowBtn(5, true);
	for i = 1, #strs do
		if string.match(strs[i], "hu") then
			self:ShowBtn(1, true);
			self.passStr = self.passStr .. "hu_"
		end
		if string.match(strs[i], "qianghu") then
			self.putOutCardPoint = string.split(strs[i], ':')[2]
			self:ShowBtn(1, true);
			self.passStr = self.passStr .. "qianghu_"
		end
		if string.match(strs[i], "peng") then
			self:ShowBtn(3, true);
			self.putOutCardPoint = string.split(strs[i], ':')[3]
			self.passStr = self.passStr .. "peng_"
		end
		if string.match(strs[i], "gang") then
			self:ShowBtn(6, true);
			self.gangPaiList = string.split(strs[i], ':');
			table.remove(self.gangPaiList, 1)
			self.passStr = self.passStr .. "gang_"
		end
		if string.match(strs[i], "kaigang") then
			self:ShowBtn(2, true);
			self.kaigangPaiList = string.split(strs[i], ':');
			table.remove(self.kaigangPaiList, 1)
			self.passStr = self.passStr .. "gang_"
		end
		if string.match(strs[i], "chi") then
			-- 格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			-- eg:"chi:1:2|1_2_3|2_3_4"
			local strChi = string.split(strs[i], '|');
			local cardPoint = string.split(strChi[1], ':')[3];
			self.chiPaiPointList = { };
			for m = 2, #strChi do
				local strChiList = string.split(strChi[m], '_');
				local cpoint = { };
				cpoint.putCardPoint = cardPoint;
				for n = 1, #strChiList do
					if (strChiList[n] == cardPoint) then
						table.remove(strChiList, n)
					end
				end
				cpoint.oneCardPoint = strChiList[1]
				cpoint.twoCardPoint = strChiList[2]
				table.insert(self.chiPaiPointList, cpoint)
			end
			self:ShowBtn(4, true);
			self.passStr = self.passStr .. "chi_"
		end
	end
end
function ChangshaGame:GangBtnClick()
	local GangRequestVO = { }
	GangRequestVO.cardPoint = tonumber(self.kaigangPaiList[1])
	GangRequestVO.gangType = 0;
	GangRequestVO.kaigang = true;
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	soundMgr:playSoundByAction("gang", LoginData.account.sex);
	self:PengGangHuEffectCtrl("gang");
	self:CleanBtnShow();
	self:CompleteBtnAction()
end

-- 0.明杠，1.暗杠，2.补杠
function ChangshaGame:GangCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local gangType = cardVo.type;
	local cardPoint = cardVo.cardPoint
	local kaigang = cardVo.kaigang
	if(kaigang) then
	self:PengGangHuEffectCtrl("gang");
	else
	self:PengGangHuEffectCtrl("bu");
	end
	soundMgr:playSoundByAction("gang", self.avatarList[cardVo.avatarId + 1].account.sex)
	local LocalIndex = self:GetLocalIndex(cardVo.avatarId);
	self:SetDirGameObjectAction(LocalIndex);
	-- 明杠
	if gangType == 0 then
		-- 销毁桌上被碰的牌
		self:RemoveLastCardOnTable()
		-- 去掉三张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 3)
		self:AddCPGToTable(LocalIndex, cardPoint, 4, 0)
		-- 暗杠
	elseif (gangType == 1) then
		-- 去掉四张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 4)
		self:AddCPGToTable(LocalIndex, cardPoint, 1, 3)
		-- 补杠
	elseif gangType == 2 then
		self:RemoveHandCard(LocalIndex, cardPoint, 1)
		self:AddCPGToTable(LocalIndex, cardPoint)
	end
	if kaigang then
		self.avatarList[cardVo.avatarId + 1].tingPai = true
		self:LockHandCard(LocalIndex)
	end
	self:SetPosition(LocalIndex);
end

function ChangshaGame:HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	self:HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		self:PengGangHuEffectCtrl("hu");
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = self:GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].cardPoint>-1) then
				RoundOverData.winnerIndex = LocalIndex
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
		if (RoomData.ma > 0) then
			local malist = string.split(allMas,':')
			OpenPanel(ZhuaMaPanel)
			ZhuaMaPanel.CreateMaiPai(malist)
			ZhuaMaPanel.MoveMaiPai(RoundOverData.winnerIndex, malist)
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
