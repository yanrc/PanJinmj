
local Ease = DG.Tweening.Ease
HomePanel = UIBase(define.HomePanel,define.FixUI)
local this = HomePanel;
local gameObject;
local nickNameText;-- 昵称
local cardCountText;-- 房卡剩余数量
local IpText;-- ID
local headIconImg-- 头像
local contactInfoContent-- 房卡面板显示内容
local roomCardPanel-- 房卡面板
local noticeText-- 广播
local CreateRoomButton-- 创建房间
local EnterRoomButton-- 加入房间
local panelCreateDialog

showNum = 1
startFlag = false

function HomePanel.OnCreate(go)
	gameObject = go;
	transform = go.transform
	this:Init(go)
	nickNameText = go.transform:FindChild("Panel_Left/Text_Nick_Name"):GetComponent("Text")
	cardCountText = go.transform:FindChild("Panel_Left/Image_Card_Number_Bg/Text"):GetComponent("Text")
	IpText = go.transform:FindChild("Panel_Left/Text_Nick_IP"):GetComponent("Text")
	headIconImg = go.transform:FindChild("Panel_Left/Image_icon"):GetComponent("Image")
	contactInfoContent = go.transform:FindChild("roomCardInfo/Text_Info_Content"):GetComponent("Text")
	roomCardPanel = go.transform:FindChild("roomCardInfo").gameObject
	noticeText = go.transform:FindChild("Image_Notice_BG/Image (1)/Text"):GetComponent("Text")
	CreateRoomButton = go.transform:FindChild("Panel_Room/Button_Create_Room").gameObject
	EnterRoomButton = go.transform:FindChild("Panel_Room/Button_Enter_Room").gameObject
	this.lua:AddClick(CreateRoomButton, this.OpenCreateRoomDialog);
	this.lua:AddClick(EnterRoomButton, this.OpenEnterRoomDialog);
end



function HomePanel.ContactInfoResponse(response)
	contactInfoContent.text = response.message;
	roomCardPanel:SetActive(true);
end

function HomePanel.InitUI()
	if (GlobalData.loginResponseData ~= nil) then
		local headIcon = GlobalData.loginResponseData.account.headicon;
		local nickName = GlobalData.loginResponseData.account.nickname;
		local roomCardcount = GlobalData.loginResponseData.account.roomcard;
		cardCountText.text = tostring(roomCardcount);
		nickNameText.text = nickName;
		IpText.text = "ID:" .. tostring(GlobalData.loginResponseData.account.uuid);
		CoMgr.LoadImg(headIconImg, headIcon);
	end
end

function HomePanel.ShowUserInfoPanel()
	soundMgr:playSoundByActionButton(1);
	local obj = this.loadPerfab("Assets/Project/Prefabs/userInfo");
	obj.ShowUserInfoScript = ShowUserInfoScript.New()
	obj.ShowUserInfoScript:SetUIData(GlobalData.loginResponseData);
end

function HomePanel.ShowRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	networkMgr:SendMessage(ClientRequest.New(APIS.CONTACT_INFO_REQUEST,""));
end

function HomePanel.CloseRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	roomCardPanel:SetActive(false);
end

function HomePanel.CheckEnterInRoom()
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomId ~= nil) then
		OpenPanel(GamePanel)
	end
end

function HomePanel.Button_openWeb()
	soundMgr:playSoundByActionButton(1);
	Application.OpenURL("https://www.baidu.com/");
end

local Panel_message;

-- 消息显示隐藏

function HomePanel.Button_Mess_Open()
	soundMgr:playSoundByActionButton(1);
	Panel_message = this.loadPerfab("Assets/Project/Prefabs/Panel_message");
end

-- 打开创建房间的对话框
function HomePanel.OpenCreateRoomDialog()
	soundMgr:playSoundByActionButton(1);
	if (GlobalData.loginResponseData == nil or GlobalData.loginResponseData.roomId == 0) then
		OpenPanel(CreateRoomPanel)
	else
		TipsManager.SetTips("当前正在房间状态，无法创建房间");
	end
end

function HomePanel.Button_fankui()
	-- SoundCtrl.getInstance().playSoundByActionButton(1);
	-- Application.OpenURL("http://kefu.easemob.com/webim/im.html?tenantId=31750");

