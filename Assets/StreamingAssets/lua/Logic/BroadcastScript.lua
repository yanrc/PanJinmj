
BroadcastScript = { };
local this = BroadcastScript;


-- 加载函数--
function BroadcastScript.Awake()
	logWarn("BroadcastScript Awake--->>");
	this.AddListener()
end

function BroadcastScript.GameBroadcastNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	local noticeString = message;
	local noticeList = string.split(noticeString, '*')
	if (noticeList ~= nil) then
		GlobalData.notices = noticeList
		Event.Brocast(DisplayBroadcast)
	end
end

function BroadcastScript.ServiceErrorNotice(buffer)
	local status = buffer:ReadInt()
	local message = buffer:ReadString()
	ClosePanel(WaitingPanel)
	TipsManager.SetTips(message);
end

function BroadcastScript.HeadResponse(buffer)

end
-------------------模板-------------------------


-- 移除事件--
function BroadcastScript.RemoveListener()
	Event.RemoveListener(tostring(APIS.GAME_BROADCAST), this.GameBroadcastNotice)
	Event.RemoveListener(tostring(APIS.ERROR_RESPONSE), this.ServiceErrorNotice)
end

-- 增加事件--
function BroadcastScript.AddListener()
	Event.AddListener(tostring(APIS.headRESPONSE), this.HeadResponse)
	Event.AddListener(tostring(APIS.GAME_BROADCAST), this.GameBroadcastNotice)
	Event.AddListener(tostring(APIS.ERROR_RESPONSE), this.ServiceErrorNotice)
end


