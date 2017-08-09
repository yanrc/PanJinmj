--玩家类
AvatarVO=
{
account={};--json生成AvatarVO类时也新生成了Account类，其中包含了玩家的头像地址
--public int cardIndex;
isOnLine=false;
isReady=false;
--庄家
main=false;
roomId=0;
chiPaiArray;--吃牌二维数组
chupais;--出牌数组
commonCards=0;--剩余牌数
paiArray;--手牌二维数组
huReturnObjectVO={};--胡牌才有数据，登录过程不管
scores=0;--分数
IP="";
tingPai=false
}
local mt = {}--元表（基类）
mt.__index = AvatarVO--index方法
--构造函数
function AvatarVO.New(avatarvo)
local avatarvo =avatarvo or {}
	setmetatable(avatarvo, mt)
	return avatarvo
end
--清除每局的临时数据
function AvatarVO:ResetData()
	self.isOnLine = false;
	self.isReady = false;
	self.main = false;
	self.tingPai = false;
end