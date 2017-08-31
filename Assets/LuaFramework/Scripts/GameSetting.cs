using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class GameSetting : MonoBehaviour {
    public  bool Panjin;
    public  bool Wuxi;
    public  bool Shuangliao;
    public  bool Jiujiang;
    public  bool Changsha;
    public  bool Tuidaohu;
    public  bool Fushun;
    public bool EnableDebug;
    public Sprite LOGO;
    public  Dictionary<string, bool> gamelist = new Dictionary<string, bool>();
    private void Awake()
    {
        YRC.Debuger.debugMode = EnableDebug;
        GameObject go = GameObject.Find("Panel_Default");
        go.transform.Find("logo").GetComponent<Image>().sprite = LOGO;
    }
    public Dictionary<string, bool> Init()
    {
        gamelist.Clear();
        gamelist.Add("Panjin", Panjin);
        gamelist.Add("Wuxi", Wuxi);
        gamelist.Add("Shuangliao", Shuangliao);
        gamelist.Add("Jiujiang", Jiujiang);
        gamelist.Add("Changsha", Changsha);
        gamelist.Add("TuiDaoHu", Tuidaohu);
        gamelist.Add("Fushun", Fushun);
        return gamelist;
    }
}

