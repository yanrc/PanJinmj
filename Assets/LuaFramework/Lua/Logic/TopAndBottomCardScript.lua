TopAndBottomCardScript = {
	gameObject,
	CardPoint,
	guiIcon,
	cardImg
}
local mt = { }-- 元表（基类）
mt.__index = TopAndBottomCardScript-- index方法
-- 构造函数
function TopAndBottomCardScript.New(obj)
	local topAndBottomCardScript = { }
	topAndBottomCardScript.gameObject = obj
	topAndBottomCardScript.guiIcon = obj.transform:FindChild("RawImage"):GetComponent("RawImage")
	topAndBottomCardScript.cardImg = obj.transform:FindChild("Image"):GetComponent("Image")
	topAndBottomCardScript.guiIcon.gameObject:SetActive(false);
	setmetatable(topAndBottomCardScript, mt)
	return topAndBottomCardScript
end

function TopAndBottomCardScript:Init(cardPoint, LocalIndex)
	local islaizi = RoomData.guiPai == cardPoint
	self.CardPoint = cardPoint
	self.gameObject:GetComponent("Animation").enabled = islaizi;
	self.guiIcon.gameObject:SetActive(islaizi);
	local switch =
	{
		[1] = UIManager.bCards[cardPoint + 1],
		[2] = UIManager.lrCards[cardPoint + 1],
		[3] = UIManager.sCards[cardPoint + 1],
		[4] = UIManager.lrCards[cardPoint + 1],
	}
	if switch[LocalIndex] then
		self.cardImg.sprite = newObject(switch[LocalIndex])
	else
		switch =
		{
			[1] = function()
				resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/Cards/Big/b" .. cardPoint .. ".png" }, function(sprite)
					self.cardImg.sprite = sprite[0]
					UIManager.bCards[cardPoint + 1] = sprite[0]
				end )
			end,
			[2] = function()
				resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/Cards/Left&Right/lr" .. cardPoint .. ".png" }, function(sprite)
					self.cardImg.sprite = sprite[0]
					UIManager.lrCards[cardPoint + 1] = sprite[0]
				end )
			end,
			[3] = function()
				resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/Cards/Small/s" .. cardPoint .. ".png" }, function(sprite)
					self.cardImg.sprite = sprite[0]
					UIManager.sCards[cardPoint + 1] = sprite[0]
				end )
			end,
			[4] = function()
				resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/Cards/Left&Right/lr" .. cardPoint .. ".png" }, function(sprite)
					self.cardImg.sprite = sprite[0]
					UIManager.lrCards[cardPoint + 1] = sprite[0]
				end )
			end,
		}
		switch[LocalIndex]()
	end
end