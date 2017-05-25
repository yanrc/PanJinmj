-- 盘锦勾选面板
local gameObject
local transform
JiuJiangPanel = { };
local this = JiuJiangPanel;
local RoomCards = { };-- 房卡数
local GameRule = { };-- 麻将玩法
-- 启动事件--
function JiuJiangPanel.Awake(obj)
	gameObject = obj;
	transform = obj.transform;
	this.gameObject = gameObject;
	this.transform = transform;
	this.InitPanel();
	logWarn("Awake lua--->>" .. gameObject.name);
end

-- 初始化面板--
function JiuJiangPanel.InitPanel()
	local rule = PlayerPrefs.GetInt("jiuJiangRule");
	log("rule=" .. tostring(rule))
	if (rule > 0) then
		for i = #guangdongGameRule, 1, -1 do
			if ((bit.band(rule, 1)) == 1) then
				guangdongGameRule[i].isOn = true;
			else
				guangdongGameRule[i].isOn = false;
			end
			rule = bit.shr(rule, 1);
		end
	end
end
-- 获得房卡数
function JiuJiangPanel.GetRoundNumber()
	local roundNumber = 8;
	for i = 1, #RoomCards do
		if (RoomCards[i].isOn) then
			if (i == 0) then
				roundNumber = 4;
			elseif (i == 1) then
				roundNumber = 8;
			elseif (i == 2) then
				roundNumber = 16;
				break;
			end
		end
	end
	return roundNumber;
end

function JiuJiangPanel.GetMayou()
	local mayou = 0;
	for i = 1, 3 do
		if (GameRule[i].isOn) then
			mayou = i-1;
			break;
		end
	end
	return mayou;
end
function JiuJiangPanel.GetKunmai()
	local kunmai = 0;
	for i = 1, 3 do
		if (GameRule[i + 3].isOn) then
			kunmai = i-1;
			break;
		end
	end
	return kunmai;
end
function JiuJiangPanel.GetHongzhongLaizi()
	return GameRule[7].isOn;
end

function JiuJiangPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
	gameObject = nil;
	-- 保存默认选择
	local rule = 0;
	for i = 1, #GameRule do
		if (GameRule[i].isOn) then
			rule = bit.shl(rule, 1) + 1;
		else
			rule = bit.shl(rule, 1);
		end
	end
	log("setrule=" + rule);
	PlayerPrefs.SetInt("jiuJiangRule", rule);
end

function JiuJiangPanel.ActiveSelf()
	if (gameObject) then
		return gameObject.activeSelf
	else
		return false
	end
end