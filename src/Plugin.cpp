#include "Plugin.h"

#include <UmaPyogin/Plugin.h>

#include <CydiaSubstrate.h>
#include <dlfcn.h>
#include <os/log.h>

namespace
{
	class IOSHookInstaller : public UmaPyogin::HookInstaller
	{
	public:
		explicit IOSHookInstaller(void* unityFramework) : m_UnityFramework(unityFramework)
		{
		}

		void InstallHook(UmaPyogin::OpaqueFunctionPointer addr,
		                 UmaPyogin::OpaqueFunctionPointer hook,
		                 UmaPyogin::OpaqueFunctionPointer* orig) override
		{
			MSHookFunction(reinterpret_cast<void*>(addr), reinterpret_cast<void*>(hook),
			               reinterpret_cast<void**>(orig));
		}

		UmaPyogin::OpaqueFunctionPointer LookupSymbol(const char* name) override
		{
			return reinterpret_cast<UmaPyogin::OpaqueFunctionPointer>(
			    dlsym(m_UnityFramework, name));
		}

	private:
		void* m_UnityFramework;
	};
} // namespace

extern "C" void InitHook(void* unityFramework, const UmaPyoginPref* pref)
{
	auto& plugin = UmaPyogin::Plugin::GetInstance();
	plugin.SetLogHandler([](UmaPyogin::Log::Level level, const char* msg) {
		os_log_with_type(OS_LOG_DEFAULT,
		                 level == UmaPyogin::Log::Level::Error ? OS_LOG_TYPE_ERROR
		                                                       : OS_LOG_TYPE_INFO,
		                 "%{public}s", msg);
	});
	plugin.LoadConfig(UmaPyogin::Config{
	    .StaticLocalizationFilePath =
	        "/private/var/mobile/Library/Application Support/UmaPyogin/static.json",
	    .StoryLocalizationDirPath =
	        "/private/var/mobile/Library/Application Support/UmaPyogin/stories",
	    .TextDataDictPath =
	        "/private/var/mobile/Library/Application Support/UmaPyogin/database/text_data.json",
	    .CharacterSystemTextDataDictPath = "/private/var/mobile/Library/Application "
	                                       "Support/UmaPyogin/database/character_system_text.json",
	    .RaceJikkyoCommentDataDictPath = "/private/var/mobile/Library/Application "
	                                     "Support/UmaPyogin/database/race_jikkyo_comment.json",
	    .RaceJikkyoMessageDataDictPath = "/private/var/mobile/Library/Application "
	                                     "Support/UmaPyogin/database/race_jikkyo_message.json",
	    .ExtraAssetBundlePath =
	        "/private/var/mobile/Library/Application Support/UmaPyogin/resources/umamusumelocalify",
	    .ReplaceFontPath = "assets/bundledassets/umamusumelocalify/fonts/MSYH.TTC",
	    .OverrideFPS = pref->UnlockFPS ? 60 : 0,
	});
	plugin.InstallHook(std::make_unique<IOSHookInstaller>(unityFramework));
}
