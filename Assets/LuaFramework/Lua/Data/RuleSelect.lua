RuleSelect = { }
local this = RuleSelect;

local transform;
local gameObject;
-- toggle模板
local Toggle
-- Group模板
local Group
-- root模板（一个面板）
local Root
-- 保存所有规则的字典（string,groupList）
local dic = { }
-- 保存当前规则（list<list<toggle>>）
local groupList = { }

function RuleSelect.Init(obj)
	gameObject = obj
	transform = obj.transform
	Toggle = transform:FindChild('Toggle').gameObject
	Group = transform:FindChild('Group').gameObject
	Root = transform:FindChild('Root').gameObject
end
function RuleSelect.Open(ruletable)
	local rulestr = ruletable.name
	local trans = transform:FindChild(rulestr);
	if (trans ~= nil) then
		trans.gameObject:SetActive(true);
		groupList = dic[rulestr];
	else
		trans = newObject(Root, transform).transform;
		trans.gameObject:SetActive(true);
		trans.name = rulestr;
		groupList = { };
		dic[rulestr] = groupList
		this.CreateItem(ruletable, trans);
		this.GetDefaultSelect(rulestr);
	end
end
function RuleSelect.Close(ruletable)
	local rulestr = ruletable.name
	local trans = transform:FindChild(rulestr);
	if (trans ~= nil) then
		trans.gameObject:SetActive(false);
	end
end
-- 从表里获取配置
function RuleSelect.CreateItem(ruletable, parent)
	local root = nil;
	for i = 1, #ruletable.groups do
		local item = ruletable.groups[i]
		local panel = parent:FindChild(item.title);

		if (panel == nil) then
			panel = newObject(Group, parent).transform;
			panel.anchoredPosition = Vector2.New(item.pos[1], item.pos[2])
			panel.gameObject:SetActive(true);
			panel.name = item.title;
			root = panel:FindChild("root");
		else
			-- 有时候同一标签下有多个组
			root = panel:FindChild("root");
			root = newObject(root, root)
		end
		-- 标题
		local Text = panel:FindChild("Text"):GetComponent("Text");
		Text.text = item.title;
		local temp = { }
		table.insert(groupList, temp)
		for j = 1, #item.content do
			local content = item.content[j]
			-- 实例化toggle
			local obj = newObject(Toggle, root);
			obj:SetActive(true);
			obj.name = content.name
			obj.transform.anchoredPosition = Vector2.New(content.pos[1], content.pos[2])
			local main = obj.transform:FindChild("Label"):GetComponent("Text")
			local des = obj.transform:FindChild("lbDes"):GetComponent("Text")
			-- 消耗房卡数
			local cost = obj.transform:FindChild("cost/Text"):GetComponent("Text")
			local image = obj.transform:FindChild("cost/Image"):GetComponent("Image")
			main.text = content.name or ""
			cost.text = content.cost or ""
			des.text = content.des or ""
			if (content.cost ~= nil) then
				image.enabled = true;
			else
				image.enabled = false;
			end
			local toggle = obj:GetComponent('Toggle')
			-- 单选
			if not item.isCheckBox then
				local group =root:GetComponent('ToggleGroup')			
				toggle.group = group;
			end
			table.insert(temp, toggle)
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
	local num = 0;
	for i = 1, #groupList do
		for j = 1, #groupList[i] do
			if (groupList[i][j].isOn) then
				rule = bit.lshift(rule, 1) + 1;
			else
				rule = bit.lshift(rule, 1);
			end
		end
		num = num + #groupList[i]
	end
	print("setrule=" .. rule);
	-- 保存默认选择
	PlayerPrefs.SetInt(rulestr, rule);
	return rule, num;
end


