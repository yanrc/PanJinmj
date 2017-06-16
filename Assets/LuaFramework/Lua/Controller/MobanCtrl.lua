require "View/Moban"
MobanCtrl = {};
local this = MobanCtrl;

local transform;
local gameObject;
local lua
--加载函数--
function MobanCtrl.Awake()
	logWarn("MobanCtrl Awake--->>");
	PanelManager:CreatePanel('MobanPanel', this.OnCreate);
	CtrlManager.MobanCtrl=this
end

--启动事件--
function MobanCtrl.OnCreate(obj)
	gameObject = obj;
	transform=obj.transform
	lua = gameObject:GetComponent('LuaBehaviour');
--	lua:AddClick( ExitPanel.btnExit, this.Exit);
--	lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>"..gameObject.name);
end

-------------------模板-------------------------

--关闭面板--
function MobanCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function MobanCtrl.RemoveListener()
	
end

--打开面板--
function MobanCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
	end
end
--增加事件--
function MobanCtrl.AddListener()

end
