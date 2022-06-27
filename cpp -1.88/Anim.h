
#ifndef ANIM_LIB_H
#define ANIM_LIB_H

#define NDEBUG
#pragma once
#include <ctime>
#include <iostream>
#include <vector>

#include "imgui.h"
#include "imgui_impl_dx11.h"
#include "imgui_impl_win32.h"
#include <cstdio>
#include <cmath>
#include <cstdlib>
#include <windows.h>
#include <d3d11.h>
#include <d3dx11.h>
#include <map>
#include <urlmon.h>
#pragma comment(lib, "urlmon.lib")
#pragma comment(lib,"d3d11.lib")
#pragma comment(lib,"d3dx11.lib")

typedef DWORD D3DCOLOR;
typedef void (*PageDrawFunction) (int&);

struct THREAD_DOWNLOAD_PARAM {
	char url[1024*10];
	ImTextureID* image;
	int seed;
};


struct BEGIN_ANIM_PARAM {
	float (*fx_func)(float start, float end, float perc);
	float destination;
	float anim_duration;
	bool loop;
	bool reverse;
	float delay;
};

class Anim
{

private:

	float start;
	float dest;
	float duration;
	bool reversing;
	bool allow_user_reverse;
	bool reset_after_loop;
	bool gonna_reverse;
	bool gonna_loop;
	clock_t reverse_from;
	clock_t time_started;
	clock_t last_finish;
	float anim_diff;
	float pause_afteranim_duration;
	float (*calfx)(float start, float end, float perc);


	std::vector<BEGIN_ANIM_PARAM> waiting_list;

public:
	float value;


	Anim();

	float get();

	void begin_animation(float (*fx_func)(float start, float end, float perc),
		float destination, float anim_duration, bool loop, bool reverse, float delay);
	void end_animation();
	void stop_loop(bool wait_reverse = true);

	bool isintask();
	void reverse();
	void setpause_afteranim(float pause_time);
	void setresetvalue_afterloop(bool reset);
	void linear(float destination, float anim_duration, bool loop = false, bool reverse = false, float delay = 0.f);
	void bounce_back(float destination, float anim_duration, bool loop = false, bool reverse = false, float delay = 0.f);
	void smooth(float destination, float anim_duration, bool loop = false, bool reverse = false, float delay = 0.f);
	void accelerate(float destination, float anim_duration, bool loop = false, bool reverse = false, float delay = 0.f);
	void sinking(float destination, float anim_duration, bool loop = false, bool reverse = false, float delay = 0.f);

};


ImTextureID DownloadImage(std::string url);
void set_d3d_device(ID3D11Device* d3d11_device);



namespace perlin {
	extern int numX;
	extern int numY;
	extern int numOctaves;
	extern double persistence ;

	extern int primeIndex;

	extern int primes[10][3];

	double Noise(int i, int x, int y);
	double SmoothedNoise(int i, int x, int y);
	double Interpolate(double a, double b, double x);
	double InterpolatedNoise(int i, double x, double y);
	double ValueNoise_2D(double x, double y);
}



namespace ukit {


	struct element_anim {
		Anim box;
		Anim color;
		Anim anim_0;
		Anim anim_1;
		Anim anim_2;
		Anim* anims;
		D3DCOLOR temp_color;
	};
	struct element_properties {
		element_anim ele_anim;
		bool MouseClicked[5];
		bool MouseDown[5];
		bool MouseReleased[5];
		bool mouse_hovered;
		bool mouse_left;
		bool clicked;
		bool isHovering;
		float fvalue;
		int ivalue;
		int ivalue_1;
		int ivalue_2;
		bool bvalue;
		bool bvalue_1;

		std::vector<int> ivalues;
	};

	void refresh();
	ImVec2 CalculateImgFit(ImVec2 size, ImVec2 fit, bool clipping, ImVec2* offset = 0, ImVec2* uv_min = 0, ImVec2* uv_max = 0);
	ImVec2 GetImageDimension(ImTextureID image);
	ImVec2 DrawImageFit(ImDrawList* drwl, ImTextureID image, ImVec2 pos, ImVec2 size, bool clipping = true, bool clipping_centered = true, float rounding = 0.f, ImU32 tint_col = 0xFFFFFFFF, ImDrawCornerFlags rounding_corners = 0);
	D3DCOLOR ColorGradient(D3DCOLOR c1, D3DCOLOR c2, float trans, bool abgr2argb = true);
	float ColorBrightness(D3DCOLOR color);
	D3DCOLOR ColorDim(D3DCOLOR color, float dim);
	D3DCOLOR ABGR2ARGB(D3DCOLOR color);
	
	element_properties* GetLastItemProperties();
	bool IsLastItemHovering();
	bool IsLastItemMouseHovered();
	bool IsLastItemMouseLeft();
	bool IsLastItemClicked();

	void KeepAlive(const char* text_id);
	bool AddButton(ImDrawList* drwl, const char* text, float text_size, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR text_color, float rounding = 0.f);
	
	bool AddOptions(ImDrawList* drwl, const char* text, const char** options, int count, int*selected, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR background_hover, D3DCOLOR text_color, D3DCOLOR text_color_hover, float rounding = 0.f, D3DCOLOR outline = 0, D3DCOLOR outline_hover = 0);

	bool AddMagicButton(ImDrawList* drwl, const char* text, float text_size, float shake, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR text_color, D3DCOLOR outline = 0);
	
	bool AddMagicButtonRound(ImDrawList* drwl, const char* text, float text_size, float shake, ImVec2 center,
		float radius, D3DCOLOR background, D3DCOLOR text_color, D3DCOLOR outline = 0);

	void AddLoadingRoundMatrix(ImDrawList* drwl, const char *text_id,
		ImVec2 center, float radius, float thickness, D3DCOLOR color);
	void AddProgressRound(ImDrawList* drwl, const char *text_id,
		ImVec2 center, float radius, float progress, D3DCOLOR color = ukit::ABGR2ARGB(0xFF00bb6e), float anim_delay=1000.f);
	void DrawMSCheatLogo(ImDrawList* drwl, ImVec2 center, float radius, float thickness, D3DCOLOR color, float fill_color = 0.f, D3DCOLOR logo_color = 0);
	bool AddCheckMark(ImDrawList* drwl, const char* text_id, bool is_active,
		ImVec2 center, float radius, D3DCOLOR color, float thickness, float anim_time=500.f);
	
	void AddSpinningBalls(ImDrawList* drwl, const char* text_id,
		ImVec2 center, int count, float radius, float width, D3DCOLOR color, float duration);

	void DrawPages(const char* text_id, ImVec2 size, PageDrawFunction* pages_draw_functions, int pages_count, int& current_page, bool vertical=false);
}


#endif


