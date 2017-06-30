
GangCardRequest = { }
-- ¹¹Ôìº¯Êý
function GangCardRequest.New(cardPoint, gangType)
	local GangRequestVO = { }
	GangRequestVO.cardPoint = cardPoint
	GangRequestVO.gangType = gangType;
	local gangCardRequest = ClientRequest.New(APIS.GANGPAI_REQUEST, json.encode(GangRequestVO));
	return gangCardRequest
end