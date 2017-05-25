local gameObject
local transform
StartPanel = {};
local this = StartPanel;
--启动事件--
function StartPanel.Awake(obj)
	gameObject=obj;
	transform=obj.transform
	this.gameObject=gameObject;
	this.transform=transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function StartPanel.InitPanel()
	this.btnLogin = transform:FindChild("Button").gameObject;
	--this.gridParent = transform:FindChild('ScrollView/Grid');
end

function StartPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
		gameObject=nil;
end

function StartPanel.ActiveSelf()
	if(gameObject) then
	return gameObject.activeSelf
	else return false
	end
end