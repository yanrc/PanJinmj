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
	local trans = transform:FindChild(rulestr);
	if (trans ~= nil) then
		trans.gameObject:SetActive(true);
		groupList = dic[rulestr];
	else
		trans = newObject(root, transform).transform;
		trans.gameObject:SetActive(true);
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
			panel = newObject(Panel, parent).transform;
			panel.gameObject:SetActive(true);
			panel.name = k;
			root = panel:FindChild("roots/root");
		else
			-- 有时候同一标签下有两组
			root = panel:FindChild("roots/root2");
			root.gameObject:SetActive(true);
		end
		local textObj = panel:FindChild("textObj");
		textObj:GetComponent("Text").text = k;
		-- 是否可以复选
		if (v._type == "0") then
			group = root:GetComponent("ToggleGroup")
			if (group == nil) then
				group = root.gameObject:AddComponent(typeof(ToggleGroup))
			end
		else
			group = nil;
		end
		local temp = { }
		table.insert(groupList, temp)
		for key, value in ipairs(v) do
			if (key ~= "_type") then
				-- 实例化toggle
				local obj = newObject(Toggle, root);
				obj:SetActive(true);
				local main = obj.transform:FindChild("Label"):GetComponent("Text")
				local des = obj.transform:FindChild("lbDes"):GetComponent("Text")
				-- 消耗房卡数
				local label = obj.transform:FindChild("cost/Text"):GetComponent("Text")
				local image = obj.transform:FindChild("cost/Image"):GetComponent("Image")
				local strs=string.split(value,'|')
				if (value:match("x%d*")) then
					--键是名字，值是消耗房卡数
					label.text = strs[2];
					image.enabled = true;
					obj.name = strs[1];
					main.text = strs[1];
					des.text = ""
				else
					--键是名字，值是描述
					label.text = "";
					image.enabled = false;
					obj.name = strs[1]
					main.text = strs[1]
					-- 描述
					des.text = strs[2];
				end
				-- 单选
				local toggle = obj:GetComponent("Toggle");
				toggle.group = group;
				table.insert(temp, toggle)
			end
		end
	end
end               


-- 显示默认选择
function RuleSelect.GetDefaultSelect(rulestr)
	local rule = PlayerPrefs.GetInt(rulestr);
	print("rule=" .. rule);
	if (rule > 0) then
		for i = #groupList, 1, -1 do
			for j = #groupList[i], 1, -1 do
				if ((bit.band(rule, 1)) == 1) then
					groupList[i][j].isOn = true;
				else
					groupList[i][j].isOn = false;
				end
				rule = bit.rshift(rule, 1);
			end
		end
	else
		print(Test.DumpTab(groupList))
		for i = 1, #groupList do
			groupList[i][1].isOn = true;
		end
	end
end

-- 选择转成数字(和toggle顺序一致)
function RuleSelect.Select2Int(rulestr)
	local rule = 0;
	for i = 1, #groupList do
		for j = 1, #groupList[i] do
			if (groupList[i][j].isOn) then
				rule = bit.lshift(rule, 1) + 1;
			else
				rule = bit.lshift(rule, 1);
			end
		end
	end
	print("setrule=" .. rule);
	-- 保存默认选择
	PlayerPrefs.SetInt(rulestr, rule);
	return rule;
end


