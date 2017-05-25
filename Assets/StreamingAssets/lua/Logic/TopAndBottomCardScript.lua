TopAndBottomCardScript={

}
local mt = {}--元表（基类）
mt.__index = TopAndBottomCardScript--index方法
--构造函数
function TopAndBottomCardScript.New()
	local topAndBottomCardScript = {}
	setmetatable(topAndBottomCardScript, mt)
	return topAndBottomCardScript
end

function TopAndBottomCardScript:Init(cardPoint,Dir,isGuiPai)

end