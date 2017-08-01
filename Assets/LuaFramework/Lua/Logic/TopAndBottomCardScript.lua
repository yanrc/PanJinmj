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
	local islaizi=RoomData.guiPai == cardPoint
	self.CardPoint = cardPoint
	self.gameObject:GetComponent("Animation").enabled = islaizi;
	self.guiIcon.gameObject:SetActive(islaizi);
	local switch =
	{
		[1] = "Assets/Project/DynaImages/Cards/Big/b",
		[2] = "Assets/Project/DynaImages/Cards/Left&Right/lr",
		[3] = "Assets/Project/DynaImages/Cards/Small/s",
		[4] = "Assets/Project/DynaImages/Cards/Left&Right/lr"
	}
	local path = switch[LocalIndex]
	resMgr:LoadSprite('dynaimages', { path .. cardPoint .. ".png" }, function(sprite)
		self.cardImg.sprite = sprite[0]
	end )
end