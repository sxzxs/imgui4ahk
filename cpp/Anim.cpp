#include "Anim.h"

ID3D11Device* main_device;

#define M_PI           3.14159265358979323846
float perc_from_time(clock_t from, float duration, clock_t now = clock()) {

	float time_passed = (now - from);
	return time_passed / duration;
}

std::map<std::string,  ImTextureID> MapURLImage;
THREAD_DOWNLOAD_PARAM aThreadDownloadParam[500];

void set_d3d_device(ID3D11Device* d3d11_device) {
	main_device = d3d11_device;
}

int PushParamDownload(THREAD_DOWNLOAD_PARAM p) {
	//static int i = 0;
	//return i++;
	for (int i = 0; i < sizeof(aThreadDownloadParam) / sizeof(THREAD_DOWNLOAD_PARAM); i++) {
		if (aThreadDownloadParam[i].url[0] == 0) {
			return i;
		}
	}
	// out of 500 param .....;
	return -1;
}

std::string random_str(int len) {

	char* text = new char[len + 1];
	for (int i = 0; i < len; i++) {
		text[i] = (((rand() % 2) == 1) ? (rand() % (0x5A - 0x41) + 0x41) : (rand() % (0x7A - 0x61) + 0x61));
	}
	text[len] = 0;
	return text;
}

_off_t fileSize(const char* filePath) {


	struct _stat64i32 stat_buf;
	int rc = _stat(filePath, &stat_buf);
	return stat_buf.st_size;
}

#include <wininet.h>
#pragma comment(lib,"Wininet.lib")
DWORD ThreadDownloadImage(LPVOID param) {
	THREAD_DOWNLOAD_PARAM p = *(THREAD_DOWNLOAD_PARAM*)param;
	ZeroMemory(param, sizeof(THREAD_DOWNLOAD_PARAM));

	//printf("[%d] start_download - %s\n", p.seed, p.url);

	if ((p.url[0] != 'h') || (p.url[1] != 't') || (p.url[2] != 't') || (p.url[3] != 'p')) return 0;

	//srand(p.seed);

	char path[512]; char snowflake[15];
	sprintf_s(snowflake, "%d", p.seed);
	std::string file_name = random_str(30);
	file_name += snowflake;
	ZeroMemory(path, sizeof(path));
	int len = GetTempPathA(512, path);
	memcpy(&path[len], file_name.c_str(), file_name.length() + 1);

	DeleteFileA(path);

	//printf("[%d] start_download\n", p.seed);
	//printf("path: %s - %s\n", path, p.url);

	//if ((p.seed % 3) != 0) DeleteUrlCacheEntryA(p.url);
	HRESULT hr = URLDownloadToFileA(
		FALSE,
		p.url,
		path,
		0,
		NULL);
	//printf("[%d] download_done: 0x%x\n", p.seed, hr);

	if ((hr == S_OK) && (fileSize(path) != 0)) {
		//ID3D11Resource* tex_download;
		ID3D11ShaderResourceView* tex_download;
		HRESULT result;

		bool bSuccess = !FAILED(D3DX11CreateShaderResourceViewFromFileA(main_device,
			path, NULL, NULL, &tex_download, &result));
		//HRESULT result1 = D3DX11CreateTextureFromFileA(main_device, path, NULL, NULL, &tex_download, &result2);
		//bool bSuccess = (result1 == S_OK);
		DeleteFileA(path);
		//printf("[%d] success: %d\n", p.seed, bSuccess);
		//printf("[%d] tex_download: %x\n", p.seed, result1);
		if (bSuccess) {
			*p.image = tex_download;

			//ID3D11Resource* res;
			//tex_download->GetResource(&res);
		}
		else {
			//printf("Download failed: %s\n", p.url);
			//ThreadDownloadImage(param);
		}
	}

	return 0;
}

ImTextureID DownloadImage(std::string url) {

	static ImTextureID zeroImage;
	//ZeroMemory(&zeroImage, sizeof(zeroImage));
	//return zeroImage;

	const char* char_url = url.c_str();
	if ((char_url[0] != 'h') || (char_url[1] != 't') || (char_url[2] != 't') || (char_url[3] != 'p')) {
		ZeroMemory(&zeroImage, sizeof(zeroImage));
		return zeroImage;
	}

	if (MapURLImage.find(url) == MapURLImage.end()) {

		//printf("[%s]\n", url.c_str());
		//DeleteUrlCacheEntryA(char_url);

		THREAD_DOWNLOAD_PARAM tmp;
		ZeroMemory(&tmp, sizeof(tmp));

		int index = PushParamDownload(tmp);

		ImTextureID image;
		ZeroMemory(&image, sizeof(image));
		MapURLImage[url] = image;

		THREAD_DOWNLOAD_PARAM* param = &aThreadDownloadParam[index];
		memcpy(param->url, url.c_str(), url.length() + 1);
		param->image = &MapURLImage[url];
		param->seed = rand() % 1586196300;
#ifdef WIN_64
		CreateThread(0, 0, ThreadDownloadImage, (LPVOID)param, 0, 0);
#else
		CreateThread(0, 0, (LPTHREAD_START_ROUTINE)ThreadDownloadImage, (LPVOID)param, 0, 0);
#endif
		url.c_str();
	}
	else {
		return MapURLImage[url];
	}
	ZeroMemory(&zeroImage, sizeof(zeroImage));
	return zeroImage;
}

Anim::Anim() {

	value = 0.f;
	duration = 0.f;
	start = 0.f;
	dest = 0.f;
	anim_diff = 0.f;
	pause_afteranim_duration = 0.f;

	time_started = 0;
	reverse_from = 0;
	last_finish = 0;
	reversing = false;
	gonna_loop = false;
	gonna_reverse = false;
	allow_user_reverse = false;
	reset_after_loop = false;
}
void Anim::setresetvalue_afterloop(bool reset) {
	reset_after_loop = reset;
}

// if any animations running
bool Anim::isintask() {
	return (time_started != 0);
}

// should use for internal only
void Anim::begin_animation(float (*fx_func)(float start, float end, float perc),
	float destination, float anim_duration, bool loop, bool reverse, float delay) {

	if (isintask()) {
		if (gonna_loop) {
			stop_loop(false);
		}

		BEGIN_ANIM_PARAM param;
		param.fx_func = fx_func;
		param.destination = destination;
		param.anim_duration = anim_duration;
		param.loop = loop;
		param.reverse = reverse;
		param.delay = delay;

		waiting_list.push_back(param);
		return;

	}
	
	duration = anim_duration;
	start = value;
	dest = value + destination;
	calfx = fx_func;
	time_started = clock();

	if ((time_started - last_finish) < pause_afteranim_duration) {
		time_started += pause_afteranim_duration - (time_started - last_finish);
	}
	time_started += delay;

	gonna_loop = loop;
	gonna_reverse = reverse;
}

// should use for internal only
void Anim::end_animation() {
	
	value = (reversing ? start : dest);
	float old_duration = duration;
	duration = 0.f;
	time_started = 0;
	reverse_from = 0;
	anim_diff = 0.f;
	reversing = false;

	last_finish = clock();

	if (gonna_reverse) {

		if (!gonna_loop) gonna_reverse = false;
		begin_animation(calfx, start-dest, old_duration, gonna_loop, gonna_reverse, 0);
	}
	else if (gonna_loop) {
		if (reset_after_loop) {
			value = start;
			begin_animation(calfx, dest, old_duration, gonna_loop, gonna_reverse, 0);
		}else
			begin_animation(calfx, dest-start, old_duration, gonna_loop, gonna_reverse, 0);
	}
	else if (waiting_list.size() > 0){

		BEGIN_ANIM_PARAM param = waiting_list[0];
		begin_animation(param.fx_func, param.destination, param.anim_duration, param.loop, param.reverse, param.delay);
		waiting_list.erase(waiting_list.begin());
	}
}

// pause for a while after each animation
void Anim::setpause_afteranim(float pause_time) {
	pause_afteranim_duration = pause_time;
}

// stop looping the current animation
void Anim::stop_loop(bool wait_reverse) {
	gonna_loop = false;
	if (!wait_reverse) gonna_reverse = false;
}

// reverse the current animation
void Anim::reverse() {

	if (!isintask()) return;
	//if (!allow_user_reverse) return;
	if (reversing) {

		float perc = perc_from_time(time_started, duration) + anim_diff;
		float reverse_perc = perc_from_time(reverse_from, duration, time_started);
		perc = reverse_perc - perc;
		float time_diff = perc * duration;
		time_started = clock() - time_diff;

	}
	else {

		reverse_from = time_started;
		time_started = clock();
	}
	reversing = !reversing;
}

