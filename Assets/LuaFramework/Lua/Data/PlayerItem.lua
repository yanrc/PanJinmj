PlayerItem = {
	gameObject,
	headerIcon,--头像
	bankerImg,--庄家
	nameText,--名字
	ReadyImg,--准备手势
	ScoreText,--分数
	chatAction,--语音图标
	offlineImage,--离线标志
	chatMessage,--短语内容
	chatPaoPao,--短语背景
	huFlag,--胡牌图标
	avatarvo,--玩家信息
	showTime,--短语显示时间
	showChatTime,--语音显示时间
	JiaGang--加钢、飘分等
}
local mt = { }-- 元表（基类）
mt.__index = PlayerItem-- index方法
-- 构造函数
function PlayerItem.New(go)
	local playerItem = { }
	playerItem.gameObject = go
	playerItem.headerIcon = go:GetComponent('Image')
	playerItem.bankerImg = go.transform:FindChild('bankerImg'):GetComponent('Image')
	playerItem.nameText = go.transform:FindChild('Text'):GetComponent('Text')
	playerItem.ReadyImg = go.transform:FindChild('readyImg'):GetComponent('Image')
	playerItem.ScoreText = go.transform:FindChild('Coins'):GetComponent('Text')
	playerItem.chatAction = go.transform:FindChild('Image_Chat').gameObject
	playerItem.offlineImage = go.transform:FindChild('Image_offline'):GetComponent('Image')
	playerItem.chatMessage = go.transform:FindChild('chatBg/Text'):GetComponent('Text')
	playerItem.chatPaoPao = go.transform:FindChild('chatBg').gameObject
	playerItem.huFlag = go.transform:FindChild('Image_hu').gameObject
	playerItem.JiaGang = go.transform:FindChild('Text_jiagang'):GetComponent('Text')
	setmetatable(playerItem, mt)
	return playerItem
end

function PlayerItem:Clean()

end

function PlayerItem:SetHuFlagHidde()

end

function PlayerItem:SetAvatarVo(avatar)


end