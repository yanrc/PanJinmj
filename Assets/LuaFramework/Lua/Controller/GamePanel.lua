

GamePanel = UIBase(define.Panels.GamePanel, define.FixUI)
local this = GamePanel
local CurrentGame = this
-----------------------------------------------------------------------------------------------------------------
-- 需要用到的对象
local gameObject;
local transform
this.playerItems = { }
local versionText
this.LeavedRoundNumText = nil
this.LeavedCastNumText = nil
local ruleText
local btnInviteFriend
local btnJieSan
local lbRoomNum-- 大房间号
local btnMessageBox
local ExitRoomButton
local live1
local live2
local centerImage
local guiObj-- 翻开的鬼牌
local roomRemark-- 房间显示的规则
local btnSetting-- 设置按钮
this.btnReadyGame = nil
local noticeGameObject-- 滚动消息
local noticeText
local Number-- 桌子中间显示的数字（剩余时间）
local touziObj-- 骰子
local Pointer-- 指针
this.imgDuanMen = nil
-- 手牌模板
local BottomPrefabs
-- 桌牌模板
local ThrowPrefabs
-- 吃碰杠牌模板
local CPGPrefabs
-- 暗杠牌模板
local BackPrefabs
-- 吃碰杠胡特效
local chiEffectGame
local pengEffectGame
local gangEffectGame
local huEffectGame
local liujuEffectGame
local effBu
this.huBtn = nil
this.gangBtn = nil
this.pengBtn = nil
this.chiBtn = nil
this.passBtn = nil
this.btnBu = nil
this.ChiSelect1 = nil
this.ChiSelect2 = nil
this.ChiSelect3 = nil
this.ReadySelect = { } -- 游戏准备toggle列表
this.lbReadySelect = { } -- 游戏准备toggle文字
local dirGameList = { }-- 桌面指示灯
local parentList = { }-- 手牌的父对象
local cpgParent = { }-- 吃碰杠牌的父对象
local outparentList = { }-- 出牌的父对象
-- 保存吃牌时的三套牌
local canChiList = { }
local chiList_1 = { }
local chiList_2 = { }
local chiList_3 = { }
-----------------------------------------------------------------------------------------------------------------
-- 重要数据
-- 0自己，1-右边。2-上边。3-左边
this.handerCardList = { }
-- 打在桌上的牌,gameObject
local tableCardList = { }
-- 玩家列表
this.avatarList = { }
-- 吃碰杠list
local PengGangList = { }


----------------------------------------------------------------------------------------------------------------

local CurLocalIndex = 1;-- 当前操作位
-- 上一个出牌者
local LastAvarIndex = 1
-- 保存碰和点炮胡的牌值
this.putOutCardPoint = -1
-- 保存服务器杠按钮通知的牌值
this.gangPaiList = { }
this.kaigangPaiList = { };
-- 保存吃按钮通知的牌值
this.chiPaiPointList = { }
this.passStr = ""-- “过”操作字符串

----------------------------------------------------------------------------------------------------------------
-- 无关紧要的数据
local disagreeCount = 0-- 不同意的人数
local VoteStatus = false-- 申请解散的状态
local showTimeNumber = 0

this.LeavedCardsNum = 0 -- 剩余牌数
local timer = 0
-- 当前显示的消息
local showNoticeNumber = 1
local timeFlag = false
GamePanel.__index = GamePanel
function GamePanel.OnCreate(go)
	gameObject = go;
	transform = go.transform
	this:Init(go)

	versionText = transform:FindChild('Text_version'):GetComponent('Text');
	this.LeavedRoundNumText = transform:FindChild('Leaved1/Text'):GetComponent('Text');
	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	btnInviteFriend = transform:FindChild('UIroot/Button_invite_friend').gameObject;
	btnJieSan = transform:FindChild('UIroot/Button_jiesan').gameObject;
	lbRoomNum = transform:FindChild('UIroot/lbRoomNum'):GetComponent('Text');
	ExitRoomButton = transform:FindChild('Button_other'):GetComponent('Button');
	live1 = transform:FindChild('Leaved'):GetComponent('Image');
	live2 = transform:FindChild('Leaved1'):GetComponent('Image');
	centerImage = transform:FindChild('table'):GetComponent('Image');

	chiEffectGame = transform:FindChild('ChiEffect_B').gameObject
	pengEffectGame = transform:FindChild('PengEffect_B').gameObject
	gangEffectGame = transform:FindChild('GangEffect_B').gameObject
	huEffectGame = transform:FindChild('HuEffect_B').gameObject
	liujuEffectGame = transform:FindChild('Liuju_B').gameObject
	effBu = transform:FindChild('effBu').gameObject

	ruleText = transform:FindChild('Rule'):GetComponent('Text');
	this.LeavedCastNumText = transform:FindChild('Leaved/Text'):GetComponent('Text');
	guiObj = transform:FindChild('gui').gameObject
	roomRemark = transform:FindChild('Text'):GetComponent('Text')
	local players = transform:FindChild('playList')
	dirGameList[1] = transform:FindChild('table/Down/Red1').gameObject
	dirGameList[2] = transform:FindChild('table/Right/Red2').gameObject
	dirGameList[3] = transform:FindChild('table/Up/Red3').gameObject
	dirGameList[4] = transform:FindChild('table/Left/Red4').gameObject
	this.playerItems[1] = PlayerItem.New(players:FindChild('Player_B').gameObject)
	this.playerItems[2] = PlayerItem.New(players:FindChild('Player_R').gameObject)
	this.playerItems[3] = PlayerItem.New(players:FindChild('Player_T').gameObject)
	this.playerItems[4] = PlayerItem.New(players:FindChild('Player_L').gameObject)

	this.ReadySelect[1] = transform:FindChild('Panel/DuanMen'):GetComponent('Toggle')
	this.ReadySelect[2] = transform:FindChild('Panel/Gang'):GetComponent('Toggle')
	this.lbReadySelect[1] = transform:FindChild('Panel/DuanMen/Label'):GetComponent('Text')
	this.lbReadySelect[2] = transform:FindChild('Panel/Gang/Label'):GetComponent('Text')
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
	this.btnReadyGame = transform:FindChild('Panel/Button').gameObject
	Number = transform:FindChild('table/Number'):GetComponent('Text')
	noticeGameObject = transform:FindChild("Image_Notice_BG").gameObject
	noticeText = transform:FindChild("Image_Notice_BG/textbg/Text"):GetComponent('Text')
	btnSetting = transform:FindChild('soundClose').gameObject

	touziObj = transform:FindChild('Panel_touzi').gameObject
	canChiList[1] = transform:FindChild('ChiList/list_1').gameObject
	canChiList[2] = transform:FindChild('ChiList/list_2').gameObject
	canChiList[3] = transform:FindChild('ChiList/list_3').gameObject
	chiList_1[1] = BottomScript.New(transform:FindChild('ChiList/list_1/Bottom_1').gameObject)
	chiList_1[2] = BottomScript.New(transform:FindChild('ChiList/list_1/Bottom_2').gameObject)
	chiList_1[3] = BottomScript.New(transform:FindChild('ChiList/list_1/Bottom_3').gameObject)
	chiList_2[1] = BottomScript.New(transform:FindChild('ChiList/list_2/Bottom_1').gameObject)
	chiList_2[2] = BottomScript.New(transform:FindChild('ChiList/list_2/Bottom_2').gameObject)
	chiList_2[3] = BottomScript.New(transform:FindChild('ChiList/list_2/Bottom_3').gameObject)
	chiList_3[1] = BottomScript.New(transform:FindChild('ChiList/list_3/Bottom_1').gameObject)
	chiList_3[2] = BottomScript.New(transform:FindChild('ChiList/list_3/Bottom_2').gameObject)
	chiList_3[3] = BottomScript.New(transform:FindChild('ChiList/list_3/Bottom_3').gameObject)
	this.huBtn = transform:FindChild("btnList/huBtn").gameObject
	this.gangBtn = transform:FindChild("btnList/GangButton").gameObject
	this.pengBtn = transform:FindChild("btnList/PengButton").gameObject
	this.chiBtn = transform:FindChild("btnList/ChiButton").gameObject
	this.passBtn = transform:FindChild("btnList/PassButton").gameObject
	this.btnBu = transform:FindChild("btnList/btnBu").gameObject
	this.ChiSelect1 = transform:FindChild("ChiList/list_1/Button").gameObject
	this.ChiSelect2 = transform:FindChild("ChiList/list_2/Button").gameObject
	this.ChiSelect3 = transform:FindChild("ChiList/list_3/Button").gameObject
	btnMessageBox = transform:FindChild('btnMessageBox').gameObject
	this.imgDuanMen = transform:FindChild('imgDuanMen'):GetComponent('Image');
	MicPhone.OnCreate(go)
	MessageBox.OnCreate(transform, this.lua)
	this.lua:AddClick(btnMessageBox, MessageBox.MoveIn)
	this.lua:AddClick(btnSetting, this.OpenSettingPanel)
	this.lua:AddClick(btnJieSan, this.QuiteRoom)
	this.lua:AddClick(btnInviteFriend, this.InviteFriend)
	for i = 1, #this.playerItems do
		this.lua:AddClick(this.playerItems[i].gameObject, PlayerItem.DisplayAvatorIp, this.playerItems[i])
	end
end


function GamePanel.RandShowTime()
	showTimeNumber = math.random(5000, 10000)
end

-- 初始化一次表
function GamePanel.InitArrayList()
	for i = 1, 4 do
		this.handerCardList[i] = { }
		tableCardList[i] = { }
		PengGangList[i] = { }
	end
end

