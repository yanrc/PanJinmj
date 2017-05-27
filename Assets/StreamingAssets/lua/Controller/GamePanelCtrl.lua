require "View/GamePanel"
require "Logic/ButtonAction"
require "Data/DirectionEnum"
require "Data/PlayerItem"
require "Vos/GameReadyRequest"
require "Vos/OutRoomRequest"
local json = require "cjson"
GamePanelCtrl = { }
local this = GamePanelCtrl;
local gameObject;
local transform
local playerItems = { }
local timeFlag = false
local versionText
local btnActionScript
local dialog_fanhui
local showTimeNumber = 0
-- 牌数组，二维
-- 1 碰 和 杠 value == 1 碰  value == 2 杠
-- 0 牌 下标为牌 内容为该牌的数量
-- 初始化和重连会用到服务器传的值，且只用到手牌
local mineList
-- 手牌列表，二维，存的是gameObject
-- 0自己，1-右边。2-上边。3-左边
-- 自己会保存摸到的牌，其他人不保存
local handerCardList
-- 打在桌上的牌
local tableCardList
-- 吃碰杠list
local PengGangList_L
local PengGangList_R
local PengGangList_T
local PengGangList_B
--
local avatarList
local bankerIndex-- 庄家index
local curDirString
local LeavedRoundNumText
local isFirstOpen
local ruleText
-- 能否申请退出房间，初始为false，开始游戏置true
local canClickButtonFlag = false
local inviteFriendButton
local btnJieSan
local ExitRoomButton
local live1
local live2
local centerImage
local liujuEffectGame
local ruleText
local LeavedCastNumText
local MoPaiCardPoint
local SelfAndOtherPutoutCard
local useForGangOrPengOrChi
local passStr
local chiPaiPointList
local LeavedCardsNum -- 剩余牌数
local pickCardItem-- 自己摸的牌
local otherPickCardItem-- 别人摸的牌
local passType-- “过”操作字符串
local guiObj-- 翻开的鬼牌
local roomRemark-- 房间显示的规则
local ReadySelect = { } -- 游戏准备时的选择
local btnReadyGame
local timer = 0
local noticeGameObject-- 滚动消息
local dialog_fanhui_text
function GamePanelCtrl.Awake()
	logWarn("GamePanelCtrl.Awake--->>");
		PanelManager:CreatePanel('GamePanel', this.OnCreate);
		CtrlManager.GamePanelCtrl=this
end

function GamePanelCtrl.OnCreate(go)
	logWarn("Start lua--->>" .. go.name);
	gameObject = go;
	transform = go.transform
	this.lua = gameObject:GetComponent('LuaBehaviour');
	versionText = transform:FindChild('Text_version'):GetComponent('Text');
	btnActionScript = ButtonAction.New();
	dialog_fanhui = transform:FindChild('jiesan')
	LeavedRoundNumText = transform:FindChild('Leaved1/Text'):GetComponent('Text');
	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	inviteFriendButton = transform:FindChild('Button_invite_friend'):GetComponent('Button');
	btnJieSan = transform:FindChild('Button_jiesan').gameObject;
	ExitRoomButton = transform:FindChild('Button_other'):GetComponent('Button');
	live1 = transform:FindChild('Leaved'):GetComponent('Image');
	live2 = transform:FindChild('Leaved1'):GetComponent('Image');
	centerImage = transform:FindChild('table'):GetComponent('Image');
	liujuEffectGame = transform:FindChild('Liuju_B').gameObject
	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	LeavedCastNumText = transform:FindChild('Leaved/Text'):GetComponent('Text');
	guiObj = transform:FindChild('gui').gameObject
	roomRemark = transform:FindChild('Text'):GetComponent('Text')
	local players = transform:FindChild('playList')
	playerItems[1] = PlayerItem.New(players:FindChild('Player_B').gameObject)
	playerItems[2] = PlayerItem.New(players:FindChild('Player_R').gameObject)
	playerItems[3] = PlayerItem.New(players:FindChild('Player_T').gameObject)
	playerItems[4] = PlayerItem.New(players:FindChild('Player_L').gameObject)
	ReadySelect[1] = transform:FindChild('Panel/DuanMen'):GetComponent('Toggle')
	ReadySelect[2] = transform:FindChild('Panel/Gang'):GetComponent('Toggle')
	btnReadyGame = transform:FindChild('Panel/Button').gameObject
	Number = transform:FindChild('table/Number'):GetComponent('Text')
	noticeGameObject = transform:FindChild("Image_Notice_BG").gameObject
	dialog_fanhui_text = transform:FindChild('jiesan/Image_Bg/tip_text'):GetComponent('Text')
	this.lua:AddClick(dialog_fanhui:FindChild('Image_Bg/Button_Sure').gameObject,this.Tuichu)
	this.lua:AddClick(dialog_fanhui:FindChild('Image_Bg/Button_Cancle').gameObject,this.Quxiao)
	this.Start()
end
function GamePanelCtrl.Start()
	this.RandShowTime();
	timeFlag = true;
	soundMgr:playBGM(2);
	-- norHu = new NormalHuScript();
	-- naiziHu = new NaiziHuScript();
	-- gameTool = new GameToolScript();
	versionText.text = "V" .. Application.version;
	this.AddListener();
	this.InitPanel();
	this.InitArrayList();
	-- initPerson ();--初始化每个成员1000分
	GlobalData.isonLoginPage = false;
	if (GlobalData.reEnterRoomData ~= nil) then
		-- 短线重连进入房间
		GlobalData.loginResponseData.roomId = GlobalData.reEnterRoomData.roomId;
		this.ReEnterRoom();
	elseif (GlobalData.roomJoinResponseData ~= nil) then
		-- 进入他人房间
		this.JoinToRoom(GlobalData.roomJoinResponseData.playerList);
	else
		-- 创建房间
		this.CreateRoomAddAvatarVO(GlobalData.loginResponseData);
	end
	GlobalData.reEnterRoomData = nil;
	TipsManager.setTips("", 0);
	dialog_fanhui.gameObject:SetActive(false);
	this.InitbtnJieSan();
	UpdateBeat:Add(this.Update);
end

function GamePanelCtrl.RandShowTime()
	showTimeNumber = math.random(5000, 10000)
end

function GamePanelCtrl.InitPanel()
	this.Clean()
	btnActionScript.CleanBtnShow()
end

function GamePanelCtrl.InitArrayList()
	mineList = { }
	handerCardList = { }
	tableCardList = { }
	PengGangList_L = { };
	PengGangList_R = { };
	PengGangList_T = { };
	PengGangList_B = { };
end

local function CardSelect(obj)
	if GlobalData.isChiState then

		OnChipSelect(obj, true);

	else

		for k, v in pairs(handerCardList[1]) do
			if v == nil then
				handerCardList[1][k] = nil
			else
				handerCardList[1][k].transform.localPosition = Vector3.New(handerCardList[0][k].transform.localPosition.x, -292);
				-- 从右到左依次对齐
				handerCardList[1][k].BottomScript.selected = false;
			end
		end

		if (obj ~= nil) then

			obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -272);
			obj.bottomScript.selected = true;

		end
	end
end

local function StartGame(response)
	GlobalData.roomAvatarVoList = avatarList;
	-- GlobalData.surplusTimes -= 1;
	local sgvo = json.decode(response.message);
	bankerIndex = sgvo.bankerId;
	GlobalData.roomVo.guiPai = sgvo.gui;
	this.CleanGameplayUI();
	-- 开始游戏后不显示
	log("lua:GamePanelCtrl.StartGame");
	GlobalData.surplusTimes = GlobalData.surplusTimes - 1;
	curDirString = this.GetDirection(bankerIndex);
	LeavedRoundNumText.text = tostring(GlobalData.surplusTimes)
	-- 刷新剩余局数
	if (not isFirstOpen) then
		btnActionScript = ButtonAction.New();
		this.InitPanel();
		-- InitArrayList ();
		avatarList[bankerIndex].main = true;
	end
	GlobalData.finalGameEndVo = null;
	GlobalData.mainUuid = avatarList[bankerIndex].account.uuid;
	this.InitArrayList();
	curDirString = this.GetDirection(bankerIndex);
	playerItems[GetIndexByDir(curDirString)]:SetbankImgEnable(true);
	SetDirGameObjectAction();
	isFirstOpen = false;
	GlobalData.isOverByPlayer = false;
	mineList = sgvo.paiArray;
	-- 发牌
	UpateTimeReStart();
	DisplayTouzi(sgvo.touzi, sgvo.gui);
	-- 显示骰子
	-- this.DisplayGuiPai(sgvo.gui);
	this.SetAllPlayerReadImgVisbleToFalse();
	InitMyCardListAndOtherCard(13, 13, 13);
	ShowLeavedCardsNumForInit();
	if (curDirString == DirectionEnum.Bottom) then
		-- isSelfPickCard = true;
		GlobalData.isDrag = true;
	else
		-- isSelfPickCard = false;
		GlobalData.isDrag = false;
	end
	local ruleStr = "";
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomType == 5) then
		if (GlobalData.roomVo.pingHu == true) then
			ruleStr = ruleStr .. "穷胡\n";
		end
		if (GlobalData.roomVo.baoSanJia == true) then
			ruleStr = ruleStr .. "包三家\n";
		end
		if (GlobalData.roomVo.gui == 2) then
			ruleStr = ruleStr .. "带会儿\n";
		end
		if (GlobalData.roomVo.jue == true) then
			ruleStr = ruleStr .. "绝\n";
		end
		if (GlobalData.roomVo.jiaGang == true) then
			ruleStr = ruleStr .. "加钢\n";
		end
		if (GlobalData.roomVo.duanMen == true and sgvo.duanMen) then
			ruleStr = ruleStr .. "买断门\n";
		end
		if (GlobalData.roomVo.jihu == true) then
			ruleStr = ruleStr .. "鸡胡\n";
		end
		if (GlobalData.roomVo.qingYiSe == true) then
			ruleStr = ruleStr .. "清一色\n";
		end
		ruleText.text = ruleStr;
	end
	for i = 1, #playerItems do
		if (sgvo.jiaGang[i]) then
			playerItems[GetIndexByDir(this.GetDirection(i))].jiaGang.text = "加钢"
		else
			playerItems[GetIndexByDir(this.GetDirection(i))].jiaGang.text = ""
		end
	end

	local jiaGang = GameToolScript.boolArrToInt(sgvo.jiaGang);
	PlayerPrefs.SetInt("jiaGang", jiaGang);
	log("lua:jiaGang=" .. tostring(jiaGang));
end

function GamePanelCtrl.CleanGameplayUI()
	canClickButtonFlag = true;
	-- weipaiImg.transform.gameObject.SetActive(false);
	inviteFriendButton.transform.gameObject:SetActive(false);
	btnJieSan:SetActive(false);
	ExitRoomButton.transform.gameObject:SetActive(false);
	live1.transform.gameObject:SetActive(true);
	live2.transform.gameObject:SetActive(true);
	-- tab.transform.gameObject.SetActive(true);
	centerImage.transform.gameObject:SetActive(true);
	liujuEffectGame:SetActive(false);
	ruleText.text = "";
end

local function ShowLeavedCardsNumForInit()
	local roomCreateVo = GlobalData.roomVo;
	local hong = roomCreateVo.hong;
	local RoomType = roomCreateVo.roomType;
	if (RoomType == 1) then
		-- 转转麻将
		LeavedCardsNum = 108;
		if (hong) then
			LeavedCardsNum = 112;
		end
	elseif (RoomType == 2) then
		-- 划水麻将
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 3) then
		LeavedCardsNum = 108;
	elseif (RoomType == 4) then
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 5) then
		-- 盘锦麻将
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 6) then
		-- 无锡麻将
		LeavedCardsNum = 116;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 144;
		end
		LeavedCardsNum = LeavedCardsNum - 53;
		LeavedCastNumText.text = tostring(LeavedCardsNum);
	end
end

local function CardsNumChange()
	LeavedCardsNum = LeavedCardsNum - 1;
	if (LeavedCardsNum < 0) then
		LeavedCardsNum = 0;
	end
	LeavedCastNumText.text = tostring(LeavedCardsNum);
end
-- 别人摸牌通知
local function OtherPickCard(response)
	UpateTimeReStart();
	local json = json.decode(response.message);
	-- 下一个摸牌人的索引
	local avatarIndex = json["avatarIndex"]+1;
	log("GamePanelCtrl.OtherPickCard:otherPickCard avatarIndex = " .. tostring(avatarIndex));
	OtherPickCardAndCreate(avatarIndex);
	SetDirGameObjectAction();
	CardsNumChange();
	GlobalData.isChiState = false;
