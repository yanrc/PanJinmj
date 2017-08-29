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
        /// <summary>
        /// 安卓的几个泛型方法
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="fieldName"></param>
        /// <returns></returns>
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
        /// <summary>
        /// 这个类lua生成的是带两个参数的构造函数，第二个函数传null会报错
        /// </summary>
        /// <param name="className"></param>
        /// <returns></returns>
        public static AndroidJavaObject NewAndroidJavaObject(string className)
        {
            return new AndroidJavaObject(className);
        }
        /// <summary>
        /// lua没有生成这个方法
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="fieldName"></param>
        /// <param name="val"></param>
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
