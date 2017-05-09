require "View/GamePanel"
require "Logic/ButtonAction"
require "Data/DirectionEnum"
GamePanelCtrl={}
local this=GamePanelCtrl;
local gameObject;
this.playerItems={}
local timeFlag=false
local versionText
local btnActionScript
local dialog_fanhui
local showTimeNumber=0
local mineList
local handerCardList
local tableCardList
local PengGangList_L
local PengGangList_R
local PengGangList_T
local PengGangCardList
local ChiCardList
local avatarList
local bankerId
local curDirString
local LeavedRoundNumText
local isFirstOpen
local ruleText
--能否申请退出房间，初始为false，开始游戏置true
local canClickButtonFlag=false
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
function GamePanelCtrl.Awake()
	logWarn("GamePanelCtrl.Awake--->>");
	if(CtrlManager.GamePanelCtrl) then
	this.Open()
else
	PanelManager:CreatePanel('GamePanel', this.OnCreate);
	CtrlManager.AddCtrl("GamePanelCtrl",this)
end
end

function GamePanelCtrl.OnCreate(go)
	logWarn("Start lua--->>"..go.name);
	gameObject = go;
	transform=go.transform
	lua = gameObject:GetComponent('LuaBehaviour');
	versionText=transform:FindChild('Text_version'):GetComponent('Text');
	btnActionScript =ButtonAction.New();
	dialog_fanhui=transform:FindChild('jiesan')
	LeavedRoundNumText=transform:FindChild('Leaved1/Text'):GetComponent('Text');
	ruleText=transform:FindChild('Rule'):GetComponent('Text');
	inviteFriendButton=transform:FindChild('Button_invite_friend'):GetComponent('Button');
	btnJieSan=transform:FindChild('Button_jiesan'):GetComponent('Button');
	ExitRoomButton=transform:FindChild('Button_other'):GetComponent('Button');
	live1=transform:FindChild('Leaved'):GetComponent('Image');
	live2=transform:FindChild('Leaved1'):GetComponent('Image');
	centerImage=transform:FindChild('table'):GetComponent('Image');
	liujuEffectGame=transform:FindChild('Liuju_B').gameObject
	ruleText=transform:FindChild('Rule'):GetComponent('Text');
	LeavedCastNumText=transform:FindChild('Leaved/Text'):GetComponent('Text');
	this.Start()
end
function GamePanelCtrl.Start()
	RandShowTime();
	timeFlag = true;
	soundMgr:playBGM(2);
	--norHu = new NormalHuScript();
	--naiziHu = new NaiziHuScript();
	--gameTool = new GameToolScript();
	versionText.text = "V" .. Application.version;
	this.AddListener();
	InitPanel();
	InitArrayList();
	--initPerson ();--初始化每个成员1000分
	GlobalData.isonLoginPage = false;
	if (GlobalData.reEnterRoomData ~= nil) then
		--短线重连进入房间
		GlobalData.loginResponseData.roomId = GlobalData.reEnterRoomData.roomId;
		ReEnterRoom();
	elseif (GlobalData.roomJoinResponseData ~= nil) then
		--进入他人房间
		JoinToRoom(GlobalData.roomJoinResponseData.playerList);
	else
		--创建房间
		CreateRoomAddAvatarVO(GlobalData.loginResponseData);
	end
	GlobalData.reEnterRoomData = nil;
	TipsManager.Instance().setTips("",0);
	dialog_fanhui.gameObject:SetActive(false);
	InitbtnJieSan();
end

function GamePanelCtrl.ExitOrDissoliveRoom()
	GlobalData.loginResponseData.resetData();--复位房间数据
	GlobalData.loginResponseData.roomId = 0;--复位房间数据
	GlobalData.roomJoinResponseData = nil;--复位房间数据
	GlobalData.roomVo.roomId = 0;
	--GlobalData.soundToggle = true;
	this.Clean();
	soundMgr:playBGM(1);
	if (HomePanel.gameObject ~= nil) then
		HomePanelCtrl.Open();
		
	else
		HomePanelCtrl.Awake();
	end
	
	while #playerItems > 0 do
		local item = playerItems[1];
		table.remove(playerItems,1)
		item.Clean();
		Destroy(item.gameObject);
	end
	this.Close();