end
local function OtherPickCardAndCreate(avatarIndex)
	local myIndex = this.GetMyIndexFromList();
	local seatIndex =1+ avatarIndex - myIndex;
	if (seatIndex < 1) then
		seatIndex = 4 + seatIndex;
	end
	curDirString = playerItems[seatIndex].dir;
	OtherMoPaiCreateGameObject(curDirString);
end

local function OtherMoPaiCreateGameObject()
	local tempVector3 = Vector3.zero;
	local switch = {
		[DirectionEnum.Top] = Vector3.New(-273,0),
		[DirectionEnum.Left] = Vector3.New(0,- 173),
		[DirectionEnum.Right] = Vector3.New(0,183)
	}
	tempVector3 = switch[dir]
	local path = "Assets/Project/Prefabs/card/Bottom_" + dir;
	-- 实例化当前摸的牌
	otherPickCardItem = this.CreateGameObjectAndReturn(path, parentList[GetIndexByDir(dir)], tempVector3);
	otherPickCardItem.transform.localScale = Vector3.one;
end

local function PickCard(response)
	UpateTimeReStart();
	local cardvo = json.decode(response.message);
	MoPaiCardPoint = cardvo.cardPoint;
	log("GamePanelCtrl:PickCard:摸牌" .. tostring(MoPaiCardPoint));
	SelfAndOtherPutoutCard = MoPaiCardPoint;
	useForGangOrPengOrChi = cardvo.cardPoint;
	PutCardIntoMineList(MoPaiCardPoint);
	MoPai();
	curDirString = DirectionEnum.Bottom;
	SetDirGameObjectAction();
	CardsNumChange();
	GlobalData.isDrag = true;
end
-- 胡，杠，碰，吃，pass按钮显示.
local function ActionBtnShow(response)
	GlobalData.isDrag = false;
	GlobalData.isChiState = false;
	log("GamePanelCtrl ActionBtnShow:msg =" .. tostring(response.message));
	local strs = string.split(response.message, ',')
	if (curDirString == DirectionEnum.Bottom) then
		passType = "selfPickCard";
	else
		passType = "otherPickCard";
	end
	btnActionScript.ShowBtn(5);
	for i = 1, #strs do
		if string.match(strs[i], "hu") then
			btnActionScript.ShowBtn(1);
			passStr = passStr .. "hu_"
		end
		if string.match(strs[i], "qianghu") then
			SelfAndOtherPutoutCard = string.split(str[i], ':')[2]
			btnActionScript.ShowBtn(1);
			isQiangHu = true;
			passStr = passStr .. "qianghu_"
		end
		if string.match(strs[i], "peng") then
			btnActionScript.ShowBtn(3);
			putOutCardPoint = string.split(str[i], ':')[3]
			passStr = passStr .. "peng_"
		end
		if string.match(strs[i], "gang") then
			btnActionScript.ShowBtn(2);
			gangPaiList = string.split(str[i], ':');
			table.remove(gangPaiList, 1)
			passStr = passStr .. "gang_"
		end
		if string.match(strs[i], "chi") then
			-- 格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			-- eg:"chi:1:2|1_2_3|2_3_4"
			GlobalData.isChiState = true;
			local strChi = string.split(str[i], '|');
			putOutCardPoint = string.split(str[1], ':')[3];
			chiPaiPointList = { };
			for m = 2, #strChi do
				local strChiList = string.split(str[i], '_');
				local cpoint = { };
				cpoint.putCardPoint = putOutCardPoint;
				for n = 1, #strChiList do
					if (strChiList[n] == putOutCardPoint) then
						table.remove(strChiList, n)
					end
					cpoint.oneCardPoint = strChiList[1]
					cpoint.twoCardPoint = strChiList[2]
					chiPaiPointList.Add(cpoint);
				end
				btnActionScript.ShowBtn(4);
				passStr = passStr .. "chi_"
			end
		end
	end
end

-- 手牌排序，鬼牌移到最前
function GamePanelCtrl.SortMyCardList()
	local guipaiList = { };
	for k, v in pairs(handerCardList[1]) do
		if (v ~= nil) then
			if (v.BottomScript.GetPoint() == GlobalData.roomVo.guiPai) then
				guipaiList.Add(v);
				-- 鬼牌
				handerCardList[1][k] = nil
			end
		end
	end
	table.sort(handerCardList[1])
	for k, v in pairs(guipaiList) do
		table.insert(handerCardList[1], 0, v)
	end
end
-- 初始化手牌
local function InitMyCardListAndOtherCard(topCount, leftCount, rightCount)
	for i = 1, #mineList[1].Count do
		-- 我的牌13张
		if (mineList[1][i] > 0) then
			for j = 1, #mineList[1][i] do
				local gob = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function()
					if (gob ~= nil) then
						gob.transform.SetParent(parentList[0]);
						gob.transform.localScale = Vector3.New(1.1, 1.1, 1);
						gob.bottomScript = BottomScript.New();
						gob.bottomScript.onSendMessage = CardChange;
						gob.bottomScript.reSetPoisiton = CardSelect;
						gob.bottomScript.setPoint(i, GlobalData.roomVo.guiPai);
						SetPosition(false);
						handerCardList[1].Add(gob);
					else
						log("GamePanelCtrl InitMyCardListAndOtherCard:" .. tostring(i) .. "is null");
						-- 游戏对象为空
					end
				end )
			end
			this.SortMyCardList();
		end
	end
	this.InitOtherCardList(DirectionEnum.Left, leftCount);
	this.InitOtherCardList(DirectionEnum.Right, rightCount);
	this.InitOtherCardList(DirectionEnum.Top, topCount);
	if (bankerIndex == this.GetMyIndexFromList()) then
		this.SetPosition(true);
		-- 设置位置
		-- checkHuPai();
	else
		SetPosition(false);
		OtherPickCardAndCreate(bankerIndex);
	end
end
function GamePanelCtrl.SetAllPlayerReadImgVisbleToFalse()
	for _, v in pairs(playerItems) do
		v.readyImg.enabled = false;
	end
end
local function SetAllPlayerHuImgVisbleToFalse()
	for _, v in pairs(playerItems) do
		v:SetHuFlagHidde(false);
	end
end

local function GetIndexByDir(dir)
	local result = 0;
	local switch =
	{
		[DirectionEnum.Top] = 3,
		[DirectionEnum.Left] = 4,
		[DirectionEnum.Right] = 2,
		[DirectionEnum.Bottom] = 1
	}
	result = switch[dir]
	return result;
end

-- 初始化其他人的手牌
function GamePanelCtrl.InitOtherCardList(initDiretion, count)
	for i = 1, count do
		local temp = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function()
			-- 实例化当前牌
			if (temp ~= nil) then
				-- 有可能没牌了
				temp.transform:SetParent(parentList[GetIndexByDir(initDiretion)]);
				temp.transform.localScale = Vector3.one;
				local switch = {
					[DirectionEnum.Top] = function()
						temp.transform.localPosition = Vector3.New(-204 + 38 * i, 0);
						handerCardList[3].Add(temp);
						temp.transform.localScale = Vector3.one;
						-- 原大小
					end,
					[DirectionEnum.Left] = function()
						temp.transform.localPosition = Vector3.New(0, -105 + i * 30);
						temp.transform.SetSiblingIndex(0);
						handerCardList[4].Add(temp);
					end,
					[DirectionEnum.Right] = function()
						temp.transform.localPosition = Vector3.New(0, 119 - i * 30);
						handerCardList[2].Add(temp);
					end
				}
				switch[initDiretion]();
			end
		end )
	end
end

-- 摸牌
local function MoPai()
	pickCardItem = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function()
		log("GamePanelCtrl MoPai:" .. tostring(MoPaiCardPoint));
		if (pickCardItem ~= nil) then
			-- 有可能没牌了
			pickCardItem.name = "pickCardItem";
			pickCardItem.transform:SetParent(parentList[1]);
			-- 父节点
			pickCardItem.transform.localScale = Vector3.New(1.1, 1.1, 1);
			-- 原大小
			pickCardItem.transform.localPosition = Vector3.New(580, -292);
			-- 位置
			pickCardItem.bottomScript = BottomScript.New()
			pickCardItem.bottomScript.onSendMessage = cardChange;
			pickCardItem.bottomScript.reSetPoisiton = cardSelect;
			pickCardItem.bottomScript:SetPoint(MoPaiCardPoint, GlobalData.roomVo.guiPai);
			InsertCardIntoList(pickCardItem);
		end
	end )
end
function PutCardIntoMineList(cardPoint)
	if (mineList[1][cardPoint] < 4) then
		mineList[1][cardPoint] = mineList[1][cardPoint] + 1;
	end
end
function PushOutFromMineList(cardPoint)
	if (mineList[1][cardPoint] > 0) then
		mineList[1][cardPoint] = mineList[1][cardPoint] -1;
	end
end
-- 接收到其它人的出牌通知
local function OtherPutOutCard(response)
	local json = json.decode(response.message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex = json["curAvatarIndex"];
	putOutCardPointAvarIndex = GetIndexByDir(this.GetDirection(curAvatarIndex));
	log("otherPickCard avatarIndex = " .. tostring(curAvatarIndex));
	useForGangOrPengOrChi = cardPoint;
	if (otherPickCardItem ~= nil) then
		local dirIndex = GetIndexByDir(this.GetDirection(curAvatarIndex));
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, otherPickCardItem.transform.position);
		Destroy(otherPickCardItem);
		otherPickCardItem = nil;
	else
		local dirIndex = GetIndexByDir(this.GetDirection(curAvatarIndex));
		local obj = handerCardList[dirIndex][1];
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, obj.transform.position);
		table.remove(handerCardList[dirIndex], 1)
		Destroy(obj)
	end
	-- createPutOutCardAndPlayAction(cardPoint, curAvatarIndex);
	GlobalData.isChiState = false;
end
-- 创建打来的的牌对象，并且开始播放动画
local function CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, position)
	soundMgr:playSound(cardPoint, avatarList[curAvatarIndex].account.sex);
	local tempVector3 = Vector3.zero;
	local destination = Vector3.zero;
	local path = "";
	local Dir = this.GetDirection(curAvatarIndex);
	local switch =
	{
		[DirectionEnum.Bottom] = function()
			path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
			tempVector3 = Vector3.New(0, -100);
			destination = Vector3.New(-261 + tableCardList[0].Count % 14 * 37,(int)(tableCardList[0].Count / 14) * 67);
		end,
		[DirectionEnum.Right] = function()
			path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
			tempVector3 = Vector3.New(420, 0);
			destination = Vector3.New((- tableCardList[1].Count / 13 * 54), -180 + tableCardList[1].Count % 13 * 28);
		end,
		[DirectionEnum.Top] = function()
			path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
			tempVector3 = Vector3.New(0, 130);
			destination = Vector3.New(289 - tableCardList[2].Count % 14 * 37, -(int)(tableCardList[2].Count / 14) * 67);
		end,
		[DirectionEnum.Left] = function()
			path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
			tempVector3 = Vector3.New(-370, 0);
			destination = Vector3.New(tableCardList[3].Count / 13 * 54, 152 - tableCardList[3].Count % 13 * 28);
		end
	}
	switch[Dir]()
	local tempGameObject = this.CreateGameObjectAndReturn(path, parentList[0], tempVector3);
	tempGameObject.transform.position = position;
	tempGameObject.name = "putOutCard";
	tempGameObject.transform.localScale = Vector3.one;
	tempGameObject.transform.parent = outparentList[GetIndexByDir(Dir)];
	if (Dir == DirectionEnum.Right or Dir == DirectionEnum.Left) then
		tempGameObject.TopAndBottomCardScript = TopAndBottomCardScript.New()
		tempGameObject.TopAndBottomCardScript.SetLefAndRightPoint(cardPoint);
		if (Dir == DirectionEnum.Right) then
			tempGameObject.transform:SetAsFirstSibling();
		end
	else
		tempGameObject.TopAndBottomCardScript = TopAndBottomCardScript.New()
		tempGameObject.TopAndBottomCardScript.SetPoint(cardPoint);
	end
	putOutCardPoint = cardPoint;
	SelfAndOtherPutoutCard = cardPoint;
	putOutCard = tempGameObject;
	local tweener = tempGameObject.transform:DOLocalMove(destination, 1).OnComplete(
	function()
		DestroyPutOutCard(cardPoint, Dir);
		if (putOutCard ~= nil) then
			Destroy(putOutCard, 1);
		end
	end );
	if (Dir ~= DirectionEnum.Bottom) then
		tweener:SetEase(Ease.OutExpo);
	else
		tweener:SetEase(Ease.OutExpo);
	end
