CoMgr={}
local this=CoMgr
local dicImage={}--已经下载好了的图片字典
local dicForDownLoad = { }--等待下载的图片字典
function CoMgr.LoadImg(img, url)
	if(img==nil or url==nil) then
		logError("img==nil or url==nil")
	return
	end
	if (dicImage[url]~=nil) then
		img.sprite = dicImage[url];
		return;
	else
		this.DownLoad(url, function(www)
			local texture2D = www.texture;
			local bytes = texture2D:EncodeToPNG();
			-- 将图片赋给场景上的Sprite
			local tempSp = Sprite.Create(texture2D, Rect.New(0, 0, texture2D.width, texture2D.height), Vector2.zero);
			img.sprite = tempSp;
			dicImage[url]=tempSp
		end);
	end
end
--启动下载协程并添加回调
--如果已经启动就增加回调
function CoMgr.DownLoad(url, callback)
	if (string.find(url,"http")==nil) then
		return
	end
	if (dicForDownLoad[url]==nil) then
		dicForDownLoad[url]=callback
		coroutine.start(this.download(url, callback))
	else
		listForDownLoad[url] =listForDownLoad[url]+ callback;
	end
end

function CoMgr.download(url, callback)
	local www = WWW(url);
	coroutine.www(www)
	listForDownLoad[url]=nil;
	callback(www);
end