end
local function Clean()
	
end

local function RandShowTime()
	showTimeNumber =math.random(5000,10000)
end

local function InitPanel()
	Clean()
	btnActionScript.CleanBtnShow()
end

local function InitArrayList()
	mineList ={}
	handerCardList = {}
	tableCardList = {}
	PengGangList_L = {};
	PengGangList_R = {};
	PengGangList_T = {};
	PengGangCardList={};
	ChiCardList = {}
end

local function CardSelect(obj)
	if GlobalData.isChiState then
		
		OnChipSelect(obj, true);
		
	else
		
		for k,v in pairs(handerCardList[1]) do
			if v == nil then
				handerCardList[1][k] = nil
			else
				handerCardList[1][k].transform.localPosition =Vector3.New(handerCardList[0][k].transform.localPosition.x, -292); --从右到左依次对齐
				handerCardList[1][k].BottomScript.selected = false;
			end
		end
		
		if (obj ~= nil) then
			
			obj.transform.localPosition =Vector3.New(obj.transform.localPosition.x, -272);
			obj.bottomScript.selected = true;
			
		end
	end
end

local function StartGame(response)
	GlobalData.roomAvatarVoList = avatarList;
	--GlobalDataScript.surplusTimes -= 1;
	local sgvo =json.decode(response.message);
	bankerId = sgvo.bankerId;
	GlobalData.roomVo.guiPai = sgvo.gui;
	CleanGameplayUI ();
	--开始游戏后不显示
	log("lua:GamePanelCtrl.StartGame");
	GlobalData.surplusTimes=GlobalData.surplusTimes-1;
	curDirString =GetDirection (bankerId);
	LeavedRoundNumText.text =tostring(GlobalData.surplusTimes)--刷新剩余局数
	if (not isFirstOpen) then
		btnActionScript =ButtonAction.New();
		InitPanel ();
		--InitArrayList ();
		avatarList [bankerId].main = true;
	end
	GlobalData.finalGameEndVo = null;
	GlobalData.mainUuid = avatarList[bankerId].account.uuid;
	InitArrayList ();
	curDirString =GetDirection (bankerId);
	playerItems [GetIndexByDir(curDirString)]:SetbankImgEnable (true);
	SetDirGameObjectAction();
	isFirstOpen = false;
	GlobalData.isOverByPlayer = false;
	mineList = sgvo.paiArray;--发牌
	UpateTimeReStart ();
	DisplayTouzi(sgvo.touzi, sgvo.gui);--显示骰子
	--displayGuiPai(sgvo.gui);
	SetAllPlayerReadImgVisbleToFalse ();
	InitMyCardListAndOtherCard (13,13,13);
	ShowLeavedCardsNumForInit();
	if (curDirString == DirectionEnum.Bottom) then
		--isSelfPickCard = true;
		GlobalData.isDrag = true;
	else
		--isSelfPickCard = false;
		GlobalData.isDrag = false;
	end
	local ruleStr = "";
	if (GlobalData.roomVo ~= nil and GlobalData.roomVo.roomType == 5) then
		if (GlobalData.roomVo.pingHu == true) then
			ruleStr=ruleStr .. "穷胡\n";
		end
		if (GlobalData.roomVo.baoSanJia == true) then
			ruleStr=ruleStr  .. "包三家\n";
		end
		if (GlobalDataScript.roomVo.gui == 2) then
			ruleStr=ruleStr  .. "带会儿\n";
		end
		if (GlobalDataScript.roomVo.jue == true) then
			ruleStr=ruleStr  .. "绝\n";
		end
		if (GlobalDataScript.roomVo.jiaGang == true) then
			ruleStr=ruleStr  .. "加钢\n";
		end
		if (GlobalDataScript.roomVo.duanMen == true and sgvo.duanMen) then
			ruleStr=ruleStr  .. "买断门\n";
		end
		if (GlobalDataScript.roomVo.jihu == true) then
			ruleStr=ruleStr  .. "鸡胡\n";
		end
		if (GlobalDataScript.roomVo.qingYiSe == true) then
			ruleStr=ruleStr  .. "清一色\n";
		end
		ruleText.text = ruleStr;
	end
	for i = 1,#playerItems do
		if(sgvo.jiaGang[i]) then
		playerItems[GetIndexByDir(GetDirection(i))].jiaGang.text = "加钢"
	else
		playerItems[GetIndexByDir(GetDirection(i))].jiaGang.text = ""
	end
