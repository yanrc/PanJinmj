PlayerItem={

}
local mt = {}--元表（基类）
mt.__index = PlayerItem--index方法
--构造函数
function PlayerItem.New()
	local playerItem = {}
	setmetatable(playerItem, mt)
	return playerItem
end

function PlayerItem:Clean()
	
end

function PlayerItem:SetHuFlagHidde()
	
end

function PlayerItem:SetAvatarVo(avatar)


end