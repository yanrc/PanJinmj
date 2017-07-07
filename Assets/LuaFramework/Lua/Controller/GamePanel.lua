
local Ease = DG.Tweening.Ease
GamePanel = UIBase(define.GamePanel, define.FixUI)
local this = GamePanel;
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
-- local mineList
-- 手牌列表，二维，自己存的是table,其他人存的是gameObject
-- 0自己，1-右边。2-上边。3-左边
this.handerCardList = { }
-- 打在桌上的牌,gameObject
local tableCardList
-- 吃碰杠list
local PengGangList_L
local PengGangList_R
local PengGangList_T
local PengGangList_B
--
local avatarList
local bankerIndex-- 庄家index
local LeavedRoundNumText
local isFirstOpen
local ruleText
-- 能否申请退出房间，初始为false，开始游戏置true
this.isGameStarted = false
local inviteFriendButton
local btnJieSan
local ExitRoomButton
local live1
local live2
local centerImage
local ruleText
local LeavedCastNumText
local SelfAndOtherPutoutCard
local useForGangOrPengOrChi
local passStr = ""
local chiPaiPointList
local LeavedCardsNum = 0 -- 剩余牌数
local pickCardItem-- 自己摸的牌
local otherPickCardItem-- 别人摸的牌,gameobject
local passType-- “过”操作字符串
local guiObj-- 翻开的鬼牌
local roomRemark-- 房间显示的规则
local ReadySelect = { } -- 游戏准备时的选择
local btnReadyGame
local timer = 0
local noticeGameObject-- 滚动消息
local dialog_fanhui_text-- 离开房间面板上的文字
local Number-- 桌子中间显示的数字（剩余时间）
local touziObj-- 骰子
local dirGameList = { }-- 桌面指示灯
local cardOnTable-- 当前打在桌上的牌,gameobject
local parentList = { }-- 手牌的父对象
local cpgParent = { }-- 吃碰杠牌的父对象
local Dir = { "B", "R", "T", "L" }
local CurLocalIndex;-- 当前操作位
local btnSetting-- 设置按钮
local outparentList = { }-- 出牌的父对象
-- 指针
local Pointertemp = nil
-- 手牌模板
local Bottom_B = nil
local Bottom_R = nil
local Bottom_T = nil
local Bottom_L = nil
-- 桌牌模板（上下）
local TopAndBottomCard = nil
-- 桌牌模板(右)
local ThrowCard_R = nil
-- 桌牌模板（左）
local ThrowCard_L = nil
-- 吃碰杠牌模板
local PengGangCard_B
local PengGangCard_R
local PengGangCard_T
local PengGangCard_L
-- 暗杠牌模板
local gangBack
local GangBack_LR
local GangBack_T
-- 吃碰杠胡特效
local chiEffectGame
local pengEffectGame
local gangEffectGame
local huEffectGame
local liujuEffectGame
-- 保存服务器杠按钮通知的牌值
local gangPaiList
-- 保存打出牌和吃碰杠牌的牌值，点击按钮使用
local putOutCardPoint
-- 保存吃牌时的三套牌
local canChiList = { }
local LastAvarIndex = 1
function GamePanel.OnCreate(go)
	gameObject = go;
	transform = go.transform
	this:Init(go)

	versionText = transform:FindChild('Text_version'):GetComponent('Text');
	btnActionScript = ButtonAction.New(transform);
	dialog_fanhui = transform:FindChild('jiesan')
	LeavedRoundNumText = transform:FindChild('Leaved1/Text'):GetComponent('Text');
	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	inviteFriendButton = transform:FindChild('Button_invite_friend'):GetComponent('Button');
	btnJieSan = transform:FindChild('Button_jiesan').gameObject;
	ExitRoomButton = transform:FindChild('Button_other'):GetComponent('Button');
	live1 = transform:FindChild('Leaved'):GetComponent('Image');
	live2 = transform:FindChild('Leaved1'):GetComponent('Image');
	centerImage = transform:FindChild('table'):GetComponent('Image');

	chiEffectGame = transform:FindChild('ChiEffect_B').gameObject
	pengEffectGame = transform:FindChild('PengEffect_B').gameObject
	gangEffectGame = transform:FindChild('GangEffect_B').gameObject
	huEffectGame = transform:FindChild('HuEffect_B').gameObject
	liujuEffectGame = transform:FindChild('Liuju_B').gameObject

	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	LeavedCastNumText = transform:FindChild('Leaved/Text'):GetComponent('Text');
	guiObj = transform:FindChild('gui').gameObject
	roomRemark = transform:FindChild('Text'):GetComponent('Text')
	local players = transform:FindChild('playList')
	dirGameList[1] = transform:FindChild('table/Down/Red1').gameObject
	dirGameList[2] = transform:FindChild('table/Right/Red2').gameObject
	dirGameList[3] = transform:FindChild('table/Up/Red3').gameObject
	dirGameList[4] = transform:FindChild('table/Left/Red4').gameObject
	playerItems[1] = PlayerItem.New(players:FindChild('Player_B').gameObject)
	playerItems[2] = PlayerItem.New(players:FindChild('Player_R').gameObject)
	playerItems[3] = PlayerItem.New(players:FindChild('Player_T').gameObject)
	playerItems[4] = PlayerItem.New(players:FindChild('Player_L').gameObject)
	ReadySelect[1] = transform:FindChild('Panel/DuanMen'):GetComponent('Toggle')
	ReadySelect[2] = transform:FindChild('Panel/Gang'):GetComponent('Toggle')
	parentList[1] = transform:FindChild('handparent/Bottom')
	parentList[2] = transform:FindChild('handparent/Right')
	parentList[3] = transform:FindChild('handparent/Top')
	parentList[4] = transform:FindChild('handparent/Left')
	cpgParent[1] = transform:FindChild('cpgParent/PenggangListB')
	cpgParent[2] = transform:FindChild('cpgParent/PenggangListR')
	cpgParent[3] = transform:FindChild('cpgParent/PenggangListT')
	cpgParent[4] = transform:FindChild('cpgParent/PenggangListL')
	outparentList[1] = transform:FindChild('ThrowCardsParent/ThrowCardsListBottom')
	outparentList[2] = transform:FindChild('ThrowCardsParent/ThrowCardsListRight')
	outparentList[3] = transform:FindChild('ThrowCardsParent/ThrowCardsListTop')
	outparentList[4] = transform:FindChild('ThrowCardsParent/ThrowCardsListLeft')
	btnReadyGame = transform:FindChild('Panel/Button').gameObject
	Number = transform:FindChild('table/Number'):GetComponent('Text')
	noticeGameObject = transform:FindChild("Image_Notice_BG").gameObject
	dialog_fanhui_text = transform:FindChild('jiesan/Image_Bg/tip_text'):GetComponent('Text')
	btnSetting = transform:FindChild('soundClose').gameObject
	this.lua:AddClick(dialog_fanhui:FindChild('Image_Bg/Button_Sure').gameObject, this.Tuichu)
	this.lua:AddClick(dialog_fanhui:FindChild('Image_Bg/Button_Cancle').gameObject, this.Quxiao)
	this.lua:AddClick(btnSetting, this.OpenGameSettingDialog)
	touziObj = transform:FindChild('Panel_touzi').gameObject
	canChiList[1] = transform:FindChild('ChiList/list_1').gameObject
	canChiList[2] = transform:FindChild('ChiList/list_2').gameObject
	canChiList[3] = transform:FindChild('ChiList/list_3').gameObject
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Pointer.prefab" }, function(prefabs) Pointertemp = newObject(prefabs[0]) end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function(prefabs) Bottom_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_R.prefab' }, function(prefabs) Bottom_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_T.prefab' }, function(prefabs) Bottom_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_L.prefab' }, function(prefabs) Bottom_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard.prefab" }, function(prefabs) TopAndBottomCard = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_R.prefab" }, function(prefabs) ThrowCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/ThrowCard/ThrowCard_L.prefab" }, function(prefabs) ThrowCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_B.prefab" }, function(prefabs) PengGangCard_B = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_R.prefab" }, function(prefabs) PengGangCard_R = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_T.prefab" }, function(prefabs) PengGangCard_T = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/PengGangCard_L.prefab" }, function(prefabs) PengGangCard_L = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/gangBack.prefab" }, function(prefabs) gangBack = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_L&R.prefab" }, function(prefabs) GangBack_LR = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/PengGangCard/GangBack_T.prefab" }, function(prefabs) GangBack_T = prefabs[0] end)
end


function GamePanel.RandShowTime()
	showTimeNumber = math.random(5000, 10000)
end

function GamePanel.InitPanel()
	this.Clean()
	btnActionScript.CleanBtnShow()
end

function GamePanel.InitArrayList()
	-- mineList = { }
	this.handerCardList = { }
	tableCardList = { }
	for i = 1, 4 do
		this.handerCardList[i] = { }
		tableCardList[i] = { }
	end
	PengGangList_L = { };
	PengGangList_R = { };
	PengGangList_T = { };
	PengGangList_B = { };
	gangPaiList = { }
end

function GamePanel.CardSelect(objCtrl)
	for k, v in pairs(this.handerCardList[1]) do
		if v == nil then
			table.remove(this.handerCardList[1], k)
		else
			this.handerCardList[1][k].gameObject.transform.localPosition = Vector3.New(this.handerCardList[1][k].transform.localPosition.x, -292);
			-- 从右到左依次对齐
			this.handerCardList[1][k].selected = false;
		end
	end
	if (objCtrl ~= nil) then
		objCtrl.gameObject.transform.localPosition = Vector3.New(objCtrl.transform.localPosition.x, -272);
		objCtrl.selected = true;
	end
end

