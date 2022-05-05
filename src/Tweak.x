#include <dlfcn.h>
#include "Plugin.h"

@import Foundation;

%hook Crackify

+ (bool)isJailbroken
{
	return NO;
}

+ (bool)isCracked
{
	return NO;
}

%end

#define PrefFile @"/var/mobile/Library/Preferences/moe.madoka.UmaPyogin.plist"

static UmaPyoginPref LoadPref()
{
	UmaPyoginPref result = {
		.Enabled = true,
		.UnlockFPS = true,
	};

	NSDictionary* const pref = [NSDictionary dictionaryWithContentsOfFile:PrefFile];

	if (!pref)
	{
		NSLog(@"Pref file not found");
		return result;
	}

	NSLog(@"Pref file loaded");

	result.Enabled = [pref[@"Enabled"] boolValue];
	result.UnlockFPS = [pref[@"UnlockFPS"] boolValue];

	return result;
}

%ctor
{
	NSString* const frameworkPath = [[NSBundle mainBundle] privateFrameworksPath];
	NSString* const frameworkName = @"UnityFramework.framework/UnityFramework";
	NSString* const frameworkFullPath = [frameworkPath stringByAppendingPathComponent:frameworkName];
	const char* const frameworkFullPathCString = [frameworkFullPath UTF8String];
	void* const unityFramework = dlopen(frameworkFullPathCString, RTLD_LAZY);

	const UmaPyoginPref pref = LoadPref();

	%init;

	if (!pref.Enabled)
	{
		NSLog(@"UmaPyogin disabled");
		return;
	}

	InitHook(unityFramework, &pref);
}
