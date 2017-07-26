RulePanel = UIBase(define.Panels.RulePanel, define.PopUI)
local this = RulePanel
local gameObject
local btnClose
local InnerText
-- 启动事件--
function RulePanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	InnerText = obj.transform:FindChild("contentBg/ScorllPanel/Text"):GetComponent("Text")
	btnClose=obj.transform:FindChild("Image_Bg/Button_Back").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
end

function RulePanel.CloseClick()
	ClosePanel(this)
end

function RulePanel.OnOpen()

end