end

local jiaGang = GameToolScript.boolArrToInt(sgvo.jiaGang);
PlayerPrefs.SetInt("jiaGang", jiaGang);
log("lua:jiaGang=" ..tostring(jiaGang));
end

local function CleanGameplayUI()
	canClickButtonFlag = true;
	--weipaiImg.transform.gameObject.SetActive(false);
	inviteFriendButton.transform.gameObject:SetActive(false);
	btnJieSan.gameObject:SetActive(false);
	ExitRoomButton.transform.gameObject:SetActive(false);
	live1.transform.gameObject:SetActive(true);
	live2.transform.gameObject:SetActive(true);
	--tab.transform.gameObject.SetActive(true);
	centerImage.transform.gameObject:SetActive(true);
	liujuEffectGame:SetActive(false);
	ruleText.text = "";
end

local function ShowLeavedCardsNumForInit()
	local roomCreateVo = GlobalData.roomVo;
	local hong =roomCreateVo.hong;
	local RoomType = roomCreateVo.roomType;
	if (RoomType == 1) then
		--转转麻将
		LeavedCardsNum = 108;
		if (hong) then
			LeavedCardsNum = 112;
		end
	elseif (RoomType == 2) then
		--划水麻将
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
		--盘锦麻将
		LeavedCardsNum = 108;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 136;
		end
	elseif (RoomType == 6) then
		--无锡麻将
		LeavedCardsNum = 116;
		if (roomCreateVo.addWordCard) then
			LeavedCardsNum = 144;
		end
		LeavedCardsNum = LeavedCardsNum - 53;
		LeavedCastNumText.text = tostring(LeavedCardsNum);
	end
end

local function CardsNumChange()
	LeavedCardsNum=LeavedCardsNum-1;
	if (LeavedCardsNum < 0)then
		LeavedCardsNum = 0;
	end
	LeavedCastNumText.text =tostring(LeavedCardsNum);
end
--别人摸牌通知
local function OtherPickCard(response)
	UpateTimeReStart ();
	local json = json.decode(response.message);
	--下一个摸牌人的索引
	local avatarIndex =json["avatarIndex"];
	log ("GamePanelCtrl.OtherPickCard:otherPickCard avatarIndex = "..tostring(avatarIndex));
	OtherPickCardAndCreate(avatarIndex);
	SetDirGameObjectAction ();
	CardsNumChange();
	GlobalData.isChiState = false;
end
local function OtherPickCardAndCreate(avatarIndex)
	local myIndex = GetMyIndexFromList();
	local seatIndex = avatarIndex - myIndex;
	if (seatIndex < 0) then
		seatIndex = 4 + seatIndex;
	end
	curDirString = playerItems[seatIndex].dir;
	OtherMoPaiCreateGameObject(curDirString);
end

local function GetMyIndexFromList()
	
end

local function OtherMoPaiCreateGameObject()
	local tempVector3 =Vector3.zero;
	local switch = {
	DirectionEnum.Top=Vector3.New(-273, 0f),
	DirectionEnum.Left=Vector3.New(0, -173f),
	DirectionEnum.Right= Vector3.New(0, 183f)
	}
	tempVector3=switch[dir]
	local path = "Assets/Project/Prefabs/card/Bottom_" + dir;
	--实例化当前摸的牌
	otherPickCardItem = CreateGameObjectAndReturn (path,parentList[GetIndexByDir(dir)],tempVector3);
	otherPickCardItem.transform.localScale = Vector3.one;
