RulePanel = UIBase(define.Panels.RulePanel, define.PopUI)
local this = RulePanel
local gameObject
local btnClose
local btnForward
local btnBackward
local InnerText
local page
-- 启动事件--
function RulePanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	InnerText = obj.transform:Find("contentBg/ScorllPanel/Text"):GetComponent("Text")
	btnClose = obj.transform:Find("Image_Bg/Button_Back").gameObject
	btnForward = obj.transform:Find("Image_Bg/Button_R").gameObject
	btnBackward = obj.transform:Find("Image_Bg/Button_L").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
	this.lua:AddClick(btnForward, this.ForwardClick)
	this.lua:AddClick(btnBackward, this.BackwardClick)
end

function RulePanel.CloseClick()
	ClosePanel(this)
end

function RulePanel:OnOpen()
	page = 1
	this.ShowPage(page)
end

function RulePanel.ForwardClick()
	if page < #APIS.Rules then
		page = page + 1
		this.ShowPage(page)
	end
end

function RulePanel.BackwardClick()
	if page > 1 then
		page = page - 1
		this.ShowPage(page)
	end
end

function RulePanel.ShowPage(page)
	local ruleText = ""
	InnerText.text=""
	local rule = APIS.Rules[page]
	for i = 1, #rule.RuleText do
		ruleText = ruleText .. rule.RuleText[i].."\n\n"
	end
	InnerText.text = ruleText
end