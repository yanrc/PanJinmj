
-- 输出日志--
function log(str)
	--Util.Log(tostring(str));
	print(debug.traceback(tostring(str)))
end

-- 错误日志--
function logError(str)
	Util.LogError(str);
end

-- 警告日志--
function logWarn(str)
	Util.LogWarning(str);
end

-- 查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab, parent)
	if (prefab == nil) then
		logWarn("prefab is nil")
	end
	if (parent ~= nil) then
		return GameToolScript.Instantiate(prefab, parent)
	end
	return GameObject.Instantiate(prefab);
end

-- 创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)
	return child(childNode):GetComponent(typeName);
end

function findPanel(str)
	local obj = find(str);
	if obj == nil then
		error(str .. " is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

function string.split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter == '') then return false end
	local pos, arr = 0, { }
	-- for each divider found
	for st, sp in function() return string.find(input, delimiter, pos, true) end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

function table.indexOf(t, value, iBegin)
	for i = iBegin or 1, #t do
		if t[i] == value then
			return i
		end
	end
	return -1
end

function loadPrefab(perfabName, parent, callback)
	resMgr:LoadPrefab('prefabs', { perfabName .. ".prefab" }, function(prefabs)
		local obj = newObject(prefabs[0]);
		obj.transform.parent = parent
		obj.transform.localScale = Vector3.one
		obj:GetComponent("RectTransform").offsetMax = Vector2.zero
		obj:GetComponent("RectTransform").offsetMin = Vector2.zero
		callback(obj)
	end )
end