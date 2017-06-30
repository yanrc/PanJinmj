Moban = UIBase("Moban")
local this = Moban;

local transform;
local gameObject;

-- 启动事件--
function Moban.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	-- this.lua:AddClick( ExitPanel.btnExit, this.Exit);
	-- this.lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>" .. gameObject.name);
end

-------------------模板-------------------------

-- 移除事件--
function Moban.RemoveListener()

end

-- 增加事件--
function Moban.AddListener()

end
