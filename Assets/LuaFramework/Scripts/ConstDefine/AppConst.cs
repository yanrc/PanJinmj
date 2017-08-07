using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework
{
    public class AppConst
    {
        public const bool DebugMode =
#if UNITY_EDITOR
         true;                       //调试模式-用于内部测试
#else
         false;
#endif
        /// <summary>
        /// 如果想删掉框架自带的例子，那这个例子模式必须要
        /// 关闭，否则会出现一些错误。
        /// </summary>
        public const bool ExampleMode = false;                       //例子模式 

        /// <summary>
        /// 如果开启更新模式，前提必须启动框架自带服务器端。
        /// 否则就需要自己将StreamingAssets里面的所有内容
        /// 复制到自己的Webserver上面，并修改下面的WebUrl。
        /// </summary>
        public const bool UpdateMode =
#if UNITY_EDITOR
         false;                                                     //更新模式-默认关闭 
#else
         true;
#endif                       
        public const bool LuaByteMode = true;                      //Lua字节码模式-默认关闭 

        public const bool LuaBundleMode = false;                    //Lua代码AssetBundle模式

        public const int TimerInterval = 1;
        public const int GameFrameRate = 30;                        //游戏帧频

        public const string AppName = "LuaFramework";               //应用程序名称
        public const string LuaTempDir = "Lua/";                    //临时目录
        public const string AppPrefix = AppName + "_";              //应用程序前缀
        public const string ExtName = ".unity3d";                   //素材扩展名
        public const string AssetDir = "StreamingAssets";           //素材目录 

        public static string UserId = string.Empty;                 //用户ID
        public static int SocketPort = 0;                           //Socket服务器端口
        public static string SocketAddress = string.Empty;          //Socket服务器地址
        public static int ChatSocketPort = 0;                       //ChatSocket服务器端口
        public static string ChatSocketAddress = string.Empty;      //ChatSocket服务器地址
        public static string FrameworkRoot
        {
            get
            {
                return Application.dataPath + "/" + AppName;
            }
        }
#if UNITY_ANDROID
        public static bool UNITY_ANDROID = true;
#else
        public static bool UNITY_ANDROID = false;
#endif
#if UNITY_IPHONE
        public static bool UNITY_IPHONE = true;
#else
        public static bool UNITY_IPHONE = false;
#endif
#if UNITY_STANDALONE_WIN
        public static bool UNITY_STANDALONE_WIN = true;
#else
        public static bool UNITY_STANDALONE_WIN = false;
#endif
#if UNITY_EDITOR
        public static bool UNITY_EDITOR = true;
#else
        public static bool UNITY_EDITOR = false;
#endif
        public static string GetWebUrl()
        {
            string WebUrl = "http://101.200.197.7:8090/";
            Dictionary<string, bool> gamelist = GameObject.FindObjectOfType<GameSetting>().Init();
            foreach(var item in gamelist)
            {
                if(item.Value)
                {
                    WebUrl +=item.Key;
                    break;
                }
            }
            if (Application.platform == RuntimePlatform.Android)
            {
                WebUrl+= "/Android/";
            }
            else if (Application.platform == RuntimePlatform.IPhonePlayer)
            {
                WebUrl = "/iOS/";
            }
            else
            {
                WebUrl = "/Windows/";
            }
            return WebUrl;
        }
    }

}