function GamePanel.StartGame(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	GlobalData.roomAvatarVoList = avatarList;
	-- GlobalData.surplusTimes -= 1;
	local sgvo = json.decode(message);
	bankerIndex = sgvo.bankerId;
	GlobalData.roomVo.guiPai = sgvo.gui;
	this.CleanGameplayUI();
	-- 开始游戏后不显示
	log("lua:GamePanel.StartGame");
	GlobalData.surplusTimes = GlobalData.surplusTimes - 1;
	LeavedRoundNumText.text = tostring(GlobalData.surplusTimes)
	-- 刷新剩余局数
	if (not isFirstOpen) then
		this.InitPanel();
		-- this.InitArrayList ();
		avatarList[bankerIndex + 1].main = true;
	end
	GlobalData.finalGameEndVo = nil;
	GlobalData.mainUuid = avatarList[bankerIndex + 1].account.uuid;
	this.InitArrayList();
	local LocalIndex = this.GetLocalIndex(bankerIndex);
	playerItems[LocalIndex]:SetBankImg(true);
	this.SetDirGameObjectAction(LocalIndex);
	isFirstOpen = false;
	GlobalData.isOverByPlayer = false;
	-- mineList = sgvo.paiArray;
	-- 发牌
	this.UpateTimeReStart();
	this.DisplayTouzi(sgvo.touzi, sgvo.gui);
	-- 显示骰子
	-- this.DisplayGuiPai(sgvo.gui);
	this.SetAllPlayerReadImgVisbleToFalse();
	this.InitMyCardListAndOtherCard(sgvo.paiArray, 13, 13, 13);
	this.ShowLeavedCardsNumForInit();
	if (LocalIndex == 1) then
		-- isSelfPickCard = true;
		GlobalData.isDrag = true;
	else
		-- isSelfPickCard = false;
		GlobalData.isDrag = false;
	end
	this.ShowRuleText(roomVo)
	for i = 1, #playerItems do
		if (sgvo.jiaGang[i]) then
			playerItems[this.GetLocalIndex(i)].jiaGang.text = "加钢"
		else
			playerItems[this.GetLocalIndex(i)].jiaGang.text = ""
		end
	end

	local jiaGang = GameToolScript.boolArrToInt(sgvo.jiaGang);
	PlayerPrefs.SetInt("jiaGang", jiaGang);
	log("lua:jiaGang=" .. tostring(jiaGang));
end

function GamePanel.ShowRuleText()
	if (roomVo ~= nil and roomVo.roomType == 7) then
		local ruleStr = "";
		if (roomVo.menqing) then
			ruleStr = ruleStr .. "闭门胡\n";
		end
		if (roomVo.siguiyi) then
			ruleStr = ruleStr .. "四归一杠翻\n";
		end
		if (roomVo.baoSanJia) then
			ruleStr = ruleStr .. "包三家\n";
		end
		ruleText.text = ruleStr;
	end
	if (roomVo ~= nil and roomVo.roomType == 8)
	then
		local ruleStr = "";
		if (roomVo.mayou > 0) then
			ruleStr = ruleStr .. "滴麻油\n";
		end
		if (roomVo.piaofen > 0) then
			ruleStr = ruleStr .. "捆买\n";
		end
		if (roomVo.gui == 2) then
			ruleStr = ruleStr .. "红中赖子\n";
		end
		ruleText.text = ruleStr;
	end
	if (roomVo ~= nil and roomVo.roomType == 3) then
		local ruleStr = "";
		if (roomVo.zhuangxian == true) then
			ruleStr = ruleStr .. "庄闲模式\n";
		end
		if (roomVo.ma > 0) then
			ruleStr = ruleStr .. "扎鸟\n";
		end
		ruleText.text = ruleStr;
	end
end

function GamePanel.CleanGameplayUI()
	log("GamePanel.CleanGameplayUI")
	this.isGameStarted = true;
	-- weipaiImg.transform.gameObject:SetActive(false);
	inviteFriendButton.transform.gameObject:SetActive(false);
	btnJieSan:SetActive(false);
	ExitRoomButton.transform.gameObject:SetActive(false);
	live1.transform.gameObject:SetActive(true);
	live2.transform.gameObject:SetActive(true);
	-- tab.transform.gameObject:SetActive(true);
	centerImage.transform.gameObject:SetActive(true);
	liujuEffectGame:SetActive(false);
	ruleText.text = "";
end

function GamePanel.ShowLeavedCardsNumForInit()
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

function GamePanel.CardsNumChange()
	LeavedCardsNum = LeavedCardsNum - 1;
	if (LeavedCardsNum < 0) then
		LeavedCardsNum = 0;
	end
	LeavedCastNumText.text = tostring(LeavedCardsNum);
end
-- 别人摸牌通知
function GamePanel.OtherPickCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	this.UpateTimeReStart();
	local json = json.decode(message);
	-- 下一个摸牌人的索引
	local avatarIndex = json["avatarIndex"];
	log("GamePanel.OtherPickCard:otherPickCard avatarIndex = " .. tostring(avatarIndex));
	local LocalIndex = this.GetLocalIndex(avatarIndex)
	-- 保存其他玩家的摸牌对象
	otherPickCardItem = this.OtherMoPaiCreateGameObject(LocalIndex);
	this.SetDirGameObjectAction(LocalIndex);
	this.CardsNumChange();
	GlobalData.isChiState = false;
end

function GamePanel.OtherMoPaiCreateGameObject(LocalIndex)
	local tempVector3 = Vector2.zero;
	local prefab = nil
	local switch = {
		[2] = function() prefab = Bottom_R return Vector2.New(0, 183) end,
		[3] = function() prefab = Bottom_T return Vector2.New(-273, 0) end,
		[4] = function() prefab = Bottom_L return Vector2.New(0, -173) end
	}
	tempVector3 = switch[LocalIndex]()
	local obj = newObject(prefab)
	obj.transform:SetParent(parentList[LocalIndex])
	obj.transform.localPosition = tempVector3
	obj.transform.localScale = Vector3.one;
	return obj
end

function GamePanel.PickCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	this.UpateTimeReStart();
	local cardvo = json.decode(message);
	local cardPoint = cardvo.cardPoint;
	SelfAndOtherPutoutCard = cardPoint;
	useForGangOrPengOrChi = cardPoint;
	-- this.PutCardIntoMineList(cardPoint);
	this.MoPai(cardPoint);
	this.SetDirGameObjectAction(1);
	this.CardsNumChange();
	GlobalData.isDrag = true;
end
-- 胡，杠，碰，吃，pass按钮显示.
function GamePanel.ActionBtnShow(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	GlobalData.isDrag = false;
	GlobalData.isChiState = false;
	log("GamePanel ActionBtnShow:msg =" .. tostring(message));
	local strs = string.split(message, ',')
	btnActionScript.ShowBtn(5, true);
	for i = 1, #strs do
		if string.match(strs[i], "hu") then
			btnActionScript.ShowBtn(1, true);
			passStr = passStr .. "hu_"
		end
		if string.match(strs[i], "qianghu") then
			SelfAndOtherPutoutCard = string.split(strs[i], ':')[2]
			btnActionScript.ShowBtn(1, true);
			isQiangHu = true;
			passStr = passStr .. "qianghu_"
		end
		if string.match(strs[i], "peng") then
			btnActionScript.ShowBtn(3, true);
			putOutCardPoint = string.split(strs[i], ':')[3]
			passStr = passStr .. "peng_"
		end
		if string.match(strs[i], "gang") then
			btnActionScript.ShowBtn(2, true);
			gangPaiList = string.split(strs[i], ':');
			table.remove(gangPaiList, 1)
			passStr = passStr .. "gang_"
		end
		if string.match(strs[i], "chi") then
			-- 格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			-- eg:"chi:1:2|1_2_3|2_3_4"
			GlobalData.isChiState = true;
			local strChi = string.split(strs[i], '|');
			putOutCardPoint = string.split(strChi[1], ':')[3];
			chiPaiPointList = { };
			for m = 2, #strChi do
				local strChiList = string.split(strChi[i], '_');
				local cpoint = { };
				cpoint.putCardPoint = putOutCardPoint;
				for n = 1, #strChiList do
					if (strChiList[n] == putOutCardPoint) then
						table.remove(strChiList, n)
					end
				end
				cpoint.oneCardPoint = strChiList[1]
				cpoint.twoCardPoint = strChiList[2]
				table.insert(chiPaiPointList, cpoint)
			end
			btnActionScript.ShowBtn(4, true);
			passStr = passStr .. "chi_"
		end
	end
	log(passStr)
end

-- 手牌排序，鬼牌移到最前
function GamePanel.SortMyCardList(point)
	table.sort(this.handerCardList[1],
	function(a, b)
		-- a是鬼牌
		if (a.CardPoint == GlobalData.roomVo.guiPai) then
			return true
			-- b是鬼牌，a不是
		elseif b.CardPoint == GlobalData.roomVo.guiPai then
			return false
			-- 都不是鬼牌，比较大小
		else
			return a.CardPoint < b.CardPoint
		end
	end )
	-- 最后摸的一张牌
	if (point ~= nil) then
		for i = 1, #this.handerCardList[1] do
			if this.handerCardList[1][i].CardPoint == point then
				local temp = this.handerCardList[1][i]
				table.remove(this.handerCardList[1], i)
				table.insert(this.handerCardList[1], temp)
				break
			end
		end
	end
end

-- 初始化手牌
function GamePanel.InitMyCardListAndOtherCard(mineList, topCount, leftCount, rightCount)
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function(prefabs)
		if (prefabs[0] ~= nil) then
			for i = 1, #mineList[1] do
				-- 我的牌13张
				if (mineList[1][i] > 0) then
					for j = 1, mineList[1][i] do
						local go = newObject(prefabs[0])
						go.transform:SetParent(parentList[1]);
						go.transform.localScale = Vector3.New(1.1, 1.1, 1);
						local objCtrl = BottomScript.New(go)
						objCtrl.OnSendMessage = this.CardChange;
						objCtrl.ReSetPoisiton = this.CardSelect;
						objCtrl:Init(i - 1, GlobalData.roomVo.guiPai == i);
						this.SetPosition();
						table.insert(this.handerCardList[1], objCtrl)
					end
				end
			end
			this.SortMyCardList();
		end
	end )
	this.InitOtherCardList(2, rightCount);
	this.InitOtherCardList(3, topCount);
	this.InitOtherCardList(4, leftCount);
	local LocalIndex = this.GetLocalIndex(bankerIndex);
	if (LocalIndex == 0) then
		this.SetPosition();
		-- 设置位置
		-- checkHuPai();
	else
		this.SetPosition();
		this.OtherMoPaiCreateGameObject(LocalIndex);
	end
end
function GamePanel.SetAllPlayerReadImgVisbleToFalse()
	for _, v in pairs(playerItems) do
		v:SetReadyImg(false)
	end
end
function GamePanel.SetAllPlayerHuImgVisbleToFalse()
	for _, v in pairs(playerItems) do
		v:SetHuFlag(false);
	end
end

-- 初始化其他人的手牌
function GamePanel.InitOtherCardList(LocalIndex, count)
	log("GamePanel.InitOtherCardList")
	local prefab = nil
	local switch = {
		[2] = function(i)
			prefab = Bottom_R
			return Vector2.New(0, 149 - i * 30)
		end,
		[3] = function(i)
			prefab = Bottom_T
			return Vector2.New(-242 + 38 * i, 0)
		end,
		[4] = function(i)
			prefab = Bottom_L
			return Vector2.New(0, -135 + i * 30);
		end,
	}
	-- 有可能没牌了
	for i = 1, count do
		local pos = switch[LocalIndex](i);
		-- 实例化当前牌
		local go = newObject(prefab)
		go.transform:SetParent(parentList[LocalIndex]);
		if (LocalIndex == 4) then
			go.transform:SetSiblingIndex(0)
		end
		go.transform.localScale = Vector3.one;
		go.transform.localPosition = pos
		table.insert(this.handerCardList[LocalIndex], go)
	end
end

-- 摸牌
function GamePanel.MoPai(cardPoint)
	log("GamePanel MoPai:" .. tostring(cardPoint));
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Bottom_B.prefab' }, function(prefabs)
		if (prefabs[0] ~= nil) then
			local go = newObject(prefabs[0])
			-- 有可能没牌了
			go.name = "pickCardItem";
			go.transform:SetParent(parentList[1]);
			-- 父节点
			go.transform.localScale = Vector3.New(1.1, 1.1, 1);
			-- 原大小
			go.transform.localPosition = Vector3.New(580, -292);
			-- 位置
			local objCtrl = BottomScript.New(go)
			objCtrl.OnSendMessage = this.CardChange;
			objCtrl.ReSetPoisiton = this.CardSelect;
			objCtrl:Init(cardPoint, GlobalData.roomVo.guiPai == cardPoint);
			this.InsertCardIntoList(objCtrl);
		end
	end )
end
-- function GamePanel.PutCardIntoMineList(cardPoint)
-- if (mineList[1][cardPoint] < 4) then
-- 	mineList[1][cardPoint] = mineList[1][cardPoint] + 1;
-- end
-- end
-- function GamePanel.PushOutFromMineList(cardPoint)
-- if (mineList[1][cardPoint] > 0) then
-- 	mineList[1][cardPoint] = mineList[1][cardPoint] -1;
-- end
-- end
-- 接收到其它人的出牌通知
function GamePanel.OtherPutOutCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local json = json.decode(message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex = json["curAvatarIndex"];
	log("otherPickCard avatarIndex = " .. tostring(curAvatarIndex));
	useForGangOrPengOrChi = cardPoint;
	local LocalIndex = this.GetLocalIndex(curAvatarIndex);
	LastAvarIndex = LocalIndex
	if (otherPickCardItem ~= nil) then
		this.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex + 1, otherPickCardItem.transform.position);
		destroy(otherPickCardItem);
		otherPickCardItem = nil;
	else
		local obj = this.handerCardList[LocalIndex][1];
		this.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex + 1, obj.transform.position);
		table.remove(this.handerCardList[LocalIndex], 1)
		destroy(obj)
	end
	-- this.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex+1);
	GlobalData.isChiState = false;