// get the value
float Anim::get() {

	if (!isintask()) return value;
	//printf("fuck");
	
	float perc = perc_from_time(time_started, duration) + anim_diff;
	
	if (perc < 0) return start;

	if ((perc < 1) && (reversing)) {

		float reverse_perc = perc_from_time(reverse_from, duration, time_started);
		perc = reverse_perc - perc;
	}

	if ((perc >= 1) || (perc < 0)) {
		end_animation();
	}
	else {
		value = calfx(start, dest, perc);
	}

	return value;
}

float fx_linear(float start, float end, float perc) {
	return start + (end - start) * perc;

}

float fx_bouce_back(float start, float end, float perc) {
	perc = -2.9166666666666665 * pow(perc, 2) + 2.9166666666666665 * perc;
	return start + (end - start) * perc;
}

float fx_smooth(float start, float end, float perc) {
	perc = -1.0817307692307694 * pow(perc, 2) + 2.0817307692307696 * perc;
	return start + (end - start) * perc;
}

float fx_accelerate(float start, float end, float perc) {
	perc = 0.8333333333333331 * pow(perc, 2) + 0.16666666666666682 * perc;
	return start + (end - start) * perc;
}

float fx_sinking(float start, float end, float perc) {
	
	static float step1 = 0.4;
	static float step2 = 0.6;

	if (perc <= 0.5) {
		perc *= 2;
		perc = -1.0817307692307694 * pow(perc, 2) + 2.0817307692307696 * perc;
		perc /= 2;
	}
	else {
		//perc = (perc-0.5)*2;
		perc = 1 - (perc-0.5)*2;
		perc = -1.0817307692307694 * pow(perc, 2) + 2.0817307692307696 * perc;
		perc = (1-perc)/2 + 0.5;
	}

	return start + (end - start) * perc;
}

// linear movement
void Anim::linear(float destination, float anim_duration, bool loop, bool reverse, float delay) {

	begin_animation(fx_linear, destination, anim_duration, loop, reverse, delay);
}

// bounce_back movement
void Anim::bounce_back(float destination, float anim_duration, bool loop, bool reverse, float delay) {

	begin_animation(fx_bouce_back, destination, anim_duration, loop, reverse, delay);
}

// smooth movement
void Anim::smooth(float destination, float anim_duration, bool loop, bool reverse, float delay) {

	begin_animation(fx_smooth, destination, anim_duration, loop, reverse, delay);
}
// accelerate movement
void Anim::accelerate(float destination, float anim_duration, bool loop, bool reverse, float delay) {

	begin_animation(fx_accelerate, destination, anim_duration, loop, reverse, delay);
}

// sinking movement
void Anim::sinking(float destination, float anim_duration, bool loop, bool reverse, float delay) {

	begin_animation(fx_sinking, destination, anim_duration, loop, reverse, delay);
}





namespace perlin {

	int numX = 128;
	int numY = 128;
	int numOctaves = 7;
	double persistence = 1;

	int primeIndex = 0;

	int primes[10][3] = {
	  { 995615039, 600173719, 701464987 },
	  { 831731269, 162318869, 136250887 },
	  { 174329291, 946737083, 245679977 },
	  { 362489573, 795918041, 350777237 },
	  { 457025711, 880830799, 909678923 },
	  { 787070341, 177340217, 593320781 },
	  { 405493717, 291031019, 391950901 },
	  { 458904767, 676625681, 424452397 },
	  { 531736441, 939683957, 810651871 },
	  { 997169939, 842027887, 423882827 }
	};

	double Noise(int i, int x, int y) {
		int n = x + y * 57;
		n = (n << 13) ^ n;
		int a = primes[i][0], b = primes[i][1], c = primes[i][2];
		int t = (n * (n * n * a + b) + c) & 0x7fffffff;
		return 1.0 - (double)(t) / 1073741824.0;
	}

	double SmoothedNoise(int i, int x, int y) {
		double corners = (Noise(i, x - 1, y - 1) + Noise(i, x + 1, y - 1) +
			Noise(i, x - 1, y + 1) + Noise(i, x + 1, y + 1)) / 16,
			sides = (Noise(i, x - 1, y) + Noise(i, x + 1, y) + Noise(i, x, y - 1) +
				Noise(i, x, y + 1)) / 8,
			center = Noise(i, x, y) / 4;
		return corners + sides + center;
	}

	double Interpolate(double a, double b, double x) {  // cosine interpolation
		double ft = x * 3.1415927,
			f = (1 - cos(ft)) * 0.5;
		return  a * (1 - f) + b * f;
	}

	double InterpolatedNoise(int i, double x, double y) {
		int integer_X = x;
		double fractional_X = x - integer_X;
		int integer_Y = y;
		double fractional_Y = y - integer_Y;

		double v1 = SmoothedNoise(i, integer_X, integer_Y),
			v2 = SmoothedNoise(i, integer_X + 1, integer_Y),
			v3 = SmoothedNoise(i, integer_X, integer_Y + 1),
			v4 = SmoothedNoise(i, integer_X + 1, integer_Y + 1),
			i1 = Interpolate(v1, v2, fractional_X),
			i2 = Interpolate(v3, v4, fractional_X);
		return Interpolate(i1, i2, fractional_Y);
	}

	double ValueNoise_2D(double x, double y) {
		double total = 0,
			frequency = pow(2, numOctaves),
			amplitude = 1;
		for (int i = 0; i < numOctaves; ++i) {
			frequency /= 2;
			amplitude *= persistence;
			total += InterpolatedNoise((primeIndex + i) % 10,
				x / frequency, y / frequency) * amplitude;
		}
		return total / frequency;
	}
}



namespace ukit {

	namespace {


		std::map<std::string, element_properties> map_properties;
		std::vector<std::string> frame_elements;

		element_properties* addProperties(std::string text) {
			element_properties ele_props;
			ZeroMemory(&ele_props, sizeof(ele_props));
			ele_props.ele_anim.temp_color = 0;
			ele_props.ele_anim.color.value = 0;
			ele_props.ele_anim.box.value = 0;
			//printf("%f\n", ele_props.ele_anim.color.get());
			map_properties[text] = ele_props;
			return &map_properties[text];
		}

		element_properties* getProperties(std::string text) {

			auto result = map_properties.find(text);
			if (result == map_properties.end()) {
				return addProperties(text);
			}
			return &result->second;
		}

		bool deleteroperties(std::string text) {
			auto result = map_properties.find(text);
			if (result == map_properties.end()) return false;
			
			map_properties.erase(result);
			return true;
		}
	}

	void refresh() {

		std::vector<std::string> gonna_delete;

		for (auto it = map_properties.begin(); it != map_properties.end(); it++) {
			bool found = false;
			for (auto ce = frame_elements.begin(); ce != frame_elements.end(); ce++) {
				//printf("%s\n", ce->c_str());
				if (*ce == it->first) {
					found = true;
					break;
				}
			}

			if (!found) {
				gonna_delete.push_back(it->first);
			}
		}

		for (auto del = gonna_delete.begin(); del != gonna_delete.end(); del++) {
			printf("%s\n", del->c_str());
			map_properties.erase(*del);
		}
		frame_elements.clear();
	}
	element_properties* GetLastItemProperties() {
		return getProperties(frame_elements.back());
	}


	bool IsLastItemHovering() {
		return GetLastItemProperties()->isHovering;
	}
	bool IsLastItemMouseHovered() {
		return GetLastItemProperties()->mouse_hovered;
	}
	bool IsLastItemMouseLeft() {
		return GetLastItemProperties()->mouse_left;
	}
	bool IsLastItemClicked() {
		return GetLastItemProperties()->clicked;
	}

	void addFrameElement(const char* text) {
		frame_elements.push_back(text);
	}


	void ElementCheckMouseEffect(element_properties* ele_props, bool bHover) {

		ele_props->mouse_hovered = false;
		ele_props->mouse_left = false;
		ele_props->clicked = false;
		if (bHover) {

			ImGuiIO& io = ImGui::GetIO();

			if (!ele_props->isHovering) {
				ele_props->isHovering = true;
				ele_props->mouse_hovered = true;
			}

			for (int i = 0; i < 5; i++) {
				ele_props->MouseClicked[i] = io.MouseClicked[i];
				ele_props->MouseReleased[i] = io.MouseReleased[i];
				ele_props->MouseDown[i] = io.MouseDown[i];
			}
			ele_props->clicked = ele_props->MouseClicked[0];
		}
		else {

			if (ele_props->isHovering) {
				ele_props->isHovering = false;
				ele_props->mouse_left = true;
				ZeroMemory(&ele_props->MouseClicked, sizeof(ele_props->MouseClicked));
				ZeroMemory(&ele_props->MouseReleased, sizeof(ele_props->MouseReleased));
				ZeroMemory(&ele_props->MouseDown, sizeof(ele_props->MouseDown));
			}
		}
	}
	void ElementCheckMouseEffect(element_properties* ele_props, ImVec2 pos, ImVec2 size) {
		bool bHover = ImGui::IsMouseHoveringRect(pos, { pos.x + size.x, pos.y + size.y }, false);
		ElementCheckMouseEffect(ele_props, bHover);
	}
	void ElementCheckMouseEffect(element_properties* ele_props, ImVec2 center, float radius) {
		ImVec2 mouse_pos = ImGui::GetIO().MousePos;
		bool bHover = sqrt(pow(mouse_pos.x - center.x, 2) + pow(mouse_pos.y - center.y, 2)) < radius;
		ElementCheckMouseEffect(ele_props, bHover);
	}

