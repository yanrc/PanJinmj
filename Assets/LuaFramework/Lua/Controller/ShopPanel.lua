ShopPanel = UIBase(define.ShopPanel, define.PopUI)
local this = ShopPanel
local gameObject
local btnClose
local InnerText
-- 启动事件--
function ShopPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	InnerText = obj.transform:FindChild("contentBg/ScorllPanel/Text"):GetComponent("Text")
	btnClose = obj.transform:FindChild("Image_Bg/Button_Back").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
end

function ShopPanel.InitInitPanel()


end

function ShopPanel.GetItemInfos()

end

function ShopPanel.CloseClick()
	ClosePanel(this)
	ClosePanel(WaitingPanel)
end

function ShopPanel.OnOpen()
	OpenPanel(WaitingPanel)
end
