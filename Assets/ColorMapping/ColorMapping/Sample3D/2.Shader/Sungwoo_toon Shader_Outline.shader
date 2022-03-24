Shader "Custom/toon Shader_Outline"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OutlinePower ("outlinePower", float) = 0
		_ShadowLevel("ShadowLevel(정수)", float) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

		cull front

        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient



		float _OutlinePower;

		

		void vert(inout appdata_full v)
		{
			_OutlinePower = _OutlinePower / 3;

			v.vertex.xyz = v.vertex.xyz + v.normal.xyz*_OutlinePower;
		}
		
        struct Input
        {
			float4 color:COLOR;
		
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
		

        }
		float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
		{
			return float4(0, 0, 0, 1);
		}



       ENDCG

		cull back
		//2nd
		CGPROGRAM

		#pragma surface surf Toon noambient

		sampler2D _MainTex;
	   float _ShadowLevel;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) *0.5 + 0.5;
			
			ndotl = ndotl * _ShadowLevel;
			ndotl = ceil(ndotl) / _ShadowLevel;
			
			float4 final;
			final.rgb = s.Albedo*ndotl;
			final.a = s.Alpha;

			return final;
		
		
		}




		ENDCG
    }
    FallBack "Diffuse"
}
