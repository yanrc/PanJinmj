ShowUserInfoScript =
{
	gameObject,
	headIcon,
	IP,
	ID,
	nameText,
	headIconPath
}
local mt = { }-- 元表（基类）
mt.__index = ShowUserInfoScript-- index方法
function ShowUserInfoScript.New(obj)
	local showUserInfoScript = { }
	showUserInfoScript.gameObject = obj
	showUserInfoScript.headIcon = obj.transform:FindChild("Image_icon"):GetComponent("Image")
	showUserInfoScript.IP = obj.transform:FindChild("TextIP"):GetComponent("Text")
	showUserInfoScript.ID = obj.transform:FindChild("TextID"):GetComponent("Text")
	showUserInfoScript.nameText = obj.transform:FindChild("TextName"):GetComponent("Text")
	setmetatable(showUserInfoScript, mt)
	return showUserInfoScript
end
function ShowUserInfoScript:SetUIData(userInfo)
	headIconPath = userInfo.account.headicon;
	IP.text = "IP:" .. userInfo.IP;
	ID.text = "ID:" .. tostring(userInfo.account.uuid)
	nameText.text = "昵称:" .. userInfo.account.nickname;
	CoMgr.LoadImg(headIcon, headIconPath);
end
function ShowUserInfoScript:CloseUserInfoPanel()
	destroy(gameObject);
end