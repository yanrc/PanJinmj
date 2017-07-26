UserInfoPanel = UIBase(define.Panels.UserInfoPanel, define.PopUI)
local this = UserInfoPanel
local gameObject
local headIcon
local IP
local ID
local nameText
local headIconPath
-- 启动事件--
function UserInfoPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	headIcon = obj.transform:FindChild("Image_icon"):GetComponent("Image")
	IP = obj.transform:FindChild("TextIP"):GetComponent("Text")
	ID = obj.transform:FindChild("TextID"):GetComponent("Text")
	nameText = obj.transform:FindChild("TextName"):GetComponent("Text")
	this.lua:AddClick(obj, this.CloseClick)
end

function UserInfoPanel.CloseClick()
	ClosePanel(this)
end

function UserInfoPanel.OnOpen(userInfo)
	headIconPath = userInfo.account.headicon;
	IP.text = "IP:" .. userInfo.IP;
	ID.text = "ID:" .. tostring(userInfo.account.uuid)
	nameText.text = "昵称:" .. userInfo.account.nickname;
	CoMgr.LoadImg(headIcon, headIconPath);
end