end

local function PickCard(response)
	UpateTimeReStart();
	local cardvo = json.decode(response.message);
	MoPaiCardPoint = cardvo.cardPoint;
	log("GamePanelCtrl:PickCard:摸牌" ..tostring(MoPaiCardPoint));
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
	log("GamePanelCtrl ActionBtnShow:msg ="..tostring(response.message));
	local strs =string.split(response.message,',')
	if (curDirString == DirectionEnum.Bottom) then
		passType = "selfPickCard";
	else
		passType = "otherPickCard";
	end
	btnActionScript.showBtn(5);
	for i = 1,#strs do
		if string.match(strs[i],"hu") then
			btnActionScript.showBtn(1);
			passStr=passStr.."hu_"
		end
		if string.match(strs[i],"qianghu") then
			SelfAndOtherPutoutCard = string.split(str[i],':')[2]
			btnActionScript.showBtn(1);
			isQiangHu = true;
			passStr=passStr.."qianghu_"
		end
		if string.match(strs[i],"peng") then
			btnActionScript.showBtn(3);
			putOutCardPoint = string.split(str[i],':')[3]
			passStr=passStr.."peng_"
		end
		if string.match(strs[i],"gang") then
			btnActionScript.showBtn(2);
			gangPaiList = string.split(str[i],':');
			table.remove(gangPaiList,1)
			passStr=passStr.."gang_"
		end
		if string.match(strs[i],"chi") then
			--格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			--eg:"chi:1:2|1_2_3|2_3_4"
			GlobalData.isChiState = true;
			local strChi =string.split(str[i],'|');
			putOutCardPoint = string.split(str[1],':')[3];
			chiPaiPointList={};
			for m = 2,#strChi do
				local strChiList =string.split(str[i],'_');
				local cpoint ={};
				cpoint.putCardPoint = putOutCardPoint;
				for n = 1,#strChiList do
					if (strChiList[n]== putOutCardPoint) then
						table.remove(strChiList,n)
					end
					cpoint.oneCardPoint=strChiList[1]
					cpoint.twoCardPoint=strChiList[2]
					chiPaiPointList.Add(cpoint);
				end
				btnActionScript.showBtn(4);
				passStr=passStr.."chi_"
			end
		end
	end
end

--手牌排序，鬼牌移到最前
local function SortMyCardList()
	local guipaiList={};
	for k,v in pairs(handerCardList[1]) do
		if (v ~= nil) then
			if (v.BottomScript.GetPoint() == GlobalData.roomVo.guiPai) then
				guipaiList.Add(v);--鬼牌
				handerCardList[1][k]=nil
			end
		end
	end
	table.sort(handerCardList[1])
	for k,v in pairs(guipaiList) do
		table.insert(handerCardList[1],0,v)
	end
end
--初始化手牌
local function InitMyCardListAndOtherCard(topCount,leftCount,rightCount)
	for i = 1,#mineList[1].Count do --我的牌13张
		if (mineList[1][i] > 0) then
			for j = 1,#mineList[1][i] do
				local gob = resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function()
					if (gob ~= nil) then
						gob.transform.SetParent(parentList[0]);
						gob.transform.localScale =Vector3.New(1.1f,1.1f,1);
						gob.bottomScript=BottomScript.New();
						gob.bottomScript.onSendMessage = CardChange;
						gob.bottomScript.reSetPoisiton = CardSelect;
						gob.bottomScript.setPoint(i, GlobalData.roomVo.guiPai);
						SetPosition(false);
						handerCardList[1].Add(gob);
					else
						log("GamePanelCtrl InitMyCardListAndOtherCard:"..tostring(i).."is null");//游戏对象为空
					end
				end)
			end
			SortMyCardList ();
		end
	end
	InitOtherCardList (DirectionEnum.Left,leftCount);
	InitOtherCardList (DirectionEnum.Right,rightCount);
	InitOtherCardList (DirectionEnum.Top,topCount);
	if (bankerId == GetMyIndexFromList()) then
		SetPosition(true);//设置位置
		--checkHuPai();
	else
		SetPosition(false);
		OtherPickCardAndCreate(bankerId);
	end
