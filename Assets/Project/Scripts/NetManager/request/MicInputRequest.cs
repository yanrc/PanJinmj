using System;
using System.Collections.Generic;
using LuaFramework;
using LuaInterface;
namespace AssemblyCSharp
{
	public class MicInputRequest:ChatRequest
	{
		public MicInputRequest (List<int> _userList, byte[] sound)
		{
            LuaTable account = LuaClient.GetMainState().GetTable("GlobalData.loginResponseData.account");
            LuaTable apis = LuaClient.GetMainState().GetTable("APIS");
            headCode =(int)apis["MicInput_Request"];
            myUUid =(int)account["uuid"];
            userList = _userList;
			ChatSound = sound;
		}
	}
}

