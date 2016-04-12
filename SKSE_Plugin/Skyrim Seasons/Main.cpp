#include "skse/PluginAPI.h"
#include "skse/skse_version.h"
#include <ShlObj.h>

#include "Main.h"

static PluginHandle g_pluginHandle = kPluginHandle_Invalid;
static SKSEPapyrusInterface * g_papyrus = NULL;

extern "C"
{

	bool SKSEPlugin_Query(const SKSEInterface * skse, PluginInfo * info)
	{

		gLog.OpenRelative(CSIDL_MYDOCUMENTS, "\\My Games\\Skyrim\\SKSE\\MyPluginScript.log");
		gLog.SetPrintLevel(IDebugLog::kLevel_Error);
		gLog.setLogLevel(IDebugLog::kLevel_DebugMessage);

		_MESSAGE("MyPluginScript");

	}

}