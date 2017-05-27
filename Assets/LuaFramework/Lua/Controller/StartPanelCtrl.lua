require "Logic.GlobalData"
require "Common/define"
require "Controller/ExitPanelCtrl"
require "Logic.TipsManager"
require "Logic.LoginManager"
require "vos/LoginChatRequest"
require "Controller/HomePanelCtrl"
require "Controller/GamePanelCtrl"
require "View/StartPanel"
local json = require "cjson"
StartPanelCtrl = {};
local this = StartPanelCtrl;
local transform;
local gameObject;
local versionText;--版本号
local watingPanel;--转圈圈面板
local panelCreate;--要加载的面板的引用
local agreeProtocol;--toggle
local xieyiPanel;--协议面板
local xieyiButton;--打开协议面板的按钮
--构建函数--
function StartPanelCtrl.New()
	logWarn("StartPanelCtrl.New--->>");
	return this;
end

function StartPanelCtrl.Awake()
	logWarn("StartPanelCtrl.Awake--->>");
	PanelManager:CreatePanel('StartPanel', this.OnCreate);
	CtrlManager.StartPanelCtrl=this
end

--启动事件--
function StartPanelCtrl.OnCreate(obj)
	gameObject = obj;
	transform=obj.transform
	this.lua = gameObject:GetComponent('LuaBehaviour');
	versionText=gameObject.transform:FindChild("TextVersion"):GetComponent('Text');
	watingPanel=gameObject.transform:FindChild("Panel_wating");
	agreeProtocol=gameObject.transform:FindChild("Toggle"):GetComponent('Toggle');
	xieyiButton=gameObject.transform:FindChild("Toggle/Label").gameObject;
	--log(StartPanel.btnLogin)
	--log(xieyiButton)
	this.lua:AddClick(StartPanel.btnLogin, this.login);
	this.lua:AddClick(xieyiButton, this.OpenXieyiPanel);
	logWarn("lua--->>"..gameObject.name);
	this.Start();
end

--单击事件--
function StartPanelCtrl.OnClick(go)
	destroy(gameObject);
end

--关闭事件--
function StartPanelCtrl.Close()
	PanelManager:ClosePanel(CtrlName.Panel_Start);
end

function StartPanelCtrl.Start()
	CustomSocket.hasStartTimer=true;
	soundMgr:playBGM(1);
	this.Open()
	GlobalData.Instance().isonLoginPage = true;
	versionText.text ="版本号："..Application.version;
	if (watingPanel ~= nil) then
		watingPanel:FindChild("Text"):GetComponent("Text").text = "正在连接服务器";
	end
	coroutine.start(this.ConnectTime,1,1);
	--每隔0.1秒執行一次定時器
	coroutine.start(this.isConnected,1,0.1);
	UpdateBeat:Add(this.Update);
end
function StartPanelCtrl.LoginCallBack(response)
	log("LUA:StartPanelCtrl.LoginCallBack="..response.message);
	if (watingPanel ~= nil)then
		watingPanel.gameObject:SetActive(false);
	end
	soundMgr:playBGM(1);
	if (response.status == 1) then
		if (HomePanel.ActiveSelf()) then
			HomePanelCtrl.Close()
		end
	end
	if (GamePanel.ActiveSelf()) then
		GamePanelCtrl.ExitOrDissoliveRoom();
	end
	GlobalData.Instance().loginResponseData =AvatarVO.New(json.decode(response.message));
	ChatSocket.getInstance ():sendMsg (LoginChatRequest.New(GlobalData.loginResponseData.account.uuid));
	HomePanelCtrl.Awake()
	this.Close()
