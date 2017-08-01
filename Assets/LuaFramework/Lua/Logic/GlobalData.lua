--管理器--
GlobalData = {};
local this = GlobalData;


this.messageBoxContents={
"快点啦，时间很宝贵的！",
"又断线了，网络怎么这么差！",
"不要走决战到天亮。",
"你的牌打的太好了！",
"你是美眉还是哥哥？",
"和你合作真是太愉快了！",
"大家好很高兴见到大家！",
"各位真不好意思,我要离开一会",
"有什么好吵的,专心玩游戏吧！",
"我到底跟你有什么仇什么怨！",
"哎呀！打错了怎么办"
}
--this.wwwSpriteImage={}


--重新初始化数据(后期需要重点优化的地方)
function GlobalData.ReinitData()
	this.loginResponseData = nil;
end
function GlobalData.GetIpAddress(callback)
    local www = WWW("http://1212.ip138.com/ic.asp");
	local timeout={time=5,dotimeout=function() callback("IP获取失败") end}
    coroutine.www(www,timeout)
    local all = www.text;
	log(all)
	local tempip =string.match(all,"%d+.%d+.%d+.%d+");
	callback(tempip)
end