end

-- 根据一个人在数组里的索引，得到这个人所在的方位，L-左，T-上,R-右，B-下（自己）
local function GetDirection()
	local result = DirectionEnum.Bottom;
	local myselfIndex = this.GetMyIndexFromList();
	if (myselfIndex == avatarIndex) then
		-- log ("getDirection == B");
		return result;
	end
	-- 从自己开始计算，下一位的索引
	for i = 1, 4 do
		myselfIndex = myselfIndex + 1;
		if (myselfIndex >= 5) then
			myselfIndex = 1;
		end
		if (myselfIndex == avatarIndex) then
			if (i == 1) then
				-- log ("getDirection == R");
				return DirectionEnum.Right;
			elseif (i == 2) then
				-- log ("getDirection == T");
				return DirectionEnum.Top;
			else
				-- log ("getDirection == L");
				return DirectionEnum.Left;
			end
		end
		return result;
	end
end


-- 设置红色箭头的显示方向
function SetDirGameObjectAction()
	-- 设置方向
	-- UpateTimeReStart();
	for i = 1, #dirGameList do
		dirGameList[i]:SetActive(false);
	end
	dirGameList[GetIndexByDir(curDirString)]:SetActive(true);
end

local function ThrowBottom(index, Dir)
	local temp = null;
	local path = "";
	local poisVector3 = Vector3.one;
	log("put out huaPaiPoint" .. tostring(index) .. "---ThrowBottom---");
	if (Dir == DirectionEnum.Bottom) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(-261 + tableCardList[0].Count % 14 * 37,(int)(tableCardList[0].Count / 14) * 67);
		GlobalData.isDrag = false;
	elseif (Dir == DirectionEnum.Right) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		poisVector3 = Vector3.New((- tableCardList[1].Count / 13 * 54), -180 + tableCardList[1].Count % 13 * 28);
	elseif (Dir == DirectionEnum.Top) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(289 - tableCardList[2].Count % 14 * 37, -(int)(tableCardList[2].Count / 14) * 67);
	elseif (Dir == DirectionEnum.Left) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		poisVector3 = Vector3.New(tableCardList[3].Count / 13 * 54, 152 - tableCardList[3].Count % 13 * 28);
		-- parenTransform = leftOutParent;
	end
	temp = this.CreateGameObjectAndReturn(path, outparentList[getIndexByDir(Dir)], poisVector3);
	temp.transform.localScale = Vector3.one;
	temp.TopAndBottomCardScript = TopAndBottomCardScript.New()
	if (Dir == DirectionEnum.Right or Dir == DirectionEnum.Left) then
		temp.TopAndBottomCardScript:setLefAndRightPoint(index);
	else
		temp.TopAndBottomCardScript:setPoint(index);
	end
	cardOnTable = temp;
	-- temp.transform.SetAsLastSibling();
	table.insert(tableCardList[GetIndexByDir(Dir)], temp)
	if (Dir == DirectionEnum.Right) then
		temp.transform.SetSiblingIndex(0);
	end
	-- 丢牌上?
	-- 顶针下?
	SetPointGameObject(temp);
end


local function PengCard(response)
	UpateTimeReStart();
	local cardVo = json.decode(response.message);
	otherPengCard = cardVo.cardPoint;
	curDirString = this.GetDirection(cardVo.avatarId);
	print("Current Diretion==========>" + curDirString);
	SetDirGameObjectAction();
	effectType = "peng";
	PengGangHuEffectCtrl();
	soundMgr:playSoundByAction("peng", avatarList[cardVo.avatarId].account.sex);
	-- 销毁桌上被碰的牌
	if (cardOnTable ~= nil) then
		ReSetOutOnTabelCardPosition(cardOnTable);
		Destroy(cardOnTable);
	end
	if (curDirString == DirectionEnum.Bottom) then
		-- 自己碰牌
		putCardIntoMineList(putOutCardPoint)
		-- 给mineList[1]增加加一张牌
		mineList[2][putOutCardPoint] = 2;
		-- 保存碰掉的2张牌
		-- 给handerCardList[1]移除2张牌
		local removeCount = 0;
		for k, v in pairs(handerCardList[1]) do
			if (v.bottomScript.GetPoint() == putOutCardPoint) then
				v = nil
				removeCount = removeCount + 1
				if (removeCount == 2) then
					break
				end
			end
		end
		this.SetPosition(true);
		BottomPeng();
	else
		-- 其他人碰牌
		local tempCardList = handerCardList[getIndexByDir(curDirString)];
		local path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_" + curDirString;
		if (tempCardList ~= nil) then
			-- 直接减少前面2张牌
			for i = 1, 2 do
				Destroy(tempCardList[1]);
				table.remove(tempCardList, 1)
			end

			-- 碰完后把第一张牌拿到最右边，重新排序
			otherPickCardItem = tempCardList[0];
			GameToolScript.setOtherCardObjPosition(tempCardList, curDirString, 1);
			-- 其他人handerCardList不保存最边上的牌
			table.remove(tempCardList, 1)
		end
		local tempvector3 = Vector3.zero;
		local tempList = { }
		-- 显示3张牌
		local switch = {
			[DirectionEnum.Right] = function()
				for i = 1, 3 do
					local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:setLefAndRightPoint(cardVo.cardPoint);
						tempvector3 = Vector3.New(0, -122 + PengGangList_R.Count * 95 + i * 26);
						obj.transform.parent = pengGangParenTransformR.transform;
						obj.transform:SetSiblingIndex(0);
						obj.transform.localScale = Vector3.one;
						obj.transform.localPosition = tempvector3;
						table.insert(tempList, obj)
					end )
				end
			end,
			[DirectionEnum.Top] = function()
				for i = 1, 3 do
					local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:setPoint(cardVo.cardPoint);
						tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + i * 37, 0, 0);
						obj.transform.parent = pengGangParenTransformT.transform;
						obj.transform.localScale = Vector3.one;
						obj.transform.localPosition = tempvector3;
						table.insert(tempList, obj)
					end )
				end
			end,
			[DirectionEnum.Left] = function()
				for i = 1, 3 do
					local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:setLefAndRightPoint(cardVo.cardPoint);
						tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - i * 26, 0);
						obj.transform.parent = pengGangParenTransformL.transform;
						obj.transform.localScale = Vector3.one;
						obj.transform.localPosition = tempvector3;
						table.insert(tempList, obj)
					end )
				end
			end
		}
		switch[curDirString]();
		AddListToPengGangList(curDirString, tempList);
	end
	GlobalData.isChiState = false;
end


function ChiCard(response)
	UpateTimeReStart();
	print("ChiCard:" .. response.message)
	local cardVo = json.decode(response.message);
	otherPengCard = cardVo.cardPoint;
	curDir = this.GetDirection(cardVo.avatarId);
	SetDirGameObjectAction();
	effectType = "chi";
	PengGangHuEffectCtrl();
	soundMgr:playSoundByAction("chi", avatarList[cardVo.avatarId].account.sex);
	if (cardOnTable ~= nil) then
		ReSetOutOnTabelCardPosition(cardOnTable);
		Destroy(cardOnTable);
	end
	if (curDir == DirectionEnum.Bottom) then
		-- 自己吃牌
		mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] + 1;
		-- mineList[3][putOutCardPoint] = 1;
		-- 第一个吃牌
		for k, v in pairs(handerCardList[1]) do
			if (v.bottomScript.GetPoint() == cardVo.onePoint) then
				v = nil
				break
			end
		end
		-- 第二个吃牌
		for k, v in pairs(handerCardList[1]) do
			if (v.bottomScript.GetPoint() == cardVo.twoPoint) then
				v = nil
				break
			end
		end
		this.SetPosition(true);
		BottomChi(otherPengCard, cardVo.onePoint, cardVo.twoPoint)
	else
		-- 其他人吃牌
		local tempCardList = handerCardList[getIndexByDir(curDir)];
		local path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_" + curDir;
		if (tempCardList ~= nil) then
			for i = 1, 2 do
				destroy(tempCardList[1]);
				table.remove(tempCardList, 1)
			end
			otherPickCardItem = tempCardList[1];
			GameToolScript.setOtherCardObjPosition(tempCardList, curDir, 1);
			table.remove(tempCardList, 1)
		end
		local tempvector3 = Vector3.zero
		local tempList = { }
		for i = 1, 3 do
			local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New();
				if (i == 0) then
					obj.TopAndBottomCardScript:Init(cardVo.cardPoint, curDir, GlobalData.roomVo.guiPai == cardVo.cardPoint);
				elseif (i == 1) then
					obj.TopAndBottomCardScript:Init(cardVo.onePoint, curDir, GlobalData.roomVo.guiPai == cardVo.onePoint);
				elseif (i == 2) then
					obj.TopAndBottomCardScript:Init(cardVo.twoPoint, curDir, GlobalData.roomVo.guiPai == cardVo.twoPoint);
				end
				local switch =
				{
					[DirectionEnum.Right] = function()
						tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + i * 26);
						obj.transform.parent = pengGangParenTransformR.transform;
						obj.transform:SetSiblingIndex(0);
					end,
					[DirectionEnum.Top] = function()
						tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0, 0);
						obj.transform.parent = pengGangParenTransformT.transform;
					end,
					[DirectionEnum.Left] = function()
						tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - i * 26, 0);
						obj.transform.parent = pengGangParenTransformL.transform;
					end
				}
				switch[curDir]()
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList, obj)
			end )
		end
		AddListToPengGangList(curDir, tempList);
	end
end

function BottomPeng()
	local templist = { }
	for i = 1, 3 do
		local obj = resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function()
			obj.transform.parent = pengGangParenTransformB.transform
			obj.transform.localPosition = Vector3.New(-370 + #PengGangList_B * 190 + i * 60, 0);
			obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
			obj.TopAndBottomCardScript:Init(putOutCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == putOutCardPoint);
			obj.transform.localScale = Vector3.one;
			table.insert(templist, obj)
		end )
	end
	table.insert(PengGangList_B, templist)
	GlobalData.isDrag = true;
end


function BottomChi(putCardPoint, oneCardPoint, twoCardPoint)
	local templist = { };
	for i = 1, 3 do
		local obj = resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function()
			obj.transform.parent = pengGangParenTransformB.transform
			obj.transform.localPosition = Vector3.New(-370 + #PengGangCardList * 190 + j * 60, 0);
			obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
			if (j == 0) then
				obj.TopAndBottomCardScript:Init(putCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == putCardPoint);
			elseif (j == 1) then
				obj.TopAndBottomCardScript:Init(oneCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == oneCardPoint);
			elseif (j == 2) then
				obj.TopAndBottomCardScript:Init(twoCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == twoCardPoint);
			end
			obj.transform.localScale = Vector3.one;
			table.insert(templist, obj)
		end )
	end
	table.insert(PengGangCardList, tempList)
	GlobalData.isDrag = true;
end

function PengGangHuEffectCtrl()
	if (effectType == "peng") then
		pengEffectGame:SetActive(true)
	elseif (effectType == "gang") then
		gangEffectGame:SetActive(true)
	elseif (effectType == "hu") then
		huEffectGame:SetActive(true)
	elseif (effectType == "liuju") then
		liujuEffectGame:SetActive(true)
	elseif (effectType == "chi") then
		chiEffectGame:SetActive(true)
	end
	coroutine.start(
	function()
		coroutine.wait(1)
		pengEffectGame:SetActive(false);
		gangEffectGame:SetActive(false);
		huEffectGame:SetActive(false);
		chiEffectGame:SetActive(false);
	end
	)
end


