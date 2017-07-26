VotePanel = UIBase(define.Panels.VotePanel, define.PopUI)
local this = VotePanel;

local transform;
local gameObject;
local btnAgree-- 同意按钮
local btnDisagree-- 不同意按钮
local lbTime-- 倒计时label
local lbNameList = { }
local lbResult = { }
local disagreeCount-- 不同意的人数
local leftTime-- 剩余时间
-- 启动事件--
function VotePanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	-- this.lua:AddClick( ExitPanel.btnExit, this.Exit);
	-- this.lua:AddClick( ExitPanel.btnCancel, this.Cancel);
	logWarn("Start lua--->>" .. gameObject.name);
end
-- 发起人uuid,名字，玩家列表
function VotePanel.Init(uuid, sponsor, avatarvoList)
	disagreeCount = 0
	leftTime = 200
	if GlobalData.loginResponseData.account.uuid == uuid then
		btnAgree:SetActive(false)
		btnDisagree:SetActive(false)
	end
	lbNameList[1].text = sponsor
	local i = 2
	for k, v in pairs(avatarvoList) do
		if avatarvoList.account.uuid ~= uuid then
			lbNameList[i].text = avatarvoList.account.nickname
			lbResult[i].text = "正在选择"
			i = i + 1
		end
	end
end

function VotePanel.DissoliveRoomResponse(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local dissoliveRoomResponseVo = json.decode(message);
	local plyerName = dissoliveRoomResponseVo.accountName;
	local uuid = dissoliveRoomResponseVo.uuid;
	if (dissoliveRoomResponseVo.type == "1") then
		playerList[getPlayerIndex(plyerName)].changeResult("同意");
	elseif (dissoliveRoomResponseVo.type == "2") then
		GlobalData.isonApplayExitRoomstatus = false;
		playerList[getPlayerIndex(plyerName)].changeResult("拒绝");
		disagreeCount = disagreeCount + 1;
		if (disagreeCount >= 2) then
			TipsManager.SetTips("同意解散房间申请人数不够，本轮投票结束，继续游戏");
			ClosePanel(this)
		end
	end
end
-------------------模板-------------------------
function VotePanel.OnOpen(uuid, sponsor, avatarvoList)
	this.Init(uuid, sponsor, avatarvoList)
end
-- 移除事件--
function VotePanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
end

-- 增加事件--
function VotePanel.AddListener()
	Event.AddListener(tostring(APIS.DISSOLIVE_ROOM_RESPONSE), this.DissoliveRoomResponse)
end
