using System.Collections;
using System.IO;
using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System;

public class YRCPackager : EditorWindow
{

    private bool pcPlatform;
    private bool androidPlatform;
    private bool iOSPlatform;
    //提示
    private string noteString = "";

    private string companyName = "app";
    private string packageName;

    Texture2D Icon;
    Sprite Logo;

    private MessageType currMessagetype = MessageType.Info;

    bool Panjin;
    bool Wuxi;
    bool Shuangliao;
    bool Jiujiang;
    bool Changsha;
    bool Tuidaohu;
    bool Fushun;
    bool EnableDebug;
    [MenuItem("YRCTools/YRCPackager")]
    static void Init()
    {
        //获取窗口
        YRCPackager window = (YRCPackager)EditorWindow.GetWindow(typeof(YRCPackager));
        window.Show();
        window.onShow();
    }

    public void onShow()
    {
        pcPlatform = EditorUserBuildSettings.activeBuildTarget == BuildTarget.StandaloneWindows64;
        androidPlatform = EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android;
        iOSPlatform = EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS;

        Logo = AssetDatabase.LoadAssetAtPath<Sprite>(PlayerPrefs.GetString("YRCPackager.Logo", "Assets/Project/Resources/Panel_Default/panjinlogo.png"));
        Icon = AssetDatabase.LoadAssetAtPath<Texture2D>(PlayerPrefs.GetString("YRCPackager.Icon", "Assets/Project/Textures/Icon/panjin.png"));
        packageName = PlayerPrefs.GetString("YRCPackager.packageName", "majiang");
        Panjin =PlayerPrefs.GetInt("YRCPackager.Panjin", 1)==1;
        Wuxi=PlayerPrefs.GetInt("YRCPackager.Wuxi", 0) == 1;
        Shuangliao = PlayerPrefs.GetInt("YRCPackager.Shuangliao", 0) == 1;
        Jiujiang = PlayerPrefs.GetInt("YRCPackager.Jiujiang", 0) == 1;
        Changsha = PlayerPrefs.GetInt("YRCPackager.Changsha", 0) == 1;
        Tuidaohu = PlayerPrefs.GetInt("YRCPackager.Tuidaohu", 0) == 1;
        Fushun = PlayerPrefs.GetInt("YRCPackager.Fushun", 0) == 1;
        EnableDebug = PlayerPrefs.GetInt("YRCPackager.EnableDebug", 0) == 1;
    }
    void OnGUI()
    {
        showContent();
    }
    private void showContent()
    {

        GUILayout.Label("Select platform", EditorStyles.boldLabel);

        GUILayout.BeginHorizontal();
        if (GUILayout.Toggle(pcPlatform, "PC"))
        {
            pcPlatform = true;
            androidPlatform = false;
            iOSPlatform = false;
        }
        if (GUILayout.Toggle(androidPlatform, "Android"))
        {
            pcPlatform = false;
            androidPlatform = true;
            iOSPlatform = false;
        }
        if (GUILayout.Toggle(iOSPlatform, "iOS"))
        {
            pcPlatform = false;
            androidPlatform = false;
            iOSPlatform = true;
        }
        GUILayout.EndHorizontal();

        EditorGUILayout.Space();      
        GUILayout.Label("Enter Game Name : ");
        packageName = GUILayout.TextField(packageName, 15);

        GUILayout.Label("Choose Game Icon : ");
        Icon = EditorGUILayout.ObjectField(Icon, typeof(Texture2D), false) as Texture2D;

        GUILayout.Label("Choose Game Logo : ");
        Logo = EditorGUILayout.ObjectField(Logo, typeof(Sprite), false) as Sprite;

        GUILayout.Label("Choose Games:");

        Panjin = GUILayout.Toggle(Panjin, "Panjin");
        Shuangliao = GUILayout.Toggle(Shuangliao, "Shuangliao");
        Jiujiang = GUILayout.Toggle(Jiujiang, "Jiujiang");
        Changsha = GUILayout.Toggle(Changsha, "Changsha");
        Tuidaohu = GUILayout.Toggle(Tuidaohu, "Tuidaohu");
        Wuxi = GUILayout.Toggle(Wuxi, "Wuxi");
        EnableDebug = GUILayout.Toggle(EnableDebug, "Debug");

        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Switch Platform"))
        {
            PlayerSettings.companyName = companyName;
            PlayerSettings.productName = packageName;
            noteString = "Please Wait";
            if(pcPlatform)
            {
                if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneWindows64)
                {
                    EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows64);
                }
            }else if(androidPlatform)
            {
                if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.Android)
                {
                    EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android,BuildTarget.Android);

                }
                EditorUserBuildSettings.androidBuildSubtarget = MobileTextureSubtarget.ETC;
            }
            else if(iOSPlatform)
            {
                if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.iOS)
                {
                    EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.iOS, BuildTarget.iOS);

                }
                EditorUserBuildSettings.androidBuildSubtarget = MobileTextureSubtarget.ETC;
            }
            noteString = "";
        }

        if (GUILayout.Button("Save PlayerSettings"))
        {
            if (androidPlatform)
            {
                if (QualitySettings.GetQualityLevel() != 2)
                    QualitySettings.SetQualityLevel(2);
                QualitySettings.anisotropicFiltering = AnisotropicFiltering.Enable;
                QualitySettings.antiAliasing = 8;
                QualitySettings.masterTextureLimit = 0;

                PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
                PlayerSettings.statusBarHidden = true;
                PlayerSettings.mobileRenderingPath = RenderingPath.Forward;
               // PlayerSettings.applicationIdentifier = "com." + companyName + "." + packageName;
                PlayerSettings.bundleVersion = "1.0";
                PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel16;
                PlayerSettings.keyaliasPass = "sunjiayao";
                PlayerSettings.keystorePass = "sunjiayao";
            }
            else if(pcPlatform)
            {
                if (QualitySettings.GetQualityLevel() != 3)
                    QualitySettings.SetQualityLevel(3);
                QualitySettings.anisotropicFiltering = AnisotropicFiltering.Enable;
                QualitySettings.antiAliasing = 8;
                QualitySettings.masterTextureLimit = 0;

                PlayerSettings.defaultIsFullScreen = false;
              
                PlayerSettings.runInBackground = true;
                PlayerSettings.captureSingleScreen = false;
                PlayerSettings.displayResolutionDialog = ResolutionDialogSetting.Enabled;
                PlayerSettings.usePlayerLog = false;
                PlayerSettings.resizableWindow = true;
                PlayerSettings.useMacAppStoreValidation = false;
                PlayerSettings.macFullscreenMode = MacFullscreenMode.FullscreenWindowWithDockAndMenuBar;
                PlayerSettings.forceSingleInstance = false;
                PlayerSettings.mobileRenderingPath = RenderingPath.Forward;
                PlayerSettings.colorSpace = ColorSpace.Gamma;
                PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.StandaloneWindows64,true);
            }
            else if (iOSPlatform)
            {
                if (QualitySettings.GetQualityLevel() != 2)
                    QualitySettings.SetQualityLevel(2);


                QualitySettings.anisotropicFiltering = AnisotropicFiltering.Enable;
                QualitySettings.antiAliasing = 8;
                QualitySettings.masterTextureLimit = 0;

                PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
                PlayerSettings.statusBarHidden = true;
                PlayerSettings.mobileRenderingPath = RenderingPath.Forward;
                PlayerSettings.applicationIdentifier = "com." + companyName + "." + packageName;
                PlayerSettings.bundleVersion = "1.0";
            }
            ApplyGameSetting(EditorUserBuildSettings.selectedBuildTargetGroup);
        }
        
        GUILayout.EndHorizontal();
        /*
        ///////////////////////////////////////////////////////////////////////////
        //                                                                      //
        //                                  打包                                //
        //                                                                      //
        //////////////////////////////////////////////////////////////////////////
        */
        if (GUILayout.Button("bulid & run"))
        {
            bool result = false;
                if (androidPlatform)
                {
                    if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android && QualitySettings.GetQualityLevel() == 2)
                    {
                        currMessagetype = MessageType.Info;
                        noteString = "";
                        BuildPipeline.BuildPlayer(GetBuildScenes(), ("F:/UnityPackage/" + Application.productName + "/Android/" + packageName + ".apk"), BuildTarget.Android, BuildOptions.AutoRunPlayer);
                        result = true;
                    }
                    else
                    {
                        result =false;

                    }
                }
                else if(iOSPlatform)
                {
                    if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS && QualitySettings.GetQualityLevel() == 2)
                    {
                        currMessagetype = MessageType.Info;
                        noteString = "";
                        BuildPipeline.BuildPlayer(GetBuildScenes(), ("F:/UnityPackage/" + Application.productName + "/iOS/"), BuildTarget.iOS, BuildOptions.AcceptExternalModificationsToPlayer);
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
                else//PC包
                {
                    if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.StandaloneWindows64 && QualitySettings.GetQualityLevel() == 3)
                    {
                        currMessagetype = MessageType.Info;
                        noteString = "";
                        BuildPipeline.BuildPlayer(GetBuildScenes(), ("F:/UnityPackage/" + Application.productName + "/PC/" + packageName + ".exe"), BuildTarget.StandaloneWindows64, BuildOptions.AutoRunPlayer);
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
                if(result)
                {
                    OpenFile();
                    Close();
                }
                else
                {
                    currMessagetype = MessageType.Error;
                    noteString = "bulid error!";
                }
        }
        EditorGUILayout.HelpBox("Note :" + noteString, currMessagetype);

        GUILayout.Box(Icon);
        if(Logo)
        GUILayout.Box(Logo.texture);
    }
    void ApplyGameSetting(BuildTargetGroup target)
    {
        //设置icon
        Texture2D[] icons = new Texture2D[PlayerSettings.GetIconSizesForTargetGroup(target).Length];
        icons[0] = Icon;
        PlayerSettings.SetIconsForTargetGroup(target,icons);
        PlayerPrefs.SetString("YRCPackager.packageName", packageName);
        PlayerPrefs.SetString("YRCPackager.Logo",AssetDatabase.GetAssetPath(Logo));
        PlayerPrefs.SetString("YRCPackager.Icon", AssetDatabase.GetAssetPath(Icon));
        PlayerPrefs.SetInt("YRCPackager.Panjin",Panjin?1:0);
        PlayerPrefs.SetInt("YRCPackager.Wuxi", Wuxi ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.Shuangliao", Shuangliao ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.Jiujiang", Jiujiang ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.Changsha", Changsha ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.Tuidaohu", Tuidaohu ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.Fushun", Fushun ? 1 : 0);
        PlayerPrefs.SetInt("YRCPackager.EnableDebug", EnableDebug ? 1 : 0);

        GameSetting gs = GameObject.FindObjectOfType<GameSetting>();
        gs.Panjin = Panjin;
        gs.Shuangliao = Shuangliao;
        gs.Jiujiang = Jiujiang;
        gs.Changsha = Changsha;
        gs.Tuidaohu = Tuidaohu;
        gs.Wuxi = Wuxi;
        gs.EnableDebug = EnableDebug;
        gs.LOGO = Logo;
    }

    private void OpenFile()
    {
        string path = "F:\\UnityPackage";
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }          
        System.Diagnostics.Process.Start("explorer.exe", path);

    }

    /// <summary>
    /// 获取场景
    /// </summary>
    /// <returns></returns>
    static string[] GetBuildScenes()
    {
        List<string> scenes = new List<string>();
        foreach (EditorBuildSettingsScene e in EditorBuildSettings.scenes)
        {
            if (e.enabled)
                scenes.Add(e.path);
        }
        return scenes.ToArray();
    }

}

