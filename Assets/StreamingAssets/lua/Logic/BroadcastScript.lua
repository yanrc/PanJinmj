require "View/Moban"
BroadcastScript = { };
local this = BroadcastScript;


-- 加载函数--
function BroadcastScript.Awake()
	logWarn("BroadcastScript Awake--->>");
	this.AddListener()
end

function BroadcastScript.GameBroadcastNotice(response)
	local noticeString = response.message;
	local noticeList = string.split(noticeString, '*')
	if (noticeList ~= nil) then
	GlobalData.notices = noticeList
--		GlobalData.notices = { }
--		for i = 1, #noticeList do
--			GlobalData.notices[i] = noticeList[i];
--		end
		Event.Brocast(DisplayBroadcast)
	end
end
-------------------模板-------------------------


-- 移除事件--
function BroadcastScript.RemoveListener()
SocketEventHandle.getInstance ().gameBroadcastNotice=nil
end

-- 增加事件--
function BroadcastScript.AddListener()
SocketEventHandle.getInstance ().gameBroadcastNotice=this.GameBroadcastNotice
end


