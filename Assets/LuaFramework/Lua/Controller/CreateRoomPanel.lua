
CreateRoomPanel = UIBase(define.Panels.CreateRoomPanel, define.PopUI)
local this = CreateRoomPanel;
local transform;
local gameObject;

-- 规则toggle
local GameRule = { }
-- local panelDevoloping

local currentGame = GameConfig.GAME_TYPE_PANJIN
-- 启动事件--
function CreateRoomPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	-- panelDevoloping = transform:FindChild("root/content/Panel_Developing").gameObject
	local createButton = transform:FindChild("root/content/Button_Create_Sure").gameObject
	local cancelButton = transform:FindChild("root/Image_Create_Bg/Button_Delete").gameObject
	local tab = transform:FindChild("root/Panel_Game_Buttons/Button_base").gameObject
	local tabsRoot = transform:FindChild("root/Panel_Game_Buttons")
	local toggleGroup = tabsRoot:GetComponent("ToggleGroup")
	this.lua:AddClick(createButton, this.CreateRoom);
	this.lua:AddClick(cancelButton, this.CloseClick);
	RuleSelectObj = transform:FindChild("root/content/Panel_Game_Setting").gameObject
	RuleSelect.Init(RuleSelectObj)
	for i = 1, #APIS.Rules do
		local obj = newObject(tab, tabsRoot)
		obj:SetActive(true)
		local ruletable = APIS.Rules[i]
		obj.transform:FindChild("Text"):GetComponent("Text").text = ruletable.name
		local toggle = obj:GetComponent("Toggle")
		toggle.group = toggleGroup
		toggle.onValueChanged:AddListener( function(isOn) this.Setting(ruletable, obj, isOn) end)
		if (i == 1) then
			toggle.isOn = true
		end
	end
end

function CreateRoomPanel.Setting(ruletable, obj, isOn)
	if isOn then
		soundMgr:playSoundByActionButton(1);
		currentGame = ruletable.index
		RuleSelect.Open(ruletable)
	else
		RuleSelect.Close(ruletable)
	end
end


-- 设置面板
-- function CreateRoomPanel.OpenPanJinSettingPanel()
-- soundMgr:playSoundByActionButton(1);
-- -- panelDevoloping:SetActive(false);
-- currentGame = GameConfig.GAME_TYPE_PANJIN
-- RuleSelect.Open(PanjinRule)
-- end


-- 点击隐藏watingPanel
function CreateRoomPanel.Cancle()
	soundMgr:playSoundByActionButton(1);
	ClosePanel(WaitingPanel)
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
	soundMgr:playSoundByActionButton(1);
	local rule, num = RuleSelect.Select2Int(ChangshaRule.name)
	local sendVo = {
		roundNumber = 1,
		zhuangxian = false,
		ma = 0,
	};
	for i = 1, num do
		if ((bit.band(rule, 1)) == 1) then
			if (i == 1) then
				sendVo.ma = 5
			elseif (i == 2) then
				sendVo.ma = 4
			elseif (i == 3) then
				sendVo.ma = 3
			elseif (i == 4) then
				sendVo.ma = 2
			elseif (i == 5) then
				sendVo.ma = 1
			elseif (i == 6) then
				sendVo.ma = 0
			elseif (i == 7) then
				sendVo.zhuangxian = true
			elseif (i == 8) then
				sendVo.roundNumber = 16
			elseif (i == 9) then
				sendVo.roundNumber = 8
			elseif (i == 10) then
				sendVo.roundNumber = 4
			end
		end
		rule = bit.rshift(rule, 1);
	end
	sendVo.roomType = currentGame;
	local sendMsg = json.encode(sendVo);
	if (LoginData.account.roomcard > 0) then
		OpenPanel(WaitingPanel, "正在创建房间")
		networkMgr:SendMessage(ClientRequest.New(APIS.CREATEROOM_REQUEST, sendMsg));
		RoomData = sendVo;
	else
		TipsManager.SetTips("您的房卡数量不足,不能创建房间")
	end
end

function CreateRoomPanel.CreateGuangdongRoom()

end

