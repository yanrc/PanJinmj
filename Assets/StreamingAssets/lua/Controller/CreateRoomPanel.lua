
CreateRoomPanel = UIBase("CreateRoomPanel")
local this = CreateRoomPanel;
local transform;
local gameObject;

-- 规则toggle
local GameRule = { }
local panelDevoloping

-- 启动事件--
function CreateRoomPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	panelDevoloping = transform:FindChild("Image_Create_Bg/Panel_Developing").gameObject
	local createButton = transform:FindChild("Button_Create_Sure").gameObject
	local cancelButton = transform:FindChild("Image_Create_Bg/Button_Delete").gameObject
	this.lua:AddClick(createButton, this.CreateRoom);
	this.lua:AddClick(cancelButton, this.Close);
end

function CreateRoomPanel.Start()
	this.AddListener()
	this.OpenJiuJiangSettingPanel();
end

-- 打开九江设置面板
function CreateRoomPanel.OpenJiuJiangSettingPanel()
	soundMgr:playSoundByActionButton(1);
	GlobalData.userMaJiangKind = 4;
	PlayerPrefs.SetInt("userDefaultMJ", 4);
	panelDevoloping:SetActive(false);
	PanelManager:CreatePanel('JiuJiangPanel', nil);
end

-- 点击隐藏watingPanel
function CreateRoomPanel.Cancle()
	soundMgr:playSoundByActionButton(1);
	WaitingPanel:Close()
end

-- 点击下载(过时)
function CreateRoomPanel.Button_down()
	soundMgr:playSoundByActionButton(1);
	Application.OpenURL("http://a.app.qq.com/o/simple.jsp?pkgname=com.pengyoupdk.poker");
end

-- 显示正在开发中
function CreateRoomPanel.OpenDevloping()
	soundMgr:playSoundByActionButton(1);
	button_DownLoad.gameObject:SetActive(false);
end

function CreateRoomPanel.CreateZhuanzhuanRoom()

end

function CreateRoomPanel.CreateHuashuiRoom()

end

function CreateRoomPanel.CreateChangshaRoom()

end

function CreateRoomPanel.CreateGuangDongRoom()

end

function CreateRoomPanel.CreatePanjinRoom()

end

function CreateRoomPanel.CreateShuangLiaoRoom()

end
-- 创建九江麻将房间
function CreateRoomPanel.CreateJiuJiangRoom()
	soundMgr:playSoundByActionButton(1);
	local jiujiang = JiuJiangPanel
	local sendVo = { };
	sendVo.roundNumber = jiujiang.GetRoundNumber();
	sendVo.roomType = GameConfig.GAME_TYPE_SHUANGLIAO;
	sendVo.mayou = jiujiang.GetMayou();
	sendVo.kunmai = jiujiang.GetKunmai();
	sendVo.hongzhonglaizi = jiujiang.GetHongzhongLaizi();
	local sendMsg = json.encode(sendVo);
	if (GlobalData.loginResponseData.account.roomcard > 0) then
		WaitingPanel:Open("正在创建房间")
		networkMgr:SendMessage(ClientRequest.New(APIS.CREATEROOM_REQUEST, sendMsg));
		GlobalData.roomVo = sendVo;
	else
		TipsManager.SetTips("您的房卡数量不足,不能创建房间")
	end
end

function CreateRoomPanel.CreateRoom()
	local x = 7;
	local switch =
	{
		[1] = this.CreateZhuanzhuanRoom,
		[2] = this.CreateHuashuiRoom,
		[3] = this.CreateChangshaRoom,
		[4] = this.CreateGuangDongRoom,
		[5] = this.CreatePanjinRoom,
		[6] = this.CreateShuangLiaoRoom,
		[7] = this.CreateJiuJiangRoom
	}
	switch[x]()
end

function CreateRoomPanel.OnCreateRoomCallback(response)
	WaitingPanel:Close()
	log("lua:OnCreateRoomCallback=" .. response.message);
	if (response.status == 1) then
		local roomid = tonumber(response.message);
		GlobalData.roomVo.roomId = roomid;
		GlobalData.loginResponseData.roomId = roomid;
		GlobalData.loginResponseData.main = true;
		GlobalData.loginResponseData.isOnLine = true;
		GlobalData.reEnterRoomData = nil;
		if (CtrlManager.GamePanel) then
			CtrlManager.GamePanel.Open()
		else
			GamePanel.Awake()
		end
		this.Close();
		HomePanelCtrl.Close()
	else
		TipsManager.SetTips(response.message);
	end
end
-------------------模板-------------------------



-- 移除事件--
function CreateRoomPanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end

-- 增加事件--
function CreateRoomPanel.AddListener()
	Event.AddListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end
