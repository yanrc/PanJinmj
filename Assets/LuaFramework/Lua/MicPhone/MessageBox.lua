MessageBox = { }
local this = MessageBox
this.MessageBoxContents={
"快点啦，时间很宝贵的！",
"又断线了，网络怎么这么差！",
"不要走决战到天亮。",
"你的牌打的太好了！",
"你是美眉还是哥哥？",
"和你合作真是太愉快了！",
"大家好很高兴见到大家！",
"各位真不好意思,我要离开一会",
"有什么好吵的,专心玩游戏吧！",
"我到底跟你有什么仇什么怨！",
"哎呀！打错了怎么办"
}
local gameObject
local transform
local buttons = { }
local btnClose
local posOut
local posIn
function MessageBox.OnCreate(parent, lua)
	gameObject = parent:FindChild('MessageBox').gameObject
	transform = gameObject.transform
	for i = 1, 8 do
		buttons[i] = transform:FindChild('Button' .. i).gameObject
		lua:AddClick(buttons[i], this.btnClick, i)
	end
	btnClose = transform:FindChild('btnClose').gameObject
	lua:AddClick(btnClose, this.MoveOut)
	posOut=transform.localPosition;
	posIn=Vector2.New(472, 113)
end

function MessageBox.btnClick(index)
	index = index + 1000
	if LoginData.account.sex == 1 then
		index = index + 1000
	else
		index = index + 2000
	end
	local sendMsg = index .. '|' .. LoginData.account.uuid
	networkMgr:SendMessage(ClientRequest.New(APIS.MessageBox_Request, sendMsg));
	GamePanel.ShowChatMessage(1, index)
	this.MoveOut()
end

function MessageBox.MoveIn()
	soundMgr:playSoundByActionButton(1);
	transform:DOLocalMove(posIn, 0.4,false)
end

function MessageBox.MoveOut()
	transform:DOLocalMove(posOut, 0.4,false)
end
