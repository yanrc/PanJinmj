FinalOverItem = {
	gameObject,
	transform,
	nickName,
	ID,
	icon,
	fangzhu,
	winner,
	paoshou,
	zimoCount,
	jiepaoCount,
	dianpaoCount,
	angangCount,
	minggangCount,
	finalScore,
}
local mt = { }-- 元表（基类）
mt.__index = FinalOverItem-- index方法
function FinalOverItem.New(obj)
	local this = { }
	this.gameObject = obj
	this.transform = obj.transform
	-- 名字
	this.nickName = obj.transform:FindChild("Text_Nnick_name"):GetComponent("Text")
	-- id
	this.ID = obj.transform:FindChild("Text_ID"):GetComponent("Text")
	-- 头像
	this.icon = obj.transform:FindChild("Image_Icon"):GetComponent("Image")
	-- 房主
	this.fangzhu = obj.transform:FindChild("fangzhu"):GetComponent("Image")
	-- 大赢家
	this.winner = obj.transform:FindChild("Image_Yingjia"):GetComponent("Image")
	-- 炮手
	this.paoshou = obj.transform:FindChild("Image_PaoShou"):GetComponent("Image")
	-- 自摸次数
	this.zimoCount = obj.transform:FindChild("Counts/zimoCount/Text_Zimo_Count"):GetComponent("Text")
	-- 接炮次数
	this.jiepaoCount = obj.transform:FindChild("Counts/jiepaoCount/Text_Jiepao_Count"):GetComponent("Text")
	-- 点炮次数
	this.dianpaoCount = obj.transform:FindChild("Counts/dianpaoCount/Text_Dianpao_Count"):GetComponent("Text")
	-- 暗杠次数
	this.angangCount = obj.transform:FindChild("Counts/angangCount/Text_Angang_Count"):GetComponent("Text")
	-- 明杠次数
	this.minggangCount = obj.transform:FindChild("Counts/minggangCount/Text_Minggang_Count"):GetComponent("Text")
	-- 总成绩
	this.finalScore = obj.transform:FindChild("Text_Score"):GetComponent("Text")
	setmetatable(this, mt)
	return this
end

function FinalOverItem:SetUI(itemData)
	self.fangzhu.enabled = itemData.IsMain
	self.nickName.text = itemData.Nickname;
	self.ID.text = "ID:" .. itemData.uuid;
	self.winner.enabled =(itemData.IsWiner and itemData.scores > 0)
	self.paoshou.enabled =(itemData.IsPaoshou and itemData.dianpao > 0)
	self.zimoCount.text = itemData.zimo;
	self.jiepaoCount.text = itemData.jiepao;
	self.dianpaoCount.text = itemData.dianpao;
	self.angangCount.text = itemData.angang;
	self.minggangCount.text = itemData.minggang;
	self.finalScore.text = itemData.scores;
	CoMgr.LoadImg(icon, itemData.Icon);
end