function GamePanel.CardSelect(objCtrl)
	for k, v in pairs(this.handerCardList[1]) do
		this.handerCardList[1][k].selected = false;
	end
	objCtrl.selected = true
end

function GamePanel.StartGame(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local sgvo = json.decode(message);
	this.CleanGameplayUI();
	this.UpateTimeReStart();
	this.LeavedRoundNumText.text = tostring(sgvo.surplusRounds)
	this.InitLeftCard();
	this.ShowRuleText(sgvo)

	RoomData.guiPai = sgvo.gui;
	RoomData.surplusTimes = sgvo.surplusRounds
	RoomData.isOverByPlayer = false;

	this.avatarList[sgvo.bankerId + 1].main = true;
	local LocalIndex = this.GetLocalIndex(sgvo.bankerId);
	this.playerItems[LocalIndex].bankerImg.enabled = true
	this.SetDirGameObjectAction(LocalIndex);
	this.DisplayTouzi(sgvo.touzi, sgvo.gui);
	this.InitMyCard(sgvo.paiArray);
	for i = 2, 4 do
		if i == LocalIndex then
			this.InitOtherCardList(i, 14);
		else
			this.InitOtherCardList(i, 13);
		end
	end
end

function GamePanel.ShowRuleText(sgvo)
	local ruleStr = "";
	if (RoomData.pingHu) then
		ruleStr = ruleStr .. "穷胡\n";
	end
	if (RoomData.baoSanJia) then
		ruleStr = ruleStr .. "包三家\n";
	end
	if (RoomData.gui == 2) then
		ruleStr = ruleStr .. "带会儿\n";
	end
	if (RoomData.jue) then
		ruleStr = ruleStr .. "绝\n";
	end
	if (RoomData.jiaGang) then
		ruleStr = ruleStr .. "加钢\n";
	end
	if (RoomData.duanMen and sgvo.duanMen) then
		ruleStr = ruleStr .. "买断门\n";
	end
	if (RoomData.jihu) then
		ruleStr = ruleStr .. "鸡胡\n";
	end
	if (RoomData.qingYiSe) then
		ruleStr = ruleStr .. "清一色\n";
	end
	ruleText.text = ruleStr;
end

function GamePanel.CleanGameplayUI()
	log("GamePanel.CleanGameplayUI")
	RoomData.enterType = 4
	-- weipaiImg.transform.gameObject:SetActive(false);
	btnInviteFriend:SetActive(false);
	btnJieSan:SetActive(false);
	ExitRoomButton.transform.gameObject:SetActive(false);
	live1.transform.gameObject:SetActive(true);
	live2.transform.gameObject:SetActive(true);
	-- tab.transform.gameObject:SetActive(true);
	centerImage.transform.gameObject:SetActive(true);
	liujuEffectGame:SetActive(false);
	this.SetAllPlayerReadImgVisbleToFalse();
	ruleText.text = "";
	lbRoomNum.text = ""
end

function GamePanel.InitLeftCard()
	this.LeavedCardsNum = 136
	this.LeavedCardsNum = this.LeavedCardsNum - 53;
	this.LeavedCastNumText.text = tostring(this.LeavedCardsNum);
end

function GamePanel.CardsNumChange()
	this.LeavedCardsNum = this.LeavedCardsNum - 1;
	if (this.LeavedCardsNum < 0) then
		this.LeavedCardsNum = 0;
	end
	this.LeavedCastNumText.text = tostring(this.LeavedCardsNum);
end


function GamePanel.CreateMoPaiGameObject(LocalIndex)
	local switch = {
		[1] = Vector2.New(-446 + #this.handerCardList[1] * 80,- 292),
		[2] = Vector2.New(0,- 301 + #this.handerCardList[2] * 30),
		[3] = Vector2.New(226 - 37 * #this.handerCardList[3],0),
		[4] = Vector2.New(0,255 - #this.handerCardList[4] * 30)
	}
	local obj = newObject(BottomPrefabs[LocalIndex])
	obj.transform:SetParent(parentList[LocalIndex])
	if (LocalIndex == 2) then
		obj.transform:SetAsFirstSibling()
	end
	obj.transform.localPosition = switch[LocalIndex]
	obj.transform.localScale = Vector3.one;
	return obj
end
-- 摸牌
function GamePanel.PickCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardvo = json.decode(message);
	local cardPoint = cardvo.cardPoint;
	local LocalIndex = this.GetLocalIndex(cardvo.avatarIndex)
	this.SetDirGameObjectAction(LocalIndex);
	this.CardsNumChange();
	local go = this.CreateMoPaiGameObject(LocalIndex)
	go.name = cardPoint;
	if (LocalIndex == 1) then
		go.transform.localScale = Vector3.New(1.1, 1.1, 1);
		local objCtrl = BottomScript.New(go)
		objCtrl.OnSendMessage = this.CardChange;
		objCtrl.ReSetPoisiton = this.CardSelect;
		objCtrl:Init(cardPoint);
		table.insert(this.handerCardList[1], objCtrl)
	else
		table.insert(this.handerCardList[LocalIndex], go)
	end
end
-- 别人摸牌通知
function GamePanel.OtherPickCard(buffer)
--	local status = buffer:ReadInt()
--	local message = buffer:ReadString()
--	local json = json.decode(message);
--	local avatarIndex = json["avatarIndex"];
--	local LocalIndex = this.GetLocalIndex(avatarIndex)
--	this.SetDirGameObjectAction(LocalIndex);
--	this.CardsNumChange();
--	-- 创建其他玩家的摸牌对象
--	local go = this.CreateMoPaiGameObject(LocalIndex)
--	table.insert(this.handerCardList[LocalIndex], go)
end
-- 胡，杠，碰，吃，pass按钮显示.
function GamePanel.ActionBtnShow(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	log("GamePanel ActionBtnShow:msg =" .. tostring(message));
	this.passStr = "";
	local strs = string.split(message, ',')
	this.ShowBtn(5, true);
	for i = 1, #strs do
		if string.match(strs[i], "hu") then
			this.ShowBtn(1, true);
			this.passStr = this.passStr .. "hu_"
		end
		if string.match(strs[i], "qianghu") then
			this.putOutCardPoint = string.split(strs[i], ':')[2]
			this.ShowBtn(1, true);
			this.passStr = this.passStr .. "qianghu_"
		end
		if string.match(strs[i], "peng") then
			this.ShowBtn(3, true);
			this.putOutCardPoint = string.split(strs[i], ':')[3]
			this.passStr = this.passStr .. "peng_"
		end
		if string.match(strs[i], "gang") then
			this.ShowBtn(2, true);
			this.gangPaiList = string.split(strs[i], ':');
			table.remove(this.gangPaiList, 1)
			this.passStr = this.passStr .. "gang_"
		end
		if string.match(strs[i], "chi") then
			-- 格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			-- eg:"chi:1:2|1_2_3|2_3_4"
			local strChi = string.split(strs[i], '|');
			local cardPoint = string.split(strChi[1], ':')[3];
			this.chiPaiPointList = { };
			for m = 2, #strChi do
				local strChiList = string.split(strChi[m], '_');
				local cpoint = { };
				cpoint.putCardPoint = cardPoint;
				for n = 1, #strChiList do
					if (strChiList[n] == cardPoint) then
						table.remove(strChiList, n)
					end
				end
				cpoint.oneCardPoint = strChiList[1]
				cpoint.twoCardPoint = strChiList[2]
				table.insert(this.chiPaiPointList, cpoint)
			end
			this.ShowBtn(4, true);
			this.passStr = this.passStr .. "chi_"
		end
	end
end

-- 手牌排序，鬼牌移到最前
-- point：最后摸的那张牌值
function GamePanel.SortMyCardList()
	local selfIndex = this.GetMyIndexFromList()
	if this.avatarList[selfIndex].tingPai then
		return
	end
	table.sort(this.handerCardList[1],
	function(a, b)
		-- print("a=" .. Test.DumpTab(a))
		-- print("b=" .. Test.DumpTab(b))
		-- b是鬼牌
		if b.cardPoint == RoomData.guiPai then
			return false
			-- a是鬼牌
		elseif (a.cardPoint == RoomData.guiPai) then
			return true
			-- 都不是鬼牌，比较大小
		else
			return a.cardPoint < b.cardPoint
		end
	end )
end

-- 初始化手牌
function GamePanel.InitMyCard(mineList)
	for i = 1, #mineList[1] do
		if (mineList[1][i] > 0) then
			for j = 1, mineList[1][i] do
				local cardPoint = i - 1
				local go = newObject(BottomPrefabs[1])
				go.transform:SetParent(parentList[1]);
				go.transform.localScale = Vector3.New(1.1, 1.1, 1);
				local objCtrl = BottomScript.New(go)
				objCtrl.OnSendMessage = this.CardChange;
				objCtrl.ReSetPoisiton = this.CardSelect;
				objCtrl:Init(cardPoint);
				table.insert(this.handerCardList[1], objCtrl)
			end
		end
	end
	this.SortMyCardList();
	this.SetPosition(1)
end

function GamePanel.SetAllPlayerReadImgVisbleToFalse()
	for _, v in pairs(this.playerItems) do
		v.readyImg.enabled = false
	end
end
function GamePanel.HidePlayerItemImg()
	for _, v in pairs(this.playerItems) do
		v.HuFlag.enabled = false
		v.jiaGang.enabled = false
		v.bankerImg.enabled = false
	end
end

-- 初始化其他人的手牌
function GamePanel.InitOtherCardList(LocalIndex, count)
	log("GamePanel.InitOtherCardList")
	for i = 1, count do
		local go = newObject(BottomPrefabs[LocalIndex])
		go.transform:SetParent(parentList[LocalIndex]);
		if (LocalIndex == 2) then
			go.transform:SetAsFirstSibling()
		end
		go.transform.localScale = Vector3.one;
		table.insert(this.handerCardList[LocalIndex], go)
	end
	this.SetPosition(LocalIndex)
end

-- 摸牌
-- function GamePanel.MoPai(cardPoint)
-- print("GamePanel MoPai");
-- local go = newObject(BottomPrefabs[1])
-- go.name = cardPoint;
-- go.transform:SetParent(parentList[1]);
-- go.transform.localScale = Vector3.New(1.1, 1.1, 1);
-- go.transform.localPosition = Vector3.New(580, -292);
-- local objCtrl = BottomScript.New(go)
-- objCtrl.OnSendMessage = this.CardChange;
-- objCtrl.ReSetPoisiton = this.CardSelect;
-- objCtrl:Init(cardPoint);
-- --this.InsertCardIntoList(objCtrl);
-- table.insert(this.handerCardList[1], objCtrl)
-- end
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

-- 自己出牌（自己收不到出牌通知）
function GamePanel.CardChange(objCtrl)
	-- 这时候才能出牌
	if (CurLocalIndex == 1) then
		objCtrl.OnSendMessage = nil;
		objCtrl.ReSetPoisiton = nil;
		local cardPoint = objCtrl.cardPoint;
		-- this.PushOutFromMineList(cardPoint);
		this.CreatePutOutCardAndPlayAction(cardPoint, this.GetMyIndexFromList() -1, objCtrl.transform.position);
		-- 将打出牌移除
		for k, v in pairs(this.handerCardList[1]) do
			if v == objCtrl then
				table.remove(this.handerCardList[1], k)
				destroy(v.gameObject);
				break
			end
		end
		-- 出完牌排序
		this.SortMyCardList()
		this.SetPosition(1);
		-- 出牌动画
		local cardvo = { }
		cardvo.cardPoint = cardPoint;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHUPAI_REQUEST, json.encode(cardvo)));
		LastAvarIndex = 1;
		CurLocalIndex = 2
		this.CleanBtnShow();
		return true
	end
	return false
end
-- 接收到其它人的出牌通知
function GamePanel.OtherPutOutCard(buffer)
	print("GamePanel.OtherPutOutCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local json = json.decode(message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex = json["curAvatarIndex"];
	local LocalIndex = this.GetLocalIndex(curAvatarIndex);
	local count = #this.handerCardList[LocalIndex]
	local obj = this.handerCardList[LocalIndex][count];
	this.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, obj.transform.position);
	table.remove(this.handerCardList[LocalIndex])
	destroy(obj)
	LastAvarIndex = LocalIndex;
end
-- 创建打来的的牌对象，并且开始播放动画
-- curAvatarIndex:在this.avatarList里的下标
function GamePanel.CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, position)
	log("GamePanel.CreatePutOutCardAndPlayAction")
	soundMgr:playSound(cardPoint, this.avatarList[curAvatarIndex + 1].account.sex);
	local LocalIndex = this.GetLocalIndex(curAvatarIndex);
	-- 飞出去的牌
	local obj = newObject(ThrowPrefabs[LocalIndex])
	obj.transform:SetParent(outparentList[LocalIndex])
	obj.transform.localPosition = position
	obj.transform.localScale = Vector3.one
	obj.name = "putOutCard";
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, LocalIndex);
	if (LocalIndex == 2) then
		obj.transform:SetAsFirstSibling();
	end
	-- 显示在桌上的牌
	local destination = this.TableCardPosition(LocalIndex)
	local go = this.ThrowBottom(cardPoint, LocalIndex, destination, false)
	local tweener = obj.transform:DOLocalMove(destination, 1, false):OnComplete(
	function()
		if (obj ~= nil) then
			destroy(obj)
			objCtrl = nil
		end
		if (not IsNil(go)) then
			go:SetActive(true)
		end
	end );
	tweener:SetEase(Ease.OutExpo);
end



-- 设置红色箭头的显示方向
function GamePanel.SetDirGameObjectAction(LocalIndex)
	-- 重新计时
	this.UpateTimeReStart();
	for i = 1, #dirGameList do
		dirGameList[i]:SetActive(false);
	end
	dirGameList[LocalIndex]:SetActive(true);
	CurLocalIndex = LocalIndex;
end

function GamePanel.ThrowBottom(cardPoint, LocalIndex, pos, isActive)
	local obj = newObject(ThrowPrefabs[LocalIndex])
	obj.transform:SetParent(outparentList[LocalIndex])
	obj.transform.localPosition = pos
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, LocalIndex);
	obj.name = tostring(cardPoint);
	obj.transform.localScale = Vector3.one;
	if (LocalIndex == 2) then obj.transform:SetAsFirstSibling() end
	table.insert(tableCardList[LocalIndex], obj)
	if (not isActive) then obj:SetActive(false) end
	this.SetPointGameObject(obj);
	return obj
end

-- 吃碰杠牌的位置，i:第几墩，j:第几张牌
function GamePanel.CPGPosition(LocalIndex, i, j)
	local switch =
	{
		[1] = function(i, j)
			if (j == 4) then
				return Vector2.New(650 - i * 190, 24)
			else
				return Vector2.New(530 - i * 190 + j * 60, 0)
			end
		end,
		[2] = function(i, j)
			if (j == 4) then
				return Vector2.New(0, 267 - i * 95 + 62)
			else
				return Vector2.New(0, 267 - i * 95 + j * 26);
			end
		end,
		[3] = function(i, j)
			if (j == 4) then
				return Vector2.New(-345 + i * 120, 20)
			else
				return Vector2.New(-271 + i * 120 - j * 37, 0);
			end
		end,
		[4] = function(i, j)
			if (j == 4) then
				return Vector2.New(0, -267 + i * 95 - 47)
			else
				return Vector2.New(0, -267 + i * 95 - j * 26);
			end
		end
	}
	local pos = switch[LocalIndex](i, j)
	return pos
end

function GamePanel.PengCard(buffer)
	print("GamePanel.PengCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	-- 设置方向灯
	this.SetDirGameObjectAction(LocalIndex);
	-- 播放特效
	this.PengGangHuEffectCtrl("peng");
	soundMgr:playSoundByAction("peng", this.avatarList[cardVo.avatarId + 1].account.sex);
	-- 销毁桌上被碰的牌
	this.RemoveLastCardOnTable()
	local cardPoint = cardVo.cardPoint
	-- 消除手牌
	this.RemoveHandCard(LocalIndex, cardPoint, 2)
	this.AddCPGToTable(LocalIndex, cardPoint, 3, 0)
	this.SetPosition(LocalIndex);
end


function GamePanel.ChiCard(buffer)
	print("GamePanel.ChiCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	this.SetDirGameObjectAction(LocalIndex);
	this.PengGangHuEffectCtrl("chi");
	soundMgr:playSoundByAction("chi", this.avatarList[cardVo.avatarId + 1].account.sex);
	-- 销毁桌上被吃的牌
	this.RemoveLastCardOnTable()
	this.RemoveHandCard(LocalIndex, cardVo.onePoint, 1)
	this.RemoveHandCard(LocalIndex, cardVo.twoPoint, 1)
	this.AddCPGToTable(LocalIndex, { cardVo.cardPoint, cardVo.onePoint, cardVo.twoPoint })
	this.SetPosition(LocalIndex);
end

-- 0.明杠，1.暗杠，2.补杠
function GamePanel.GangCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	this.PengGangHuEffectCtrl("gang");
	soundMgr:playSoundByAction("gang", this.avatarList[cardVo.avatarId + 1].account.sex)
	local LocalIndex = this.GetLocalIndex(cardVo.avatarId);
	this.SetDirGameObjectAction(LocalIndex);
	local gangType = cardVo.type;
	local cardPoint = cardVo.cardPoint
	local kaigang = cardVo.kaigang
	-- 明杠
	if gangType == 0 then
		-- 销毁桌上被碰的牌
		this.RemoveLastCardOnTable()
		-- 去掉三张手牌
		this.RemoveHandCard(LocalIndex, cardPoint, 3)
		this.AddCPGToTable(LocalIndex, cardPoint, 4, 0)
		-- 暗杠
	elseif (gangType == 1) then
		-- 去掉四张手牌
		this.RemoveHandCard(LocalIndex, cardPoint, 4)
		this.AddCPGToTable(LocalIndex, cardPoint, 1, 3)
		-- 补杠
	elseif gangType == 2 then
		this.RemoveHandCard(LocalIndex, cardPoint, 1)
		this.AddCPGToTable(LocalIndex, cardPoint)
	end
	if kaigang then
		this.avatarList[cardVo.avatarId + 1].tingPai = true
		this.LockHandCard(LocalIndex)
	end
	this.SetPosition(LocalIndex);
end

function GamePanel.LockHandCard(Index)
	local count = #this.handerCardList[Index]
	if count % 3 == 2 then
		count = count - 1
	end
	if Index == 1 then
		for i = 1, count do
			this.handerCardList[Index][i].IsTingLock = true
			this.handerCardList[Index][i].bg.color = Color.gray
		end
	else
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/paidimian_05.png' }, function(sprites)
			for i = 1, count do
				this.handerCardList[Index][i]:GetComponent('Image').sprite = sprites[0]
				if (Index == 3) then
					this.handerCardList[Index][i]:GetComponent('RectTransform').sizeDelta = Vector2.New(39, 54)
				else
					this.handerCardList[Index][i]:GetComponent('RectTransform').sizeDelta = Vector2.New(45, 30)
				end
			end
		end )
	end
end

-- 牌值，第几墩，显示几张牌，盖几张牌
function GamePanel.AddCPGToTable(LocalIndex, cardPoint, shownum, hidenum)
	-- 吃
	if type(cardPoint) == "table" then
		local tempList = { };
		tempList.cardPoint = cardPoint[1]
		for i = 1, #cardPoint do
			local obj = newObject(CPGPrefabs[LocalIndex])
			obj.transform:SetParent(cpgParent[LocalIndex])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
			if (LocalIndex == 2) then
				obj.transform:SetAsFirstSibling();
			end
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(cardPoint[i], LocalIndex);
			table.insert(tempList, obj)
		end
		table.insert(PengGangList[LocalIndex], tempList)
	else
		local index = this.GetPaiInpeng(cardPoint, LocalIndex);
		if index == -1 then
			local tempList = { };
			tempList.cardPoint = cardPoint
			for i = 1, hidenum do
				local obj = newObject(BackPrefabs[LocalIndex])
				obj.transform:SetParent(cpgParent[LocalIndex])
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
				if (LocalIndex == 2) then
					obj.transform:SetAsFirstSibling();
				end
				table.insert(tempList, obj)
			end
			for i = 1, shownum do
				local obj = newObject(CPGPrefabs[LocalIndex])
				obj.transform:SetParent(cpgParent[LocalIndex])
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i + hidenum)
				if (LocalIndex == 2) then
					obj.transform:SetAsFirstSibling();
				end
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, LocalIndex);
				table.insert(tempList, obj)
			end
			table.insert(PengGangList[LocalIndex], tempList)
			-- 补杠
		else
			local obj = newObject(CPGPrefabs[LocalIndex])
			obj.transform:SetParent(cpgParent[LocalIndex])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = this.CPGPosition(LocalIndex, index, 4)
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(cardPoint, LocalIndex)
			table.insert(PengGangList[LocalIndex][index], obj)
		end
	end