local function OtherGang(response)
	local gangNotice = json.decode(response.message);
	otherGangCard = gangNotice.cardPoint;
	otherGangType = gangNotice.type;
	local path = "";
	-- 杠牌下面的三张
	local path2 = "";
	-- 杠牌上面的一张
	local tempvector3 = Vector3.zero;
	curDir = this.GetDirection(gangNotice.avatarId);
	effectType = "gang";
	PengGangHuEffectCtrl();
	SetDirGameObjectAction();
	soundMgr:playSoundByAction("gang", avatarList[gangNotice.avatarId].account.sex)
	local tempCardList
	-- 确定牌背景（明杠，暗杠）
	local switch =
	{
		[DirectionEnum.Right] = function()
			tempCardList = handerCardList[2];
			path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_R";
			path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_L&R";
		end,
		[DirectionEnum.Top] = function()
			tempCardList = handerCardList[3];
			path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_T";
			path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_T";
		end,
		[DirectionEnum.Top] = function()
			tempCardList = handerCardList[4];
			path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_L";
			path2 = "Assets/Project/Prefabs/PengGangCard/GangBack_L&R";
		end
	}
	local tempList = { }
	-- 明杠和暗杠
	if (GetPaiInpeng(otherGangCard, curDir) == -1) then
		-- 删除玩家手牌，当玩家碰牌牌组里面的有碰牌时，不用删除手牌
		for i = 1, 3 do
			local temp = tempCardList[1];
			table.remove(tempCardList, 1)
			destroy(temp);
		end
		this.SetPosition(false)
		if (tempCardList ~= nil) then
			GameToolScript.setOtherCardObjPosition(tempCardList, curDir, 2);
		end
		-- 明杠
		if (otherGangType == 0) then
			if (cardOnTable ~= nil) then
				ReSetOutOnTabelCardPosition(cardOnTable);
				destroy(cardOnTable);
			end
			for i = 1, 4 do
				-- 实例化其他人杠牌
				local obj = resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function()
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(otherGangCard, curDir, GlobalData.roomVo.guiPai == otherGangCard);
					local switch =
					{
						[DirectionEnum.Right] = function()
							obj.transform.parent = pengGangParenTransformR.transform;
							if (i == 3) then
								tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + 33);
							else
								tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28);
								obj.transform:SetSiblingIndex(0);
							end
						end,
						[DirectionEnum.Top] = function()
							obj.transform.parent = pengGangParenTransformT.transform;
							if (i == 3) then
								tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + 37, 20);
							else
								tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0);
							end
						end,
						[DirectionEnum.Left] = function()
							obj.transform.parent = pengGangParenTransformL.transform;
							if (i == 3) then
								tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - 18);
							else
								tempvector3 = Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28);
							end
						end
					}
					switch[curDir]()
					obj.transform.localScale = Vector3.one;
					obj.transform.localPosition = tempvector3;
					table.insert(tempList, obj)
				end )
			end
			-- 暗杠
		elseif (otherGangType == 1) then
			destroy(otherPickCardItem);
			local common = function()
				local switch =
				{
					[DirectionEnum.Right] = function()
						obj.transform.parent = pengGangParenTransformR.transform;
						if (j == 3) then
							tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + 33, 0);
						else
							tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + j * 28, 0);
						end
					end,
					[DirectionEnum.Top] = function()
						obj.transform.parent = pengGangParenTransformT.transform;
						if (j == 3) then
							tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + 37, 10);
						else
							tempvector3 = Vector3.New(251 - PengGangList_T.Count * 120 + j * 37, 0);
						end
					end,
					[DirectionEnum.Left] = function()
						obj.transform.parent = pengGangParenTransformL.transform;
						if (j == 3) then
							tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - 18, 0);
						else
							tempvector3 = new Vector3(0, 122 - PengGangList_L.Count * 95 - j * 28, 0);
						end
					end
				}
				switch[curDir]()
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = tempvector3;
				table.insert(tempList, obj)
			end
			for i = 1, 4 do
				local obj;
				if (j == 3) then
					obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:Init(otherGangCard, curDir, GlobalData.roomVo.guiPai == otherGangCard);
						common()
					end )
				else
					obj = resMgr:LoadPrefab('prefabs', { path2 + ".prefab" }, function()
						common()
					end )
				end

			end
		end
		AddListToPengGangList(curDir, tempList);
		-- 补杠
	else
		local gangIndex = GetPaiInpeng(otherGangCard, curDir);
		if (otherPickCardItem ~= nil) then
			destroy(otherPickCardItem);
		end
		local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
			obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
			obj.TopAndBottomCardScript:Init(otherGangCard, curDir, GlobalData.roomVo.guiPai == otherGangCard);
			local switch =
			{
				[DirectionEnum.Top] = function()
					obj.transform.parent = pengGangParenTransformT.transform;
					tempvector3 = Vector3.New(251 - gangIndex * 120 + 37, 20);
					table.insert(PengGangList_T[gangIndex], obj)
				end,
				[DirectionEnum.Left] = function()
					obj.transform.parent = pengGangParenTransformL.transform;
					tempvector3 = Vector3.New(0, 122 - gangIndex * 95 - 26, 0);
					table.insert(PengGangList_L[gangIndex], obj)
				end,
				[DirectionEnum.Right] = function()
					obj.transform.parent = pengGangParenTransformR.transform;
					tempvector3 = Vector3.New(0, -122 + gangIndex * 95 + 26);
					table.insert(PengGangList_R[gangIndex], obj)
				end
			}
			switch[curDir]()
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = tempvector3;
		end )
	end
	GlobalData.isChiState = false;
end

function AddListToPengGangList(dir, tempList)
	local switch =
	{
		[DirectionEnum.Right] = function()
			table.insert(PengGangList_R, tempList)
		end,
		[DirectionEnum.Top] = function()
			table.insert(PengGangList_T, tempList)
		end,
		[DirectionEnum.Left] = function()
			table.insert(PengGangList_L, tempList)
		end
	}
	switch[dir]()
end


--[[ 判断碰牌的牌组里面是否包含某个牌，用于判断是否实例化一张牌还是三张牌
cardpoint：牌点
direction：方向
返回-1  代表没有牌
其余牌在list的位置--]]

function GetPaiInpeng(cardPoint, direction)
	local jugeList = { }
	local switch =
	{
		[DirectionEnum.Bottom] = function()
			-- 自己
			jugeList = PengGangCardList;
		end,
		[DirectionEnum.Right] = function()
			jugeList = PengGangList_R;
		end,
		[DirectionEnum.Left] = function()
			jugeList = PengGangList_L;
		end,
		[DirectionEnum.Top] = function()
			jugeList = PengGangList_T;
		end
	}
	switch[direction]()
	if (jugeList == nil or #jugeList == 0) then
		return -1;
	end
	-- 循环遍历比对点数
	for i = 1, #jugeList do
		local index
		local ret, errMessage = pcall(
		function()
			if (jugeList[i][1].TopAndBottomCardScript.CardPoint == cardPoint) then
				index = i
			end
		end )
		if not ret then
			error("error:" .. errMessage)
			index = -1
			return
		end
		if (index > -1) then
			return index
		end
	end
	return -1;
end
-- 设置顶针
local function SetPointGameObject(parent)
	if (parent ~= nil) then
		local common = function()
			Pointertemp.transform:SetParent(parent.transform);
			Pointertemp.transform.localScale = Vector3.one;
			Pointertemp.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		end
		if (Pointertemp == nil) then
			Pointertemp = resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Pointer.prefab" }, function()
				common()
			end )
		else
			common()
		end
	end
end

local function OnChipSelect(obj, isSelected)
	if (isSelect) then
		-- 选择此牌
		if (oneChiCardPoint ~= -1 and twoChiCardPoint ~= -1) then
			return
		end
		if (oneChiCardPoint == -1) then
			oneChiCardPoint = obj.bottomScript.CardPoint;
		else
			twoChiCardPoint = obj.bottomScript.CardPoint;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -272);
		obj.bottomScript.selected = true;
	else
		-- 取消选择
		if (oneChiCardPoint == obj.bottomScript.CardPoint) then
			oneChiCardPoint = -1;
		elseif (twoChiCardPoint == obj.bottomScript.CardPoint) then
			twoChiCardPoint = -1;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -292);
		obj.bottomScript.selected = false;
	end
end

-- 自己打出的牌
local function CardChange(obj)
	if (GlobalData.isChiState) then
		onChipSelect(obj, false);
	else
		local handCardCount = #handerCardList[1]
		if (handCardCount % 3 == 2) then
			-- 这时候才能出牌
			obj.bottomScript.onSendMessage = nil;
			obj.bottomScript.reSetPoisiton = nil;
			local putOutCardPointTemp = obj.bottomScript.CardPoint;
			pushOutFromMineList(putOutCardPointTemp);
			-- 将打出牌移除
			table.remove(handerCardList[1], obj)
			destroy(obj);
			this.SetPosition(false);
			CreatePutOutCardAndPlayAction(putOutCardPointTemp, this.GetMyIndexFromList(), obj.transform.position);
			-- 出牌动画
			local cardvo = { }
			cardvo.cardPoint = putOutCardPointTemp;
			putOutCardPointAvarIndex = getIndexByDir(this.GetDirection(this.GetMyIndexFromList()));
			CustomSocket.getInstance():sendMsg(PutOutCardRequest.New(json.encode(cardvo)));
			GlobalData.isChiState = false;
			GlobalData.isDrag = false;
		end
	end
end

function InsertCardIntoList(item)
	-- 插入牌的方法
	if (item ~= nil) then
		local curCardPoint = item.bottomScript.CardPoint;
		-- 得到当前牌指针
		if (curCardPoint == GlobalData.roomVo.guiPai) then
			table.insert(handerCardList[1], 1, item)
			-- 鬼牌放到最前面
			return;
		else
			for i = 1, #handerCardList[1] do
				-- 游戏物体个数 自增
				local cardPoint = handerCardList[1][i].bottomScript.CardPoint;
				-- 得到所有牌指针
				if (cardPoint ~= GlobalData.roomVo.guiPai and cardPoint >= curCardPoint) then
					-- 牌指针>=当前牌的时候插入
					table.insert(handerCardList[1], i, item)
					this.SortMyCardList();
					return;
				end
				table.insert(handerCardList[1], item)
				-- 游戏对象列表添加当前牌
				this.SortMyCardList();
			end
		end
		item = nil;
	end
end

function GamePanelCtrl.SetPosition(flag)
	-- 设置位置
	local count = #handerCardList[1];
	local startX = 594 - count * 80;
	if (flag) then
		for i = 1, count - 1 do
			handerCardList[1][i].transform.localPosition = Vector3.New(startX + i * 80, -292, 0);
			-- 从左到右依次对齐
		end
		handerCardList[1][count - 1].transform.localPosition = Vector3.New(580, -292, 0);
		-- 从左到右依次对齐
	else
		for i = 1, count do
			handerCardList[1][i].transform.localPosition = Vector3.New(startX + i * 80 - 80, -292, 0);
			-- 从左到右依次对齐
		end
	end
end

function GamePanelCtrl.Update()
	timer = timer - Time.deltaTime;
	if (timer < 0) then
		timer = 0;
	end
	Number.text = math.floor(timer);
	if (timeFlag) then
		showTimeNumber = showTimeNumber - 1;
		if (showTimeNumber < 0) then
			timeFlag = false;
			showTimeNumber = 0;
			PlayNoticeAction();
		end
	end
end

