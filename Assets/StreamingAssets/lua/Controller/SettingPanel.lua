
SettingPanel = UIBase(define.Panels.SettingPanel, define.PopUI)
local this = SettingPanel

local transform;
local gameObject;
local yinyueSlider;
local yinxiaoSlider;
local jiesanBtn;-- 解散按钮
local jiesanBtnStr;-- 解散按钮文本
local btnStr;-- 解散按钮文字
local mtype = 0;-- 1.退出游戏；2.申请解散房间；3.房主解散房间；4.房客离开房间
local btnClose
local btnMinYinYue
local btnMaxYinYue
local btnMinYinXiao
local btnMaxYinXiao
local sliderYinYue
local sliderYinXiao

-- 启动事件--
function SettingPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	jiesanBtn = transform:FindChild('Button').gameObject
	jiesanBtnStr = transform:FindChild('Button/Text'):GetComponent('Text')
	btnClose = transform:FindChild('Image_Enter_Room_Bg/Button_Close').gameObject
	btnMinYinYue = transform:FindChild('Slider_yinyue/Image (1)').gameObject
	btnMaxYinYue = transform:FindChild('Slider_yinyue/Image (2)').gameObject
	btnMinYinXiao = transform:FindChild('Slider_yinxiao/Image (1)').gameObject
	btnMaxYinXiao = transform:FindChild('Slider_yinxiao/Image (2)').gameObject
	sliderYinYue = transform:FindChild('Slider_yinyue'):GetComponent('Slider')
	sliderYinXiao = transform:FindChild('Slider_yinxiao'):GetComponent('Slider')
	this.lua:AddClick(btnClose, this.CloseClick);
	this.lua:AddClick(btnMinYinYue, this.setJingyin);
	this.lua:AddClick(btnMaxYinYue, this.setMax);
	this.lua:AddClick(btnMinYinXiao, this.setJingyin2);
	this.lua:AddClick(btnMaxYinXiao, this.setMax2);
	sliderYinYue.onValueChanged:AddListener(this.silderChange)
	sliderYinXiao.onValueChanged:AddListener(this.silder2Change)
end

function SettingPanel.toJieSan()
	OpenPanel(ExitPanel, "申请解散房间", "你确定要申请解散房间？", this.doDissoliveRoomRequest);
	ClosePanel(this)
end

function SettingPanel.toExit()
	OpenPanel(ExitPanel);
	ClosePanel(this)
end
function SettingPanel.toLeaveRoom(des)
	OpenPanel(ExitPanel, "提示", des, this.LeaveRoom);
	ClosePanel(this)
end


function SettingPanel.LeaveRoom()
	local vo = { };
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo);
	networkMgr:SendMessage(ClientRequest.New(APIS.OUT_ROOM_REQUEST, sendMsg));
end
function SettingPanel.doDissoliveRoomRequest()
	local dissoliveRoomRequestVo = { };
	dissoliveRoomRequestVo.roomId = GlobalData.loginResponseData.roomId;
	dissoliveRoomRequestVo.type = "0";
	local sendMsg = json.encode(dissoliveRoomRequestVo);
	networkMgr:SendMessage(ClientRequest.New(APIS.DISSOLIVE_ROOM_REQUEST, sendMsg));
	GlobalData.isonApplayExitRoomstatus = true;
end

-- 音乐音量
function SettingPanel.silderChange(value)
	PlayerPrefs.SetFloat("MusicVolume", value);
	soundMgr.MusicVolume = value
end
-- 音效音量
function SettingPanel.silder2Change(value)
	PlayerPrefs.SetFloat("EffectVolume", value);
	soundMgr.EffectVolume = value
end


function SettingPanel.setJingyin()
	sliderYinYue.value = 0;
	soundMgr.MusicVolume = 0
end

function SettingPanel.setMax()
	sliderYinYue.value = 1;
	soundMgr.MusicVolume = 1
	soundMgr:playSoundByActionButton(1);
end

function SettingPanel.setJingyin2()
	sliderYinXiao.value = 0;
	soundMgr.EffectVolume = 0
end
function SettingPanel.setMax2()
	sliderYinXiao.value = 1;
	soundMgr.EffectVolume = 1
	soundMgr:playSoundByActionButton(1);
end
-------------------模板-------------------------
function SettingPanel.CloseClick()
	ClosePanel(this)
end
function SettingPanel.OnOpen(_type)
	sliderYinYue.value = soundMgr.MusicVolume
	sliderYinXiao.value = soundMgr.EffectVolume
	this.lua:ResetClick(jiesanBtn)
	if (_type == 1) then
		jiesanBtnStr.text = "退出游戏"
		this.lua:AddClick(jiesanBtn, this.toExit)
	elseif (_type == 2) then
		jiesanBtnStr.text = "申请解散房间";
		this.lua:AddClick(jiesanBtn, this.toJieSan)
	elseif (_type == 3) then
		jiesanBtnStr.text = "解散房间";
		this.lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要解散房间吗?") end)
	elseif (_type == 4) then
		jiesanBtnStr.text = "离开房间";
		this.lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要离开房间吗?") end)
	end
end
-- 移除事件--
function SettingPanel.RemoveListener()

end


-- 增加事件--
function SettingPanel.AddListener()

end


