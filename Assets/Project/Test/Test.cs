using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using AssemblyCSharp;
using System;
using UnityEngine.UI;
public class Test : MonoBehaviour {
    public GameObject prefab;
    private void Start()
    {
       GameObject clone=GameObject.Instantiate(prefab,prefab.transform.parent);
    }
}
