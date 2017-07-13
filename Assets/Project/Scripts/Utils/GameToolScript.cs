using System;
using System.Collections.Generic;
using UnityEngine;
using AssemblyCSharp;
using UnityEngine.UI;
using System.IO;
using System.Collections;
using System.Net;
using System.Text;
namespace AssemblyCSharp
{
    public class GameToolScript
    {
        public static GameObject Instantiate(GameObject obj, Transform parent)
        {
            return GameObject.Instantiate(obj, parent);
        }
        /// <summary>
        /// 这个方法和lua里的方法一起使用
        /// </summary>
        public static string GetIpAddress(string url)
        {
            string tempip = "";
            try
            {
                WebRequest wr = WebRequest.Create(url);
                Stream s = wr.GetResponse().GetResponseStream();
                StreamReader sr = new StreamReader(s, Encoding.Default);
                string all = sr.ReadToEnd(); //读取网站的数据
                tempip = all;
                sr.Close();
                s.Close();
            }
            catch
            {
            }
            return tempip;
        }
    }
}
