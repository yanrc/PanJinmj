Payment = { }
local this = Payment
local WXAppID = "wx9228df7ba5a4906c";-- 微信appid;
if Application.platform == RuntimePlatform.Android then
	local unityPlayer = AndroidJavaClass.New("com.unity3d.player.UnityPlayer")
	log(unityPlayer)
	local activity = GameToolScript.AndroidJavaObjectGetStatic(unityPlayer, "currentActivity")
	log(activity)
	local apiFactory = AndroidJavaClass.New("com.tencent.mm.opensdk.openapi.WXAPIFactory")
	log(apiFactory)
	this.WXApi = GameToolScript.AndroidJavaObjectCallStatic(apiFactory, "createWXAPI", activity, WXAppID, false);
end
function Payment.WXPay(itemId)
	coroutine.start(this.GetHttp, itemId)
end

function Payment.GetHttp(itemId)
	-- 显示转圈圈，提示正在打开微信
	OpenPanel(WaitingPanel, "请稍等...")
	-- 获取信息
	local url = "http://dqc.qrz123.com/MaJiangManage/charge/weixin"
	local userId = LoginData.account.uuid
	local time = DateTime.Now:ToString("yyyyMMddHH");
	local md5 = GameToolScript.GetMD5(userId .. time .. itemId)
	url = url .. string.format("?userId=%s&itemId=%s&identify=%s", userId, itemId, md5);
	local www = WWW(url);
	coroutine.www(www)
	log(www.text);
	local Data = json.decode(www.text);
	local prepayid = Data.prepayid
	local partnerid = Data.partnerid
	local nonceStr = Data.noncestr
	local timestamp = Data.timestamp
	local packageValue = Data.package
	local sign = Data.sign
	local request = GameToolScript.NewAndroidJavaObject("com.tencent.mm.opensdk.modelpay.PayReq");
	GameToolScript.SetAndroidString(request, "appId", WXAppID)
	GameToolScript.SetAndroidString(request, "partnerId", partnerid)
	GameToolScript.SetAndroidString(request, "prepayId", prepayid)
	GameToolScript.SetAndroidString(request, "packageValue", packageValue)
	GameToolScript.SetAndroidString(request, "nonceStr", nonceStr)
	GameToolScript.SetAndroidString(request, "timeStamp", timestamp)
	GameToolScript.SetAndroidString(request, "sign", sign)
	GameToolScript.AndroidJavaObjectCallBool(this.WXApi, "sendReq", request)
end

function Payment.WXPayCallback(ret)
	ClosePanel(WaitingPanel)
	ClosePanel(ShopPanel)
end