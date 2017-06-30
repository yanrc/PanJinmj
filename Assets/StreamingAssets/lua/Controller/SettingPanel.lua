
SettingPanel = UIBase("SettingPanel")
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
	this.lua:AddClick(btnClose, this:Close());
	this.lua:AddClick(btnMinYinYue, this.setJingyin);
	this.lua:AddClick(btnMaxYinYue, this.setMax);
	this.lua:AddClick(btnMinYinXiao, this.setJingyin2);
	this.lua:AddClick(btnMaxYinXiao, this.setMax2);
	sliderYinYue.onValueChanged:AddListener(this.silderChange)
	sliderYinXiao.onValueChanged:AddListener(this.silder2Change)
end

-------------------模板-------------------------


-- 移除事件--
function SettingPanel.RemoveListener()

end


-- 增加事件--
function SettingPanel.AddListener()

end

function SettingPanel.OnOpen()
	sliderYinYue.value = soundMgr.MusicVolume
	sliderYinXiao.value = soundMgr.EffectVolume
	this.lua:ResetClick(jiesanBtn)
	local _type = 1;
	if (GamePanel.isGameStarted) then
		jiesanBtnStr.text = "申请解散房间";
		_type = 2;
	else
		if (1 == GamePanel.GetMyIndexFromList()) then
			-- 我是房主（一开始庄家是房主）
			jiesanBtnStr.text = "解散房间";
			_type = 3;
		else
			jiesanBtnStr.text = "离开房间";
			_type = 4;
		end
	end
	log("_type" .. _type)
	if (_type == 1) then
		this.lua:AddClick(jiesanBtn, this.toExit)
	elseif (_type == 2) then
		this.lua:AddClick(jiesanBtn, this.toJieSan)
	elseif (_type == 3) then
		this.lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要解散房间吗?") end)
	elseif (_type == 4) then
		this.lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要离开房间吗?") end)
	end
end
function SettingPanel.toJieSan()
	TipsManager.loadDialog("申请解散房间", "你确定要申请解散房间？", this.doDissoliveRoomRequest, nil);
	this:Close()
end

function SettingPanel.toExit()
	ExitAppScript.OpenPanel(transform);
end
function SettingPanel.toLeaveRoom(des)
	TipsManager.loadDialog("提示", des, this.LeaveRoom, nil);
	this:Close();
end


function SettingPanel.LeaveRoom()
	local vo = { };
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo);
	networkMgr:SendMessage(ClientRequest.New(APIS.OUT_ROOM_REQUEST, sendMsg));
	gameObject:SetActive(false);
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
