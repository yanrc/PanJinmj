GameOverScript={

}
local mt = {}--元表（基类）
mt.__index = GameOverScript--index方法
--构造函数
function GameOverScript.New()
	local gameOverScript = {}
	setmetatable(gameOverScript, mt)
	return gameOverScript
end