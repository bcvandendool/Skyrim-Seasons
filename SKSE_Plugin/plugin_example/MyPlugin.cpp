#include "MyPlugin.h"
#include <windows.h>
#include "skse/Utilities.h"

typedef BOOL(WINAPI* CreateSymbolicLinkProc) (LPCSTR, LPCSTR, DWORD);

namespace MyPluginNamespace {
	float ChangeSeasonLodDirectory(StaticFunctionTag *base, UInt32 newSeason, BSFixedString installLocation, BSFixedString folderLocation)
	{

		HMODULE h;
		CreateSymbolicLinkProc CreateSymbolicLink_func;
		DWORD flag = 0x1;
		h = LoadLibrary("kernel32");
		std::string Season;
		if (newSeason == 1) { Season = "Spring"; }
		if (newSeason == 2) { Season = "Summer"; }
		if (newSeason == 3) { Season = "Autumn"; }
		if (newSeason == 4) { Season = "Winter"; }
		CreateSymbolicLink_func = (CreateSymbolicLinkProc)GetProcAddress(h, "CreateSymbolicLink");
		if (CreateSymbolicLink_func == NULL)
		{

			fprintf(stderr, "CreateSymbolicLinkA not available\n");
			return 0;

		}

		std::string baseLoc = (std::string)(char *)installLocation.data + (std::string)(char *)folderLocation.data;
		std::string seasonLoc = (std::string)(char *)installLocation.data + Season + (std::string)(char *)folderLocation.data;

		if ((*CreateSymbolicLink_func)(baseLoc.c_str(), seasonLoc.c_str(), flag) == 0)
		{

			fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());
			return -1;

		}

		return (float)newSeason;
	}

	bool RegisterFuncs(VMClassRegistry* registry) {
		registry->RegisterFunction(
			new NativeFunction3 <StaticFunctionTag, float, UInt32, BSFixedString, BSFixedString>("ChangeSeasonLodDirectory", "SeasonChanger", MyPluginNamespace::ChangeSeasonLodDirectory, registry));
		
		return true;
	}
} 
