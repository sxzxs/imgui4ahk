// imgui_dll.cpp : Defines the exported functions for the DLL.
//

#include "pch.h"
#include "framework.h"
#include "imgui_dll.h"


// This is an example of an exported variable
IMGUIDLL_API int nimguidll=0;

// This is an example of an exported function.
IMGUIDLL_API int fnimguidll(void)
{
    return 0;
}

// This is the constructor of a class that has been exported.
Cimguidll::Cimguidll()
{
    return;
}
 int WinMain(  
    _In_  HINSTANCE hInstance,  
    _In_  HINSTANCE hPrevInstance,  
    _In_  LPSTR lpCmdLine,  
    _In_  int nCmdShow  
  )  
{  
  
	 printf("hello world");
    return 0;  
}  
#include <stdio.h>
#include <stddef.h>
 
struct S {
    char c;
    double d;
};

int offset(void)
{
    //printf("the first element is at offset %zu\n", offsetof(struct S, c));
	printf("the double is at offset %zu\n", offsetof(struct ImGuiStyle, WindowTitleAlign));
    return 0;
}
 
EXTERN_DLL_EXPORT ImTextureID ImageFromURL(const char* url);
int main(void)
{
	offset();
	return 0;
}

