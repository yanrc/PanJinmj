GameOverScript = {

}
local mt = { }-- 元表（基类）
mt.__index = GameOverScript-- index方法
-- 构造函数
function GameOverScript.New(obj)
	local gameOverScript = { }
	setmetatable(gameOverScript, mt)
	return gameOverScript
end
-- 设置面板的显示内容
-- flg:0显示单局数据，1显示本轮数据
function GameOverScript:SetDisplaContent(flg, personList, allMas, validMas, isNextBanker)
	self.AvatarList = personList;
	self.ValidMas = validMas;
	self:initRoomBaseInfo();
	self:ClearPanel();
	self.jushuText.text = "圈数：" ..(GlobalData.totalTimes - GlobalData.surplusTimes) .. "/" .. GlobalData.totalTimes;
	if (flg == 0) then
		allMasList = { }
		mas_0 = { }
		mas_1 = { }
		mas_2 = { }
		mas_3 = { }
		self.signalEndPanel:SetActive(true);
		self.finalEndPanel:SetActive(false);
		self.continueGame:SetActive(true);
		self.shareFinalButton:SetActive(false);
		self.button_Delete:SetActive(false);
		self.closeButton.transform.gameObject:SetActive(false);
		-- 本轮结束，显示查看战绩按钮
		if (GlobalDataScript.surplusTimes == 0 or GlobalDataScript.isOverByPlayer) then
			self.shareSiganlButton.gameObject:SetActive(true);
			self.continueGame.gameObject:SetActive(false);
		else
			self.shareSiganlButton.gameObject:SetActive(false);
			self.continueGame.gameObject:SetActive(true);
			self.ReadySelect[0].gameObject:SetActive(GlobalDataScript.roomVo.duanMen);
			self.ReadySelect[1].gameObject:SetActive(GlobalDataScript.roomVo.jiaGang);
			self.ReadySelect[0].interactable = isNextBanker;
		end
		self:getMas(allMas);
		self:setSignalContent();
	elseif (flg == 1) then
		self.signalEndPanel:SetActive(false);
		self.finalEndPanel:SetActive(true);
		self.shareSiganlButton:SetActive(false);
		self.continueGame.gameObject:SetActive(false);
		self.continueGame:SetActive(false);
		self.shareFinalButton:SetActive(true);
		self.button_Delete:SetActive(true);
		self.closeButton.transform.gameObject:SetActive(true);
		self:setFinalContent();
	end
end

function GameOverScript:ClearPanel()
	for i = 0, #signalEndPanel.transform.childCount do
		destroy(signalEndPanel.transform:GetChild(i).gameObject);
	end
	for i = 0, #finalEndPanel.transform.childCount do
		destroy(finalEndPanel.transform:GetChild(i).gameObject);
	end
end


function GameOverScript:initRoomBaseInfo()
	timeText.text = DateTime.Now.ToString("yyyy-MM-dd");
	roomNoText.text = "房间号：" + GlobalData.roomVo.roomId;
	if (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN) then
		title.text = "转转麻将";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_HUASHUI) then
		title.text = "划水麻将";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
		title.text = "长沙麻将";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
		title.text = "广东麻将";
	elseif (GlobalDataScript.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
		title.text = "盘锦麻将";
	end
end

function GameOverScript:getMas()

end

function GameOverScript:setSignalContent()


end

function GameOverScript:setFinalContent()

end