	ImVec2 GetImageDimension(ImTextureID image) {

		ID3D11ShaderResourceView* a = (ID3D11ShaderResourceView*)image;
		ID3D11Texture2D* pTextureInterface = 0;
		ID3D11Resource* res;
		a->GetResource(&res);
		res->QueryInterface<ID3D11Texture2D>(&pTextureInterface);
		D3D11_TEXTURE2D_DESC desc;
		pTextureInterface->GetDesc(&desc);
		return { float(desc.Width), float(desc.Height) };
	}
	
	ImVec2 CalculateImgFit(ImVec2 size, ImVec2 fit, bool clipping, ImVec2 *offset, ImVec2*uv_min, ImVec2*uv_max) {

		float dw = size.x / fit.x;
		float dh = size.y / fit.y;
		
		ImVec2 newSize = fit;

		if (fit.x == 0 && fit.y == 0) return size;

		if (fit.x == 0) {
			newSize.x = size.x / dh;
		}
		else if (fit.y == 0) {
			newSize.y = size.y / dw;
		}
		else {

			if (dw < dh) {
				newSize.y = size.y / dw;
			}
			else if (dw > dh) {
				newSize.x = size.x / dh;
			}

			if (!clipping) {
				offset->x = -(newSize.x - fit.x) / 2;
				offset->y = -(newSize.y - fit.y) / 2;
			}
			else {

				uv_min->x = (newSize.x - fit.x) / 2.f / newSize.x;
				uv_min->y = (newSize.y - fit.y) / 2.f / newSize.y;
				uv_max->x = 1 - uv_min->x;
				uv_max->y = 1 - uv_min->y;
				newSize = fit;
			}
		}
		return newSize;
	}

	ImVec2 DrawImageFit(ImDrawList* drwl, ImTextureID image, ImVec2 pos, ImVec2 size, bool clipping, bool clipping_centered, float rounding,  ImU32 tint_col, ImDrawCornerFlags rounding_corners) {

		if (image == 0) return { 0,0 };

		char text_id[50];
		sprintf_s(text_id, "image_%p", image);

		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;
		ElementCheckMouseEffect(ele_props, pos, size);

		Anim& anim = ele_props->ele_anim.box;
		if (!ele_props->bvalue) {
			ele_props->bvalue = true;
			anim.value = 0;
			anim.smooth(1, 150);
		}
		//size.x *= anim.get();
		//size.y *= anim.get();

		ImVec2 offset = { 0,0 }, uv_min = { 0,0 }, uv_max = { 1,1 };
		ImVec2 imgSize = GetImageDimension(image);
		ImVec2 newSize = CalculateImgFit(imgSize, size, clipping, &offset, &uv_min, &uv_max);

		if (clipping_centered) {
			pos.x += offset.x;
			pos.y += offset.y;
		}
		if (drwl) {
			if (rounding == 0.f)
				drwl->AddImage(image, pos, { pos.x + newSize.x, pos.y + newSize.y }, uv_min, uv_max, tint_col);
			else
				drwl->AddImageRounded(image, pos, { pos.x + newSize.x, pos.y + newSize.y }, uv_min, uv_max, tint_col, rounding, rounding_corners);
		}

		addFrameElement(text_id);
		return newSize;
	}

	// Value of trans is from 0 to 1
	D3DCOLOR ColorGradient(D3DCOLOR c1, D3DCOLOR c2, float trans, bool abgr2argb) {

		float argb1[4] = {
			((c1 >> 24) & 0xff),
			((c1 >> 16) & 0xff),
			((c1 >> 8) & 0xff),
			((c1) & 0xff)
		};

		float argb2[4] = {
			((c2 >> 24) & 0xff),
			((c2 >> 16) & 0xff),
			((c2 >> 8) & 0xff),
			((c2) & 0xff)
		};

		BYTE argb[4] = {
			argb1[0] + (argb2[0] - argb1[0]) * trans,
			argb1[1] + (argb2[1] - argb1[1]) * trans,
			argb1[2] + (argb2[2] - argb1[2]) * trans,
			argb1[3] + (argb2[3] - argb1[3]) * trans
		};

		for (int i = 0; i < 4; i++) {
			if (argb[i] < 0) argb[i] = 0;
			if (argb[i] > 0xFF) argb[i] = 0xFF;
		}

		if (abgr2argb) return argb[0] * 0x1000000 + argb[3] * 0x10000 + argb[2] * 0x100 + argb[1];
		return argb[0] * 0x1000000 + argb[1] * 0x10000 + argb[2] * 0x100 + argb[3];
	}

	// Return a value from 0 to 1
	float ColorBrightness(D3DCOLOR color) {

		float rgb[3] = {
			((color >> 16) & 0xff),
			((color >> 8) & 0xff),
			((color) & 0xff)
		};
		int total = 0;
		for (int i = 0; i < 3; i++)
			total += rgb[i];

		if ((rgb[0] > 0xF0) && ((rgb[1] + rgb[2]) < 0xF5)) total *= 2.5;
		if ((rgb[1] > 0xF0) && ((rgb[0] + rgb[2]) < 0xF5)) total *= 2.5;
		if ((rgb[2] > 0xF0) && ((rgb[1] + rgb[0]) < 0xF5)) total *= 2.5;

		float brightness = total / float(0xFF * 3);
		if (brightness > 1) brightness = 1;
		return brightness;
	}

	// Dim a color
	// float dim = 1.1 to increase 110%
	D3DCOLOR ColorDim(D3DCOLOR color, float dim) {

		float argb[4] = {
			((color >> 24) & 0xff),
			((color >> 16) & 0xff),
			((color >> 8) & 0xff),
			((color) & 0xff)
		};

		for (int i = 1; i < 4; i++)
			argb[i] *= dim;

		for (int i = 0; i < 4; i++) {
			argb[i] = round(argb[i]);
			if (argb[i] < 0) argb[i] = 0;
			if (argb[i] > 0xFF) argb[i] = 0xFF;
		}

		BYTE byte_argb[4];

		for (int i = 0; i < 4; i++)
			byte_argb[i] = argb[i];

		D3DCOLOR result = byte_argb[0] * 0x1000000 + byte_argb[1] * 0x10000 + byte_argb[2] * 0x100 + byte_argb[3];
		return result;
	}

	// If you stopped drawing some element
	// but you want it to keep its properties, then use this.
	void KeepAlive(const char* text_id) {
		bool is_already_exists = false;
		for (auto ce = frame_elements.begin(); ce != frame_elements.end(); ce++) {
			if (*ce == text_id) {
				is_already_exists = true;
				break;
			}
		}
		if (!is_already_exists)
			frame_elements.push_back(text_id);
	}

	// Also works for ARGB to ABGR
	D3DCOLOR ABGR2ARGB(D3DCOLOR color) {
		D3DCOLOR result = color;
		*(BYTE*)((char*)&result) = ((color >> 16) & 0xff);
		*(BYTE*)((char*)&result + 2) = ((color) & 0xff);
		return result;
	}

