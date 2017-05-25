local gameObject
local transform
CreateRoomPanel = {};
local this = CreateRoomPanel;

--启动事件--
function CreateRoomPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.gameObject=gameObject;
	this.transform=transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CreateRoomPanel.InitPanel()
	
end

function CreateRoomPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
		gameObject=nil;
end

function CreateRoomPanel.ActiveSelf()
	if(gameObject) then
	return gameObject.activeSelf
	else return false
	end
end
