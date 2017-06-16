using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using AssemblyCSharp;
using System;
using UnityEngine.UI;
public class Test : MonoBehaviour {
    Slider slider;
    void mtest()
    {
        slider.onValueChanged.AddListener(Changed);
    }
    private void Changed(float value)
    {
        
    }
}
