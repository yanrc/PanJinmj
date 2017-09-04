APIS =
{
	--  socketUrl = "101.200.197.7";
	--  chatSocketUrl = "101.200.197.7";
	--  socketPort = 11111;
	--  chatPort = 10123;

	-- UPDATE_INFO_JSON_URL = string.format("http://%s:8888/download/update.xml",
	-- socketUrl);
	-- -- 服务器上最新的软件版本信息存储文件
	-- PIC_PATH = string.format("http://%s:8888/download/",
	-- socketUrl);
	-- shareUrl = "";
	-- shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";

	head = 0x000030;
	headRESPONSE = 0x000031;

	-- 游戏关闭返回
	CLOSE_RESPONSE = 0x000000;
	LOGIN_REQUEST = 0x000001;-- 登陆请求码
	LOGIN_RESPONSE = 0x000002;-- 登陆返回码

	JOIN_ROOM_REQUEST = 0x000003;-- 加入房间请求码
	JOIN_ROOM_RESPONSE = 0x000004;-- 加入房间返回码
	JOIN_ROOM_NOICE = 0x10a004;-- 其它 人加入房间通知


	CREATEROOM_REQUEST = 0x00009;-- 创建房间请求码
	CREATEROOM_RESPONSE = 0x00010;-- 创建房间返回吗

	STARTGAME_RESPONSE_NOTICE = 0x00012;-- 开始游戏
	PICKCARD_RESPONSE = 0x100004;-- 摸牌
	OTHER_PICKCARD_RESPONSE_NOTICE = 0x100014;

	RETURN_INFO_RESPONSE = 0x100000;-- 胡、碰、杠等通知
	CHUPAI_REQUEST = 0x100001;-- 出牌请求
	CHUPAI_RESPONSE = 0x100002;-- 出牌通知

	PENGPAI_REQUEST = 0x100005;-- 碰牌请求
	PENGPAI_RESPONSE = 0x100006;-- 碰牌通知
	GANGPAI_REQUEST = 0x100007;-- 杠牌请求
	GANGPAI_RESPONSE = 0x100008;-- 杠牌返回
	OTHER_GANGPAI_NOICE = 0x10a008;-- 杠牌通知
	HUPAI_REQUEST = 0x100009;-- 胡牌请求
	HUPAI_RESPONSE = 0x100010;-- 胡牌返回

	CHIPAI_REQUEST = 0x100011;-- 吃牌请求
	CHIPAI_RESPONSE = 0x100012;-- 吃牌通知

	HUPAIALL_RESPONSE = 0x100110;-- 全局结束通知
	GAVEUP_REQUEST = 0x100015;-- 放弃（胡，杠，碰，吃）

	BACK_LOGIN_REQUEST = 0x001001;-- 掉线后重新登录查询当前牌桌情况请求
	BACK_LOGIN_RESPONSE = 0x001002;-- 掉线后重新登录查询当前牌桌情况返回

	OUT_ROOM_REQUEST = 0x000013;-- 退出房间请求
	OUT_ROOM_RESPONSE = 0x000014;-- 退出房间返回数

	DISSOLIVE_ROOM_REQUEST = 0X000113;-- 申请解散房间
	DISSOLIVE_ROOM_RESPONSE = 0X000114;-- 解散房间回调

	PrepareGame_MSG_REQUEST = 0x333333;-- 准备
	PrepareGame_MSG_RESPONSE = 0x444444;

	ERROR_RESPONSE = 0xffff09;-- 错误回调

	MicInput_Request = 200;
	MicInput_Response = 201;

	LoginChat_Request = 202;

	MessageBox_Request = 203;
	MessageBox_Notice = 204;

	QUITE_LOGIN = 0x555555;-- 退出登录调用，仅限于正常登录
	CARD_CHANGE = 0x777777;

	-- public const int OUT_ROOM_RESPONSE = 0x001002;--离线通知
	OFFLINE_NOTICE = 0x000015;
	ONLINE_NOTICE = 0x001111;

	PRIZE_RESPONSE = 0x999999;-- 抽奖接口
	GET_PRIZE = 0x888888;-- 抽奖请求接口

	RETURN_ONLINE_RESPONSE = 0x001003;-- 断线重连返回最后一次打牌数据
	REQUEST_CURRENT_DATA = 0x001004;-- 申请最后打牌数据数据

	Game_FollowBander_Notice = 0x100016;-- 跟庄

	GAME_BROADCAST = 0x157777;-- 游戏公告
	CONTACT_INFO_REQUEST = 0x156666;-- 添加房卡请求数据
	CONTACT_INFO_RESPONSE = 0x155555;-- 添加房卡返回数据
	HOST_UPDATEDRAW_RESPONSE = 0x010111;-- 抽奖信息变化
	ZHANJI_REPOTER_REQUEST = 0x002001;-- 战绩请求
	ZHANJI_REPORTER_REPONSE = 0x002002;-- 房间战绩返回数据
	ZHANJI_DETAIL_REPORTER_REPONSE = 0x002003;-- 某个房间详细每局战绩
	ZHANJI_SEARCH_REQUEST = 0x002004;-- 搜索房间对应战绩

	GAME_BACK_PLAY_REQUEST = 0x003001;-- 回放请求
	GAME_BACK_PLAY_RESPONSE = 0x003002;-- 回放返回数据
	TIP_MESSAGE = 0x160016;

	OTHER_TELE_LOGIN = 0x211211;-- 其他设备登录

}
local this = APIS
APIS.Rules = { }
function APIS.GameSetting()
	this.Rules = { }
	if GameSetting.Panjin then
		table.insert(this.Rules, PanjinRule)
		AppConst.SocketAddress = "127.0.0.1";
		AppConst.ChatSocketAddress = "127.0.0.1";
		AppConst.SocketPort = 9001;
		AppConst.ChatSocketPort = 9002;
		--AppConst.SocketAddress = "120.77.38.7";
		--AppConst.ChatSocketAddress = "120.77.38.7";
		--AppConst.SocketPort = 10233;
		--AppConst.ChatSocketPort = 10234;
		if UNITY_ANDROID then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=android&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		elseif UNITY_IPHONE then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=ios&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		end
		shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";
	end

	if GameSetting.Jiujiang then
		table.insert(this.Rules, JiujiangRule)
		-- 	AppConst.SocketAddress = "127.0.0.1";
		-- 	AppConst.ChatSocketAddress = "127.0.0.1";
		AppConst.SocketAddress = "120.77.38.7";
		AppConst.ChatSocketAddress = "120.77.38.7";
		AppConst.SocketPort = 10233;
		AppConst.ChatSocketPort = 10234;
		if UNITY_ANDROID then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=android&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		elseif UNITY_IPHONE then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=ios&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		end
		shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";
	end
	if GameSetting.Changsha then
		table.insert(this.Rules, ChangshaRule)
		-- 	AppConst.SocketAddress = "127.0.0.1";
		-- 	AppConst.ChatSocketAddress = "127.0.0.1";
		AppConst.SocketAddress = "120.77.38.7";
		AppConst.ChatSocketAddress = "120.77.38.7";
		AppConst.SocketPort = 10233;
		AppConst.ChatSocketPort = 10234;
		if UNITY_ANDROID then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=android&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		elseif UNITY_IPHONE then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=ios&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		end
		shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";
	end
	if GameSetting.Tuidaohu then
		table.insert(this.Rules, TuidaohuRule)
		-- 	AppConst.SocketAddress = "127.0.0.1";
		-- 	AppConst.ChatSocketAddress = "127.0.0.1";
		AppConst.SocketAddress = "120.77.38.7";
		AppConst.ChatSocketAddress = "120.77.38.7";
		AppConst.SocketPort = 10233;
		AppConst.ChatSocketPort = 10234;
		if UNITY_ANDROID then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=android&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		elseif UNITY_IPHONE then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=ios&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		end
		shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";
	end

	if GameSetting.Shuangliao then
		table.insert(this.Rules, ShuangliaoRule)
		--AppConst.SocketAddress = "127.0.0.1";
		--AppConst.ChatSocketAddress = "127.0.0.1";
		AppConst.SocketAddress = "120.77.38.7";
		AppConst.ChatSocketAddress = "120.77.38.7";
		AppConst.SocketPort = 10233;
		AppConst.ChatSocketPort = 10234;
		if UNITY_ANDROID then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=android&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		elseif UNITY_IPHONE then
			APIS.shareUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxef967ded3e40f05c&redirect_uri=http://dqc.qrz123.com/MaJiangManage/weixinPage?device=ios&response_type=code&scope=snsapi_userinfo&state=%s&connect_redirect=1#wechat_redirect";
		end
		shareImageUrl = "http://101.200.197.7:8090/panjin/share/logo.png";
	end
end