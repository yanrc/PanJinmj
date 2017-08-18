TuidaohuGame = { }
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(TuidaohuGame, mt)

function TuidaohuGame:InitLeftCard()
	self.LeavedCardsNum = 112
	self.LeavedCardsNum = self.LeavedCardsNum - 53;
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end

function TuidaohuGame:StartGame(buffer)
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
function TuidaohuGame:HupaiCallBack(buffer)
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
			local malist = string.split(allMas)
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

