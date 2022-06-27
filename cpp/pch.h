// pch.h: This is a precompiled header file.
// Files listed below are compiled only once, improving build performance for future builds.
// This also affects IntelliSense performance, including code completion and many code browsing features.
// However, files listed here are ALL re-compiled if any one of them is updated between builds.
// Do not add files here that you will be updating frequently as this negates the performance advantage.

#ifndef PCH_H
#define PCH_H

#define EXTERN_DLL_EXPORT extern "C" __declspec(dllexport)

// add headers that you want to pre-compile here
#include "framework.h"
#include <stdio.h>

#define NDEBUG

//#define STBI_ONLY_PNG
//#define STBI_ONLY_JPEG
//#define STBI_ONLY_BMP
//#define STBI_ONLY_GIF

#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx11.h"
#include <d3d11.h>
#include "std_image.h"

#define DIRECTINPUT_VERSION 0x0800
#include <dinput.h>
#include <tchar.h>


#include "Anim.h"
#include "base_engine.h"
#endif //PCH_H
