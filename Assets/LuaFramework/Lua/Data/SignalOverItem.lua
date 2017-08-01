SignalOverItem = {
	gameObject,
	transform,
	nickName,
	resultDes,
	huFlagImg,
	fanCount,
	gangScore,
	totalScroe,
	paiArrayPanel,
	zhongMaFlag,
	GenzhuangFlag,
	gangPaiList,
	pengPaiList,
	chiPaiList,
	hupaiObj,
	Banker,
	JiaGang,
}
local mt = { }-- 元表（基类）
mt.__index = SignalOverItem-- index方法
-- 构造函数
function SignalOverItem.New(obj)
	local this = { }
	this.gameObject = obj
	this.transform = obj.transform
	-- 名字
	this.nickName = obj.transform:FindChild("Text_Palyer_Name"):GetComponent("Text")
	-- 描述
	this.resultDes = obj.transform:FindChild("Text_Game_Result_Describe"):GetComponent("Text")
	-- 胡牌图标
	this.huFlagImg = obj.transform:FindChild("Image_Hu_Label"):GetComponent("Image")
	-- 番数
	this.fanCount = obj.transform:FindChild("Scores/Text/Text_Fanshu"):GetComponent("Text")
	-- 杠分
	this.gangScore = obj.transform:FindChild("Scores/Text1/Text_Gangfen"):GetComponent("Text")
	-- 总分
	this.totalScroe = obj.transform:FindChild("Scores/Text2/Text_Total_Score"):GetComponent("Text")
	-- 牌面板
	this.paiArrayPanel = obj.transform:FindChild("Panel_Pai_Array")
	-- 中码图片
	this.zhongMaFlag = obj.transform:FindChild("Image_zhongma_flag"):GetComponent("Image")
	-- 跟庄图片
	this.GenzhuangFlag = obj.transform:FindChild("Image_gen_zhuang"):GetComponent("Image")
	-- 庄家图片
	this.Banker = obj.transform:FindChild("Text_Palyer_Name/Image_banker"):GetComponent("Image")
	-- 加钢文字
	this.JiaGang = obj.transform:FindChild("Text_Palyer_Name/Text_jiagang"):GetComponent("Text")
	this.gangPaiList = { }
	this.pengPaiList = { }
	this.chiPaiList = { }
	setmetatable(this, mt)
	return this
end

function SignalOverItem:SetUI(itemData, Banker)
	self.nickName.text = itemData.nickname;
	self.totalScroe.text = tostring(itemData.totalScore);
	self.gangScore.text = tostring(itemData.gangScore);
	self.fanCount.text = tostring(itemData.totalScore - itemData.gangScore)
	self.huFlagImg.enabled =(itemData.uuid == RoundOverData.winnerId);
	self.Banker.enabled =(itemData.uuid == Banker);
	self.JiaGang.text = "";
	self.GenzhuangFlag.enabled =(itemData.totalInfo.genzhuang == "1" and itemData.uuid == Banker)
	self:AnalysisPaiInfo(itemData);
end

