CoMgr = { }
local this = CoMgr
local dicImage = { }-- 已经下载好了的图片字典
local dicForDownLoad = { }-- 等待下载的图片字典
local Sprite = UnityEngine.Sprite
local Rect = UnityEngine.Rect
function CoMgr.LoadImg(img, url)
	xpcall(
	function()
		if (img == nil or url == nil) then
			logWarn("img==nil or url==nil")
			return
		end
		if (dicImage[url] ~= nil) then
			img.sprite = dicImage[url];
			return;
		else
			this.DownLoad(url, function(www)
				local texture2D = www.texture;
				--local bytes = texture2D:EncodeToPNG();
				-- 将图片赋给场景上的Sprite
				local tempSp = Sprite.Create(texture2D, Rect.New(0, 0, texture2D.width, texture2D.height), Vector2.zero);
				img.sprite = tempSp;
				dicImage[url] = tempSp
			end );
		end
	end , logError
	)
end
-- 启动下载协程并添加回调
-- 如果已经启动就增加回调
function CoMgr.DownLoad(url, callback)
	if (string.find(url, "http") == nil) then
		return
	end
	if (dicForDownLoad[url] == nil) then
		dicForDownLoad[url] = callback
		coroutine.start(this.download, url, callback)
	else
		dicForDownLoad[url] = function() dicForDownLoad[url]() callback() end;
	end
end

function CoMgr.download(url, callback)
	local www = WWW(url);
	coroutine.www(www)
	dicForDownLoad[url] = nil;
	callback(www);
end

function CoMgr.GetIpAddress(callback)
	local www = WWW("http://1212.ip138.com/ic.asp");
	local timeout = { time = 5, dotimeout = function() callback("IP获取失败") end }
	coroutine.www(www, timeout)
	local all = www.text;
	log(all)
	local tempip = string.match(all, "%d+.%d+.%d+.%d+");
	callback(tempip)
end