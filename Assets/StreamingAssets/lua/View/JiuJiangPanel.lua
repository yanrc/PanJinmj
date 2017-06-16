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
	logWarn("Awake lua--->>" .. gameObject.name);
	this.InitPanel();
end

-- 初始化面板--
function JiuJiangPanel.InitPanel()
	transform.parent = CreateRoomPanel.transform
	transform.localPosition = Vector3.New(149, 16, 0)
	RoomCards[1] = transform:FindChild("GameObject_Times/Toggle_x4"):GetComponent("Toggle")
	RoomCards[2] = transform:FindChild("GameObject_Times/Toggle_x8"):GetComponent("Toggle")
	RoomCards[3] = transform:FindChild("GameObject_Times/Toggle_x16"):GetComponent("Toggle")
	GameRule[1] = transform:FindChild("GameObject_Rules/group1/Toggle_mayou0"):GetComponent("Toggle")
	GameRule[2] = transform:FindChild("GameObject_Rules/group1/Toggle_mayou1"):GetComponent("Toggle")
	GameRule[3] = transform:FindChild("GameObject_Rules/group1/Toggle_mayou2"):GetComponent("Toggle")
	GameRule[4] = transform:FindChild("GameObject_Rules/group2/Toggle_kunmai0"):GetComponent("Toggle")
	GameRule[5] = transform:FindChild("GameObject_Rules/group2/Toggle_kunmai1"):GetComponent("Toggle")
	GameRule[6] = transform:FindChild("GameObject_Rules/group2/Toggle_kunmai2"):GetComponent("Toggle")
	GameRule[7] = transform:FindChild("GameObject_Rules/group3/Toggle_hongzhong"):GetComponent("Toggle")

	local rule = PlayerPrefs.GetInt("jiuJiangRule");
	log("JiuJiangPanel.lua:rule=" .. tostring(rule))
	if (rule > 0) then
		for i = #GameRule, 1, -1 do
			if ((bit.band(rule, 1)) == 1) then
				GameRule[i].isOn = true;
			else
				GameRule[i].isOn = false;
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
			mayou = i - 1;
			break;
		end
	end
	return mayou;
end
function JiuJiangPanel.GetKunmai()
	local kunmai = 0;
	for i = 1, 3 do
		if (GameRule[i + 3].isOn) then
			kunmai = i - 1;
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