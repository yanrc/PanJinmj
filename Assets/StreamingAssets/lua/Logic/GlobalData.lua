--管理器--
GlobalData = {};
local this = GlobalData;
local isonLoginPage=false;
local wechatOperate=nil;
--构建函数--
function GlobalData.Instance()
	return this;
end
--init
this.wechatOperate=GameObject.Find("Utils/ShareSDK"):GetComponent('WechatOperateScript');

this.wwwSpriteImage={}


--重新初始化数据
function GlobalData.reinitData()
	this.isDrag = false;
	this.loginResponseData = nil;
	this.roomJoinResponseData = nil;
	this.roomVo = nil;
	this.hupaiResponseVo = nil;
	this.finalGameEndVo = nil;
	this.roomAvatarVoList = nil;
	this.surplusTimes = 0;
	this.totalTimes = 0;
	this.userMaJiangKind = 0;
	this.reEnterRoomData = nil;
	this.singalGameOverList = nil;
	this.lotteryDatas = nil;
	this.isonApplayExitRoomstatus = false;
	this.isOverByPlayer = false;
	this.loginVo = nil;
	this.isChiState = false;
end
function GlobalData.getIpAddress()
	local all = GameToolScript.getIpAddress("http://1212.ip138.com/ic.asp");
	--log(all)
	--local startIndex =string.find(all,"[") + 1;
	--ocal endIndex = string.find(all,"]");
	--local count = endIndex - startIndex;
	--log(count)
	--tempip =string.sub(all,startIndex,count);
	tempip =string.match(all,"%d+.%d+.%d+.%d+");
	--log(tempip)
	return tempip;
end