

GamePanel = UIBase(define.Panels.GamePanel, define.FixUI)
local this = GamePanel
-----------------------------------------------------------------------------------------------------------------
-- 需要用到的对象
local gameObject;
local transform
this.playerItems = { }
this.versionText=nil
this.LeavedRoundNumText = nil
this.LeavedCastNumText = nil
this.ruleText=nil
this.btnInviteFriend=nil
this.btnJieSan=nil
this.lbRoomNum=nil-- 大房间号
this.btnMessageBox=nil
this.ExitRoomButton=nil
this.live1=nil
this.live2=nil
this.centerImage=nil
this.guiObj=nil-- 翻开的鬼牌
this.roomRemark=nil-- 房间显示的规则
this.btnSetting=nil-- 设置按钮
this.btnReadyGame = nil
this.noticeGameObject=nil-- 滚动消息
this.noticeText=nil
this.Number=nil-- 桌子中间显示的数字（剩余时间）
this.touziObj=nil-- 骰子
this.Pointer=nil-- 指针
this.imgDuanMen = nil
-- 手牌模板
this.BottomPrefabs={}
-- 桌牌模板
this.ThrowPrefabs={}
-- 吃碰杠牌模板
this.CPGPrefabs={}
-- 暗杠牌模板
this.BackPrefabs={}
-- 吃碰杠胡特效
this.chiEffectGame=nil
this.pengEffectGame=nil
this.gangEffectGame=nil
this.huEffectGame=nil
this.liujuEffectGame=nil
this.effBu=nil
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
this.ReadySelectGroup=nil
this.lbReadySelect = { } -- 游戏准备toggle文字
this.dirGameList = { }-- 桌面指示灯
this.parentList = { }-- 手牌的父对象
this.cpgParent = { }-- 吃碰杠牌的父对象
this.outparentList = { }-- 出牌的父对象
-- 保存吃牌时的三套牌
this.canChiList = { }
this.chiList_1 = { }
this.chiList_2 = { }
this.chiList_3 = { }
-----------------------------------------------------------------------------------------------------------------
-- 重要数据
-- 0自己，1-右边。2-上边。3-左边
this.handerCardList = { }
-- 打在桌上的牌,gameObject
this.tableCardList = { }
-- 玩家列表
this.avatarList = { }
-- 吃碰杠list
this.PengGangList = { }


----------------------------------------------------------------------------------------------------------------

this.CurLocalIndex = 1;-- 当前操作位
-- 上一个出牌者
this.LastAvarIndex = 1
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

this.showTimeNumber = 0

this.LeavedCardsNum = 0 -- 剩余牌数
this.timer = 0
-- 当前显示的消息
this.showNoticeNumber = 1
this.timeFlag = false
GamePanel.__index = GamePanel
function GamePanel.OnCreate(go)
	gameObject = go;
	transform = go.transform
	this:Init(go)
	this.BottomPrefabs = { UIManager.Bottom_B, UIManager.Bottom_R, UIManager.Bottom_T, UIManager.Bottom_L }
	this.ThrowPrefabs = { UIManager.TopAndBottomCard, UIManager.ThrowCard_R, UIManager.TopAndBottomCard, UIManager.ThrowCard_L }
	this.CPGPrefabs = { UIManager.PengGangCard_B, UIManager.PengGangCard_R, UIManager.PengGangCard_T, UIManager.PengGangCard_L }
	this.BackPrefabs = { UIManager.GangBack, UIManager.GangBack_LR, UIManager.GangBack_T, UIManager.GangBack_LR }
	this.Pointer = UIManager.Pointer
	this.versionText = transform:Find('Text_version'):GetComponent('Text');
	this.LeavedRoundNumText = transform:Find('Leaved1/Text'):GetComponent('Text');
	this.ruleText = transform:Find('Rule'):GetComponent('Text');
	this.btnInviteFriend = transform:Find('UIroot/Button_invite_friend').gameObject;
	this.btnJieSan = transform:Find('UIroot/Button_jiesan').gameObject;
	this.lbRoomNum = transform:Find('UIroot/lbRoomNum'):GetComponent('Text');
	this.ExitRoomButton = transform:Find('Button_other'):GetComponent('Button');
	this.live1 = transform:Find('Leaved'):GetComponent('Image');
	this.live2 = transform:Find('Leaved1')
	this.liveJu = transform:Find('Leaved1/imgJu'):GetComponent('Image');
	this.liveQuan = transform:Find('Leaved1/imgQuan'):GetComponent('Image');
	this.centerImage = transform:Find('table'):GetComponent('Image');

	this.chiEffectGame = transform:Find('ChiEffect_B').gameObject
	this.pengEffectGame = transform:Find('PengEffect_B').gameObject
	this.gangEffectGame = transform:Find('GangEffect_B').gameObject
	this.huEffectGame = transform:Find('HuEffect_B').gameObject
	this.liujuEffectGame = transform:Find('Liuju_B').gameObject
	this.effBu = transform:Find('effBu').gameObject
	this.LeavedCastNumText = transform:Find('Leaved/Text'):GetComponent('Text');
	this.guiObj = transform:Find('gui').gameObject
	this.roomRemark = transform:Find('Text'):GetComponent('Text')
	local players = transform:Find('playList')
	this.dirGameList[1] = transform:Find('table/Down/Red1').gameObject
	this.dirGameList[2] = transform:Find('table/Right/Red2').gameObject
	this.dirGameList[3] = transform:Find('table/Up/Red3').gameObject
	this.dirGameList[4] = transform:Find('table/Left/Red4').gameObject
	this.playerItems[1] = PlayerItem.New(players:Find('Player_B').gameObject)
	this.playerItems[2] = PlayerItem.New(players:Find('Player_R').gameObject)
	this.playerItems[3] = PlayerItem.New(players:Find('Player_T').gameObject)
	this.playerItems[4] = PlayerItem.New(players:Find('Player_L').gameObject)

	this.ReadySelect[1] = transform:Find('Panel/DuanMen'):GetComponent('Toggle')
	this.ReadySelect[2] = transform:Find('Panel/Gang'):GetComponent('Toggle')
	this.ReadySelectGroup=transform:Find('Panel'):GetComponent('ToggleGroup')
	this.lbReadySelect[1] = transform:Find('Panel/DuanMen/Label'):GetComponent('Text')
	this.lbReadySelect[2] = transform:Find('Panel/Gang/Label'):GetComponent('Text')
	this.parentList[1] = transform:Find('handparent/Bottom')
	this.parentList[2] = transform:Find('handparent/Right')
	this.parentList[3] = transform:Find('handparent/Top')
	this.parentList[4] = transform:Find('handparent/Left')
	this.cpgParent[1] = transform:Find('cpgParent/PengGangListB')
	this.cpgParent[2] = transform:Find('cpgParent/PengGangListR')
	this.cpgParent[3] = transform:Find('cpgParent/PengGangListT')
	this.cpgParent[4] = transform:Find('cpgParent/PengGangListL')
	this.outparentList[1] = transform:Find('ThrowCardsParent/ThrowCardsListBottom')
	this.outparentList[2] = transform:Find('ThrowCardsParent/ThrowCardsListRight')
	this.outparentList[3] = transform:Find('ThrowCardsParent/ThrowCardsListTop')
	this.outparentList[4] = transform:Find('ThrowCardsParent/ThrowCardsListLeft')
	this.btnReadyGame = transform:Find('Panel/Button').gameObject
	this.Number = transform:Find('table/Number'):GetComponent('Text')
	this.noticeGameObject = transform:Find("Image_Notice_BG").gameObject
	this.noticeText = transform:Find("Image_Notice_BG/textbg/Text"):GetComponent('Text')
	this.btnSetting = transform:Find('soundClose').gameObject

	this.touziObj = transform:Find('Panel_touzi').gameObject
	this.canChiList[1] = transform:Find('ChiList/list_1').gameObject
	this.canChiList[2] = transform:Find('ChiList/list_2').gameObject
	this.canChiList[3] = transform:Find('ChiList/list_3').gameObject
	this.chiList_1[1] = BottomScript.New(transform:Find('ChiList/list_1/Bottom_1').gameObject)
	this.chiList_1[2] = BottomScript.New(transform:Find('ChiList/list_1/Bottom_2').gameObject)
	this.chiList_1[3] = BottomScript.New(transform:Find('ChiList/list_1/Bottom_3').gameObject)
	this.chiList_2[1] = BottomScript.New(transform:Find('ChiList/list_2/Bottom_1').gameObject)
	this.chiList_2[2] = BottomScript.New(transform:Find('ChiList/list_2/Bottom_2').gameObject)
	this.chiList_2[3] = BottomScript.New(transform:Find('ChiList/list_2/Bottom_3').gameObject)
	this.chiList_3[1] = BottomScript.New(transform:Find('ChiList/list_3/Bottom_1').gameObject)
	this.chiList_3[2] = BottomScript.New(transform:Find('ChiList/list_3/Bottom_2').gameObject)
	this.chiList_3[3] = BottomScript.New(transform:Find('ChiList/list_3/Bottom_3').gameObject)
	this.huBtn = transform:Find("btnList/huBtn").gameObject
	this.gangBtn = transform:Find("btnList/GangButton").gameObject
	this.pengBtn = transform:Find("btnList/PengButton").gameObject
	this.chiBtn = transform:Find("btnList/ChiButton").gameObject
	this.passBtn = transform:Find("btnList/PassButton").gameObject
	this.btnBu = transform:Find("btnList/btnBu").gameObject
	this.ChiSelect1 = transform:Find("ChiList/list_1/Button").gameObject
	this.ChiSelect2 = transform:Find("ChiList/list_2/Button").gameObject
	this.ChiSelect3 = transform:Find("ChiList/list_3/Button").gameObject
	this.btnMessageBox = transform:Find('btnMessageBox').gameObject
	this.imgDuanMen = transform:Find('imgDuanMen'):GetComponent('Image');
	MicPhone.OnCreate(go)
	MessageBox.OnCreate(transform, this.lua)
	this.lua:AddClick(this.btnMessageBox, MessageBox.MoveIn)
	this.lua:AddClick(this.btnSetting, function() this:OpenSettingPanel()end)
	this.lua:AddClick(this.btnJieSan, function() this:QuiteRoom()end)
	this.lua:AddClick(this.btnInviteFriend,function() this:InviteFriend()end)
	for i = 1, #this.playerItems do
		this.lua:AddClick(this.playerItems[i].gameObject,function() PlayerItem:DisplayAvatorIp()end)
	end
