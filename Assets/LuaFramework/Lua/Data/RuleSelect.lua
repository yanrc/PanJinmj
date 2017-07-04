RuleSelect = { }
local this = RuleSelect;

local transform;
local gameObject;
-- toggle模板
local Toggle
-- panel模板
local Panel
-- root模板
local root
-- 保存所有规则的字典（string,groupList）
local dic = { }
-- 保存当前规则（list<list<toggle>>）
local groupList = { }

function RuleSelect.Init(obj)
	gameObject = obj
	transform = obj.transform
	Toggle = transform:FindChild('Toggle').gameObject
	Panel = transform:FindChild('GameObject').gameObject
	root = transform:FindChild('root').gameObject
end
function RuleSelect.Open(ruletable)
	local rulestr = ruletable.name
	log(rulestr);
	local trans = transform:FindChild(rulestr);
	if (trans ~= nil) then
		trans.gameObject:SetActive(true);
		groupList = dic[rulestr];
	else
		trans = GameObject.Instantiate(root, transform).transform;
		trans.gameObject.SetActive(true);
		trans.name = rulestr;
		groupList = { };
		dic[rulestr] = groupList
		this.CreateItem(ruletable, trans);
		this.GetDefaultSelect(rulestr);
	end
end
-- 从表里获取配置
function RuleSelect.CreateItem(ruletable, parent)
	local root = nil;
	local group = nil;
	for k, v in pairs(ruletable.groups) do
		-- 新建一个组
		local panel = parent:FindChild(k);
		if (panel == nil) then
			panel = GameObject.Instantiate(Panel, parent).transform;
			panel.gameObject:SetActive(true);
			panel.name = k;
			root = panel.FindChild("roots/root");
		else
			root = panel.FindChild("roots/root2");
			root.gameObject:SetActive(true);
		end
		local textObj = panel:FindChild("textObj");
		textObj:GetComponent("Text").text = k;
		-- 是否可以复选
		if (v._type == "0") then
			group = root.GetComponent("ToggleGroup")
			if (group == nil) then
				group = root.gameObject:AddComponent("ToggleGroup")
			end
		else
			group = nil;
		end
		local temp = { }
		table.insert(groupList, temp)
		for key, value in pairs(v) do
			-- 实例化toggle
			local obj = GameObject.Instantiate(Toggle, root);
			obj:SetActive(true);
			local main = obj.transform:FindChild("Label"):GetComponent("Text")
			local des = obj.transform:FindChild("lbDes"):GetComponent("Text")
			-- 消耗房卡数
			local label = obj.transform:FindChild("cost/Text"):GetComponent("Text")
			local image = obj.transform:FindChild("cost/Image"):GetComponent("Image")
			if (key:match("x%d*")) then
				label.text = key;
				image.enabled = true;
				obj.name = value;
				main.text = value;
			else
				label.text = "";
				image.enabled = false;
				obj.name = key
				main.text = key
				-- 描述
				des.text = value;
			end
			-- 单选
			local toggle = obj:GetComponent("Toggle");
			toggle.group = group;
			table.insert(temp, toggle)
		end
	end
end               


-- 显示默认选择
function RuleSelect.GetDefaultSelect(rulestr)
	local rule = PlayerPrefs.GetInt(rulestr);
	log("rule=" + rule);
	if (rule > 0) then
		for i = groupList.Count, 1, -1 do
			for j = groupList[i].Count, 1, -1 do
				if ((bit.band(rule, 1)) == 1) then
					groupList[i][j].isOn = true;
				else
					groupList[i][j].isOn = false;
				end
				rule = bit.shr(rule, 1);
			end
		end
	else
		for i = 1, groupList.Count do
			groupList[i][1].isOn = true;
		end
	end
end

-- 选择转成数字
function RuleSelect.Select2Int(rulestr)
	local rule = 0;
	for i = 1, groupList.Count do
		for j = 1, groupList[i].Count do
			if (groupList[i][j].isOn) then
				rule = bit.shl(rule, 1) + 1;
			else

				rule = bit.shl(rule, 1);
			end
		end
	end
	log("setrule=" + rule);
	-- 保存默认选择
	PlayerPrefs.SetInt(rulestr, rule);
	return rule;
end


