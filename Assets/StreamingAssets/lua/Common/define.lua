
CtrlNames = {
	
}

PanelNames = {
	
}

--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}
--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;


--our project
CustomSocket=AssemblyCSharp.CustomSocket
ChatRequest=AssemblyCSharp.ChatRequest
ChatSocket=AssemblyCSharp.ChatSocket
ClientRequest=AssemblyCSharp.ClientRequest
ClientResponse=AssemblyCSharp.ClientResponse
CustomSocket=AssemblyCSharp.CustomSocket
SocketEventHandle=AssemblyCSharp.SocketEventHandle
HeadRequest=AssemblyCSharp.HeadRequest
GameToolScript=AssemblyCSharp.GameToolScript
PlatformType=cn.sharesdk.unity3d.PlatformType