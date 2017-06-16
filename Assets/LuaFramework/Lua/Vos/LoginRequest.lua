require"vos/APIS"
LoginRequest={}
--构造函数
function LoginRequest.New(data)
	local loginrequest = ClientRequest.New();
	--setmetatable(loginrequest, mt)
	loginrequest.headCode = APIS.LOGIN_REQUEST;
	--loginrequest.messageContent='{'..data..'}'
	loginrequest.messageContent=data
	log("lua:loginrequest="..loginrequest.messageContent)
	return loginrequest
end
ExitRequest={}
--构造函数
function ExitRequest.New()
	local exitrequest = ClientRequest.New();
	exitrequest.headCode = APIS.QUITE_LOGIN;
	if (GlobalData.loginResponseData ~= nil) then
		exitrequest.messageContent =tostring(GlobalData.loginResponseData.account.uuid);
		return exitrequest
	end
end