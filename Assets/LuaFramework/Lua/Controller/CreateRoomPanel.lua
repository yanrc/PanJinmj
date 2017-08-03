
CreateRoomPanel = UIBase(define.Panels.CreateRoomPanel, define.PopUI)
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
	panelDevoloping = transform:FindChild("root/content/Panel_Developing").gameObject
	local createButton = transform:FindChild("root/content/Button_Create_Sure").gameObject
	local cancelButton = transform:FindChild("root/Image_Create_Bg/Button_Delete").gameObject
	this.lua:AddClick(createButton, this.CreateRoom);
	this.lua:AddClick(cancelButton, this.CloseClick);
	RuleSelectObj = transform:FindChild("root/content/Panel_Game_Setting").gameObject
	RuleSelect.Init(RuleSelectObj)
end

-- 打开九江设置面板
function CreateRoomPanel.OpenJiuJiangSettingPanel()
	soundMgr:playSoundByActionButton(1);
	PlayerPrefs.SetInt("userDefaultMJ", 4);
	panelDevoloping:SetActive(false);
	PanelManager:CreatePanel('JiuJiangPanel', nil);
end

-- 打开九江设置面板
function CreateRoomPanel.OpenPanJinSettingPanel()
	soundMgr:playSoundByActionButton(1);
	panelDevoloping:SetActive(false);
	RuleSelect.Open(PanjinRule)
end


-- 点击隐藏watingPanel
function CreateRoomPanel.Cancle()
	soundMgr:playSoundByActionButton(1);
	ClosePanel(WaitingPanel)
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
	soundMgr:playSoundByActionButton(1);
	local rule = RuleSelect.Select2Int("盘锦麻将")
	local sendVo = {
		roundNumber = 1,
		pingHu = false,
		magnification = false,
		baoSanJia = false,
		jiaGang = false,
		gui = 0,
		duanMen = false,
		jihu = false,
	};
	-- 盘锦麻将为了兼容老版本，不直接发rule
	for i = 1, 10 do
		if ((bit.band(rule, 1)) == 1) then
			if (i == 1) then
				sendVo.jihu = true
			elseif (i == 2) then
				sendVo.duanMen = true
			elseif (i == 3) then
				sendVo.gui = 2
			elseif (i == 4) then
				sendVo.jiaGang = true
			elseif (i == 5) then
				sendVo.baoSanJia = true
			elseif (i == 6) then
				sendVo.magnification = true
			elseif (i == 7) then
				sendVo.pingHu = true
			elseif (i == 8) then
				sendVo.roundNumber = 4
			elseif (i == 9) then
				sendVo.roundNumber = 2
			elseif (i == 10) then
				sendVo.roundNumber = 1
			end
		end
		rule = bit.rshift(rule, 1);
	end
	sendVo.roomType = GameConfig.GAME_TYPE_PANJIN;
	sendVo.addWordCard = true
	local sendMsg = json.encode(sendVo);
	if (LoginData.account.roomcard > 0) then
		OpenPanel(WaitingPanel, "正在创建房间")
		networkMgr:SendMessage(ClientRequest.New(APIS.CREATEROOM_REQUEST, sendMsg));
		RoomData = sendVo;
	else
		TipsManager.SetTips("您的房卡数量不足,不能创建房间")
	end
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
	if (LoginData.account.roomcard > 0) then
		OpenPanel(WaitingPanel, "正在创建房间")
		networkMgr:SendMessage(ClientRequest.New(APIS.CREATEROOM_REQUEST, sendMsg));
		RoomData = sendVo;
	else
		TipsManager.SetTips("您的房卡数量不足,不能创建房间")
	end
end

function CreateRoomPanel.CreateRoom()
	local x = 5;
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

function CreateRoomPanel.OnCreateRoomCallback(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	ClosePanel(WaitingPanel)
	log("lua:OnCreateRoomCallback=" .. message);
	if (status == 1) then
		local roomid = tonumber(message);
		RoomData.roomId = roomid;
		RoomData.enterType = 1;
		LoginData.main = true;
		LoginData.isOnLine = true;
		LoginData.scores = 0;
		ClosePanel(this)
		ClosePanel(HomePanel)
		OpenPanel(GamePanel)
	else
		TipsManager.SetTips(message);
	end
end
-------------------模板-------------------------
function CreateRoomPanel.CloseClick()
	ClosePanel(this)
end
function CreateRoomPanel.OnOpen()
	this.OpenPanJinSettingPanel();
end
-- 移除事件--
function CreateRoomPanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end

-- 增加事件--
function CreateRoomPanel.AddListener()
	Event.AddListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end
