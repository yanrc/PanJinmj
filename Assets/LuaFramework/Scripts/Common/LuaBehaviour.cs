using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    public class LuaBehaviour : View {
        private string data = null;
        private Dictionary<GameObject, LuaFunction> buttons = new Dictionary<GameObject, LuaFunction>();

        protected void Awake() {
            Util.CallMethod(name, "Awake", gameObject);
        }

        protected void Start() {
            Util.CallMethod(name, "Start");
        }

        protected void OnClick() {
            Util.CallMethod(name, "OnClick");
        }

        protected void OnClickEvent(GameObject go) {
            Util.CallMethod(name, "OnClick", go);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null)
            {
                Debugger.LogError("GameObject="+go+ ",LuaFunction="+luafunc);
                return;
            }
            buttons.Add(go, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }
        /// <summary>
        /// 添加单击事件,多一个参数
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc,object arg)
        {
            if (go == null || luafunc == null)
            {
                Debugger.LogError("GameObject=" + go + ",LuaFunction=" + luafunc);
                return;
            }
            buttons.Add(go, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate () {
                    luafunc.Call(go,arg);
                }
            );
        }
        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            ClearClick();
#if ASYNC_MODE
            //string abName = name.ToLower().Replace("panel", "");
            string abName = "prefabs";
            ResManager.UnloadAssetBundle(abName + AppConst.ExtName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}