function CreateRoomPanel.CreatePanjinRoom()
	soundMgr:playSoundByActionButton(1);
	local rule, num = RuleSelect.Select2Int(PanjinRule.name)
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
	for i = 1, num do
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
	sendVo.roomType = currentGame;
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

function CreateRoomPanel.CreateShuangliaoRoom()

end
-- 创建九江麻将房间
function CreateRoomPanel.CreateJiujiangRoom()
	soundMgr:playSoundByActionButton(1);
	local rule, num = RuleSelect.Select2Int(JiujiangRule.name)
	local sendVo = {
		roundNumber = 1,
		mayou = 0,
		piaofen = 0,
		gui = 0,
	};
	for i = 1, num do
		if ((bit.band(rule, 1)) == 1) then
			if (i == 1) then
				sendVo.gui = 2
			elseif (i == 2) then
				sendVo.piaofen = 2
			elseif (i == 3) then
				sendVo.piaofen = 1
			elseif (i == 4) then
				sendVo.piaofen = 0
			elseif (i == 5) then
				sendVo.mayou = 2
			elseif (i == 6) then
				sendVo.mayou = 1
			elseif (i == 7) then
				sendVo.mayou = 0
			elseif (i == 8) then
				sendVo.roundNumber = 16
			elseif (i == 9) then
				sendVo.roundNumber = 8
			elseif (i == 10) then
				sendVo.roundNumber = 4
			end
		end
		rule = bit.rshift(rule, 1);
	end
	sendVo.roomType = currentGame;
	local sendMsg = json.encode(sendVo);
	if (LoginData.account.roomcard > 0) then
		OpenPanel(WaitingPanel, "正在创建房间")
		networkMgr:SendMessage(ClientRequest.New(APIS.CREATEROOM_REQUEST, sendMsg));
		RoomData = sendVo;
	else
		TipsManager.SetTips("您的房卡数量不足,不能创建房间")
	end
end

function CreateRoomPanel.CreateTuidaohuRoom()
	soundMgr:playSoundByActionButton(1);
	local rule, num = RuleSelect.Select2Int(TuidaohuRule.name)
	local sendVo = {
		roundNumber = 1,
		rule = 0,
		ma = 0,
	};
	for i = 1, num do
		if ((bit.band(rule, 1)) == 1) then
			if (i == 1) then
				sendVo.ma = 1
			elseif (i == 2) then
				sendVo.ma = 0
			elseif (i == 3) then
				sendVo.rule=sendVo.rule+8
			elseif (i == 4) then
				sendVo.rule=sendVo.rule+4
			elseif (i == 5) then
				sendVo.rule=sendVo.rule+2
			elseif (i == 6) then
				sendVo.rule=sendVo.rule+1
			elseif (i == 7) then
				sendVo.roundNumber = 16
			elseif (i == 8) then
				sendVo.roundNumber = 8
			elseif (i == 9) then
				sendVo.roundNumber = 4
			end
		end
		rule = bit.rshift(rule, 1);
	end
	sendVo.roomType = currentGame;
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
	local x = currentGame
	local switch =
	{
		[1] = this.CreateZhuanzhuanRoom,
		[2] = this.CreateHuashuiRoom,
		[3] = this.CreateChangshaRoom,
		[4] = this.CreateGuangdongRoom,
		[5] = this.CreatePanjinRoom,
		[6] = this.CreateWuxiRoom,
		[7] = this.CreateShuangliaoRoom,
		[8] = this.CreateJiujiangRoom,
		[9] = this.CreateTuidaohuRoom,
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
		OpenPanel(StartPanel.GetGame(RoomData.roomType))
	else
		TipsManager.SetTips(message);
	end
end
-------------------模板-------------------------
function CreateRoomPanel.CloseClick()
	ClosePanel(this)
end
function CreateRoomPanel:OnOpen()

end
-- 移除事件--
function CreateRoomPanel:RemoveListener()
	Event.RemoveListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end

-- 增加事件--
function CreateRoomPanel:AddListener()
	Event.AddListener(tostring(APIS.CREATEROOM_RESPONSE), this.OnCreateRoomCallback)
end
