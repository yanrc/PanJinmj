require"vos/APIS"
GameReadyRequest={}
--构造函数
function GameReadyRequest.New(data)
	local gameReadyRequest = ClientRequest.New();
	--setmetatable(gameReadyRequest, mt)
	gameReadyRequest.headCode = APIS.PrepareGame_MSG_REQUEST;
	--gameReadyRequest.messageContent='{'..data..'}'
	gameReadyRequest.messageContent=data
	log(gameReadyRequest.messageContent)
	return gameReadyRequest
end
