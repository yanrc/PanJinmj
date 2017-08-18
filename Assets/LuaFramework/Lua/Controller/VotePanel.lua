VotePanel = UIBase(define.Panels.VotePanel, define.PopUI)
local this = VotePanel;

local transform;
local gameObject;
local btnConfirm-- 确认按钮
local btnCancel-- 取消按钮
local lbTime-- 倒计时label
local lbNameList = { }
local lbResult = { }
local leftTime-- 剩余时间

this.disagreeCount = 0-- 不同意的人数
this.VoteStatus = false-- 申请解散的状态
-- 启动事件--
function VotePanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	for i = 1, 4 do
		lbNameList[i] = transform:FindChild('Panel/Player' .. i .. '/name'):GetComponent('Text')
		lbResult[i] = transform:FindChild('Panel/Player' .. i .. '/result'):GetComponent('Text')
	end
	lbTime = transform:FindChild('Clock/Text'):GetComponent('Text')
	btnConfirm = transform:FindChild('btnConfirm').gameObject
	btnCancel = transform:FindChild('btnCancel').gameObject
	this.lua:AddClick(btnConfirm, this.Confirm);
	this.lua:AddClick(btnCancel, this.Cancel);
	logWarn("Start lua--->>" .. gameObject.name);
end


function VotePanel.GetPlayerIndex(name)
	for i = 1, #lbNameList do
		if name == lbNameList[i].text then
			return i
		end
	end
	return 1
end

function VotePanel.DissoliveRoomResponse(_type,plyerName)
	local index = this.GetPlayerIndex(plyerName)
	if (_type == 1) then
		lbResult[index].text = "同意";
	elseif (_type == 2) then
		lbResult[index].text = "拒绝";
	end
end

function VotePanel.TimeChange()
	while leftTime > 0 do
		lbTime.text = leftTime
		leftTime = leftTime - 1
		coroutine.wait(1)
	end
end

function VotePanel.Confirm()
	this.DoDissoliveRoomRequest(1)
	btnConfirm:SetActive(false)
	btnCancel:SetActive(false)
end



function VotePanel.Cancel()
	this.DoDissoliveRoomRequest(2)
	btnConfirm:SetActive(false)
	btnCancel:SetActive(false)
end

function VotePanel.DoDissoliveRoomRequest(_type)
	local data = { };
	data.roomId = RoomData.roomId;
	data.type = _type;
	local sendMsg = json.encode(data);
	networkMgr:SendMessage(ClientRequest.New(APIS.DISSOLIVE_ROOM_REQUEST, sendMsg));
	this.VoteStatus = true
end
-------------------模板-------------------------


-- 发起人uuid,名字，玩家列表
function VotePanel:OnOpen(uuid, sponsor, avatarvoList)
	leftTime = 200
	btnConfirm:SetActive(false)
	btnCancel:SetActive(false)
	if LoginData.account.uuid ~= uuid then
		btnConfirm:SetActive(true)
		btnCancel:SetActive(true)
	end
	lbNameList[1].text = sponsor
	local i = 2
	for k, v in pairs(avatarvoList) do
		if v.account.uuid ~= uuid then
			lbNameList[i].text = v.account.nickname
			lbResult[i].text = "正在选择"
			i = i + 1
		end
	end
end
-- 移除事件--
function VotePanel:RemoveListener()
	coroutine.stop(this.TimeChange)
end

-- 增加事件--
function VotePanel:AddListener()
	coroutine.start(this.TimeChange)
end
