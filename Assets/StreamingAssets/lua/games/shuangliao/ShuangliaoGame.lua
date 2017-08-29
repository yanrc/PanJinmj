ShuangliaoGame = { }
local mt = { }-- 元表（基类）
mt.__index = GamePanel-- index方法
setmetatable(ShuangliaoGame, mt)

function ShuangliaoGame:InitLeftCard()
	self.LeavedCardsNum = 112
	self.LeavedCardsNum = self.LeavedCardsNum - 53;
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end

