// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RuinWall"
{
	Properties
	{
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
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

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalA = i.uv_texcoord * _NormalA_ST.xy + _NormalA_ST.zw;
			float2 uv_NormalB = i.uv_texcoord * _NormalB_ST.xy + _NormalB_ST.zw;
			float2 uv_LerpMap = i.uv_texcoord * _LerpMap_ST.xy + _LerpMap_ST.zw;
			float grayscale8 = Luminance(tex2D( _LerpMap, uv_LerpMap ).rgb);
			float temp_output_20_0 = ( ( grayscale8 - _LerpValue ) * _lerpMutiply );
			float4 lerpResult11 = lerp( tex2D( _NormalA, uv_NormalA ) , tex2D( _NormalB, uv_NormalB ) , temp_output_20_0);
			o.Normal = lerpResult11.rgb;
			float2 uv_AlbedoA = i.uv_texcoord * _AlbedoA_ST.xy + _AlbedoA_ST.zw;
			float2 uv_AlbedoB = i.uv_texcoord * _AlbedoB_ST.xy + _AlbedoB_ST.zw;
			float4 lerpResult7 = lerp( tex2D( _AlbedoA, uv_AlbedoA ) , tex2D( _AlbedoB, uv_AlbedoB ) , temp_output_20_0);
			o.Albedo = lerpResult7.rgb;
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
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
794;404;1156;1352;1210.751;1302.107;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1246.393,1987.211;Inherit;True;Property;_LerpMap;LerpMap;10;0;Create;True;0;0;0;False;0;False;750b1bd7ba8bd28489650de6d0a95cc5;2e29d566a37e9e64eb825dfdc86f6dc6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;6;-927.8967,1982.768;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-615.5768,2253.473;Inherit;False;Property;_LerpValue;LerpValue;11;0;Create;True;0;0;0;False;0;False;1;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;8;-615.8387,1948.498;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-320.3347,1920.305;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-327.148,2300.25;Inherit;False;Property;_lerpMutiply;lerpMutiply;12;0;Create;True;0;0;0;False;0;False;0;1.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1080.967,666.0218;Inherit;True;Property;_RoughnessA;RoughnessA;4;0;Create;True;0;0;0;False;0;False;None;c53b2f2493a69c34c94e257ff4994a8c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;35;-1068.007,953.8784;Inherit;True;Property;_RoughnessB;RoughnessB;9;0;Create;True;0;0;0;False;0;False;None;0147bf2f4ce00ad4a9ab72f988a39046;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;33;-653.8018,661.8352;Inherit;True;Property;_TextureSample7;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;10;-994.6144,-971.3174;Inherit;True;Property;_AlbedoA;AlbedoA;0;0;Create;True;0;0;0;False;0;False;None;6696b852ced51e143982ba54efc2497a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1017.52,-447.1064;Inherit;True;Property;_NormalA;NormalA;1;0;Create;True;0;0;0;False;0;False;None;0e22a74caaa03ec449a4d8b886761c90;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;29;-1036.405,405.2242;Inherit;True;Property;_MetalicB;MetalicB;7;0;Create;True;0;0;0;False;0;False;None;5fd6d039b581c974bb85bec10e124a86;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;34;-667.7023,938.6594;Inherit;True;Property;_TextureSample8;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;39;-1130.816,1435.639;Inherit;True;Property;_AmbientOccB;AmbientOccB;8;0;Create;True;0;0;0;False;0;False;None;fc9bcc6093f2cc2498202128cf9abbb7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1004.56,-159.2499;Inherit;True;Property;_NormalB;NormalB;6;0;Create;True;0;0;0;False;0;False;None;3422f8e1280d50a4fa408dc15ebe1b9d;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;38;-1033.351,1165.489;Inherit;True;Property;_AmbientOccA;AmbientOccA;3;0;Create;True;0;0;0;False;0;False;None;0ca3f34ad2ae59e45a6bb8f65bc10d8d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1018.498,-736.9208;Inherit;True;Property;_AlbedoB;AlbedoB;5;0;Create;True;0;0;0;False;0;False;None;fd3f0e14dd487d643a2c1d32cb3e79ed;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;39.08708,2011.865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;28;-1049.365,117.3676;Inherit;True;Property;_MetalicA;MetalicA;2;0;Create;True;0;0;0;False;0;False;None;6c95a5e274237eb46b694be1be7fa971;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;31;-636.1005,390.0052;Inherit;True;Property;_TextureSample6;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-563.0162,-688.7039;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-549.5146,-916.8174;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-604.2552,-174.4689;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-620.0862,1438.127;Inherit;True;Property;_TextureSample10;Texture Sample 4;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;32;373.294,796.8672;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-590.3546,-451.293;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-606.1857,1161.303;Inherit;True;Property;_TextureSample9;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-622.2,113.181;Inherit;True;Property;_TextureSample5;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;404.8956,248.213;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;324.4342,1192.969;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;353.989,-831.7778;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;436.7408,-316.261;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;37;753.3348,820.5901;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1034.39,-117.9199;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RuinWall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;6;7;5;1
WireConnection;8;0;6;0
WireConnection;19;0;8;0
WireConnection;19;1;17;0
WireConnection;33;0;36;0
WireConnection;33;7;36;1
WireConnection;34;0;35;0
WireConnection;34;7;35;1
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;31;0;29;0
WireConnection;31;7;29;1
WireConnection;2;0;1;0
WireConnection;2;7;1;1
WireConnection;9;0;10;0
WireConnection;9;7;10;1
WireConnection;12;0;13;0
WireConnection;12;7;13;1
WireConnection;41;0;39;0
WireConnection;41;7;39;1
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;32;2;20;0
WireConnection;4;0;3;0
WireConnection;4;7;3;1
WireConnection;40;0;38;0
WireConnection;40;7;38;1
WireConnection;30;0;28;0
WireConnection;30;7;28;1
WireConnection;27;0;30;0
WireConnection;27;1;31;0
WireConnection;27;2;20;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;42;2;20;0
WireConnection;7;0;9;0
WireConnection;7;1;2;0
WireConnection;7;2;20;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;11;2;20;0
WireConnection;37;0;32;0
WireConnection;0;0;7;0
WireConnection;0;1;11;0
WireConnection;0;3;27;0
WireConnection;0;4;37;0
WireConnection;0;5;42;0
ASEEND*/
//CHKSM=42D4327AC015FB6EC8C7B828C67172437CA2F64F