end

function GamePanel.RemoveHandCard(Index, cardPoint, count)
	local list = this.handerCardList[Index]
	local pos = Vector3.zero
	if Index == 1 then
		for i = #list, 1, -1 do
			local objCtrl = list[i];
			if (objCtrl.cardPoint == cardPoint) then
				table.remove(list, i)
				pos = objCtrl.transform.localPosition
				destroy(objCtrl.gameObject);
				count = count - 1;
				if (count == 0) then
					break
				end
			end
		end
	else
		for i = 1, count do
			pos = list[1].transform.localPosition
			destroy(table.remove(list, 1));
		end
	end
	return pos
end
-- 消除打到桌上的牌
function GamePanel.RemoveLastCardOnTable()
	destroy(table.remove(tableCardList[LastAvarIndex]));
	Pointer:SetActive(false)
end
-- 补花动画
function GamePanel.BuHua(response)
	this.PengGangHuEffectCtrl("buhua");
	local cardVo = json.decode(response.message);
	SoundCtrl.getInstance().playSoundByAction("buhua", this.avatarList[cardVo.avatarIndex].account.sex);
	local LocalIndex = this.GetLocalIndex(cardVo.avatarIndex);
	for i = 1, #cardVo.huaPaiList do
		this.CardsNumChange();
		this.BuhuaRemoveCard(cardVo.huaPaiList[i], LocalIndex);
		this.BuhuaPutCard(cardVo.huaPaiList[i], LocalIndex);
		if (LocalIndex == 0) then
			this.BuhuaAddCard(cardVo.cardList[i], LocalIndex);
		else
			this.CreateMoPaiGameObject(LocalIndex);
		end
	end
	this.UpateTimeReStart();
	this.SetDirGameObjectAction(LocalIndex);
