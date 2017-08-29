LoginVo=
{
openId="";

nickName="";

headIcon="";

unionid="";

province="";

city="";

sex=0;

IP="";

}
local mt = {}--元表（基类）
mt.__index = LoginVo--index方法
--构造函数
function LoginVo.New()
	local loginvo = {}
	setmetatable(loginvo, mt)
	return loginvo
end