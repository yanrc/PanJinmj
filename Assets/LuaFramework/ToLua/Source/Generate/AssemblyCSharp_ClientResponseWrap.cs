﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class AssemblyCSharp_ClientResponseWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(AssemblyCSharp.ClientResponse), typeof(System.Object));
		L.RegFunction("New", _CreateAssemblyCSharp_ClientResponse);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("status", get_status, set_status);
		L.RegVar("message", get_message, set_message);
		L.RegVar("headCode", get_headCode, set_headCode);
		L.RegVar("bytes", get_bytes, set_bytes);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateAssemblyCSharp_ClientResponse(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				AssemblyCSharp.ClientResponse obj = new AssemblyCSharp.ClientResponse();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: AssemblyCSharp.ClientResponse.New");
			}
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_status(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			int ret = obj.status;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index status on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_message(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			string ret = obj.message;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index message on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_headCode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			int ret = obj.headCode;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index headCode on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_bytes(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			byte[] ret = obj.bytes;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index bytes on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_status(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.status = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index status on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_message(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.message = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index message on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_headCode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.headCode = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index headCode on a nil value" : e.Message);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_bytes(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			AssemblyCSharp.ClientResponse obj = (AssemblyCSharp.ClientResponse)o;
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			obj.bytes = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o == null ? "attempt to index bytes on a nil value" : e.Message);
		}
	}
}

