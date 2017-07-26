ShopPanel = UIBase(define.Panels.ShopPanel, define.PopUI)
local this = ShopPanel
local gameObject
local btnClose
local ItemsRoot
-- 启动事件--
function ShopPanel.OnCreate(obj)
	gameObject = obj;
	this:Init(obj)
	ItemsRoot = obj.transform:FindChild("content")
	btnClose = obj.transform:FindChild("btnclose").gameObject
	this.lua:AddClick(btnClose, this.CloseClick)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ShopItem.prefab" }, function(prefabs) coroutine.start(this.GetItemInfos, prefabs) end)

end
-- 请求并保存商品信息
function ShopPanel.GetItemInfos(prefabs)
	local www = WWW("http://dqc.qrz123.com/MaJiangManage/charge/getChargeInfo")
	coroutine.www(www)
	local data = json.decode(www.text)
	local infos = data.list

	for i = 1, #infos do
		local go = newObject(prefabs[0], ItemsRoot)
		go.transform.localScale=Vector3.one
		ShopItem.New(go, infos[i])
		this.lua:AddClick(go, Payment.WXPay, infos[i][1])
	end
end

function ShopPanel.CloseClick()
	ClosePanel(this)
end

function ShopPanel.OnOpen()

end
