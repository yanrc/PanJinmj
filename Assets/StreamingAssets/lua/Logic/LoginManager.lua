
-- 管理器--
LoginManager = { };
local this = LoginManager;
-- 构建函数--
function LoginManager.Instance()
	return this;
end

function LoginManager.TestLogin(prefabs)
	local go = newObject(prefabs[0]);
	go.transform.parent = StartPanel.transform.parent;
	go.transform.localScale = Vector3.one;
	go.transform:SetAsLastSibling();
	go:GetComponent("RectTransform").offsetMax = Vector2.zero;
	go:GetComponent("RectTransform").offsetMin = Vector2.zero;
	local button = go.transform:Find("Button"):GetComponent("Button").gameObject;
	StartPanel.lua:AddClick(button, this.TestLoginClick)
	this.dropdown = go.transform:Find("Dropdown"):GetComponent("Dropdown");
	this.go = go;
end
-- UUID,OPENID,NICKNAME
local testInfo = {
	{ "100000", "16669993331", "test1" },
	{ "102516", "16669993332", "test2" },
	{ "102517", "16669993333", "test3" },
	{ "102518", "16669993334", "test4" },
	{ "102519", "16669993335", "test5" },
	{ "102520", "oPnbKvg8SYnhYrtzobu0WH3yKasw", "农村在家待业人员汪某" },
	{ "102521", "oxVwqwgQ3o9LDIocaK_0NLUhE-Hg", "赖皮猴" },
	{ "102522", "oxVwqwlZfhqyppxtO54LpiU4Iyw4", "自动小喇叭" },
	{ "102523", "5555", "5555for5555" },
	{ "102524", "6666", "6666for6666" },
	{ "102525", "7777", "7777" },
	{ "102526", "8888", "888for888" },
	{ "102527", "oPnbKvkDstqfsraFbh-s8mJzJmxA", "彬彬有礼" },
	{ "102528", "oPnbKvru9DZMoKthchWcTBHe-CoA", "张志国" }
};

function LoginManager.TestLoginClick()
	local loginvo = LoginVo.New();
	-- local str = math.random(100, 1000) .. "for" .. math.random(2000, 5000);
	local value = this.dropdown.value;
	loginvo.openId = testInfo[value + 1][2];
	-- openid
	loginvo.nickName = testInfo[value + 1][3];
	-- nickname
	loginvo.headIcon = "imgico221";
	loginvo.unionid = testInfo[value + 1][1];
	-- uuid
	loginvo.province = "21sfsd";
	loginvo.city = "afafsdf";
	loginvo.sex = 1;
	coroutine.start(CoMgr.GetIpAddress, function(IPstr)
		loginvo.IP = IPstr;
		local data = json.encode(loginvo);
		LoginData = AvatarVO.New();
		LoginData.account = Account.New();
		LoginData.account.openid = loginvo.openId;
--		LoginData.account.city = loginvo.city;
--		LoginData.account.nickname = loginvo.nickName;
--		LoginData.account.headicon = loginvo.headIcon;
--		LoginData.account.unionid = loginvo.unionid;
--		LoginData.account.sex = loginvo.sex;
--		LoginData.IP = loginvo.IP;
		networkMgr:SendMessage(ClientRequest.New(APIS.LOGIN_REQUEST, data));
	end )
	destroy(this.go);
end

LoginVo =
{
	openId = "";
	nickName = "";
	headIcon = "";
	unionid = "";
	province = "";
	city = "";
	sex = 0;
	IP = "";
}
local mt = { }
mt.__index = LoginVo
function LoginVo.New()
	local loginvo = { }
	setmetatable(loginvo, mt)
	return loginvo
end