function PlayNoticeAction()
	noticeGameObject:SetActive(true);
	if (GlobalData.noticeMegs ~= nil and #GlobalData.noticeMegs ~= 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.noticeMegs[showNoticeNumber];
		local time = noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = noticeText.transform:DOLocalMove(
		Vector3.New(- noticeText.text.Length * 28, noticeText.transform.localPosition.y), time)
		.OnComplete(MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end
end

function MoveCompleted()
	showNoticeNumber = showNoticeNumber + 1;
	if (showNoticeNumber == #GlobalData.noticeMegs) then
		showNoticeNumber = 0;
	end
	noticeGameObject:SetActive(false);
	RandShowTime();
	timeFlag = true;
end

-- 重新开始计时
function UpateTimeReStart()
	timer = 16;
end


-- 点击放弃按钮
function MyPassBtnClick()
	btnActionScript.CleanBtnShow();
	if isSelfPickCard then
		GlobalData.isDrag = true;
		isSelfPickCard = false;
	end
	if (passType == "selfPickCard") then
		GlobalData.isDrag = true;
	end
	passType = "";
	CustomSocket.getInstance():sendMsg(GaveUpRequest.New("gaveup|" .. passStr));
	GlobalData.isChiState = false;
	passStr = "";
end

function MyPengBtnClick()
	GlobalData.isDrag = true;
	UpateTimeReStart();
	local cardvo = { };
	cardvo.cardPoint = putOutCardPoint;
	CustomSocket.getInstance().sendMsg(PengCardRequest.New(json.encode(cardvo)));
	btnActionScript.CleanBtnShow();
	passStr = "";
end


function ShowChipai(idx)
	local cpoint = chiPaiPointList[idx];
	if (idx == 1) then
		chiList_1[1].bottomScript.CardPoint = cpoint.putCardPoint;
		chiList_1[2].bottomScript.CardPoint = cpoint.oneCardPoint;
		chiList_1[3].bottomScript.CardPoint = cpoint.twoCardPoint;
	end
	if (idx == 2) then
		chiList_2[1].bottomScript.CardPoint = cpoint.putCardPoint;
		chiList_2[2].bottomScript.CardPoint = cpoint.oneCardPoint;
		chiList_2[3].bottomScript.CardPoint = cpoint.twoCardPoint;
	end
	if (idx == 3) then
		chiList_3[1].bottomScript.CardPoint = cpoint.putCardPoint;
		chiList_3[2].bottomScript.CardPoint = cpoint.oneCardPoint;
		chiList_3[3].bottomScript.CardPoint = cpoint.twoCardPoint;
	end
end

-- 显示可吃牌的显示
local function ShowChiList()
	btnActionScript.CleanBtnShow();
	for i = 1, #canChiList do
		if (i <= #chiPaiPointList) then
			canChiList[i].gameObject:SetActive(true);
			ShowChipai(i);
		else
			canChiList[i].gameObject:SetActive(false);
		end
	end
end

-- 吃牌选择点击
local function MyChiBtnClick2(idx)
	local cpoint = chiPaiPointList[idx];
	GlobalData.isDrag = true;
	UpateTimeReStart();
	local cardvo = { }
	cardvo.cardPoint = cpoint.putCardPoint;
	cardvo.onePoint = cpoint.oneCardPoint;
	cardvo.twoPoint = cpoint.twoCardPoint;
	CustomSocket.getInstance():sendMsg(ChiCardRequest.New(json.encode(cardvo)));
	btnActionScript.CleanBtnShow();
	GlobalData.isChiState = false;
	oneChiCardPoint = -1;
	twoChiCardPoint = -1;
	passStr = "";
	for i = 1, #canChiList do
		canChiList[i].gameObject:SetActive(false);
	end
end

-- 吃按钮点击
local function MyChiBtnClick()
	if (#chiPaiPointList == 1) then
		local cpoint = chiPaiPointList[1];
		GlobalData.isDrag = true;
		UpateTimeReStart();
		local cardvo = { };
		cardvo.cardPoint = cpoint.putCardPoint;
		cardvo.onePoint = cpoint.oneCardPoint;
		cardvo.twoPoint = cpoint.twoCardPoint;
		CustomSocket.getInstance():sendMsg(ChiCardRequest.New(json.encode(cardvo)));
		btnActionScript.CleanBtnShow();
		GlobalData.isChiState = false;
		oneChiCardPoint = -1;
		twoChiCardPoint = -1;
		passStr = "";
		for i = 1, #canChiList do
			canChiList[i].gameObject:SetActive(false);
		end
	else
		ShowChiList();
	end
end

local function GangResponse(response)
	UpateTimeReStart();
	local gangBackVo = json.decode(response.message);
	local gangKind = gangBackVo.type;
	if (#gangBackVo.cardList == 0) then
		mineList[1][selfGangCardPoint] = 2;
		if (gangKind == 0) then
			-- 明杠
			if (GetPaiInpeng(selfGangCardPoint, DirectionEnum.Bottom) == -1) then
				-- 杠牌不在碰牌数组以内，一定为别人打得牌
				mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] -3;
				-- 销毁别人打的牌
				if (putOutCard ~= nil) then
					destroy(putOutCard);
				end
				if (cardOnTable ~= nil) then
					ReSetOutOnTabelCardPosition(cardOnTable);
					destroy(cardOnTable)
				end
				-- 销毁手牌中的三张牌
				local removeCount = 0;
				for i = 1, #handerCardList[1] do
					local temp = handerCardList[1][i];
					local tempCardPoint = handerCardList[1][i].bottomScript.CardPoint;
					if (selfGangCardPoint == tempCardPoint) then
						table.remove(handerCardList[1], i)
						destroy(temp);
						i = i - 1
						removeCount = removeCount + 1;
						if (removeCount == 3) then
							break;
						end
					end
				end
				-- 创建杠牌序列
				local gangTempList = { };
				for i = 1, 4 do
					local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
					pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint);
					obj.transform.localScale = Vector3.one;
					if (i == 3) then
						obj.transform.localPosition = Vector3.New(-310 + #PengGangCardList * 190, 24);
					end
					table.insert(gangTempList, obj)
				end
				-- 添加到杠牌数组里面
				table.insert(PengGangCardList, gangTempList)
				-- 补杠
			else
				-- 在碰牌数组以内，则一定是自摸的牌
				mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] -4;
				for i = 1, #handerCardList[1] do
					if (handerCardList[1][i].bottomScript.CardPoint == selfGangCardPoint) then
						local temp = handerCardList[1][i];
						table.remove(handerCardList[1], i)
						destroy(temp);
						break;
					end
				end
				local index = GetPaiInpeng(selfGangCardPoint, DirectionEnum.Bottom);
				-- 将杠牌放到对应位置
				local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
				pengGangParenTransformB.transform, Vector3.New(-370 + PengGangCardList.Count * 190, 0));
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint)
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = Vector3.New(-310 + index * 190, 24);
				table.insert(PengGangCardList[index], obj)
				-- 暗杠
			end
		elseif (gangKind == 1) then
			mineList[1][selfGangCardPoint] = mineList[1][selfGangCardPoint] -4;
			local removeCount = 0;
			for i = 1, #handerCardList[1] do
				local temp = handerCardList[1][i];
				local tempCardPoint = handerCardList[1][i].bottomScript.CardPoint;
				if (selfGangCardPoint == tempCardPoint) then
					table.remove(handerCardList[1], i)
					destroy(temp);
					i = i - 1
					removeCount = removeCount + 1;
					if (removeCount == 4) then
						break;
					end
				end
			end
			local tempGangList = { };
			for i = 1, 4 do
				if (i < 3) then
					local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/gangBack",
					pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
					table.insert(tempGangList, obj)
				elseif (i == 3) then
					local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
					pengGangParenTransformB.transform, Vector3.New(-310 + #PengGangCardList * 190, 24));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript.Init(selfGangCardPoint, DirectionEnum.Bottom, GlobalData.roomVo.guiPai == selfGangCardPoint)
					table.insert(tempCardList, obj)
				end
			end
			table.insert(PengGangCardList, tempGangList)
		end
	elseif (gangBackVo.cardList.Count == 2) then
	end
	this.SetPosition(false);
	GlobalData.isChiState = false;
end

function GamePanelCtrl.CreateGameObjectAndReturn(path, parent, position)
	local obj = resMgr:LoadPrefab('prefabs', { path + ".prefab" }, function()
		obj.transform:SetParent(parent);
		obj.transform.localScale = Vector3.one;
		obj.transform.localPosition = position;
	end )
	return obj;
end

local function MyGangBtnClick()
	-- useForGangOrPengOrChi = int.Parse (gangPaiList [1]);
	-- GlobalData.isDrag = true;--由于存在抢杠胡，点了杠按钮以后还不能打牌，收到杠消息才能打
	if (#gangPaiList == 1) then
		useForGangOrPengOrChi = tonumber(gangPaiList[1])
		selfGangCardPoint = useForGangOrPengOrChi;
	else
		-- 多张牌
		useForGangOrPengOrChi = tonumber(gangPaiList[1])
		selfGangCardPoint = useForGangOrPengOrChi;
	end
	CustomSocket.getInstance():sendMsg(GangCardRequest.New(useForGangOrPengOrChi, 0));
	soundMgr:playSoundByAction("gang", GlobalData.loginResponseData.account.sex);
	btnActionScript.CleanBtnShow();
	effectType = "gang";
	PengGangHuEffectCtrl();
	gangPaiList = nil;
	GlobalData.isChiState = false;
	passStr = "";
end

function GamePanelCtrl.Clean()
	this.CleanArrayList(handerCardList)
	this.CleanArrayList(tableCardList)
	this.CleanArrayList(PengGangList_L)
	this.CleanArrayList(PengGangCardList)
	this.CleanArrayList(PengGangList_R)
	this.CleanArrayList(PengGangList_T)
	if (mineList ~= nil) then
		mineList = { }
	end
	if (putOutCard ~= nil) then
		destroy(putOutCard);
	end
	if (pickCardItem ~= nil) then
		destroy(pickCardItem);
	end
	if (otherPickCardItem ~= nil) then
		destroy(otherPickCardItem);
	end
	guiObj:SetActive(false);
end

function GamePanelCtrl.CleanArrayList(list)
	if (list ~= nil) then
		while #list > 0 do
			local tempList = list[1]
			table.remove(list, 1)
			this.CleanList(tempList)
		end
	end
end

function GamePanelCtrl.CleanList(tempList)
	if (tempList ~= nil) then
		while #tempList > 0 do
			local temp = tempList[1];
			table.remove(tempList, 1)
			destroy(temp);
		end
	end
end

local function SetRoomRemark()
	local roomvo = GlobalData.roomVo;
	GlobalData.totalTimes = roomvo.roundNumber;
	GlobalData.surplusTimes = roomvo.roundNumber;
	-- LeavedRoundNumText.text = GlobalData.surplusTimes + "";
	local str = "房间号：\n" .. roomvo.roomId .. "\n"
	.. "圈数:" .. roomvo.roundNumber .. "\n\n"
	roomRemark.text = str;
end

function GamePanelCtrl.AddAvatarVOToList(avatar)
	if (avatarList == nil) then
		avatarList = { };
	end
	table.insert(avatarList, avatar)
	this.SetSeat(avatar);
end
-- 创建房间
function GamePanelCtrl.CreateRoomAddAvatarVO(avatar)
	avatar.scores = 1000;
	this.AddAvatarVOToList(avatar);
	SetRoomRemark();
	if (GlobalData.roomVo.duanMen or GlobalData.roomVo.jiaGang) then
		ReadySelect[1].gameObject:SetActive(GlobalData.roomVo.duanMen)
		ReadySelect[2].gameObject:SetActive(GlobalData.roomVo.jiaGang)
		btnReadyGame:SetActive(true);
		ReadySelect[1].interactable = true;
	else
		this.ReadyGame();
	end
end

-- 加入房间
function GamePanelCtrl.JoinToRoom(avatars)
	avatarList = avatars;
	for i = 1, #avatars do
		this.SetSeat(avatars[i])
	end
	SetRoomRemark();
	if (GlobalData.roomVo.jiaGang) then
		ReadySelect[1].gameObject:SetActive(GlobalData.roomVo.duanMen);
		ReadySelect[2].gameObject:SetActive(GlobalData.roomVo.jiaGang);
		btnReadyGame:SetActive(true);
		ReadySelect[1].interactable = false;
	else
		this.ReadyGame();
	end
end

-- 设置当前角色的座位
function GamePanelCtrl.SetSeat(avatar)
	-- 游戏结束后用的数据，勿删！！！
	if (avatar.account.uuid == GlobalData.loginResponseData.account.uuid) then
		playerItems[1]:SetAvatarVo(avatar);
	else
		local myIndex = this.GetMyIndexFromList();
		local curAvaIndex = table.indexOf(avatarList, avatar)
		local seatIndex =1+ curAvaIndex - myIndex;
		if (seatIndex < 1) then
			seatIndex = 4 + seatIndex;
		end
		playerItems[seatIndex]:SetAvatarVo(avatar);
	end
end

function GamePanelCtrl.GetMyIndexFromList()
	if (avatarList ~= nil) then
		for i = 1, #avatarList do
			if (avatarList[i].account.uuid == GlobalData.loginResponseData.account.uuid or avatarList[i].account.openid == GlobalData.loginResponseData.account.openid) then
				GlobalData.loginResponseData.account.uuid = avatarList[i].account.uuid;
				return i
			end
		end
	end
	return 0;
end

function GamePanelCtrl.GetIndex(uuid)
	if (avatarList ~= nil) then
		for i = 1, #avatarList do
			if (avatarList[i].account ~= nil) then
				if (avatarList[i].account.uuid == uuid) then
					return i;
				end
			end
		end
		return 1;
	end
end

local function OtherUserJointRoom(response)
	local avatar = json.decode(response.message);
	this.AddAvatarVOToList(avatar);
end

-- 胡牌按钮点击
local function HupaiRequest()
	if (SelfAndOtherPutoutCard ~= -1) then
		local cardPoint = SelfAndOtherPutoutCard;
		-- 需修改成正确的胡牌cardpoint
		local requestVo = { };
		requestVo.cardPoint = cardPoint;
		if (isQiangHu) then
			requestVo.type = "qianghu";
			isQiangHu = false;
		end
		local sendMsg = json.encode(requestVo);
		CustomSocket.getInstance():sendMsg(HupaiRequest.New(sendMsg));
		btnActionScript.CleanBtnShow();
		GlobalData.isChiState = false;
	end
end

local function HupaiCallBack(response)
	for i = 1, #playerItems do
		playerItems[GetIndexByDir(this.GetDirection(i))].jiaGang.text = "";
	end
	GlobalData.hupaiResponseVo = json.decode(response.message);
	local scores = GlobalData.hupaiResponseVo.currentScore;
	HupaiCoinChange(scores);
	local huPaiPoint = 0;
	if (GlobalData.hupaiResponseVo.type == "0") then
		SoundMgr:playSoundByAction("hu", GlobalData.loginResponseData.account.sex);
		effectType = "hu";
		PengGangHuEffectCtrl();
		for i = 1, #GlobalData.hupaiResponseVo.avatarList do
			if (GlobalData.hupaiResponseVo.avatarList[i].uuid == GlobalData.hupaiResponseVo.winnerId) then
				huPaiPoint = GlobalData.hupaiResponseVo.avatarList[i].cardPoint;
				if (GlobalData.hupaiResponseVo.winnerId ~= GlobalData.hupaiResponseVo.dianPaoId) then
					-- 点炮胡
					playerItems[GetIndexByDir(this.GetDirection(i))]:SetHuFlagDisplay();
					soundMgr:playSoundByAction("hu", avatarList[i].account.sex);
				else
					-- 自摸胡
					playerItems[GetIndexByDir(this.GetDirection(i))]:SetHuFlagDisplay();
					soundMgr:playSoundByAction("zimo", avatarList[i].account.sex);
				end
			else
				playerItems[GetIndexByDir(this.GetDirection(i))]:SetHuFlagHidde();
			end
		end
		allMas = GlobalData.hupaiResponseVo.allMas;
		if (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN
			or GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
			-- 转转麻将显示抓码信息
			if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas > 0) then
				zhuamaPanel = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab' }, nil)
				zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
				zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas)
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 7)
				)
			else
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 3)
				)
			end
		elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
			-- 广东麻将显示抓码信息
			if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas > 0) then
				zhuamaPanel = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab' }, nil)
				zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
				zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas, GlobalData.roomVo.roomType);
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 7)
				)
			else
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 3)
				)
			end
		elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
			-- 盘锦麻将绝
			if (GlobalData.roomVo.jue) then
				zhuamaPanel = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/Panel_ZhuaMa.prefab' }, nil)
				zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
				zhuamaPanel.ZhuMaScript:arrageJue(huPaiPoint, avatarList, GlobalData.hupaiResponseVo.validMas);
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 7)
				)
			else
				coroutine.start(
				Invoke(OpenGameOverPanelSignal, 3)
				)
			end
		else
			coroutine.start(
			Invoke(OpenGameOverPanelSignal, 3)
			)
		end
	elseif (GlobalData.hupaiResponseVo.type == "1") then
		soundMgr:playSoundByAction("liuju", GlobalData.loginResponseData.account.sex);
		effectType = "liuju";
		PengGangHuEffectCtrl();
		coroutine.start(
		Invoke(OpenGameOverPanelSignal, 3)
		)
	else
		coroutine.start(
		Invoke(OpenGameOverPanelSignal, 3)
		)
	end
