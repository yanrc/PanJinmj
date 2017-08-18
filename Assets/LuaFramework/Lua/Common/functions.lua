
-- 输出日志--
function log(str)
	Util.Log(tostring(str));
	--print(debug.traceback(tostring(str)))
	--print(tostring(str));
end

-- 错误日志--
function logError(str)
	Util.LogError(debug.traceback(tostring(str)));
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

function IsNil(uobj)
	return uobj == nil or uobj:Equals(nil)
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

function string.bytes2string(bytes)
	local str = ''
	if (type(bytes) == "table") then
		for i = 1, #bytes do
			str = str .. string.char(bytes[i])
		end
	elseif (type(bytes) == "userdata") then
		for i = 0, bytes.Length - 1 do
			str = str .. string.char(bytes[i])
		end
	else
		log(string.format("bytes type is %s", type(bytes)))
	end
	return str
end
--[Comment]
-- 摧毁list中的gameobject
function CleanList(list)
	for k, v in pairs(list) do
		if type(v) == "table" then
			CleanList(v)
		elseif type(v) == "userdata" then
			if not IsNil(v) and not IsNil(v.gameObject) then
				destroy(v.gameObject)
			end
		end
	end
end

function Invoke(f, time)
	coroutine.wait(time)
	f()
end