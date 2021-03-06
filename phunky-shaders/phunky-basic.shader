Shader ".Phunky/phunky-basic-wip"{
    Properties{

        [Enum(Off, 0, Front, 1, Back, 2)] _CullMode ("Cull", Int) = 0

        _MainTex("Main Texture", 2D) = "white"{}
        _Color("Color", color) = (1,1,1,1)
        _BumpMap("Normal Map", 2D) = "bump"{}

        [Enum(UnityEngine.Rendering.BlendMode)] _BlendModeSourceColor ("Source Color BlendMode", Int) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendModeDestinationColor ("Destination Color BlendMode", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendModeSourceAlpha ("Source Alpha BlendMode", Int) = 1
        [Enum(Less, 0, Greater, 1, LEqual, 2, GEqual, 3, Equal, 4, NotEqual, 5, Always, 6)] _ZTestMode ("ZTest", Int) = 2
        [Enum(On, 0, Off, 1)] _ZWriteMode("ZWrite", Int) = 0

    }
    SubShader{
        Tags {
            "Queue" = "Geometry"
            "RenderType" = "Transparent"
            }
        
        Cull [_CullMode]
        ZTest [_ZTestMode]
        ZWrite [_ZWriteMode]
        Blend [_BlendModeSourceColor] [_BlendModeDestinationColor], [_BlendModeSourceAlpha] [_BlendModeDestinationAlpha]

        Pass{
            CGPROGRAM
                // #pragma surface surf Lambert
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                struct appdata {
                    // float2 uv_MainTex;
                    // float2 uv_BumpMap;
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f {
                    float4 vertex : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                uniform sampler2D _MainTex;
                uniform float4 _MainTex_ST;
                uniform fixed4 _Color;

                // void surf(appdata IN, inout SurfaceOutput o){
                //     o.Abledo = tex2D(_MainTex, IN.uv_MainTex).rbg;
                //     o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                // }
                
                v2f vert(appdata v){
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o, O.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {
                    fixed4 col = tex2D(_MainTex, i.uv);
                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col * _Color;
                }
            ENDCG
        }
    }
    Fallback "Diffuse"
}