end

local function Invoke(f, time)
	coroutine.wait(time)
	f()
end

local function HupaiCoinChange(scores)
	local scoreList = string.split(scores, ',')
	if (scoreList ~= nil and #scoreList > 0) then
		for i = 1, #scoreList - 1 do
			local itemstr = scoreList[i];
			local uuid = tonumber(string.split(itemstr, ':')[1]);
			local score = tonumber(string.split(itemstr, ':')[2]) + 1000;
			playerItems[GetIndexByDir(this.GetDirection(this.GetIndex(uuid)))].scoreText.text = tostring(score);
			avatarList[this.GetIndex(uuid)].scores = score;
		end
	end
end


-- 单局结束重置数据的地方

local function OpenGameOverPanelSignal()
	-- 单局结算
	liujuEffectGame:SetActive(false);
	SetAllPlayerHuImgVisbleToFalse();
	playerItems[GetIndexByDir(this.GetDirection(bankerIndex))]:SetbankImgEnable(false);
	if (handerCardList ~= nil and #handerCardList > 0 and #handerCardList[1] > 0) then
		for i = 1, #handerCardList[1] do
			handerCardList[1][i].bottomScript.onSendMessage = nil
			handerCardList[1][i].bottomScript.reSetPoisiton = nil
		end
	end
	this.InitPanel();
	if (zhuamaPanel ~= nil) then
		destroy(zhuamaPanel);
	end
	local obj = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/Panel_Game_Over.prefab' }, function()
		obj.GameOverScript = GameOverScript.New()
		obj.GameOverScript:SetDisplaContent(0, avatarList, allMas, GlobalData.hupaiResponseVo.validMas, GlobalData.hupaiResponseVo.nextBankerId == GlobalData.loginResponseData.account.uuid);
		table.insert(GlobalData.singalGameOverList, obj)
	end )
	allMas = "";
	-- 初始化码牌数据为空
	avatarList[bankerIndex].main = false;
end

function ReSetOutOnTabelCardPosition(cardOnTable)
	log("putOutCardPointAvarIndex===========:" .. tostring(putOutCardPointAvarIndex));
	if (putOutCardPointAvarIndex ~= -1) then
		local objIndex = table.indexOf(tableCardList[putOutCardPointAvarIndex], cardOnTable)
		if (objIndex ~= -1) then
			table.remove(tableCardList[putOutCardPointAvarIndex], objIndex)
			return;
		end
	end
end


-- 退出房间确认面板
local function QuiteRoom()
	if (bankerIndex == this.GetMyIndexFromList()) then
		dialog_fanhui_text.text = "亲，确定要解散房间吗?";
	else
		dialog_fanhui_text.text = "亲，确定要离开房间吗?";
	end
	dialog_fanhui.gameObject:SetActive(true);
end
--退出房间按钮点击
function GamePanelCtrl.Tuichu()
	local vo = { };
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo)
	CustomSocket.getInstance():sendMsg(OutRoomRequest.New(sendMsg));
	dialog_fanhui.gameObject:SetActive(false);
end
--取消退出房间
function GamePanelCtrl.Quxiao()
	dialog_fanhui.gameObject:SetActive(false);
end

local function OutRoomCallbak(response)
	local responseMsg = json.decode(response.message)
	if (responseMsg.status_code == "0") then
		if (responseMsg.type == "0") then
			local uuid = responseMsg.uuid;
			if (uuid ~= GlobalData.loginResponseData.account.uuid) then
				local index = this.GetIndex(uuid);
				table.remove(avatarList, index)
				for i = 1, #playerItems do
					playerItems[i]:setAvatarVo(nil);
				end
				if (avatarList ~= nil) then
					for i = 1, #avatarList do
						SetSeat(avatarList[i]);
					end
				end
			else
				this.ExitOrDissoliveRoom();
			end
		else
			this.ExitOrDissoliveRoom();
		end
	else
		TipsManager.Instance().setTips("退出房间失败：" .. tostring(responseMsg.error));
	end
end

local dissoliveRoomType = "0";
local function DissoliveRoomRequest()
	SoundMgr:playSoundByActionButton(1);
	if (canClickButtonFlag) then
		dissoliveRoomType = "0";
		TipsManagerScript:LoadDialog("申请解散房间", "你确定要申请解散房间?", doDissoliveRoomRequest, cancle);
	else
		TipsManager.Instance().setTips("还没有开始游戏，不能申请退出房间");
	end
end
-- 游戏设置
local function OpenGameSettingDialog()
	SoundMgr:playSoundByActionButton(1);
	loadPerfab("Assets/Project/Prefabs/Panel_Setting");
	panelCreateDialog.SettingScript = SettingScript.New()
	local ss = panelCreateDialog.SettingScript
	if (canClickButtonFlag) then
		ss.canClickButtonFlag = canClickButtonFlag;
		ss.jiesanBtn:GetComponentInChildren("Text").text = "申请解散房间";
		ss.type = 2;
	else
		if (bankerIndex == this.GetMyIndexFromList()) then
			-- 我是房主（一开始庄家是房主）
			ss.canClickButtonFlag = canClickButtonFlag;
			ss.jiesanBtn:GetComponentInChildren("Text").text = "解散房间";
			ss.type = 3;
			ss.dialog_fanhui = dialog_fanhui;
			dialog_fanhui_text.text = "亲，确定要解散房间吗?";
		else
			ss.canClickButtonFlag = canClickButtonFlag;
			ss.jiesanBtn:GetComponentInChildren("Text").text = "离开房间";
			ss.type = 3;
			ss.dialog_fanhui = dialog_fanhui;
			dialog_fanhui_text.text = "亲，确定要离开房间吗?";
		end
	end

end

local panelCreateDialog;-- 界面上打开的dialog
local function loadPerfab(perfabName)
	panelCreateDialog = resMgr:LoadPrefab('prefabs', { perfabName + ".prefab" }, function()
		panelCreateDialog.transform.parent = gameObject.transform;
		panelCreateDialog.transform.localScale = Vector3.one;
		panelCreateDialog:GetComponent("RectTransform").offsetMax = Vector2.zero;
		panelCreateDialog:GetComponent("RectTransform").offsetMin = Vector2.zero;
	end )
end

-- 申请解散房间回调

local dissoDialog;
local function DissoliveRoomResponse(response)
	local dissoliveRoomResponseVo = json.decode(response.message);
	local plyerName = dissoliveRoomResponseVo.accountName;
	local uuid = dissoliveRoomResponseVo.uuid;
	if (dissoliveRoomResponseVo.type == "0") then
		GlobalData.isonApplayExitRoomstatus = true;
		dissoliveRoomType = "1";
		dissoDialog = PrefabManage.loadPerfab("Assets/Project/Prefabs/Panel_Apply_Exit");
		dissoDialog.VoteScript = VoteScript.New()
		dissoDialog.VoteScript.iniUI(uuid, plyerName, avatarList);
	elseif (dissoliveRoomResponseVo.type == "3") then
		if (zhuamaPanel ~= nil and GlobalData.isonApplayExitRoomstatus) then
			destroy(zhuamaPanel)
		end
		GlobalData.isonApplayExitRoomstatus = false;
		if (dissoDialog ~= nil) then
			dissoDialog.VoteScript.RemoveListener();
			destroy(dissoDialog);
		end
		GlobalData.isOverByPlayer = true;
	end
end


-- 申请或同意解散房间请求
local function DoDissoliveRoomRequest()
	local dissoliveRoomRequestVo = DissoliveRoomRequestVo.New();
	dissoliveRoomRequestVo.roomId = GlobalData.loginResponseData.roomId;
	dissoliveRoomRequestVo.type = dissoliveRoomType;
	local sendMsg = josn.encode(dissoliveRoomRequestVo);
	CustomSocket.getInstance():sendMsg(DissoliveRoomRequest.New(sendMsg));
	GlobalData.isonApplayExitRoomstatus = true;
end

local function cancle()
end

function GamePanelCtrl.ExitOrDissoliveRoom()
	GlobalData.loginResponseData:ResetData();
	-- 复位房间数据
	GlobalData.loginResponseData.roomId = 0;
	-- 复位房间数据
	GlobalData.roomJoinResponseData = nil;
	-- 复位房间数据
	GlobalData.roomVo.roomId = 0;
	GlobalData.soundToggle = true;
	this.Clean();
	soundMgr:playBGM(1);
	if (CtrlManager.HomePanelCtrl ~= nil) then
		CtrlManager.HomePanelCtrl.Open();
	else
		HomePanelCtrl.Awake()
	end

	while #playerItems > 0 do
		local item = playerItems[1];
		table.remove(playerItems, 1)
		destroy(item.gameObject);
	end
	this.Close()
	HomePanelCtrl.Open()
end

local function GameReadyNotice(response)
	local message = json.decode(response.message);
	local avatarIndex = message["avatarIndex"]+1;--服务器是从0开始
	local myIndex = this.GetMyIndexFromList();
	local seatIndex =1+ avatarIndex - myIndex;
	if (seatIndex < 1) then
		seatIndex = 4 + seatIndex;
	end
	playerItems[seatIndex].ReadyImg.enabled = true;
	avatarList[avatarIndex].IsReady = true;
end

-- 隐藏跟庄
local function GameFollowBanderNotice(response)
	genZhuang:SetActive(true);
	coroutine.start(Invoke(HideGenzhuang, 2))
end

local function HideGenzhuang()
	genZhuang:SetActive(false);
end

