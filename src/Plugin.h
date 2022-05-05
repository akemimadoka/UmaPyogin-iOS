#ifndef UMAPYOGIN_IOS_PLUGIN_H
#define UMAPYOGIN_IOS_PLUGIN_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct UmaPyoginPref {
	bool Enabled;
	bool UnlockFPS;
} UmaPyoginPref;

void InitHook(void* unityFramework, const UmaPyoginPref* pref);

#ifdef __cplusplus
}
#endif

#endif
