local transform;
local gameObject;

HomePanel = {};
local this = HomePanel;

--启动事件--
function HomePanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.InitPanel();
	logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function HomePanel.InitPanel()
	--this.btnExit = transform:FindChild("Image_Bg/Button_Sure").gameObject;
	--this.btnCancel = transform:FindChild("Image_Bg/Button_Cancle").gameObject;
	transform.localScale = Vector3.one;
	gameObject:GetComponent('RectTransform').offsetMax =Vector2.zero
	gameObject:GetComponent('RectTransform').offsetMin =Vector2.zero;
end


function HomePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
		gameObject=nil;
end

function HomePanel.ActiveSelf()
	if(gameObject) then
	return gameObject.activeSelf
	else return false
	end
end