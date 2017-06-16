require"vos/APIS"
CurrentStatusRequest={}
--构造函数
function CurrentStatusRequest.New(data)
	local currentStatusRequest = ClientRequest.New();
	--setmetatable(currentStatusRequest, mt)
	currentStatusRequest.headCode = APIS.REQUEST_CURRENT_DATA;
	--currentStatusRequest.messageContent='{'..data..'}'
	currentStatusRequest.messageContent=data
	log("lua:currentStatusRequest="..currentStatusRequest.messageContent)
	return currentStatusRequest
end
