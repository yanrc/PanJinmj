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
        /// <summary>
        /// Sets the other card object position.
        /// </summary>
        /// <param name="tempList">Temp list.</param>
        /// <param name="initDiretion">Init diretion.</param>
        /// <param name="Type">Type.</param> 1- 碰，2-杠
        //public static void setOtherCardObjPosition(List<GameObject> tempList, String initDiretion, int type)
        //{
        //    if (type == 1)
        //    {
        //        switch (initDiretion)
        //        {
        //            case DirectionEnum.Top: //上
        //                tempList[0].transform.localPosition = new Vector3(-273f, 0f); //位置                      
        //                break;
        //            case DirectionEnum.Left: //左
        //                tempList[0].transform.localPosition = new Vector3(0, -173); //位置              
        //                break;
        //            case DirectionEnum.Right: //右
        //                tempList[0].transform.localPosition = new Vector3(0, 180f); //位置                  
        //                break;
        //        }


        //        for (int i = 1; i < tempList.Count; i++)
        //        {

        //            switch (initDiretion)
        //            {
        //                case DirectionEnum.Top: //上
        //                    tempList[i].transform.localPosition = new Vector3(-204f + 37 * (i - 1), 0); //位置                      
        //                    break;
        //                case DirectionEnum.Left: //左
        //                    tempList[i].transform.localPosition = new Vector3(0, -105 + (i - 1) * 30); //位置              
        //                    break;
        //                case DirectionEnum.Right: //右
        //                    tempList[i].transform.localPosition = new Vector3(0, 119 - (i - 1) * 30); //位置                  
        //                    break;
        //            }
        //        }
        //    }
        //    else
        //    {

        //        for (int i = 0; i < tempList.Count; i++)
        //        {

        //            switch (initDiretion)
        //            {
        //                case DirectionEnum.Top: //上
        //                    tempList[i].transform.localPosition = new Vector3(-204 + 37 * i, 0); //位置                      
        //                    break;
        //                case DirectionEnum.Left: //左
        //                    tempList[i].transform.localPosition = new Vector3(0, -105 + i * 30); //位置              
        //                    break;
        //                case DirectionEnum.Right: //右
        //                    tempList[i].transform.localPosition = new Vector3(0, 119 - i * 30); //位置                  
        //                    break;
        //            }
        //        }
        //    }
        //}
        /// <summary>
        /// 把bool类型数组转化为2进制数字
        /// </summary>
        //public static int boolArrToInt(bool[] arr)
        //{
        //    int num = 0;
        //    for (int i = arr.Length - 1; i >= 0; i--)
        //    {
        //        num = (num << 1) + (arr[i] ? 1 : 0);
        //    }
        //    return num;
        //}
        /// <summary>
        /// 2进制数字转化bool类型数组
        /// </summary>
        //public static bool[] IntToboolArr(int num)
        //{
        //    List<bool> temp = new List<bool>();
        //    while (num > 0)
        //    {
        //        temp.Add((num & 1) == 1);
        //        num = num >> 1;
        //    }
        //    return temp.ToArray();
        //}
        /// <summary>
        /// 把toggle类型列表转化为2进制数字
        /// </summary>
        //public static int ToggleListToInt(List<Toggle> toggles)
        //{
        //    int num = 0;
        //    for (int i = toggles.Count - 1; i >= 0; i--)
        //    {
        //        num = (num << 1) + (toggles[i].isOn ? 1 : 0);
        //    }
        //    return num;
        //}
        /// <summary>
        /// 2进制数字给toggle列表赋值
        /// </summary>
        //public static void IntToToggleList(int num, List<Toggle> toggles)
        //{
        //    for (int i = 0; i < toggles.Count; i++)
        //    {
        //        toggles[i].isOn = (num & 1) == 1;
        //        num = num >> 1;
        //    }
        //}
        ///// <summary>
        ///// 文件夹复制，sourceDir不能是Android的streamingasset，因为获取不到
        ///// </summary>
        //public static void CopyFolder(string sourceDir, string destDir)
        //{
        //    //删除目标文件夹并重新生成
        //    if (Directory.Exists(destDir)) Directory.Delete(destDir, true);
        //    Directory.CreateDirectory(destDir);

        //    // 子文件夹
        //    foreach (string sub in Directory.GetDirectories(sourceDir))
        //        CopyFolder(sub + "\\", destDir + Path.GetFileName(sub) + "\\");

        //    // 文件
        //    foreach (string file in Directory.GetFiles(sourceDir))
        //        File.Copy(file, destDir + Path.GetFileName(file), true);
        //}
        ///// <summary>
        ///// 文件夹复制
        ///// </summary>
        //public static IEnumerator CopyFilesInAndroid(string[] sourcefiles, string destDir)
        //{
        //    //删除目标文件夹并重新生成
        //    if (Directory.Exists(destDir)) Directory.Delete(destDir, true);
        //    Directory.CreateDirectory(destDir);
        //    //复制每个文件
        //    for (int i = 0; i < sourcefiles.Length; i++)
        //    {
        //        string outfile = destDir + Path.GetFileName(sourcefiles[i]);
        //        WWW www = new WWW(sourcefiles[i]);
        //        yield return www;
        //        if (www.error == null)
        //        {
        //            File.WriteAllBytes(outfile, www.bytes);
        //        }
        //        else
        //        {
        //            Debug.Log(www.error);
        //        }
        //    }
        //}
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

    //public class DirectionEnum
    //{
    //    public const string Bottom = "B";
    //    public const string Right = "R";
    //    public const string Top = "T";
    //    public const string Left = "L";
    //}
}
