DialogPanelCtrl = { };
local this = DialogPanelCtrl;

local transform;
local gameObject;
local lua
local texttitle
local textmsg
local btnConfirm
local btnCancel
-- 加载函数--
function DialogPanelCtrl.Awake()
	logWarn("DialogPanelCtrl Awake--->>");
	PanelManager:CreatePanel('DialogPanel', this.OnCreate);
	CtrlManager.DialogPanelCtrl = this
end

-- 启动事件--
function DialogPanelCtrl.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	lua = gameObject:GetComponent('LuaBehaviour');
	texttitle = transform:FindChild('Text2'):GetComponent('Text')
	textmsg = transform:FindChild('Text_Msg'):GetComponent('Text')
	btnConfirm = transform:FindChild('Button_OK').gameObject
	btnCancel = transform:FindChild('Button_Cancle').gameObject
	logWarn("Start lua--->>" .. gameObject.name);
	this.Start();
end

function DialogPanelCtrl.Start()
	this.Init()
end

function DialogPanelCtrl.Init()
	lua:ResetClick(btnConfirm)
	lua:ResetClick(btnCancel)
	texttitle.text = this.title
	textmsg.text = this.msg
	lua:AddClick(btnConfirm, this.yescallback)
	lua:AddClick(btnCancel, this.nocallback or this.Close)
end

function DialogPanelCtrl.Set(title, msg, yescallback, nocallback)
	this.title = title
	this.msg = msg
	this.yescallback = yescallback
	this.nocallback = nocallback
end
-------------------模板-------------------------

-- 关闭面板--
function DialogPanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

-- 移除事件--
function DialogPanelCtrl.RemoveListener()

end

-- 打开面板--
function DialogPanelCtrl.Open(title, msg, yescallback, nocallback)
	this.Set(title, msg, yescallback, nocallback)
	if (gameObject) then
		gameObject:SetActive(true)
		transform:SetAsLastSibling();
		this.AddListener()
		this.Init()
	elseif (CtrlManager.DialogPanelCtrl ~= nil) then
		return
	else
		this.Awake()
	end
end
-- 增加事件--
function DialogPanelCtrl.AddListener()

end