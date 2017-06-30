
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
PanelManager = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;

--our project
Application=UnityEngine.Application
Input=UnityEngine.Input
KeyCode=UnityEngine.KeyCode
List_int=System.Collections.Generic.List_int
PlayerPrefs=UnityEngine.PlayerPrefs

ChatRequest=AssemblyCSharp.ChatRequest
ChatSocket=AssemblyCSharp.ChatSocket
ClientRequest=AssemblyCSharp.ClientRequest
ClientResponse=AssemblyCSharp.ClientResponse
HeadRequest=AssemblyCSharp.HeadRequest
GameToolScript=AssemblyCSharp.GameToolScript
PlatformType=cn.sharesdk.unity3d.PlatformType
GameConfig={}
GameConfig.GAME_TYPE_ZHUANZHUAN = 1;
GameConfig.GAME_TYPE_HUASHUI = 2;
GameConfig.GAME_TYPE_CHANGSHA = 3;
GameConfig.GAME_TYPE_GUANGDONG = 4;
GameConfig.GAME_TYPE_PANJIN = 5;
GameConfig.GAME_TYPE_TUIDAO = 6;
GameConfig.GAME_TYPE_SHUANGLIAO = 7;
GameConfig.GAME_TYPE_JIUJIANG=8

--Unity的几个宏命令
UNITY_ANDROID=AppConst.UNITY_ANDROID;
UNITY_IPHONE=AppConst.UNITY_IPHONE;
UNITY_STANDALONE_WIN=AppConst.UNITY_STANDALONE_WIN;
UNITY_EDITOR=AppConst.UNITY_EDITOR;