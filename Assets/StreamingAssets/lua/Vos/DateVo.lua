DateVo=
{
date=0;
day=0;
hours=0;
minutes=0;
month=0;
seconds=0;
time=0;
timezoneOffset=0;
year=0;
}
local mt = {}--元表（基类）
mt.__index = DateVo--index方法
--构造函数
function DateVo.New()
	local datevo = {}
	setmetatable(datevo, mt)
	return datevo
end