	void DrawPages(const char* text_id, ImVec2 size, PageDrawFunction* pages_draw_functions, int pages_count, int& current_page, bool vertical) {

		ImGui::BeginChild(std::string(std::string(text_id) + "_main_child_frame").c_str(), size, false, ImGuiWindowFlags_::ImGuiWindowFlags_NoScrollbar );
		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;
		ElementCheckMouseEffect(ele_props, ImGui::GetCursorPos(), size);

		Anim& anim = ele_props->ele_anim.box;

		if (ele_props->ivalue_2!= current_page) {
			ele_props->ivalue_2 = current_page;

			ele_props->ivalues.push_back(current_page);

		}
		if (!anim.isintask() && (ele_props->ivalues.size() > 0)) {
			

			ele_props->ivalue_1 = ele_props->ivalue;
			ele_props->bvalue = ele_props->ivalues[0] > ele_props->ivalue_1;
			ele_props->ivalue = ele_props->ivalues[0];

			anim.value = 0;
			anim.accelerate(1, 300);

			ele_props->ivalues.erase(ele_props->ivalues.begin());

		}

		if (!anim.isintask()) {

			ImGui::BeginChild(std::string(std::string(text_id) + "_main_child").c_str(), size, false, ImGuiWindowFlags_::ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_AlwaysUseWindowPadding);
			//printf("%s - %d\n", text_id, ele_props->ivalue);
			pages_draw_functions[ele_props->ivalue](current_page);
			ImGui::EndChild();
		}
		else {


			float diff_anim = anim.get();
			ImVec2 pos_1, pos_2;
			if (ele_props->bvalue) {
				if (!vertical) {
					pos_1 = { - diff_anim *0.2f* size.x, 0 };
					pos_2 = { - diff_anim * size.x + size.x, 0 };
				}
				else {
					pos_1 = { 0, -diff_anim * 0.2f * size.y };
					pos_2 = { 0, -diff_anim * size.y + size.y };
				}
			}else{
				if (!vertical) {
					pos_1 = { -0.2f*size.x + diff_anim * 0.2f * size.x, 0 };
					pos_2 = { diff_anim * size.x, 0 };
				}
				else {
					pos_1 = { 0, -0.2f * size.y + diff_anim * 0.2f * size.y };
					pos_2 = { 0, diff_anim * size.y};
				}
			}


			D3DCOLOR bk_color = ImGui::GetStyle().Colors[ImGuiCol_ChildBg];
			D3DCOLOR fade_color = bk_color;
			*(BYTE*)((char*)&fade_color + 3) = 0;


			ImGui::SetCursorPos(pos_1);
			ImGui::BeginChild(std::string(std::string(text_id) + "_main_child1").c_str(), size, false, ImGuiWindowFlags_::ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_AlwaysUseWindowPadding);
			
			if (!ele_props->bvalue)
				pages_draw_functions[ele_props->ivalue](current_page);
			else
				pages_draw_functions[ele_props->ivalue_1](current_page);

			ImVec2 win_pos = ImGui::GetWindowPos();
			ImVec2 win_size = ImGui::GetWindowSize();

			D3DCOLOR shadow_color = (ele_props->bvalue ? ColorGradient(0x00000000, 0x55000000, diff_anim) : ColorGradient(0x55000000, 0x00000000, diff_anim));
			ImGui::GetWindowDrawList()->AddRectFilled(win_pos, { win_pos.x + win_size.x, win_pos.y + win_size.y }, shadow_color);

			win_pos.x -= pos_1.x;
			win_pos.y -= pos_1.y;
			win_pos.x += pos_2.x;
			win_pos.y += pos_2.y;


			ImGui::GetWindowDrawList()->AddRectFilledMultiColor(win_pos,
				{ win_pos.x - 30, win_pos.y + win_size.y },
				0x55000000, 0x00000000, 0x00000000, 0x55000000);;

			ImGui::EndChild();


			ImGui::SetCursorPos(pos_2);
			ImGui::BeginChild(std::string(std::string(text_id) + "_main_child2").c_str(), size, false, ImGuiWindowFlags_::ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_AlwaysUseWindowPadding);

			if (ele_props->bvalue)
				pages_draw_functions[ele_props->ivalue](current_page);
			else
				pages_draw_functions[ele_props->ivalue_1](current_page);


			ImGui::EndChild();

		}
		ImGui::EndChild();
		addFrameElement(text_id);
	}

