BottomScript={
isSelected=false
}
local mt = {}--元表（基类）
mt.__index = BottomScript--index方法
--构造函数
function BottomScript.New()
	local bottomScript = {}
	setmetatable(bottomScript, mt)
	return bottomScript
end

function BottomScript:Clean()
	
end

function BottomScript:GetPoint()
	
end