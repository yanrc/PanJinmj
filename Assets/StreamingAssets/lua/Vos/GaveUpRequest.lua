require"vos/APIS"
GaveUpRequest={}
--¹¹Ôìº¯Êý
function GaveUpRequest.New(data)
	local gaveUpRequest = ClientRequest.New();
	--setmetatable(gaveUpRequest, mt)
	gaveUpRequest.headCode = APIS.GAVEUP_REQUEST;
	--gaveUpRequest.messageContent='{'..data..'}'
	gaveUpRequest.messageContent=data
	log("lua:gaveUpRequest="..gaveUpRequest.messageContent)
	return gaveUpRequest
end