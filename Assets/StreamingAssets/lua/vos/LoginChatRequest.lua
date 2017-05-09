require"vos/APIS"
LoginChatRequest={}
--¹¹Ôìº¯Êý
function LoginChatRequest.New(userId)
	local loginChatRequest = ChatRequest.New();
	loginChatRequest.headCode = APIS.LoginChat_Request;
	loginChatRequest.userList=List_int.New();
	loginChatRequest.userList:Add (userId);
	return loginChatRequest
end
