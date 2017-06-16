require"vos/APIS"
DissoliveRoomRequest={}
--构造函数
function DissoliveRoomRequest.New(data)
	local dissoliveRoomRequest = ClientRequest.New();
	--setmetatable(mobanRequest, mt)
	dissoliveRoomRequest.headCode = APIS.DISSOLIVE_ROOM_REQUEST;
	--mobanRequest.messageContent='{'..data..'}'
	dissoliveRoomRequest.messageContent=data
	log("lua:mobanRequest="..dissoliveRoomRequest.messageContent)
	return dissoliveRoomRequest
end