end
local function SetAllPlayerReadImgVisbleToFalse()
	for _,v in pairs(playerItems) do
		v.readyImg.enabled = false;
	end
end
local function SetAllPlayerHuImgVisbleToFalse()
	for _,v in pairs(playerItems) do
		v:SetHuFlagHidde() = false;
	end
end

local function GetIndexByDir(dir)
	local result = 0;
	local switch=
	{
	DirectionEnum.Top=3,
	DirectionEnum.Left=4,
	DirectionEnum.Right=2,
	DirectionEnum.Bottom=1
	}
	result=switch[dir]
	return result;
end

--初始化其他人的手牌
local function InitOtherCardList(initDiretion,count)
	for (int i = 0; i < count; i++) do
		local temp = ('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function --实例化当前牌
		if (temp ~= nil) then--有可能没牌了
			temp.transform:SetParent(parentList[GetIndexByDir(initDiretion)]);
			temp.transform.localScale = Vector3.one;
			local switch={
			DirectionEnum.Top = function()
				temp.transform.localPosition = Vector3.New(-204 + 38 * i, 0);
				handerCardList[3].Add(temp);
				temp.transform.localScale = Vector3.one; //原大小
			end
			DirectionEnum.Left = function()
				temp.transform.localPosition = Vector3.New(0, -105 + i * 30);
				temp.transform.SetSiblingIndex(0);
				handerCardList[4].Add(temp);
			end
			DirectionEnum.Right=function()
				temp.transform.localPosition = Vector3.New(0, 119 - i * 30);
				handerCardList[2].Add(temp);
			end
			}
			switch[initDiretion]();
		end
	end)
end
end

--摸牌
local function MoPai()
	pickCardItem=resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/card/Bottom_B.prefab'},function()
		log ("GamePanelCtrl MoPai:"..tostring(MoPaiCardPoint));
		if (pickCardItem ~= nil) then //有可能没牌了
			pickCardItem.name = "pickCardItem";
			pickCardItem.transform.SetParent(parentList[0]); --父节点
			pickCardItem.transform.localScale = Vector3.New(1.1f,1.1f,1);--原大小
			pickCardItem.transform.localPosition =Vector3.New(580f, -292f); --位置
			pickCardItem.bottomScript=BottomScript.New()
			pickCardItem.bottomScript.onSendMessage = cardChange;
			pickCardItem.bottomScript.reSetPoisiton = cardSelect;
			pickCardItem.bottomScript:PsetPoint(MoPaiCardPoint, GlobalData.roomVo.guiPai);
			insertCardIntoList(pickCardItem);
		end
	end)
end
function putCardIntoMineList(cardPoint)
	if (mineList[1][cardPoint] < 4) then
		mineList[1][cardPoint]++;
	end
end
function pushOutFromMineList(cardPoint)
	if (mineList[1][cardPoint] > 0) then
		mineList[1][cardPoint]--;
	end
end
--接收到其它人的出牌通知
local function OtherPutOutCard(response)
	local json = json.decode(response.message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex =json["curAvatarIndex"];
	putOutCardPointAvarIndex = GetIndexByDir(GetDirection(curAvatarIndex));
	log("otherPickCard avatarIndex = " ..tostring(curAvatarIndex));
	useForGangOrPengOrChi = cardPoint;
	if (otherPickCardItem ~=nil) then
		local dirIndex = GetIndexByDir(GetDirection(curAvatarIndex));
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, otherPickCardItem.transform.position);
		Destroy(otherPickCardItem);
		otherPickCardItem = nil;
	else
		local dirIndex = GetIndexByDir(GetDirection(curAvatarIndex));
		local obj = handerCardList[dirIndex][1];
		CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, obj.transform.position);
		table.remove(handerCardList[dirIndex],1)
		Destroy(obj)
	end
	--createPutOutCardAndPlayAction(cardPoint, curAvatarIndex);
	GlobalData.isChiState = false;