function GamePanelCtrl.ReEnterRoom()
	if (GlobalData.reEnterRoomData ~= nil) then
		local roomVo = GlobalData.roomVo;
		local reEnterRoomData = GlobalData.reEnterRoomData
		-- 显示房间基本信息
		roomVo.addWordCard = reEnterRoomData.addWordCard;
		roomVo.hong = reEnterRoomData.hong;
		roomVo.name = reEnterRoomData.name;
		roomVo.roomId = reEnterRoomData.roomId;
		roomVo.roomType = reEnterRoomData.roomType;
		roomVo.roundNumber = reEnterRoomData.roundNumber;
		roomVo.sevenDouble = reEnterRoomData.sevenDouble;
		roomVo.xiaYu = reEnterRoomData.xiaYu;
		roomVo.ziMo = reEnterRoomData.ziMo;
		roomVo.magnification = reEnterRoomData.magnification;
		roomVo.ma = reEnterRoomData.ma;
		roomVo.gangHu = reEnterRoomData.gangHu;
		roomVo.guiPai = reEnterRoomData.guiPai;

		roomVo.pingHu = reEnterRoomData.pingHu;
		-- log("GlobalData.reEnterRoomData.jue=" + GlobalData.reEnterRoomData.jue);
		roomVo.jue = reEnterRoomData.jue;
		roomVo.baoSanJia = reEnterRoomData.baoSanJia;
		roomVo.jiaGang = reEnterRoomData.jiaGang;
		roomVo.gui = reEnterRoomData.gui;
		roomVo.duanMen = reEnterRoomData.duanMen;
		roomVo.jihu = reEnterRoomData.jihu;
		roomVo.qingYiSe = reEnterRoomData.qingYiSe;
		roomVo.siguiyi = reEnterRoomData.siguiyi;
		roomVo.menqing = reEnterRoomData.menqing;
		SetRoomRemark();
		-- 设置座位
		avatarList = reEnterRoomData.playerList;
		GlobalData.roomAvatarVoList = reEnterRoomData.playerList;
		for i = 1, #avatarList do
			this.SetSeat(avatarList[i]);
			if (avatarList[i].main) then
				bankerIndex = i;
			end
		end

		this.RecoverOtherGlobalData();
		local selfPaiArray = reEnterRoomData.playerList[this.GetMyIndexFromList()].paiArray;
		if (selfPaiArray == nil or #selfPaiArray == 0) then
			-- 游戏还没有开始
			if (not avatarList[this.GetMyIndexFromList()].isReady) then
				-- log("bankerIndex=" + bankerIndex + "     this.GetMyIndexFromList()=" +  this.GetMyIndexFromList());
				if (roomVo.duanMen or roomVo.jiaGang) then
					ReadySelect[1].gameObject:SetActive(roomVo.duanMen);
					ReadySelect[2].gameObject:SetActive(roomVo.jiaGang);
					btnReadyGame:SetActive(true);
					ReadySelect[1].interactable = avatarList[this.GetMyIndexFromList()].main;
				else
					this.ReadyGame();
				end
			end
		else
			-- 牌局已开始
			this.SetAllPlayerReadImgVisbleToFalse();
			this.CleanGameplayUI();
			-- 显示打牌数据
			this.DisplayTableCards();
			-- 显示鬼牌
			this.DisplayGuiPai();
			-- 显示碰牌
			this.DisplayOtherHandercard();
			-- 显示其他玩家的手牌
			this.DisplayallGangCard();
			-- 显示杠牌
			this.DisplayPengCard();
			-- 显示碰牌
			this.DisplayChiCard();
			-- 显示吃牌
			this.DispalySelfhanderCard();
			-- 显示自己的手牌
			CustomSocket.getInstance():sendMsg(CurrentStatusRequest.New());
		end
	end
end

-- 恢复其他全局数据
function GamePanelCtrl.RecoverOtherGlobalData()
	local selfIndex = this.GetMyIndexFromList();
	-- 恢复房卡数据，此时主界面还没有load所以无需操作界面显示
	GlobalData.loginResponseData.account.roomcard = GlobalData.reEnterRoomData.playerList[selfIndex].account.roomcard;
end


function GamePanelCtrl.DispalySelfhanderCard()
	mineList = this.ToList(GlobalData.reEnterRoomData.playerList[this.GetMyIndexFromList()].paiArray);
	for i = 1, #mineList[1] do
		if (mineList[1][i] > 0) then
			for j = 1, #mineList[1][i] do
				local gob = resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function()
					if (gob ~= nil) then
						gob.transform:SetParent(parentList[1]);
						-- 设置父节点
						gob.transform.localScale = Vector3.New(1.1, 1.1, 1);
						gob.bottomScript.onSendMessage = CardChange;
						-- 发送消息fd
						gob.bottomScript.reSetPoisiton = CardSelect;
						gob.bottomScript.CardPoint = i;
						if (i == GlobalData.roomVo.guiPai) then
							gob.bottomScript.SetLaizi(true);
						end
						table.insert(handerCardList[1], god)
						-- 增加游戏对象
						this.SortMyCardList();
					end
				end )
			end
		end
	end
	this.SetPosition(false);
end

function GamePanelCtrl.ToList(param)
	local returnData = { };
	for i = 1, #param do

		local temp = { };
		for j = 1, #param[i] do
			temp[j] = param[i][j]
		end
		returnData[i] = temp
	end
	return returnData;
end

function MyselfSoundActionPlay()
	playerItems[1].ShowChatAction();
end


-- 重连显示打牌数据
function GamePanelCtrl.DisplayTableCards()
	local Dir;
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local chupai = GlobalData.reEnterRoomData.playerList[i].chupais;
		Dir = this.GetDirection(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
		if (chupai ~= nil and #chupai > 0) then
			for j = 1, #chupai do
				this.ThrowBottom(chupai[j], Dir, true);
			end
		end
	end
end

-- 显示桌面鬼牌
local function DisplayTouzi(touzi, gui)
	if (gui ~= -1 and GlobalData.roomVo.roomType == 4 and GlobalData.roomVo.gui == 2) then
		-- 显示骰子
		local r1 = touzi / 10;
		local r2 = touzi % 10;
		touziObj.TouziActionScript = TouziActionScript.New()
		local bts = touziObj.TouziActionScript;
		bts:SetResult(r1, r2);
		touziObj:SetActive(true);
		coroutine.start(Invoke(this.DisplayGuiPai, 5.5))
	else
		this.DisplayGuiPai();
	end
end

-- 获取显示赖子皮（鬼牌2万 显示1万）
local function GetDisplayGuiPai(gui)
	if (gui == 0 or gui == 9 or gui == 18) then
		return gui + 8;
	elseif (gui == 27) then
		-- 风
		return gui + 3;
	elseif (gui == 31) then
		-- 中发白
		return gui + 2;
	else
		return gui - 1;
	end
end

-- 显示桌面鬼牌
function GamePanelCtrl.DisplayGuiPai()
	touziObj:SetActive(false);
	local gui = GlobalData.roomVo.guiPai;
	if (gui ~= -1 and(GlobalData.roomVo.hong or GlobalData.roomVo.gui > 0)) then
		-- 显示鬼牌
		-- int mGui = getDisplayGuiPai(gui);//盘锦玩法，显示当前鬼牌的前一张
		guiObj.TopAndBottomCardScript = TopAndBottomCardScript.New()
		guiObj.TopAndBottomCardScript.Init(gui, DirectionEnum.T, true);
		guiObj:SetActive(true);
	end
end

-- 重连显示其他人的手牌
function GamePanelCtrl.DisplayOtherHandercard()
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local dir = this.GetDirection(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
		local count = GlobalData.reEnterRoomData.playerList[i].commonCards;
		if (dir ~= DirectionEnum.B) then
			this.InitOtherCardList(dir, count);
		end
	end
end

-- 重连显示杠牌
function GamePanelCtrl.DisplayallGangCard()
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];
		local dirstr = this.GetDirection(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
		if (table.Contains(paiArrayType, 2)) then

			local gangString = GlobalData.reEnterRoomData.playerList[i].huReturnObjectVO.totalInfo.gang;
			if (gangString ~= nil) then
				local gangtemps = string.split(gangString, ',')
				for j = 1, #gangtemps do
					local item = gangtemps[j];
					gangpaiObj = { };
					gangpaiObj.uuid = string.split(item, ':')[1];
					gangpaiObj.cardPiont = tonumber(string.split(item, ':')[2]);
					gangpaiObj.type = string.split(item, ':')[3];
					-- 增加判断是否为自己的杠牌的操作

					GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPiont] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPiont] -4;
					if (gangpaiObj.type == "an") then
						this.DoDisplayPengGangCard(dirstr, gangpaiObj.cardPiont, 4, 1);
					else
						this.DoDisplayPengGangCard(dirstr, gangpaiObj.cardPiont, 4, 0);
					end
				end
			end
		end

	end
end


-- 碰牌重连（这个逻辑写得很反人类）
function GamePanelCtrl.DisplayPengCard()
	for i = 0, #GlobalData.reEnterRoomData.playerList do
		local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];
		-- 第二个数组存储了碰的牌
		local dirstr = this.GetDirection(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
		if (table.Contains(paiArrayType, 1)) then
			-- 1代表碰的那张牌
			for j = 1, #paiArrayType do
				if (paiArrayType[j] == 1 and GlobalData.reEnterRoomData.playerList[i].paiArray[0][j] > 0) then
					-- 服务器没去掉已经吃碰杠的牌，所以处理一下（主要是要去掉自己的）
					GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] -3;
					this.DoDisplayPengGangCard(dirstr, j, 3, 2);
				end
			end
		end
	end
end


-- 吃牌的重连
function GamePanelCtrl.DisplayChiCard()
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local dirstr = this.GetDirection(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid));
		local chiPaiArray = GlobalData.reEnterRoomData.playerList[i].chiPaiArray;
		if #chiPaiArray > 0 then
			for j = 1, #chiPaiArray do
				for k = 1, #chiPaiArray[j] do
					if (GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] > 0) then
						GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] -1;
					end
				end
				this.DoDisplayChiCard(dirstr, chiPaiArray[j]);
			end
		end
	end
end


-- 显示杠碰牌
-- cloneCount 代表clone的次数  若为3则表示碰   若为4则表示杠
-- flag 1暗杠 0补杠和明杠
function GamePanelCtrl.DoDisplayPengGangCard(dirstr, point, cloneCount, flag)
	local gangTempList = { };
	switch =
	{
		[DirectionEnum.B] = function()
			for i = 1, #cloneCount do
				local obj;
				if (i < 4) then
					if (flag ~= 1) then
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
						pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
						obj.transform.localScale = Vector3.one;
					else
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/gangBack",
						pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						obj.transform.localScale = Vector3.one;
					end
				else
					obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
					pengGangParenTransformB.transform, Vector3.New(-310 + #PengGangCardList * 190, 24));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
				end
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangCardList, gangTempList);
		end,
		[DirectionEnum.T] = function()
			for i = 1, #cloneCount do
				local obj;
				if (i < 4) then
					if (flag ~= 1) then
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
						pengGangParenTransformT.transform, Vector3.New(-370 + #PengGangList_T * 190 + i * 60, 0));
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
					else
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_T",
						pengGangParenTransformT.transform, Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0));
						obj.transform.localScale = Vector3.one;
					end
				else
					obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
					pengGangParenTransformT.transform, Vector3.New(251 - #PengGangList_T * 120 + 37, 20));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);

				end
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_T, gangTempList);
		end,
		[DirectionEnum.L] = function()
			for i = 1, #cloneCount do
				local obj;
				if (i < 4) then
					if (flag ~= 1) then
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
						pengGangParenTransformL.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
					else
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_L&R",
						pengGangParenTransformL.transform, Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28));
					end
				else
					obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
					pengGangParenTransformL.transform, Vector3.New(0, 122 - #PengGangList_L * 95 - 18, 0));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
				end
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_L, gangTempList);
		end,
		[DirectionEnum.R] = function()
			for i = 1, #cloneCount do
				local obj;
				if (i < 4) then
					if (flag ~= 1) then
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
						pengGangParenTransformR.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
						obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
						obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
					else
						obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/GangBack_L&R",
						pengGangParenTransformR.transform, Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28));
						obj.transform:SetSiblingIndex(0);
					end
				else
					obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
					pengGangParenTransformR.transform, Vector3.New(0, -122 + #PengGangList_R * 95 + 33));
					obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
					obj.TopAndBottomCardScript:Init(point, dirstr, GlobalData.roomVo.guiPai == point);
				end
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_R, gangTempList);
		end
	}
	switch[dirstr]()
end


-- 吃牌重连

