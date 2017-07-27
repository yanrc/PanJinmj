

StartPanel = UIBase(define.Panels.StartPanel,define.FixUI)
local this = StartPanel
local transform;
local gameObject;
local versionText;-- 版本号
local panelCreate;-- 要加载的面板的引用
local agreeProtocol;-- toggle
local xieyiPanel;-- 协议面板
local xieyiButton;-- 打开协议面板的按钮
local btnLogin-- 登录按钮
-- 启动事件--
function StartPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	versionText = gameObject.transform:FindChild("TextVersion"):GetComponent('Text');
	agreeProtocol = gameObject.transform:FindChild("Toggle"):GetComponent('Toggle');
	xieyiButton = gameObject.transform:FindChild("Toggle/Label").gameObject;
	btnLogin = transform:FindChild("Button").gameObject;
	this.lua:AddClick(btnLogin, this.Login);
	this.lua:AddClick(xieyiButton, this.OpenXieyiPanel);
	
end



function StartPanel.LoginCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	log("LUA:StartPanel.LoginCallBack=" .. message);
	ClosePanel(WaitingPanel)
	soundMgr:playBGM(1);
	GlobalData.loginResponseData = AvatarVO.New(json.decode(message));
	OpenPanel(HomePanel)
	ClosePanel(this)
end
function StartPanel.RoomBackResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	ClosePanel(WaitingPanel)
	GlobalData.reEnterRoomData = json.decode(message);
	log("Lua:RoomBackResponse=" .. message);
	log("Lua:RoomBackResponse playerList.length=" .. #GlobalData.reEnterRoomData.playerList)
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local itemData = GlobalData.reEnterRoomData.playerList[i];
		if (itemData.account.openid == GlobalData.loginResponseData.account.openid) then
			GlobalData.loginResponseData=AvatarVO.New(itemData)
			local userlist={GlobalData.loginResponseData.account.uuid}
			networkMgr:SendChatMessage(ChatRequest.New(APIS.LoginChat_Request,userlist,nil,nil));
			break;
		end
	end
	OpenPanel(GamePanel)
	ClosePanel(this)
end

function StartPanel.ConnectTime(time)
	coroutine.wait(1)
	networkMgr:SendConnect();
	GlobalData.isonLoginPage = true;
end

function StartPanel.OnConnect()
	ClosePanel(WaitingPanel)
	-- 如果已经授权自动登录
	if UNITY_ANDROID then
		if (WechatOperate.shareSdk:IsAuthorized(PlatformType.WeChat)) then
			this.Login();
		end
	elseif UNITY_IPHONE then
		if (WechatOperate.shareSdk:IsAuthorized(PlatformType.WechatPlatform)) then
			this.Login();
		end
	end
end

function StartPanel.Login()
	GlobalData.ReinitData();
	-- 初始化界面数值
	if (agreeProtocol.isOn) then
		this.doLogin();
		OpenPanel(WaitingPanel,"进入游戏中")
	else
		log("lua:请先同意用户使用协议");
		TipsManager.SetTips("请先同意用户使用协议", 1);
	end
end
function StartPanel.doLogin()
	log("UNITY_EDITOR="..tostring(UNITY_EDITOR)..",UNITY_STANDALONE_WIN="..tostring(UNITY_STANDALONE_WIN))
	if UNITY_EDITOR or UNITY_STANDALONE_WIN then
		-- 用于测试 不用微信登录
		resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/LoginPanel.prefab' }, LoginManager.TestLogin);
	else
		WechatOperate.Login();
	end
end
-- Update is called once per frame
--function StartPanel.Update()
--	-- Android系统监听返回键，由于只有Android和ios系统所以无需对系统做判断
--	if (Input.GetKey(KeyCode.Escape)) then
--		-- 在登录界面panelCreateDialog肯定是null
--		OpenPanel(ExitPanel)
--	end
--end

function StartPanel.OpenXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if (xieyiPanel) then
		xieyiPanel:SetActive(true)
	else
		resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/xieyiPanel.prefab' }, this.InitXieyiPanel);
	end
end
function StartPanel.InitXieyiPanel(prefabs)
	xieyiPanel = newObject(prefabs[0]);
	xieyiPanel.transform.parent = StartPanel.transform.parent;
	xieyiPanel.transform.localScale = Vector3.one;
	xieyiPanel.transform:SetAsLastSibling();
	xieyiPanel:GetComponent("RectTransform").offsetMax = Vector2.zero;
	xieyiPanel:GetComponent("RectTransform").offsetMin = Vector2.zero;
end
function StartPanel.CloseXieyiPanel()
	soundMgr:playSoundByActionButton(1);
	if (xieyiPanel) then
		xieyiPanel:SetActive(false);
	end
end


-------------------模板-------------------------
function StartPanel.OnOpen()
	soundMgr:playBGM(1);
	GlobalData.isonLoginPage = true;
	versionText.text = "版本号：" .. Application.version;
	OpenPanel(WaitingPanel,"正在连接服务器")
	-- 1秒后开始连接
	coroutine.start(this.ConnectTime, 1);
end
-- 移除事件--
function StartPanel.RemoveListener()
	--UpdateBeat:Remove(this.Update);
	Event.RemoveListener(Protocal.Connect, this.OnConnect);
	Event.RemoveListener(tostring(APIS.LOGIN_RESPONSE), this.LoginCallBack)
	Event.RemoveListener(tostring(APIS.BACK_LOGIN_RESPONSE), this.RoomBackResponse)
end

-- 增加事件--
function StartPanel.AddListener()
	--UpdateBeat:Add(this.Update);
	Event.AddListener(Protocal.Connect, this.OnConnect);
	Event.AddListener(tostring(APIS.LOGIN_RESPONSE), this.LoginCallBack)
	Event.AddListener(tostring(APIS.BACK_LOGIN_RESPONSE), this.RoomBackResponse)
end
