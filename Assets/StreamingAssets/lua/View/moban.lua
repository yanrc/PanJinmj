local gameObject
local transform
Moban = {};
local this = Moban;

--启动事件--
function Moban.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.gameObject=gameObject;
	this.transform=transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function Moban.InitPanel()
	
end

function Moban.OnDestroy()
	logWarn("OnDestroy---->>>");
		gameObject=nil;
end

function Moban.ActiveSelf()
	if(gameObject) then
	return gameObject.activeSelf
	else return false
	end
end
