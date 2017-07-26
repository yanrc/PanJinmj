
ExitPanel = UIBase(define.Panels.ExitPanel, define.PopUI);
local this = ExitPanel;
local transform;
local gameObject;

local btnExit
local btnCancel
local title
local content

-- 启动事件--
function ExitPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform;
	this:Init(obj)
	btnExit = transform:FindChild('Image_Bg/Button_Sure').gameObject
	btnCancel = transform:FindChild('Image_Bg/Button_Cancle').gameObject
	title=transform:FindChild('Image_Bg/Title'):GetComponent('Text')
	content=transform:FindChild('Image_Bg/Content'):GetComponent('Text')
	this.lua:AddClick(btnCancel, this.CloseClick)
end


function ExitPanel.Exit()
	if UNITY_ANDROID then
		Application.Quit()
	elseif UNITY_IPHONE then
		TipsManager.SetTips("苹果手机请按Home键盘进行退出！")
	end
end


-------------------模板-------------------------
function ExitPanel.CloseClick()
	ClosePanel(this)
end

function ExitPanel.OnOpen(titleStr, des, f)
	this.lua:ResetClick(btnExit)
	this.lua:AddClick(btnExit, f or this.Exit)
	title.text = titleStr or "提示"
	content.text = des or "亲，确定要退出游戏吗?"
end
-- 移除事件--
function ExitPanel.RemoveListener()

end

-- 增加事件--
function ExitPanel.AddListener()

end