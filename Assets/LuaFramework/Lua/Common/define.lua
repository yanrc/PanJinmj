
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
PlayerPrefs=UnityEngine.PlayerPrefs
ToggleGroup=UnityEngine.UI.ToggleGroup
AndroidJavaClass=UnityEngine.AndroidJavaClass
RuntimePlatform=UnityEngine.RuntimePlatform
AndroidJavaObject=UnityEngine.AndroidJavaObject
Microphone=UnityEngine.Microphone

List_int=System.Collections.Generic.List_int
DateTime=System.DateTime

ChatRequest=AssemblyCSharp.ChatRequest
ChatSocket=AssemblyCSharp.ChatSocket
ClientRequest=AssemblyCSharp.ClientRequest
ClientResponse=AssemblyCSharp.ClientResponse
HeadRequest=AssemblyCSharp.HeadRequest
GameToolScript=AssemblyCSharp.GameToolScript

PlatformType=cn.sharesdk.unity3d.PlatformType
ShareContent=cn.sharesdk.unity3d.ShareContent


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


--定义字符串
define={}
define.PanelsInited="PanelsInited"

define.FixUI="FixUI"
define.PopUI="PopUI"

define.Panels={}
define.Panels.CreateRoomPanel="CreateRoomPanel"
define.Panels.DialogPanel="DialogPanel"
define.Panels.EnterRoomPanel="EnterRoomPanel"
define.Panels.ExitPanel="ExitPanel"
define.Panels.GamePanel="GamePanel"
define.Panels.HomePanel="HomePanel"
define.Panels.SettingPanel="SettingPanel"
define.Panels.StartPanel="StartPanel"
define.Panels.VotePanel="VotePanel"
define.Panels.WaitingPanel="WaitingPanel"
define.Panels.GameOverPanel="GameOverPanel"
define.Panels.UserInfoPanel="UserInfoPanel"
define.Panels.MessagePanel="MessagePanel"
define.Panels.RulePanel="RulePanel"
define.Panels.ShopPanel="ShopPanel"
define.Panels.SharePanel="SharePanel"
define.Panels.InviteCodePanel="InviteCodePanel"