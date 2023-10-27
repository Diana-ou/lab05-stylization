void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten) {
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
    #else
        float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ChooseColor_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float HatchedDiffuse, float Threshold1, float Threshold2, bool isHatchedShadow, out
float3 OUT)
{
    if (isHatchedShadow && HatchedDiffuse < Threshold1)
    {
        OUT = Shadow;
    } 
    else if (!isHatchedShadow && Diffuse < Threshold1)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Threshold2)
    {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}

void DetermineShadow_bool(float Diffuse, float Threshold1, out bool OUT)
{
    if (Diffuse < Threshold1)
    {
        OUT = true;
    }
    else
    {
        OUT = false;
    }
}