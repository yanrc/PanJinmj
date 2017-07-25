using System;
using UnityEngine;
using System.IO;
using System.Net;
using System.Text;
using System.Security.Cryptography;
using System.Collections;

namespace AssemblyCSharp
{
    public class GameToolScript
    {
        public static GameObject Instantiate(GameObject obj, Transform parent)
        {
            return GameObject.Instantiate(obj, parent);
        }

        public static AndroidJavaObject AndroidJavaObjectGetStatic(AndroidJavaObject obj,string fieldName)
        {
            return obj.GetStatic<AndroidJavaObject>(fieldName);
        }
        public static AndroidJavaObject AndroidJavaObjectCallStatic(AndroidJavaObject obj, string fieldName, params object[] args)
        {
            return obj.CallStatic<AndroidJavaObject>(fieldName, args);
        }
        public static bool AndroidJavaObjectCallBool(AndroidJavaObject obj, string fieldName, params object[] args)
        {
            return obj.Call<bool>(fieldName, args);
        }
        public static AndroidJavaObject NewAndroidJavaObject(string className)
        {
            return new AndroidJavaObject(className);
        }
        public static void SetAndroidString(AndroidJavaObject obj, string fieldName, string val)
        {
            obj.Set(fieldName, val);
        }
        public static string GetMD5(string str)
        {
            byte[] result = Encoding.Default.GetBytes(str);    //tbPass为输入密码的文本框
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] output = md5.ComputeHash(result);
            return (BitConverter.ToString(output).Replace("-", "")).ToLower();  //tbMd5pass为输出加密文本的文本框
        }
    }
}