	bool AddMagicButton(ImDrawList* drwl, const char* text, float text_size, float shake, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR text_color, D3DCOLOR outline) {

		bool clicked	= false;
		ImVec2 mouse_pos = ImGui::GetIO().MousePos;

		bool bHover = ImGui::IsMouseHoveringRect(pos, { pos.x + size.x, pos.y + size.y }, false);


		element_properties* ele_props = getProperties(text);
		element_anim* ele_anim = &ele_props->ele_anim;

		D3DCOLOR color = ColorGradient(background, ele_anim->temp_color, ele_anim->color.get(), false);
		//D3DCOLOR color = ColorGradient(background, 0, 0);

		ele_props->mouse_hovered = false;
		ele_props->mouse_left = false;
		if (bHover) {

			ImGuiIO& io = ImGui::GetIO();

			if (!ele_props->isHovering) {
				ele_props->mouse_hovered = true;
				ele_props->isHovering = true;
				D3DCOLOR new_color = ((ColorBrightness(background) > 0.87) ? ColorDim(background, 0.85) : new_color = ColorDim(background, 1.2));
				ele_anim->temp_color = new_color;
				ele_anim->color.end_animation();
				ele_anim->color.smooth(1, 250);
			}
			for (int i = 0; i < 5; i++) {
				ele_props->MouseClicked[i] = io.MouseClicked[i];
				ele_props->MouseReleased[i] = io.MouseReleased[i];
				ele_props->MouseDown[i] = io.MouseDown[i];
			}
			//if (ele_props->MouseClicked[0]) {
			//	ele_anim->box.smooth(radius / 30, 50, false, true);
			//	clicked = true;
			//}

			if (ImGui::GetIO().MouseDown[0]) {
				color = ColorDim(color, 0.9);
			}

		}
		else {

			if (ele_props->isHovering) {
				ele_props->mouse_left = true;
				ele_props->isHovering = false;
				ele_anim->color.end_animation();
				ele_anim->color.smooth(-1, 150);
				ZeroMemory(&ele_props->MouseClicked, sizeof(ele_props->MouseClicked));
				ZeroMemory(&ele_props->MouseReleased, sizeof(ele_props->MouseReleased));
				ZeroMemory(&ele_props->MouseDown, sizeof(ele_props->MouseDown));
			}
		}


		float diff_btn= ele_anim->box.get();
		float angle = ele_props->fvalue;
		static const int steps = 60;
		ImVec2 points[steps];

		static float phase = 0;
		float radius = (size.x + size.y) / 2;

		shake += ele_anim->color.get() / 1 * shake * 1.1;
		if (shake > 25) shake = 25;
		float last_cr = 0;
		float total_len = (size.x + size.y);
		float draw_len = (angle / M_PI) * total_len;

		for (int i = 0; i < steps; i++) {

			float xoff = ((cos(angle + phase) + 1.f) / 2.f) * shake;
			float yoff = ((sin(angle + phase) + 1.f) / 2.f) * shake;
			float cr = perlin::ValueNoise_2D(xoff, yoff);
			
			if (draw_len < size.x) {
				points[i] = { pos.x + draw_len, pos.y - (cr * radius / 2) };
			}
			else if ((draw_len > size.x) && (draw_len < total_len)) {
				points[i] = { pos.x + size.x + (cr * radius / 2), pos.y + draw_len - size.x };

			}else if ((draw_len > total_len) && (draw_len < total_len + size.x)){
				points[i] = { pos.x + size.x - (draw_len - total_len), pos.y + size.y + (cr * radius / 2)};
			}
			else {
				points[i] = { pos.x - (cr * radius / 2), pos.y + size.y - (draw_len - (total_len+size.x)) };

			}

			angle += M_PI * 2 / steps;
			draw_len += total_len * 2 / steps;
			if (draw_len > total_len * 2) draw_len = draw_len - (total_len * 2.f);

			phase += (((rand() % 2) == 0) ? -0.0004 : 0.0002);
			last_cr = cr;
		}
		if (angle > M_PI * 2) angle = angle - (M_PI * 2.f);

		drwl->AddConvexPolyFilled(points, steps, color);
		if (outline != 0) {
			drwl->AddPolyline(points, steps, background, true, 1);

		}

		ImFont* font = ImGui::GetFont();
		ImVec2 text_bound = font->CalcTextSizeA(text_size + ele_anim->box.get() / 2, FLT_MAX, size.x * 0.9, text);
		ImVec2 text_pos = { pos.x + size.x / 2 - text_bound.x / 2, pos.y + size.y / 2 - text_bound.y / 2 };
		drwl->AddText(font, text_size + ele_anim->box.get() / 2, text_pos, text_color, text);

		addFrameElement(text);
		ele_props->fvalue = angle;
		ele_props->clicked = clicked;

		return clicked;
	}
	bool AddMagicButtonRound(ImDrawList* drwl, const char* text, float text_size, float shake, ImVec2 center,
		float radius, D3DCOLOR background, D3DCOLOR text_color, D3DCOLOR outline) {

		element_properties* ele_props = getProperties(text);
		element_anim* ele_anim = &ele_props->ele_anim;

		D3DCOLOR color = ColorGradient(background, ele_anim->temp_color, ele_anim->color.get(), false);

		ElementCheckMouseEffect(ele_props, center, radius);

		if (ele_props->isHovering) {

			ImGuiIO& io = ImGui::GetIO();

			if (ele_props->mouse_hovered) {
				D3DCOLOR new_color = ((ColorBrightness(background) > 0.87) ? ColorDim(background, 0.85) : new_color = ColorDim(background, 1.2));
				ele_anim->temp_color = new_color;
				ele_anim->color.end_animation();
				ele_anim->color.smooth(1, 250);
			}
			if (ele_props->MouseClicked[0])
				ele_anim->box.smooth(radius / 30, 50, false, true);

			if (ele_props->MouseDown[0])
				color = ColorDim(color, 0.9);
	
		}
		else if (ele_props->mouse_left) {
			ele_anim->color.end_animation();
			ele_anim->color.smooth(-1, 150);
		}


		radius += ele_anim->box.get();
		float angle = ele_props->fvalue;
		static const int steps = 60;
		ImVec2 points1[steps];
		ImVec2 points2[steps];
		ImVec2 points3[steps];
		ImVec2 points4[steps];
		static float phase = 0;
		shake += ele_anim->color.get()/1*shake*1.1;
		if (shake > 25) shake = 25;
		float last_cr = 0;

		for (int i = 0; i < steps; i++) {


			float xoff = ((cos(angle ) + 1.f) / 2.f) * 7;
			float yoff = ((sin(angle ) + 1.f) / 2.f) * 7;
			float cr = perlin::ValueNoise_2D(xoff + phase, yoff + phase);
			cr = perlin::ValueNoise_2D(xoff+ cr*7, yoff + cr * 7);


			points1[i].x = (radius + cr * shake) * cos(angle) + center.x;
			points1[i].y = (radius + cr * shake) * sin(angle) + center.y;
			points2[i].x = (radius + cr * shake) * cos(-angle) + center.x;
			points2[i].y = (radius + cr * shake) * sin(-angle) + center.y;
			points3[i].x = (radius + cr * shake) * cos(angle - M_PI / 2) + center.x;
			points3[i].y = (radius + cr * shake) * sin(angle - M_PI / 2) + center.y;
			points4[i].x = (radius + cr * shake) * cos(-angle - M_PI / 2) + center.x;
			points4[i].y = (radius + cr * shake) * sin(-angle - M_PI / 2) + center.y;
			angle += M_PI * 2 / steps;
			if (angle > M_PI * 2) angle = angle - (M_PI * 2.f);
			
			if (ele_props->bvalue)
				phase += (((rand() % 2) == 0) ? -0.005 : 0.004);
			else
				phase += (((rand() % 2) == 0) ? -0.004 : 0.005);

			//if (phase > 14) ele_props->bvalue = true;
			//if (phase < 0) ele_props->bvalue = false;


			last_cr = cr;
		}

		drwl->AddConvexPolyFilled(points1, steps, color);
		drwl->AddConvexPolyFilled(points2, steps, color);
		drwl->AddConvexPolyFilled(points3, steps, color);
		drwl->AddConvexPolyFilled(points4, steps, color);
		//drwl->AddPolyline(points1, steps, 0xFFFFFFFF, true, 1);
		if (outline != 0) {
			drwl->AddPolyline(points1, steps, ColorDim(outline, 0.4), true, 1);
			drwl->AddPolyline(points2, steps, ColorDim(outline, 0.6), true, 1);
			drwl->AddPolyline(points3, steps, ColorDim(outline, 0.8), true, 1);
			drwl->AddPolyline(points4, steps, outline, true, 1);

		}

		ImFont* font = ImGui::GetFont();
		ImVec2 text_bound = font->CalcTextSizeA(text_size + ele_anim->box.get() / 2, FLT_MAX, radius * 2, text);
		ImVec2 text_pos = { center.x - text_bound.x / 2, center.y - text_bound.y / 2 };
		drwl->AddText(font, text_size + ele_anim->box.get() / 2, text_pos, text_color, text);

		addFrameElement(text);
		ele_props->fvalue = angle;

		return ele_props->clicked;
	}
	bool AddOptions(ImDrawList* drwl, const char*text, const char* *options, int count, int* selected, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR background_hover, 
		D3DCOLOR text_color, D3DCOLOR text_color_hover, float rounding, D3DCOLOR outline, D3DCOLOR outline_hover) {

		element_properties* ele_props = getProperties(text);
		element_anim* ele_anim = &ele_props->ele_anim;

		Anim& anim_prev = ele_anim->anim_0;
		Anim& anim_next = ele_anim->anim_1;
		Anim& anim = ele_anim->anim_2;
		float diff_btn = ele_anim->box.get();
		float diff_anim_prev = anim_prev.get();
		float diff_anim_next = anim_next.get();
		ElementCheckMouseEffect(ele_props, pos, size);

		D3DCOLOR bk_color = ColorGradient(background, background_hover, ele_anim->color.get());
		D3DCOLOR arrow_color = ColorDim(background_hover, 0.8);


		if (ele_props->ivalue_2 != *selected) {
			ele_props->ivalue_2 = *selected;

			ele_props->ivalues.push_back(*selected);

		}
		if (!anim.isintask() && (ele_props->ivalues.size() > 0)) {
			ele_props->ivalue_1 = ele_props->ivalue;
			
			if (ele_props->bvalue_1) {
				ele_props->bvalue_1 = false;
			}
			else {
				ele_props->bvalue = ele_props->ivalues[0] > ele_props->ivalue_1;
				if ((ele_props->ivalues[0] == 0) && (ele_props->ivalue_1 == count-1)) ele_props->bvalue = true;
				if ((ele_props->ivalues[0] == count - 1) && (ele_props->ivalue_1 == 0)) ele_props->bvalue = false;
			}
			ele_props->ivalue = ele_props->ivalues[0];

			anim.value = 0;
			anim.accelerate(1, 150);

			ele_props->ivalues.erase(ele_props->ivalues.begin());
		}


		if (ele_props->isHovering) {

			if (ele_props->mouse_hovered) {
				ele_anim->color.end_animation();
				ele_anim->box.end_animation();
				ele_anim->color.smooth(1, 50);
				ele_anim->box.smooth(1, 50);
			}

			if (ele_props->MouseDown[0] || ele_props->MouseDown[1]) {
				bk_color = ColorDim(background_hover, 0.8);
			}

		}
		else if (ele_props->mouse_left) {
			ele_anim->color.end_animation();
			ele_anim->box.end_animation();
			ele_anim->color.smooth(-1, 150);
			ele_anim->box.smooth(-1, 150);
		}

		ImVec2 pos_box = { pos.x - size.x / 20.f * diff_btn / 2,  pos.y - size.y / 20.f * diff_btn / 2 };
		ImVec2 size_box = { size.x + size.x / 20.f * diff_btn, size.y + size.y / 20.f * diff_btn };

		drwl->AddRectFilled(pos_box, { pos_box.x + size_box.x, pos_box.y + size_box.y }, bk_color, rounding);

		if ((outline != 0) || (outline_hover != 0)) {
			drwl->AddRect(pos_box, { pos_box.x + size_box.x, pos_box.y + size_box.y }, ColorGradient(outline, outline_hover, ele_anim->color.get()), rounding);
		}


		ImVec2 text_pos = { pos_box.x + size_box.y / 2, pos_box.y + size_box.y / 2 };

		text_color = ColorGradient(text_color, text_color_hover, ele_anim->color.get());
		float text_size = size_box.y * 0.5f + diff_btn / 2;
		ImFont* font = ImGui::GetFont();
		ImVec2 text_bound = font->CalcTextSizeA(text_size, FLT_MAX, size.x * 0.9, text);
		text_pos = { text_pos.x, text_pos.y - text_bound.y / 2 };
		drwl->AddText(font, text_size, text_pos, text_color, text);

		float text_area = 0.4f * size.x;

		float arrow_radius1 = size_box.y * 0.25f + size_box.y * 0.15f * diff_anim_prev;
		float arrow_radius2 = size_box.y * 0.25f + size_box.y * 0.15f * diff_anim_next;

		ImVec2 center_arrow = { pos_box.x + size_box.x *0.95f- diff_btn* size.x / 40.f, pos_box.y + size_box.y / 2 };

		ImVec2 points_prev[] = {
			{center_arrow.x + sinf(M_PI * 0.75f)* arrow_radius1 - text_area - arrow_radius1 / 2,
			center_arrow.y + cosf(M_PI * 0.75f) * arrow_radius1},
			{center_arrow.x - text_area - arrow_radius1 / 2, center_arrow.y},
			{center_arrow.x + sinf(M_PI * 0.25f) * arrow_radius1 - text_area - arrow_radius1 / 2,
			center_arrow.y + cosf(M_PI * 0.25f) * arrow_radius1}

		}
		;ImVec2 points_next[] = {
			{center_arrow.x + sinf(-M_PI * 0.75f) * arrow_radius2 + arrow_radius2 / 2,
			center_arrow.y + cosf(-M_PI * 0.75f) * arrow_radius2},
			{center_arrow.x + arrow_radius2 / 2, center_arrow.y},
			{center_arrow.x + sinf(-M_PI * 0.25f) * arrow_radius2 + arrow_radius2 / 2,
			center_arrow.y + cosf(-M_PI * 0.25f) * arrow_radius2}

		};

		ImVec2 mouse_pos = ImGui::GetMousePos();
		bool bHoverPrev = sqrt(pow(points_prev[1].x + size_box.y / 8 - mouse_pos.x, 2) + pow(points_prev[1].y - mouse_pos.y, 2)) < size_box.y/3;
		
		if (bHoverPrev) {
			D3DCOLOR arrow_color = ColorDim(background_hover, 0.8);
			if (ele_props->MouseDown[0]) arrow_color = ColorDim(background_hover, 0.7);
			drwl->AddCircleFilled({ points_prev[1].x+size_box.y/8, points_prev[1].y}, size_box.y/3+size_box.y/9* anim_prev.get(), arrow_color);

			if (ele_props->clicked) {
				anim_prev.smooth(1, 50, false, true);
				if (-- * selected < 0) *selected = count - 1;
				ele_props->bvalue_1 = true;
				ele_props->bvalue = false;
			}
		}
		bool bHoverNext = sqrt(pow(points_next[1].x - size_box.y / 8 - mouse_pos.x, 2) + pow(points_next[1].y - mouse_pos.y, 2)) < size_box.y / 3;

		if (bHoverNext) {
			D3DCOLOR arrow_color = ColorDim(background_hover, 0.8);
			if (ele_props->MouseDown[0]) arrow_color = ColorDim(background_hover, 0.7);
			drwl->AddCircleFilled({ points_next[1].x - size_box.y / 8, points_next[1].y }, size_box.y / 3 + size_box.y / 9 * anim_next.get(), arrow_color);

			if (ele_props->clicked) {
				anim_next.smooth(1, 50, false, true);
				if (++ * selected >= count) *selected = 0;
				ele_props->bvalue_1 = true;
				ele_props->bvalue = true;
			}
		}

		drwl->AddPolyline(points_prev, 3, text_color, false, 1.f / 30.f * size_box.y+diff_btn);
		drwl->AddPolyline(points_next, 3, text_color, false, 1.f / 30.f * size_box.y+diff_btn);

		ImVec2 option_pos = { center_arrow.x - text_area/2.f, pos_box.y + size_box.y / 2 };
		ImVec2 text_bound1 = font->CalcTextSizeA(text_size, FLT_MAX, size.x * 0.9f, options[ele_props->ivalue]);
		ImVec2 text_bound2 = font->CalcTextSizeA(text_size, FLT_MAX, size.x * 0.9f, options[ele_props->ivalue_1]);
		


		if (!anim.isintask()) {
			option_pos = { option_pos.x - text_bound1.x / 2.f, option_pos.y - text_bound1.y / 2.f };
			drwl->AddText(font, text_size, option_pos, text_color, options[ele_props->ivalue]);
		}
		else {


			float diff_anim = anim.get();
			ImVec2 pos_1, pos_2;
			float temp = option_pos.x;
			if (ele_props->bvalue) {
				option_pos = { option_pos.x - text_bound1.x / 2.f-diff_anim* text_area, option_pos.y - text_bound1.y / 2.f };
				pos_1 = option_pos;
				//pos_1 = { option_pos.x -diff_anim, 0 };
				option_pos.x = temp - text_bound2.x / 2.f - diff_anim * text_area + text_area;
				//pos_2 = { option_pos.x -diff_anim * text_bound2.x + text_bound1.x, 0 };
				pos_2 = option_pos;
			}
			else {
				option_pos = { option_pos.x - text_bound1.x / 2.f + diff_anim * text_area-text_area, option_pos.y - text_bound1.y / 2.f };
				pos_1 = option_pos;
				//pos_1 = { option_pos.x -diff_anim, 0 };
				option_pos.x = temp - text_bound2.x / 2.f + diff_anim * text_area;
				//pos_2 = { option_pos.x -diff_anim * text_bound2.x + text_bound1.x, 0 };
				pos_2 = option_pos;
			}

			if (!ele_props->bvalue) {
				drwl->AddText(font, text_size, pos_1, ColorGradient(0, text_color, diff_anim), options[ele_props->ivalue]);
				drwl->AddText(font, text_size, pos_2, ColorGradient(text_color, 0, diff_anim), options[ele_props->ivalue_1]);
			}
			else {
				drwl->AddText(font, text_size, pos_1, ColorGradient(text_color, 0, diff_anim), options[ele_props->ivalue_1]);
				drwl->AddText(font, text_size, pos_2, ColorGradient(0, text_color, diff_anim), options[ele_props->ivalue]);
			}
		}

		if (!bHoverPrev && !bHoverNext) {

			if (ele_props->clicked) {
				anim_next.smooth(1, 50, false, true);
				if (++ * selected >= count) *selected = 0;
				ele_props->bvalue_1 = true;
				ele_props->bvalue = true;
			}
			if (ele_props->MouseClicked[1]) {
				anim_prev.smooth(1, 50, false, true);
				if (-- * selected < 0) *selected = count - 1;
				ele_props->bvalue_1 = true;
				ele_props->bvalue = false;
			}
		}

		addFrameElement(text);
		return ele_props->clicked;
	}
	bool AddButton(ImDrawList* drwl, const char* text, float text_size, ImVec2 pos,
		ImVec2 size, D3DCOLOR background, D3DCOLOR foreground, float rounding) {

		element_properties* ele_props = getProperties(text);
		element_anim* ele_anim = &ele_props->ele_anim;

		float diff_btn = ele_anim->box.get();

		D3DCOLOR bk_color = ColorDim(background, 0.7);
		D3DCOLOR text_color = ColorDim(foreground, 0.9);
		text_color = ColorGradient(text_color, foreground, ele_anim->color.get());

		D3DCOLOR color = ColorGradient(bk_color, background, ele_anim->color.get(), false);
		//D3DCOLOR color = ColorGradient(background, 0, 0);

		ElementCheckMouseEffect(ele_props, pos, size);

		if (ele_props->isHovering) {

			if (ele_props->mouse_hovered) {
				ele_anim->color.end_animation();
				ele_anim->color.smooth(1, 50);
			}
			if (ele_props->MouseClicked[0])
				ele_anim->box.smooth(sqrt(size.x * size.y) / 70, 50, false, true);
			if (ele_props->MouseDown[0])
				color = ColorDim(color, 0.9);
		}
		else if (ele_props->mouse_left) {
			ele_anim->color.end_animation();
			ele_anim->color.smooth(-1, 150);
		}

		drwl->AddRectFilled({ pos.x - diff_btn, pos.y - diff_btn }, 
			{ pos.x + size.x + diff_btn * 2, pos.y + size.y + diff_btn*2 },
			color, rounding);
		drwl->AddRect({ pos.x - diff_btn, pos.y - diff_btn }, 
			{ pos.x + size.x + diff_btn * 2, pos.y + size.y + diff_btn*2 },
			background, rounding, 0, 1.f/200.f*(size.x+size.y));


		ImFont* font = ImGui::GetFont();
		ImVec2 text_bound = font->CalcTextSizeA(text_size + diff_btn / 2, FLT_MAX, size.x * 0.9, text);
		ImVec2 text_pos = { pos.x + size.x / 2 - text_bound.x / 2, pos.y + size.y / 2 - text_bound.y / 2 };
		drwl->AddText(font, text_size+ diff_btn/2, text_pos, text_color, text);
		
		addFrameElement(text);
		return ele_props->MouseClicked[0];
	}