function SignalOverItem:AnalysisPaiInfo(itemData)
	local mdesCribe = ''
	local paiArray = itemData.paiArray;
	local totalInfo = itemData.totalInfo;
	-- 杠
	local gangpaiStr = totalInfo.gang;
	if (gangpaiStr ~= nil) then
		local gangs = string.split(gangpaiStr, ',')
		for i = 1, #gangs do
			local items = string.split(gangs[i], ':')
			local temp = { }
			temp.uuid = items[1]
			temp.cardPoint = tonumber(items[2])
			temp.type = items[3]
			-- 增加判断是否为自己的杠牌的操作
			paiArray[temp.cardPoint+1] = paiArray[temp.cardPoint+1] -4;
			table.insert(self.gangPaiList, temp)
			if (temp.type == "an") then
				mdesCribe = mdesCribe .. "暗杠  ";
			else
				mdesCribe = mdesCribe .. "明杠  ";
			end
		end
	end
	-- 碰
	local pengpaiStr = totalInfo.peng;
	if (pengpaiStr ~= nil) then
		local pengs = string.split(pengpaiStr, ',')
		for i = 1, #pengs do
			local cardPoint = tonumber(pengs[i])
			paiArray[cardPoint+1] = paiArray[cardPoint+1] -3;
			table.insert(self.pengPaiList, cardPoint)
		end
	end
	-- 吃
	local chipaiStr = totalInfo.chi;
	if (chipaiStr ~= nil) then
		local chis = string.split(chipaiStr, ',')
		for i = 1, #chis do
			local items = string.split(chis[i], '|')
			local cardPoint1 = tonumber(items[1])
			local cardPoint2 = tonumber(items[2])
			local cardPoint3 = tonumber(items[3])
			paiArray[cardPoint1+1] = paiArray[cardPoint1+1] -1;
			paiArray[cardPoint2+1] = paiArray[cardPoint2+1] -1;
			paiArray[cardPoint3+1] = paiArray[cardPoint3+1] -1;
			local temp = { }
			temp.cardPoints = { cardPoint1, cardPoint2, cardPoint3 };
			table.insert(self.chiPaiList, temp)
		end
	end
	if (itemData.uuid == RoundOverData.winnerId) then
		paiArray[itemData.cardPoint+1] = paiArray[itemData.cardPoint+1] -1;
	end
	if (itemData.huType ~= nil) then
		mdesCribe = mdesCribe .. itemData.huType
	end
	self.resultDes.text = mdesCribe;
	self:ArrangePai(itemData);
end


-- 显示牌
function SignalOverItem:ArrangePai(itemData)
	local startPosition = 30
	-- 显示杠牌
	if (#self.gangPaiList>0) then
		for i = 1, #self.gangPaiList do
			local cardPoint = self.gangPaiList[i].cardPoint;
			for j = 1, 4 do
				local obj = newObject(UIManager.TopAndBottomCard)
				obj.transform.parent = self.paiArrayPanel
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector2.New(startPosition, 0);
				startPosition = startPosition + 36
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, 3)
			end
		end
		startPosition = startPosition + 8
	end
	if (#self.pengPaiList >0) then
		for i = 1, #self.pengPaiList do
			local cardPoint = self.pengPaiList[i];
			for j = 1, 3 do
				local obj = newObject(UIManager.TopAndBottomCard)
				obj.transform.parent = self.paiArrayPanel
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector2.New(startPosition, 0);
				startPosition = startPosition + 36
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, 3)

			end
		end
		startPosition = startPosition + 8
	end
	if (#self.chiPaiList >0) then
		for i = 1, #self.chiPaiList do
			for j = 1, 3 do
				local cardPoint = self.chiPaiList[i].cardPoints[j];
				local obj = newObject(UIManager.TopAndBottomCard)
				obj.transform.parent = self.paiArrayPanel
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector2.New(startPosition, 0);
				startPosition = startPosition + 36
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, 3)
			end
		end
		startPosition = startPosition + 8
	end
	local paiArray = itemData.paiArray;
	for i = 1, #paiArray do
		if (paiArray[i] > 0) then
			local cardPoint = i - 1
			local count = paiArray[i]
			for j = 1, count do
				local obj = newObject(UIManager.TopAndBottomCard)
				obj.transform:SetParent(self.paiArrayPanel)
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector2.New(startPosition, 0);
				startPosition = startPosition + 36
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, 3)
			end
		end
	end
	startPosition = startPosition + 8
	if (itemData.cardPoint > -1 and itemData.uuid == RoundOverData.winnerId) then
		local cardPoint = itemData.cardPoint
		local obj = newObject(UIManager.TopAndBottomCard)
		obj.transform:SetParent(self.paiArrayPanel)
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = Vector2.New(startPosition, 0);
		startPosition = startPosition + 36
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(cardPoint, 3)
	end
	startPosition = startPosition + 52
end