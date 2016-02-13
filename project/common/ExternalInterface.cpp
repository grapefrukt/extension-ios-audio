#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <stdio.h>
#include <hxcpp.h>
#include "OpenFLIOSAudio.h"


using namespace openfliosaudio;

static value iosaudio_enableduck()
{
	#ifdef IPHONE
	enableduck();
	#endif
	return alloc_null();
}
DEFINE_PRIM (iosaudio_enableduck, 0);;

static value iosaudio_disableduck()
{
	#ifdef IPHONE
	disableduck();
	#endif
	return alloc_null();
}
DEFINE_PRIM (iosaudio_disableduck, 0);;

static value iosaudio_hasexternalmusicplaying()
{
	#ifdef IPHONE
	return alloc_bool(hasexternalmusicplaying());
	#else
	return alloc_null();
	#endif
}
DEFINE_PRIM(iosaudio_hasexternalmusicplaying, 0);


extern "C" int extension_ios_audio_register_prims() { return 0; }