	void scale_points_to_center(ImVec2* points, int size, float max, ImVec2 center, float radius) {

		for (int i = 0; i < size; i++) {
			points[i].x = points[i].x / max * radius - radius / 2 + center.x;
			points[i].y = points[i].y / max * radius - radius / 2 + center.y;
		}
	}

	void scale_points_to_center(ImVec2* points, int size, ImVec2 max, ImVec2 center, ImVec2 radius) {

		for (int i = 0; i < size; i++) {
			points[i].x = points[i].x / max.x * radius.x - radius.x / 2 + center.x;
			points[i].y = points[i].y / max.y * radius.y - radius.y / 2 + center.y;
		}
	}

	void DrawMSCheatLogo(ImDrawList* drwl, ImVec2 center, float radius, float thickness, D3DCOLOR color, float fill_color, D3DCOLOR logo_color) {

		bool bFill = (fill_color > 0.f);
		int points_count = 0;
		D3DCOLOR dim_color = color;
		float trans = float((dim_color >> 24) & 0xff) * 0.8;
		//printf("%f\n", trans);
		*(BYTE*)((char*)&dim_color + 3) = BYTE(trans);
		D3DCOLOR green_dark, green_light;
		if (logo_color == 0) {
			green_dark = ukit::ColorGradient(color, 0xFF03a05f, fill_color);
			green_light = ukit::ColorGradient(color, 0xFF00bb6e, fill_color);
		}
		else {
			green_light = ukit::ColorGradient(color, logo_color, fill_color);
			green_dark = ukit::ColorGradient(color, ColorDim(logo_color, 0.85), fill_color);
		}

		D3DCOLOR dark_eye = ukit::ColorGradient(color, 0xFF303030, fill_color);
		D3DCOLOR blue_eye = ukit::ColorGradient(color, 0xFFd9a634, fill_color);
		D3DCOLOR white_eye = ukit::ColorGradient(color, 0xFFffffff, fill_color);
		if (bFill) {
			ImVec2 fill_green_light1[] = {
				{54, 583},
				{666, 83},
				{419, 707},
				{179, 633},
			};
			ImVec2 fill_green_light2[] = {
				{177, 649},
				{382, 807},
				{415, 723},
			};
			ImVec2 fill_green_dark1[] = {
				{666, 83},
				{758, 863},
				{643, 818},
				{419, 707},
			};
			ImVec2 fill_green_dark2[] = {
				{633, 830},
				{382, 807},
				{415, 723},
			};

			scale_points_to_center(fill_green_light1, 4, 1000, center, radius);
			scale_points_to_center(fill_green_light2, 3, 1000, center, radius);
			scale_points_to_center(fill_green_dark1, 4, 1000, center, radius);
			scale_points_to_center(fill_green_dark2, 3, 1000, center, radius);
			drwl->AddConvexPolyFilled(fill_green_light1, 4, green_light);
			drwl->AddConvexPolyFilled(fill_green_light2, 3, green_light);
			drwl->AddConvexPolyFilled(fill_green_dark1, 4, green_dark);
			drwl->AddConvexPolyFilled(fill_green_dark2, 3, green_dark);
		}
		else {

			ImVec2 points1[] = {
				{54, 583},
				{666, 83},
				{758, 863},
				{643, 818},
				{419, 707},
				{179, 633},
			};

			points_count = sizeof(points1) / sizeof(points1[0]);
			scale_points_to_center(points1, points_count, 1000, center, radius);
			for (int i = 0; i < points_count; i++) drwl->AddLine(points1[i], points1[((i < points_count - 1) ? i + 1 : 0)], color, thickness);

			ImVec2 points2[] = {
				{177, 649},
				{382, 807},
				{633, 830},
			};

			points_count = sizeof(points2) / sizeof(points2[0]);
			scale_points_to_center(points2, points_count, 1000, center, radius);
			for (int i = 0; i < points_count - 1; i++) drwl->AddLine(points2[i], points2[i + 1], color, thickness);
		}

		ImVec2 curves[] = {
			{ 640, 364 },
			{ 645, 573 },
			{ 282, 581 },
			{ 367, 597 },
			{ 306, 509 },
			{ 264, 525 },
			{ 640, 364 },
		};
		ImVec2 cp0[] = {
			{ 640, 364 },
			{ 611, 655 },
			{ 282, 581 },
			{ 367, 597 },
			{ 306, 509 },
			{ 264, 525 },
		};
		ImVec2 cp1[] = {
			{ 705, 463 },
			{ 414, 772 },
			{ 332, 602 },
			{ 324, 571 },
			{ 264, 525 },
			{ 403, 341 },
		};

		points_count = sizeof(curves) / sizeof(curves[0]);
		scale_points_to_center(curves, points_count, 1000, center, radius);
		scale_points_to_center(cp0, points_count - 1, 1000, center, radius);
		scale_points_to_center(cp1, points_count - 1, 1000, center, radius);

		if (!bFill) {
			for (int i = 0; i < points_count - 1; i++)
				drwl->AddBezierCurve(curves[i], cp0[i], cp1[i], curves[i + 1], color, thickness);
		}
		else {
			for (int i = 0; i < points_count - 1; i++) {
				drwl->PathLineTo(curves[i]);
				drwl->PathBezierCurveTo(cp0[i], cp1[i], curves[i + 1]);
			}
			drwl->PathFillConvex(dark_eye);

			drwl->PathLineTo(curves[2]);
			drwl->PathBezierCurveTo(cp0[2], cp1[2], curves[3]);
			drwl->PathLineTo(curves[3]);
			drwl->PathBezierCurveTo(cp0[3], cp1[3], curves[4]);
			drwl->PathFillConvex(green_light);
		}

		ImVec2 curves_eye[] = {
			{550, 450},
			{458, 579},
			{356, 491},
			{391, 480},
			{457, 542},
			{522, 512},
			{506, 481},
			{550, 450},
		};
		ImVec2 cp0_eye[] = {
			{550, 450},
			{458, 577},
			{356, 491},
			{391, 480},
			{457, 542},
			{522, 512},
			{506, 458},
		};
		ImVec2 cp1_eye[] = {
			{567, 547},
			{380, 582},
			{391, 480},
			{401, 534},
			{491, 546},
			{505, 503},
			{525, 450},
		};
		points_count = sizeof(curves_eye) / sizeof(curves_eye[0]);

		scale_points_to_center(curves_eye, points_count, 1000, center, radius);
		scale_points_to_center(cp0_eye, points_count - 1, 1000, center, radius);
		scale_points_to_center(cp1_eye, points_count - 1, 1000, center, radius);
		if (!bFill) {
			for (int i = 0; i < points_count - 1; i++)
				drwl->AddBezierCurve(curves_eye[i], cp0_eye[i], cp1_eye[i], curves_eye[i + 1], dim_color, thickness);
		}
		else
		{

			ImVec2 curves_eye2[] = {
				{570, 450},
				{516, 565},
				{457, 578},
				{542, 450},
			};
			ImVec2 cp0_eye2[] = {
				{570, 450},
				{516, 565},
				{457, 578},
			};
			ImVec2 cp1_eye2[] = {
				{584, 529},
				{497, 580},
				{563, 555},
			};

			scale_points_to_center(curves_eye2, 4, 1000, center, radius);
			scale_points_to_center(cp0_eye2, 3, 1000, center, radius);
			scale_points_to_center(cp1_eye2, 3, 1000, center, radius);

			for (int i = 0; i < 4 - 1; i++) {
				drwl->PathLineTo(curves_eye2[i]);
				drwl->PathBezierCurveTo(cp0_eye2[i], cp1_eye2[i], curves_eye2[i + 1]);
			}
			drwl->PathFillConvex(ukit::ABGR2ARGB(blue_eye));


			for (int i = 0; i < points_count - 1; i++) {
				drwl->PathLineTo(curves_eye[i]);
				drwl->PathBezierCurveTo(cp0_eye[i], cp1_eye[i], curves_eye[i + 1]);
			}
			drwl->PathFillConvex(white_eye);

			for (int i = 3; i < 7; i++) {
				drwl->PathLineTo(curves_eye[i]);
				drwl->PathBezierCurveTo(cp0_eye[i], cp1_eye[i], curves_eye[i + 1]);
			}
			drwl->PathFillConvex(dark_eye);
		}

		ImVec2 circles[2] = {
			{440, 497},
			{459, 475},
		};
		scale_points_to_center(circles, 2, 1000, center, radius);

		D3DCOLOR eye_color = (bFill ? ukit::ABGR2ARGB(blue_eye) : color);
		drwl->AddCircleFilled(circles[0], 14.f / 1000.f * radius, eye_color);
		drwl->AddCircleFilled(circles[1], 8.f / 1000.f * radius, eye_color);


	}
	
