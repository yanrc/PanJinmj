Moban = UIBase("Moban")
local this = Moban;

local transform;
local gameObject;

-- 启动事件--
function Moban.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
--	this.lua:AddClick(btnConfirm, this.Confirm);
--	this.lua:AddClick(btnCancel, this.Cancel);
--	this.lua:AddClick(btnClose, this.CloseClick);
	logWarn("Start lua--->>" .. gameObject.name);
end

-------------------模板-------------------------

-- 移除事件--
function Moban.RemoveListener()

end

-- 增加事件--
function Moban.AddListener()

end