end


function GamePanel:RandShowTime()
	self.showTimeNumber = math.random(5000, 10000)
end

-- 初始化一次表
function GamePanel:InitArrayList()
	for i = 1, 4 do
		self.handerCardList[i] = { }
		self.tableCardList[i] = { }
		self.PengGangList[i] = { }
	end
end

function GamePanel:CardSelect(objCtrl)
	self:SetPosition(1)
	objCtrl.transform.localPosition = objCtrl.transform.localPosition + Vector2.New(0, 20);
	for k, v in pairs(self.handerCardList[1]) do
		self.handerCardList[1][k].selected = false;
	end
	objCtrl.selected = true
end

function GamePanel:StartGame(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local sgvo = json.decode(message);
	self.LeavedRoundNumText.text = tostring(sgvo.surplusRounds)
	self:CleanGameplayUI();
	self:UpateTimeReStart();	
	self:InitLeftCard();
	self:ShowRuleText(sgvo)

	RoomData.guiPai = sgvo.gui;
	RoomData.surplusTimes = sgvo.surplusRounds
	RoomData.isOverByPlayer = false;

	self.avatarList[sgvo.bankerId + 1].main = true;
	local LocalIndex = self:GetLocalIndex(sgvo.bankerId);
	self.playerItems[LocalIndex].bankerImg.enabled = true
	self:SetDirGameObjectAction(LocalIndex);
	self:DisplayTouzi(sgvo.touzi, sgvo.gui);
	self:InitMyCard(sgvo.paiArray);
	for i = 2, 4 do
		if LocalIndex==i then
			self:InitOtherCardList(i, 14);
		else
			self:InitOtherCardList(i, 13);
		end
	end
end

function GamePanel:ShowRuleText(sgvo)
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
	self.ruleText.text = ruleStr;
end

function GamePanel:CleanGameplayUI()
	log(tostring(self).. ":CleanGameplayUI")
	RoomData.enterType = 4
	-- weipaiImg.transform.gameObject:SetActive(false);
	self.btnInviteFriend:SetActive(false);
	self.btnJieSan:SetActive(false);
	self.ExitRoomButton.transform.gameObject:SetActive(false);
	self.live1.gameObject:SetActive(true);
	self.live2.gameObject:SetActive(true);
	self.liveJu.gameObject:SetActive(true);
	-- tab.transform.gameObject:SetActive(true);
	self.centerImage.transform.gameObject:SetActive(true);
	self.liujuEffectGame:SetActive(false);
	self:SetAllPlayerReadImgVisbleToFalse();
	self.ruleText.text = "";
	self.lbRoomNum.text = ""
end

function GamePanel:InitLeftCard()
	self.LeavedCardsNum = 136
	self.LeavedCardsNum = self.LeavedCardsNum - 53;
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end

function GamePanel:CardsNumChange()
	self.LeavedCardsNum = self.LeavedCardsNum - 1;
	if (self.LeavedCardsNum < 0) then
		self.LeavedCardsNum = 0;
	end
	self.LeavedCastNumText.text = tostring(self.LeavedCardsNum);
end


function GamePanel:CreateMoPaiGameObject(LocalIndex)
	local switch = {
		[1] = Vector2.New(-446 + #self.handerCardList[1] * 80,- 292),
		[2] = Vector2.New(0,- 301 + #self.handerCardList[2] * 30),
		[3] = Vector2.New(226 - 37 * #self.handerCardList[3],0),
		[4] = Vector2.New(0,255 - #self.handerCardList[4] * 30)
	}
	local obj = newObject(self.BottomPrefabs[LocalIndex])
	obj.transform:SetParent(self.parentList[LocalIndex])
	if (LocalIndex == 2) then
		obj.transform:SetAsFirstSibling()
	end
	obj.transform.localPosition = switch[LocalIndex]
	obj.transform.localScale = Vector3.one;
	return obj
end
-- 摸牌
function GamePanel:PickCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardvo = json.decode(message);
	local cardPoint = cardvo.cardPoint;
	local LocalIndex = self:GetLocalIndex(cardvo.avatarIndex)
	self:SetDirGameObjectAction(LocalIndex);
	self:CardsNumChange();
	local go = self:CreateMoPaiGameObject(LocalIndex)
	go.name = cardPoint;
	if (LocalIndex == 1) then
		go.transform.localScale = Vector3.New(1.1, 1.1, 1);
		local objCtrl = BottomScript.New(go)
		objCtrl.OnSendMessage =function(ctrl) self:CardChange(ctrl) end;
		objCtrl.ReSetPoisiton =function(ctrl) self:CardSelect(ctrl) end;
		objCtrl:Init(cardPoint);
		table.insert(self.handerCardList[1], objCtrl)
	else
		table.insert(self.handerCardList[LocalIndex], go)
	end
end
-- 别人摸牌通知
function GamePanel.OtherPickCard(buffer)
--	local status = buffer:ReadInt()
--	local message = buffer:ReadString()
--	local json = json.decode(message);
--	local avatarIndex = json["avatarIndex"];
--	local LocalIndex = self:GetLocalIndex(avatarIndex)
--	self.SetDirGameObjectAction(LocalIndex);
--	self.CardsNumChange();
--	-- 创建其他玩家的摸牌对象
--	local go = self.CreateMoPaiGameObject(LocalIndex)
--	table.insert(self.handerCardList[LocalIndex], go)
end
-- 胡，杠，碰，吃，pass按钮显示.
function GamePanel:ActionBtnShow(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	log("ActionBtnShow,msg =" .. tostring(message));
	self.passStr = "";
	local strs = string.split(message, ',')
	self:ShowBtn(5, true);
	for i = 1, #strs do
		if string.match(strs[i], "hu") then
			self:ShowBtn(1, true);
			self.passStr = self.passStr .. "hu_"
		end
		if string.match(strs[i], "dianpao") then
			self.putOutCardPoint = string.split(strs[i], ':')[2]
			self:ShowBtn(1, true);
			self.passStr = self.passStr .. "qianghu_"
		end
		if string.match(strs[i], "peng") then
			self:ShowBtn(3, true);
			self.putOutCardPoint = string.split(strs[i], ':')[3]
			self.passStr = self.passStr .. "peng_"
		end
		if string.match(strs[i], "gang") then
			self:ShowBtn(2, true);
			self.gangPaiList = string.split(strs[i], ':');
			table.remove(self.gangPaiList, 1)
			self.passStr = self.passStr .. "gang_"
		end
		if string.match(strs[i], "chi") then
			-- 格式：chi：出牌玩家：出的牌|牌1_牌2_牌3| 牌1_牌2_牌3
			-- eg:"chi:1:2|1_2_3|2_3_4"
			local strChi = string.split(strs[i], '|');
			local cardPoint = string.split(strChi[1], ':')[3];
			self.chiPaiPointList = { };
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
				table.insert(self.chiPaiPointList, cpoint)
			end
			self:ShowBtn(4, true);
			self.passStr = self.passStr .. "chi_"
		end
	end
end

-- 手牌排序，鬼牌移到最前
-- point：最后摸的那张牌值
function GamePanel:SortMyCardList()
	local selfIndex = self:GetMyIndexFromList()
	if self.avatarList[selfIndex].tingPai then
		return
	end
	table.sort(self.handerCardList[1],
	function(a, b)
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
function GamePanel:InitMyCard(mineList)
	for i = 1, #mineList[1] do
		if (mineList[1][i] > 0) then
			for j = 1, mineList[1][i] do
				local cardPoint = i - 1
				local go = newObject(self.BottomPrefabs[1])
				go.transform:SetParent(self.parentList[1]);
				go.transform.localScale = Vector3.New(1.1, 1.1, 1);
				local objCtrl = BottomScript.New(go)
				objCtrl.OnSendMessage =function(ctrl) self:CardChange(ctrl) end;
				objCtrl.ReSetPoisiton =function(ctrl) self:CardSelect(ctrl) end;
				objCtrl:Init(cardPoint);
				table.insert(self.handerCardList[1], objCtrl)
			end
		end
	end
	self:SortMyCardList();
	self:SetPosition(1)
end

function GamePanel:SetAllPlayerReadImgVisbleToFalse()
	for _, v in pairs(self.playerItems) do
		v.readyImg.enabled = false
	end
end
function GamePanel:HidePlayerItemImg()
	for _, v in pairs(self.playerItems) do
		v.HuFlag.enabled = false
		v.jiaGang.enabled = false
		v.bankerImg.enabled = false
	end
end

-- 初始化其他人的手牌
function GamePanel:InitOtherCardList(LocalIndex, count)
	log("InitOtherCardList")
	for i = 1, count do
		local go = newObject(self.BottomPrefabs[LocalIndex])
		go.transform:SetParent(self.parentList[LocalIndex]);
		if (LocalIndex == 2) then
			go.transform:SetAsFirstSibling()
		end
		go.transform.localScale = Vector3.one;
		table.insert(self.handerCardList[LocalIndex], go)
	end
	self:SetPosition(LocalIndex)
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
-- objCtrl.OnSendMessage = self.CardChange;
-- objCtrl.ReSetPoisiton = self.CardSelect;
-- objCtrl:Init(cardPoint);
-- --self.InsertCardIntoList(objCtrl);
-- table.insert(self.handerCardList[1], objCtrl)
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
function GamePanel:CardChange(objCtrl)
	-- 这时候才能出牌
	if (self.CurLocalIndex == 1) then
		objCtrl.OnSendMessage = nil;
		objCtrl.ReSetPoisiton = nil;
		local cardPoint = objCtrl.cardPoint;
		-- self.PushOutFromMineList(cardPoint);
		self:CreatePutOutCardAndPlayAction(cardPoint, self:GetMyIndexFromList() -1, objCtrl.transform.position);
		-- 将打出牌移除
		for k, v in pairs(self.handerCardList[1]) do
			if v == objCtrl then
				table.remove(self.handerCardList[1], k)
				destroy(v.gameObject);
				break
			end
		end
		-- 出完牌排序
		self:SortMyCardList()
		self:SetPosition(1);
		-- 出牌动画
		local cardvo = { }
		cardvo.cardPoint = cardPoint;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHUPAI_REQUEST, json.encode(cardvo)));
		self.LastAvarIndex = 1;
		self.CurLocalIndex = 2
		self:CleanBtnShow();
		return true
	end
	return false
end
-- 接收到其它人的出牌通知
function GamePanel:OtherPutOutCard(buffer)
	print("OtherPutOutCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local json = json.decode(message);
	local cardPoint = json["cardIndex"];
	local curAvatarIndex = json["curAvatarIndex"];
	local LocalIndex = self:GetLocalIndex(curAvatarIndex);
	local count = #self.handerCardList[LocalIndex]
	local obj = self.handerCardList[LocalIndex][count];
	self:CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, obj.transform.position);
	table.remove(self.handerCardList[LocalIndex])
	destroy(obj)
	self.LastAvarIndex = LocalIndex;
end
-- 创建打来的的牌对象，并且开始播放动画
-- curAvatarIndex:在self.avatarList里的下标
function GamePanel:CreatePutOutCardAndPlayAction(cardPoint, curAvatarIndex, position)
	log("CreatePutOutCardAndPlayAction")
	soundMgr:playSound(cardPoint, self.avatarList[curAvatarIndex + 1].account.sex);
	local LocalIndex = self:GetLocalIndex(curAvatarIndex);
	-- 飞出去的牌
	local obj = newObject(self.ThrowPrefabs[LocalIndex])
	obj.transform:SetParent(self.outparentList[LocalIndex])
	obj.transform.localPosition = position
	obj.transform.localScale = Vector3.one
	obj.name = "putOutCard";
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, LocalIndex);
	if (LocalIndex == 2) then
		obj.transform:SetAsFirstSibling();
	end
	-- 显示在桌上的牌
	local destination = self:TableCardPosition(LocalIndex)
	local go = self:ThrowBottom(cardPoint, LocalIndex, destination, false)
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
function GamePanel:SetDirGameObjectAction(LocalIndex)
	-- 重新计时
	self:UpateTimeReStart();
	for i = 1, #self.dirGameList do
		self.dirGameList[i]:SetActive(false);
	end
	self.dirGameList[LocalIndex]:SetActive(true);
	self.CurLocalIndex = LocalIndex;
end

function GamePanel:ThrowBottom(cardPoint, LocalIndex, pos, isActive)
	local obj = newObject(self.ThrowPrefabs[LocalIndex])
	obj.transform:SetParent(self.outparentList[LocalIndex])
	obj.transform.localPosition = pos
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, LocalIndex);
	obj.name = tostring(cardPoint);
	obj.transform.localScale = Vector3.one;
	if (LocalIndex == 2) then obj.transform:SetAsFirstSibling() end
	table.insert(self.tableCardList[LocalIndex], obj)
	if (not isActive) then obj:SetActive(false) end
	self:SetPointGameObject(obj);
	return obj
end

-- 吃碰杠牌的位置，i:第几墩，j:第几张牌
function GamePanel:CPGPosition(LocalIndex, i, j)
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

function GamePanel:PengCard(buffer)
	log("PengCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local LocalIndex = self:GetLocalIndex(cardVo.avatarId);
	-- 设置方向灯
	self:SetDirGameObjectAction(LocalIndex);
	-- 播放特效
	self:PengGangHuEffectCtrl("peng");
	soundMgr:playSoundByAction("peng", self.avatarList[cardVo.avatarId + 1].account.sex);
	-- 销毁桌上被碰的牌
	self:RemoveLastCardOnTable()
	local cardPoint = cardVo.cardPoint
	-- 消除手牌
	self:RemoveHandCard(LocalIndex, cardPoint, 2)
	self:AddCPGToTable(LocalIndex, cardPoint, 3, 0)
	self:SetPosition(LocalIndex);
end


function GamePanel:ChiCard(buffer)
	log("ChiCard")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	local LocalIndex = self:GetLocalIndex(cardVo.avatarId);
	self:SetDirGameObjectAction(LocalIndex);
	self:PengGangHuEffectCtrl("chi");
	soundMgr:playSoundByAction("chi", self.avatarList[cardVo.avatarId + 1].account.sex);
	-- 销毁桌上被吃的牌
	self:RemoveLastCardOnTable()
	self:RemoveHandCard(LocalIndex, cardVo.onePoint, 1)
	self:RemoveHandCard(LocalIndex, cardVo.twoPoint, 1)
	self:AddCPGToTable(LocalIndex, { cardVo.cardPoint, cardVo.onePoint, cardVo.twoPoint })
	self:SetPosition(LocalIndex);
end

-- 0.明杠，1.暗杠，2.补杠
function GamePanel:GangCard(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local cardVo = json.decode(message);
	self:PengGangHuEffectCtrl("gang");
	soundMgr:playSoundByAction("gang", self.avatarList[cardVo.avatarId + 1].account.sex)
	local LocalIndex = self:GetLocalIndex(cardVo.avatarId);
	self:SetDirGameObjectAction(LocalIndex);
	local gangType = cardVo.type;
	local cardPoint = cardVo.cardPoint
	local kaigang = cardVo.kaigang
	-- 明杠
	if gangType == 0 then
		-- 销毁桌上被碰的牌
		self:RemoveLastCardOnTable()
		-- 去掉三张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 3)
		self:AddCPGToTable(LocalIndex, cardPoint, 4, 0)
		-- 暗杠
	elseif (gangType == 1) then
		-- 去掉四张手牌
		self:RemoveHandCard(LocalIndex, cardPoint, 4)
		self:AddCPGToTable(LocalIndex, cardPoint, 1, 3)
		-- 补杠
	elseif gangType == 2 then
		self:RemoveHandCard(LocalIndex, cardPoint, 1)
		self:AddCPGToTable(LocalIndex, cardPoint)
	end
	if kaigang then
		self.avatarList[cardVo.avatarId + 1].tingPai = true
		self:LockHandCard(LocalIndex)
	end
	self:SetPosition(LocalIndex);
end

function GamePanel:LockHandCard(Index)
	local count = #self.handerCardList[Index]
	if count % 3 == 2 then
		count = count - 1
	end
	if Index == 1 then
		for i = 1, count do
			self.handerCardList[Index][i].IsTingLock = true
			self.handerCardList[Index][i].bg.color = Color.gray
		end
	else
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/paidimian_05.png' }, function(sprites)
			for i = 1, count do
				self.handerCardList[Index][i]:GetComponent('Image').sprite = sprites[0]
				if (Index == 3) then
					self.handerCardList[Index][i]:GetComponent('RectTransform').sizeDelta = Vector2.New(39, 54)
				else
					self.handerCardList[Index][i]:GetComponent('RectTransform').sizeDelta = Vector2.New(45, 30)
				end
			end
		end )
	end
end

-- 牌值，第几墩，显示几张牌，盖几张牌
function GamePanel:AddCPGToTable(LocalIndex, cardPoint, shownum, hidenum)
	-- 吃
	if type(cardPoint) == "table" then
		local tempList = { };
		tempList.cardPoint = cardPoint[1]
		for i = 1, #cardPoint do
			local obj = newObject(self.CPGPrefabs[LocalIndex])
			obj.transform:SetParent(self.cpgParent[LocalIndex])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
			if (LocalIndex == 2) then
				obj.transform:SetAsFirstSibling();
			end
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(cardPoint[i], LocalIndex);
			table.insert(tempList, obj)
		end
		table.insert(self.PengGangList[LocalIndex], tempList)
	else
		local index = self:GetPaiInpeng(cardPoint, LocalIndex);
		if index == -1 then
			local tempList = { };
			tempList.cardPoint = cardPoint
			for i = 1, hidenum do
				local obj = newObject(self.BackPrefabs[LocalIndex])
				obj.transform:SetParent(self.cpgParent[LocalIndex])
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
				if (LocalIndex == 2) then
					obj.transform:SetAsFirstSibling();
				end
				table.insert(tempList, obj)
			end
			for i = 1, shownum do
				local obj = newObject(self.CPGPrefabs[LocalIndex])
				obj.transform:SetParent(self.cpgParent[LocalIndex])
				obj.transform.localScale = Vector3.one;
				obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i + hidenum)
				if (LocalIndex == 2) then
					obj.transform:SetAsFirstSibling();
				end
				local objCtrl = TopAndBottomCardScript.New(obj)
				objCtrl:Init(cardPoint, LocalIndex);
				table.insert(tempList, obj)
			end
			table.insert(self.PengGangList[LocalIndex], tempList)
			-- 补杠
		else
			local obj = newObject(self.CPGPrefabs[LocalIndex])
			obj.transform:SetParent(self.cpgParent[LocalIndex])
			obj.transform.localScale = Vector3.one;
			obj.transform.localPosition = self:CPGPosition(LocalIndex, index, 4)
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(cardPoint, LocalIndex)
			table.insert(self.PengGangList[LocalIndex][index], obj)
		end
	end
end

function GamePanel:RemoveHandCard(Index, cardPoint, count)
	local list = self.handerCardList[Index]
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
function GamePanel:RemoveLastCardOnTable()
	destroy(table.remove(self.tableCardList[self.LastAvarIndex]));
	self.Pointer:SetActive(false)
end
-- 补花动画
function GamePanel:BuHua(response)
	self:PengGangHuEffectCtrl("buhua");
	local cardVo = json.decode(response.message);
	SoundCtrl.getInstance().playSoundByAction("buhua", self.avatarList[cardVo.avatarIndex].account.sex);
	local LocalIndex = self:GetLocalIndex(cardVo.avatarIndex);
	for i = 1, #cardVo.huaPaiList do
		self:CardsNumChange();
		self:BuhuaRemoveCard(cardVo.huaPaiList[i], LocalIndex);
		self:BuhuaPutCard(cardVo.huaPaiList[i], LocalIndex);
		if (LocalIndex == 0) then
			self:BuhuaAddCard(cardVo.cardList[i], LocalIndex);
		else
			self:CreateMoPaiGameObject(LocalIndex);
		end
	end
	self:UpateTimeReStart();
	self:SetDirGameObjectAction(LocalIndex);
end

-- 去除手上花牌

function GamePanel:BuhuaRemoveCard(cardPoint, LocalIndex)
	if (LocalIndex == 0) then
		for i = 1, #self.handerCardList[1] do
			local temp = self.handerCardList[1][i];
			local cardPoint = temp.cardPoint;
			if (cardPoint == cardPoint) then
				table.remove(self.handerCardList[1], i)
				destroy(temp.gameObject);
				temp = nil
				break;
			end
		end
		-- self.PushOutFromMineList(cardPoint);
		self:SetPosition(1);
	else
		local temp = self.handerCardList[LocalIndex][1];
		table.remove(self.handerCardList[LocalIndex], 1)
		destroy(temp);
	end
end
-- 桌上显示花牌
function GamePanel:BuhuaPutCard(cardPoint, LocalIndex)

end

-- 补牌
function GamePanel:BuhuaAddCard(LocalIndex, cardPoint)
	-- SelfAndOtherPutoutCard = cardPoint;
	-- self.PutCardIntoMineList(cardPoint);
	local go = newObject(self.BottomPrefabs[1])
	go.name = cardPoint;
	go.transform:SetParent(self.parentList[1]);
	go.transform.localScale = Vector3.New(1.1, 1.1, 1);
	go.transform.localPosition = Vector3.New(580, -292);
	local objCtrl = BottomScript.New(go)
	objCtrl.OnSendMessage = function(ctrl) self:CardChange(ctrl) end;
	objCtrl.ReSetPoisiton = function(ctrl) self:CardSelect(ctrl) end;
	objCtrl:Init(cardPoint);
	table.insert(self.handerCardList[1], objCtrl)
end


function GamePanel:PengGangHuEffectCtrl(effectType)
	local effobj = self.pengEffectGame
	if (effectType == "peng") then
		effobj = self.pengEffectGame
	elseif (effectType == "gang") then
		effobj = self.gangEffectGame
	elseif (effectType == "hu") then
		effobj = self.huEffectGame
	elseif (effectType == "liuju") then
		effobj = self.liujuEffectGame
	elseif (effectType == "chi") then
		effobj = self.chiEffectGame
	elseif (effectType == "bu") then
		effobj = self.effBu
	end
	effobj:SetActive(true)
	coroutine.start(
	function()
		coroutine.wait(0.8)
		effobj:SetActive(false)
	end
	)
end


-- function GamePanel.AddListToself.PengGangList(LocalIndex, tempList)
-- log("GamePanel.AddListToself.PengGangList")
-- local switch =
-- {
-- 	[1] = function()
-- 		table.insert(self.PengGangList_B, tempList)
-- 	end,
-- 	[2] = function()
-- 		table.insert(self.PengGangList_R, tempList)
-- 	end,
-- 	[3] = function()
-- 		table.insert(self.PengGangList_T, tempList)
-- 	end,
-- 	[4] = function()
-- 		table.insert(self.PengGangList_L, tempList)
-- 	end
-- }
-- switch[LocalIndex]()
-- end



function GamePanel:GetPaiInpeng(cardPoint, LocalIndex)
	local jugeList = self.PengGangList[LocalIndex]
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
function GamePanel:SetPointGameObject(parent)
	if (parent ~= nil) then
		self.Pointer.transform:SetParent(parent.transform);
		self.Pointer.transform.localScale = Vector3.one;
		self.Pointer.transform.localPosition = Vector3.New(0, parent.transform:GetComponent("RectTransform").sizeDelta.y / 2 + 10);
		self.Pointer.transform:SetParent(transform);
		self.Pointer:SetActive(true)
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



--function GamePanel:InsertCardIntoList(objCtrl)
--	-- 插入牌的方法
--	if (objCtrl ~= nil) then
--		local curCardPoint = objCtrl.cardPoint;
--		-- 得到当前牌指针
--		if (curCardPoint == RoomData.guiPai) then
--			table.insert(self.handerCardList[1], 1, objCtrl)
--			-- 鬼牌放到最前面
--			return;
--		else
--			for i = 1, #self.handerCardList[1] do
--				local cardPoint = self.handerCardList[1][i].cardPoint;
--				if (cardPoint ~= RoomData.guiPai and cardPoint >= curCardPoint) then
--					table.insert(self.handerCardList[1], i, objCtrl)
--					return;
--				end
--			end
--			table.insert(self.handerCardList[1], objCtrl)
--		end
--	end
--end

-- 设置牌位置
function GamePanel:SetPosition(LocalIndex)
	print("SetPosition")
	local tempList = self.handerCardList[LocalIndex]
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
function GamePanel:Update()
	self.timer = self.timer - Time.deltaTime;
	if (self.timer < 0) then
		self.timer = 0;
	end
	self.Number.text = math.floor(self.timer);
	if (self.timeFlag) then
		self.showTimeNumber = self.showTimeNumber - 1;
		if (self.showTimeNumber < 0) then
			self.timeFlag = false;
			self.showTimeNumber = 0;
			self:PlayNoticeAction();
		end
	end
	if (Input.GetKeyDown(KeyCode.T)) then
		self:Test();
	end
end

function GamePanel:PlayNoticeAction()
	self.noticeGameObject:SetActive(true);
	if (BroadcastScript.noticeMegs ~= nil and #BroadcastScript.noticeMegs ~= 0) then
		self.noticeText.transform.localPosition = Vector3.New(500, self.noticeText.transform.localPosition.y);
		self.noticeText.text = BroadcastScript.noticeMegs[self.showNoticeNumber];
		local time = self.noticeText.text.Length * 0.5 + 422 / 56;
		local tweener = self.noticeText.transform:DOLocalMove(
		Vector3.New(- self.noticeText.text.Length * 28, self.noticeText.transform.localPosition.y), time, false)
		.OnComplete(function() self:MoveCompleted() end);
		tweener:SetEase(Ease.Linear);
	end
end

function GamePanel:MoveCompleted()
	self.showNoticeNumber = self.showNoticeNumber + 1;
	if (self.showNoticeNumber == #BroadcastScript.noticeMegs) then
		self.showNoticeNumber = 0;
	end
	self.noticeGameObject:SetActive(false);
	self:RandShowTime();
	self.timeFlag = true;
end

-- 重新开始计时
function GamePanel:UpateTimeReStart()
	self.timer = 16;
end

-- 胡牌按钮点击
function GamePanel:HubtnClick()
	local cardPoint
	local requestVo = { };
	if (self.putOutCardPoint ~= -1) then
		requestVo.type = "dianpao";
		cardPoint = self.putOutCardPoint;
	else
		cardPoint = self.handerCardList[1][#self.handerCardList[1]].cardPoint
	end
	requestVo.cardPoint = cardPoint;
	local sendMsg = json.encode(requestVo);
	networkMgr:SendMessage(ClientRequest.New(APIS.HUPAI_REQUEST, sendMsg));
	self:CleanBtnShow();
	self:CompleteBtnAction()
end
-- 点击放弃按钮
function GamePanel:PassBtnClick()
	networkMgr:SendMessage(ClientRequest.New(APIS.GAVEUP_REQUEST, "gaveup|" .. self.passStr));
	self:CleanBtnShow();
	self:CompleteBtnAction()
end

function GamePanel:PengBtnClick()
	local cardvo = { };
	cardvo.cardPoint = self.putOutCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.PENGPAI_REQUEST, json.encode(cardvo)));
	self:CleanBtnShow();
	self:CompleteBtnAction()
end


function GamePanel:ShowChipai(idx)
	local cpoint = self.chiPaiPointList[idx];
	if (idx == 1) then
		self.chiList_1[1]:Init(cpoint.putCardPoint)
		self.chiList_1[2]:Init(cpoint.oneCardPoint)
		self.chiList_1[3]:Init(cpoint.twoCardPoint)
	end
	if (idx == 2) then
		self.chiList_2[1]:Init(cpoint.putCardPoint)
		self.chiList_2[2]:Init(cpoint.oneCardPoint)
		self.chiList_2[3]:Init(cpoint.twoCardPoint)
	end
	if (idx == 3) then
		self.chiList_3[1]:Init(cpoint.putCardPoint)
		self.chiList_3[2]:Init(cpoint.oneCardPoint)
		self.chiList_3[3]:Init(cpoint.twoCardPoint)
	end
end

-- 显示可吃牌的显示
function GamePanel:ShowChiList()
	self:CleanBtnShow();
	for i = 1, #self.canChiList do
		if (i <= #self.chiPaiPointList) then
			self.canChiList[i].gameObject:SetActive(true);
			self:ShowChipai(i);
		else
			self.canChiList[i].gameObject:SetActive(false);
		end
	end
end

-- 吃牌选择点击
function GamePanel:ChiBtnClick2(idx, go)
	local cpoint = self.chiPaiPointList[idx];
	local cardvo = { }
	cardvo.cardPoint = cpoint.putCardPoint;
	cardvo.onePoint = cpoint.oneCardPoint;
	cardvo.twoPoint = cpoint.twoCardPoint;
	networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
	for i = 1, #self.canChiList do
		self.canChiList[i].gameObject:SetActive(false);
	end
	self:CompleteBtnAction()
end

-- 吃按钮点击
function GamePanel:ChiBtnClick()
	if (#self.chiPaiPointList == 1) then
		local cpoint = self.chiPaiPointList[1];
		local cardvo = { };
		self:UpateTimeReStart();
		cardvo.cardPoint = cpoint.putCardPoint;
		cardvo.onePoint = cpoint.oneCardPoint;
		cardvo.twoPoint = cpoint.twoCardPoint;
		networkMgr:SendMessage(ClientRequest.New(APIS.CHIPAI_REQUEST, json.encode(cardvo)));
		self:CleanBtnShow();
		self:CompleteBtnAction()
	else
		self:ShowChiList();
	end
end

function GamePanel:GangBtnClick()
	local GangRequestVO = { }
	GangRequestVO.cardPoint = tonumber(self.gangPaiList[1])
	GangRequestVO.gangType = 0;
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	self:CleanBtnShow();
	self:CompleteBtnAction()
end
function GamePanel:BuBtnClick()
	local GangRequestVO = { }
	GangRequestVO.cardPoint = tonumber(self.gangPaiList[1])
	GangRequestVO.gangType = 0;
	GangRequestVO.kaigang = false
	networkMgr:SendMessage(ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO)))
	self:CleanBtnShow();
	self:CompleteBtnAction()
end
-- 每局结束销毁牌
function GamePanel:Clean()
	CleanList(self.handerCardList)
	CleanList(self.tableCardList)
	CleanList(self.PengGangList)
	self.guiObj:SetActive(false);
	self.Pointer:SetActive(false)
	self.imgDuanMen.enabled = false
	self:CleanBtnShow()
	self:CompleteBtnAction()
end

function GamePanel:SetRoomRemark()
	local roomvo = RoomData;
	local str = "房间号：\n" .. roomvo.roomId .. "\n"
	.. "局数:" .. roomvo.roundNumber .. "\n\n"
	self.roomRemark.text = str;
end

function GamePanel:AddAvatarVOToList(avatar)
	table.insert(self.avatarList, avatar)
	RoomData.playerList=self.avatarList
	self:SetSeat(avatar);
end
-- 创建房间
function GamePanel:CreateRoomAddAvatarVO(avatar)
	self.avatarList = { }
	self:AddAvatarVOToList(avatar);
	self:SetRoomRemark();
	self:ReadyGame();
end

-- 加入房间
function GamePanel:JoinToRoom(avatars)
	self.avatarList = avatars;
	for i = 1, #avatars do
		self:SetSeat(avatars[i])
	end
	self:SetRoomRemark();
	if (RoomData.jiaGang) then
		self.ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
		self.ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
		self.btnReadyGame:SetActive(true);
		self.ReadySelect[1].interactable = false;
	else
		self:ReadyGame();
	end
end

-- 设置当前角色的座位
function GamePanel:SetSeat(avatar)
	-- 游戏结束后用的数据，勿删！！！
	if (avatar.account.uuid == LoginData.account.uuid) then
		self.playerItems[1]:SetAvatarVo(avatar);
	else
		local myIndex = self:GetMyIndexFromList();
		local curAvaIndex = self:GetIndex(avatar.account.uuid)
		local seatIndex = 1 + curAvaIndex - myIndex;
		if (seatIndex < 1) then
			seatIndex = 4 + seatIndex;
		end
		self.playerItems[seatIndex]:SetAvatarVo(avatar);
	end
end
-- 获取自己在self.avatarList中的下标，等于服务器下标+1
function GamePanel:GetMyIndexFromList()
	if (self.avatarList ~= nil) then
		for i = 1, #self.avatarList do
			if (self.avatarList[i].account.uuid == LoginData.account.uuid or self.avatarList[i].account.openid == LoginData.account.openid) then
				LoginData.account.uuid = self.avatarList[i].account.uuid;
				return i
			end
		end
	end
	return 1;
end
-- 获取玩家在self.avatarList中的下标，等于服务器下标+1
function GamePanel:GetIndex(uuid)
	if (self.avatarList ~= nil) then
		for i = 1, #self.avatarList do
			if (self.avatarList[i].account ~= nil) then
				if (self.avatarList[i].account.uuid == uuid) then
					return i;
				end
			end
		end
		return 1;
	end
end
-- 服务器下标转本地下标
function GamePanel:GetLocalIndex(serverIndex)
	local Index = self:GetMyIndexFromList();
	return(serverIndex - Index + 5) % 4 + 1;
end

function GamePanel:OtherUserJointRoom(buffer)
	log("OtherUserJointRoom")
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local avatar = json.decode(message);
	avatar = AvatarVO.New(avatar)
	self:AddAvatarVOToList(avatar);
end



function GamePanel:HupaiCallBack(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoundOverData = json.decode(message);
	local scores = RoundOverData.currentScore;
	self:HupaiCoinChange(scores);
	if (RoundOverData.type == "0") then
		self:PengGangHuEffectCtrl("hu");
		for i = 1, #RoundOverData.avatarList do
			local LocalIndex = self:GetLocalIndex(i - 1);
			if (RoundOverData.avatarList[i].cardPoint > -1) then
				if (RoundOverData.avatarList[i].uuid ~= RoundOverData.avatarList[i].dianPaoId) then
					soundMgr:playSoundByAction("hu", self.avatarList[i].account.sex);
				else
					soundMgr:playSoundByAction("zimo", self.avatarList[i].account.sex);
				end
				self.playerItems[LocalIndex].HuFlag.enabled = true
			else
				self.playerItems[LocalIndex].HuFlag.enabled = false
			end
		end
		local allMas = RoundOverData.allMas;
		coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
	elseif (RoundOverData.type == "1") then
		soundMgr:playSoundByAction("liuju", LoginData.account.sex);
		self:PengGangHuEffectCtrl("liuju");
	coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
	else
		coroutine.start(Invoke,function() self:OpenGameOverPanelSignal() end,3)
	end
end


function GamePanel:HupaiCoinChange(scores)
	local scoreList = string.split(scores, ',')
	if (scoreList ~= nil and #scoreList > 0) then
		for i = 1, #scoreList - 1 do
			local itemstr = scoreList[i];
			local uuid = tonumber(string.split(itemstr, ':')[1]);
			local score = tonumber(string.split(itemstr, ':')[2]);
			local LocalIndex = self:GetLocalIndex(self:GetIndex(uuid) -1)
			self.playerItems[LocalIndex].scoreText.text = tostring(score);
			self.avatarList[self:GetIndex(uuid)].scores = score;
		end
	end
end


-- 单局结束重置数据的地方
function GamePanel:OpenGameOverPanelSignal()
	local isNextBanker = RoundOverData.nextBankerId == LoginData.account.uuid
	ClosePanel(ZhuaMaPanel)
	OpenPanel(GameOverPanel, isNextBanker)
	self:Clean();
	self:HidePlayerItemImg();
	for i = 1, #self.avatarList do
		self.avatarList[i]:ResetData()
	end
	self:InitArrayList()
end


-- 退出房间确认面板
function GamePanel:QuiteRoom()
	soundMgr:playSoundByActionButton(1);
	if (1 == self:GetMyIndexFromList()) then
		OpenPanel(ExitPanel, "提示", "亲，确定要解散房间吗?",function() self:Tuichu()end);
	else
		OpenPanel(ExitPanel, "提示", "亲，确定要离开房间吗?", function() self:Tuichu()end);
	end

end
-- 退出房间按钮点击
function GamePanel:Tuichu()
	ClosePanel(ExitPanel)
	soundMgr:playSoundByActionButton(1);
	local vo = { };
	vo.roomId = RoomData.roomId;
	local sendMsg = json.encode(vo)
	networkMgr:SendMessage(ClientRequest.New(APIS.OUT_ROOM_REQUEST, sendMsg));
end


function GamePanel:OutRoomCallbak(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local responseMsg = json.decode(message)
	if (responseMsg.status_code == "0") then
		if (responseMsg.type == "0") then
			local uuid = responseMsg.uuid;
			if (uuid ~= LoginData.account.uuid) then
				local index = self:GetIndex(uuid);
				table.remove(self.avatarList, index)
				for i = 1, #self.playerItems do
					self.playerItems[i]:SetAvatarVo(nil);
				end
				if (self.avatarList ~= nil) then
					for i = 1, #self.avatarList do
						self:SetSeat(self.avatarList[i]);
					end
				end
			else
				self:ChangePanel(HomePanel)
			end
		else
			self:ChangePanel(HomePanel)
		end
	else
		TipsManager.SetTips("退出房间失败：" .. tostring(responseMsg.error));
	end
end

-- 游戏设置
function GamePanel:OpenSettingPanel()
	soundMgr:playSoundByActionButton(1);
	local _type = 4
	if (RoomData.enterType == 4) then
		_type = 2;
	elseif (1 == GamePanel:GetMyIndexFromList()) then
		_type = 3;
	end
	OpenPanel(SettingPanel, _type)
end



-- 申请解散房间回调
function GamePanel:DissoliveRoomResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message);
	local plyerName = data.accountName;
	local uuid = data.uuid;
	-- 发起申请
	if (data.type == "0") then
		VotePanel.VoteStatus = true;
		VotePanel.disagreeCount = 0
		OpenPanel(VotePanel, uuid, plyerName, self.avatarList)
		-- 有人同意
	elseif (data.type == "1") then
		VotePanel.DissoliveRoomResponse(1, plyerName)
		-- 有人拒绝
	elseif (data.type == "2") then
		VotePanel.DissoliveRoomResponse(2, plyerName)
		VotePanel.disagreeCount = VotePanel.disagreeCount + 1;
		if (VotePanel.disagreeCount >= 2) then
			VotePanel.VoteStatus = false;
			TipsManager.SetTips("同意解散房间申请人数不够，本轮投票结束，继续游戏");
			ClosePanel(VotePanel)
		end
		-- 解散
	elseif (data.type == "3") then
		VotePanel.VoteStatus = false;
		ClosePanel(VotePanel)
		RoomData.isOverByPlayer = true;
	end
end

function GamePanel:GameReadyNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local data = json.decode(message);
	local avatarIndex = data["avatarIndex"];
	local seatIndex = self:GetLocalIndex(avatarIndex)
	self.playerItems[seatIndex].readyImg.enabled = true
	self.avatarList[avatarIndex + 1].isReady = true;
end

-- 隐藏跟庄
function GamePanel:GameFollowBanderNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	genZhuang:SetActive(true);
	coroutine.start(Invoke,function() self:HideGenzhuang()end, 2)
end

function GamePanel:HideGenzhuang()
	genZhuang:SetActive(false);
end

function GamePanel:ReEnterRoom()
	if (RoomData.enterType == 3) then
		-- 服务器的坑
		if (RoomData.gui <= 0) then
			RoomData.guiPai = -1
		end
		self:SetRoomRemark();
		-- 设置座位
		self.avatarList = RoomData.playerList;
		for i = 1, #self.avatarList do
			self:SetSeat(self.avatarList[i]);
		end
		local selfIndex = self:GetMyIndexFromList()
		LoginData.account.roomcard = self.avatarList[selfIndex].account.roomcard;
		local selfPaiArray = self.avatarList[selfIndex].paiArray;
		if (selfPaiArray == nil or #selfPaiArray == 0) then
			-- 游戏还没有开始
			-- 		if (not self.avatarList[selfIndex].isReady and RoomDataRoomData.currentRound==0) then
			-- 			self.ReadyGame();
			-- 		end
			-- 牌局已开始
		else
			self:CleanGameplayUI();
			-- 显示打牌数据
			self:DisplayTableCards();
			-- 显示鬼牌
			self:DisplayGuiPai();
			-- 显示其他玩家的手牌
			self:DisplayOtherHandercard();
			-- 显示杠牌
			self:DisplayallGangCard();
			-- 显示碰牌
			self:DisplayPengCard();
			-- 显示吃牌
			self:DisplayChiCard();
			self:DispalySelfhanderCard();
			networkMgr:SendMessage(ClientRequest.New(APIS.REQUEST_CURRENT_DATA, "dd"));
		end
	end
end

-- 只加载手牌对象，不排序
function GamePanel:DispalySelfhanderCard()
	local index = self:GetMyIndexFromList()
	local paiArray = self.avatarList[index].paiArray
	for i = 1, #paiArray[1] do
		if (paiArray[1][i] > 0) then
			for j = 1, paiArray[1][i] do
				local go = newObject(self.BottomPrefabs[1]);
				-- 设置父节点
				go.transform:SetParent(self.parentList[1]);
				go.transform.localScale = Vector3.New(1.1, 1.1, 1);
				local objCtrl = BottomScript.New(go)
				local point = i - 1
				objCtrl.OnSendMessage = function(ctrl) self:CardChange(ctrl) end;
				objCtrl.ReSetPoisiton = function(ctrl) self:CardSelect(ctrl) end;
				objCtrl:Init(point)
				-- 增加游戏对象
				table.insert(self.handerCardList[1], objCtrl)
			end
		end
	end
end

--function GamePanel:ToList(param)
--	local returnData = { };
--	for i = 1, #param do

--		local temp = { };
--		for j = 1, #param[i] do
--			temp[j] = param[i][j]
--		end
--		returnData[i] = temp
--	end
--	return returnData;
--end

function GamePanel:MyselfSoundActionPlay()
	self.playerItems[1]:ShowChatAction();
end
-- 桌牌位置
function GamePanel:TableCardPosition(LocalIndex)
	local switch =
	{
		[1] = Vector2.New(-261 + #self.tableCardList[1] % 14 * 37,math.modf(#self.tableCardList[1] / 14) * 67),
		[2] = Vector2.New((math.modf(#self.tableCardList[2] / 13) * -54),- 180 + #self.tableCardList[2] % 13 * 28),
		[3] = Vector2.New(289 - #self.tableCardList[3] % 14 * 37,math.modf(#self.tableCardList[3] / 14) * -67),
		[4] = Vector2.New(math.modf(#self.tableCardList[4] / 13) * 54,152 - #self.tableCardList[4] % 13 * 28)
	}
	return switch[LocalIndex]
end
-- 重连显示打牌数据
function GamePanel:DisplayTableCards()
	log("DisplayTableCards")

	for i = 1, #RoomData.playerList do
		local chupai = RoomData.playerList[i].chupais;
		local LocalIndex = self:GetLocalIndex(self:GetIndex(RoomData.playerList[i].account.uuid) -1);
		if (chupai ~= nil and #chupai > 0) then
			for j = 1, #chupai do
				local pos = self:TableCardPosition(LocalIndex)
				self:ThrowBottom(chupai[j], LocalIndex, pos, true);
			end
		end
	end
end

-- 显示桌面鬼牌
function GamePanel:DisplayTouzi(touzi, gui)
	if (gui ~= -1 and RoomData.roomType == 4 and RoomData.gui == 2) then
		-- 显示骰子
		local r1 = touzi / 10;
		local r2 = touzi % 10;
		self.touziObj.TouziActionScript = TouziActionScript.New()
		local bts = self.touziObj.TouziActionScript;
		bts:SetResult(r1, r2);
		self.touziObj:SetActive(true);
		coroutine.start(Invoke,function() self:DisplayGuiPai() end, 5.5)
	else
		self:DisplayGuiPai();
	end
end

-- 获取显示赖子皮（鬼牌2万 显示1万）
function GamePanel:GetDisplayGuiPai(gui)
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
function GamePanel:DisplayGuiPai()
	log("DisplayGuiPai")
	self.touziObj:SetActive(false);
	local gui = RoomData.guiPai;
	if (gui ~= -1 and(RoomData.hong or RoomData.gui > 0)) then
		-- 显示鬼牌
		-- int mGui = getDisplayGuiPai(gui);//盘锦玩法，显示当前鬼牌的前一张
		local objCtrl = TopAndBottomCardScript.New(self.guiObj)
		objCtrl:Init(gui, 3);
		self.guiObj:SetActive(true);
	end
end

-- 重连显示其他人的手牌
function GamePanel:DisplayOtherHandercard()
	log("DisplayOtherHandercard")
	for i = 1, #RoomData.playerList do
		local LocalIndex = self:GetLocalIndex(self:GetIndex(RoomData.playerList[i].account.uuid) -1);
		local count = RoomData.playerList[i].commonCards;
		if (LocalIndex ~= 1) then
			self:InitOtherCardList(LocalIndex, count);
			if RoomData.playerList[i].tingPai then
				self:LockHandCard(LocalIndex)
			end
		end
	end
end

-- 杠牌重连
function GamePanel:DisplayallGangCard()
	log("DisplayallGangCard")
	for i = 1, #RoomData.playerList do
		local paiArrayType = RoomData.playerList[i].paiArray[2];
		local LocalIndex = self:GetLocalIndex(self:GetIndex(RoomData.playerList[i].account.uuid) -1);
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
						self:DoDisplayAnGangCard(LocalIndex, gangpaiObj.cardPoint, true);
					else
						self:DoDisplayMGangCard(LocalIndex, gangpaiObj.cardPoint);
					end
				end
			end
		end

	end
end


-- 碰牌重连（这个逻辑写得很反人类）
function GamePanel:DisplayPengCard()
	log("DisplayPengCard")
	for i = 1, #RoomData.playerList do
		local paiArrayType = RoomData.playerList[i].paiArray[2];
		-- 第二个数组存储了碰的牌
		local LocalIndex = self:GetLocalIndex(self:GetIndex(RoomData.playerList[i].account.uuid) -1);
			-- 1代表碰的那张牌
			for j = 1, #paiArrayType do
				if (paiArrayType[j] == 1 and RoomData.playerList[i].paiArray[1][j] > 0) then
					-- 服务器没去掉已经吃碰杠的牌，所以处理一下（主要是要去掉自己的）
					RoomData.playerList[i].paiArray[1][j] = RoomData.playerList[i].paiArray[1][j] -3;
					self:DoDisplayPengCard(LocalIndex, j - 1);
				end
			end
	end
end


-- 吃牌重连
function GamePanel:DisplayChiCard()
	log("DisplayChiCard")
	for i = 1, #RoomData.playerList do
		local LocalIndex = self:GetLocalIndex(self:GetIndex(RoomData.playerList[i].account.uuid) -1);
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
				self:DoDisplayChiCard(LocalIndex, chiPaiArray[j]);
			end
		end
	end
end


-- 补花牌的重连
function GamePanel:DisplayBuhua(playerList)
	for i = 1, #playerList do
		local LocalIndex = self:GetLocalIndex(self:GetIndex(playerList[i].account.uuid) -1);
		local buhualist = playerList[i].buhuas;
		if (#buhualist > 0) then
			for j = 1, j < #buhualist do
				self:BuhuaPutCard(buhualist[j], LocalIndex);
			end
		end
	end
end
-- 重连显示明杠
function GamePanel:DoDisplayMGangCard(LocalIndex, point)
	log("DoDisplayMGangCard")
	local TempList = { };
	for i = 1, 4 do
		local obj = newObject(self.CPGPrefabs[LocalIndex])
		obj.transform:SetParent(self.cpgParent[LocalIndex])
		obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex);
		if (LocalIndex == 2 and i < 4) then
			obj.transform:SetAsFirstSibling()
		end
		table.insert(TempList, obj)
	end
	table.insert(self.PengGangList[LocalIndex], TempList)
end


-- 显示暗杠牌
-- show:是否显示暗杠牌值
function GamePanel:DoDisplayAnGangCard(LocalIndex, point, show)
	log("DoDisplayAnGangCard")
	local TempList = { };
	for i = 1, 4 do
		local obj = nil
		if (i == 4 and show) then
			obj = newObject(self.CPGPrefabs[LocalIndex])
			local objCtrl = TopAndBottomCardScript.New(obj)
			objCtrl:Init(point, LocalIndex);
		else
			obj = newObject(self.BackPrefabs[LocalIndex])
		end
		table.insert(TempList, obj)
		obj.transform:SetParent(self.cpgParent[LocalIndex])
		obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2 and i < 4) then
			obj.transform:SetAsFirstSibling()
		end
	end
	table.insert(self.PengGangList[LocalIndex], TempList)
end

-- 重连显示碰牌
function GamePanel:DoDisplayPengCard(LocalIndex, point)
	log("DoDisplayPengCard")
	local TempList = { };
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(self.CPGPrefabs[LocalIndex])
		obj.transform:SetParent(self.cpgParent[LocalIndex])
		obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(point, LocalIndex);
		table.insert(TempList, objCtrl)
	end
	table.insert(self.PengGangList[LocalIndex], TempList)
end
-- 重连显示吃牌
-- chipai一组吃牌的牌值
function GamePanel:DoDisplayChiCard(LocalIndex, chipai)
	log("DoDisplayChiCard")
	local TempList = { };
	for i = 1, 3 do
		local pos = switch[LocalIndex](i)
		local obj = newObject(self.CPGPrefabs[LocalIndex])
		obj.transform:SetParent(self.cpgParent[LocalIndex])
		obj.transform.localPosition = self:CPGPosition(LocalIndex, #self.PengGangList[LocalIndex] + 1, i)
		obj.transform.localScale = Vector3.one;
		if (LocalIndex == 2) then
			obj.transform:SetAsFirstSibling()
		end
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(chipai[i], LocalIndex);
		table.insert(TempList, obj)
	end
	table.insert(self.PengGangList[LocalIndex], TempList)
end

function GamePanel:InviteFriend()
	soundMgr:playSoundByActionButton(1);
	OpenPanel(SharePanel)
end

-- 用户离线回调
function GamePanel:OfflineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = self:GetIndex(uuid) -1;
	local LocalIndex = self:GetLocalIndex(index);
	self.playerItems[LocalIndex].offlineImage.enabled = true
	-- 申请解散房间过程中，有人掉线，直接不能解散房间
	if (VotePanel.VoteStatus) then
		ClosePanel(VotePanel)
		TipsManager.SetTips("由于" .. self.avatarList[index].account.nickname .. "离线，系统不能解散房间")
	end
end

-- 用户上线提醒
function GamePanel:OnlineNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local uuid = tonumber(message);
	local index = self:GetIndex(uuid) -1;
	local LocalIndex = self:GetLocalIndex(index);
	self.playerItems[LocalIndex].offlineImage.enabled = false
end

function GamePanel:MessageBoxNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local arr = string.split(message, '|')
	local uuid = tonumber(arr[2]);
	local LocalIndex = self:GetLocalIndex(self:GetIndex(uuid) -1);
	local index = tonumber(arr[1])
	self:ShowChatMessage(LocalIndex, index)
end
function GamePanel:ShowChatMessage(LocalIndex, index)
	self.playerItems[LocalIndex]:ShowChatMessage(index);
end

-- 发准备消息
function GamePanel:ReadyGame()
	soundMgr:playSoundByActionButton(1);
	local readyvo = { };
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(readyvo)));
end

function GamePanel:MicInputNotice(buffer)
	local sendUUid = buffer:ReadInt()
	local data = buffer:ReadBytes()
	MicPhone.MicInputNotice(data)
	for i = 1, #self.playerItems do
		if (sendUUid == self.playerItems[i].uuid) then
			self.playerItems[i]:ShowChatAction();
		end
	end
end
-- 完成一次按钮操作
function GamePanel:CompleteBtnAction()
	self.putOutCardPoint = -1
	self.gangPaiList = { }
	self.kaigangPaiList = { };
	self.chiPaiPointList = { }
	self.passStr = ""
end

function GamePanel:CleanBtnShow()
	self.huBtn:SetActive(false);
	self.gangBtn:SetActive(false);
	self.pengBtn:SetActive(false);
	self.chiBtn:SetActive(false);
	self.passBtn:SetActive(false);
	self.btnBu:SetActive(false)
end

function GamePanel:ShowBtn(btntype, value)
	if (btntype == 1) then
		self.huBtn:SetActive(value)
	end
	if (btntype == 2) then
		self.gangBtn:SetActive(value)
	end
	if (btntype == 3) then
		self.pengBtn:SetActive(value)
	end
	if (btntype == 4) then
		self.chiBtn:SetActive(value)
	end
	if (btntype == 5) then
		self.passBtn:SetActive(value)
	end
	if (btntype == 6) then
		self.btnBu:SetActive(value)
	end
end

-- 最后一次操作（这代码也写得很反人类）
-- 应该这样修改
-- 1)确定当前是等待出牌还是等待操作
-- 2)等谁出牌,或者谁刚出完牌
function GamePanel:ReturnGameResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local returnstr = message;
	local returnJsonData = json.decode(message);
	-- 1.显示剩余牌的张数和圈数
	local surplusCards = returnJsonData.surplusCards;
	local gameRound = returnJsonData.gameRound;
	self.LeavedCastNumText.text = tostring(surplusCards);
	self.LeavedCardsNum = surplusCards;
	self.LeavedRoundNumText.text = tostring(gameRound);
	RoomData.surplusTimes = gameRound;

	local curAvatarIndex = returnJsonData.curAvatarIndex;
	local pickAvatarIndex = returnJsonData.pickAvatarIndex or 0;
	-- 胡牌后重连没这个值
	local currentCardPoint = returnJsonData.currentCardPoint
	-- 是否已出牌，等待操作
	local waitAction = true
	for i = 1, #self.handerCardList do
		if #self.handerCardList[i] % 3 == 2 then
			waitAction = false
			break
		end
	end
	-- 出牌后等待操作
	if (waitAction) then
		local LocalIndex = self:GetLocalIndex(curAvatarIndex);
		self:SetDirGameObjectAction(LocalIndex);
		self:SortMyCardList()
		-- 等待出牌
	else
		local LocalIndex = self:GetLocalIndex(pickAvatarIndex);
		self:SetDirGameObjectAction(LocalIndex);
		-- 自己摸牌
		if (currentCardPoint ~= nil) then
			local cardPoint
			if (currentCardPoint == -2) then
				local count = #self.handerCardList[1]
				cardPoint = self.handerCardList[1][count].cardPoint;
			else
				cardPoint = currentCardPoint
			end
			self:SortMyCardList()
			-- 最后摸的一张牌
			for i = 1, #self.handerCardList[1] do
				if self.handerCardList[1][i].cardPoint == cardPoint then
					local temp = self.handerCardList[1][i]
					table.remove(self.handerCardList[1], i)
					table.insert(self.handerCardList[1], temp)
					break
				end
			end
		end
	end
	self:SetPosition(1)
	local index = self:GetMyIndexFromList()
	if self.avatarList[index].tingPai then
		self:LockHandCard(1)
	end
	self.LastAvarIndex = self:GetLocalIndex(curAvatarIndex)
	if (self.tableCardList[self.LastAvarIndex] ~= nil and #self.tableCardList[self.LastAvarIndex] ~= 0) then
		local obj = self.tableCardList[self.LastAvarIndex][#self.tableCardList[self.LastAvarIndex]];
		self:SetPointGameObject(obj);
	end
end





-- 解散房间按钮
function GamePanel:InitbtnJieSan()
	if (1 == self:GetMyIndexFromList()) then
		-- 我是房主（一开始庄家是房主）
		resMgr:LoadSprite('dynaimages', { 'Assets/Project/DynaImages/jiesan.png' }, function(sprite)
			self.btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	else
		resMgr:LoadSprite('dynaimages', { "Assets/Project/DynaImages/leaveRoom.png" }, function(sprite)
			self.btnJieSan:GetComponent("Image").sprite = sprite[0]
		end )
	end

end

function GamePanel:HUPAIALL_RESPONSE(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	RoomOverData = json.decode(message);
end


-- 测试方法，用来打印table
function GamePanel:Test()
	local Test=require("Logic.Test")
	print(Test:DumpTab(self.avatarList))
	print(Test:DumpTab(self.handerCardList))
	print(Test:DumpTab(self.PengGangList))
	print(Test:DumpTab(self.tableCardList))
end
------------------------------------------------------------
function GamePanel:OnOpen()
	self:InitArrayList()
	self:RandShowTime();
	self.imgDuanMen.enabled = false
	self.timeFlag = true;
	soundMgr:playBGM(2);
	self.versionText.text = "V" .. Application.version;
	self.lbRoomNum.text = "房间号：" .. RoomData.roomId;
	if (RoomData.enterType == 3) then
		-- 短线重连进入房间
		self:ReEnterRoom();
	elseif (RoomData.enterType == 2) then
		-- 进入他人房间
		self:JoinToRoom(RoomData.playerList);
	else
		-- 创建房间
		self:CreateRoomAddAvatarVO(LoginData);
	end
	MicPhone.OnOpen(self.avatarList)
	self:InitbtnJieSan();
	self:Change();
end



function GamePanel:OnClose()
	LoginData:ResetData();
	RoomData = { }
	RoundOverData = { }
	RoomOverData = { }
	for i = 1, #self.playerItems do
		self.playerItems[i]:Clean()
	end
	for i = 1, #self.ReadySelect do
		self.ReadySelect[i].gameObject:SetActive(false)
		self.ReadySelect[i].interactable = true
	end
	self.btnReadyGame:SetActive(false);
	self.live1.gameObject:SetActive(false);
	self.live2.gameObject:SetActive(false);
	self.liveJu.gameObject:SetActive(false);
	self.liveQuan.gameObject:SetActive(false);
	self:Clean();
	self:Recovery()
end
--改变
function GamePanel:Change()
	--空方法，用来被子类重写
end
--恢复
function GamePanel:Recovery()
--空方法，用来被子类重写
end


-- 增加事件--
function GamePanel:AddListener()
	UpdateBeat:Add(self.Update,self);
	FixedUpdateBeat:Add(MicPhone.FixedUpdate);
	Event.AddListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE),function(buffer) self:StartGame(buffer) end)
	Event.AddListener(tostring(APIS.PICKCARD_RESPONSE), function(buffer) self:PickCard(buffer) end)
	Event.AddListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE), function(buffer) self:OtherPickCard(buffer) end)
	Event.AddListener(tostring(APIS.CHUPAI_RESPONSE), function(buffer) self:OtherPutOutCard(buffer) end)
	Event.AddListener(tostring(APIS.JOIN_ROOM_NOICE), function(buffer) self:OtherUserJointRoom(buffer) end)
	Event.AddListener(tostring(APIS.PENGPAI_RESPONSE),function(buffer) self:PengCard(buffer) end)
	Event.AddListener(tostring(APIS.CHIPAI_RESPONSE), function(buffer) self:ChiCard(buffer) end)
	Event.AddListener(tostring(APIS.GANGPAI_RESPONSE),function(buffer) self:GangCard(buffer) end)
	Event.AddListener(tostring(APIS.OTHER_GANGPAI_NOICE),function(buffer) self:GangCard(buffer) end)
	Event.AddListener(tostring(APIS.RETURN_INFO_RESPONSE),function(buffer) self:ActionBtnShow(buffer) end)
	Event.AddListener(tostring(APIS.HUPAI_RESPONSE), function(buffer) self:HupaiCallBack(buffer) end)
	Event.AddListener(tostring(APIS.OUT_ROOM_RESPONSE), function(buffer) self:OutRoomCallbak(buffer) end)
	Event.AddListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), function(buffer) self:DissoliveRoomResponse(buffer) end)
	Event.AddListener(tostring(APIS.PrepareGame_MSG_RESPONSE), function(buffer) self:GameReadyNotice(buffer) end)
	Event.AddListener(tostring(APIS.OFFLINE_NOTICE), function(buffer) self:OfflineNotice(buffer) end)
	Event.AddListener(tostring(APIS.MessageBox_Notice), function(buffer) self:MessageBoxNotice(buffer) end)
	Event.AddListener(tostring(APIS.RETURN_ONLINE_RESPONSE), function(buffer) self:ReturnGameResponse(buffer) end)
	Event.AddListener(tostring(APIS.ONLINE_NOTICE), function(buffer) self:OnlineNotice(buffer) end)
	Event.AddListener(tostring(APIS.MicInput_Response), function(buffer) self:MicInputNotice(buffer) end)
	Event.AddListener(tostring(APIS.Game_FollowBander_Notice), function(buffer) self:GameFollowBanderNotice(buffer) end)
	Event.AddListener(tostring(APIS.HUPAIALL_RESPONSE), function(buffer) self:HUPAIALL_RESPONSE(buffer) end)
	

	self.lua:AddClick(self.huBtn,function() self:HubtnClick() end)
	self.lua:AddClick(self.gangBtn,function() self:GangBtnClick() end)
	self.lua:AddClick(self.pengBtn, function() self:PengBtnClick() end)
	self.lua:AddClick(self.chiBtn, function() self:ChiBtnClick() end)
	self.lua:AddClick(self.passBtn, function() self:PassBtnClick() end)
	self.lua:AddClick(self.btnBu, function() self:BuBtnClick() end)
	self.lua:AddClick(self.ChiSelect1,function(go) self:ChiBtnClick2(1,go) end)
	self.lua:AddClick(self.ChiSelect2, function(go) self:ChiBtnClick2(2,go) end)
	self.lua:AddClick(self.ChiSelect3, function(go) self:ChiBtnClick2(3,go) end)
	self.lua:AddClick(self.btnReadyGame, function() self:ReadyGame() end)
end
-- 移除事件--
function GamePanel:RemoveListener()
	UpdateBeat:Remove(self.Update,self);
	FixedUpdateBeat:Remove(MicPhone.FixedUpdate);
	Event.RemoveListener(tostring(APIS.STARTGAME_RESPONSE_NOTICE))
	Event.RemoveListener(tostring(APIS.PICKCARD_RESPONSE))
	Event.RemoveListener(tostring(APIS.OTHER_PICKCARD_RESPONSE_NOTICE))
	Event.RemoveListener(tostring(APIS.CHUPAI_RESPONSE))
	Event.RemoveListener(tostring(APIS.JOIN_ROOM_NOICE))
	Event.RemoveListener(tostring(APIS.PENGPAI_RESPONSE))
	Event.RemoveListener(tostring(APIS.CHIPAI_RESPONSE))
	Event.RemoveListener(tostring(APIS.GANGPAI_RESPONSE))
	Event.RemoveListener(tostring(APIS.OTHER_GANGPAI_NOICE))
	Event.RemoveListener(tostring(APIS.RETURN_INFO_RESPONSE))
	Event.RemoveListener(tostring(APIS.HUPAI_RESPONSE))
	Event.RemoveListener(tostring(APIS.OUT_ROOM_RESPONSE))
	Event.RemoveListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE))
	Event.RemoveListener(tostring(APIS.PrepareGame_MSG_RESPONSE))
	Event.RemoveListener(tostring(APIS.OFFLINE_NOTICE))
	Event.RemoveListener(tostring(APIS.MessageBox_Notice))
	Event.RemoveListener(tostring(APIS.RETURN_ONLINE_RESPONSE))
	Event.RemoveListener(tostring(APIS.ONLINE_NOTICE))
	Event.RemoveListener(tostring(APIS.MicInput_Response))
	Event.RemoveListener(tostring(APIS.Game_FollowBander_Notice))
	Event.RemoveListener(tostring(APIS.HUPAIALL_RESPONSE))
	self.lua:ResetClick(self.huBtn)
	self.lua:ResetClick(self.gangBtn)
	self.lua:ResetClick(self.pengBtn)
	self.lua:ResetClick(self.chiBtn)
	self.lua:ResetClick(self.passBtn)
	self.lua:ResetClick(self.btnBu)
	self.lua:ResetClick(self.ChiSelect1)
	self.lua:ResetClick(self.ChiSelect2)
	self.lua:ResetClick(self.ChiSelect3)
	self.lua:ResetClick(self.btnReadyGame)
end