end
--创建打来的的牌对象，并且开始播放动画
local function CreatePutOutCardAndPlayAction(cardPoint,curAvatarIndex,position)
	soundMgr:playSound (cardPoint,avatarList[curAvatarIndex].account.sex);
	local tempVector3 =Vector3.zero;
	local destination =Vector3.zero;
	local path = "";
	local Dir = GetDirection(curAvatarIndex);
	local switch=
	{
	DirectionEnum.Bottom=function()
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		tempVector3 = Vector3.New(0, -100);
		destination =  Vector3.New(-261 + tableCardList[0].Count % 14 * 37, (int)(tableCardList[0].Count / 14) * 67);
	end
	DirectionEnum.Right=function()
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		tempVector3 =  Vector3.New(420f, 0);
		destination =  Vector3.New((-tableCardList[1].Count / 13 * 54f), -180 + tableCardList[1].Count % 13 * 28);
	end
	DirectionEnum.Top=function()
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		tempVector3 = Vector3.New(0, 130);
		destination =  Vector3.New(289f - tableCardList[2].Count % 14 * 37, -(int)(tableCardList[2].Count / 14) * 67);
	end
	DirectionEnum.Left=function()
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		tempVector3 =  Vector3.New(-370, 0);
		destination =  Vector3.New(tableCardList[3].Count / 13 * 54, 152 - tableCardList[3].Count % 13 * 28);
	end
	}
	switch[Dir]()
	local tempGameObject = CreateGameObjectAndReturn(path, parentList[0], tempVector3);
	tempGameObject.transform.position = position;
	tempGameObject.name = "putOutCard";
	tempGameObject.transform.localScale = Vector3.one;
	tempGameObject.transform.parent = outparentList[GetIndexByDir(Dir)];
	if (Dir == DirectionEnum.Right || Dir == DirectionEnum.Left) then
		tempGameObject.TopAndBottomCardScript=TopAndBottomCardScript.New()
		tempGameObject.TopAndBottomCardScript.SetLefAndRightPoint(cardPoint);
		if(Dir == DirectionEnum.Right) then
		tempGameObject.transform:SetAsFirstSibling();
	end
else
	tempGameObject.TopAndBottomCardScript=TopAndBottomCardScript.New()
	tempGameObject.TopAndBottomCardScript.SetPoint(cardPoint);
end
putOutCardPoint = cardPoint;
SelfAndOtherPutoutCard = cardPoint;
putOutCard = tempGameObject;
local tweener = tempGameObject.transform:DOLocalMove(destination,1).OnComplete(
function()
	DestroyPutOutCard(cardPoint, Dir);
	if (putOutCard != null) then
		Destroy(putOutCard, 1f);
	end
end);
if (Dir != DirectionEnum.Bottom) then
	tweener.SetEase(Ease.OutExpo);
else
	tweener.SetEase(Ease.OutExpo);
end
end

--根据一个人在数组里的索引，得到这个人所在的方位，L-左，T-上,R-右，B-下（自己）
local function GetDirection()
	local result = DirectionEnum.Bottom;
	local myselfIndex = GetMyIndexFromList();
	if (myselfIndex == avatarIndex) then
		--log ("getDirection == B");
		return result;
	end
	--从自己开始计算，下一位的索引
	for i = 1,4 do
		myselfIndex=myselfIndex+1;
		if (myselfIndex >= 5) then
			myselfIndex = 1;
		end
		if (myselfIndex == avatarIndex) then
			if (i == 1) then
				--log ("getDirection == R");
				return DirectionEnum.Right;
			elseif (i == 2)
				--log ("getDirection == T");
				return DirectionEnum.Top;
			else
				--log ("getDirection == L");
				return DirectionEnum.Left;
			end
		end
		return result;
	end
