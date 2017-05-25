require"vos/APIS"
local json = require "cjson"
GangCardRequest={}
--¹¹Ôìº¯Êý
function GangCardRequest.New(cardPoint,gangType)
			local GangRequestVO={}
		GangRequestVO.cardPoint=cardPoint
		 GangRequestVO.gangType = gangType;
	local gangCardRequest = ClientRequest.New();
	--setmetatable(gangCardRequest, mt)
	gangCardRequest.headCode = APIS.GANGPAI_REQUEST;
	--gangCardRequest.messageContent='{'..data..'}'
	gangCardRequest.messageContent=json.encode(GangRequestVO)
	log(gangCardRequest.messageContent)
	return gangCardRequest
end