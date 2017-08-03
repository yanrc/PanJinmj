local _UIBase =
{
	name = "",
	_type = "",
	gameObject = nil,
	transform = nil,
	lua = nil,
}
function _UIBase:Awake()
	logWarn(self.name .. ":Awake--->>");
	PanelManager:CreatePanel(self.name, self.OnCreate);
	CtrlManager.AddCtrl(self.name, self)
end

function _UIBase:Init(obj)
	self.gameObject = obj
	self.transform = obj.transform
	self.lua = obj:GetComponent('LuaBehaviour');
	obj:SetActive(false)
	Event.Brocast(define.PanelsInited, self);
	logWarn("Start lua--->>" .. obj.name);
end

function _UIBase:Open(...)
	if (self.gameObject) then
		if (not self.gameObject.activeSelf) then
			self.gameObject:SetActive(true)
			self.transform:SetAsLastSibling();
			self.AddListener()
			self.OnOpen(...)
		end
	end
end

function _UIBase:Close()
	if (self.gameObject) then
		if (self.gameObject.activeSelf) then
			self.gameObject:SetActive(false)
			self.RemoveListener()
			self.OnClose()
		end
	end
end

function _UIBase:ChangePanel(panel)
	if (self._type ~= define.FixUI) then
		log("wrong type=>"..self.name)
	end
	if (panel._type ~= define.FixUI) then
		log("wrong type=>"..panel.name)
	end
	OpenPanel(panel)
	ClosePanel(self)
end

function _UIBase.AddListener()

end
function _UIBase.RemoveListener()

end
function _UIBase.OnOpen()

end
function _UIBase.OnClose()

end
_UIBase.__index = function(t, k)
	return rawget(_UIBase, k)
end
setmetatable(_UIBase, _UIBase)
function UIBase(name, _type)
	local base = { name = name, _type = _type }
	setmetatable(base, _UIBase)
	return base
end
