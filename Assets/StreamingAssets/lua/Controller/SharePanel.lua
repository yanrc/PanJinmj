SharePanel = UIBase(define.Panels.SharePanel, define.PopUI)
local this = SharePanel
local transform;
local gameObject;
local btnClose
local btnWeChat
local btnWeChatMoments
-- 启动事件--
function SharePanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	btnClose = transform:Find('root/btnClose').gameObject
	btnWeChat = transform:Find('root/btnWeChat').gameObject
	btnWeChatMoments = transform:Find('root/btnWeChatMoments').gameObject
	this.lua:AddClick(btnClose, this.CloseClick);
	this.lua:AddClick(btnWeChat, this.ShareWeChat);
	this.lua:AddClick(btnWeChatMoments, this.ShareWeChatMoments);
end

function SharePanel.ShareWeChat()
	WechatOperate.InviteFriend(PlatformType.WeChat)
	ClosePanel(this)
end

function SharePanel.ShareWeChatMoments()
	WechatOperate.InviteFriend(PlatformType.WeChatMoments)
	ClosePanel(this)
end
-------------------模板-------------------------
function SharePanel.CloseClick()
	ClosePanel(this)
end
function SharePanel:OnOpen()

end
