MessagePanel = UIBase(define.Panels.MessagePanel, define.PopUI)
local this = MessagePanel
local gameObject
local btnClose
local InnerText
-- 启动事件--
function MessagePanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	InnerText = obj.transform:Find("contentBg/ScorllPanel/Text"):GetComponent("Text")
	btnClose=obj.transform:Find("Image_Bg/Button_Back").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
end

function MessagePanel.CloseClick()
	ClosePanel(this)
end

function MessagePanel:OnOpen()

end