end
-- 创建打来的的牌对象，并且开始播放动画
-- curAvatarIndex:在avatarList里的下标
function GamePanel.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, position)
	log("GamePanel.CreatePutOutCardAndPlayAction")
	soundMgr:playSound(cardPoint, avatarList[curAvatarIndex].account.sex);
	local tempVector3 = Vector2.zero;
	local destination = Vector2.zero;
	local prefab = nil
	local LocalIndex = this.GetLocalIndex(curAvatarIndex - 1);
	local switch =
	{
		[1] = function()
			prefab = TopAndBottomCard
			tempVector3 = Vector2.New(0, -100);
			destination = Vector2.New(-261 + #tableCardList[1] % 14 * 37, math.modf(#tableCardList[1] / 14) * 67);
		end,
		[2] = function()
			prefab = ThrowCard_R
			tempVector3 = Vector2.New(420, 0);
			destination = Vector2.New((math.modf(#tableCardList[2] / 13) * -54), -180 + #tableCardList[2] % 13 * 28);
		end,
		[3] = function()
			prefab = TopAndBottomCard
			tempVector3 = Vector2.New(0, 130);
			destination = Vector2.New(289 - #tableCardList[3] % 14 * 37, math.modf(#tableCardList[3] / 14) * -67);
		end,
		[4] = function()
			prefab = ThrowCard_L
			tempVector3 = Vector2.New(-370, 0);
			destination = Vector2.New(math.modf(#tableCardList[4] / 13) * 54, 152 - #tableCardList[4] % 13 * 28);
		end
	}
	switch[LocalIndex]()
	local obj = newObject(prefab)
	obj.transform:SetParent(outparentList[LocalIndex])
	obj.transform.localPosition = tempVector3
	obj.transform.localScale = Vector3.one
	obj.name = "putOutCard";
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, LocalIndex, GlobalData.roomVo.guiPai == cardPoint);
	if (LocalIndex == 2) then
		obj.transform:SetAsFirstSibling();
	end
	putOutCardPoint = cardPoint;
	SelfAndOtherPutoutCard = cardPoint;
	-- putOutCard = obj;
	local go = this.ThrowBottom(cardPoint, LocalIndex, false)
	local tweener = obj.transform:DOLocalMove(destination, 1, false):OnComplete(
	function()
		if (obj ~= nil) then
			destroy(obj)
			objCtrl = nil
		end
		if (go ~= nil) then
			go:SetActive(true)
		end
	end );
	tweener:SetEase(Ease.OutExpo);
end

function GamePanel.GetLocalIndex(serverIndex)
	local Index = this.GetMyIndexFromList();
	return(serverIndex - Index + 5) % 4 + 1;
end

-- 设置红色箭头的显示方向
function GamePanel.SetDirGameObjectAction(LocalIndex)
	-- 设置方向
	-- this.UpateTimeReStart();
	for i = 1, #dirGameList do
		dirGameList[i]:SetActive(false);
	end
	dirGameList[LocalIndex]:SetActive(true);
	CurLocalIndex = LocalIndex;
end

function GamePanel.ThrowBottom(index, LocalIndex, isActive)
	local path = "";
	local poisVector3 = Vector3.zero;
	local obj = nil
	if (LocalIndex == 1) then
		-- 	path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		obj = newObject(TopAndBottomCard)
		poisVector3 = Vector3.New(-261 + #tableCardList[1] % 14 * 37, math.modf(#tableCardList[1] / 14) * 67);
		GlobalData.isDrag = false;
	elseif (LocalIndex == 2) then
		obj = newObject(ThrowCard_R)
		-- path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_R";
		poisVector3 = Vector3.New(math.modf(#tableCardList[2] / 13) * -54, -180 + #tableCardList[2] % 13 * 28);
	elseif (LocalIndex == 3) then
		obj = newObject(TopAndBottomCard)
		-- path = "Assets/Project/Prefabs/ThrowCard/TopAndBottomCard";
		poisVector3 = Vector3.New(289 - #tableCardList[3] % 14 * 37, math.modf(#tableCardList[3] / 14) * -67);
	elseif (LocalIndex == 4) then
		obj = newObject(ThrowCard_L)
		-- path = "Assets/Project/Prefabs/ThrowCard/ThrowCard_L";
		poisVector3 = Vector3.New(math.modf(#tableCardList[4] / 13) * 54, 152 - #tableCardList[4] % 13 * 28);
		-- parenTransform = leftOutParent;
	end
	obj.transform:SetParent(outparentList[LocalIndex])
	obj.transform.localPosition = poisVector3
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(index, LocalIndex, index == GlobalData.roomVo.guiPai);
	obj.name = tostring(index);
	obj.transform.localScale = Vector3.one;
	if (LocalIndex == 2) then obj.transform:SetSiblingIndex(0) end
	table.insert(tableCardList[LocalIndex], obj)
	if (not isActive) then obj:SetActive(false) end
	cardOnTable = obj;
	this.SetPointGameObject(obj);
	return obj
end


function GamePanel.PengCard(buffer)
	print("GamePanel.PengCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	this.UpateTimeReStart();
	local cardVo = json.decode(message);
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	this.SetDirGameObjectAction(LocalIndex);
	this.PengGangHuEffectCtrl("peng");
	soundMgr:playSoundByAction("peng", avatarList[cardVo.avatarId + 1].account.sex);
	-- 销毁桌上被碰的牌
	if (cardOnTable ~= nil) then
		this.ReSetOutOnTabelCardPosition(cardOnTable);
		destroy(cardOnTable);
	end
	if (LocalIndex == 1) then
		-- 自己碰牌
		-- this.PutCardIntoMineList(putOutCardPoint)
		-- 给mineList[1]增加加一张牌
		-- mineList[2][putOutCardPoint] = 2;
		-- 保存碰掉的2张牌
		-- 给this.handerCardList[1]移除2张牌
		removeCount = 0
		for i = #this.handerCardList[1], 1, -1 do
			local objCtrl = this.handerCardList[1][i];
			if (objCtrl.CardPoint == cardVo.cardPoint) then
				table.remove(this.handerCardList[1], i)
				destroy(objCtrl.gameObject);
				removeCount = removeCount + 1;
				if (removeCount == 2) then
					break;
				end
			end
		end
		this.SetPosition();
		this.BottomPeng(cardVo.cardPoint);
	else
		-- 其他人碰牌
		local tempCardList = this.handerCardList[LocalIndex];
		if (tempCardList ~= nil) then
			-- 直接减少前面2张牌
			for i = 1, 2 do
				destroy(tempCardList[1]);
				table.remove(tempCardList, 1)
			end

			-- 碰完后把第一张牌拿到最右边，重新排序
			otherPickCardItem = tempCardList[1];
			this.SetOtherCardObjPosition(tempCardList, LocalIndex, 1);
			-- 其他人this.handerCardList不保存最边上的牌
			table.remove(tempCardList, 1)
		end
		local tempList = { }
		-- 显示3张牌
		local switch = {
			[2] = function()
				for i = 1, 3 do
					local obj = newObject(PengGangCard_R)
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(cardVo.cardPoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.cardPoint);
					obj.transform:SetParent(cpgParent[2])
					obj.transform:SetSiblingIndex(0);
					obj.transform.localScale = Vector3.one;
					obj.transform.localPosition = Vector3.New(0, -148 + #PengGangList_R * 95 + i * 26)
					table.insert(tempList, objCtrl)
				end
			end,
			[3] = function()
				for i = 1, 3 do
					local obj = newObject(PengGangCard_T)
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(cardVo.cardPoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.cardPoint);
					obj.transform:SetParent(cpgParent[3])
					obj.transform.localScale = Vector3.one;
					obj.transform.localPosition = Vector3.New(214 - #PengGangList_T * 120 + i * 37, 0, 0);
					table.insert(tempList, objCtrl)
				end
			end,
			[4] = function()
				for i = 1, 3 do
					local obj = newObject(PengGangCard_L)
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(cardVo.cardPoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.cardPoint);
					obj.transform:SetParent(cpgParent[4])
					obj.transform.localScale = Vector3.one;
					obj.transform.localPosition = Vector3.New(0, 148 - #PengGangList_L * 95 - i * 26, 0);
					table.insert(tempList, objCtrl)
				end
			end
		}
		switch[LocalIndex]();
		this.AddListToPengGangList(LocalIndex, tempList);
	end
	GlobalData.isChiState = false;
end


function GamePanel.ChiCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	this.UpateTimeReStart();
	print("ChiCard:" .. message)
	local cardVo = json.decode(message);
	otherPengCard = cardVo.cardPoint;
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	this.SetDirGameObjectAction(LocalIndex);
	this.PengGangHuEffectCtrl("chi");
	soundMgr:playSoundByAction("chi", avatarList[cardVo.avatarId].account.sex);
	if (cardOnTable ~= nil) then
		this.ReSetOutOnTabelCardPosition(cardOnTable);
		destroy(cardOnTable);
	end
	if (LocalIndex == 1) then
		-- 自己吃牌
		-- mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] + 1;
		-- mineList[3][putOutCardPoint] = 1;
		-- 第一个吃牌
		for k, v in pairs(this.handerCardList[1]) do
			if (v.CardPoint == cardVo.onePoint) then
				table.remove(this.handerCardList[1], k)
				destroy(v.gameObject)
				break
			end
		end
		-- 第二个吃牌
		for k, v in pairs(this.handerCardList[1]) do
			if (v.CardPoint == cardVo.twoPoint) then
				destroy(v.gameObject)
				table.remove(this.handerCardList[1], k)
				break
			end
		end
		this.SetPosition();
		this.BottomChi(otherPengCard, cardVo.onePoint, cardVo.twoPoint)
	else
		-- 其他人吃牌
		local tempCardList = this.handerCardList[LocalIndex];
		if (tempCardList ~= nil) then
			for i = 1, 2 do
				destroy(tempCardList[1]);
				table.remove(tempCardList, 1)
			end
			otherPickCardItem = tempCardList[1];
			this.SetOtherCardObjPosition(tempCardList, LocalIndex, 1);
			table.remove(tempCardList, 1)
		end
		local prefab = nil
		local switch =
		{
			[2] = function(i)
				prefab = PengGangCard_R
				return Vector3.New(0, -122 + #PengGangList_R * 95 + i * 26);
			end,
			[3] = function(i)
				prefab = PengGangCard_T
				return Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0, 0);
			end,
			[4] = function(i)
				prefab = PengGangCard_L
				return Vector3.New(0, 122 - #PengGangList_L * 95 - i * 26, 0);
			end
		}

		local tempList = { }
		for i = 1, 3 do
			local pos = switch[LocalIndex](i)
			local obj = newObject(prefab)
			obj.transform:SetParent(cpgParent[i])
			obj.transform.localPosition = pos
			obj.transform.localScale = Vector3.one;
			if LocalIndex == 2 then
				obj.transform:SetSiblingIndex(0);
			end
			local objCtrl = TopAndBottomCardScript.New(obj);
			if (i == 1) then
				objCtrl:Init(cardVo.cardPoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.cardPoint);
			elseif (i == 2) then
				objCtrl:Init(cardVo.onePoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.onePoint);
			elseif (i == 3) then
				objCtrl:Init(cardVo.twoPoint, LocalIndex, GlobalData.roomVo.guiPai == cardVo.twoPoint);
			end
			table.insert(tempList, objCtrl)
		end
		this.AddListToPengGangList(LocalIndex, tempList);
	end
end

-- 补花动画
function GamePanel.BuHua(response)
	this.PengGangHuEffectCtrl("buhua");
	local cardVo = json.decode(response.message);
	SoundCtrl.getInstance().playSoundByAction("buhua", avatarList[cardVo.avatarIndex].account.sex);
	local LocalIndex = this.GetLocalIndex(cardVo.avatarIndex);
	for i = 1, #cardVo.huaPaiList do
		this.CardsNumChange();
		this.BuhuaRemoveCard(cardVo.huaPaiList[i], LocalIndex);
		this.BuhuaPutCard(cardVo.huaPaiList[i], LocalIndex);
		if (LocalIndex == 0) then
			this.BuhuaAddCard(cardVo.cardList[i], LocalIndex);
		else
			this.OtherMoPaiCreateGameObject(LocalIndex);
		end
	end
	this.UpateTimeReStart();
	this.SetDirGameObjectAction(LocalIndex);
	GlobalData.isDrag = true;
end

-- 去除手上花牌

function GamePanel.BuhuaRemoveCard(cardPoint, LocalIndex)
	if (LocalIndex == 0) then
		for i = 1, #this.handerCardList[1] do
			local temp = this.handerCardList[1][i];
			local CardPoint = temp.CardPoint;
			if (CardPoint == cardPoint) then
				table.remove(this.handerCardList[1], i)
				destroy(temp.gameObject);
				temp = nil
				break;
			end
		end
		-- this.PushOutFromMineList(cardPoint);
		this.SetPosition();
	else
		if (otherPickCardItem ~= nil) then
			destroy(otherPickCardItem);
			otherPickCardItem = nil;
		else
			local temp = this.handerCardList[LocalIndex][1];
			table.remove(this.handerCardList[LocalIndex], 1)
			destroy(temp);
		end
	end
end
-- 桌上显示花牌
function GamePanel.BuhuaPutCard(cardPoint, LocalIndex)
	switch =
	{
		[0] = Vector3.New(-230 + #buhualist[0] * 65,0),
		[1] = Vector3.New(0,- 140 + #buhualist[1] * 42),
		[2] = Vector3.New(-140 + #buhualist[2] * 40,0),
		[3] = Vector3.New(0,140 - #buhualist[3] * 42)
	}
	local tempvector3 = switch[LocalIndex];
	local path = "Assets/Project/Prefabs/PengGangCard/PengGangCard_" .. Dir[LocalIndex];
	resMgr:LoadPrefab('prefabs', { path .. '.prefab' }, function(prefabs)
		local obj = newObject(prefabs[0])
		obj.transform.parent = BuaHuaParenTransform[LocalIndex]
		obj.transform.localPosition = tempvector3
		obj.transform.localScale = Vector3.one * 0.6;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(cardPoint, LocalIndex, false);
		tabel.insert(buhualist, objCtrl)
	end )
end

-- 补牌
function GamePanel.BuhuaAddCard(LocalIndex, cardPoint)
	SelfAndOtherPutoutCard = cardPoint;
	-- this.PutCardIntoMineList(cardPoint);
	this.MoPai(cardPoint);
end
function GamePanel.BottomPeng(point)
	local templist = { }
	local prefab = PengGangCard_B

	for i = 1, 3 do
		local obj = newObject(prefab)
		obj.transform:SetParent(cpgParent[1])
		obj.transform.localPosition = Vector3.New(-430 + #PengGangList_B * 190 + i * 60, 0);
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, 1, GlobalData.roomVo.guiPai == point);
		obj.transform.localScale = Vector3.one;
		table.insert(templist, objCtrl)
	end
	table.insert(PengGangList_B, templist)
	GlobalData.isDrag = true;
end


function GamePanel.BottomChi(putCardPoint, oneCardPoint, twoCardPoint)
	local templist = { };
	local prefab = PengGangCard_B

	for i = 1, 3 do
		local obj = newObject(prefab)
		obj.transform:SetParent(cpgParent[1])
		obj.transform.localPosition = Vector3.New(-430 + #PengGangList_B * 190 + j * 60, 0);
		local objCtrl = TopAndBottomCardScript.New(obj)
		if (j == 0) then
			objCtrl:Init(putCardPoint, 1, GlobalData.roomVo.guiPai == putCardPoint);
		elseif (j == 1) then
			objCtrl:Init(oneCardPoint, 1, GlobalData.roomVo.guiPai == oneCardPoint);
		elseif (j == 2) then
			objCtrl:Init(twoCardPoint, 1, GlobalData.roomVo.guiPai == twoCardPoint);
		end
		obj.transform.localScale = Vector3.one;
		table.insert(templist, objCtrl)
	end
	table.insert(PengGangList_B, tempList)
	GlobalData.isDrag = true;
end

function GamePanel.PengGangHuEffectCtrl(effectType)
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


function GamePanel.OtherGang(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local gangNotice = json.decode(message);
	local point = gangNotice.cardPoint;
	local gangType = gangNotice.type;

	local LocalIndex = this.GetLocalIndex(gangNotice.avatarId);
	this.PengGangHuEffectCtrl("gang");
	this.SetDirGameObjectAction(LocalIndex);
	soundMgr:playSoundByAction("gang", avatarList[gangNotice.avatarId].account.sex)
	-- 杠牌下面的三张
	local prefab1 = nil
	-- 杠牌上面的一张
	local prefab2 = nil;
	local tempCardList = nil
	local switch =
	{
		[2] = function()
			tempCardList = this.handerCardList[2];
			prefab1 = PengGangCard_R
			prefab2 = GangBack_LR
		end,
		[3] = function()
			tempCardList = this.handerCardList[3];
			prefab1 = PengGangCard_T
			prefab2 = GangBack_T
		end,
		[4] = function()
			tempCardList = this.handerCardList[4];
			prefab1 = PengGangCard_L
			prefab2 = GangBack_LR
		end
	}
	switch[LocalIndex]()
	local tempList = { }
	-- 明杠和暗杠
	if (this.GetPaiInpeng(point, LocalIndex) == -1) then
		for i = 1, 3 do
			local temp = tempCardList[1];
			table.remove(tempCardList, 1)
			destroy(temp);
		end
		otherPickCardItem = tempCardList[1];
		if (tempCardList ~= nil) then
			this.SetOtherCardObjPosition(tempCardList, LocalIndex, 2);
			table.remove(tempCardList, 1)
		end
		-- 明杠
		if (gangType == 0) then
			-- 去掉桌上当前牌
			if (cardOnTable ~= nil) then
				this.ReSetOutOnTabelCardPosition(cardOnTable);
				destroy(cardOnTable);
			end
			local switch =
			{
				[2] = function(i)
					if (i == 3) then
						return Vector3.New(0, -122 + #PengGangList_R * 95 + 33);
					else
						return Vector3.New(0, -122 + #PengGangList_R * 95 + i * 28);

					end
				end,
				[3] = function(i)
					if (i == 3) then
						return Vector3.New(251 - #PengGangList_T * 120 + 37, 20);
					else
						return Vector3.New(251 - #PengGangList_T * 120 + i * 37, 0);
					end
				end,
				[4] = function(i)
					if (i == 3) then
						return Vector3.New(0, 122 - #PengGangList_L * 95 - 18);
					else
						return Vector3.New(0, 122 - #PengGangList_L * 95 - i * 28);
					end
				end
			}
			for i = 1, 4 do
				-- 实例化其他人杠牌
				local pos = switch[LocalIndex](i)
				local obj = newObject(prefab1)
				obj.transform:SetParent(cpgParent[LocalIndex])
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = pos;
				if (LocalIndex == 2) then
					obj.transform:SetSiblingIndex(0);
				end
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
				table.insert(tempList, obj)
			end
			-- 暗杠
		elseif (gangType == 1) then
			destroy(otherPickCardItem);
			local common = function(obj)
				local switch =
				{
					[2] = function()
						obj.transform.parent = pengGangParenTransformR.transform;
						if (j == 3) then
							tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + 33, 0);
						else
							tempvector3 = Vector3.New(0, -122 + #PengGangList_R * 95 + j * 28, 0);
						end
					end,
					[3] = function()
						obj.transform.parent = pengGangParenTransformT.transform;
						if (j == 3) then
							tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + 37, 10);
						else
							tempvector3 = Vector3.New(251 - #PengGangList_T * 120 + j * 37, 0);
						end
					end,
					[4] = function()
						obj.transform.parent = pengGangParenTransformL.transform;
						if (j == 3) then
							tempvector3 = new Vector3(0, 122 - #PengGangList_L * 95 - 18, 0);
						else
							tempvector3 = new Vector3(0, 122 - #PengGangList_L * 95 - j * 28, 0);
						end
					end
				}
				switch[LocalIndex]()
				

			end
			for i = 1, 4 do
				local obj;
				if (j == 3) then
					obj = newObject(prefab2)
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
				else
					obj = newObject(prefab1)
				end
				
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = pos;
				table.insert(tempList, obj)
			end
		end
		this.AddListToPengGangList(LocalIndex, tempList);
		-- 补杠
	else
		local gangIndex = this.GetPaiInpeng(point, LocalIndex);
		if (otherPickCardItem ~= nil) then
			destroy(otherPickCardItem);
		end
		resMgr:LoadPrefab('prefabs', { path .. ".prefab" }, function(prefabs)
			local obj = newObject(prefabs[0])
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
			local switch =
			{
				[2] = function()
					obj.transform.parent = pengGangParenTransformR.transform;
					tempvector3 = Vector3.New(0, -122 + gangIndex * 95 + 26);
					table.insert(PengGangList_R[gangIndex], objCtrl)
				end,
				[3] = function()
					obj.transform.parent = pengGangParenTransformT.transform;
					tempvector3 = Vector3.New(251 - gangIndex * 120 + 37, 20);
					table.insert(PengGangList_T[gangIndex], objCtrl)
				end,
				[4] = function()
					obj.transform.parent = pengGangParenTransformL.transform;
					tempvector3 = Vector3.New(0, 122 - gangIndex * 95 - 26, 0);
					table.insert(PengGangList_L[gangIndex], objCtrl)
				end,
			}
			switch[LocalIndex]()
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = tempvector3;
		end )
	end
	GlobalData.isChiState = false;
end

function GamePanel.AddListToPengGangList(LocalIndex, tempList)
	log("GamePanel.AddListToPengGangList")
	local switch =
	{
		[1] = function()
			table.insert(PengGangList_B, tempList)
		end,
		[2] = function()
			table.insert(PengGangList_R, tempList)
		end,
		[3] = function()
			table.insert(PengGangList_T, tempList)
		end,
		[4] = function()
			table.insert(PengGangList_L, tempList)
		end
	}
	switch[LocalIndex]()
end


--[[ 判断碰牌的牌组里面是否包含某个牌，用于判断是否实例化一张牌还是三张牌
cardpoint：牌点
direction：方向
返回-1  代表没有牌
其余牌在list的位置--]]

function GamePanel.GetPaiInpeng(cardPoint, LocalIndex)
	local jugeList = { }
	local switch =
	{
		[1] = function()
			-- 自己
			jugeList = PengGangList_B;
		end,
		[2] = function()
			jugeList = PengGangList_R;
		end,
		[3] = function()
			jugeList = PengGangList_L;
		end,
		[4] = function()
			jugeList = PengGangList_T;
		end
	}
	switch[LocalIndex]()
	if (jugeList == nil or #jugeList == 0) then
		return -1;
	end
	-- 循环遍历比对点数
	for i = 1, #jugeList do
		local index
		local ret, errMessage = pcall(
		function()
			if (jugeList[i][1].CardPoint == cardPoint) then
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
function GamePanel.SetPointGameObject(parent)
	if (parent ~= nil) then
		Pointertemp.transform:SetParent(parent.transform);
		Pointertemp.transform.localScale = Vector3.one;
		Pointertemp.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		Pointertemp.transform:SetParent(transform);
	end
end


function GamePanel.OnChipSelect(objCtrl, isSelected)
	if (isSelect) then
		-- 选择此牌
		if (oneChiCardPoint ~= -1 and twoChiCardPoint ~= -1) then
			return
		end
		if (oneChiCardPoint == -1) then
			oneChiCardPoint = objCtrl.CardPoint;
		else
			twoChiCardPoint = objCtrl.CardPoint;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -272);
		objCtrl.selected = true;
	else
		-- 取消选择
		if (oneChiCardPoint == objCtrl.CardPoint) then
			oneChiCardPoint = -1;
		elseif (twoChiCardPoint == objCtrl.CardPoint) then
			twoChiCardPoint = -1;
		end
		obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -292);
		objCtrl.selected = false;
	end
end

-- 自己打出的牌
function GamePanel.CardChange(objCtrl)
	local handCardCount = #this.handerCardList[1]
	log("handCardCount=" .. handCardCount .. ",CurLocalIndex=" .. CurLocalIndex)
	if (handCardCount % 3 == 2 and CurLocalIndex == 1) then
		-- 这时候才能出牌
		objCtrl.OnSendMessage = nil;
		objCtrl.ReSetPoisiton = nil;
		local CardPoint = objCtrl.CardPoint;
		-- this.PushOutFromMineList(CardPoint);
		this.CreatePutOutCardAndPlayAction(CardPoint, this.GetMyIndexFromList(), objCtrl.transform.position);
		-- 将打出牌移除
		for k, v in pairs(this.handerCardList[1]) do
			if v.CardPoint == CardPoint then
				table.remove(this.handerCardList[1], k)
				destroy(v.gameObject);
				break
			end
		end
		this.SetPosition();
		-- 出牌动画
		local cardvo = { }
		cardvo.cardPoint = CardPoint;
		LastAvarIndex = 1;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHUPAI_REQUEST, json.encode(cardvo)));
	else
		this.CardSelect(objCtrl);
	end
end

function GamePanel.InsertCardIntoList(objCtrl)
	-- 插入牌的方法
	if (objCtrl ~= nil) then
		local curCardPoint = objCtrl.CardPoint;
		-- 得到当前牌指针
		if (curCardPoint == GlobalData.roomVo.guiPai) then
			table.insert(this.handerCardList[1], 1, objCtrl)
			-- 鬼牌放到最前面
			return;
		else
			for i = 1, #this.handerCardList[1] do
				local cardPoint = this.handerCardList[1][i].CardPoint;
				if (cardPoint ~= GlobalData.roomVo.guiPai and cardPoint >= curCardPoint) then
					table.insert(this.handerCardList[1], i, objCtrl)
					return;
				end
			end
			table.insert(this.handerCardList[1], objCtrl)
		end
	end
end
-- 给自己的牌设置位置
function GamePanel.SetPosition()
	-- 设置位置
	local count = #this.handerCardList[1];
	local startX = 594 - count * 80 - 80;
	if (count % 3 == 2) then
		for i = 1, count - 1 do
			this.handerCardList[1][i].gameObject.transform.localPosition = Vector2.New(startX + i * 80, -292);
			-- 从左到右依次对齐
		end
		this.handerCardList[1][count].gameObject.transform.localPosition = Vector2.New(580, -292);
		-- 从左到右依次对齐
	else
		for i = 1, count do
			this.handerCardList[1][i].gameObject.transform.localPosition = Vector2.New(startX + i * 80 - 80, -292);
			-- 从左到右依次对齐
		end
	end
end

function GamePanel.Update()
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
			this.PlayNoticeAction();
		end
	end
end

function GamePanel.PlayNoticeAction()
	noticeGameObject:SetActive(true);
	if (GlobalData.noticeMegs ~= nil and #GlobalData.noticeMegs ~= 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = GlobalData.noticeMegs[showNoticeNumber];
		local time = noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = noticeText.transform:DOLocalMove(
		Vector3.New(- noticeText.text.Length * 28, noticeText.transform.localPosition.y), time, false)
		.OnComplete(MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end
end

function GamePanel.MoveCompleted()
	showNoticeNumber = showNoticeNumber + 1;
	if (showNoticeNumber == #GlobalData.noticeMegs) then
		showNoticeNumber = 0;
	end
	noticeGameObject:SetActive(false);
	this.RandShowTime();
	timeFlag = true;
end

-- 重新开始计时
function GamePanel.UpateTimeReStart()
	timer = 16;
end


-- 点击放弃按钮
function GamePanel.MyPassBtnClick()
	btnActionScript.CleanBtnShow();
	if isSelfPickCard then
		GlobalData.isDrag = true;
		isSelfPickCard = false;
	end
	if (passType == "selfPickCard") then
		GlobalData.isDrag = true;
	end
	passType = "";
	networkMgr:SendMessage(ClientRequest.New(APIS.GAVEUP_REQUEST, "gaveup|" .. passStr));
	GlobalData.isChiState = false;
	passStr = "";
end

function GamePanel.MyPengBtnClick()
	GlobalData.isDrag = true;
	this.UpateTimeReStart();
	local cardvo = { };
	cardvo.cardPoint = putOutCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.PENGPAI_REQUEST, json.encode(cardvo)));
	btnActionScript.CleanBtnShow();
	passStr = "";
end


function GamePanel.ShowChipai(idx)
	local cpoint = chiPaiPointList[idx];
	if (idx == 1) then
		chiList_1[1].CardPoint = cpoint.putCardPoint;
		chiList_1[2].CardPoint = cpoint.oneCardPoint;
		chiList_1[3].CardPoint = cpoint.twoCardPoint;
	end
	if (idx == 2) then
		chiList_2[1].CardPoint = cpoint.putCardPoint;
		chiList_2[2].CardPoint = cpoint.oneCardPoint;
		chiList_2[3].CardPoint = cpoint.twoCardPoint;
	end
	if (idx == 3) then
		chiList_3[1].CardPoint = cpoint.putCardPoint;
		chiList_3[2].CardPoint = cpoint.oneCardPoint;
		chiList_3[3].CardPoint = cpoint.twoCardPoint;
	end
end

-- 显示可吃牌的显示
function GamePanel.ShowChiList()
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
function GamePanel.MyChiBtnClick2(idx)
	local cpoint = chiPaiPointList[idx];
	GlobalData.isDrag = true;
	this.UpateTimeReStart();
	local cardvo = { }
	cardvo.cardPoint = cpoint.putCardPoint;
	cardvo.onePoint = cpoint.oneCardPoint;
	cardvo.twoPoint = cpoint.twoCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
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
function GamePanel.MyChiBtnClick()
	if (#chiPaiPointList == 1) then
		local cpoint = chiPaiPointList[1];
		GlobalData.isDrag = true;
		this.UpateTimeReStart();
		local cardvo = { };
		cardvo.cardPoint = cpoint.putCardPoint;
		cardvo.onePoint = cpoint.oneCardPoint;
		cardvo.twoPoint = cpoint.twoCardPoint;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
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

function GamePanel.GangResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	this.UpateTimeReStart();
	local gangBackVo = json.decode(message);
	local gangKind = gangBackVo.type;
	if (#gangBackVo.cardList == 0) then
		-- mineList[1][selfGangCardPoint] = 2;
		if (gangKind == 0) then
			-- 明杠
			if (this.GetPaiInpeng(selfGangCardPoint, 1) == -1) then
				-- 杠牌不在碰牌数组以内，一定为别人打得牌
				-- mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] -3;
				-- 销毁别人打的牌
				-- 			if (putOutCard ~= nil) then
				-- 				destroy(putOutCard);
				-- 			end
				if (cardOnTable ~= nil) then
					this.ReSetOutOnTabelCardPosition(cardOnTable);
					destroy(cardOnTable)
				end
				-- 销毁手牌中的三张牌
				local removeCount = 0;
				for i = #this.handerCardList[1], 1, -1 do
					local objCtrl = this.handerCardList[1][i];
					local tempCardPoint = objCtrl.CardPoint;
					if (selfGangCardPoint == tempCardPoint) then
						table.remove(this.handerCardList[1], i)
						destroy(objCtrl.gameObject);
						removeCount = removeCount + 1;
						if (removeCount == 3) then
							break;
						end
					end
				end
				-- 创建杠牌序列
				local gangTempList = { };
				for i = 1, 4 do
					local obj = newObject(PengGangCard_B)
					obj.transform:SetParent(cpgParent[1])
					obj.transform.localPosition = Vector3.New(-430 + #PengGangList_B * 190 + i * 60, 0)
					obj.transform.localScale = Vector3.one;
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(selfGangCardPoint, 1, GlobalData.roomVo.guiPai == selfGangCardPoint);
					if (i == 3) then
						obj.transform.localPosition = Vector3.New(-310 + #PengGangList_B * 190, 24);
					end
					table.insert(gangTempList, objCtrl)
				end
				-- 添加到杠牌数组里面
				table.insert(PengGangList_B, gangTempList)
				-- 补杠
			else
				-- 在碰牌数组以内，则一定是自摸的牌
				-- mineList[1][putOutCardPoint] = mineList[1][putOutCardPoint] -4;
				for i = 1, #this.handerCardList[1] do
					if (this.handerCardList[1][i].CardPoint == selfGangCardPoint) then
						local objCtrl = this.handerCardList[1][i];
						table.remove(this.handerCardList[1], i)
						destroy(objCtrl.gameObject);
						break;
					end
				end
				local index = this.GetPaiInpeng(selfGangCardPoint, 1);
				-- 将杠牌放到对应位置
				local obj = newObject(PengGangCard_B)
				obj.transform:SetParent(cpgParent[1])
				obj.transform.localPosition = Vector3.New(-500 + index * 190, 24);
				obj.transform.localScale = Vector3.one;
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(selfGangCardPoint, 1, GlobalData.roomVo.guiPai == selfGangCardPoint)
				table.insert(PengGangList_B[index], objCtrl)
			end
		elseif (gangKind == 1) then
			-- mineList[1][selfGangCardPoint] = mineList[1][selfGangCardPoint] -4;
			local removeCount = 0;
			for i = #this.handerCardList[1], 1, -1 do
				local objCtrl = this.handerCardList[1][i];
				local tempCardPoint = objCtrl.CardPoint;
				if (selfGangCardPoint == tempCardPoint) then
					table.remove(this.handerCardList[1], i)
					destroy(objCtrl.gameObject);
					removeCount = removeCount + 1;
					if (removeCount == 4) then
						break;
					end
				end
			end
			local tempGangList = { };
			for i = 1, 4 do
				if (i < 3) then
					local obj = newObject(gangBack)
					obj.transform:SetParent(cpgParent[1])
					obj.transform.localPosition = Vector3.New(-430 + #PengGangList_B * 190 + i * 60, 0);
					obj.transform.localScale = Vector3.one;
					table.insert(tempGangList, obj)
				elseif (i == 3) then
					local obj = newObject(PengGangCard_B)
					obj.transform:SetParent(cpgParent[1])
					obj.transform.localPosition = Vector3.New(-310 + #PengGangList_B * 190, 24)
					obj.transform.localScale = Vector3.one;
					local objCtrl = TopAndBottomCardScript.New(obj)
					objCtrl:Init(selfGangCardPoint, 1, GlobalData.roomVo.guiPai == selfGangCardPoint)
					table.insert(tempGangList, objCtrl)
				end
			end
			table.insert(PengGangList_B, tempGangList)
		end
	elseif (#gangBackVo.cardList == 2) then
	end
	this.SetPosition();
	GlobalData.isChiState = false;
end

-- function GamePanel.CreateGameObjectAndReturn(path, parent, position, f)
-- log("CreateGameObjectAndReturn:" .. path)
-- resMgr:LoadPrefab('prefabs', { path .. ".prefab" }, function(prefabs)
-- 	local obj = newObject(prefabs[0])
-- 	obj.transform:SetParent(parent);
-- 	obj.transform.localScale = Vector3.one;
-- 	obj.transform.localPosition = position;
-- 	f(obj)
-- end )
-- end

function GamePanel.MyGangBtnClick()
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
	local GangRequestVO = { }
	GangRequestVO.cardPoint = useForGangOrPengOrChi
	GangRequestVO.gangType = 0;
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	soundMgr:playSoundByAction("gang", GlobalData.loginResponseData.account.sex);
	btnActionScript.CleanBtnShow();
	this.PengGangHuEffectCtrl("gang");
	gangPaiList = nil;
	GlobalData.isChiState = false;
	passStr = "";
end

function GamePanel.Clean()
	this.CleanArrayList(this.handerCardList)
	this.CleanArrayList(tableCardList)
	this.CleanArrayList(PengGangList_L)
	this.CleanArrayList(PengGangList_B)
	this.CleanArrayList(PengGangList_R)
	this.CleanArrayList(PengGangList_T)
	-- if (mineList ~= nil) then
	-- 	mineList = { }
	-- end
	-- if (putOutCard ~= nil) then
	-- 	destroy(putOutCard);
	-- end
	if (pickCardItem ~= nil) then
		destroy(pickCardItem);
	end
	if (otherPickCardItem ~= nil) then
		destroy(otherPickCardItem);
	end
	guiObj:SetActive(false);
end

function GamePanel.CleanArrayList(list)
	if (list ~= nil) then
		while #list > 0 do
			local tempList = list[1]
			table.remove(list, 1)
			this.CleanList(tempList)
		end
	end
end

function GamePanel.CleanList(tempList)
	if (tempList ~= nil) then
		while #tempList > 0 do
			local temp = tempList[1];
			table.remove(tempList, 1)
			if (type(temp) == "table") then
				destroy(temp.gameObject)
				temp = nil
			else
				destroy(temp)
			end
		end
	end
end

function GamePanel.SetRoomRemark()
	local roomvo = GlobalData.roomVo;
	GlobalData.totalTimes = roomvo.roundNumber;
	GlobalData.surplusTimes = roomvo.roundNumber;
	-- LeavedRoundNumText.text = GlobalData.surplusTimes + "";
	local str = "房间号：\n" .. roomvo.roomId .. "\n"
	.. "圈数:" .. roomvo.roundNumber .. "\n\n"
	roomRemark.text = str;
end

function GamePanel.AddAvatarVOToList(avatar)
	if (avatarList == nil) then
		avatarList = { };
	end
	table.insert(avatarList, avatar)
	this.SetSeat(avatar);
end
-- 创建房间
function GamePanel.CreateRoomAddAvatarVO(avatar)
	avatar.scores = 1000;
	this.AddAvatarVOToList(avatar);
	this.SetRoomRemark();
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
function GamePanel.JoinToRoom(avatars)
	avatarList = avatars;
	for i = 1, #avatars do
		this.SetSeat(avatars[i])
	end
	this.SetRoomRemark();
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
function GamePanel.SetSeat(avatar)
	-- 游戏结束后用的数据，勿删！！！
	if (avatar.account.uuid == GlobalData.loginResponseData.account.uuid) then
		playerItems[1]:SetAvatarVo(avatar);
	else
		local myIndex = this.GetMyIndexFromList();
		local curAvaIndex = table.indexOf(avatarList, avatar)
		local seatIndex = 1 + curAvaIndex - myIndex;
		if (seatIndex < 1) then
			seatIndex = 4 + seatIndex;
		end
		playerItems[seatIndex]:SetAvatarVo(avatar);
	end
end

function GamePanel.GetMyIndexFromList()
	if (avatarList ~= nil) then
		for i = 1, #avatarList do
			if (avatarList[i].account.uuid == GlobalData.loginResponseData.account.uuid or avatarList[i].account.openid == GlobalData.loginResponseData.account.openid) then
				GlobalData.loginResponseData.account.uuid = avatarList[i].account.uuid;
				return i
			end
		end
	end
	return 1;
end

function GamePanel.GetIndex(uuid)
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

function GamePanel.OtherUserJointRoom(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local avatar = json.decode(message);
	this.AddAvatarVOToList(avatar);
end

-- 胡牌按钮点击
function GamePanel.HupaiRequest()
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
		networkMgr:SendMessage(ClientRequest.New(APIS.HUPAI_REQUEST, sendMsg));
		btnActionScript.CleanBtnShow();
		GlobalData.isChiState = false;
	end
end

function GamePanel.HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	for i = 1, #playerItems do
		playerItems[i].jiaGang.text = "";
	end
	GlobalData.hupaiResponseVo = json.decode(message);
	local scores = GlobalData.hupaiResponseVo.currentScore;
	this.HupaiCoinChange(scores);
	local huPaiPoint = 0;
	if (GlobalData.hupaiResponseVo.type == "0") then
		soundMgr:playSoundByAction("hu", GlobalData.loginResponseData.account.sex);
		this.PengGangHuEffectCtrl("hu");
		for i = 1, #GlobalData.hupaiResponseVo.avatarList do
			local LocalIndex = this.GetLocalIndex(i);
			if (GlobalData.hupaiResponseVo.avatarList[i].uuid == GlobalData.hupaiResponseVo.winnerId) then
				huPaiPoint = GlobalData.hupaiResponseVo.avatarList[i].cardPoint;
				if (GlobalData.hupaiResponseVo.winnerId ~= GlobalData.hupaiResponseVo.dianPaoId) then
					-- 点炮胡
					playerItems[LocalIndex]:SetHuFlag(true);
					soundMgr:playSoundByAction("hu", avatarList[i].account.sex);
				else
					-- 自摸胡
					playerItems[LocalIndex]:SetHuFlag(true);
					soundMgr:playSoundByAction("zimo", avatarList[i].account.sex);
				end
			else
				playerItems[LocalIndex]:SetHuFlag(false);
			end
		end
		allMas = GlobalData.hupaiResponseVo.allMas;
		if (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN
			or GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
			-- 转转麻将显示抓码信息
			if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas > 0) then
				resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab' }, function(prefabs)
					zhuamaPanel = newObject(prefabs[0])
					zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
					zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas)
					coroutine.start(Invoke(OpenGameOverPanelSignal, 7))
				end )
			else
				coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
			end
		elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
			-- 广东麻将显示抓码信息
			if (GlobalData.roomVo.ma > 0 and allMas ~= nil and #allMas > 0) then
				resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/card/Panel_ZhuaMa.prefab' }, function(prefabs)
					zhuamaPanel = newObject(prefabs[0])
					zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
					zhuamaPanel.ZhuMaScript:arrageMas(allMas, avatarList, GlobalData.hupaiResponseVo.validMas, GlobalData.roomVo.roomType);
					coroutine.start(Invoke(OpenGameOverPanelSignal, 7))
				end )
			else
				coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
			end
		elseif (GlobalData.roomVo.roomType == GameConfig.GAME_TYPE_PANJIN) then
			-- 盘锦麻将绝
			if (GlobalData.roomVo.jue) then
				resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/Panel_ZhuaMa.prefab' }, function(prefabs)
					zhuamaPanel = newObject(prefabs[0])
					zhuamaPanel.ZhuMaScript = ZhuMaScript.New()
					zhuamaPanel.ZhuMaScript:arrageJue(huPaiPoint, avatarList, GlobalData.hupaiResponseVo.validMas);
					coroutine.start(Invoke(OpenGameOverPanelSignal, 7))
				end )
			else
				coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
			end
		else
			coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
		end
	elseif (GlobalData.hupaiResponseVo.type == "1") then
		soundMgr:playSoundByAction("liuju", GlobalData.loginResponseData.account.sex);
		this.PengGangHuEffectCtrl("liuju");
		coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
	else
		coroutine.start(Invoke(OpenGameOverPanelSignal, 3))
	end
end

function GamePanel.Invoke(f, time)
	coroutine.wait(time)
	f()
end

function GamePanel.HupaiCoinChange(scores)
	local scoreList = string.split(scores, ',')
	if (scoreList ~= nil and #scoreList > 0) then
		for i = 1, #scoreList - 1 do
			local itemstr = scoreList[i];
			local uuid = tonumber(string.split(itemstr, ':')[1]);
			local score = tonumber(string.split(itemstr, ':')[2]) + 1000;
			local LocalIndex = this.GetLocalIndex(this.GetIndex(uuid) -1)
			playerItems[LocalIndex].scoreText.text = tostring(score);
			avatarList[this.GetIndex(uuid)].scores = score;
		end
	end
end


-- 单局结束重置数据的地方

function GamePanel.OpenGameOverPanelSignal(allMas)
	-- 单局结算
	liujuEffectGame:SetActive(false);
	SetAllPlayerHuImgVisbleToFalse();
	playerItems[this.GetLocalIndex(bankerIndex)]:SetBankImg(false);
	if (this.handerCardList ~= nil and #this.handerCardList > 0 and #this.handerCardList[1] > 0) then
		for i = 1, #this.handerCardList[1] do
			this.handerCardList[1][i].OnSendMessage = nil
			this.handerCardList[1][i].ReSetPoisiton = nil
		end
	end
	this.InitPanel();
	if (zhuamaPanel ~= nil) then
		destroy(zhuamaPanel);
	end
	resMgr:LoadPrefab('prefabs', { 'Assets/Project/Prefabs/Panel_Game_Over.prefab' }, function(prefabs)
		local obj = newObject(prefabs[0])
		local GameOverScript = GameOverScript.New(obj)
		GameOverScript:SetDisplaContent(0, avatarList, allMas, GlobalData.hupaiResponseVo.validMas, GlobalData.hupaiResponseVo.nextBankerId == GlobalData.loginResponseData.account.uuid);
		table.insert(GlobalData.singalGameOverList, GameOverScript)
	end )
	allMas = "";
	-- 初始化码牌数据为空
	avatarList[bankerIndex].main = false;
end

function GamePanel.ReSetOutOnTabelCardPosition(cardOnTable)
	print("GamePanel.ReSetOutOnTabelCardPosition:" .. tostring(LastAvarIndex));
	if (LastAvarIndex ~= -1) then
		local objIndex = table.indexOf(tableCardList[LastAvarIndex], cardOnTable)
		if (objIndex ~= -1) then
			destroy(tableCardList[LastAvarIndex][objIndex])
			table.remove(tableCardList[LastAvarIndex], objIndex)
			return;
		end
	end
end


-- 退出房间确认面板
function GamePanel.QuiteRoom()
	if (bankerIndex == this.GetMyIndexFromList()) then
		dialog_fanhui_text.text = "亲，确定要解散房间吗?";
	else
		dialog_fanhui_text.text = "亲，确定要离开房间吗?";
	end
	dialog_fanhui.gameObject:SetActive(true);
end
-- 退出房间按钮点击
function GamePanel.Tuichu()
	local vo = { };
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo)
	networkMgr:SendMessage(ClientRequest.New(APIS.OUT_ROOM_REQUEST, sendMsg));
	dialog_fanhui.gameObject:SetActive(false);
end
-- 取消退出房间
function GamePanel.Quxiao()
	dialog_fanhui.gameObject:SetActive(false);
end

function GamePanel.OutRoomCallbak(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local responseMsg = json.decode(message)
	if (responseMsg.status_code == "0") then
		if (responseMsg.type == "0") then
			local uuid = responseMsg.uuid;
			if (uuid ~= GlobalData.loginResponseData.account.uuid) then
				local index = this.GetIndex(uuid);
				table.remove(avatarList, index)
				for i = 1, #playerItems do
					playerItems[i]:SetAvatarVo(nil);
				end
				if (avatarList ~= nil) then
					for i = 1, #avatarList do
						this.SetSeat(avatarList[i]);
					end
				end
			else
				this.ExitOrDissoliveRoom();
			end
		else
			this.ExitOrDissoliveRoom();
		end
	else
		TipsManager.SetTips("退出房间失败：" .. tostring(responseMsg.error));
	end
end

local dissoliveRoomType = "0";
function GamePanel.DissoliveRoomRequest()
	soundMgr:playSoundByActionButton(1);
	if (this.isGameStarted) then
		dissoliveRoomType = "0";
		TipsManager.LoadDialog("申请解散房间", "你确定要申请解散房间?", this.DoDissoliveRoomRequest, cancle);
	else
		TipsManager.SetTips("还没有开始游戏，不能申请退出房间");
	end
end
-- 游戏设置
function GamePanel.OpenGameSettingDialog()
	soundMgr:playSoundByActionButton(1);
	SettingPanelCtrl.Open();
end

local panelCreateDialog;-- 界面上打开的dialog
function GamePanel.LoadPrefab(perfabName)
	resMgr:LoadPrefab('prefabs', { perfabName .. ".prefab" }, function(prefabs)
		panelCreateDialog = newObject(prefabs[0])
		panelCreateDialog.transform.parent = gameObject.transform;
		panelCreateDialog.transform.localScale = Vector3.one;
		panelCreateDialog:GetComponent("RectTransform").offsetMax = Vector2.zero;
		panelCreateDialog:GetComponent("RectTransform").offsetMin = Vector2.zero;
	end )
end

-- 申请解散房间回调

local dissoDialog;
function GamePanel.DissoliveRoomResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local dissoliveRoomResponseVo = json.decode(message);
	local plyerName = dissoliveRoomResponseVo.accountName;
	local uuid = dissoliveRoomResponseVo.uuid;
	if (dissoliveRoomResponseVo.type == "0") then
		GlobalData.isonApplayExitRoomstatus = true;
		dissoliveRoomType = "1";
		resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Panel_Apply_Exit.prefab" }, function(prefabs)
			dissoDialog = newObject(prefabs[0])
			local VoteScript = VoteScript.New(dissoDialog)
			VoteScript:InitUI(uuid, plyerName, avatarList);
		end )
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
function GamePanel.DoDissoliveRoomRequest()
	local dissoliveRoomRequestVo = DissoliveRoomRequestVo.New();
	dissoliveRoomRequestVo.roomId = GlobalData.loginResponseData.roomId;
	dissoliveRoomRequestVo.type = dissoliveRoomType;
	local sendMsg = josn.encode(dissoliveRoomRequestVo);
	networkMgr:SendMessage(ClientRequest.New(APIS.DISSOLIVE_ROOM_REQUEST, sendMsg));
	GlobalData.isonApplayExitRoomstatus = true;
end

function GamePanel.Cancle()
end

function GamePanel.ExitOrDissoliveRoom()
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
	OpenPanel(HomePanel)

	while #playerItems > 0 do
		local item = playerItems[1];
		table.remove(playerItems, 1)
		destroy(item.gameObject);
	end
	this.Close()
	HomePanelCtrl.Open()
end

function GamePanel.GameReadyNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message);
	local avatarIndex = data["avatarIndex"] + 1;
	-- 服务器是从0开始
	local myIndex = this.GetMyIndexFromList();
	local seatIndex = 1 + avatarIndex - myIndex;
	if (seatIndex < 1) then
		seatIndex = 4 + seatIndex;
	end
	playerItems[seatIndex]:SetReadyImg(true)
	avatarList[avatarIndex].IsReady = true;
end

-- 隐藏跟庄
function GamePanel.GameFollowBanderNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	genZhuang:SetActive(true);
	coroutine.start(Invoke(HideGenzhuang, 2))
end

function GamePanel.HideGenzhuang()
	genZhuang:SetActive(false);
end

function GamePanel.ReEnterRoom()
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
		this.SetRoomRemark();
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
			-- 牌局已开始
		else

			this.SetAllPlayerReadImgVisbleToFalse();

			this.CleanGameplayUI();

			-- 显示打牌数据
			this.DisplayTableCards();

			-- 显示鬼牌
			this.DisplayGuiPai();

			-- 显示其他玩家的手牌
			this.DisplayOtherHandercard();

			-- 显示杠牌
			this.DisplayallGangCard();

			-- 显示碰牌
			this.DisplayPengCard();

			-- 显示吃牌
			this.DisplayChiCard();

			this.DispalySelfhanderCard();

			networkMgr:SendMessage(ClientRequest.New(APIS.REQUEST_CURRENT_DATA, "dd"));
		end
	end
end

-- 恢复其他全局数据
function GamePanel.RecoverOtherGlobalData()
	local selfIndex = this.GetMyIndexFromList();
	-- 恢复房卡数据，此时主界面还没有load所以无需操作界面显示
	GlobalData.loginResponseData.account.roomcard = GlobalData.reEnterRoomData.playerList[selfIndex].account.roomcard;
end

-- 只加载手牌对象，不排序
function GamePanel.DispalySelfhanderCard()
	-- mineList = this.ToList(GlobalData.reEnterRoomData.playerList[this.GetMyIndexFromList()].paiArray)
	local paiArray = avatarList[this.GetMyIndexFromList()].paiArray
	for i = 1, #paiArray[1] do
		if (paiArray[1][i] > 0) then
			for j = 1, paiArray[1][i] do
				local go = newObject(Bottom_B);
				-- 设置父节点
				go.transform:SetParent(parentList[1]);
				go.transform.localScale = Vector3.New(1.1, 1.1, 1);
				local objCtrl = BottomScript.New(go)
				local point = i - 1
				objCtrl.OnSendMessage = this.CardChange;
				objCtrl.ReSetPoisiton = this.CardSelect;
				objCtrl:Init(point, GlobalData.roomVo.guiPai == point)
				-- 增加游戏对象
				table.insert(this.handerCardList[1], objCtrl)
			end
		end
	end
end

function GamePanel.ToList(param)
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

function GamePanel.MyselfSoundActionPlay()
	playerItems[1]:ShowChatAction();
end


-- 重连显示打牌数据
function GamePanel.DisplayTableCards()
	log("GamePanel.DisplayTableCards")
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local chupai = GlobalData.reEnterRoomData.playerList[i].chupais;
		local LocalIndex = this.GetLocalIndex(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid) -1);
		if (chupai ~= nil and #chupai > 0) then
			for j = 1, #chupai do
				this.ThrowBottom(chupai[j], LocalIndex, true, nil);
			end
		end
	end
end

-- 显示桌面鬼牌
function GamePanel.DisplayTouzi(touzi, gui)
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
function GamePanel.GetDisplayGuiPai(gui)
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
function GamePanel.DisplayGuiPai()
	log("GamePanel.DisplayGuiPai")
	touziObj:SetActive(false);
	local gui = GlobalData.roomVo.guiPai;
	if (gui ~= -1 and(GlobalData.roomVo.hong or GlobalData.roomVo.gui > 0)) then
		-- 显示鬼牌
		-- int mGui = getDisplayGuiPai(gui);//盘锦玩法，显示当前鬼牌的前一张
		local objCtrl = TopAndBottomCardScript.New(guiObj)
		objCtrl:Init(gui, 3, true);
		guiObj:SetActive(true);
	end
end

-- 重连显示其他人的手牌
function GamePanel.DisplayOtherHandercard()
	log("GamePanel.DisplayOtherHandercard")
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local LocalIndex = this.GetLocalIndex(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid) -1);
		local count = GlobalData.reEnterRoomData.playerList[i].commonCards;
		if (LocalIndex ~= 1) then
			this.InitOtherCardList(LocalIndex, count);
		end
	end
end

-- 杠牌重连
function GamePanel.DisplayallGangCard()
	log("GamePanel.DisplayallGangCard")
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];
		local LocalIndex = this.GetLocalIndex(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid) -1);
		if (table.indexOf(paiArrayType, 2) > -1) then
			local gangString = GlobalData.reEnterRoomData.playerList[i].huReturnObjectVO.totalInfo.gang;
			if (gangString ~= nil) then
				local gangtemps = string.split(gangString, ',')
				for j = 1, #gangtemps do
					local item = gangtemps[j];
					local items = string.split(item, ':')
					gangpaiObj = { };
					gangpaiObj.uuid = items[1];
					gangpaiObj.cardPoint = tonumber(items[2]);
					gangpaiObj.type = items[3];
					GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPoint + 1] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][gangpaiObj.cardPoint + 1] -4;
					if (gangpaiObj.type == "an") then
						this.DoDisplayAnGangCard(LocalIndex, gangpaiObj.cardPoint, true);
					else
						this.DoDisplayMGangCard(LocalIndex, gangpaiObj.cardPoint);
					end
				end
			end
		end

	end
end


-- 碰牌重连（这个逻辑写得很反人类）
function GamePanel.DisplayPengCard()
	log("GamePanel.DisplayPengCard")
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local paiArrayType = GlobalData.reEnterRoomData.playerList[i].paiArray[2];
		-- 第二个数组存储了碰的牌
		local LocalIndex = this.GetLocalIndex(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid) -1);
		if (table.indexOf(paiArrayType, 1) > -1) then
			-- 1代表碰的那张牌
			for j = 1, #paiArrayType do
				if (paiArrayType[j] == 1 and GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] > 0) then
					-- 服务器没去掉已经吃碰杠的牌，所以处理一下（主要是要去掉自己的）
					GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][j] -3;
					this.DoDisplayPengCard(LocalIndex, j - 1);
				end
			end
		end
	end
end


-- 吃牌重连
function GamePanel.DisplayChiCard()
	log("GamePanel.DisplayChiCard")
	for i = 1, #GlobalData.reEnterRoomData.playerList do
		local LocalIndex = this.GetLocalIndex(this.GetIndex(GlobalData.reEnterRoomData.playerList[i].account.uuid) -1);
		local chiPaiArray = GlobalData.reEnterRoomData.playerList[i].chiPaiArray;
		log(Test.DumpTab(chiPaiArray))
		if #chiPaiArray > 0 then
			for j = 1, #chiPaiArray do
				for k = 1, #chiPaiArray[j] do
					if (chiPaiArray[j][k] > 0 and GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] > 0) then
						GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] = GlobalData.reEnterRoomData.playerList[i].paiArray[1][chiPaiArray[j][k]] -1;
					end
				end
				this.DoDisplayChiCard(LocalIndex, chiPaiArray[j]);
			end
		end
	end
end


-- 补花牌的重连
function GamePanel.DisplayBuhua(playerList)
	for i = 1, #playerList do
		local LocalIndex = this.GetLocalIndex(this.GetIndex(playerList[i].account.uuid) -1);
		local buhualist = playerList[i].buhuas;
		if (#buhualist > 0) then
			for j = 1, j < #buhualist do
				this.BuhuaPutCard(buhualist[j], LocalIndex);
			end
		end
	end
end
-- 重连显示明杠
function GamePanel.DoDisplayMGangCard(LocalIndex, point)
	log("GamePanel.DoDisplayMGangCard")
	local TempList = { };
	local prefab = nil
	switch =
	{
		[1] = function(i)
			prefab = PengGangCard_B
			if (i == 4) then
				return Vector2.New(-310 + #PengGangList_B * 190, 24)
			else
				return Vector2.New(-430 + #PengGangList_B * 190 + i * 60, 0)
			end
		end,
		[2] = function(i)
			prefab = PengGangCard_R
			if (i == 4) then
				return Vector2.New(0, -122 + #PengGangList_R * 95 + 33)
			else
				return Vector2.New(0, -150 + #PengGangList_R * 95 + i * 28)
			end
		end,
		[3] = function(i)
			prefab = PengGangCard_T
			if (i == 4) then
				return Vector2.New(251 - #PengGangList_T * 120 + 37, 20)
			else
				return Vector2.New(214 - #PengGangList_T * 120 + i * 37, 0)
			end
		end,
		[4] = function(i)
			prefab = PengGangCard_L
			if (i == 4) then
				return Vector2.New(0, 122 - #PengGangList_L * 95 - 18)
			else
				return Vector2.New(0, 150 - #PengGangList_L * 95 - i * 28)
			end
		end,
	}
	for i = 1, 4 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(prefab)
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = pos
		obj.transform.localScale = Vector3.one;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		table.insert(TempList, objCtrl)
	end
	this.AddListToPengGangList(LocalIndex, TempList)
end


-- 显示暗杠牌
-- show:是否显示暗杠牌值
function GamePanel.DoDisplayAnGangCard(LocalIndex, point, show)
	log("GamePanel.DoDisplayAnGangCard")
	local TempList = { };
	local prefab = nil
	local prefabback = nil
	switch =
	{
		[1] = function(i)
			prefab = PengGangCard_B
			prefabback = gangBack
			if (i == 4) then
				return Vector2.New(-310 + #PengGangList_B * 190, 24)
			else
				return Vector2.New(-430 + #PengGangList_B * 190 + i * 60, 0)
			end
		end,
		[2] = function(i)
			prefab = PengGangCard_R
			prefabback = GangBack_LR
			if (i == 4) then
				return Vector2.New(0, -122 + #PengGangList_R * 95 + 33)
			else
				return Vector2.New(0, -150 + #PengGangList_R * 95 + i * 28)
			end
		end,
		[3] = function(i)
			prefab = PengGangCard_T
			prefabback = GangBack_T
			if (i == 4) then
				return Vector2.New(251 - #PengGangList_T * 120 + 37, 20)
			else
				return Vector2.New(214 - #PengGangList_T * 120 + i * 37, 0)
			end
		end,
		[4] = function(i)
			prefab = PengGangCard_L
			prefabback = GangBack_LR
			if (i == 4) then
				return Vector2.New(0, 122 - #PengGangList_L * 95 - 18)
			else
				return Vector2.New(0, 150 - #PengGangList_L * 95 - i * 28)
			end
		end,
	}
	for i = 1, 4 do
		local pos = switch[LocalIndex](i)
		local obj = nil
		if (i == 4 and show) then
			obj = newObject(prefab)
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
			table.insert(TempList, objCtrl)
		else
			obj = newObject(prefabback)
			table.insert(TempList, obj)
		end
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = pos
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
	end
	this.AddListToPengGangList(LocalIndex, TempList)
end

-- 重连显示碰牌
function GamePanel.DoDisplayPengCard(LocalIndex, point)
	log("GamePanel.DoDisplayPengCard")
	local TempList = { };
	local prefab = nil
	switch =
	{
		[1] = function(i) prefab = PengGangCard_B return Vector3.New(-430 + #PengGangList_B * 190 + i * 60, 0) end,
		[2] = function(i) prefab = PengGangCard_R return Vector3.New(0, -150 + #PengGangList_R * 95 + i * 28) end,
		[3] = function(i) prefab = PengGangCard_T return Vector3.New(214 - #PengGangList_T * 120 + i * 37, 0) end,
		[4] = function(i) prefab = PengGangCard_L return Vector3.New(0, 150 - #PengGangList_L * 95 - i * 28) end,
	}
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(prefab)
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = pos
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex, GlobalData.roomVo.guiPai == point);
		table.insert(TempList, objCtrl)
	end
	this.AddListToPengGangList(LocalIndex, TempList)
end
-- 重连显示吃牌
-- chipai一组吃牌的牌值
function GamePanel.DoDisplayChiCard(LocalIndex, chipai)
	log("GamePanel.DoDisplayChiCard")
	local TempList = { };
	local prefab = nil
	switch =
	{
		[1] = function(i) prefab = PengGangCard_B return Vector3.New(-430 + #PengGangList_B * 190 + i * 60, 0) end,
		[2] = function(i) prefab = PengGangCard_R return Vector3.New(0, -150 + #PengGangList_R * 95 + i * 28) end,
		[3] = function(i) prefab = PengGangCard_T return Vector3.New(214 - #PengGangList_T * 120 + i * 37, 0) end,
		[4] = function(i) prefab = PengGangCard_L return Vector3.New(0, 150 - #PengGangList_L * 95 - i * 28) end,
	}
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(prefab)
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = pos
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(chipai[i], LocalIndex, GlobalData.roomVo.guiPai == chipai[i]);
		table.insert(TempList, objCtrl)
	end
	this.AddListToPengGangList(LocalIndex, TempList)
end

function GamePanel.InviteFriend()
	GlobalData.wechatOperate:inviteFriend();
end

-- 用户离线回调
function GamePanel.OfflineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = this.GetIndex(uuid) -1;
	local LocalIndex = this.GetLocalIndex(index);
	switch =
	{
		[1] = function()
			playerItems[1]:SetPlayerOffline(true);
		end,
		[2] = function()
			playerItems[2]:SetPlayerOffline(true);
		end,
		[3] = function()
			playerItems[3]:SetPlayerOffline(true);
		end,
		[4] = function()
			playerItems[4]:SetPlayerOffline(true);
		end
	}
	switch[LocalIndex]()
	-- 申请解散房间过程中，有人掉线，直接不能解散房间
	if (GlobalData.isonApplayExitRoomstatus) then
		VotePanel:Close()
		TipsManager.SetTips("由于" .. avatarList[index].account.nickname .. "离线，系统不能解散房间")
	end
end

-- 用户上线提醒
function GamePanel.OnlineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = this.GetIndex(uuid) -1;
	local LocalIndex = this.GetLocalIndex(index);
	playerItems[LocalIndex]:SetPlayerOffline(false);
end

function GamePanel.MessageBoxNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local arr = string.split(message, '|')
	local uuid = tonumber(arr[1]);
	local index = this.GetIndex(uuid) -1;
	local LocalIndex = this.GetLocalIndex(index);
	playerItems[LocalIndex]:ShowChatMessage(tonumber(arr[1]));
end


-- 发准备消息
function GamePanel.ReadyGame()
	local readyvo = { };
	readyvo.duanMen = ReadySelect[1].isOn;
	readyvo.jiaGang = ReadySelect[2].isOn;
	log("ReadySelect[1].isOn=" .. tostring(ReadySelect[1].isOn) .. "ReadySelect[2].isOn=" .. tostring(ReadySelect[2].isOn));
	ReadySelect[1].gameObject:SetActive(false);
	ReadySelect[2].gameObject:SetActive(false);
	btnReadyGame:SetActive(false);
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end

function GamePanel.MicInputNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local sendUUid = tonumber(message)
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

function GamePanel.ReturnGameResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local returnstr = message;
	log("ReturnGameResponse=" .. returnstr);

	local returnJsonData = json.decode(message);
	-- 1.显示剩余牌的张数和圈数
	local surplusCards = returnJsonData.surplusCards;
	local gameRound = returnJsonData.gameRound;
	LeavedCastNumText.text = tostring(surplusCards);
	LeavedCardsNum = surplusCards;
	LeavedRoundNumText.text = tostring(gameRound);
	GlobalData.surplusTimes = gameRound;
	-- 当前打牌人本地索引
	LastAvarIndex = this.GetLocalIndex(returnJsonData.curAvatarIndex);
	-- 打的点数
	putOutCardPoint = returnJsonData.putOffCardPoint;
	SelfAndOtherPutoutCard = putOutCardPoint;
	-- 当前摸牌牌人的索引(可能为空)
	local pickAvatarIndex =(returnJsonData.pickAvatarIndex or -1) + 1;
	-- 当前摸的牌值（可能为空）
	local currentCardPoint = returnJsonData.currentCardPoint or -1
	local LocalIndex = LastAvarIndex
	if (pickAvatarIndex == this.GetMyIndexFromList()) then
		local count = #this.handerCardList[1]
		-- 吃碰杠之后
		if (currentCardPoint == -2) then
			local cardPoint = this.handerCardList[1][count].CardPoint;
			SelfAndOtherPutoutCard = cardPoint;
			this.SortMyCardList()
			-- 摸牌之后
		elseif (count % 3 == 2) then
			local cardPoint = returnJsonData.currentCardPoint;
			SelfAndOtherPutoutCard = cardPoint;
			this.SortMyCardList(cardPoint)
		end
		this.SetPosition();
		this.SetDirGameObjectAction(1);
		GlobalData.isDrag = true;
	else
		this.SortMyCardList()
		this.SetPosition();
		-- 别人摸牌
		this.SetDirGameObjectAction(LocalIndex);
	end

	if (tableCardList[LocalIndex] == nil or #tableCardList[LocalIndex] == 0) then
		-- 刚启动
	else
		local obj = tableCardList[LocalIndex][#tableCardList[LocalIndex]];
		cardOnTable = obj;
		this.SetPointGameObject(cardOnTable);
	end
end





-- 解散房间按钮
function GamePanel.InitbtnJieSan()
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
	this.lua:AddClick(btnJieSan, this.QuiteRoom)
end
-- 给其他玩家设置牌位置
function GamePanel.SetOtherCardObjPosition(tempList, LocalIndex)
	print("GamePanel.SetOtherCardObjPosition")
	local switch =
	{
		[2] = Vector2.New(0,180),
		[3] = Vector2.New(-273,0),
		[4] = Vector2.New(0,- 173),
	}

	tempList[1].transform.localPosition = switch[LocalIndex]

	switch =
	{
		[2] = function(i) return Vector2.New(0, 179 - i * 30) end,
		[3] = function(i) return Vector2.New(-278 + 37 * i, 0) end,
		[4] = function(i) return Vector2.New(0, -165 + i * 30) end,
	}

	for i = 2, #tempList do
		tempList[i].transform.localPosition = switch[LocalIndex](i)
	end
end
-- 测试方法，用来打印table
function GamePanel.Test()
	return {
		avatarList,
		this.handerCardList,
	}
end
------------------------------------------------------------
function GamePanel.OnOpen()
	this.RandShowTime();
	timeFlag = true;
	soundMgr:playBGM(2);
	versionText.text = "V" .. Application.version;
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
	-- 重进房间的数据在这里清空了
	GlobalData.reEnterRoomData = nil;
	TipsManager.SetTips("", 0);
	dialog_fanhui.gameObject:SetActive(false);
	this.InitbtnJieSan();
end
-- 移除事件--
function GamePanel.RemoveListener()
	UpdateBeat:RemoveListener(this.Update);
	Event.RemoveListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
	Event.RemoveListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
	Event.RemoveListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
	Event.RemoveListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
	Event.RemoveListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
	Event.RemoveListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
	Event.RemoveListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
	Event.RemoveListener(tostring(APIS.GANGPAI_RESPONSE), this.GangResponse)
	Event.RemoveListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.OtherGang)
	Event.RemoveListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
	Event.RemoveListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
	Event.RemoveListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
	Event.RemoveListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
	Event.RemoveListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
	Event.RemoveListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
	Event.RemoveListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
	Event.RemoveListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
	Event.RemoveListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
	Event.RemoveListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
	Event.RemoveListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
	Event.RemoveListener(closeGamePanel, this.ExitOrDissoliveRoom)
end


-- 增加事件--
function GamePanel.AddListener()
	UpdateBeat:Add(this.Update);
	Event.AddListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
	Event.AddListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
	Event.AddListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
	Event.AddListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
	Event.AddListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
	Event.AddListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
	Event.AddListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
	Event.AddListener(tostring(APIS.GANGPAI_RESPONSE), this.GangResponse)
	Event.AddListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.OtherGang)
	Event.AddListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
	Event.AddListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
	Event.AddListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
	Event.AddListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
	Event.AddListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
	Event.AddListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
	Event.AddListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
	Event.AddListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
	Event.AddListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
	Event.AddListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
	Event.AddListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
	Event.AddListener(closeGamePanel, this.ExitOrDissoliveRoom)
end
