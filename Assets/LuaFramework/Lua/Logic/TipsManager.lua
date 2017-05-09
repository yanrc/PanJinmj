--管理器--
TipsManager = {};
local this = TipsManager;
--构建函数--
function TipsManager.Instance()
	return this;
end
function TipsManager.setTips(tips,time)
	this.tips=tips;
	this.time=time;
	resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/TipPanel.prefab'}, this.OnCreateTipPanel);
end

function TipsManager.OnCreateTipPanel(prefabs)
	local go=newObject(prefabs[0]);
	go.transform.parent =StartPanel.transform.parent;
	go.transform.localScale = Vector3.one;
	go.transform.localPosition =Vector2.New(0,-300);
	go:GetComponent("TipPanelScript"):setText (this.tips);
	go:GetComponent("TipPanelScript"):startAction(this.time);
end

function TipsManager.loadDialog(title,msg,yescallback,nocallback)
	this.title=title;
	this.msg=msg;
	this.yescallback=yescallback;
	this.nocallback=nocallback;
	resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/Image_Base_Dialog.prefab'}, this.OnCreateDialogPanel);
end

function TipsManager.OnCreateDialogPanel(prefabs)
	local go=newObject(prefabs[0]);
	go.transform.parent =StartPanel.transform.parent;
	go.transform.localScale = Vector3.one;
	go.transform.localPosition = Vector3.zero;
	go:GetComponent("DialogPanelScript"):setContent (this.title,this.msg,true,this.yesCallBack,this.noCallBack);
end