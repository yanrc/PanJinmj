Account={
openid="";

nickname="";

headicon="";

unionid="";

province="";

city="";

sex=0;

roomcard=0;

uuid=0;

prizecount=0;

actualcard=0;
createtime=nil;
id=0;
lastlogintime=nil;
managerUpId=0;
totalcard=0;
status="";
isGame="";
}
local mt = {}--元表（基类）
mt.__index = Account--index方法
--构造函数
function Account.New()
	local account = {}
	setmetatable(account, mt)
	return account
end