	void AddLoadingRoundMatrix(ImDrawList* drwl, const char* text_id,
		ImVec2 center, float radius, float thickness, D3DCOLOR color) {

		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;

		Anim& anim_tick = ele_anim->box;
		float diff_tick = anim_tick.get();
		if (!anim_tick.isintask())
			anim_tick.linear(M_PI, 50, false, false, 100);

		drwl->PathArcTo(center, radius, M_PI / 2 - diff_tick / 2, M_PI / 2 + diff_tick / 2, 60);
		drwl->PathStroke(color, false, thickness / 2);

		addFrameElement(text_id);
	}

	bool AddCheckMark(ImDrawList* drwl, const char* text_id, bool is_active,
		ImVec2 center, float radius, D3DCOLOR color, float thickness, float anim_time) {

		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;

		Anim& anim_tick1 = ele_anim->box;
		Anim& anim_tick2 = ele_anim->color;
		Anim& anim_tick3 = ele_anim->anim_0;

		float diff_tick1 = anim_tick1.get();
		float diff_tick2 = anim_tick2.get();
		float diff_tick3 = anim_tick3.get();

		ImVec2 points[3] = {
			{ 6, 35 }, { 30, 56 },{ 78, 3 }
		};
		if (diff_tick1 > 0) {

			int size = 3;
			points[1].x = points[0].x + (points[1].x - points[0].x)*diff_tick1;
			points[1].y = points[0].y + (points[1].y - points[0].y)*diff_tick1;

			if (diff_tick1 == 1) {

				points[2].x = points[1].x + (points[2].x - points[1].x) * diff_tick2;
				points[2].y = points[1].y + (points[2].y - points[1].y) * diff_tick2;
			}
			else {
				size = 2;
			}
			scale_points_to_center(points, 3, { 80,61 }, center, { radius, radius / 1.31147540984f });
			//drwl->AddLine(points[0], points[1], color, 10);
			//drwl->AddLine(points[1], points[2], color, 10);
			drwl->AddPolyline(points, size, color, false, thickness);
		}
		if (diff_tick3 > 0) {
			drwl->PathArcTo(center, radius, M_PI / 2-diff_tick3/2, M_PI / 2 + diff_tick3 / 2, 35);
			drwl->PathStroke(color, false, thickness / 2);
		}


		if ((!ele_props->bvalue && is_active) ||
			(ele_props->bvalue && !is_active) ){

			float dist1 = sqrt(pow(points[1].x - points[0].x, 2) + pow(points[1].y - points[0].y, 2));
			float dist2 = sqrt(pow(points[1].x - points[0].x, 2) + pow(points[1].y - points[0].y, 2));
			float total_dist = dist1 + dist2;

			float cm_time = anim_time * 0.4;
			float circle_time = anim_time - cm_time;

			if (!ele_props->bvalue) {
				anim_tick1.linear(1, dist1 / total_dist * cm_time, false, false, circle_time);
				anim_tick2.linear(1, dist2 / total_dist * cm_time, false, false, dist1 / total_dist * cm_time + circle_time);
				anim_tick3.smooth(M_PI * 2, circle_time);
			}
			else {

				anim_tick3.smooth(-M_PI * 2, circle_time, false, false, cm_time);
				anim_tick2.linear(-1, dist2 / total_dist * cm_time, false, false, dist1 / total_dist * cm_time);
				anim_tick1.linear(-1, dist1 / total_dist * cm_time);
			}

			ele_props->bvalue = !ele_props->bvalue;
		}

		addFrameElement(text_id);
		return ((anim_tick1.isintask() || anim_tick2.isintask() || anim_tick3.isintask()) || (ele_props->bvalue));
	}
	void AddSpinningBalls(ImDrawList* drwl, const char* text_id,
		ImVec2 center, int count, float radius, float width, D3DCOLOR color, float duration) {

		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;

		if (ele_props->bvalue == false) {
			ele_props->bvalue = true;
			ele_props->ivalue = count;
			ele_props->ele_anim.anims = new Anim[count];
			for (int i = 0; i < count; i++) {
				ele_props->ele_anim.anims[i].setresetvalue_afterloop(true);
				ele_props->ele_anim.anims[i].setpause_afteranim(duration*2.5);
				ele_props->ele_anim.anims[i].smooth(M_PI * 2, duration, true, false, duration/count*2 * i);
			}
		}


		for (int i = 0; i < count; i++) {
			float value = ele_props->ele_anim.anims[i].get();
			if ((value > 0) && (value < M_PI * 2))
				drwl->AddCircleFilled({ center.x - sin(-value) * radius, center.y - cos(-value) * radius },
					width, color);
		}
		addFrameElement(text_id);
	}

