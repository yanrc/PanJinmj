require"vos/APIS"
PengCardRequest={}
--¹¹Ôìº¯Êý
function PengCardRequest.New(data)
	local pengCardRequest = ClientRequest.New();
	--setmetatable(pengCardRequest, mt)
	pengCardRequest.headCode = APIS.PENGPAI_REQUEST;
	--pengCardRequest.messageContent='{'..data..'}'
	pengCardRequest.messageContent=data
	log(pengCardRequest.messageContent)
	return pengCardRequest
end
