--通用弹出框
DialogPanel = UIBase(define.Panels.DialogPanel,define.PopUI)
local this = DialogPanel;

local transform;
local gameObject;
local texttitle
local textmsg
local btnConfirm
local btnCancel

-- 启动事件--
function DialogPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	texttitle = transform:FindChild('Text2'):GetComponent('Text')
	textmsg = transform:FindChild('Text_Msg'):GetComponent('Text')
	btnConfirm = transform:FindChild('Button_OK').gameObject
	btnCancel = transform:FindChild('Button_Cancle').gameObject
end



-------------------模板-------------------------
function DialogPanel.CloseClick()
ClosePanel(this)
end
function DialogPanel:OnOpen(title, msg, yescallback, nocallback)
	this.lua:ResetClick(btnConfirm)
	this.lua:ResetClick(btnCancel)
	texttitle.text = title
	textmsg.text = msg
	this.lua:AddClick(btnConfirm, yescallback)
	this.lua:AddClick(btnCancel, nocallback or this.CloseClick)
end
-- 移除事件--
function DialogPanel:RemoveListener()

end

-- 增加事件--
function DialogPanel:AddListener()

end