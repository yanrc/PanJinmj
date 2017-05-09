require "View/GamePanel"
GamePanelCtrl={}
local this=GamePanelCtrl;
local gameObject;

function GamePanelCtrl.Awake()
	logWarn("GamePanelCtrl.Awake--->>");
	if(CtrlManager.GamePanelCtrl) then
		this.Open()
	else
		PanelManager:CreatePanel('GamePanelCtrl', this.OnCreate);
		CtrlManager.AddCtrl("GamePanelCtrl",this)
	end
end

function GamePanelCtrl.OnCreate(go)
	gameObject = go;
	lua = gameObject:GetComponent('LuaBehaviour');
	
	logWarn("Start lua--->>"..gameObject.name);
end

function GamePanelCtrl.ExitOrDissoliveRoom()
	
end
--关闭面板--
function GamePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function GamePanelCtrl.RemoveListener()
	
end

--打开面板--
function GamePanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
end
end
--增加事件--
function GamePanelCtrl.AddListener()
	
end