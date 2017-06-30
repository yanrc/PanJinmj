
ExitPanel = UIBase("ExitPanel");
local this = ExitPanel;

local transform;
local gameObject;

--启动事件--
function ExitPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	this.lua:AddClick( ExitPanel.btnExit, this.Exit);
	this.lua:AddClick( ExitPanel.btnCancel, this.Cancel);
end

--单击事件--
function ExitPanel.Exit(go)
	log("lua:exit click")
end

--关闭事件--
function ExitPanel.Cancel()
	log("lua:cancel")
end


-------------------模板-------------------------

--移除事件--
function ExitPanel.RemoveListener()
	
end

--增加事件--
function ExitPanel.AddListener()

end