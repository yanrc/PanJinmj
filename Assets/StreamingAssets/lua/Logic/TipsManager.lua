

TipsManager = {};
local this = TipsManager;
function TipsManager.SetTips(tips,time)
	this.tips=tips;
	this.time=time or 1;
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
	DialogPanelCtrl:Open(title,msg,yescallback,nocallback);
end
