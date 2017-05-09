local transform;
local gameObject;

ExitPanel = {};
local this = ExitPanel;

--启动事件--
function ExitPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function ExitPanel.InitPanel()
	this.btnExit = transform:FindChild("Image_Bg/Button_Sure").gameObject;
	this.btnCancel = transform:FindChild("Image_Bg/Button_Cancle").gameObject;
	transform.localScale = Vector3.one;
	gameObject:GetComponent('RectTransform').offsetMax =Vector2.zero
	gameObject:GetComponent('RectTransform').offsetMin =Vector2.zero;
end

function ExitPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
		gameObject=nil;
end

function ExitPanel.ActiveSelf()
	if(gameObject) then
	return gameObject.activeSelf
	else return false
	end
end