end

-- 打开进入房间的对话框

function HomePanel.OpenEnterRoomDialog()
	soundMgr:playSoundByActionButton(1);
	if (GlobalData.roomVo.roomId == nil or GlobalData.roomVo.roomId == 0) then
		OpenPanel(EnterRoomPanel)
	else
		TipsManager.SetTips("当前正在房间状态，无法加入新的房间");
	end
end

-- 打开设置对话框

function HomePanel.OpenGameSettingDialog()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Setting");
	panelCreateDialog.SettingScript = SettingScript.New()
	local ss = panelCreateDialog.SettingScript;
	ss.jiesanBtn:GetComponentInChildren("Text").text = "退出游戏"
	ss.type = 1;
end



-- 打开游戏规则对话框

function HomePanel.OpenGameRuleDialog()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Game_Rule_Dialog");
end

-- 打开抽奖对话框

function HomePanel.LotteryBtnClick()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Lottery");
end

function HomePanel.ZhanjiBtnClick()
	soundMgr:playSoundByActionButton(1);
	this.loadPerfab("Assets/Project/Prefabs/Panel_Report");
end

function HomePanel.loadPerfab(perfabName)
	resMgr:LoadPrefab('prefabs', { perfabName .. ".prefab" }, function(prefabs)
		panelCreateDialog = newObject(prefabs[0]);
		panelCreateDialog.transform.parent = gameObject.transform
		panelCreateDialog.transform.localScale = Vector3.one
		panelCreateDialog:GetComponent("RectTransform").offsetMax = Vector2.zero
		panelCreateDialog:GetComponent("RectTransform").offsetMin = Vector2.zero
	end )
end


function HomePanel.CardChangeNotice(response)
	local oldCount = tonumber(cardCountText.text);
	-- 原来的钻石数量
	local newCount = tonumber(response.message);
	cardCountText.text = response.message;
	GlobalData.loginResponseData.account.roomcard = newCount;
	contactInfoContent.text = "钻石" .. tostring(newCount - oldCout) .. "颗";
	roomCardPanel:SetActive(true);
end



function HomePanel.GameBroadcastNotice()
	showNum = 1;
	if (not startFlag) then
		startFlag = true;
		this.SetNoticeTextMessage();
	end
end

function HomePanel.SetNoticeTextMessage()
	if (GlobalData.notices ~= nil and #GlobalData.notices > 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.notices[showNum];
		local time = string.len(noticeText.text) * 0.5 + 422 / 56;
		local tweener = noticeText.transform:DOLocalMove(Vector3.New(- string.len(noticeText.text) * 40, noticeText.transform.localPosition.y), time / 1.6, false);
		tweener:OnComplete(this.MoveCompleted)
		tweener:SetEase(Ease.Linear);
	end
end

function HomePanel.MoveCompleted()
	showNum = showNum + 1
	if (showNum == #GlobalData.notices) then
		showNum = 1
	end
	this.SetNoticeTextMessage();
end

function HomePanel.ExitApp()
	soundMgr:playSoundByActionButton(1);
	if (panelExitDialog == nil) then
		this.loadPerfab("Assets/Project/Prefabs/Panel_Exit");
	end
end
-------------------模板-------------------------
function HomePanel.OnOpen()
	this.InitUI();
	GlobalData.isonLoginPage = false;
	this.CheckEnterInRoom();
end
-- 移除事件--
function HomePanel.RemoveListener()
	Event.RemoveListener(APIS.CARD_CHANGE, this.CardChangeNotice)
	Event.RemoveListener(APIS.CONTACT_INFO_RESPONSE, this.ContactInfoResponse)
	Event.RemoveListener(DisplayBroadcast, this.GameBroadcastNotice)
end

-- 增加事件--
function HomePanel.AddListener()
	Event.AddListener(tostring(APIS.CARD_CHANGE), this.CardChangeNotice)
	Event.AddListener(tostring(APIS.CONTACT_INFO_RESPONSE), this.ContactInfoResponse)
	Event.AddListener(DisplayBroadcast, this.GameBroadcastNotice)
end
