require"vos/APIS"
CreateRoomRequest={}
--构造函数
function CreateRoomRequest.New(data)
	local createRoomRequest = ClientRequest.New();
	--setmetatable(createRoomRequest, mt)
	createRoomRequest.headCode = APIS.CREATEROOM_REQUEST;
	--createRoomRequest.messageContent='{'..data..'}'
	createRoomRequest.messageContent=data
	log(createRoomRequest.messageContent)
	return createRoomRequest
end