end

-- 去除手上花牌

function GamePanel.BuhuaRemoveCard(cardPoint, LocalIndex)
	if (LocalIndex == 0) then
		for i = 1, #this.handerCardList[1] do
			local temp = this.handerCardList[1][i];
			local cardPoint = temp.cardPoint;
			if (cardPoint == cardPoint) then
				table.remove(this.handerCardList[1], i)
				destroy(temp.gameObject);
				temp = nil
				break;
			end
		end
		-- this.PushOutFromMineList(cardPoint);
		this.SetPosition(1);
	else
		local temp = this.handerCardList[LocalIndex][1];
		table.remove(this.handerCardList[LocalIndex], 1)
		destroy(temp);
	end
end
-- 桌上显示花牌
function GamePanel.BuhuaPutCard(cardPoint, LocalIndex)

end

-- 补牌
function GamePanel.BuhuaAddCard(LocalIndex, cardPoint)
	-- SelfAndOtherPutoutCard = cardPoint;
	-- this.PutCardIntoMineList(cardPoint);
	local go = newObject(BottomPrefabs[1])
	go.name = cardPoint;
	go.transform:SetParent(parentList[1]);
	go.transform.localScale = Vector3.New(1.1, 1.1, 1);
	go.transform.localPosition = Vector3.New(580, -292);
	local objCtrl = BottomScript.New(go)
	objCtrl.OnSendMessage = this.CardChange;
	objCtrl.ReSetPoisiton = this.CardSelect;
	objCtrl:Init(cardPoint);
	table.insert(this.handerCardList[1], objCtrl)
end


function GamePanel.PengGangHuEffectCtrl(effectType)
	local effobj = pengEffectGame
	if (effectType == "peng") then
		effobj = pengEffectGame
	elseif (effectType == "gang") then
		effobj = gangEffectGame
	elseif (effectType == "hu") then
		effobj = huEffectGame
	elseif (effectType == "liuju") then
		effobj = liujuEffectGame
	elseif (effectType == "chi") then
		effobj = chiEffectGame
	elseif (effectType == "bu") then
		effobj = effBu
	end
	effobj:SetActive(true)
	coroutine.start(
	function()
		coroutine.wait(1)
		effobj:SetActive(false)
	end
	)
end


-- function GamePanel.AddListToPengGangList(LocalIndex, tempList)
-- log("GamePanel.AddListToPengGangList")
-- local switch =
-- {
-- 	[1] = function()
-- 		table.insert(PengGangList_B, tempList)
-- 	end,
-- 	[2] = function()
-- 		table.insert(PengGangList_R, tempList)
-- 	end,
-- 	[3] = function()
-- 		table.insert(PengGangList_T, tempList)
-- 	end,
-- 	[4] = function()
-- 		table.insert(PengGangList_L, tempList)
-- 	end
-- }
-- switch[LocalIndex]()
-- end



function GamePanel.GetPaiInpeng(cardPoint, LocalIndex)
	local jugeList = PengGangList[LocalIndex]
	if (jugeList == nil or #jugeList == 0) then
		return -1;
	end
	-- 循环遍历比对点数
	for i = 1, #jugeList do
		if (jugeList[i].cardPoint == cardPoint) then
			return i
		end
	end
	return -1;
end
-- 设置顶针
function GamePanel.SetPointGameObject(parent)
	if (parent ~= nil) then
		Pointer.transform:SetParent(parent.transform);
		Pointer.transform.localScale = Vector3.one;
		Pointer.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		Pointer.transform:SetParent(transform);
		Pointer:SetActive(true)
	end
end


function GamePanel.OnChipSelect(objCtrl, isSelected)
	-- if (isSelect) then
	-- 	-- 选择此牌
	-- 	if (oneChiCardPoint ~= -1 and twoChiCardPoint ~= -1) then
	-- 		return
	-- 	end
	-- 	if (oneChiCardPoint == -1) then
	-- 		oneChiCardPoint = objCtrl.cardPoint;
	-- 	else
	-- 		twoChiCardPoint = objCtrl.cardPoint;
	-- 	end
	-- 	obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -272);
	-- 	objCtrl.selected = true;
	-- else
	-- 	-- 取消选择
	-- 	if (oneChiCardPoint == objCtrl.cardPoint) then
	-- 		oneChiCardPoint = -1;
	-- 	elseif (twoChiCardPoint == objCtrl.cardPoint) then
	-- 		twoChiCardPoint = -1;
	-- 	end
	-- 	obj.transform.localPosition = Vector3.New(obj.transform.localPosition.x, -292);
	-- 	objCtrl.selected = false;
	-- end
end



function GamePanel.InsertCardIntoList(objCtrl)
	-- 插入牌的方法
	if (objCtrl ~= nil) then
		local curCardPoint = objCtrl.cardPoint;
		-- 得到当前牌指针
		if (curCardPoint == RoomData.guiPai) then
			table.insert(this.handerCardList[1], 1, objCtrl)
			-- 鬼牌放到最前面
			return;
		else
			for i = 1, #this.handerCardList[1] do
				local cardPoint = this.handerCardList[1][i].cardPoint;
				if (cardPoint ~= RoomData.guiPai and cardPoint >= curCardPoint) then
					table.insert(this.handerCardList[1], i, objCtrl)
					return;
				end
			end
			table.insert(this.handerCardList[1], objCtrl)
		end
	end
end

