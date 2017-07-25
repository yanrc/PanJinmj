ShopItem = {
	lbPrice,
	lbDes,
	Icon,
}

local mt = { }-- 元表（基类）
mt.__index = ShopItem-- index方法

local Instance = nil
function ShopItem.New(go, info)
	local shopItem = { }
	setmetatable(shopItem, mt)
	shopItem.lbPrice = go.transform:FindChild('price'):GetComponent('Text')
	shopItem.lbDes = go.transform:FindChild('des'):GetComponent('Text')
	shopItem.Icon = go.transform:FindChild('Image'):GetComponent('Image')
	shopItem.lbPrice.text = info[2]
	shopItem.lbDes.text = info[3]
	local path = "Assets/Project/DynaImages/" .. string.match(info[4], ".+/([^/]*%.%w+)$")
	resMgr:LoadSprite('dynaimages', {path }, function(sprites)
		shopItem.Icon.sprite = sprites[0]
	end )
	return shopItem
end


