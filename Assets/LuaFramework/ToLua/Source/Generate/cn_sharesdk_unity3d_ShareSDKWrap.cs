﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class cn_sharesdk_unity3d_ShareSDKWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(cn.sharesdk.unity3d.ShareSDK), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("OnError", OnError);
		L.RegFunction("OnComplete", OnComplete);
		L.RegFunction("OnCancel", OnCancel);
		L.RegFunction("InitSDK", InitSDK);
		L.RegFunction("SetPlatformConfig", SetPlatformConfig);
		L.RegFunction("Authorize", Authorize);
		L.RegFunction("CancelAuthorize", CancelAuthorize);
		L.RegFunction("IsAuthorized", IsAuthorized);
		L.RegFunction("IsClientValid", IsClientValid);
		L.RegFunction("GetUserInfo", GetUserInfo);
		L.RegFunction("ShareContent", ShareContent);
		L.RegFunction("ShowPlatformList", ShowPlatformList);
		L.RegFunction("ShowShareContentEditor", ShowShareContentEditor);
		L.RegFunction("ShareWithContentName", ShareWithContentName);
		L.RegFunction("ShowPlatformListWithContentName", ShowPlatformListWithContentName);
		L.RegFunction("ShowShareContentEditorWithContentName", ShowShareContentEditorWithContentName);
		L.RegFunction("GetFriendList", GetFriendList);
		L.RegFunction("AddFriend", AddFriend);
		L.RegFunction("GetAuthInfo", GetAuthInfo);
		L.RegFunction("DisableSSO", DisableSSO);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("appKey", get_appKey, set_appKey);
		L.RegVar("devInfo", get_devInfo, set_devInfo);
		L.RegVar("shareSDKUtils", get_shareSDKUtils, set_shareSDKUtils);
		L.RegVar("authHandler", get_authHandler, set_authHandler);
		L.RegVar("shareHandler", get_shareHandler, set_shareHandler);
		L.RegVar("showUserHandler", get_showUserHandler, set_showUserHandler);
		L.RegVar("getFriendsHandler", get_getFriendsHandler, set_getFriendsHandler);
		L.RegVar("followFriendHandler", get_followFriendHandler, set_followFriendHandler);
		L.RegFunction("EventHandler", cn_sharesdk_unity3d_ShareSDK_EventHandler);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnError(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			cn.sharesdk.unity3d.PlatformType arg1 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 3, typeof(cn.sharesdk.unity3d.PlatformType));
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			System.Collections.Hashtable arg3 = (System.Collections.Hashtable)ToLua.CheckObject(L, 5, typeof(System.Collections.Hashtable));
			obj.OnError(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnComplete(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			cn.sharesdk.unity3d.PlatformType arg1 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 3, typeof(cn.sharesdk.unity3d.PlatformType));
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			System.Collections.Hashtable arg3 = (System.Collections.Hashtable)ToLua.CheckObject(L, 5, typeof(System.Collections.Hashtable));
			obj.OnComplete(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnCancel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			cn.sharesdk.unity3d.PlatformType arg1 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 3, typeof(cn.sharesdk.unity3d.PlatformType));
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			obj.OnCancel(arg0, arg1, arg2);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitSDK(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			string arg0 = ToLua.CheckString(L, 2);
			obj.InitSDK(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPlatformConfig(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			System.Collections.Hashtable arg0 = (System.Collections.Hashtable)ToLua.CheckObject(L, 2, typeof(System.Collections.Hashtable));
			obj.SetPlatformConfig(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Authorize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			int o = obj.Authorize(arg0);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CancelAuthorize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			obj.CancelAuthorize(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsAuthorized(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			bool o = obj.IsAuthorized(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsClientValid(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			bool o = obj.IsClientValid(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUserInfo(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			int o = obj.GetUserInfo(arg0);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareContent(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK), typeof(cn.sharesdk.unity3d.PlatformType[]), typeof(cn.sharesdk.unity3d.ShareContent)))
			{
				cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.ToObject(L, 1);
				cn.sharesdk.unity3d.PlatformType[] arg0 = ToLua.CheckObjectArray<cn.sharesdk.unity3d.PlatformType>(L, 2);
				cn.sharesdk.unity3d.ShareContent arg1 = (cn.sharesdk.unity3d.ShareContent)ToLua.ToObject(L, 3);
				int o = obj.ShareContent(arg0, arg1);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else if (count == 3 && TypeChecker.CheckTypes(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK), typeof(cn.sharesdk.unity3d.PlatformType), typeof(cn.sharesdk.unity3d.ShareContent)))
			{
				cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.ToObject(L, 1);
				cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.ToObject(L, 2);
				cn.sharesdk.unity3d.ShareContent arg1 = (cn.sharesdk.unity3d.ShareContent)ToLua.ToObject(L, 3);
				int o = obj.ShareContent(arg0, arg1);
				LuaDLL.lua_pushinteger(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: cn.sharesdk.unity3d.ShareSDK.ShareContent");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowPlatformList(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType[] arg0 = ToLua.CheckObjectArray<cn.sharesdk.unity3d.PlatformType>(L, 2);
			cn.sharesdk.unity3d.ShareContent arg1 = (cn.sharesdk.unity3d.ShareContent)ToLua.CheckObject(L, 3, typeof(cn.sharesdk.unity3d.ShareContent));
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 5);
			int o = obj.ShowPlatformList(arg0, arg1, arg2, arg3);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowShareContentEditor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			cn.sharesdk.unity3d.ShareContent arg1 = (cn.sharesdk.unity3d.ShareContent)ToLua.CheckObject(L, 3, typeof(cn.sharesdk.unity3d.ShareContent));
			int o = obj.ShowShareContentEditor(arg0, arg1);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShareWithContentName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			string arg1 = ToLua.CheckString(L, 3);
			System.Collections.Hashtable arg2 = (System.Collections.Hashtable)ToLua.CheckObject(L, 4, typeof(System.Collections.Hashtable));
			int o = obj.ShareWithContentName(arg0, arg1, arg2);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowPlatformListWithContentName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 6);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			string arg0 = ToLua.CheckString(L, 2);
			System.Collections.Hashtable arg1 = (System.Collections.Hashtable)ToLua.CheckObject(L, 3, typeof(System.Collections.Hashtable));
			cn.sharesdk.unity3d.PlatformType[] arg2 = ToLua.CheckObjectArray<cn.sharesdk.unity3d.PlatformType>(L, 4);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 5);
			int arg4 = (int)LuaDLL.luaL_checknumber(L, 6);
			int o = obj.ShowPlatformListWithContentName(arg0, arg1, arg2, arg3, arg4);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowShareContentEditorWithContentName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			string arg1 = ToLua.CheckString(L, 3);
			System.Collections.Hashtable arg2 = (System.Collections.Hashtable)ToLua.CheckObject(L, 4, typeof(System.Collections.Hashtable));
			int o = obj.ShowShareContentEditorWithContentName(arg0, arg1, arg2);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFriendList(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			int arg2 = (int)LuaDLL.luaL_checknumber(L, 4);
			int o = obj.GetFriendList(arg0, arg1, arg2);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddFriend(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			string arg1 = ToLua.CheckString(L, 3);
			int o = obj.AddFriend(arg0, arg1);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAuthInfo(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			cn.sharesdk.unity3d.PlatformType arg0 = (cn.sharesdk.unity3d.PlatformType)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.PlatformType));
			System.Collections.Hashtable o = obj.GetAuthInfo(arg0);
			ToLua.PushObject(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DisableSSO(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)ToLua.CheckObject(L, 1, typeof(cn.sharesdk.unity3d.ShareSDK));
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.DisableSSO(arg0);
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_appKey(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			string ret = obj.appKey;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index appKey on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_devInfo(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.DevInfoSet ret = obj.devInfo;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index devInfo on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_shareSDKUtils(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDKImpl ret = obj.shareSDKUtils;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index shareSDKUtils on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_authHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler ret = obj.authHandler;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index authHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_shareHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler ret = obj.shareHandler;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index shareHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_showUserHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler ret = obj.showUserHandler;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index showUserHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_getFriendsHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler ret = obj.getFriendsHandler;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index getFriendsHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_followFriendHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler ret = obj.followFriendHandler;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index followFriendHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_appKey(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.appKey = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index appKey on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_devInfo(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.DevInfoSet arg0 = (cn.sharesdk.unity3d.DevInfoSet)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.DevInfoSet));
			obj.devInfo = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index devInfo on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_shareSDKUtils(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDKImpl arg0 = (cn.sharesdk.unity3d.ShareSDKImpl)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDKImpl));
			obj.shareSDKUtils = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index shareSDKUtils on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_authHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (cn.sharesdk.unity3d.ShareSDK.EventHandler)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func) as cn.sharesdk.unity3d.ShareSDK.EventHandler;
			}

			obj.authHandler = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index authHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_shareHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (cn.sharesdk.unity3d.ShareSDK.EventHandler)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func) as cn.sharesdk.unity3d.ShareSDK.EventHandler;
			}

			obj.shareHandler = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index shareHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_showUserHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (cn.sharesdk.unity3d.ShareSDK.EventHandler)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func) as cn.sharesdk.unity3d.ShareSDK.EventHandler;
			}

			obj.showUserHandler = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index showUserHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_getFriendsHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (cn.sharesdk.unity3d.ShareSDK.EventHandler)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func) as cn.sharesdk.unity3d.ShareSDK.EventHandler;
			}

			obj.getFriendsHandler = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index getFriendsHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_followFriendHandler(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			cn.sharesdk.unity3d.ShareSDK obj = (cn.sharesdk.unity3d.ShareSDK)o;
			cn.sharesdk.unity3d.ShareSDK.EventHandler arg0 = null;
			LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

			if (funcType2 != LuaTypes.LUA_TFUNCTION)
			{
				 arg0 = (cn.sharesdk.unity3d.ShareSDK.EventHandler)ToLua.CheckObject(L, 2, typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler));
			}
			else
			{
				LuaFunction func = ToLua.ToLuaFunction(L, 2);
				arg0 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func) as cn.sharesdk.unity3d.ShareSDK.EventHandler;
			}

			obj.followFriendHandler = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index followFriendHandler on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int cn_sharesdk_unity3d_ShareSDK_EventHandler(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateFactory.CreateDelegate(typeof(cn.sharesdk.unity3d.ShareSDK.EventHandler), func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