end


-- 设置红色箭头的显示方向
function SetDirGameObjectAction() --设置方向
	--UpateTimeReStart();
	for i = 1,#dirGameList do
		dirGameList [i]:SetActive (false);
	end
	dirGameList[GetIndexByDir(curDirString)]:SetActive(true);
end

local function ThrowBottom(index,Dir)
	local temp = null;
	local path = "";
	local poisVector3 = Vector3.one;
	log("put out huaPaiPoint"..tostring(index).."---ThrowBottom---");
	if (Dir == DirectionEnum.Bottom) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(-261 + tableCardList[0].Count%14*37, (int)(tableCardList[0].Count/14)*67);
		GlobalDataScript.isDrag = false;
	elseif (Dir == DirectionEnum.Right) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		poisVector3 = Vector3.New((-tableCardList[1].Count/13*54), -180 + tableCardList[1].Count%13*28);
	elseif (Dir == DirectionEnum.Top) then
		path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(289 - tableCardList[2].Count%14*37, -(int)(tableCardList[2].Count/14)*67);
	elseif (Dir == DirectionEnum.Left) then
		path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		poisVector3 = Vector3.New(tableCardList[3].Count/13*54, 152 - tableCardList[3].Count%13*28);
		--parenTransform = leftOutParent;
	end
	temp = CreateGameObjectAndReturn (path,outparentList[getIndexByDir(Dir)],poisVector3);
	temp.transform.localScale = Vector3.one;
	temp.TopAndBottomCardScript=TopAndBottomCardScript.New()
	if (Dir == DirectionEnum.Right || Dir == DirectionEnum.Left) then
		temp.TopAndBottomCardScript:setLefAndRightPoint(index);
	else
		temp.TopAndBottomCardScript:setPoint(index);
	end
	cardOnTable = temp;
	--temp.transform.SetAsLastSibling();
	table.insert(tableCardList[GetIndexByDir(Dir)],temp)
	if (Dir == DirectionEnum.Right) then
		temp.transform.SetSiblingIndex(0);
	end
	--丢牌上?
	--顶针下?
	SetPointGameObject(temp);
end

local function OtherPeng()
	
end

local function SetPointGameObject()
	
end

local function DestroyPutOutCard()
	
end

local function CardChange()
	
end

local function SetPosition()
	
end

local function PutCardIntoMineList()
	
end



local function CreateGameObjectAndReturn()
	--resMgr:LoadPrefab('prefabs', {'Assets/Project/Prefabs/TipPanel.prefab'}, this.OnCreateTipPanel);
end

local function ReEnterRoom()
	
end

local function JoinToRoom()
	
end

local function CreateRoomAddAvatarVO()
	
end

local function InitbtnJieSan()
	
end

local function OtherUserJointRoom()
	
end



local function OtherChi()
	
end

local function GangResponse()
	
end

local function OtherGang()
	
end

local function HupaiCallBack()
	
end

local function OutRoomCallbak()
	
end

local function DissoliveRoomResponse()
	
end

local function GameReadyNotice()
	
end

local function OfflineNotice()
	
end

local function MessageBoxNotice()
	
end

local function ReturnGameResponse()
	
end

local function OnlineNotice()
	
end

local function MicInputNotice()
	
end

local function GameFollowBanderNotice()
	
end

local function OnChipSelect(obj,isSelected)
	
end



local function SetDirGameObjectAction()
	
end

local function UpateTimeReStart()
	
end

local function DisplayTouzi()
	
end

local function SetAllPlayerReadImgVisbleToFalse()
	
end



------------------------------------------------------------
--关闭面板--
function GamePanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

