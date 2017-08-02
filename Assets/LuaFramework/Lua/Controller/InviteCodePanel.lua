InviteCodePanel = UIBase(define.Panels.InviteCodePanel, define.PopUI)
local this = InviteCodePanel

local transform;
local gameObject;
local inputField
local btnConfirm
local btnCancel
local btnClose
-- 启动事件--
function InviteCodePanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	inputField = transform:FindChild('InputField'):GetComponent('InputField')
	btnConfirm = transform:FindChild('btnConfirm').gameObject
	btnCancel = transform:FindChild('btnCancel').gameObject
	btnClose = transform:FindChild('btnClose').gameObject
	this.lua:AddClick(btnConfirm, this.Confirm);
	this.lua:AddClick(btnCancel, this.Cancel);
	this.lua:AddClick(btnClose, this.CloseClick);
	inputField.onValueChanged:AddListener(this.OnValueChange)
	logWarn("Start lua--->>" .. gameObject.name);
end

function InviteCodePanel.OnValueChange()
	inputField.text = string.gsub(inputField.text, '-', '')
end

function InviteCodePanel.Confirm()
	if inputField.text ~= "" then
		coroutine.start(this.Bind)
	else
		TipsManager.SetTips("请输入正确的ID号！")
	end
	soundMgr:playSoundByActionButton(1);
end

function InviteCodePanel.Cancel()
	inputField.text = "";
	soundMgr:playSoundByActionButton(1);
end

function InviteCodePanel.CloseClick()
	ClosePanel(this)
	soundMgr:playSoundByActionButton(1);
end

function InviteCodePanel.Bind()
	OpenPanel(WaitingPanel, "绑定中...")
	local url = string.format("http://dqc.qrz123.com/MaJiangManage/charge/inviteCode?uuid=%d&&code=%d", LoginData.account.uuid, inputField.text)
	local www = WWW(url)
	coroutine.www(www)
	ClosePanel(WaitingPanel)
	local data = json.decode(www.text)
	local return_code = data.return_code
	local switch = {
		[200] = function()
			TipsManager.SetTips("绑定成功！")
			ClosePanel(this)
			ShopPanel.state = 1
		end,
		[400] = function() TipsManager.SetTips("参数不完整！") end,
		[404] = function() TipsManager.SetTips("用户不存在！") end,
		[405] = function() TipsManager.SetTips("邀请码不存在！") end,
	}
	switch[return_code]()
end