end
function StartPanelCtrl.RoomBackResponse(response)
	watingPanel.gameObject:SetActive(false);
	if (HomePanel.ActiveSelf()) then
		HomePanelCtrl.Close()
	end
	if (GamePanel.ActiveSelf()) then
		GamePanelCtrl.ExitOrDissoliveRoom();
	end
	GlobalData.reEnterRoomData = json.decode (response.message);
	log("Lua:RoomBackResponse=" .. response.message);
	log("Lua:RoomBackResponse playerList.length=" ..#GlobalData.reEnterRoomData.playerList)
	for i = 1,#GlobalData.reEnterRoomData.playerList do
		local itemData =GlobalData.reEnterRoomData.playerList [i];
		if (itemData.account.openid == GlobalData.loginResponseData.account.openid) then
			GlobalData.loginResponseData.account.uuid = itemData.account.uuid;
			ChatSocket.getInstance ():sendMsg (LoginChatRequest.New(GlobalData.loginResponseData.account.uuid));
			break;
		end
	end
	GamePanelCtrl.Awake()
	this.Close()
end
local connectRetruen = false;
function StartPanelCtrl.ConnectTime(time,state)
	connectRetruen = false;
	coroutine.wait(time)
	if (not connectRetruen)then
		--超过5秒还没连接成功显示失败
		if (state == 1)then
			CustomSocket.hasStartTimer = false;
			CustomSocket.getInstance():Connect();
			ChatSocket.getInstance():Connect();
			GlobalData.Instance().isonLoginPage = true;
		else
			if (watingPanel ~= nil)then
				watingPanel.gameObject:SetActive(false);
			end
		end
		print("ConnectTime coroutine over")
	end
end
--这个方法在C#里用的invokerepeating，lua里用协程实现
--time:延迟几秒开始，rate:重复的频率
function StartPanelCtrl.isConnected(time,rate)
	coroutine.wait(time)
	while true do
		if (CustomSocket.getInstance().isConnected) then
			watingPanel.gameObject:SetActive(false);
			--如果已经授权自动登录
			if UNITY_ANDROID then
				if (GlobalData.Instance().wechatOperate.shareSdk:IsAuthorized(PlatformType.WeChat)) then
					this.login();
				end
			elseif UNITY_IPHONE then
				if (GlobalData.Instance().wechatOperate.shareSdk:IsAuthorized(PlatformType.WechatPlatform)) then
					this.login();
				end
			end
			break;
		end
		coroutine.wait(rate)
	end
	print("isConnected coroutine over")
end

function StartPanelCtrl.login()
	if (not CustomSocket.getInstance ().isConnected) then
		CustomSocket.getInstance ().Connect ();
		ChatSocket.getInstance ().Connect();
		return;
	end
	GlobalData.Instance().reinitData ();--初始化界面数值
	if (agreeProtocol.isOn) then
		this.doLogin ();
		watingPanel:FindChild("Text"):GetComponent("Text").text  = "进入游戏中";
		watingPanel.gameObject:SetActive(true);
	else
		log("lua:请先同意用户使用协议");
		TipsManager.Instance().setTips("请先同意用户使用协议",1);
	end
end
function StartPanelCtrl.doLogin()
	coroutine.start(this.ConnectTime,10,0);
	if UNITY_EDITOR or UNITY_STANDALONE_WIN then
		--用于测试 不用微信登录
		resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/LoginPanel.prefab'}, LoginManager.TestLogin);
	else
		GlobalData.Instance ().wechatOperate:login ();
	end
end
-- Update is called once per frame
function StartPanelCtrl.Update()
	--Android系统监听返回键，由于只有Android和ios系统所以无需对系统做判断
	if(Input.GetKey(KeyCode.Escape)) then
	--在登录界面panelCreateDialog肯定是null
		local ctrl = CtrlManager.GetCtrl("ExitPanelCtrl");
		if ctrl then
			ExitPanelCtrl.Open();
			else
			ExitPanelCtrl.Awake();
		end
	end
end

function StartPanelCtrl.OpenXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if(xieyiPanel) then
	xieyiPanel:SetActive(true)
else
	resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/xieyiPanel.prefab'}, this.InitXieyiPanel);
end
end
function StartPanelCtrl.InitXieyiPanel(prefabs)
	xieyiPanel=newObject(prefabs[0]);
	xieyiPanel.transform.parent=StartPanel.transform.parent;
	xieyiPanel.transform.localScale = Vector3.one;
	xieyiPanel.transform:SetAsLastSibling();
	xieyiPanel:GetComponent("RectTransform").offsetMax =Vector2.zero;
	xieyiPanel:GetComponent("RectTransform").offsetMin = Vector2.zero;
end
function StartPanelCtrl.CloseXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if (xieyiPanel) then
		xieyiPanel:SetActive(false);
	end
end
--关闭事件--
function StartPanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function StartPanelCtrl.RemoveListener()
	SocketEventHandle.getInstance ().LoginCallBack = nil;
	SocketEventHandle.getInstance ().RoomBackResponse =nil;
end

--打开事件--
function StartPanelCtrl.Open()
		if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
	end
end
--增加事件--
function StartPanelCtrl.AddListener()
	SocketEventHandle.getInstance ().LoginCallBack = this.LoginCallBack;
	SocketEventHandle.getInstance ().RoomBackResponse =this.RoomBackResponse;
end
