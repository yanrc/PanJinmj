RecordPlayerItem = {
	gameObject,
	headerIcon,-- 头像
	bankerImg,-- 庄家
	nameText,-- 名字
	scoreText,-- 分数
	jiaGang,-- 加钢、飘分等
	HuFlag,-- 胡牌图标
	ChiEffect,
	PengEffect,
	GangEffect,
	HuEffect,
}
local mt = { }-- 元表（基类）
mt.__index = RecordPlayerItem-- index方法
-- 构造函数
function RecordPlayerItem.New(go)
	local playerItem = { }
	setmetatable(playerItem, mt)
	playerItem.gameObject = go
	playerItem.headerIcon = go:GetComponent('Image')
	playerItem.bankerImg = go.transform:Find('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:Find('Text'):GetComponent('Text')
	-- playerItem.readyImg = go.transform:Find('readyImg'):GetComponent('Image')
	playerItem.scoreText = go.transform:Find('Coins'):GetComponent('Text')
	-- playerItem.chatAction = go.transform:Find('Image_Chat').gameObject
	-- playerItem.offlineImage = go.transform:Find('Image_offline'):GetComponent('Image')
	-- playerItem.chatMessage = go.transform:Find('chatBg/Text'):GetComponent('Text')
	-- playerItem.chatPaoPao = go.transform:Find('chatBg').gameObject
	playerItem.HuFlag = go.transform:Find('Image_hu').gameObject
	playerItem.jiaGang = go.transform:Find('jiagang'):GetComponent('Image')
	playerItem.ChiEffect = go.transform:Find('ChiEffect').gameObject
	playerItem.PengEffect = go.transform:Find('PengEffect').gameObject
	playerItem.GangEffect = go.transform:Find('GangEffect').gameObject
	playerItem.HuEffect = go.transform:Find('HuEffect').gameObject
	return playerItem
end



function RecordPlayerItem:SetAvatarVo(avatar)
	if (avatar ~= nil) then
		-- self.bankerImg.enabled = avatar.main;
		self.jiaGang.enabled = avatar.jiagang
		self.nameText.text = avatar.accountName;
		self.scoreText.text = avatar.socre
		CoMgr.LoadImg(self.headerIcon, avatar.headicon);
	else
		self:Clean()
	end
end

function RecordPlayerItem:Clean()
	self.headerIcon.sprite = UIManager.DefaultIcon
	self.bankerImg.enabled = false
	self.jiaGang.enabled = false
	self.scoreText.text = "";
	self.nameText.text = ""
end

