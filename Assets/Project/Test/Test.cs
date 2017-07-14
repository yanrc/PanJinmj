using System.Collections;
using UnityEngine;
using LuaInterface;
public class Test : MonoBehaviour
{
    string script = @"
function string.bytes2string(bytes)
print(bytes.Length)
local len = bytes.Length
	local str = ''
	for i = 0,len-1 do
		str = str .. string.char(bytes[i])
	end
    test.test(str)
	return str
end
test={}
function test.test(data)
print(#data)
local desfile=io.open('e:\\Capture002.png','wb')
io.output(desfile)
io.write(data)
io.close(desfile)
end
        ";
    LuaFunction func = null;
    LuaState lua = null;
    string tips = null;
    
    IEnumerator Start()
    {
        yield return new WaitForEndOfFrame();
        int width = Screen.width;
        int height = Screen.height;
        Texture2D tex = new Texture2D(width, height, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, width, height), 0, 0, true);
        tex.Apply();
        byte[] imagebytes = tex.EncodeToPNG();//转化为png图
        lua = new LuaState();
        lua.Start();
        lua.DoString(script);
        func = lua.GetFunction("string.bytes2string");
        if (func != null)
        {
            object[] r = func.Call(imagebytes);
            Debugger.Log("generic call return: {0}", r[0]);
        }
        lua.CheckTop();
    }
    void OnDestroy()
    {
        if (func != null)
        {
            func.Dispose();
            func = null;
        }
        lua.Dispose();
        lua = null;
    }
}
