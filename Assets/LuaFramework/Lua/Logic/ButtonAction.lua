ButtonAction={}
local mt = {}--元表（基类）
mt.__index = ButtonAction--index方法
--构造函数
function ButtonAction.New()
	local ButtonAction = {}
	setmetatable(ButtonAction, mt)
	return ButtonAction
end

function ButtonAction.Clean()
	
end

function ButtonAction.CleanBtnShow()
	
end