-- 设置牌位置
function GamePanel.SetPosition(LocalIndex)
	print("GamePanel.SetPosition")
	local tempList = this.handerCardList[LocalIndex]
	local count = #tempList;
	switch =
	{
		[1] = function(i) return Vector2.New(-606 + i * 80, -292) end,
		[2] = function(i) return Vector2.New(0, -361 + i * 30) end,
		[3] = function(i) return Vector2.New(300 - 37 * i, 0) end,
		[4] = function(i) return Vector2.New(0, 315 - i * 30) end,
	}
	for i = 1, count do
		tempList[i].gameObject.transform.localPosition = switch[LocalIndex](i)
	end
	if (count % 3 == 2) then
		tempList[count].gameObject.transform.localPosition = switch[LocalIndex](count + 1)
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
	if (BroadcastScript.noticeMegs ~= nil and #BroadcastScript.noticeMegs ~= 0) then
		noticeText.transform.localPosition = Vector3.New(500, noticeText.transform.localPosition.y);
		noticeText.text = BroadcastScript.noticeMegs[showNoticeNumber];
		local time = noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = noticeText.transform:DOLocalMove(
		Vector3.New(- noticeText.text.Length * 28, noticeText.transform.localPosition.y), time, false)
		.OnComplete(MoveCompleted);
		tweener:SetEase(Ease.Linear);
	end
end

function GamePanel.MoveCompleted()
	showNoticeNumber = showNoticeNumber + 1;
	if (showNoticeNumber == #BroadcastScript.noticeMegs) then
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

-- 胡牌按钮点击
function GamePanel.HubtnClick()
	local cardPoint
	local requestVo = { };
	if (this.putOutCardPoint ~= -1) then
		requestVo.type = "qianghu";
		cardPoint = this.putOutCardPoint;
	else
		cardPoint = this.handerCardList[1][#this.handerCardList[1]].cardPoint
	end
	requestVo.cardPoint = cardPoint;
	local sendMsg = json.encode(requestVo);
	networkMgr:SendMessage(ClientRequest.New(APIS.HUPAI_REQUEST, sendMsg));
	this.CleanBtnShow();
	this.CompleteBtnAction()
end
-- 点击放弃按钮
function GamePanel.PassBtnClick()
	networkMgr:SendMessage(ClientRequest.New(APIS.GAVEUP_REQUEST, "gaveup|" .. this.passStr));
	this.CleanBtnShow();
	this.CompleteBtnAction()
end

function GamePanel.PengBtnClick()
	local cardvo = { };
	cardvo.cardPoint = this.putOutCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.PENGPAI_REQUEST, json.encode(cardvo)));
	this.CleanBtnShow();
	this.CompleteBtnAction()
end


function GamePanel.ShowChipai(idx)
	local cpoint = this.chiPaiPointList[idx];
	if (idx == 1) then
		chiList_1[1]:Init(cpoint.putCardPoint)
		chiList_1[2]:Init(cpoint.oneCardPoint)
		chiList_1[3]:Init(cpoint.twoCardPoint)
	end
	if (idx == 2) then
		chiList_2[1]:Init(cpoint.putCardPoint)
		chiList_2[2]:Init(cpoint.oneCardPoint)
		chiList_2[3]:Init(cpoint.twoCardPoint)
	end
	if (idx == 3) then
		chiList_3[1]:Init(cpoint.putCardPoint)
		chiList_3[2]:Init(cpoint.oneCardPoint)
		chiList_3[3]:Init(cpoint.twoCardPoint)
	end
end

-- 显示可吃牌的显示
function GamePanel.ShowChiList()
	this.CleanBtnShow();
	for i = 1, #canChiList do
		if (i <= #this.chiPaiPointList) then
			canChiList[i].gameObject:SetActive(true);
			this.ShowChipai(i);
		else
			canChiList[i].gameObject:SetActive(false);
		end
	end
end

-- 吃牌选择点击
function GamePanel.ChiBtnClick2(idx, go)
	local cpoint = this.chiPaiPointList[idx];
	local cardvo = { }
	cardvo.cardPoint = cpoint.putCardPoint;
	cardvo.onePoint = cpoint.oneCardPoint;
	cardvo.twoPoint = cpoint.twoCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
	for i = 1, #canChiList do
		canChiList[i].gameObject:SetActive(false);
	end
	this.CompleteBtnAction()
end

-- 吃按钮点击
function GamePanel.ChiBtnClick()
	if (#this.chiPaiPointList == 1) then
		local cpoint = this.chiPaiPointList[1];
		local cardvo = { };
		this.UpateTimeReStart();
		cardvo.cardPoint = cpoint.putCardPoint;
		cardvo.onePoint = cpoint.oneCardPoint;
		cardvo.twoPoint = cpoint.twoCardPoint;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
		this.CleanBtnShow();
		this.CompleteBtnAction()
	else
		this.ShowChiList();
	end
end

function GamePanel.GangBtnClick()
	local GangRequestVO = { }
	GangRequestVO.cardPoint = tonumber(this.gangPaiList[1])
	GangRequestVO.gangType = 0;
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	soundMgr:playSoundByAction("gang", LoginData.account.sex);
	this.PengGangHuEffectCtrl("gang");
	this.CleanBtnShow();
	this.CompleteBtnAction()
end
function GamePanel.BuBtnClick()
	local GangRequestVO = { }
	GangRequestVO.cardPoint = tonumber(this.gangPaiList[1])
	GangRequestVO.gangType = 0;
	GangRequestVO.kaigang = false
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	-- soundMgr:playSoundByAction("bu", LoginData.account.sex);
	-- this.PengGangHuEffectCtrl("bu");
	this.CleanBtnShow();
	this.CompleteBtnAction()
end
-- 每局结束销毁牌
function GamePanel.Clean()
	this.CleanList(this.handerCardList)
	this.CleanList(tableCardList)
	this.CleanList(PengGangList)
	guiObj:SetActive(false);
	Pointer:SetActive(false)
	this.imgDuanMen.enabled = false
	this.CleanBtnShow()
	this.CompleteBtnAction()
end

-- function GamePanel.CleanList(list)
-- if (type(list) == "table") then
-- 	for i = #list, 1, -1 do
-- 		local temp = list[i]
-- 		if type(temp) == "table" then
-- 			if not IsNil(temp.gameObject) then
-- 				destroy(temp.gameObject)
-- 				table.remove(list, i)
-- 			else
-- 				this.CleanList(temp)
-- 			end
-- 		else
-- 			if not IsNil(temp.gameObject) then
-- 				destroy(temp.gameObject)
-- 				table.remove(list, i)
-- 			end
-- 		end
-- 	end
-- end
-- end

-- 摧毁gameobject
function GamePanel.CleanList(list)
	for k, v in pairs(list) do
		if type(v) == "table" then
			this.CleanList(v)
		elseif type(v) == "userdata" then
			if not IsNil(v.gameObject) then
				destroy(v.gameObject)
				list[k] = nil
			end
		end
	end
end

function GamePanel.SetRoomRemark()
	local roomvo = RoomData;
	local str = "房间号：\n" .. roomvo.roomId .. "\n"
	.. "圈数:" .. roomvo.roundNumber .. "\n\n"
	roomRemark.text = str;
end

function GamePanel.AddAvatarVOToList(avatar)
	table.insert(this.avatarList, avatar)
	this.SetSeat(avatar);
end
-- 创建房间
function GamePanel.CreateRoomAddAvatarVO(avatar)
	this.avatarList = { }
	this.AddAvatarVOToList(avatar);
	this.SetRoomRemark();
	this.ReadyGame();
end

-- 加入房间
function GamePanel.JoinToRoom(avatars)
	this.avatarList = avatars;
	for i = 1, #avatars do
		this.SetSeat(avatars[i])
	end
	this.SetRoomRemark();
	if (RoomData.jiaGang) then
		this.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
		this.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
		this.btnReadyGame:SetActive(true);
		this.ReadySelect[1].interactable = false;
	else
		this.ReadyGame();
	end
end

-- 设置当前角色的座位
function GamePanel.SetSeat(avatar)
	-- 游戏结束后用的数据，勿删！！！
	if (avatar.account.uuid == LoginData.account.uuid) then
		this.playerItems[1]:SetAvatarVo(avatar);
	else
		local myIndex = this.GetMyIndexFromList();
		local curAvaIndex = this.GetIndex(avatar.account.uuid)
		local seatIndex = 1 + curAvaIndex - myIndex;
		if (seatIndex < 1) then
			seatIndex = 4 + seatIndex;
		end
		this.playerItems[seatIndex]:SetAvatarVo(avatar);
	end
end
-- 获取自己在this.avatarList中的下标，等于服务器下标+1
function GamePanel.GetMyIndexFromList()
	if (this.avatarList ~= nil) then
		for i = 1, #this.avatarList do
			if (this.avatarList[i].account.uuid == LoginData.account.uuid or this.avatarList[i].account.openid == LoginData.account.openid) then
				LoginData.account.uuid = this.avatarList[i].account.uuid;
				return i
			end
		end
	end
	return 1;
end
-- 获取玩家在this.avatarList中的下标，等于服务器下标+1
function GamePanel.GetIndex(uuid)
	if (this.avatarList ~= nil) then
		for i = 1, #this.avatarList do
			if (this.avatarList[i].account ~= nil) then
				if (this.avatarList[i].account.uuid == uuid) then
					return i;
				end
			end
		end
		return 1;
	end
end
-- 服务器下标转本地下标
function GamePanel.GetLocalIndex(serverIndex)
	local Index = this.GetMyIndexFromList();
	return(serverIndex - Index + 5) % 4 + 1;
end
-- 获取庄家在this.avatarList中的下标，等于服务器下标+1
function GamePanel.GetBanker()
	if (this.avatarList ~= nil) then
		for i = 1, #this.avatarList do
			if (this.avatarList[i].main) then
				return i
			end
		end
		return 1
	end
end

function GamePanel.GetAccount(uuid)
	if (this.avatarList ~= nil) then
		for i = 1, #this.avatarList do
			if (this.avatarList[i].account ~= nil) then
				if (this.avatarList[i].account.uuid == uuid) then
					return this.avatarList[i].account
				end
			end
		end
		return nil
	end
end

function GamePanel.OtherUserJointRoom(buffer)
	log("GamePanel.OtherUserJointRoom")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local avatar = json.decode(message);
	avatar = AvatarVO.New(avatar)
	this.AddAvatarVOToList(avatar);
end



function GamePanel.HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	this.HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		this.PengGangHuEffectCtrl("hu");
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = this.GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].cardPoint > -1) then
				if (RoundOverData.avatarList[i].uuid ~= RoundOverData.avatarList[i].dianPaoId) then
					soundMgr:playSoundByAction("hu", this.avatarList[i].account.sex);
				else
					soundMgr:playSoundByAction("zimo", this.avatarList[i].account.sex);
				end
				this.playerItems[LocalIndex].HuFlag.enabled = true
			else
				this.playerItems[LocalIndex].HuFlag.enabled = false
			end
		end
		local allMas = RoundOverData.allMas;
		coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3, allMas)
	elseif (RoundOverData.type == "1") then
		soundMgr:playSoundByAction("liuju", LoginData.account.sex);
		this.PengGangHuEffectCtrl("liuju");
		coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3)
	else
		coroutine.start(this.Invoke, this.OpenGameOverPanelSignal, 3)
	end
