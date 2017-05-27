require"vos/APIS"
MobanRequest={}
--构造函数
function MobanRequest.New(data)
	local mobanRequest = ClientRequest.New();
	--setmetatable(mobanRequest, mt)
	mobanRequest.headCode = APIS.XXXX;
	--mobanRequest.messageContent='{'..data..'}'
	mobanRequest.messageContent=data
	log("lua:mobanRequest="..mobanRequest.messageContent)
	return mobanRequest
end
