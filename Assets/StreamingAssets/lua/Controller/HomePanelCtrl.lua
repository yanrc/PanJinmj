require "View/HomePanel"
require "Controller/CreateRoomPanelCtrl"
HomePanelCtrl = { }
local this = HomePanelCtrl;
local gameObject;
local nickNameText;-- 昵称
local cardCountText;-- 房卡剩余数量
local IpText;-- ID
local headIconImg-- 头像
local contactInfoContent-- 房卡面板显示内容
local roomCardPanel-- 房卡面板
local noticeText-- 广播
local CreateRoomButton-- 创建房间
local panelCreateDialog
local CreateRoomCtrl
showNum = 0
startFlag = false
function HomePanelCtrl.Awake()
	logWarn("HomePanelCtrl.Awake--->>");
	PanelManager:CreatePanel('HomePanel', this.OnCreate);
	CtrlManager.AddCtrl("HomePanelCtrl", this)
end

function HomePanelCtrl.OnCreate(go)
	gameObject = go;
	transform = go.transform
	this.lua = gameObject:GetComponent('LuaBehaviour');
	nickNameText = go.transform:FindChild("Panel_Left/Text_Nick_Name"):GetComponent("Text")
	cardCountText = go.transform:FindChild("Panel_Left/Image_Card_Number_Bg/Text"):GetComponent("Text")
	IpText = go.transform:FindChild("Panel_Left/Text_Nick_IP"):GetComponent("Text")
	headIconImg = go.transform:FindChild("Panel_Left/Image_icon"):GetComponent("Image")
	contactInfoContent = go.transform:FindChild("roomCardInfo/Text_Info_Content"):GetComponent("Text")
	roomCardPanel = go.transform:FindChild("roomCardInfo").gameObject
	noticeText = go.transform:FindChild("Image_Notice_BG/Image (1)/Text"):GetComponent("Text")
	CreateRoomButton = go.transform:FindChild("Panel_Room/Button_Create_Room").gameObject
	logWarn("Start lua--->>" .. gameObject.name);

	this.lua:AddClick(CreateRoomButton, this.OpenCreateRoomDialog);
	this.Start()
end

function HomePanelCtrl.Start()
	this.InitUI();
	GlobalData.isonLoginPage = false;
	this.checkEnterInRoom();
	this.AddListener();
	noticeText.text = "我在测试啊"
	local time = string.len(noticeText.text) * 0.5 + 422 / 56;
	local textTransform = gameObject.transform:FindChild("Image_Notice_BG/Image (1)/Text")
	local tweener = textTransform:DOLocalMove(Vector3.New(- string.len(noticeText.text) * 40, textTransform.localPosition.y), time / 1.6, false);
	log(this.MoveCompleted)
	tweener:OnComplete(this.MoveCompleted)
	-- tweener:SetEase(Ease.Linear);
end

function HomePanelCtrl.ContactInfoResponse(response)
	contactInfoContent.text = response.message;
	roomCardPanel:SetActive(true);
end

function HomePanelCtrl.InitUI()
	if (GlobalData.loginResponseData ~= nil) then
		local headIcon = GlobalData.loginResponseData.account.headicon;
		local nickName = GlobalData.loginResponseData.account.nickname;
		local roomCardcount = GlobalData.loginResponseData.account.roomcard;
		cardCountText.text = tostring(roomCardcount);
		nickNameText.text = nickName;
		IpText.text = "ID:" .. tostring(GlobalData.loginResponseData.account.uuid);
		coroutine.start(this.LoadImg, headIcon);
	end
end

function HomePanelCtrl.ShowUserInfoPanel()

	soundMgr:playSoundByActionButton(1);
	-- userInfoPanel.SetActive (true);
	local obj = PrefabManage.loadPerfab("Assets/Project/Prefabs/userInfo");
	obj.ShowUserInfoScript = ShowUserInfoScript.New()
	obj.ShowUserInfoScript:setUIData(GlobalData.loginResponseData);
end

function HomePanelCtrl.ShowRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	CustomSocket.getInstance():sendMsg(GetContactInfoRequest.New());
end

function HomePanelCtrl.CloseRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	roomCardPanel:SetActive(false);
end

function HomePanelCtrl.checkEnterInRoom()
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomId ~= 0) then
		GamePanelCtrl.Awake()
	end
end

function HomePanelCtrl.Button_openWeb()
	soundMgr:playSoundByActionButton(1);
	Application.OpenURL("https://www.baidu.com/");
end

local Panel_message;

-- 消息显示隐藏

function HomePanelCtrl.Button_Mess_Open()
	soundMgr:playSoundByActionButton(1);
	Panel_message = PrefabManage.loadPerfab("Assets/Project/Prefabs/Panel_message");
end

-- 打开创建房间的对话框
function HomePanelCtrl.OpenCreateRoomDialog()
	soundMgr:playSoundByActionButton(1);
	if (GlobalData.loginResponseData == nil or GlobalData.loginResponseData.roomId == 0) then
		CreateRoomPanelCtrl.Awake()
	else
		TipsManager.Instance().setTips("当前正在房间状态，无法创建房间");
	end