function GamePanelCtrl.DoDisplayChiCard(dirstr, point)
	local gangTempList = { };
	switch =
	{
		[DirectionEnum.B] = function()
			for i = 1, 3 do
				local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_B",
				pengGangParenTransformB.transform, Vector3.New(-370 + #PengGangCardList * 190 + i * 60, 0));
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
				obj.transform.localScale = Vector3.one;
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangCardList, gangTempList)
		end,
		[DirectionEnum.T] = function()
			for i = 1, 3 do
				local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_T",
				pengGangParenTransformT.transform, Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0));
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_T, gangTempList)
		end,
		[DirectionEnum.L] = function()
			for i = 1, 3 do
				local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_L",
				pengGangParenTransformL.transform, Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28));
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_T, gangTempList)
		end,
		[DirectionEnum.R] = function()
			for i = 1, 3 do
				local obj = this.CreateGameObjectAndReturn("Assets/Project/Prefabs/PengGangCard/PengGangCard_R",
				pengGangParenTransformR.transform, Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28));
				obj.TopAndBottomCardScript = TopAndBottomCardScript.New()
				obj.TopAndBottomCardScript:Init(point[i], dirstr, GlobalData.roomVo.guiPai == point[i]);
				obj.transform:SetSiblingIndex(0);
				table.insert(gangTempList, obj)
			end
			table.insert(PengGangList_T, gangTempList)
		end
	}
	switch[dirstr]()
end

function InviteFriend()
	GlobalData.wechatOperate:inviteFriend();
end

-- 用户离线回调
function offlineNotice(response)
	local uuid = tonumber(response.message);
	local index = this.GetIndex(uuid);
	local dirstr = this.GetDirection(index);
	switch =
	{
		[DirectionEnum.B] = function()
			playerItems[1].PlayerItemScript:SetPlayerOffline();
		end,
		[DirectionEnum.R] = function()
			playerItems[2].PlayerItemScript:SetPlayerOffline();
		end,
		[DirectionEnum.T] = function()
			playerItems[3].PlayerItemScript:SetPlayerOffline();
		end,
		[DirectionEnum.L] = function()
			playerItems[4].PlayerItemScript:SetPlayerOffline();
		end
	}
	switch[dirstr]()
	-- 申请解散房间过程中，有人掉线，直接不能解散房间
	if (GlobalData.isonApplayExitRoomstatus) then
		if (dissoDialog ~= nil) then
			dissoDialog.VoteScript.removeListener();
			destroy(dissoDialog);
		end
		TipsManager.setTips("由于" .. avatarList[index].account.nickname .. "离线，系统不能解散房间")
	end
end

-- 用户上线提醒
local function OnlineNotice(response)
	local uuid = tonumber(response.message);
	local index = this.GetIndex(uuid);
	local dirstr = this.GetDirection(index);
	switch =
	{
		[DirectionEnum.B] = function()
			playerItems[1].PlayerItemScript:SetPlayerOnline();
		end,
		[DirectionEnum.R] = function()
			playerItems[2].PlayerItemScript:SetPlayerOnline();
		end,
		[DirectionEnum.T] = function()
			playerItems[3].PlayerItemScript:SetPlayerOnline();
		end,
		[DirectionEnum.L] = function()
			playerItems[4].PlayerItemScript:SetPlayerOnline();
		end
	}
	switch[dirstr]()
end

local function messageBoxNotice(response)
	local arr = string.split(response.message, '|')
	local uuid = tonumber(arr[1]);
	local myIndex = this.GetMyIndexFromList();
	local curAvaIndex = this.GetIndex(uuid);
	local seatIndex =1+ curAvaIndex - myIndex;
	if (seatIndex < 1) then
		seatIndex = 4 + seatIndex;
	end
	playerItems[seatIndex]:ShowChatMessage(tonumber(arr[1]));
end


-- 发准备消息
function GamePanelCtrl.ReadyGame()
	local readyvo = { };
	readyvo.duanMen = ReadySelect[1].isOn;
	readyvo.jiaGang = ReadySelect[2].isOn;
	log("ReadySelect[1].isOn=" .. tostring(ReadySelect[1].isOn) .. "ReadySelect[2].isOn=" .. tostring(ReadySelect[2].isOn));
	ReadySelect[1].gameObject:SetActive(false);
	ReadySelect[2].gameObject:SetActive(false);
	btnReadyGame:SetActive(false);
	CustomSocket.getInstance():sendMsg(GameReadyRequest.New(json.encode(readyvo)));
end

local function MicInputNotice(response)
	local sendUUid = tonumber(response.message)
	if (sendUUid > 0) then
		for i = 1, #playerItems do
			if (playerItems[i]:GetUuid() ~= -1) then
				if (sendUUid == playerItems[i]:GetUuid()) then
					playerItems[i]:ShowChatAction();
				end
			end
		end
	end
end


-- 最后一次操作（这代码也写得很反人类）

local function returnGameResponse(response)
	local returnstr = response.message;
	log("returnGameResponse=" .. returnstr);
	-- 1.显示剩余牌的张数和圈数
	local returnJsonData = json.decode(response.message);
	local surplusCards = returnJsonData.surplusCards;
	LeavedCastNumText.text = tostring(surplusCards);
	LeavedCardsNum = surplusCards;
	local gameRound = returnJsonData.gameRound;
	LeavedRoundNumText.text = tostring(gameRound);
	GlobalData.surplusTimes = gameRound;
	local curAvatarIndexTemp = -1;
	-- 当前出牌人的索引
	local pickAvatarIndexTemp = -1;
	-- 当前摸牌人的索引
	local putOffCardPointTemp = -1;
	-- 当前打得点数
	local currentCardPointTemp = -1;
	-- 当前摸的点数
	-- 不是自己摸牌

	curAvatarIndexTemp = returnJsonData.curAvatarIndex;
	-- 当前打牌人的索引
	putOffCardPointTemp = returnJsonData.putOffCardPoint;
	-- 当前打得点数
	putOutCardPointAvarIndex = GetIndexByDir(this.GetDirection(curAvatarIndexTemp));
	putOutCardPoint = putOffCardPointTemp;
	SelfAndOtherPutoutCard = putOutCardPoint;
	pickAvatarIndexTemp = returnJsonData.pickAvatarIndex;
	-- 当前摸牌牌人的索引

	if (table.Contains(returnJsonData, currentCardPoint)) then
		currentCardPointTemp = returnJsonData.currentCardPoint;
		-- 当前摸得的点数  (吃碰杠以后，服务器发的这个值是-2)
		SelfAndOtherPutoutCard = currentCardPointTemp;
	end


	if (pickAvatarIndexTemp == this.GetMyIndexFromList()) then
		-- 自己摸牌
		if (currentCardPointTemp == -2) then
			MoPaiCardPoint = handerCardList[1][#handerCardList[1]].bottomScript.CardPoint;
			SelfAndOtherPutoutCard = MoPaiCardPoint;
			useForGangOrPengOrChi = curAvatarIndexTemp;
			destroy(handerCardList[1][#handerCardList[1]]);
			table.remove(handerCardList[1])
			this.SetPosition(false);
			PutCardIntoMineList(MoPaiCardPoint);
			MoPai();
			curDir = DirectionEnum.B;
			SetDirGameObjectAction();
			GlobalData.isDrag = true;
		else
			if ((#handerCardList[1]) % 3 ~= 1) then
				MoPaiCardPoint = currentCardPointTemp;
				log("摸牌" .. MoPaiCardPoint);
				SelfAndOtherPutoutCard = MoPaiCardPoint;
				useForGangOrPengOrChi = curAvatarIndexTemp;
				for i = 1, #handerCardList[1] do
					if (handerCardList[1][i].bottomScript.CardPoint == currentCardPointTemp) then
						destroy(handerCardList[1][i]);
						table.remove(handerCardList[1], i)
						break;
					end
				end
				this.SetPosition(false);
				PutCardIntoMineList(MoPaiCardPoint);
				MoPai();
				curDir = DirectionEnum.B;
				SetDirGameObjectAction();
				GlobalData.isDrag = true;
			end
		end
	else
		-- 别人摸牌
		curDir = this.GetDirection(pickAvatarIndexTemp);
		-- otherMoPaiCreateGameObject (curDirString);
		SetDirGameObjectAction();
	end
	-- 光标指向打牌人
	local dirindex = GetIndexByDir(this.GetDirection(curAvatarIndexTemp));
	-- cardOnTable = tableCardList[dirindex][tableCardList[dirindex].Count - 1];
	if (tableCardList[dirindex] == nil or #tableCardList[dirindex] == 0) then
		-- 刚启动
	else
		local temp = tableCardList[dirindex][#tableCardList[dirindex]];
		cardOnTable = temp;
		SetPointGameObject(temp);
	end
end





-- 解散房间按钮
function GamePanelCtrl.InitbtnJieSan()
	if (bankerIndex == this.GetMyIndexFromList()) then
		-- 我是房主（一开始庄家是房主）
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/jiesan.png' }, function(sprite)
			btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	else
		resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/leaveRoom.png" }, function(sprite)
			btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	end
	this.lua:AddClick(btnJieSan, QuiteRoom)
end


------------------------------------------------------------
-- 关闭面板--
function GamePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

-- 移除事件--
function GamePanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().StartGameNotice = nil;
	SocketEventHandle.getInstance().pickCardCallBack = nil
	SocketEventHandle.getInstance().otherPickCardCallBack = nil
	SocketEventHandle.getInstance().putOutCardCallBack = nil
	SocketEventHandle.getInstance().otherUserJointRoomCallBack = nil
	SocketEventHandle.getInstance().PengCardCallBack = nil;
	SocketEventHandle.getInstance().ChiCardCallBack = nil
	SocketEventHandle.getInstance().GangCardCallBack = nil
	SocketEventHandle.getInstance().gangCardNotice = nil
	SocketEventHandle.getInstance().btnActionShow = nil
	SocketEventHandle.getInstance().HupaiCallBack = nil
	-- SocketEventHandle.getInstance ().FinalGameOverCallBack -= finalGameOverCallBack;
	SocketEventHandle.getInstance().outRoomCallback = nil
	SocketEventHandle.getInstance().dissoliveRoomResponse = nil
	SocketEventHandle.getInstance().gameReadyNotice = nil
	SocketEventHandle.getInstance().offlineNotice = nil
	SocketEventHandle.getInstance().onlineNotice = nil
	SocketEventHandle.getInstance().messageBoxNotice = nil
	SocketEventHandle.getInstance().returnGameResponse = nil
	-- CommonEvent.getInstance ().readyGame -= markselfReadyGame;
	SocketEventHandle.getInstance().micInputNotice = nil
	SocketEventHandle.getInstance().gameFollowBanderNotice = nil
	Event.RemoveListener(closeGamePanel, this.ExitOrDissoliveRoom)
end

-- 打开面板--
function GamePanelCtrl.Open()
	if (gameObject) then
		gameObject:SetActive(true)
		transform:SetAsLastSibling();
		this.AddListener()
	end
end
-- 增加事件--
function GamePanelCtrl.AddListener()
	SocketEventHandle.getInstance().StartGameNotice = StartGame;
	SocketEventHandle.getInstance().pickCardCallBack = PickCard;
	SocketEventHandle.getInstance().otherPickCardCallBack = OtherPickCard;
	SocketEventHandle.getInstance().putOutCardCallBack = OtherPutOutCard;
	SocketEventHandle.getInstance().otherUserJointRoomCallBack = OtherUserJointRoom;
	SocketEventHandle.getInstance().PengCardCallBack = PengCard;
	SocketEventHandle.getInstance().ChiCardCallBack = ChiCard;
	SocketEventHandle.getInstance().GangCardCallBack = GangResponse;
	SocketEventHandle.getInstance().gangCardNotice = OtherGang;
	SocketEventHandle.getInstance().btnActionShow = ActionBtnShow;
	SocketEventHandle.getInstance().HupaiCallBack = HupaiCallBack;
	-- SocketEventHandle.getInstance ().FinalGameOverCallBack =this.FinalGameOverCallBack;
	SocketEventHandle.getInstance().outRoomCallback = OutRoomCallbak;
	SocketEventHandle.getInstance().dissoliveRoomResponse = DissoliveRoomResponse;
	SocketEventHandle.getInstance().gameReadyNotice = GameReadyNotice;
	SocketEventHandle.getInstance().offlineNotice = OfflineNotice;
	SocketEventHandle.getInstance().messageBoxNotice = MessageBoxNotice;
	SocketEventHandle.getInstance().returnGameResponse = ReturnGameResponse;
	SocketEventHandle.getInstance().onlineNotice = OnlineNotice;
	-- CommonEvent.getInstance ().readyGame = this.MarkselfReadyGame;
	SocketEventHandle.getInstance().micInputNotice = MicInputNotice;
	SocketEventHandle.getInstance().gameFollowBanderNotice = GameFollowBanderNotice;
	Event.AddListener(closeGamePanel,this.ExitOrDissoliveRoom)
end
