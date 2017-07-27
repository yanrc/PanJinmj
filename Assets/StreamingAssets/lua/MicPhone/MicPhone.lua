MicPhone = { }
local this = MicPhone

-- 录音的图标对象
local InputObj
-- 最大录音时间
local MaxTime = 10
local btnDown = false
local Slider
local avatarList
function MicPhone.OnCreate(obj)
	InputObj=obj.transform:FindChild('Micphone/MicBg').gameObject
	Slider=obj.transform:FindChild('Micphone/MicBg/FillWrite'):GetComponent('Slider')
end

function MicPhone.OnPointerDown()
	soundMgr:playBGM(0);
	xpcall( function()
		if (avatarList ~= nil and #avatarList > 1) then
			btnDown = true;
			InputObj:SetActive(true);
			MicroPhoneInput.getInstance():StartRecord();
		else
			TipsManager.SetTips("房间里只有你一个人，不能发送语音");
			soundMgr:playBGM(2);
		end
	end , function(e)
		log(e)
		TipsManager.SetTips("您的设备不支持录音功能");
	end )
end

function MicPhone.OnPointerUp()
	btnDown = false;
	InputObj:SetActive(false);
	if (avatarList ~= nil and #avatarList > 1) then
		if MaxTime > 9 then
			soundMgr:playBGM(2);
			TipsManager.SetTips("录音时间太短哦");
			return;
		end
		MicroPhoneInput.getInstance():StopRecord();
		networkMgr:SendChatMessage(ChatRequest.New(APIS.MicInput_Request, this.GetUserList(), nil, MicroPhoneInput.getInstance():GetClipData()))
		GamePanel.MyselfSoundActionPlay();
	end
	coroutine.start( function()
		coroutine.wait(5)
		soundMgr:playBGM(2);
	end )
end

function MicPhone.GetUserList()
	local userList = { }
	for i = 1, #avatarList do
		if (avatarList[i].account.uuid ~= GlobalData.loginResponseData.account.uuid) then
			userList.Add(myScript.avatarList[i].account.uuid);
		end
	end
	return userList;
end

		
function MicPhone.MicInputNotice(data)
	if (soundMgr.EffectVolume > 0) then
		MicroPhoneInput.getInstance():PlayClipData(data);
	end
end

function MicPhone.OnOpen(list)
	avatarList = list
end

function MicPhone.FixedUpdate()
	if (btnDown) then
		MaxTime = MaxTime - Time.deltaTime;
		Slider.value = MaxTime;
		if (MaxTime <= 0) then
			this.OnPointerUp()
		end
	end
end