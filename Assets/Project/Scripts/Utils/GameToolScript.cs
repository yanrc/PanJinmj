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
        public void setOtherCardObjPosition(List<GameObject> tempList, String initDiretion, int type)
        {
            if (type == 1)
            {
                switch (initDiretion)
                {
                    case DirectionEnum.Top: //上
                        tempList[0].transform.localPosition = new Vector3(-273f, 0f); //位置                      
                        break;
                    case DirectionEnum.Left: //左
                        tempList[0].transform.localPosition = new Vector3(0, -173); //位置              
                        break;
                    case DirectionEnum.Right: //右
                        tempList[0].transform.localPosition = new Vector3(0, 180f); //位置                  
                        break;
                }


                for (int i = 1; i < tempList.Count; i++)
                {

                    switch (initDiretion)
                    {
                        case DirectionEnum.Top: //上
                            tempList[i].transform.localPosition = new Vector3(-204f + 37 * (i - 1), 0); //位置                      
                            break;
                        case DirectionEnum.Left: //左
                            tempList[i].transform.localPosition = new Vector3(0, -105 + (i - 1) * 30); //位置              
                            break;
                        case DirectionEnum.Right: //右
                            tempList[i].transform.localPosition = new Vector3(0, 119 - (i - 1) * 30); //位置                  
                            break;
                    }
                }
            }
            else
            {

                for (int i = 0; i < tempList.Count; i++)
                {

                    switch (initDiretion)
                    {
                        case DirectionEnum.Top: //上
                            tempList[i].transform.localPosition = new Vector3(-204 + 37 * i, 0); //位置                      
                            break;
                        case DirectionEnum.Left: //左
                            tempList[i].transform.localPosition = new Vector3(0, -105 + i * 30); //位置              
                            break;
                        case DirectionEnum.Right: //右
                            tempList[i].transform.localPosition = new Vector3(0, 119 - i * 30); //位置                  
                            break;
                    }
                }
            }
        }
        //public static int getMyIndexFromList(List<AvatarVO> avatarList)
        //{
        //    if (avatarList != null)
        //    {
        //        for (int i = 0; i < avatarList.Count; i++)
        //        {
        //            if (avatarList[i].account.uuid == GlobalDataScript.loginResponseData.account.uuid || avatarList[i].account.openid == GlobalDataScript.loginResponseData.account.openid)
        //            {
        //                GlobalDataScript.loginResponseData.account.uuid = avatarList[i].account.uuid;
        //                return i;
        //            }
        //        }
        //    }
        //    MyDebug.LogError("数据异常返回0");
        //    return 0;
        //}
        public static void cleaListener()
        {
            //if (SocketEventHandle.getInstance ().LoginCallBack != null) {
            //	SocketEventHandle.getInstance ().LoginCallBack = null;
            //}
            if (SocketEventHandle.getInstance().CreateRoomCallBack != null)
            {
                SocketEventHandle.getInstance().CreateRoomCallBack = null;
            }
            if (SocketEventHandle.getInstance().JoinRoomCallBack != null)
            {
                SocketEventHandle.getInstance().JoinRoomCallBack = null;
            }
            if (SocketEventHandle.getInstance().StartGameNotice != null)
            {
                SocketEventHandle.getInstance().StartGameNotice = null;
            }
            if (SocketEventHandle.getInstance().pickCardCallBack != null)
            {
                SocketEventHandle.getInstance().pickCardCallBack = null;
            }
            if (SocketEventHandle.getInstance().otherPickCardCallBack != null)
            {
                SocketEventHandle.getInstance().otherPickCardCallBack = null;
            }
            if (SocketEventHandle.getInstance().putOutCardCallBack != null)
            {
                SocketEventHandle.getInstance().putOutCardCallBack = null;
            }
            if (SocketEventHandle.getInstance().PengCardCallBack != null)
            {
                SocketEventHandle.getInstance().PengCardCallBack = null;
            }
            if (SocketEventHandle.getInstance().GangCardCallBack != null)
            {
                SocketEventHandle.getInstance().GangCardCallBack = null;
            }
            if (SocketEventHandle.getInstance().HupaiCallBack != null)
            {
                SocketEventHandle.getInstance().HupaiCallBack = null;
            }
            if (SocketEventHandle.getInstance().gangCardNotice != null)
            {
                SocketEventHandle.getInstance().gangCardNotice = null;
            }
            if (SocketEventHandle.getInstance().btnActionShow != null)
            {
                SocketEventHandle.getInstance().btnActionShow = null;
            }
            if (SocketEventHandle.getInstance().outRoomCallback != null)
            {
                SocketEventHandle.getInstance().outRoomCallback = null;
            }
            if (SocketEventHandle.getInstance().dissoliveRoomResponse != null)
            {
                SocketEventHandle.getInstance().dissoliveRoomResponse = null;
            }
            if (SocketEventHandle.getInstance().gameReadyNotice != null)
            {
                SocketEventHandle.getInstance().gameReadyNotice = null;
            }
            if (SocketEventHandle.getInstance().messageBoxNotice != null)
            {
                SocketEventHandle.getInstance().messageBoxNotice = null;
            }
            if (SocketEventHandle.getInstance().backLoginNotice != null)
            {
                SocketEventHandle.getInstance().backLoginNotice = null;
            }
            //if (SocketEventHandle.getInstance ().RoomBackResponse != null) {
            //	SocketEventHandle.getInstance ().RoomBackResponse = null;
            //}
            if (SocketEventHandle.getInstance().cardChangeNotice != null)
            {
                SocketEventHandle.getInstance().cardChangeNotice = null;
            }
            if (SocketEventHandle.getInstance().offlineNotice != null)
            {
                SocketEventHandle.getInstance().offlineNotice = null;
            }
            if (SocketEventHandle.getInstance().onlineNotice != null)
            {
                SocketEventHandle.getInstance().onlineNotice = null;
            }
            if (SocketEventHandle.getInstance().giftResponse != null)
            {
                SocketEventHandle.getInstance().giftResponse = null;
            }
            if (SocketEventHandle.getInstance().returnGameResponse != null)
            {
                SocketEventHandle.getInstance().returnGameResponse = null;
            }
            if (SocketEventHandle.getInstance().gameFollowBanderNotice != null)
            {
                SocketEventHandle.getInstance().gameFollowBanderNotice = null;
            }
            if (SocketEventHandle.getInstance().contactInfoResponse != null)
            {
                SocketEventHandle.getInstance().contactInfoResponse = null;
            }
            if (SocketEventHandle.getInstance().zhanjiResponse != null)
            {
                SocketEventHandle.getInstance().zhanjiResponse = null;
            }
            if (SocketEventHandle.getInstance().zhanjiDetailResponse != null)
            {
                SocketEventHandle.getInstance().zhanjiDetailResponse = null;
            }
            if (SocketEventHandle.getInstance().gameBackPlayResponse != null)
            {
                SocketEventHandle.getInstance().gameBackPlayResponse = null;
            }
        }
        /// <summary>
        /// 把bool类型数组转化为2进制数字
        /// </summary>
        public static int boolArrToInt(bool[] arr)
        {
            int num = 0;
            for (int i = arr.Length - 1; i >= 0; i--)
            {
                num = (num << 1) + (arr[i] ? 1 : 0);
            }
            return num;
        }
        /// <summary>
        /// 2进制数字转化bool类型数组
        /// </summary>
        public static bool[] IntToboolArr(int num)
        {
            List<bool> temp = new List<bool>();
            while (num > 0)
            {
                temp.Add((num & 1) == 1);
                num = num >> 1;
            }
            return temp.ToArray();
        }
        /// <summary>
        /// 把toggle类型列表转化为2进制数字
        /// </summary>
        public static int ToggleListToInt(List<Toggle> toggles)
        {
            int num = 0;
            for (int i = toggles.Count - 1; i >= 0; i--)
            {
                num = (num << 1) + (toggles[i].isOn ? 1 : 0);
            }
            return num;
        }
        /// <summary>
        /// 2进制数字给toggle列表赋值
        /// </summary>
        public static void IntToToggleList(int num, List<Toggle> toggles)
        {
            for (int i = 0; i < toggles.Count; i++)
            {
                toggles[i].isOn = (num & 1) == 1;
                num = num >> 1;
            }
        }
        /// <summary>
        /// 文件夹复制，sourceDir不能是Android的streamingasset，因为获取不到
        /// </summary>
        public static void CopyFolder(string sourceDir, string destDir)
        {
            //删除目标文件夹并重新生成
            if (Directory.Exists(destDir)) Directory.Delete(destDir, true);
            Directory.CreateDirectory(destDir);

            // 子文件夹
            foreach (string sub in Directory.GetDirectories(sourceDir))
                CopyFolder(sub + "\\", destDir + Path.GetFileName(sub) + "\\");

            // 文件
            foreach (string file in Directory.GetFiles(sourceDir))
                File.Copy(file, destDir + Path.GetFileName(file), true);
        }
        /// <summary>
        /// 文件夹复制
        /// </summary>
        public static IEnumerator CopyFilesInAndroid(string[] sourcefiles, string destDir)
        {
            //删除目标文件夹并重新生成
            if (Directory.Exists(destDir)) Directory.Delete(destDir, true);
            Directory.CreateDirectory(destDir);
            //复制每个文件
            for (int i = 0; i < sourcefiles.Length; i++)
            {
                string outfile = destDir + Path.GetFileName(sourcefiles[i]);
                WWW www = new WWW(sourcefiles[i]);
                yield return www;
                if (www.error == null)
                {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                else
                {
                    Debug.Log(www.error);
                }
            }
        }
        /// <summary>
        /// 这个方法和lua里的方法一起使用
        /// </summary>
        public static string getIpAddress(string url)
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

    public class DirectionEnum
    {
        public const string Bottom = "B";
        public const string Right = "R";
        public const string Top = "T";
        public const string Left = "L";
    }
}
