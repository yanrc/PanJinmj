
require "Common/define"
require "Common/protocal"
require "Common/functions"
Event = require 'events'

require "3rd/pblua/login_pb"
require "3rd/pbc/protobuf"

local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

Network = { };
local this = Network;

local transform;
local gameObject;
local islogging = false;

function Network.Start()
	logWarn("Network.Start!!");
	Event.AddListener(Protocal.Connect, this.OnConnect);
	Event.AddListener(Protocal.ConnectFail, this.OnConnectFail);
	Event.AddListener(Protocal.Message, this.OnMessage);
	Event.AddListener(Protocal.Exception, this.OnException);
	Event.AddListener(Protocal.Disconnect, this.OnDisconnect);
	Event.AddListener(Protocal.ChatConnect, this.OnChatConnect);
	Event.AddListener(Protocal.ChatMessage, this.OnChatMessage);
	Event.AddListener(Protocal.ChatException, this.OnChatException);
	Event.AddListener(Protocal.ChatDisconnect, this.OnChatDisconnect);
	Event.AddListener(Protocal.ChatConnectFail, this.ChatConnectFail);
end

-- Socket消息--
function Network.OnSocket(key, data)
	log(string.format("key=%#x,data=%s", key, data))
	Event.Brocast(tostring(key), data);
end
-- 发送心跳
function Network.Sendheart()
	while islogging do
		coroutine.wait(30)
		networkMgr:SendMessage(ClientRequest.New(APIS.head, ""));
	end
end
-- 当连接建立时--
function Network.OnConnect()
	logWarn("Game Server connected!!");
	islogging = true
	coroutine.start(this.Sendheart)
end
-- 当连接失败时，回到登录页--
function Network.OnConnectFail()
	logWarn("Game Server connect fail!!");
	OpenPanel(StartPanel)
end
-- 异常断线,重连--
function Network.OnException()
	logWarn("OnException------->>>>");
	islogging = false;
	coroutine.stop(this.Sendheart)
	networkMgr:SendConnect()
end

-- 连接中断，或者被踢掉，回到登录页--
function Network.OnDisconnect()
	logWarn("OnDisconnect------->>>>");
	islogging = false;
	coroutine.stop(this.Sendheart)
	OpenPanel(StartPanel)
end

-- 登录返回--
function Network.OnMessage(buffer)
--	if TestProtoType == ProtocalType.BINARY then
--		this.TestLoginBinary(buffer);
--	end
--	if TestProtoType == ProtocalType.PB_LUA then
--		this.TestLoginPblua(buffer);
--	end
--	if TestProtoType == ProtocalType.PBC then
--		this.TestLoginPbc(buffer);
--	end
--	if TestProtoType == ProtocalType.SPROTO then
--		this.TestLoginSproto(buffer);
--	end
--	----------------------------------------------------
--	local ctrl = CtrlManager.GetCtrl(CtrlNames.Message);
--	if ctrl ~= nil then
--		ctrl:Awake();
--	end
	logWarn('OnMessage-------->>>');
end
-- 当连接建立时--
function Network.OnChatConnect()
	logWarn("Chat Server connected!!");
	-- islogging = true
	-- coroutine.start(this.Sendheart)
end
-- 当连接失败时--
function Network.ChatConnectFail()
	logWarn("Game Server connect fail!!");
end
-- 异常断线--
function Network.OnChatException()
	-- islogging = false;
	-- -- NetManager:SendConnect();
	-- networkMgr:SendConnect()
	logWarn("OnChatException------->>>>");
end

-- 连接中断，或者被踢掉--
function Network.OnChatDisconnect()
	-- islogging = false;
	logWarn("OnChatDisconnect------->>>>");
end

-- 登录返回--
function Network.OnChatMessage(buffer)
	-- if TestProtoType == ProtocalType.BINARY then
	-- 	this.TestLoginBinary(buffer);
	-- end
	-- if TestProtoType == ProtocalType.PB_LUA then
	-- 	this.TestLoginPblua(buffer);
	-- end
	-- if TestProtoType == ProtocalType.PBC then
	-- 	this.TestLoginPbc(buffer);
	-- end
	-- if TestProtoType == ProtocalType.SPROTO then
	-- 	this.TestLoginSproto(buffer);
	-- end
	-- ----------------------------------------------------
	-- local ctrl = CtrlManager.GetCtrl(CtrlNames.Message);
	-- if ctrl ~= nil then
	-- 	ctrl:Awake();
	-- end
	logWarn('OnChatMessage-------->>>');
end
-- 二进制登录--
function Network.TestLoginBinary(buffer)
	local protocal = buffer:ReadByte();
	local str = buffer:ReadString();
	log('TestLoginBinary: protocal:>' .. protocal .. ' str:>' .. str);
end

-- PBLUA登录--
function Network.TestLoginPblua(buffer)
	local protocal = buffer:ReadByte();
	local data = buffer:ReadBuffer();

	local msg = login_pb.LoginResponse();
	msg:ParseFromString(data);
	log('TestLoginPblua: protocal:>' .. protocal .. ' msg:>' .. msg.id);
end

-- PBC登录--
function Network.TestLoginPbc(buffer)
	local protocal = buffer:ReadByte();
	local data = buffer:ReadBuffer();

	local path = Util.DataPath .. "lua/3rd/pbc/addressbook.pb";

	local addr = io.open(path, "rb")
	local buffer = addr:read "*a"
	addr:close()
	protobuf.register(buffer)
	local decode = protobuf.decode("tutorial.Person", data)

	print(decode.name)
	print(decode.id)
	for _, v in ipairs(decode.phone) do
		print("\t" .. v.number, v.type)
	end
	log('TestLoginPbc: protocal:>' .. protocal);
end

-- SPROTO登录--
function Network.TestLoginSproto(buffer)
	local protocal = buffer:ReadByte();
	local code = buffer:ReadBuffer();

	local sp = sproto.parse [[
							    .Person {
							        name 0 : string
							        id 1 : integer
							        email 2 : string

							        .PhoneNumber {
							            number 0 : string
							            type 1 : integer
							        }

							        phone 3 : *PhoneNumber
							    }

							    .AddressBook {
							        person 0 : *Person(id)
							        others 1 : *Person
							    }
							    ]]
	local addr = sp:decode("AddressBook", code)
	print_r(addr)
	log('TestLoginSproto: protocal:>' .. protocal);
end

-- 卸载网络监听--
function Network.Unload()
	Event.RemoveListener(Protocal.Connect);
	Event.RemoveListener(Protocal.Message);
	Event.RemoveListener(Protocal.Exception);
	Event.RemoveListener(Protocal.Disconnect);
	Event.RemoveListener(Protocal.ConnectFail);
	Event.RemoveListener(Protocal.ChatConnect);
	Event.RemoveListener(Protocal.ChatMessage);
	Event.RemoveListener(Protocal.ChatException);
	Event.RemoveListener(Protocal.ChatDisconnect);
	Event.RemoveListener(Protocal.ChatConnectFail);
	logWarn('Unload Network...');
end