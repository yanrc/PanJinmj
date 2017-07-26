
WaitingPanel = UIBase(define.Panels.WaitingPanel,define.PopUI);
local this = WaitingPanel
local gameObject
local transform
local label
local circle
local speed = 260


-- 启动事件--
function WaitingPanel.OnCreate(obj)
	this:Init(obj)
	gameObject = obj;
	transform = obj.transform
	label = transform:FindChild('Connect/Text'):GetComponent('Text')
	circle = transform:FindChild('Connect/Image')
end

function WaitingPanel.FixedUpdate()
	circle:Rotate(Vector3.forward, speed * Time.deltaTime);
end
-------------------模板-------------------------
-- 移除事件--
function WaitingPanel.RemoveListener()
	FixedUpdateBeat:Remove(this.FixedUpdate);
end


function WaitingPanel.OnOpen(des)
	label.text = des
end
-- 增加事件--
function WaitingPanel.AddListener()
	FixedUpdateBeat:Add(this.FixedUpdate);
end
