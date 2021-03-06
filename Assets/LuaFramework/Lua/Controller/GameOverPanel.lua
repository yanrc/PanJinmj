GameOverPanel = UIBase(define.Panels.GameOverPanel, define.PopUI)
local this = GameOverPanel
local transform
local gameObject
-- 时间
local timeText
-- 房间号
local roomNoText
-- 局数
local jushuText
-- 标题
local title
-- 单局面板
local SignalEndPanel
-- 全局面板
local FinalEndPanel
-- 查看战绩按钮
local btnShowFinal
-- 继续按钮
local btnContinue
-- 分享按钮
local btnShare
-- 关闭/返回按钮
local btnReturn
-- 选择项
local ReadySelect = { }

-- GamePanel里的玩家列表
local AvatarvoList
-- 单局面板显示的内容
local SingalItem
-- 全局面板显示的内容
local FinalItem
-- local mas_0 = { }
-- local mas_1 = { }
-- local mas_2 = { }
-- local mas_3 = { }
-- local allMasList = { }
-- local ValidMas = { }

-- 启动事件--
function GameOverPanel.OnCreate(obj)
	gameObject = obj
	transform = obj.transform
	this:Init(obj)
	timeText = transform:Find('Image_Game_Over_Bg/Text_Time'):GetComponent('Text')
	roomNoText = transform:Find('Image_Game_Over_Bg/Text_Room_Number'):GetComponent('Text')
	jushuText = transform:Find('Image_Game_Over_Bg/Text_Times'):GetComponent('Text')
	title = transform:Find('Image_Game_Over_Bg/Text_title'):GetComponent('Text')
	SignalEndPanel = transform:Find('Image_Game_Over_Bg/Panel_Current_Time').gameObject
	FinalEndPanel = transform:Find('Image_Game_Over_Bg/Panel_Final').gameObject
	btnShowFinal = transform:Find('Image_Game_Over_Bg/Button_Share_Current').gameObject
	btnContinue = transform:Find('Image_Game_Over_Bg/Button_Continue_Game').gameObject
	btnShare = transform:Find('Image_Game_Over_Bg/Button_Share_Final').gameObject
	btnReturn = transform:Find('Image_Game_Over_Bg/Button_Delete').gameObject
	ReadySelect[1] = transform:Find('DuanMen'):GetComponent('Toggle')
	ReadySelect[2] = transform:Find('Gang'):GetComponent('Toggle')
	this.lua:AddClick(btnContinue, this.ReStratGame)
	this.lua:AddClick(btnReturn, this.CloseClick)
	this.lua:AddClick(btnShowFinal, this.ShowFinal)
	this.lua:AddClick(btnShare, this.ShareFinal)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Panel_Current_Item.prefab" }, function(prefabs) SingalItem = prefabs[0] end)
	resMgr:LoadPrefab('prefabs', { "Assets/Project/Prefabs/Panel_Final_Item.prefab" }, function(prefabs) FinalItem = prefabs[0] end)
end


function GameOverPanel:ClearPanel()
	for i = 0, SignalEndPanel.transform.childCount - 1 do
		destroy(SignalEndPanel.transform:GetChild(i).gameObject);
	end
	for i = 0, FinalEndPanel.transform.childCount - 1 do
		destroy(FinalEndPanel.transform:GetChild(i).gameObject);
	end
end

-- 设置房间信息
function GameOverPanel:InitRoomBaseInfo()
	timeText.text = DateTime.Now:ToString("yyyy-MM-dd");
	roomNoText.text = "房间号：" .. RoomData.roomId;
	jushuText.text = "圈数：" ..(RoomData.roundNumber - RoomData.surplusTimes) .. "/" .. RoomData.roundNumber;
	if (RoomData.roomType == GameConfig.GAME_TYPE_ZHUANZHUAN) then
		title.text = "转转麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_HUASHUI) then
		title.text = "划水麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_CHANGSHA) then
		title.text = "长沙麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_GUANGDONG) then
		title.text = "广东麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_PANJIN) then
		title.text = "盘锦麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_Wuxi) then
		title.text = "无锡麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_SHUANGLIAO) then
		title.text = "双辽麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_JIUJIANG) then
		title.text = "九江麻将";
	elseif (RoomData.roomType == GameConfig.GAME_TYPE_TUIDAOHU) then
		title.text = "推倒胡";
	end
end

function GameOverPanel:GetMas()

end

function GameOverPanel:SetSignalContent()
	if (next(RoundOverData) and RoundOverData.avatarList ~= nil) then
		for i = 1, #RoundOverData.avatarList do
			local itemdata = RoundOverData.avatarList[i];
			local item = newObject(SingalItem)
			item.transform:SetParent(SignalEndPanel.transform)
			item.transform.localScale = Vector3.one;
			local itemCtrl = SignalOverItem.New(item)
			local Banker = this.GetBanker()
			itemCtrl:SetUI(itemdata, Banker);
		end
	end