end

function GamePanel.Invoke(f, time, ...)
	coroutine.wait(time)
	f(...)
end

function GamePanel.HupaiCoinChange(scores)
	local scoreList = string.split(scores, ',')
	if (scoreList ~= nil and #scoreList > 0) then
		for i = 1, #scoreList - 1 do
			local itemstr = scoreList[i];
			local uuid = tonumber(string.split(itemstr, ':')[1]);
			local score = tonumber(string.split(itemstr, ':')[2]);
			local LocalIndex = this.GetLocalIndex(this.GetIndex(uuid) -1)
			this.playerItems[LocalIndex].scoreText.text = tostring(score);
			this.avatarList[this.GetIndex(uuid)].scores = score;
		end
	end
end


-- 单局结束重置数据的地方
function GamePanel.OpenGameOverPanelSignal(allMas)
	local isNextBanker = RoundOverData.nextBankerId == LoginData.account.uuid
	ClosePanel(ZhuaMaPanel)
	OpenPanel(GameOverPanel, isNextBanker)
	this.Clean();
	this.HidePlayerItemImg();
	for i = 1, #this.avatarList do
		this.avatarList[i]:ResetData()
	end
	this.InitArrayList()
	allMas = "";
end


-- 退出房间确认面板
function GamePanel.QuiteRoom()
	soundMgr:playSoundByActionButton(1);
	if (1 == this.GetMyIndexFromList()) then
		OpenPanel(ExitPanel, "提示", "亲，确定要解散房间吗?", this.Tuichu);
	else
		OpenPanel(ExitPanel, "提示", "亲，确定要离开房间吗?", this.Tuichu);
	end

end
-- 退出房间按钮点击
function GamePanel.Tuichu()
	ClosePanel(ExitPanel)
	soundMgr:playSoundByActionButton(1);
	local vo = { };
	vo.roomId = RoomData.roomId;
	local sendMsg = json.encode(vo)
	networkMgr:SendMessage(ClientRequest.New(APIS.OUT_ROOM_REQUEST, sendMsg));
end


function GamePanel.OutRoomCallbak(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local responseMsg = json.decode(message)
	if (responseMsg.status_code == "0") then
		if (responseMsg.type == "0") then
			local uuid = responseMsg.uuid;
			if (uuid ~= LoginData.account.uuid) then
				local index = this.GetIndex(uuid);
				table.remove(this.avatarList, index)
				for i = 1, #this.playerItems do
					this.playerItems[i]:SetAvatarVo(nil);
				end
				if (this.avatarList ~= nil) then
					for i = 1, #this.avatarList do
						this.SetSeat(this.avatarList[i]);
					end
				end
			else
				this:ChangePanel(HomePanel)
			end
		else
			this:ChangePanel(HomePanel)
		end
	else
		TipsManager.SetTips("退出房间失败：" .. tostring(responseMsg.error));
	end
end

-- 游戏设置
function GamePanel.OpenSettingPanel()
	soundMgr:playSoundByActionButton(1);
	local _type = 4
	if (RoomData.enterType == 4) then
		_type = 2;
	elseif (1 == GamePanel.GetMyIndexFromList()) then
		_type = 3;
	end
	OpenPanel(SettingPanel, _type)
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

function GamePanel.DoDissoliveRoomRequest(_type)
	local data = { };
	data.roomId = RoomData.roomId;
	data.type = _type;
	local sendMsg = json.encode(data);
	networkMgr:SendMessage(ClientRequest.New(APIS.DISSOLIVE_ROOM_REQUEST, sendMsg));
	VoteStatus = true
end

-- 申请解散房间回调
function GamePanel.DissoliveRoomResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message);
	local plyerName = data.accountName;
	local uuid = data.uuid;
	-- 发起申请
	if (data.type == "0") then
		VoteStatus = true;
		disagreeCount = 0
		OpenPanel(VotePanel, uuid, plyerName, this.avatarList)
		-- 有人同意
	elseif (data.type == "1") then
		VotePanel.DissoliveRoomResponse(1, plyerName)
		-- 有人拒绝
	elseif (data.type == "2") then
		VotePanel.DissoliveRoomResponse(2, plyerName)
		disagreeCount = disagreeCount + 1;
		if (disagreeCount >= 2) then
			VoteStatus = false;
			TipsManager.SetTips("同意解散房间申请人数不够，本轮投票结束，继续游戏");
			ClosePanel(VotePanel)
		end
		-- 解散
	elseif (data.type == "3") then
		VoteStatus = false;
		ClosePanel(VotePanel)
		RoomData.isOverByPlayer = true;
	end
end

function GamePanel.GameReadyNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message);
	local avatarIndex = data["avatarIndex"];
	local seatIndex = this.GetLocalIndex(avatarIndex)
	this.playerItems[seatIndex].readyImg.enabled = true
	this.avatarList[avatarIndex + 1].isReady = true;
end

-- 隐藏跟庄
function GamePanel.GameFollowBanderNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	genZhuang:SetActive(true);
	coroutine.start(this.Invoke(this.HideGenzhuang, 2))
end

function GamePanel.HideGenzhuang()
	genZhuang:SetActive(false);
end

