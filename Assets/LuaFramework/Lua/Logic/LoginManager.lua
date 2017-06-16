local json = require "cjson"
require "vos/AvatarVO"
require "vos/Account"
require "vos/LoginRequest"
--管理器--
LoginManager = {};
local this = LoginManager;
--构建函数--
function LoginManager.Instance()
	return this;
end

function LoginManager.TestLogin(prefabs)
	local go=newObject(prefabs[0]);
	go.transform.parent=StartPanel.transform.parent;
	go.transform.localScale = Vector3.one;
	go.transform:SetAsLastSibling();
	go:GetComponent("RectTransform").offsetMax =Vector2.zero;
	go:GetComponent("RectTransform").offsetMin = Vector2.zero;
	local button=go.transform:FindChild("Button"):GetComponent("Button").gameObject;
	StartPanelCtrl.lua:AddClick(button,this.TestLoginClick)
	this.dropdown=go.transform:FindChild("Dropdown"):GetComponent("Dropdown");
	this.go=go;
end
--UUID,OPENID,NICKNAME
local testInfo = { {"100000","16669993331","123122for212231"},
{"102516","16669993332","123122for212232"},
{"102517","16669993333","123122for212233"},
{"102518","16669993334","123122for212234"},
{"102519","1666333","111112322444"},
{"102520","oPnbKvg8SYnhYrtzobu0WH3yKasw","农村在家待业人员汪某"},
{"102521","oxVwqwgQ3o9LDIocaK_0NLUhE-Hg","赖皮猴"},
{"102522","oxVwqwlZfhqyppxtO54LpiU4Iyw4","自动小喇叭"},
{"102523","5555","5555for5555"},
{"102524","6666","6666for6666"},
{"102525","7777","7777"},
{"102526","8888","888for888"},
{"102527","oPnbKvkDstqfsraFbh-s8mJzJmxA","彬彬有礼"},
{"102528","oPnbKvru9DZMoKthchWcTBHe-CoA","张志国"}
};

function LoginManager.TestLoginClick()
	local loginvo = LoginVo.New();
	--local str = math.random(100, 1000) .. "for" .. math.random(2000, 5000);
	local value =this.dropdown.value;
	loginvo.openId = testInfo[value+1][2];--openid
	loginvo.nickName = testInfo[value+1][3];--nickname
	loginvo.headIcon = "imgico221";
	loginvo.unionid = testInfo[value+1][1];--uuid
	loginvo.province = "21sfsd";
	loginvo.city = "afafsdf";
	loginvo.sex = 1;
	loginvo.IP = GlobalData.GetIpAddress();
	local data = json.encode(loginvo);
	GlobalData.loginVo = loginvo;
	GlobalData.loginResponseData = AvatarVO.New();
	GlobalData.loginResponseData.account =Account.New();
	GlobalData.loginResponseData.account.city = loginvo.city;
	GlobalData.loginResponseData.account.openid = loginvo.openId;
	GlobalData.loginResponseData.account.nickname = loginvo.nickName;
	GlobalData.loginResponseData.account.headicon = loginvo.headIcon;
	GlobalData.loginResponseData.account.unionid = loginvo.city;
	GlobalData.loginResponseData.account.sex = loginvo.sex;
	GlobalData.loginResponseData.IP = loginvo.IP;
	CustomSocket.getInstance():sendMsg(LoginRequest.New(data));
	destroy(this.go);
end

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
local mt = {}
mt.__index = LoginVo
function LoginVo.New()
	local loginvo = {}
	setmetatable(loginvo, mt)	
	return loginvo
end