end

function GameOverPanel:SetFinalContent()
	if (next(RoomOverData) and RoomOverData.totalInfo ~= nil) then
		local itemdatas = RoomOverData.totalInfo;
		local itemCtrls = { }
		local topScore = itemdatas[1].scores;
		local topPaoshou = itemdatas[1].dianpao;
		local lastTopIndex = 1;
		local lastPaoshouIndex = 1;
		for i = 1, #itemdatas do
			local item = newObject(FinalItem)
			item.transform:SetParent(FinalEndPanel.transform)
			item.transform.localScale = Vector3.one;
			local itemCtrl = FinalOverItem.New(item)
			table.insert(itemCtrls, itemCtrl)
			-- 找最大赢家
			if (topScore < itemdatas[i].scores) then
				lastTopIndex = i;
				topScore = itemdatas[i].scores;
			end
			-- 找最佳炮手
			if (topPaoshou < itemdatas[i].dianpao and not itemdatas[i].IsWiner) then
				lastPaoshouIndex = i;
				topPaoshou = itemdatas[i].dianpao;
			end
		end
		itemCtrls[lastTopIndex].IsWiner = true;
		itemCtrls[lastPaoshouIndex].IsPaoshou = true;
		local owerUuid = RoomOverData.theowner;
		for i = 1, #itemdatas do
			local itemdata = itemdatas[i];
			-- 庄家
			if (owerUuid == itemdata.uuid) then
				itemCtrls[i].IsMain = true;
			end
			local account = this.GetAccount(itemdata.uuid);
			-- 头像和名称
			if (account ~= nil) then
				itemCtrls[i].iconUrl = account.headicon;
				itemCtrls[i].Nickname = account.nickname;
			end
			itemCtrls[i]:SetUI(itemdata);
		end
	end
end
-- 开始下一局
function GameOverPanel.ReStratGame()
	local Readyvo = { }
	Readyvo.duanMen = ReadySelect[1].isOn;
	Readyvo.jiaGang = ReadySelect[2].isOn;
	networkMgr:SendMessage(ClientRequest.New(APIS.PrepareGame_MSG_REQUEST, json.encode(Readyvo)));
	soundMgr:playSoundByActionButton(1);
	ClosePanel(this)
	RoundOverData = { }
end

function GameOverPanel.ShowSingle(isNextBanker)
	SignalEndPanel:SetActive(true);
	FinalEndPanel:SetActive(false);
	btnShare:SetActive(false);
	btnReturn:SetActive(false);
	-- 本轮结束，显示查看战绩按钮
	if (RoomData.surplusTimes <= 0 or RoomData.isOverByPlayer) then
		btnShowFinal:SetActive(true);
		btnContinue:SetActive(false);
		ReadySelect[1].gameObject:SetActive(false);
		ReadySelect[2].gameObject:SetActive(false);
	else
		btnShowFinal:SetActive(false);
		btnContinue:SetActive(true);
		ReadySelect[1].gameObject:SetActive(RoomData.duanMen);
		ReadySelect[2].gameObject:SetActive(RoomData.jiaGang);
		ReadySelect[1].interactable = isNextBanker;
	end
	this.SetSignalContent();
end

function GameOverPanel.ShowFinal()
	SignalEndPanel:SetActive(false);
	btnContinue:SetActive(false);
	btnShowFinal:SetActive(false);
	FinalEndPanel:SetActive(true);
	btnShare:SetActive(true);
	btnReturn:SetActive(true);
	this.SetFinalContent();
	soundMgr:playSoundByActionButton(1);
end

function GameOverPanel.ShareFinal()
	WechatOperate.ShareAchievementToWeChat(PlatformType.WeChat);
	soundMgr:playSoundByActionButton(1);
end

function GameOverPanel.GetAccount(uuid)
	if (RoomData.playerList ~= nil) then
		for i = 1, #RoomData.playerList do
			if (RoomData.playerList[i].account ~= nil) then
				if (RoomData.playerList[i].account.uuid == uuid) then
					return RoomData.playerList[i].account
				end
			end
		end
		return nil
	end
end

-- 获取庄家在self.avatarList中的下标，等于服务器下标+1
function GameOverPanel.GetBanker()
	if (RoomData.avatarList ~= nil) then
		for i = 1, #RoomData.avatarList do
			if (RoomData.avatarList[i].main) then
				return i
			end
		end
		return 1
	end
end
-------------------模板-------------------------
-- 整轮结束
function GameOverPanel.CloseClick()
	ClosePanel(this)
	ClosePanel(StartPanel.GetGame(RoomData.roomType))
	OpenPanel(HomePanel)
end

-- 设置面板的显示内容
function GameOverPanel:OnOpen(isNextBanker)
	print("GameOverPanel.OnOpen")
	this.InitRoomBaseInfo();
	this.ClearPanel();
	this.ShowSingle(isNextBanker)
end