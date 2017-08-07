using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameSetting : MonoBehaviour {
    public  bool Panjin;
    public  bool Wuxi;
    public  bool ShuangLiao;
    public  bool Jiujiang;
    public  bool Changsha;
    public  bool TuiDaoHu;
    public  bool Fushun;
    public  Dictionary<string, bool> gamelist = new Dictionary<string, bool>();
    public Dictionary<string, bool> Init()
    {
        gamelist.Clear();
        gamelist.Add("Panjin", Panjin);
        gamelist.Add("Wuxi", Wuxi);
        gamelist.Add("ShuangLiao", ShuangLiao);
        gamelist.Add("Jiujiang", Jiujiang);
        gamelist.Add("Changsha", Changsha);
        gamelist.Add("TuiDaoHu", TuiDaoHu);
        gamelist.Add("Fushun", Fushun);
        return gamelist;
    }
}

