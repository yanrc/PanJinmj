SocketEventHandle = { }
local this = SocketEventHandle;
local isDisconnet = false;
function SocketEventHandle.Start()
	FixedUpdateBeat:Add(this.FixedUpdate);
end
function SocketEventHandle.FixedUpdate()

	if (isDisconnet) then
		isDisconnet = false;
		Event.Brocast(Protocal.Exception)
	end
end

function SocketEventHandle.NoticeDisConect()
	isDisconnet = true;
end