function GamePanel.ReEnterRoom()
	if (RoomData.enterType == 3) then
		-- 服务器的坑
		if (RoomData.gui <= 0) then
			RoomData.guiPai = -1
		end
		this.SetRoomRemark();
		-- 设置座位
		this.avatarList = RoomData.playerList;
		for i = 1, #this.avatarList do
			this.SetSeat(this.avatarList[i]);
		end
		local selfIndex = this.GetMyIndexFromList()
		LoginData.account.roomcard = this.avatarList[selfIndex].account.roomcard;
		local selfPaiArray = this.avatarList[selfIndex].paiArray;
		if (selfPaiArray == nil or #selfPaiArray == 0) then
			-- 游戏还没有开始
			-- 		if (not this.avatarList[selfIndex].isReady and RoomDataRoomData.currentRound==0) then
			-- 			this.ReadyGame();
			-- 		end
			-- 牌局已开始
		else
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

-- 只加载手牌对象，不排序
function GamePanel.DispalySelfhanderCard()
	local index = this.GetMyIndexFromList()
	local paiArray = this.avatarList[index].paiArray
	for i = 1, #paiArray[1] do
		if (paiArray[1][i] > 0) then
			for j = 1, paiArray[1][i] do
				local go = newObject(BottomPrefabs[1]);
				-- 设置父节点
				go.transform:SetParent(parentList[1]);
				go.transform.localScale = Vector3.New(1.1, 1.1, 1);
				local objCtrl = BottomScript.New(go)
				local point = i - 1
				objCtrl.OnSendMessage = this.CardChange;
				objCtrl.ReSetPoisiton = this.CardSelect;
				objCtrl:Init(point)
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
	this.playerItems[1]:ShowChatAction();
end
-- 桌牌位置
function GamePanel.TableCardPosition(LocalIndex)
	local switch =
	{
		[1] = Vector2.New(-261 + #tableCardList[1] % 14 * 37,math.modf(#tableCardList[1] / 14) * 67),
		[2] = Vector2.New((math.modf(#tableCardList[2] / 13) * -54),- 180 + #tableCardList[2] % 13 * 28),
		[3] = Vector2.New(289 - #tableCardList[3] % 14 * 37,math.modf(#tableCardList[3] / 14) * -67),
		[4] = Vector2.New(math.modf(#tableCardList[4] / 13) * 54,152 - #tableCardList[4] % 13 * 28)
	}
	return switch[LocalIndex]
end
-- 重连显示打牌数据
function GamePanel.DisplayTableCards()
	log("GamePanel.DisplayTableCards")

	for i = 1, #RoomData.playerList do
		local chupai = RoomData.playerList[i].chupais;
		local LocalIndex = this.GetLocalIndex(this.GetIndex(RoomData.playerList[i].account.uuid) -1);
		if (chupai ~= nil and #chupai > 0) then
			for j = 1, #chupai do
				local pos = this.TableCardPosition(LocalIndex)
				this.ThrowBottom(chupai[j], LocalIndex, pos, true);
			end
		end
	end
end

-- 显示桌面鬼牌
function GamePanel.DisplayTouzi(touzi, gui)
	if (gui ~= -1 and RoomData.roomType == 4 and RoomData.gui == 2) then
		-- 显示骰子
		local r1 = touzi / 10;
		local r2 = touzi % 10;
		touziObj.TouziActionScript = TouziActionScript.New()
		local bts = touziObj.TouziActionScript;
		bts:SetResult(r1, r2);
		touziObj:SetActive(true);
		coroutine.start(this.Invoke(this.DisplayGuiPai, 5.5))
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
	local gui = RoomData.guiPai;
	if (gui ~= -1 and(RoomData.hong or RoomData.gui > 0)) then
		-- 显示鬼牌
		-- int mGui = getDisplayGuiPai(gui);//盘锦玩法，显示当前鬼牌的前一张
		local objCtrl = TopAndBottomCardScript.New(guiObj)
		objCtrl:Init(gui, 3);
		guiObj:SetActive(true);
	end
end

-- 重连显示其他人的手牌
function GamePanel.DisplayOtherHandercard()
	log("GamePanel.DisplayOtherHandercard")
	for i = 1, #RoomData.playerList do
		local LocalIndex = this.GetLocalIndex(this.GetIndex(RoomData.playerList[i].account.uuid) -1);
		local count = RoomData.playerList[i].commonCards;
		if (LocalIndex ~= 1) then
			this.InitOtherCardList(LocalIndex, count);
			if RoomData.playerList[i].tingPai then
				this.LockHandCard(LocalIndex)
			end
		end
	end
end

-- 杠牌重连
function GamePanel.DisplayallGangCard()
	log("GamePanel.DisplayallGangCard")
	for i = 1, #RoomData.playerList do
		local paiArrayType = RoomData.playerList[i].paiArray[2];
		local LocalIndex = this.GetLocalIndex(this.GetIndex(RoomData.playerList[i].account.uuid) -1);
		if (table.indexOf(paiArrayType, 2) > -1) then
			local gangString = RoomData.playerList[i].huReturnObjectVO.totalInfo.gang;
			if (gangString ~= nil) then
				local gangtemps = string.split(gangString, ',')
				for j = 1, #gangtemps do
					local item = gangtemps[j];
					local items = string.split(item, ':')
					gangpaiObj = { };
					gangpaiObj.uuid = items[1];
					gangpaiObj.cardPoint = tonumber(items[2]);
					gangpaiObj.type = items[3];
					RoomData.playerList[i].paiArray[1][gangpaiObj.cardPoint + 1] = RoomData.playerList[i].paiArray[1][gangpaiObj.cardPoint + 1] -4;
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
	for i = 1, #RoomData.playerList do
		local paiArrayType = RoomData.playerList[i].paiArray[2];
		-- 第二个数组存储了碰的牌
		local LocalIndex = this.GetLocalIndex(this.GetIndex(RoomData.playerList[i].account.uuid) -1);
		if (table.indexOf(paiArrayType, 1) > -1) then
			-- 1代表碰的那张牌
			for j = 1, #paiArrayType do
				if (paiArrayType[j] == 1 and RoomData.playerList[i].paiArray[1][j] > 0) then
					-- 服务器没去掉已经吃碰杠的牌，所以处理一下（主要是要去掉自己的）
					RoomData.playerList[i].paiArray[1][j] = RoomData.playerList[i].paiArray[1][j] -3;
					this.DoDisplayPengCard(LocalIndex, j - 1);
				end
			end
		end
	end
end


-- 吃牌重连
function GamePanel.DisplayChiCard()
	log("GamePanel.DisplayChiCard")
	for i = 1, #RoomData.playerList do
		local LocalIndex = this.GetLocalIndex(this.GetIndex(RoomData.playerList[i].account.uuid) -1);
		local chiPaiArray = RoomData.playerList[i].chiPaiArray;
		if #chiPaiArray > 0 then
			for j = 1, #chiPaiArray do
				for k = 1, #chiPaiArray[j] do
					-- 在paiArray里的下标比牌值大1
					local index = chiPaiArray[j][k] + 1
					if (chiPaiArray[j][k] > 0 and RoomData.playerList[i].paiArray[1][index] > 0) then
						RoomData.playerList[i].paiArray[1][index] = RoomData.playerList[i].paiArray[1][index] -1;
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
	for i = 1, 4 do
		local obj = newObject(CPGPrefabs[LocalIndex])
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex);
		if (LocalIndex == 2 and i < 4) then
			obj.transform:SetAsFirstSibling()
		end
		table.insert(TempList, obj)
	end
	table.insert(PengGangList[LocalIndex], TempList)
end


-- 显示暗杠牌
-- show:是否显示暗杠牌值
function GamePanel.DoDisplayAnGangCard(LocalIndex, point, show)
	log("GamePanel.DoDisplayAnGangCard")
	local TempList = { };
	for i = 1, 4 do
		local obj = nil
		if (i == 4 and show) then
			obj = newObject(CPGPrefabs[LocalIndex])
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(point, LocalIndex);
		else
			obj = newObject(BackPrefabs[LocalIndex])
		end
		table.insert(TempList, obj)
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2 and i < 4) then
			obj.transform:SetAsFirstSibling()
		end
	end
	table.insert(PengGangList[LocalIndex], TempList)
end

-- 重连显示碰牌
function GamePanel.DoDisplayPengCard(LocalIndex, point)
	log("GamePanel.DoDisplayPengCard")
	local TempList = { };
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(CPGPrefabs[LocalIndex])
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex);
		table.insert(TempList, objCtrl)
	end
	table.insert(PengGangList[LocalIndex], TempList)
end
-- 重连显示吃牌
-- chipai一组吃牌的牌值
function GamePanel.DoDisplayChiCard(LocalIndex, chipai)
	log("GamePanel.DoDisplayChiCard")
	local TempList = { };
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(CPGPrefabs[LocalIndex])
		obj.transform:SetParent(cpgParent[LocalIndex])
		obj.transform.localPosition = this.CPGPosition(LocalIndex, #PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(chipai[i], LocalIndex);
		table.insert(TempList, obj)
	end
	table.insert(PengGangList[LocalIndex], TempList)
end

function GamePanel.InviteFriend()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(SharePanel)
end

-- 用户离线回调
function GamePanel.OfflineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = this.GetIndex(uuid) -1;
	local LocalIndex = this.GetLocalIndex(index);
	this.playerItems[LocalIndex].offlineImage.enabled = true
	-- 申请解散房间过程中，有人掉线，直接不能解散房间
	if (VoteStatus) then
		ClosePanel(VotePanel)
		TipsManager.SetTips("由于" .. this.avatarList[index].account.nickname .. "离线，系统不能解散房间")
	end
end

-- 用户上线提醒
function GamePanel.OnlineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = this.GetIndex(uuid) -1;
	local LocalIndex = this.GetLocalIndex(index);
	this.playerItems[LocalIndex].offlineImage.enabled = false
end

function GamePanel.MessageBoxNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local arr = string.split(message, '|')
	local uuid = tonumber(arr[2]);
	local LocalIndex = this.GetLocalIndex(this.GetIndex(uuid) -1);
	local index = tonumber(arr[1])
	this.ShowChatMessage(LocalIndex, index)
end
function GamePanel.ShowChatMessage(LocalIndex, index)
	this.playerItems[LocalIndex]:ShowChatMessage(index);
end

-- 发准备消息
function GamePanel.ReadyGame()
	-- print(debug.traceback("ReadyGame"))
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end

function GamePanel.MicInputNotice(buffer)
	local sendUUid = buffer:ReadInt()
	local data = buffer:ReadBytes()
	MicPhone.MicInputNotice(data)
	for i = 1, #this.playerItems do
		if (sendUUid == this.playerItems[i].uuid) then
			this.playerItems[i]:ShowChatAction();
		end
	end
end
-- 完成一次按钮操作
function GamePanel.CompleteBtnAction()
	this.putOutCardPoint = -1
	this.gangPaiList = { }
	this.kaigangPaiList = { };
	this.chiPaiPointList = { }
	this.passStr = ""
end

function GamePanel.CleanBtnShow()
	this.huBtn:SetActive(false);
	this.gangBtn:SetActive(false);
	this.pengBtn:SetActive(false);
	this.chiBtn:SetActive(false);
	this.passBtn:SetActive(false);
	this.btnBu:SetActive(false)
end

function GamePanel.ShowBtn(btntype, value)
	if (btntype == 1) then
		this.huBtn:SetActive(value)
	end
	if (btntype == 2) then
		this.gangBtn:SetActive(value)
	end
	if (btntype == 3) then
		this.pengBtn:SetActive(value)
	end
	if (btntype == 4) then
		this.chiBtn:SetActive(value)
	end
	if (btntype == 5) then
		this.passBtn:SetActive(value)
	end
	if (btntype == 6) then
		this.btnBu:SetActive(value)
	end
end

-- 最后一次操作（这代码也写得很反人类）
-- 应该这样修改
-- 1)确定当前是等待出牌还是等待操作
-- 2)等谁出牌,或者谁刚出完牌
function GamePanel.ReturnGameResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local returnstr = message;
	local returnJsonData = json.decode(message);
	-- 1.显示剩余牌的张数和圈数
	local surplusCards = returnJsonData.surplusCards;
	local gameRound = returnJsonData.gameRound;
	this.LeavedCastNumText.text = tostring(surplusCards);
	this.LeavedCardsNum = surplusCards;
	this.LeavedRoundNumText.text = tostring(gameRound);
	RoomData.surplusTimes = gameRound;

	local curAvatarIndex = returnJsonData.curAvatarIndex;
	local pickAvatarIndex = returnJsonData.pickAvatarIndex or 0;
	-- 胡牌后重连没这个值
	local currentCardPoint = returnJsonData.currentCardPoint
	-- 是否已出牌，等待操作
	local waitAction = true
	for i = 1, #this.handerCardList do
		if #this.handerCardList[i] % 3 == 2 then
			waitAction = false
			break
		end
	end
	-- 出牌后等待操作
	if (waitAction) then
		local LocalIndex = this.GetLocalIndex(curAvatarIndex);
		this.SetDirGameObjectAction(LocalIndex);
		this.SortMyCardList()
		-- 等待出牌
	else
		local LocalIndex = this.GetLocalIndex(pickAvatarIndex);
		this.SetDirGameObjectAction(LocalIndex);
		-- 自己摸牌
		if (currentCardPoint ~= nil) then
			local cardPoint
			if (currentCardPoint == -2) then
				local count = #this.handerCardList[1]
				cardPoint = this.handerCardList[1][count].cardPoint;
			else
				cardPoint = currentCardPoint
			end
			this.SortMyCardList()
			-- 最后摸的一张牌
			for i = 1, #this.handerCardList[1] do
				if this.handerCardList[1][i].cardPoint == cardPoint then
					local temp = this.handerCardList[1][i]
					table.remove(this.handerCardList[1], i)
					table.insert(this.handerCardList[1], temp)
					break
				end
			end
		end
	end
	this.SetPosition(1)
	local index = this.GetMyIndexFromList()
	if this.avatarList[index].tingPai then
		this.LockHandCard(1)
	end
	LastAvarIndex = this.GetLocalIndex(curAvatarIndex)
	if (tableCardList[LastAvarIndex] ~= nil and #tableCardList[LastAvarIndex] ~= 0) then
		local obj = tableCardList[LastAvarIndex][#tableCardList[LastAvarIndex]];
		this.SetPointGameObject(obj);
	end
	-- local LocalIndex = this.GetLocalIndex(pickAvatarIndex)
	-- if (LocalIndex == this.GetMyIndexFromList()) then
	-- 	local count = #this.handerCardList[1]
	-- 	-- 吃碰杠之后
	-- 	if (currentCardPoint == -2) then
	-- 		local cardPoint = this.handerCardList[1][count].cardPoint;
	-- 		-- SelfAndOtherPutoutCard = cardPoint;
	-- 		this.SortMyCardList()
	-- 		-- 摸牌之后
	-- 	elseif (count % 3 == 2) then
	-- 		local cardPoint = returnJsonData.currentCardPoint;
	-- 		-- SelfAndOtherPutoutCard = cardPoint;
	-- 		this.SortMyCardList(cardPoint)
	-- 	end
	-- 	this.SetDirGameObjectAction(1);
	-- else
	-- 	this.SortMyCardList()
	-- 	-- 别人摸牌
	-- 	this.SetDirGameObjectAction(LocalIndex);
	-- 	local count = #this.handerCardList[LocalIndex]
	-- 	if (count % 3 ~= 2) then
	-- 		local go = this.CreateMoPaiGameObject(LocalIndex)
	-- 		table.insert(this.handerCardList[LocalIndex], go)
	-- 	end
	-- end
	-- this.SetPosition(1)
	-- if (tableCardList[LastAvarIndex] == nil or #tableCardList[LastAvarIndex] == 0) then
	-- 	-- 刚启动
	-- else
	-- 	local obj = tableCardList[LastAvarIndex][#tableCardList[LastAvarIndex]];
	-- 	cardOnTable = obj;
	-- 	this.SetPointGameObject(cardOnTable);
	-- end
end





-- 解散房间按钮
function GamePanel.InitbtnJieSan()
	if (1 == this.GetMyIndexFromList()) then
		-- 我是房主（一开始庄家是房主）
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/jiesan.png' }, function(sprite)
			btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	else
		resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/leaveRoom.png" }, function(sprite)
			btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	end

end

function GamePanel.HUPAIALL_RESPONSE(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoomOverData = json.decode(message);
end


-- 测试方法，用来打印table
function GamePanel.Test()
	return {
		this.avatarList,
		this.handerCardList,
		PengGangList,
		tableCardList,
	}
end
------------------------------------------------------------
function GamePanel.OnOpen()
	log(Test.DumpTab(RoomData))
	BottomPrefabs = { UIManager.Bottom_B, UIManager.Bottom_R, UIManager.Bottom_T, UIManager.Bottom_L }
	ThrowPrefabs = { UIManager.TopAndBottomCard, UIManager.ThrowCard_R, UIManager.TopAndBottomCard, UIManager.ThrowCard_L }
	CPGPrefabs = { UIManager.PengGangCard_B, UIManager.PengGangCard_R, UIManager.PengGangCard_T, UIManager.PengGangCard_L }
	BackPrefabs = { UIManager.GangBack, UIManager.GangBack_LR, UIManager.GangBack_T, UIManager.GangBack_LR }
	Pointer = UIManager.Pointer
	this.InitArrayList()
	CurrentGame = this.GetGame()
	log(CurrentGame)
	CurrentGame.Start()
	this.RandShowTime();
	this.imgDuanMen.enabled = false
	timeFlag = true;
	soundMgr:playBGM(2);
	versionText.text = "V" .. Application.version;
	lbRoomNum.text = "房间号：" .. RoomData.roomId;
	if (RoomData.enterType == 3) then
		-- 短线重连进入房间
		CurrentGame.ReEnterRoom();
	elseif (RoomData.enterType == 2) then
		-- 进入他人房间
		CurrentGame.JoinToRoom(RoomData.playerList);
	else
		-- 创建房间
		CurrentGame.CreateRoomAddAvatarVO(LoginData);
	end
	this.InitbtnJieSan();
	MicPhone.OnOpen(this.avatarList)
end

function GamePanel.GetGame()
	local switch = {
		[1] = ZhuanzhuanGame,
		[2] = PanjinGame,
		[3] = ChangshaGame,
		[4] = GuangdongGame,
		[5] = PanjinGame,
		[6] = WuxiGame,
		[7] = ShuangliaoGame,
		[8] = JiujiangGame,
		[9] = TuidaohuGame,
	}
	return switch[RoomData.roomType]
end

function GamePanel.OnClose()
	CurrentGame.End()
	LoginData:ResetData();
	RoomData = { }
	RoundOverData = { }
	RoomOverData = { }
	for i = 1, #this.playerItems do
		this.playerItems[i]:Clean()
	end
	for i = 1, #this.ReadySelect do
		this.ReadySelect[i].gameObject:SetActive(false)
		this.ReadySelect[i].interactable = true
	end
	this.btnReadyGame:SetActive(false);
	this.Clean();
end
-- 移除事件--
-- function GamePanel.RemoveListener()
-- UpdateBeat:Remove(this.Update);
-- FixedUpdateBeat:Remove(MicPhone.FixedUpdate);
-- Event.RemoveListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
-- Event.RemoveListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
-- Event.RemoveListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
-- Event.RemoveListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
-- Event.RemoveListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
-- Event.RemoveListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
-- Event.RemoveListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
-- Event.RemoveListener(tostring(APIS.GANGPAI_RESPONSE), this.GangCard)
-- Event.RemoveListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.GangCard)
-- Event.RemoveListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
-- Event.RemoveListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
-- Event.RemoveListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
-- Event.RemoveListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
-- Event.RemoveListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
-- Event.RemoveListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
-- Event.RemoveListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
-- Event.RemoveListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
-- Event.RemoveListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
-- Event.RemoveListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
-- Event.RemoveListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
-- Event.RemoveListener(tostring(APIS.HUPAIALL_RESPONSE), this.HUPAIALL_RESPONSE)
-- end


-- 增加事件--
-- function GamePanel.AddListener()
-- UpdateBeat:Add(this.Update);
-- FixedUpdateBeat:Add(MicPhone.FixedUpdate);
-- Event.AddListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE), this.StartGame)
-- Event.AddListener(tostring(APIS.PICKCARD_RESPONSE), this.PickCard)
-- Event.AddListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), this.OtherPickCard)
-- Event.AddListener(tostring(APIS.CHUPAI_RESPONSE), this.OtherPutOutCard)
-- Event.AddListener(tostring(APIS.JOIN_ROOM_NOICE), this.OtherUserJointRoom)
-- Event.AddListener(tostring(APIS.PENGPAI_RESPONSE), this.PengCard)
-- Event.AddListener(tostring(APIS.CHIPAI_RESPONSE), this.ChiCard)
-- Event.AddListener(tostring(APIS.GANGPAI_RESPONSE), this.GangCard)
-- Event.AddListener(tostring(APIS.OTHER_GANGPAI_NOICE), this.GangCard)
-- Event.AddListener(tostring(APIS.RETURN_INFO_RESPONSE), this.ActionBtnShow)
-- Event.AddListener(tostring(APIS.HUPAI_RESPONSE), this.HupaiCallBack)
-- Event.AddListener(tostring(APIS.OUT_ROOM_RESPONSE), this.OutRoomCallbak)
-- Event.AddListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
-- Event.AddListener(tostring(APIS.PrepareGame_MSG_RESPONSE), this.GameReadyNotice)
-- Event.AddListener(tostring(APIS.OFFLINE_NOTICE), this.OfflineNotice)
-- Event.AddListener(tostring(APIS.MessageBox_Notice), this.MessageBoxNotice)
-- Event.AddListener(tostring(APIS.RETURN_ONLINE_RESPONSE), this.ReturnGameResponse)
-- Event.AddListener(tostring(APIS.ONLINE_NOTICE), this.OnlineNotice)
-- Event.AddListener(tostring(APIS.MicInput_Response), this.MicInputNotice)
-- Event.AddListener(tostring(APIS.Game_FollowBander_Notice), this.GameFollowBanderNotice)
-- Event.AddListener(tostring(APIS.HUPAIALL_RESPONSE), this.HUPAIALL_RESPONSE)
-- end
