BottomScript = {
	gameObject,
	transform,
	cardPoint,
	guiIcon,
	cardImg,
	bg,
	selected = false,
	islaizi = false,
	OnSendMessage = nil,
	ReSetPoisiton = nil,
	IsTingLock = false,
	offset = Vector2.zero
}
local mt = { }-- 元表（基类）
mt.__index = BottomScript-- index方法
-- 构造函数
function BottomScript.New(obj)
	local bottomScript = { }
	bottomScript.gameObject = obj
	bottomScript.transform = obj.transform
	bottomScript.guiIcon = obj.transform:FindChild("RawImage"):GetComponent("RawImage")
	bottomScript.cardImg = obj.transform:FindChild("Image"):GetComponent("Image")
	bottomScript.bg = obj.transform:GetComponent("Image")
	bottomScript.guiIcon.gameObject:SetActive(false);
	obj:AddComponent(typeof(Mahjong)):Init(bottomScript);
	setmetatable(bottomScript, mt)
	return bottomScript
end


function BottomScript:OnDrag(eventData)
	if (self.IsTingLock) then return end
	if (self.islaizi) then return end
	self.transform.position = eventData.position + self.offset;
end
function BottomScript:OnPointerDown(eventData)
	if (self.IsTingLock) then return end
	if (self.islaizi) then return end
	self.offset = self.transform.position - eventData.position
end

function BottomScript:OnPointerUp(eventData)
	if (self.IsTingLock) then return end
	if (self.islaizi) then return end
	if (self.selected) then
		if not self:SendObjectToCallBack() then
			self:ReSetPoisitonCallBack();
		end
	elseif self.transform.localPosition.y > -122 then
		if not self:SendObjectToCallBack() then
			self:ReSetPoisitonCallBack();
		end
	else
		self:ReSetPoisitonCallBack();
	end
end
-- 打牌事件
function BottomScript:SendObjectToCallBack()
	if (self.OnSendMessage ~= nil) then
		self:OnSendMessage()
	end
end
-- 归位事件
function BottomScript:ReSetPoisitonCallBack()
	-- 清除其他牌的选中状态
	if (self.ReSetPoisiton ~= nil) then
		self:ReSetPoisiton()
	end
end

function BottomScript:Init(cardPoint)
	local islaizi = RoomData.guiPai == cardPoint
	self.cardPoint = cardPoint
	self.gameObject:GetComponent("Animation").enabled = islaizi;
	self.guiIcon.gameObject:SetActive(islaizi);
	self.islaizi = islaizi;
	if UIManager.bCards[cardPoint + 1] then
		self.cardImg.sprite = newObject(UIManager.bCards[cardPoint + 1])
	else
		local path = "Assets/Project/DynaImages/Cards/Big/b"
		resMgr:LoadSprite('dynaimages', { path .. cardPoint .. ".png" }, function(sprite)
			if not IsNil(self.gameObject) then
				self.cardImg.sprite = newObject(sprite[0])
			end
			UIManager.bCards[cardPoint + 1] = sprite[0]
		end )
	end
end
