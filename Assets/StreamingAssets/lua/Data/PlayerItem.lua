PlayerItem = {
	gameObject,
	headerIcon,-- 头像
	bankerImg,-- 庄家
	nameText,-- 名字
	readyImg,-- 准备手势
	scoreText,-- 分数
	chatAction,-- 语音图标
	offlineImage,-- 离线标志
	chatMessage,-- 短语内容
	chatPaoPao,-- 短语背景
	huFlag,-- 胡牌图标
	uuid,-- 玩家uuid
	showTime,-- 短语显示时间
	showChatTime,-- 语音显示时间
	jiaGang-- 加钢、飘分等
}
local mt = { }-- 元表（基类）
mt.__index = PlayerItem-- index方法
-- 构造函数
function PlayerItem.New(go)
	local playerItem = { }
	setmetatable(playerItem, mt)
	playerItem.gameObject = go
	playerItem.headerIcon = go:GetComponent('Image')
	playerItem.bankerImg = go.transform:FindChild('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:FindChild('Text'):GetComponent('Text')
	playerItem.readyImg = go.transform:FindChild('readyImg'):GetComponent('Image')
	playerItem.scoreText = go.transform:FindChild('Coins'):GetComponent('Text')
	playerItem.chatAction = go.transform:FindChild('Image_Chat').gameObject
	playerItem.offlineImage = go.transform:FindChild('Image_offline'):GetComponent('Image')
	playerItem.chatMessage = go.transform:FindChild('chatBg/Text'):GetComponent('Text')
	playerItem.chatPaoPao = go.transform:FindChild('chatBg').gameObject
	playerItem.huFlag = go.transform:FindChild('Image_hu').gameObject
	playerItem.jiaGang = go.transform:FindChild('Text_jiagang'):GetComponent('Text')
	playerItem.showTime =0
	playerItem.showChatTime = 0
	playerItem.uuid=-1
	UpdateBeat:Add(playerItem.Update,playerItem);
	return playerItem
end

function PlayerItem:Update()
	if (self.showTime > 0) then
		self.showTime = self.showTime - 1;
		if (self.showTime <= 0) then
			self.chatPaoPao:SetActive(false);
		end
	end
	if (self.showChatTime > 0) then
		self.showTime = self.showTime - 1;
		if (self.showChatTime <= 0) then
			self.chatAction:SetActive(false);
		end
	end
end

function PlayerItem:SetAvatarVo(avatar)
	if (avatar ~= nil) then
		self.readyImg.enabled = avatar.isReady;
		self.bankerImg.enabled = avatar.main;
		self.nameText.text = avatar.account.nickname;
		self.scoreText.text = tostring(avatar.scores)
		self.offlineImage.enabled =(not avatar.isOnLine);
		self.uuid=avatar.account.uuid
		CoMgr.LoadImg(headerIcon, avatar.account.headicon);
	else
		self.nameText.text = "";
		self.readyImg.enabled = false;
		self.enabled = false;
		self.scoreText.text = "";
		self.readyImg.enabled = false;
		self.uuid=-1;
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/morentouxiang.jpg' }, function(sprite)
			self.headerIcon.sprite = sprite[0]
		end )
	end
end

function PlayerItem:SetBankImg(flag)
	self.bankerImg.enabled = flag;
end

function PlayerItem:SetReadyImg(flag)
	self.readyImg.enabled = flag;
end

function PlayerItem:ShowChatAction()
	self.showChatTime = 120;
	self.chatAction:SetActive(true);
end

function PlayerItem:GetUuid()
	return self.uuid
end

function PlayerItem:Clean()
	destroy(self.headerIcon.gameObject);
	destroy(self.bankerImg.gameObject);
	destroy(self.nameText.gameObject);
	destroy(self.readyImg.gameObject);
end

function PlayerItem:SetPlayerOffline(value)
	self.offlineImage.enabled = value
end
-- 音频 从1001-1011
function PlayerItem:ShowChatMessage(index)
	self.showTime = 200;
	index = index - 1000;
	self.chatMessage.text = GlobalData.messageBoxContents[index];
	self.chatPaoPao:SetActive(true);
end


function PlayerItem:DisplayAvatorIp()
	if (self.avatarvo ~= nil) then
		loadPrefab("Assets/Project/Prefabs/userInfo", gameObject.transform, function(obj)
			local ShowUserInfoScript = ShowUserInfoScript.New(obj)
			ShowUserInfoScript:SetUIData(self.avatarvo)
		end )
		soundMgr:playSoundByActionButton(1);
	end
end

function PlayerItem:SetHuFlag(value)
	self.HuFlag:SetActive(value);
end
