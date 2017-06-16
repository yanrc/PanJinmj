ButtonAction = { }
local mt = { }-- 元表（基类）
mt.__index = ButtonAction-- index方法
local huBtn;
local gangBtn;
local pengBtn;
local chiBtn;
local passBtn;
-- 构造函数
function ButtonAction.New(transform)
	local ButtonAction = { }
	setmetatable(ButtonAction, mt)
	huBtn = transform:FindChild("btnList/huBtn").gameObject
	gangBtn = transform:FindChild("btnList/GangButton").gameObject
	pengBtn = transform:FindChild("btnList/PengButton").gameObject
	chiBtn = transform:FindChild("btnList/ChiButton").gameObject
	passBtn = transform:FindChild("btnList/PassButton").gameObject
	return ButtonAction
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