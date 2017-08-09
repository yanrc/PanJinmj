
local Ease = DG.Tweening.Ease
HomePanel = UIBase(define.Panels.HomePanel, define.FixUI)
local this = HomePanel;
local gameObject;
local nickNameText;-- 昵称
local cardCountText;-- 房卡剩余数量
local IpText;-- ID
local headIconImg-- 头像
local headIconbg-- 头像框
local contactInfoContent-- 房卡面板显示内容
local roomCardPanel-- 房卡面板
local noticeText-- 广播
local CreateRoomButton-- 创建房间
local EnterRoomButton-- 加入房间
local panelCreateDialog
local btnMessage-- 消息按钮
local btnRule-- 玩法按钮
local btnSet-- 设置按钮
local btnBuy-- 购买按钮
local btnShop-- 商城按钮
local btnShare-- 分享按钮
local btnRecord-- 战绩按钮
local logo
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
	headIconbg = go.transform:FindChild("Panel_Left/Image_icon_bg").gameObject
	contactInfoContent = go.transform:FindChild("roomCardInfo/Text_Info_Content"):GetComponent("Text")
	roomCardPanel = go.transform:FindChild("roomCardInfo").gameObject
	noticeText = go.transform:FindChild("Image_Notice_BG/Image (1)/Text"):GetComponent("Text")
	CreateRoomButton = go.transform:FindChild("Panel_Room/Button_Create_Room").gameObject
	EnterRoomButton = go.transform:FindChild("Panel_Room/Button_Enter_Room").gameObject
	btnMessage = go.transform:FindChild("Panel_Right/btnMessage").gameObject
	btnRule = go.transform:FindChild("Panel_Right/btnRule").gameObject
	btnSet = go.transform:FindChild("Panel_Right/btnSet").gameObject
	btnBuy = go.transform:FindChild("Panel_Left/Image_Card_Number_Bg/jiahao").gameObject
	btnShop = transform:FindChild("Bottom/shop").gameObject
	btnShare = transform:FindChild("Bottom/share").gameObject
	btnRecord = transform:FindChild("Bottom/Record").gameObject
	logo=transform:FindChild("Image_Bg/logo"):GetComponent("Image")
	logo.sprite=GameSetting.LOGO
	this.lua:AddClick(CreateRoomButton, this.OpenCreateRoomDialog);
	this.lua:AddClick(EnterRoomButton, this.OpenEnterRoomDialog);
	this.lua:AddClick(headIconbg, this.ShowUserInfoPanel);
	this.lua:AddClick(btnMessage, this.Button_Mess_Open);
	this.lua:AddClick(btnRule, this.OpenGameRuleDialog);
	this.lua:AddClick(btnSet, this.OpenGameSettingDialog);
	this.lua:AddClick(btnBuy, this.OpenShop);
	this.lua:AddClick(btnShop, this.OpenShop);
	this.lua:AddClick(btnShare, this.Share);
	this.lua:AddClick(btnRecord, this.OpenRecord);
end



function HomePanel.ContactInfoResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	contactInfoContent.text = message;
	roomCardPanel:SetActive(true);
end

function HomePanel.InitUI()
	if (LoginData ~= nil) then
		local headIcon = LoginData.account.headicon;
		local nickName = LoginData.account.nickname;
		local roomCardcount = LoginData.account.roomcard;
		cardCountText.text = tostring(roomCardcount);
		nickNameText.text = nickName;
		IpText.text = "ID:" .. tostring(LoginData.account.uuid);
		CoMgr.LoadImg(headIconImg, headIcon);
	end
end

function HomePanel.ShowUserInfoPanel()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(UserInfoPanel, LoginData)
end

function HomePanel.ShowRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	networkMgr:SendMessage(ClientRequest.New(APIS.CONTACT_INFO_REQUEST, ""));
end

function HomePanel.CloseRoomCardPanel()
	soundMgr:playSoundByActionButton(1);
	roomCardPanel:SetActive(false);
