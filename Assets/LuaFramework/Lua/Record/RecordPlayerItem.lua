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
	playerItem.bankerImg = go.transform:FindChild('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:FindChild('Text'):GetComponent('Text')
	-- playerItem.readyImg = go.transform:FindChild('readyImg'):GetComponent('Image')
	playerItem.scoreText = go.transform:FindChild('Coins'):GetComponent('Text')
	-- playerItem.chatAction = go.transform:FindChild('Image_Chat').gameObject
	-- playerItem.offlineImage = go.transform:FindChild('Image_offline'):GetComponent('Image')
	-- playerItem.chatMessage = go.transform:FindChild('chatBg/Text'):GetComponent('Text')
	-- playerItem.chatPaoPao = go.transform:FindChild('chatBg').gameObject
	playerItem.HuFlag = go.transform:FindChild('Image_hu'):GetComponent('Image')
	playerItem.jiaGang = go.transform:FindChild('jiagang'):GetComponent('Image')
	playerItem.ChiEffect = go.transform:FindChild('ChiEffect').gameObject
	playerItem.PengEffect = go.transform:FindChild('PengEffect').gameObject
	playerItem.GangEffect = go.transform:FindChild('GangEffect').gameObject
	playerItem.HuEffect = go.transform:FindChild('HuEffect').gameObject
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

