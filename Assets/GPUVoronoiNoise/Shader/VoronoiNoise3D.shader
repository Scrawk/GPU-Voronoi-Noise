Shader "Noise/VoronoiNoise3D" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", color) = (1,1,1,1)
		_Frequency("Frequency", float) = 10.0
		_Lacunarity("Lacunarity", float) = 2.0
		_Gain("Gain", float) = 0.5
		_Jitter("Jitter", Range(0,1)) = 1.0
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0
		#pragma glsl
		#include "GPUVoronoiNoise3D.cginc"
		#define OCTAVES 1

		sampler2D _MainTex;
		fixed4 _Color;
		
		struct Input 
		{
			float2 uv_MainTex;
			float3 noiseUV;
		};
		
		void vert(inout appdata_full v, out Input o) 
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.noiseUV = v.vertex.xyz; //use model space, not world space for noise uvs
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			float n = fBm_F0(IN.noiseUV, OCTAVES);
			
			//float n = fBm_F1_F0(IN.noiseUV, OCTAVES);
			
			o.Albedo = _Color * n;
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
