// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the IMGUIDLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// IMGUIDLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef IMGUIDLL_EXPORTS
#define IMGUIDLL_API __declspec(dllexport)
#else
#define IMGUIDLL_API __declspec(dllimport)
#endif

// This class is exported from the dll
class IMGUIDLL_API Cimguidll {
public:
	Cimguidll(void);
	// TODO: add your methods here.
};

extern IMGUIDLL_API int nimguidll;

IMGUIDLL_API int fnimguidll(void);