	void AddProgressRound(ImDrawList* drwl, const char *text_id, ImVec2 center,
		float radius, float progress, D3DCOLOR color, float anim_delay) {
		
		bool clicked = false;
		bool bHover = ImGui::IsMouseHoveringRect({ center.x - radius, center.y - radius },
			{ center.x + radius, center.y + radius }, false);

		element_properties* ele_props = getProperties(text_id);
		element_anim* ele_anim = &ele_props->ele_anim;

		Anim& anim_logo = ele_anim->box;
		Anim& anim_progress = ele_anim->color;
		Anim& anim_color = ele_anim->anim_0;
		Anim& anim_opening = ele_anim->anim_1;

		if (anim_opening.get() == 0) anim_opening.smooth(M_PI, 400);

		float diff_opening = anim_opening.get();
		radius = radius * 0.6 + (radius * 0.4f)* diff_opening / M_PI;
		float circle_mid = M_PI/2.f;

		color = ColorGradient(color, ColorDim(color, 1.2), anim_logo.get(), false);

		drwl->PathArcTo(center, radius, circle_mid-diff_opening, circle_mid + diff_opening, 45);
		drwl->PathStroke(ukit::ABGR2ARGB(0x22888888), false, 1.f/100.f*radius);

		drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius*0.9, circle_mid - diff_opening, circle_mid + diff_opening, 40);
		drwl->PathFillConvex(ukit::ABGR2ARGB(0xff1e2025));

		drwl->PathArcTo(center, radius * 0.9, circle_mid - diff_opening, circle_mid + diff_opening, 40);
		drwl->PathStroke(ukit::ABGR2ARGB(0xff16171a), false, 1.f / 150.f * radius);


		//drwl->PathClear();
		// progress
		//drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius * (0.73 + anim_logo.get()/50), M_PI / 2, M_PI / 2 + anim_progress.get(), 50);
		drwl->PathStroke(color, false, radius*0.05);

		drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius * 0.73, circle_mid - diff_opening, circle_mid + diff_opening, 40);
		drwl->PathFillConvex(ukit::ABGR2ARGB(0xff23252b));

		int tick_steps = 60;
		float tick_radius_outer = radius * 0.71;
		float tick_radius_inner = radius * 0.67;
		float tick_angle = 0.f;
		//bool is_bypass_tick = false;
		bool is_bypass_tick = !anim_opening.isintask();
		for (int i = 0; i < tick_steps; i++) {
			D3DCOLOR tick_color = 0xFF444444;

			if (is_bypass_tick) {
				if (tick_angle < anim_progress.get()) tick_color = color;
				drwl->AddLine({ center.x + sin(-tick_angle) * tick_radius_outer,
				center.y + cos(-tick_angle) * tick_radius_outer },
					{ center.x + sin(-tick_angle) * tick_radius_inner,
					center.y + cos(-tick_angle) * tick_radius_inner }, tick_color, 1.f / 200.f * radius);
			}
			else if ((((circle_mid - diff_opening) < tick_angle - circle_mid) && ((circle_mid + diff_opening) > tick_angle - circle_mid))) {

				//if (tick_angle > anim_progress.get()) tick_color = color;
				drwl->AddLine({ center.x - sin(-tick_angle) * tick_radius_outer,
					center.y - cos(-tick_angle) * tick_radius_outer },
					{ center.x - sin(-tick_angle) * tick_radius_inner,
					center.y - cos(-tick_angle) * tick_radius_inner }, tick_color, 1.f / 200.f * radius);
			}
			tick_angle += M_PI * 2 / tick_steps;
		}

		drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius * 0.58, circle_mid - diff_opening, circle_mid + diff_opening, 35);
		drwl->PathFillConvex(ukit::ABGR2ARGB(0xff25282f));

		drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius * 0.416, circle_mid - diff_opening, circle_mid + diff_opening, 35);
		drwl->PathFillConvex(ukit::ABGR2ARGB(0xff1f2126));

		drwl->PathLineTo(center);
		drwl->PathArcTo(center, radius * 0.375, circle_mid - diff_opening, circle_mid + diff_opening, 30);
		drwl->PathFillConvex(ukit::ABGR2ARGB(0xff17191c));

		std::string id_spinning_balls = std::string(text_id) + "_spinningballs";
		AddSpinningBalls(drwl, id_spinning_balls.c_str(), center, 30, radius * 0.52, 1.f / 100.f * radius, 0x88DDDDDD, 1500);

		if (is_bypass_tick) {

			if (!anim_logo.isintask()) anim_logo.smooth(1, 2000, false, true, 1000);
			float progress_perc = anim_progress.get() / M_PI / 2;
			bool is_progress_done = (progress_perc >= 1);
			if (is_progress_done || ele_props->bvalue) {
				std::string id_check_mark = std::string(text_id) + "_checkmark";

				bool is_animating = AddCheckMark(drwl, id_check_mark.c_str(), is_progress_done, center, radius * 0.375, color, 10.f / 300.f * radius);
				if (!ele_props->bvalue) ele_props->bvalue = true;
				if (ele_props->bvalue) ele_props->bvalue = is_animating;
				if (!ele_props->bvalue) {
					anim_logo.stop_loop(true);
					anim_logo.end_animation();
					if (anim_logo.isintask()) anim_logo.end_animation();
				}
			}
			else {

				D3DCOLOR replace_color = 0;
				if (color != ukit::ABGR2ARGB(0xFF00bb6e))
					replace_color = ukit::ABGR2ARGB(color);
				float diff_anim = anim_logo.get();
				if (diff_anim > 0)DrawMSCheatLogo(drwl, center, radius * 0.6667, 1, 0xff16171a, diff_anim, replace_color);
				DrawMSCheatLogo(drwl, center, radius * 0.6667, 1, ukit::ColorGradient(0xff353841, 0x00000000, diff_anim));

			}
			ele_props->ivalue = (progress_perc >= 1) ? 1 : 0;
		}
		else {

			DrawMSCheatLogo(drwl, center, radius * 0.6667, 1, ukit::ColorGradient(0x00000000, 0xff353841, diff_opening/M_PI));
		}
		

		if (ele_props->fvalue != progress) {
			float new_progress = progress / 100 * M_PI * 2;
			float current_progress = anim_progress.get();
			anim_progress.end_animation();
			anim_progress.value = current_progress;
			anim_progress.smooth(new_progress - current_progress, anim_delay);
		}
		ele_props->fvalue = progress;
		addFrameElement(text_id);
	}

}