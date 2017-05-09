require "View/ExitPanel"
ExitPanelCtrl = {};
local this = ExitPanelCtrl;

local message;
local transform;
local gameObject;

--构建函数--
function ExitPanelCtrl.New()
	logWarn("ExitPanelCtrl.New--->>");
	return this;
end

function ExitPanelCtrl.Awake()
	logWarn("ExitPanelCtrl.Awake--->>");
	PanelManager:CreatePanel('ExitPanel', this.OnCreate);
	CtrlManager.AddCtrl("ExitPanelCtrl",this)
end

--启动事件--
function ExitPanelCtrl.OnCreate(obj)
	gameObject = obj;
	lua = gameObject:GetComponent('LuaBehaviour');
	lua:AddClick( ExitPanel.btnExit, this.Exit);
	lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>"..gameObject.name);
end

--单击事件--
function ExitPanelCtrl.Exit(go)
	log("exit click")
end

--关闭事件--
function ExitPanelCtrl.Cancel()
	log("cancel")
end


-------------------模板-------------------------

--关闭面板--
function ExitPanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function ExitPanelCtrl.RemoveListener()
	
end

--打开面板--
function ExitPanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
	end
end
--增加事件--
function ExitPanelCtrl.AddListener()

end