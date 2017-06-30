VotePanel = UIBase("VotePanel")
local this = VotePanel;

local transform;
local gameObject;

-- 启动事件--
function VotePanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	-- this.lua:AddClick( ExitPanel.btnExit, this.Exit);
	-- this.lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>" .. gameObject.name);
end

-------------------模板-------------------------

-- 移除事件--
function VotePanel.RemoveListener()

end

-- 增加事件--
function VotePanel.AddListener()

end
