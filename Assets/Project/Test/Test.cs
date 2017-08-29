using System.Collections;
using UnityEngine;
using LuaInterface;
public class Test : MonoBehaviour
{
    //    string script = @"
    //function string.bytes2string(bytes)
    //print(bytes.Length)
    //local len = bytes.Length
    //	local str = ''
    //	for i = 0,len-1 do
    //		str = str .. string.char(bytes[i])
    //	end
    //    test.test(str)
    //	return str
    //end
    //test={}
    //function test.test(data)
    //print(#data)
    //local desfile=io.open('e:\\Capture002.png','wb')
    //io.output(desfile)
    //io.write(data)
    //io.close(desfile)
    //end
    //        ";
    //    LuaFunction func = null;
    //    LuaState lua = null;
    //    string tips = null;

    //    IEnumerator Start()
    //    {
    //        yield return new WaitForEndOfFrame();
    //        int width = Screen.width;
    //        int height = Screen.height;
    //        Texture2D tex = new Texture2D(width, height, TextureFormat.RGB24, false);
    //        tex.ReadPixels(new Rect(0, 0, width, height), 0, 0, true);
    //        tex.Apply();
    //        byte[] imagebytes = tex.EncodeToPNG();//转化为png图
    //        lua = new LuaState();
    //        lua.Start();
    //        lua.DoString(script);
    //        func = lua.GetFunction("string.bytes2string");
    //        if (func != null)
    //        {
    //            object[] r = func.LazyCall(imagebytes);
    //            Debugger.Log("generic call return: {0}", r[0]);
    //        }
    //        lua.CheckTop();
    //    }
    //    void OnDestroy()
    //    {
    //        if (func != null)
    //        {
    //            func.Dispose();
    //            func = null;
    //        }
    //        lua.Dispose();
    //        lua = null;
    //    }
    void Start()
    {
        //obj.SetActive(true);
        //obj2.SetActive(true);
        //GameObject temp =null;
        //string name="123";
        //table[name] = temp;
        //temp = obj;
        //temp.GetType();
        //Debuger.Log(table[name]);
        Debug.Log("Application.persistentDataPath:" + Application.persistentDataPath);
        StartCoroutine(testwww());
    }
    IEnumerator testwww()
    {
        string url = "http://101.200.197.7:8090/Shuangliao/Android/";
        string random = System.DateTime.Now.ToString("yyyymmddhhmmss");
        string listUrl = url + "StreamingAssets?v=" + random;
        WWW www = new WWW(listUrl);
        yield return www;
        System.IO.File.WriteAllBytes(Application.persistentDataPath + "/StreamingAssets", www.bytes);
        WWW wwwlocal = new WWW("file://" + Application.persistentDataPath + "/StreamingAssets");
        yield return wwwlocal;
        Debug.Log(wwwlocal.url);
        Debug.Log(wwwlocal.text);
    }
}
