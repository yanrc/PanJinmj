ShopPanel = UIBase(define.Panels.ShopPanel, define.PopUI)
local this = ShopPanel
local gameObject
local btnClose
local ItemsRoot
local flg = false
-- 启动事件--
function ShopPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	ItemsRoot = obj.transform:FindChild("content")
	btnClose = obj.transform:FindChild("btnclose").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
end
-- 请求并保存商品信息
function ShopPanel.GetItemInfos()
	local url = string.format("http://dqc.qrz123.com/MaJiangManage/charge/getChargeInfo?uuid=%d", LoginData.account.uuid)
	local www = WWW(url)
	coroutine.www(www)
	local data = json.decode(www.text)
	local infos = data.list
	this.state = data.upmgr
	for i = 1, #infos do
		local go = newObject(UIManager.ShopItem, ItemsRoot)
		go.transform.localScale = Vector3.one
		local item = ShopItem.New(go, infos[i])
		this.lua:AddClick(go, ShopItem.Click, item)
	end
end

function ShopPanel.CloseClick()
	ClosePanel(this)
end

function ShopPanel:OnOpen()
	if not flg then
		coroutine.start(this.GetItemInfos)
		flg = true
	end
end
