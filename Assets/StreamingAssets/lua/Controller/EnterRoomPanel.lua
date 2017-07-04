
EnterRoomPanel = UIBase(define.EnterRoomPanel, define.PopUI)
local this = EnterRoomPanel;

local transform;
local gameObject;
local inputChars
local btnList


-- 启动事件--
function EnterRoomPanel.OnCreate(obj)
	gameObject = obj;
	transform = obj.transform
	this:Init(obj)
	btnList = { }
	btnList[1] = transform:FindChild("GameObject/Button_0").gameObject
	btnList[2] = transform:FindChild("GameObject/Button_1").gameObject
	btnList[3] = transform:FindChild("GameObject/Button_2").gameObject
	btnList[4] = transform:FindChild("GameObject/Button_3").gameObject
	btnList[5] = transform:FindChild("GameObject/Button_4").gameObject
	btnList[6] = transform:FindChild("GameObject/Button_5").gameObject
	btnList[7] = transform:FindChild("GameObject/Button_6").gameObject
	btnList[8] = transform:FindChild("GameObject/Button_7").gameObject
	btnList[9] = transform:FindChild("GameObject/Button_8").gameObject
	btnList[10] = transform:FindChild("GameObject/Button_9").gameObject
	local btnClear = transform:FindChild("GameObject/Button_Clear").gameObject
	local btnDelete = transform:FindChild("GameObject/Button_Delete").gameObject
	local btnClose = transform:FindChild("Image_Enter_Room_Bg/Button_Close").gameObject
	for i = 1, #btnList do
		local gobj = btnList[i];
		this.lua:AddClick(btnList[i], this.OnClickHandle, i - 1)
	end
	this.lua:AddClick(btnClear, this.Clear)
	this.lua:AddClick(btnDelete, this.DeleteNumber)
	this.lua:AddClick(btnClose, this.CloseClick)
	inputTexts = { }
	inputTexts[1] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_0"):GetComponent("Text")
	inputTexts[2] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_1"):GetComponent("Text")
	inputTexts[3] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_2"):GetComponent("Text")
	inputTexts[4] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_3"):GetComponent("Text")
	inputTexts[5] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_4"):GetComponent("Text")
	inputTexts[6] = transform:FindChild("Image_Enter_Room_Bg/Text_Nmber_5"):GetComponent("Text")
	logWarn("Start lua--->>" .. gameObject.name);
end



-- 数字按钮点击
function EnterRoomPanel.OnClickHandle(go, number)
	this.Number(number);
end

function EnterRoomPanel.Number(number)
	soundMgr:playSoundByActionButton(1);
	if (#inputChars >= 6) then
		return;
	end
	table.insert(inputChars, number)
	local index = #inputChars
	inputTexts[index].text = tostring(number)
	-- 最后一位数字赋值
	if (index == #inputTexts) then
		this.SureRoomNumber();
		-- 确定加入房间
	end
end

function EnterRoomPanel.Clear()
	soundMgr:playSoundByActionButton(1);
	inputChars = { }
	for i = 1, #inputTexts do
		inputTexts[i].text = "";
	end
end


function EnterRoomPanel.DeleteNumber()
	soundMgr:playSoundByActionButton(1);
	if (inputChars ~= nil and #inputChars > 0) then
		inputTexts[#inputChars].text = "";
		table.remove(inputChars)
	end
end

function EnterRoomPanel.SureRoomNumber()
	if (#inputChars ~= 6) then
		TipsManager.SetTips("请先完整输入房间号码！");
		return;
	end
	OpenPanel(WaitingPanel, "正在进入房间")
	local roomNumber = inputChars[1] .. inputChars[2] .. inputChars[3] .. inputChars[4] .. inputChars[5] .. inputChars[6];
	local roomJoinVo = { };
	roomJoinVo.roomId = tonumber(roomNumber);
	local sendMsg = json.encode(roomJoinVo);
	coroutine.start(this.ConnectTime, 4)
	networkMgr:SendMessage(ClientRequest.New(APIS.JOIN_ROOM_REQUEST, sendMsg));

end
function EnterRoomPanel.ServiceErrorNotice(response)
	this.Clear();
end
local connectRetruen = false;

function EnterRoomPanel.ConnectTime(time)
	connectRetruen = false;
	coroutine.wait(time)
	if (not connectRetruen) then
		-- 超过5秒还没连接成功显示失败
		connectRetruen = true;
		ClosePanel(WaitingPanel)
	end
end
-- 房间不存在时不会收到这个回调，而是返回错误消息
function EnterRoomPanel.OnJoinRoomCallBack(response)
	ClosePanel(WaitingPanel)
	if (response.status == 1) then
		local message = json.decode(response.message)
		GlobalData.roomJoinResponseData = message
		log("Lua:OnJoinRoomCallBack=" .. response.message)
		GlobalData.roomVo.addWordCard = message.addWordCard;
		GlobalData.roomVo.hong = message.hong;
		GlobalData.roomVo.ma = message.ma;
		GlobalData.roomVo.name = message.name;
		GlobalData.roomVo.roomId = message.roomId;
		GlobalData.roomVo.roomType = message.roomType;
		GlobalData.roomVo.roundNumber = message.roundNumber;
		GlobalData.roomVo.sevenDouble = message.sevenDouble;
		GlobalData.roomVo.xiaYu = message.xiaYu;
		GlobalData.roomVo.ziMo = message.ziMo;
		GlobalData.roomVo.gangHu = message.gangHu;
		GlobalData.roomVo.guiPai = message.guiPai;
		GlobalData.roomVo.pingHu = message.pingHu;
		GlobalData.roomVo.jue = message.jue;
		GlobalData.roomVo.baoSanJia = message.baoSanJia;
		GlobalData.roomVo.jiaGang = message.jiaGang;
		GlobalData.roomVo.gui = message.gui;
		GlobalData.roomVo.duanMen = message.duanMen;
		GlobalData.roomVo.jihu = message.jihu;
		GlobalData.roomVo.qingYiSe = message.qingYiSe;
		GlobalData.roomVo.menqing = message.menqing;
		GlobalData.roomVo.siguiyi = message.siguiyi;
		GlobalData.surplusTimes = message.roundNumber;
		GlobalData.loginResponseData.roomId = message.roomId;
		GlobalData.reEnterRoomData = nil;
		OpenPanel(GamePanel)
		connectRetruen = true;
		ClosePanel(this)
		GlobalData.roomVo.jiaGang = message.jiaGang;
		GlobalData.roomVo.duanMen = message.duanMen;
	else
		this.Clear();
		TipsManager.SetTips(response.message);
	end
end
-------------------模板-------------------------
function EnterRoomPanel.CloseClick()
	ClosePanel(this)
end

function EnterRoomPanel.OnOpen()
	inputChars = { }
end
-- 移除事件--
function EnterRoomPanel.RemoveListener()
	Event.RemoveListener(tostring(APIS.JOIN_ROOM_RESPONSE), this.OnJoinRoomCallBack)
	Event.RemoveListener(tostring(APIS.ERROR_RESPONSE), this.ServiceErrorNotice)
end

-- 增加事件--
function EnterRoomPanel.AddListener()
	Event.AddListener(tostring(APIS.ERROR_RESPONSE), this.ServiceErrorNotice)
	Event.AddListener(tostring(APIS.JOIN_ROOM_RESPONSE), this.OnJoinRoomCallBack)
end

