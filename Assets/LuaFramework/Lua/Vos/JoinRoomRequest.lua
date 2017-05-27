require"vos/APIS"
JoinRoomRequest={}
--构造函数
function JoinRoomRequest.New(data)
	local joinRoomRequest = ClientRequest.New();
	--setmetatable(joinRoomRequest, mt)
	joinRoomRequest.headCode = APIS.JOIN_ROOM_REQUEST;
	--joinRoomRequest.messageContent='{'..data..'}'
	joinRoomRequest.messageContent=data
	log("lua:joinRoomRequest="..joinRoomRequest.messageContent)
	return joinRoomRequest
end