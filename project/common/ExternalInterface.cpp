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

static value iosaudio_fixinterrupt() {
	fixinterrupt();
	return alloc_null();
}
DEFINE_PRIM (iosaudio_fixinterrupt, 0);;

static value iosaudio_enableambient() {
	enableambient();
	return alloc_null();
}
DEFINE_PRIM (iosaudio_enableambient, 0);;

static value iosaudio_disableambient() {
	disableambient();
	return alloc_null();
}
DEFINE_PRIM (iosaudio_disableambient, 0);;

static value iosaudio_hasexternalmusicplaying() {
	return alloc_bool(hasexternalmusicplaying());
}
DEFINE_PRIM(iosaudio_hasexternalmusicplaying, 0);

extern "C" int extension_ios_audio_register_prims() { return 0; }