end

-- function HomePanel.CheckEnterInRoom()
-- if (RoomData ~= nil and RoomData.roomId ~= nil) then
-- 	OpenPanel(GamePanel)
-- end
-- end

function HomePanel.Button_openWeb()
	soundMgr:playSoundByActionButton(1);
	Application.OpenURL("https://www.baidu.com/");
end

local Panel_message;

-- 消息显示隐藏

function HomePanel.Button_Mess_Open()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(MessagePanel)
end

-- 打开创建房间的对话框
function HomePanel.OpenCreateRoomDialog()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(CreateRoomPanel)
end

function HomePanel.Button_fankui()
	-- SoundCtrl.getInstance().playSoundByActionButton(1);
	-- Application.OpenURL("http://kefu.easemob.com/webim/im.html?tenantId=31750");

end

-- 打开进入房间的对话框

function HomePanel.OpenEnterRoomDialog()
	soundMgr:playSoundByActionButton(1);
	-- if (RoomData.roomId == nil or RoomData.roomId == 0) then
	OpenPanel(EnterRoomPanel)
	-- else
	-- TipsManager.SetTips("当前正在房间状态，无法加入新的房间");
	-- end
end

-- 打开设置对话框

function HomePanel.OpenGameSettingDialog()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(SettingPanel, 1)
end

-- 打开商店
function HomePanel.OpenShop()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(ShopPanel)
end

-- 打开回放
function HomePanel.OpenRecord()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(RecordPanel)
end
-- 打开游戏规则对话框

function HomePanel.OpenGameRuleDialog()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(RulePanel)
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


function HomePanel.CardChangeNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local oldCount = tonumber(cardCountText.text);
	local newCount = tonumber(message);
	cardCountText.text = message;
	LoginData.account.roomcard = newCount;
	if newCount > oldCount then
		contactInfoContent.text = "恭喜您获得" ..(newCount - oldCout) .. "张房卡"
	else
		contactInfoContent.text = "房卡" ..(newCount - oldCout);
	end
	roomCardPanel:SetActive(true);
end

function HomePanel.Share()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(SharePanel)
end


function HomePanel.GameBroadcastNotice()
	showNum = 1;
	if (not startFlag) then
		startFlag = true;
		this.SetNoticeTextMessage();
	end
end

function HomePanel.SetNoticeTextMessage()
	if (BroadcastScript.noticeList ~= nil and #BroadcastScript.noticeList > 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = BroadcastScript.noticeList[showNum];
		local time = string.len(noticeText.text) * 0.5 + 422 / 56;
		local tweener = noticeText.transform:DOLocalMove(Vector3.New(- string.len(noticeText.text) * 40, noticeText.transform.localPosition.y), time / 1.6, false);
		tweener:OnComplete(this.MoveCompleted)
		tweener:SetEase(Ease.Linear);
	end
end

function HomePanel.MoveCompleted()
	showNum = showNum + 1
	if (showNum == #BroadcastScript.noticeList) then
		showNum = 1
	end
	this.SetNoticeTextMessage();
end

-- function HomePanel.ExitApp()
-- soundMgr:playSoundByActionButton(1);
-- if (panelExitDialog == nil) then
-- 	this.loadPerfab("Assets/Project/Prefabs/Panel_Exit");
-- end
-- end
-------------------模板-------------------------
function HomePanel.OnOpen()
	this.InitUI();
	soundMgr:playBGM(1);
	-- this.CheckEnterInRoom();
end
-- 移除事件--
function HomePanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.CARD_CHANGE), this.CardChangeNotice)
	Event.RemoveListener(tostring(APIS.CONTACT_INFO_RESPONSE), this.ContactInfoResponse)
end

-- 增加事件--
function HomePanel.AddListener()
	Event.AddListener(tostring(APIS.CARD_CHANGE), this.CardChangeNotice)
	Event.AddListener(tostring(APIS.CONTACT_INFO_RESPONSE), this.ContactInfoResponse)
end
