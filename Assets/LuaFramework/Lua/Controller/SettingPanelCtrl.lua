local json=require"cjson"

SettingPanelCtrl = { };
local this = SettingPanelCtrl;

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
local lua
-- 加载函数--
function SettingPanelCtrl.Awake()
	logWarn("SettingScript Awake--->>");
	PanelManager:CreatePanel('SettingPanel', this.OnCreate);
	CtrlManager.SettingPanelCtrl = this
end

-- 启动事件--
function SettingPanelCtrl.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	lua = gameObject:GetComponent('LuaBehaviour');
	jiesanBtn = transform:FindChild('Button').gameObject
	jiesanBtnStr = transform:FindChild('Button/Text'):GetComponent('Text')
	btnClose = transform:FindChild('Image_Enter_Room_Bg/Button_Close').gameObject
	btnMinYinYue = transform:FindChild('Slider_yinyue/Image (1)').gameObject
	btnMaxYinYue = transform:FindChild('Slider_yinyue/Image (2)').gameObject
	btnMinYinXiao = transform:FindChild('Slider_yinxiao/Image (1)').gameObject
	btnMaxYinXiao = transform:FindChild('Slider_yinxiao/Image (2)').gameObject
	sliderYinYue = transform:FindChild('Slider_yinyue'):GetComponent('Slider')
	sliderYinXiao = transform:FindChild('Slider_yinxiao'):GetComponent('Slider')
	lua:AddClick(btnClose, this.Close);
	lua:AddClick(btnMinYinYue, this.setJingyin);
	lua:AddClick(btnMaxYinYue, this.setMax);
	lua:AddClick(btnMinYinXiao, this.setJingyin2);
	lua:AddClick(btnMaxYinXiao, this.setMax2);
	sliderYinYue.onValueChanged:AddListener(this.silderChange)
	sliderYinXiao.onValueChanged:AddListener(this.silder2Change)
	logWarn("Start lua--->>" .. gameObject.name);
	this.Start();
end

-------------------模板-------------------------

-- 关闭面板--
function SettingPanelCtrl.Close()
	gameObject:SetActive(false)
	this.RemoveListener()
end

-- 移除事件--
function SettingPanelCtrl.RemoveListener()

end

-- 打开面板--
function SettingPanelCtrl.Open()
	if (gameObject) then
		gameObject:SetActive(true)
		transform:SetAsLastSibling();
		this.AddListener()
		this.Init()
	elseif (CtrlManager.SettingPanelCtrl ~= nil) then
		return
	else
		this.Awake()
	end
end
-- 增加事件--
function SettingPanelCtrl.AddListener()

end

function SettingPanelCtrl.Start()
	this.Init()
end
function SettingPanelCtrl.Init()
	sliderYinYue.value = soundMgr.MusicVolume
	sliderYinXiao.value = soundMgr.EffectVolume
	lua:ResetClick(jiesanBtn)
	local _type = 1;
	if (GamePanelCtrl.isGameStarted) then
		jiesanBtnStr.text = "申请解散房间";
		_type = 2;
	else
		if (1 == GamePanelCtrl.GetMyIndexFromList()) then
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
		lua:AddClick(jiesanBtn, this.toExit)
	elseif (_type == 2) then
		lua:AddClick(jiesanBtn, this.toJieSan)
	elseif (_type == 3) then
		lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要解散房间吗?") end)
	elseif (_type == 4) then
		lua:AddClick(jiesanBtn, function() this.toLeaveRoom("亲，确定要离开房间吗?") end)
	end
end
function SettingPanelCtrl.toJieSan()
	TipsManager.loadDialog("申请解散房间", "你确定要申请解散房间？", this.doDissoliveRoomRequest, nil);
	this.CloseDialog();
end

function SettingPanelCtrl.toExit()
	ExitAppScript.OpenPanel(transform);
end
function SettingPanelCtrl.toLeaveRoom(des)
	TipsManager.loadDialog("提示", des, this.LeaveRoom, nil);
	this.Close();
end

function SettingPanelCtrl.Close()
	gameObject:SetActive(false);
end

function SettingPanelCtrl.LeaveRoom()
	local vo ={};
	vo.roomId = GlobalData.roomVo.roomId;
	local sendMsg = json.encode(vo);
	CustomSocket.getInstance():sendMsg(OutRoomRequest.New(sendMsg));
	gameObject:SetActive(false);
end
function SettingPanelCtrl.doDissoliveRoomRequest()
	local dissoliveRoomRequestVo = {};
	dissoliveRoomRequestVo.roomId = GlobalData.loginResponseData.roomId;
	dissoliveRoomRequestVo.type = "0";
	local sendMsg = json.encode(dissoliveRoomRequestVo);
	CustomSocket.getInstance():sendMsg(DissoliveRoomRequest.New(sendMsg));
	GlobalData.isonApplayExitRoomstatus = true;
end

-- 音乐音量
function SettingPanelCtrl.silderChange(value)
	PlayerPrefs.SetFloat("MusicVolume", value);
	soundMgr.MusicVolume = value
end
-- 音效音量
function SettingPanelCtrl.silder2Change(value)
	PlayerPrefs.SetFloat("EffectVolume", value);
	soundMgr.EffectVolume = value
end

function SettingPanelCtrl.CloseDialog()
	soundMgr:playSoundByActionButton(1);
	gameObject:SetActive(false);
end

function SettingPanelCtrl.setJingyin()
	sliderYinYue.value = 0;
	soundMgr.MusicVolume = 0
end

function SettingPanelCtrl.setMax()
	sliderYinYue.value = 1;
	soundMgr.MusicVolume = 1
	soundMgr:playSoundByActionButton(1);
end

function SettingPanelCtrl.setJingyin2()
	sliderYinXiao.value = 0;
	soundMgr.EffectVolume = 0
end
function SettingPanelCtrl.setMax2()
	sliderYinXiao.value = 1;
	soundMgr.EffectVolume = 1
	soundMgr:playSoundByActionButton(1);
end