--移除事件--
function GamePanelCtrl.RemoveListener()
	SocketEventHandle.getInstance().StartGameNotice       =nil;
	SocketEventHandle.getInstance().pickCardCallBack      =nil
	SocketEventHandle.getInstance().otherPickCardCallBack =nil
	SocketEventHandle.getInstance().putOutCardCallBack    =nil
	SocketEventHandle.getInstance().otherUserJointRoomCallBack = nil
	SocketEventHandle.getInstance().PengCardCallBack = nil;
	SocketEventHandle.getInstance().ChiCardCallBack  = nil
	SocketEventHandle.getInstance().GangCardCallBack = nil
	SocketEventHandle.getInstance().gangCardNotice =nil
	SocketEventHandle.getInstance ().btnActionShow =nil
	SocketEventHandle.getInstance ().HupaiCallBack =nil
	--SocketEventHandle.getInstance ().FinalGameOverCallBack -= finalGameOverCallBack;
	SocketEventHandle.getInstance ().outRoomCallback =nil
	SocketEventHandle.getInstance ().dissoliveRoomResponse =nil
	SocketEventHandle.getInstance ().gameReadyNotice =nil
	SocketEventHandle.getInstance ().offlineNotice =nil
	SocketEventHandle.getInstance().onlineNotice =nil
	SocketEventHandle.getInstance ().messageBoxNotice =nil
	SocketEventHandle.getInstance ().returnGameResponse =nil
	--CommonEvent.getInstance ().readyGame -= markselfReadyGame;
	SocketEventHandle.getInstance ().micInputNotice =nil
	SocketEventHandle.getInstance ().gameFollowBanderNotice =nil
	Event.RemoveListener(closeGamePanel,this.ExitOrDissoliveRoom)
end

--打开面板--
function GamePanelCtrl.Open()
	if(gameObject) then
	gameObject:SetActive(true)
	transform:SetAsLastSibling();
	this.AddListener()
end
end
--增加事件--
function GamePanelCtrl.AddListener()
	SocketEventHandle.getInstance().StartGameNotice =StartGame;
	SocketEventHandle.getInstance().pickCardCallBack =PickCard;
	SocketEventHandle.getInstance().otherPickCardCallBack =OtherPickCard;
	SocketEventHandle.getInstance().putOutCardCallBack =OtherPutOutCard;
	SocketEventHandle.getInstance().otherUserJointRoomCallBack =OtherUserJointRoom;
	SocketEventHandle.getInstance().PengCardCallBack =OtherPeng;
	SocketEventHandle.getInstance().ChiCardCallBack =OtherChi;
	SocketEventHandle.getInstance().GangCardCallBack =GangResponse;
	SocketEventHandle.getInstance().gangCardNotice =OtherGang;
	SocketEventHandle.getInstance ().btnActionShow =ActionBtnShow;
	SocketEventHandle.getInstance ().HupaiCallBack = HupaiCallBack;
	--SocketEventHandle.getInstance ().FinalGameOverCallBack =this.FinalGameOverCallBack;
	SocketEventHandle.getInstance ().outRoomCallback =OutRoomCallbak;
	SocketEventHandle.getInstance ().dissoliveRoomResponse =DissoliveRoomResponse;
	SocketEventHandle.getInstance ().gameReadyNotice = GameReadyNotice;
	SocketEventHandle.getInstance ().offlineNotice = OfflineNotice;
	SocketEventHandle.getInstance ().messageBoxNotice = MessageBoxNotice;
	SocketEventHandle.getInstance ().returnGameResponse = ReturnGameResponse;
	SocketEventHandle.getInstance().onlineNotice = OnlineNotice;
	--CommonEvent.getInstance ().readyGame = this.MarkselfReadyGame;
	SocketEventHandle.getInstance ().micInputNotice = MicInputNotice;
	SocketEventHandle.getInstance ().gameFollowBanderNotice = GameFollowBanderNotice;
	Event.AddListener(closeGamePanel,this.ExitOrDissoliveRoom)
end