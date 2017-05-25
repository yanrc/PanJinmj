require "View/CreateRoomPanel"
require "View/JiuJiangPanel"
require "Vos/CreateRoomRequest"
local json = require "cjson"
CreateRoomPanelCtrl = { };
local this = CreateRoomPanelCtrl;
local transform;
local gameObject;


-- 规则toggle
local GameRule = { }
local panelDevoloping
local watingPanel
----加载函数----
function CreateRoomPanelCtrl.Awake()
	logWarn("CreateRoomPanelCtrl Awake--->>");
	PanelManager:CreatePanel("CreateRoomPanel", this.OnCreate);
	CtrlManager.AddCtrl("CreateRoomPanelCtrl", this)
end

-- 启动事件--
function CreateRoomPanelCtrl.OnCreate(obj)
	gameObject = obj;
	lua = gameObject:GetComponent('LuaBehaviour');
	panelDevoloping =obj.transform:FindChild("Image_Create_Bg/Panel_Developing").gameObject
	watingPanel =obj.transform:FindChild("Image_Create_Bg/wait").gameObject
	local createButton =obj.transform:FindChild("Button_Create_Sure").gameObject
	lua:AddClick(createButton, this.CreateRoom);
	-- lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	this.Start()
	logWarn("Start lua--->>" .. gameObject.name);
end

function CreateRoomPanelCtrl.Start()
	this.AddListener()
	this.OpenJiuJiangSettingPanel();
end

-- 打开九江设置面板
function CreateRoomPanelCtrl.OpenJiuJiangSettingPanel()
	soundMgr:playSoundByActionButton(1);
	GlobalData.userMaJiangKind = 4;
	PlayerPrefs.SetInt("userDefaultMJ", 4);
	panelDevoloping:SetActive(false);
	PanelManager:CreatePanel('JiuJiangPanel', nil);
end

-- 点击隐藏watingPanel
local function Cancle()
	soundMgr:playSoundByActionButton(1);
	watingPanel:SetActive(false);
end

-- 点击下载(过时)
local function Button_down()
	soundMgr:playSoundByActionButton(1);
	Application.OpenURL("http://a.app.qq.com/o/simple.jsp?pkgname=com.pengyoupdk.poker");
end

-- 显示正在开发中
local function OpenDevloping()
	soundMgr:playSoundByActionButton(1);
	button_DownLoad.gameObject:SetActive(false);
end

function CreateRoomPanelCtrl.CreateZhuanzhuanRoom()

end

function CreateRoomPanelCtrl.CreateHuashuiRoom()

end 

function CreateRoomPanelCtrl.CreateChangshaRoom()

end 

function CreateRoomPanelCtrl.CreateGuangDongRoom()

end 

function CreateRoomPanelCtrl.CreatePanjinRoom()

end 

function CreateRoomPanelCtrl.CreateShuangLiaoRoom()

end  
-- 创建九江麻将房间
function CreateRoomPanelCtrl.CreateJiuJiangRoom()
	soundMgr:playSoundByActionButton(1);
	local jiujiang = JiuJiangPanel
	local sendVo = { };
	sendVo.roundNumber = jiujiang.GetRoundNumber();
	sendVo.roomType = GameConfig.GAME_TYPE_SHUANGLIAO;
	sendVo.mayou = jiujiang.GetMayou();
	sendVo.kunmai = jiujiang.GetKunmai();
	sendVo.hongzhonglaizi = jiujiang.GetHongzhongLaizi();
	local sendmsgstr = json.encode(sendVo);
	if (GlobalData.loginResponseData.account.roomcard > 0) then
		watingPanel:SetActive(true)
		CustomSocket.getInstance():sendMsg(CreateRoomRequest.New(sendmsgstr));
		GlobalData.roomVo = sendVo;
	else
		TipsManager.Instance().setTips("你的房卡数量不足，不能创建房间");
	end
end

function CreateRoomPanelCtrl.CreateRoom()
	local x = 7;
	local switch =
	{
		[1] = this.CreateZhuanzhuanRoom(),
		[2] = this.CreateHuashuiRoom(),
		[3] = this.CreateChangshaRoom(),
		[4] = this.CreateGuangDongRoom(),
		[5] = this.CreatePanjinRoom(),
		[6] = this.CreateShuangLiaoRoom(),
		[7] = this.CreateJiuJiangRoom()
	}
	switch[x]()
end

local function OnCreateRoomCallback(response)
	if (watingPanel ~= nil) then
		watingPanel:SetActive(false);
	end
	log(response.message);
	if (response.status == 1) then
		local roomid = tonumber(response.message);
		GlobalData.roomVo.roomId = roomid;
		GlobalData.loginResponseData.roomId = roomid;
		GlobalData.loginResponseData.main = true;
		GlobalData.loginResponseData.isOnLine = true;
		GlobalData.reEnterRoomData = nil;
		GlobalData.gamePlayPanel = GamePanelCtrl.Awake()
		this.Close();
	else
		TipsManager.setTips(response.message);
	end
end
-------------------模板-------------------------

-- 关闭面板--
function CreateRoomPanelCtrl.Close()
	soundMgr:playSoundByActionButton(1);
	gameObject:SetActive(false)
	this.RemoveListener()
end

-- 移除事件--
function CreateRoomPanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().CreateRoomCallBack = nil;
end

-- 打开面板--
function CreateRoomPanelCtrl.Open()
	if (gameObject) then
		gameObject:SetActive(true)
		transform:SetAsLastSibling();
		this.AddListener()
	end
end
-- 增加事件--
function CreateRoomPanelCtrl.AddListener()
	SocketEventHandle.getInstance().CreateRoomCallBack = OnCreateRoomCallback;
end
