ZhuaMaPanel = UIBase(define.Panels.ZhuaMaPanel, define.PopUI);
local this = ZhuaMaPanel;
local transform;
local gameObject;

local Parents = { }
local HuPaiPanel
local MaPaiPanel
-- 启动事件--
function ZhuaMaPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	for i = 1, 4 do
		local temp = { }
		temp.root = transform:FindChild('Parents/Parent' .. i)
		temp.img = temp.root:FindChild('Image').gameObject
		table.insert(Parents, temp)
	end
	HuPaiPanel = transform:FindChild('content/HuPaiPanel')
	MaPaiPanel = transform:FindChild('content/MaPaiPanel')
end


function ZhuaMaPanel.CreateMaiPai(malist)
	for i = 1, #malist do
		local obj = newObject(UIManager.PengGangCard_B, MaPaiPanel)
		obj.transform.localPosition = Vector2.New(i * 70, 0)
		obj.transform.localScale = Vector3.one;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(tonumber(malist[i]), 1);
	end
end

function ZhuaMaPanel.CreateHuPai(cardPoint)
	local obj = newObject(UIManager.PengGangCard_B, HuPaiPanel)
	obj.transform.localPosition = Vector2.New(i * 70, 0)
	obj.transform.localScale = Vector3.one;
	local objCtrl = TopAndBottomCardScript.New(obj)
	objCtrl:Init(cardPoint, 1);
end

-- 中码动画
function ZhuaMaPanel.MoveMaiPai(winnerIndex, malist)
	for i = 1, #malist do
		local cardPoint = tonumber(malist[i])
		local Index = this.GetZhongMaIndex(winnerIndex, cardPoint)
		Parents[index].num = Parents[index].num + 1
		local obj = newObject(UIManager.PengGangCard_B, MaPaiPanel)
		obj.transform.localPosition = Vector2.New(i * 70, 0)
		obj.transform.localScale = Vector3.one;
		local objCtrl = TopAndBottomCardScript.New(obj)
		objCtrl:Init(cardPoint, 1);
		obj.transform:SetParent(Parents[Index].root)
		local destination = Vector2.New(Parents[index].num * 70, 0)
		local tweener = obj.transform:DOLocalMove(destination, 1, false):OnComplete(
		function()
			Parents[index].img:SetActive(true)
		end );
		tweener:SetEase(Ease.OutExpo);
	end
end

-- 寻找中码玩家
-- 1,5,9
-- 2,6,中
-- 3,7,发
-- 4,8,白
function ZhuaMaPanel.GetZhongMaIndex(winnerIndex, cardPoint)
	local Index = 1
	local offset = 0
	if cardPoint < 31 then
		offset = cardPoint % 9
	else
		offset =(cardPoint + 1) % 9
	end
	if offset == 0 or offset == 4 or offset == 8 then
		Index = winnerIndex
	elseif offset == 1 or offset == 5 then
		Index =(winnerIndex + 1+3) % 4+1;
	elseif offset == 2 or offset == 6 then
		Index =(winnerIndex + 2+3) % 4+1;
	elseif offset == 3 or offset == 7 then
		Index =(winnerIndex + 3+3) % 4+1;
	end
	return Index
end

-------------------模板-------------------------

function ZhuaMaPanel.OnOpen()
	for i = 1, #Parents do
		Parents[i].num = 0
		Parents[i].img:SetActive(false)
	end
end
