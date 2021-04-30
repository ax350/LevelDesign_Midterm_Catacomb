// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RuinWall"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0
		_AlbedoA("AlbedoA", 2D) = "white" {}
		_NormalA("NormalA", 2D) = "white" {}
		_MetalicA("MetalicA", 2D) = "white" {}
		_AmbientOccA("AmbientOccA", 2D) = "white" {}
		_RoughnessA("RoughnessA", 2D) = "white" {}
		_AlbedoB("AlbedoB", 2D) = "white" {}
		_NormalB("NormalB", 2D) = "white" {}
		_MetalicB("MetalicB", 2D) = "white" {}
		_AmbientOccB("AmbientOccB", 2D) = "white" {}
		_RoughnessB("RoughnessB", 2D) = "white" {}
		_LerpMap("LerpMap", 2D) = "white" {}
		_LerpValue("LerpValue", Float) = 1
		_lerpMutiply("lerpMutiply", Float) = 0
		_distance("distance", Float) = 0
		[Toggle]_off("off", Float) = 0
		_reverse("reverse", Float) = 1
		_edgewidth("edge width", Float) = 0
		_edgeColor("edge Color", Color) = (0.01337528,1,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalA;
		uniform float4 _NormalA_ST;
		uniform sampler2D _NormalB;
		uniform float4 _NormalB_ST;
		uniform sampler2D _LerpMap;
		uniform float4 _LerpMap_ST;
		uniform float _LerpValue;
		uniform float _lerpMutiply;
		uniform sampler2D _AlbedoA;
		uniform float4 _AlbedoA_ST;
		uniform sampler2D _AlbedoB;
		uniform float4 _AlbedoB_ST;
		uniform float _edgewidth;
		uniform float _off;
		uniform float _distance;
		uniform float _reverse;
		uniform float4 _edgeColor;
		uniform sampler2D _MetalicA;
		uniform float4 _MetalicA_ST;
		uniform sampler2D _MetalicB;
		uniform float4 _MetalicB_ST;
		uniform sampler2D _RoughnessA;
		uniform float4 _RoughnessA_ST;
		uniform sampler2D _RoughnessB;
		uniform float4 _RoughnessB_ST;
		uniform sampler2D _AmbientOccA;
		uniform float4 _AmbientOccA_ST;
		uniform sampler2D _AmbientOccB;
		uniform float4 _AmbientOccB_ST;
		uniform float _Cutoff = 0;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalA = i.uv_texcoord * _NormalA_ST.xy + _NormalA_ST.zw;
			float2 uv_NormalB = i.uv_texcoord * _NormalB_ST.xy + _NormalB_ST.zw;
			float2 uv_LerpMap = i.uv_texcoord * _LerpMap_ST.xy + _LerpMap_ST.zw;
			float grayscale8 = Luminance(tex2D( _LerpMap, uv_LerpMap ).rgb);
			float temp_output_20_0 = ( ( grayscale8 - _LerpValue ) * _lerpMutiply );
			float4 lerpResult11 = lerp( tex2D( _NormalA, uv_NormalA ) , ( tex2D( _NormalB, uv_NormalB ) * 13.98 ) , temp_output_20_0);
			o.Normal = lerpResult11.rgb;
			float2 uv_AlbedoA = i.uv_texcoord * _AlbedoA_ST.xy + _AlbedoA_ST.zw;
			float2 uv_AlbedoB = i.uv_texcoord * _AlbedoB_ST.xy + _AlbedoB_ST.zw;
			float4 lerpResult7 = lerp( tex2D( _AlbedoA, uv_AlbedoA ) , tex2D( _AlbedoB, uv_AlbedoB ) , temp_output_20_0);
			o.Albedo = lerpResult7.rgb;
			float3 ase_worldPos = i.worldPos;
			float simpleNoise12_g2 = SimpleNoise( ( float4( ase_worldPos , 0.0 ) + _SinTime ).xy*3.0 );
			float ifLocalVar19_g2 = 0;
			if( (int)_off == 0.0 )
				ifLocalVar19_g2 = ( ( ( _distance + ( 5.0 * ( simpleNoise12_g2 - 0.5 ) ) ) - distance( ase_worldPos , _WorldSpaceCameraPos ) ) * (int)_reverse );
			else
				ifLocalVar19_g2 = 1.0;
			float temp_output_74_0 = ifLocalVar19_g2;
			float temp_output_66_0 = abs( temp_output_74_0 );
			float ifLocalVar65 = 0;
			if( _edgewidth > temp_output_66_0 )
				ifLocalVar65 = temp_output_66_0;
			float4 ifLocalVar68 = 0;
			if( _edgewidth > temp_output_66_0 )
				ifLocalVar68 = ( _edgeColor * ( _edgewidth - ifLocalVar65 ) );
			o.Emission = ifLocalVar68.rgb;
			float2 uv_MetalicA = i.uv_texcoord * _MetalicA_ST.xy + _MetalicA_ST.zw;
			float2 uv_MetalicB = i.uv_texcoord * _MetalicB_ST.xy + _MetalicB_ST.zw;
			float4 lerpResult27 = lerp( tex2D( _MetalicA, uv_MetalicA ) , tex2D( _MetalicB, uv_MetalicB ) , temp_output_20_0);
			o.Metallic = lerpResult27.r;
			float2 uv_RoughnessA = i.uv_texcoord * _RoughnessA_ST.xy + _RoughnessA_ST.zw;
			float2 uv_RoughnessB = i.uv_texcoord * _RoughnessB_ST.xy + _RoughnessB_ST.zw;
			float4 lerpResult32 = lerp( tex2D( _RoughnessA, uv_RoughnessA ) , tex2D( _RoughnessB, uv_RoughnessB ) , temp_output_20_0);
			o.Smoothness = ( 1.0 - lerpResult32 ).r;
			float2 uv_AmbientOccA = i.uv_texcoord * _AmbientOccA_ST.xy + _AmbientOccA_ST.zw;
			float2 uv_AmbientOccB = i.uv_texcoord * _AmbientOccB_ST.xy + _AmbientOccB_ST.zw;
			float4 lerpResult42 = lerp( tex2D( _AmbientOccA, uv_AmbientOccA ) , tex2D( _AmbientOccB, uv_AmbientOccB ) , temp_output_20_0);
			o.Occlusion = lerpResult42.r;
			o.Alpha = 1;
			clip( temp_output_74_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1147;163;1156;1216;-677.6472;250.7791;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1246.393,1987.211;Inherit;True;Property;_LerpMap;LerpMap;11;0;Create;True;0;0;0;False;0;False;750b1bd7ba8bd28489650de6d0a95cc5;2e29d566a37e9e64eb825dfdc86f6dc6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;49;446.6209,373.9282;Inherit;False;Property;_off;off;15;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;541.602,279.6181;Inherit;False;Property;_reverse;reverse;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;470.4123,465.8618;Inherit;False;Property;_distance;distance;14;0;Create;True;0;0;0;False;0;False;0;-5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-927.8967,1982.768;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;74;659.3995,373.7769;Inherit;False;DistanceDissolve;-1;;2;d1f9b9ca3a057d84dba32c25879e0a8c;0;3;23;INT;0;False;21;INT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;722.7426,174.4073;Inherit;False;Property;_edgewidth;edge width;17;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;66;882.2183,267.186;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;8;-592.8387,1965.498;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-599.5768,2239.473;Inherit;False;Property;_LerpValue;LerpValue;12;0;Create;True;0;0;0;False;0;False;1;-0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;35;-1068.007,953.8784;Inherit;True;Property;_RoughnessB;RoughnessB;10;0;Create;True;0;0;0;False;0;False;None;0147bf2f4ce00ad4a9ab72f988a39046;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ConditionalIfNode;65;1007.654,209.4247;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1080.967,666.0218;Inherit;True;Property;_RoughnessA;RoughnessA;5;0;Create;True;0;0;0;False;0;False;None;9aa32358c3ee9074e8d8306e47763c9a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1004.56,-159.2499;Inherit;True;Property;_NormalB;NormalB;7;0;Create;True;0;0;0;False;0;False;None;3422f8e1280d50a4fa408dc15ebe1b9d;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-320.3347,1920.305;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-327.148,2300.25;Inherit;False;Property;_lerpMutiply;lerpMutiply;13;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-653.8018,661.8352;Inherit;True;Property;_TextureSample7;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;10;-994.6144,-971.3174;Inherit;True;Property;_AlbedoA;AlbedoA;1;0;Create;True;0;0;0;False;0;False;None;ce434fb9e13991040a3e55384d5f1427;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1018.498,-736.9208;Inherit;True;Property;_AlbedoB;AlbedoB;6;0;Create;True;0;0;0;False;0;False;None;fd3f0e14dd487d643a2c1d32cb3e79ed;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1017.52,-447.1064;Inherit;True;Property;_NormalA;NormalA;2;0;Create;True;0;0;0;False;0;False;None;36c7d69c8fa32294fb4b2b0ef3053c78;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;60;669.2426,-104.1927;Inherit;False;Property;_edgeColor;edge Color;18;0;Create;True;0;0;0;False;0;False;0.01337528,1,0,1;0.01337528,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-604.2552,-174.4689;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;39;-1130.816,1435.639;Inherit;True;Property;_AmbientOccB;AmbientOccB;9;0;Create;True;0;0;0;False;0;False;None;fc9bcc6093f2cc2498202128cf9abbb7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;919.6541,93.42474;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;29;-1036.405,405.2242;Inherit;True;Property;_MetalicB;MetalicB;8;0;Create;True;0;0;0;False;0;False;None;5fd6d039b581c974bb85bec10e124a86;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;28;-1049.365,117.3676;Inherit;True;Property;_MetalicA;MetalicA;3;0;Create;True;0;0;0;False;0;False;None;898f0e27735a8604c9b1743e7c44592a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;2.837783,1997.586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-216.3154,-21.04565;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;13.98;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-667.7023,938.6594;Inherit;True;Property;_TextureSample8;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;38;-1068.351,1182.489;Inherit;True;Property;_AmbientOccA;AmbientOccA;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;9;-549.5146,-916.8174;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-636.1005,390.0052;Inherit;True;Property;_TextureSample6;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-620.0862,1438.127;Inherit;True;Property;_TextureSample10;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-563.0162,-688.7039;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-606.1857,1161.303;Inherit;True;Property;_TextureSample9;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-32.86243,-105.8264;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;235.2952,709.3555;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-590.3546,-451.293;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-622.2,113.181;Inherit;True;Property;_TextureSample5;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;1091.743,15.40726;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;37;510.9955,665.7621;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;68;1352.134,0.4780996;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;324.4342,1192.969;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;81;-1498.906,-70.33582;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-1638.906,-43.33582;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;77;-1870.407,-143.3408;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;27;396.8956,12.213;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-1305.271,-170.2706;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.01,0.01;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;353.989,-831.7778;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;436.7408,-316.261;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;78;-1859.213,-445.4753;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1765.746,6.364142;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RuinWall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;6;7;5;1
WireConnection;74;23;50;0
WireConnection;74;21;49;0
WireConnection;74;10;48;0
WireConnection;66;0;74;0
WireConnection;8;0;6;0
WireConnection;65;0;61;0
WireConnection;65;1;66;0
WireConnection;65;2;66;0
WireConnection;19;0;8;0
WireConnection;19;1;17;0
WireConnection;33;0;36;0
WireConnection;33;7;36;1
WireConnection;12;0;13;0
WireConnection;12;7;13;1
WireConnection;67;0;61;0
WireConnection;67;1;65;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;34;0;35;0
WireConnection;34;7;35;1
WireConnection;9;0;10;0
WireConnection;9;7;10;1
WireConnection;31;0;29;0
WireConnection;31;7;29;1
WireConnection;41;0;39;0
WireConnection;41;7;39;1
WireConnection;2;0;1;0
WireConnection;2;7;1;1
WireConnection;40;0;38;0
WireConnection;40;7;38;1
WireConnection;45;0;12;0
WireConnection;45;1;46;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;32;2;20;0
WireConnection;4;0;3;0
WireConnection;4;7;3;1
WireConnection;30;0;28;0
WireConnection;30;7;28;1
WireConnection;59;0;60;0
WireConnection;59;1;67;0
WireConnection;37;0;32;0
WireConnection;68;0;61;0
WireConnection;68;1;66;0
WireConnection;68;2;59;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;42;2;20;0
WireConnection;81;0;80;0
WireConnection;80;0;77;1
WireConnection;80;1;77;2
WireConnection;80;2;77;3
WireConnection;27;0;30;0
WireConnection;27;1;31;0
WireConnection;27;2;20;0
WireConnection;7;0;9;0
WireConnection;7;1;2;0
WireConnection;7;2;20;0
WireConnection;11;0;4;0
WireConnection;11;1;45;0
WireConnection;11;2;20;0
WireConnection;0;0;7;0
WireConnection;0;1;11;0
WireConnection;0;2;68;0
WireConnection;0;3;27;0
WireConnection;0;4;37;0
WireConnection;0;5;42;0
WireConnection;0;10;74;0
ASEEND*/
//CHKSM=EDEE21A267F8691DEA29243FC4F909CD6B09DA94