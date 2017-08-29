ShopItem = {
	lbPrice,
	lbDes,
	Icon,
	id,
}

local mt = { }-- 元表（基类）
mt.__index = ShopItem-- index方法

function ShopItem.New(go, info)
	local shopItem = { }
	setmetatable(shopItem, mt)
	shopItem.lbPrice = go.transform:Find('price'):GetComponent('Text')
	shopItem.lbDes = go.transform:Find('des'):GetComponent('Text')
	shopItem.Icon = go.transform:Find('Image'):GetComponent('Image')
	shopItem.id = info[1]
	shopItem.lbPrice.text = info[2]
	shopItem.lbDes.text = info[3]
	local path = "Assets/Project/DynaImages/" .. string.match(info[4], ".+/([^/]*%.%w+)$")
	resMgr:LoadSprite('dynaimages', { path }, function(sprites)
		shopItem.Icon.sprite = sprites[0]
	end )
	return shopItem
end

function ShopItem:Click()
	if ShopPanel.state == 0 then
		OpenPanel(InviteCodePanel)
	else
		Payment.WXPay(self.id)
	end
end