end

function HomePanelCtrl.Button_fankui()
	-- SoundCtrl.getInstance().playSoundByActionButton(1);
	-- Application.OpenURL("http://kefu.easemob.com/webim/im.html?tenantId=31750");

end

-- 打开进入房间的对话框

function HomePanelCtrl.OpenEnterRoomDialog()
	soundMgr:playSoundByActionButton(1);
	if (GlobalData.roomVo == nil or GlobalData.roomVo.roomId == 0) then
		this.loadPerfab("Assets/Project/Prefabs/Panel_Enter_Room");
	else
		TipsManager.Instance().setTips("当前正在房间状态，无法加入新的房间");
	end
end

-- 打开设置对话框

function HomePanelCtrl.OpenGameSettingDialog()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Setting");
	panelCreateDialog.SettingScript = SettingScript.New()
	local ss = panelCreateDialog.SettingScript;
	ss.jiesanBtn:GetComponentInChildren("Text").text = "退出游戏";
	ss.type = 1;
end



-- 打开游戏规则对话框

function HomePanelCtrl.OpenGameRuleDialog()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Game_Rule_Dialog");
end

-- 打开抽奖对话框

function HomePanelCtrl.LotteryBtnClick()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Lottery");
end

function HomePanelCtrl.ZhanjiBtnClick()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Report");
end

function HomePanelCtrl.loadPerfab(perfabName)
	resMgr:LoadPrefab('prefabs', { perfabName .. ".prefab" }, function(prefabs)
		panelCreateDialog = newObject(prefabs[0]);
		panelCreateDialog.transform.parent = gameObject.transform
		panelCreateDialog.transform.localScale = Vector3.one
		panelCreateDialog:GetComponent("RectTransform").offsetMax = Vector2.zero
		panelCreateDialog:GetComponent("RectTransform").offsetMin = Vector2.zero
	end )
end

function HomePanelCtrl.LoadImg(headIcon)
	-- 开始下载图片
	log("lua:HomePanelCtrl.LoadImg headIcon=" .. headIcon)
	if (headIcon ~= nil and headIcon ~= "") then
		if (GlobalData.wwwSpriteImage.headIcon) then
			headIconImg.sprite = GlobalData.wwwSpriteImage.headIcon;
			coroutine.stop()
		end
		local www = WWW(headIcon);
		coroutine.www(www)
		local ret, errMessage = pcall(
		function()
			-- 下载完成，保存图片到路径filePath
			local texture2D = www.texture;
			local bytes = texture2D:EncodeToPNG();
			-- 将图片赋给场景上的Sprite
			local tempSp = UnityEngine.Sprite.Create(texture2D, UnityEngine.Rect.New(0, 0, texture2D.width, texture2D.height), Vector2.zero);
			headIconImg.sprite = tempSp;
			GlobalData.wwwSpriteImage.headIcon = tempSp;
		end )
		if not ret then
			error("error:" .. errMessage)
			return
		end
	end
end



function HomePanelCtrl.CardChangeNotice(response)
	local oldCount = tonumber(cardCountText.text);
	-- 原来的钻石数量
	local newCount = tonumber(response.message);
	cardCountText.text = response.message;
	GlobalDataScript.loginResponseData.account.roomcard = newCount;
	contactInfoContent.text = "钻石" .. tostring(newCount - oldCout) .. "颗";
	roomCardPanel:SetActive(true);
end



function HomePanelCtrl.GameBroadcastNotice()
	showNum = 0;
	if (not startFlag) then
		startFlag = true;
		this.SetNoticeTextMessage();
	end
end

function HomePanelCtrl.SetNoticeTextMessage()
	--[[if (GlobalData.noticeMegs ~= nil and GlobalData.noticeMegs.Count ~= 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.noticeMegs[showNum];
		local time = noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = noticeText.transform.DOLocalMove(
		Vector3.New(-noticeText.text.Length * 40, noticeText.transform.localPosition.y), time/1.6)
		.OnComplete(this.MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end--]]
end

function HomePanelCtrl.MoveCompleted()
	log("MoveCompleted")
end

function HomePanelCtrl.ExitApp()
	soundMgr:playSoundByActionButton(1);
	if (panelExitDialog == nil) then
		this.loadPerfab("Assets/Project/Prefabs/Panel_Exit");
	end
end
-------------------模板-------------------------

-- 关闭事件--
function HomePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

-- 移除事件--
function HomePanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().cardChangeNotice = nil;
	SocketEventHandle.getInstance().contactInfoResponse = nil;
	Event.RemoveListener(DisplayBroadcast, this.GameBroadcastNotice)
end

-- 打开事件--
function HomePanelCtrl.Open()
	if (gameObject) then
		gameObject:SetActive(true)
		transform:SetAsLastSibling();
		this.AddListener()
	end
end
-- 增加事件--
function HomePanelCtrl.AddListener()
	SocketEventHandle.getInstance().cardChangeNotice = this.CardChangeNotice;
	SocketEventHandle.getInstance().contactInfoResponse = this.ContactInfoResponse;
	Event.AddListener(DisplayBroadcast, this.GameBroadcastNotice)
end
