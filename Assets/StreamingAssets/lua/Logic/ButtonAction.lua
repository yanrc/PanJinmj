ButtonAction = { }
local mt = { }-- 元表（基类）
mt.__index = ButtonAction-- index方法
local huBtn;
local gangBtn;
local pengBtn;
local chiBtn;
local passBtn;

local ChiSelect1
local ChiSelect2
local ChiSelect3
-- 构造函数
function ButtonAction.New(transform)
	local buttonAction = { }
	setmetatable(ButtonAction, mt)
	huBtn = transform:FindChild("btnList/huBtn").gameObject
	gangBtn = transform:FindChild("btnList/GangButton").gameObject
	pengBtn = transform:FindChild("btnList/PengButton").gameObject
	chiBtn = transform:FindChild("btnList/ChiButton").gameObject
	passBtn = transform:FindChild("btnList/PassButton").gameObject
	ChiSelect1 = transform:FindChild("ChiList/list_1/Button").gameObject
	ChiSelect2 = transform:FindChild("ChiList/list_2/Button").gameObject
	ChiSelect3 = transform:FindChild("ChiList/list_3/Button").gameObject
	GamePanel.lua:AddClick(huBtn, GamePanel.HupaiRequest)
	GamePanel.lua:AddClick(gangBtn, GamePanel.MyGangBtnClick)
	GamePanel.lua:AddClick(pengBtn, GamePanel.MyPengBtnClick)
	GamePanel.lua:AddClick(chiBtn, GamePanel.MyChiBtnClick)
	GamePanel.lua:AddClick(passBtn, GamePanel.MyPassBtnClick)
	GamePanel.lua:AddClick(ChiSelect1, GamePanel.MyChiBtnClick2,1)
	GamePanel.lua:AddClick(ChiSelect2, GamePanel.MyChiBtnClick2,2)
	GamePanel.lua:AddClick(ChiSelect3, GamePanel.MyChiBtnClick2,3)
	return buttonAction
end

function ButtonAction.CleanBtnShow()
	huBtn:SetActive(false);
	gangBtn:SetActive(false);
	pengBtn:SetActive(false);
	chiBtn:SetActive(false);
	passBtn:SetActive(false);
end

function ButtonAction.ShowBtn(btntype, value)
	if (btntype == 1) then
		huBtn:SetActive(value)
	end
	if (btntype == 2) then
		gangBtn:SetActive(value)
	end
	if (btntype == 3) then
		pengBtn:SetActive(value)
	end
	if (btntype == 4) then
		chiBtn:SetActive(value)
	end
	if (btntype == 5) then
		passBtn:SetActive(value)
	end
end