WechatOperate = { }
local this = WechatOperate
local shareSdk = GameObject.Find("Utils/ShareSDK"):GetComponent('ShareSDK');
log(shareSdk)
this.shareSdk=shareSdk
shareSdk.showUserHandler = this.GetUserInforCallback;
shareSdk.shareHandler = this.OnShareCallBack;
log(shareSdk.showUserHandler)
log(shareSdk.shareHandler)
-- 获取微信个人信息成功回调,登录
function WechatOperate.GetUserInforCallback(reqID, state, _type, data)
	if (data ~= nil) then
		log(json.encode(data));
		local loginvo = LoginVo.New();
		xpcall( function()
			loginvo.openId = tostring(data["openid"]);
			loginvo.nickName = tostring(data["nickname"]);
			loginvo.headIcon = tostring(data["headimgurl"]);
			loginvo.unionid = tostring(data["unionid"]);
			loginvo.province = tostring(data["province"]);
			loginvo.city = tostring(data["city"]);
			loginvo.sex = tonumber(data["sex"]);
			loginvo.IP = GlobalData.GetIpAddress();
			local data = json.encode(loginvo);
			GlobalData.loginVo = loginvo;
			GlobalData.loginResponseData = AvatarVO.New();
			GlobalData.loginResponseData.account = Account.New();
			GlobalData.loginResponseData.account.city = loginvo.city;
			GlobalData.loginResponseData.account.openid = loginvo.openId;
			GlobalData.loginResponseData.account.nickname = loginvo.nickName;
			GlobalData.loginResponseData.account.headicon = loginvo.headIcon;
			GlobalData.loginResponseData.account.unionid = loginvo.unionid;
			GlobalData.loginResponseData.account.sex = loginvo.sex;
			GlobalData.loginResponseData.IP = loginvo.IP;
			networkMgr:SendMessage(ClientRequest.New(APIS.LOGIN_REQUEST, data));
			log("GlobalData.loginResponseData.account.unionid=" .. GlobalData.loginResponseData.account.unionid)
		end
		, function(e)
			log("微信接口有变动！" .. e.Message);
			TipsManager.SetTips("请先打开你的微信客户端");
		end )
	else
		TipsManager.SetTips("微信登录失败");
	end
end

-- 登录，提供给button使用
function WechatOperate.Login()
	shareSdk:GetUserInfo(PlatformType.WeChat)
end

-- 分享战绩成功回调
function WechatOperate.OnShareCallBack(reqID, state, _type, result)
	if state == ResponseState.Success then
		-- TipsManager.SetTips("分享成功");
	elseif (state == ResponseState.Fail) then
		log("shar fail :" + result["error_msg"]);
	end
end


-- 分享战绩、战绩
function WechatOperate.ShareAchievementToWeChat(platformType)
	this.GetCapture(platformType)
end

-- 截屏
function WechatOperate.GetCapture(platformType)
	local picPath
	if (Application.platform == RuntimePlatform.Android or Application.platform == RuntimePlatform.IPhonePlayer) then
		picPath = Application.persistentDataPath;
	elseif (Application.platform == RuntimePlatform.WindowsPlayer) then
		picPath = Application.dataPath;
	elseif (Application.platform == RuntimePlatform.WindowsEditor) then
		picPath = Application.dataPath;
		picPath = picPath.Replace("/Assets", nil);
	end
	picPath = picPath .. "/screencapture.png";
	local width = Screen.width;
	local height = Screen.height;
	local tex = Texture2D.New(width, height, TextureFormat.RGB24, false);
	tex:ReadPixels(Rect.New(0, 0, width, height), 0, 0, true);
	tex:Apply();
	-- 转化为png图
	local imagebytes = tex:EncodeToPNG();
	-- 对屏幕缓存进行压缩
	tex:Compress(false);
	local str = string.bytes2string(imagebytes)
	local file = io.open(picPath, 'wb')
	io.output(file)
	io.write(str)
	io.close(file)
	-- 存储png图
	destroy(tex);
	this.ShareAchievement(platformType, picPath);
end

-- 执行分享到朋友圈的操作
function WechatOperate.ShareAchievement(platformType, picPath)
	local customizeShareParams = ShareContent.New();
	customizeShareParams:SetText("");
	customizeShareParams:SetImagePath(picPath);
	customizeShareParams:SetShareType(ContentType.Image);
	customizeShareParams:SetObjectID("");
	customizeShareParams:SetShareContentCustomize(platformType, customizeShareParams);
	shareSdk:ShareContent(platformType, customizeShareParams);
end

function WechatOperate.InviteFriend()
	if (GlobalData.roomVo ~= nil) then
		local roomvo = GlobalData.roomVo;
		GlobalData.totalTimes = roomvo.roundNumber;
		GlobalData.surplusTimes = roomvo.roundNumber;
		local str = "";
		if (roomvo.hong) then
			str = str .. "红中麻将,";
		else
			if (roomvo.roomType == 1) then
				str = str .. "转转麻将,";
			elseif (roomvo.roomType == 2) then
				str = str .. "划水麻将,";
			elseif (roomvo.roomType == 3) then
				str = str .. "长沙麻将,";
			elseif (roomvo.roomType == 4) then
				str = str .. "广东麻将,";
			elseif (roomvo.roomType == 5) then
				str = str .. "盘锦麻将,";
			end
			str = str .. "大战" .. roomvo.roundNumber .. "圈,";
			if (roomvo.sevenDouble) then
				str = str .. "可胡七对,";
			end
			if (roomvo.addWordCard) then
				str = str .. "有风牌,";
			else
				str = str .. "无风牌,";
			end
			if (roomvo.xiaYu > 0) then
				str = str .. "下鱼" .. roomvo.xiaYu .. "条,";
			end
			if (roomvo.ma > 0) then
				str = str .. "抓" .. roomvo.ma .. "个码,";
			end
			if (roomvo.magnification > 0) then
				str = str .. "128番封顶";
			end
			str = str .. "有胆，你就来！";
			local title = "豆豆盘锦麻将    " .. "房间号：" .. roomvo.roomId;
			local url = string.format(APIS.shareUrl, GlobalData.loginResponseData.account.unionid)
			this.Share(title, str, url, APIS.shareImageUrl, ContentType.Webpage)
		end
	end
end

-- 大厅里的分享
function WechatOperate.InviteInHome()
	local title = Application.productName;
	local str = GlobalData.loginResponseData.account.nickname .. "邀请您一起来玩" .. title;
	local url = string.format(APIS.shareUrl, GlobalData.loginResponseData.account.unionid)
	this.Share(title, str, url, APIS.shareImageUrl, ContentType.Webpage)
end

-- 分享
function WechatOperate.Share(title, text, url, imageUrl, ShareType)
	local customizeShareParams = ShareContent.New();
	customizeShareParams:SetTitle(title);
	customizeShareParams:SetText(text);
	-- 配置下载地址
	customizeShareParams:SetUrl(url);
	-- 配置分享logo
	customizeShareParams:SetImageUrl(imageUrl);
	customizeShareParams:SetShareType(ShareType);
	customizeShareParams:SetObjectID("");
	shareSdk:ShareContent(PlatformType.WeChat, customizeShareParams);
end