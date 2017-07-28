MicPhone = { }
local this = MicPhone

-- 录音的图标对象
local InputObj
-- 最大录音时间
local MaxTime = 10
local btnDown = false
local Slider
local avatarList
local micArray
local audio
function MicPhone.OnCreate(obj)
	InputObj = obj.transform:FindChild('Micphone/MicBg').gameObject
	Slider = obj.transform:FindChild('Micphone/MicBg/FillWrite'):GetComponent('Slider')
	micArray = Microphone.devices;
	audio = obj.transform:FindChild('Micphone'):GetComponent('AudioSource')
end

function MicPhone.OnPointerDown()
	soundMgr:playBGM(0);
	xpcall( function()
		log(Test.DumpTab(avatarList))
		if (avatarList ~= nil and #avatarList > 1) then
			btnDown = true;
			InputObj:SetActive(true);
			this.StartRecord();
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
		this.StopRecord();

		GamePanel.MyselfSoundActionPlay();
	end
	coroutine.start( function()
		coroutine.wait(5)
		soundMgr:playBGM(2);
	end )
	MaxTime = 10
end

function MicPhone.StartRecord()
	audio:Stop();
	if micArray.Length == 0 then
		log("No Record Device!");
		return;
	end
	audio.loop = false;
	audio.mute = true;
	audio.clip = Microphone.Start("inputMicro", false, 10, 8000);
	while (not(Microphone.GetPosition(nil) > 0)) do
	end
	audio:Play();
	log("StartRecord");
end

function MicPhone.StopRecord()
	if (micArray.Length == 0) then
		log("No Record Device!");
		return;
	end
	if (not Microphone.IsRecording(nil)) then
		return;
	end
	Microphone.End(nil);
	audio:Stop();
	local myuuid=GlobalData.loginResponseData.account.uuid
	networkMgr:SendChatMessage(ChatRequest.New(APIS.MicInput_Request, this.GetUserList(), myuuid, MicroPhoneInput.getInstance():GetClipData()))
	this.PlayRecord();
end

function MicPhone.PlayRecord()
	if (audio.clip == nil) then
		log("audio.clip=null");
		return;
	end
	audio.mute = false;
	audio.loop = false;
	audio:Play();
end

function MicPhone.GetUserList()
	local userList = { }
	for i = 1, #avatarList do
		if (avatarList[i].account.uuid ~= GlobalData.loginResponseData.account.uuid) then
			table.insert(userList, avatarList[i].account.uuid)
		end
	end
	return userList;
end

		
function MicPhone.MicInputNotice(data)
	if (soundMgr.EffectVolume > 0) then
		MicroPhoneInput.getInstance():PlayClipData(data);
	end
end

function MicPhone.OnOpen(avatars)
	avatarList = avatars
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