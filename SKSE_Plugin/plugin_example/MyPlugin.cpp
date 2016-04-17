#include "MyPlugin.h"
#include <windows.h>
#include "skse/Utilities.h"

typedef BOOL(WINAPI* CreateSymbolicLinkProc) (LPCSTR, LPCSTR, DWORD);

namespace MyPluginNamespace {
	float ChangeSeasonLodDirectory(StaticFunctionTag *base, UInt32 newSeason, UInt32 baseSeason, BSFixedString installLocation, BSFixedString folderLocation)
	{

		HMODULE h;
		CreateSymbolicLinkProc CreateSymbolicLink_func;
		DWORD flag = 0x1;
		h = LoadLibrary("kernel32");
		CreateSymbolicLink_func = (CreateSymbolicLinkProc)GetProcAddress(h, "CreateSymbolicLink");
		if (CreateSymbolicLink_func == NULL)
		{

			fprintf(stderr, "CreateSymbolicLinkA not available\n");
			return 0;

		}
		

		if (newSeason == baseSeason)
		{

			std::string baseLoc = (std::string)(char *)installLocation.data + (std::string)(char *)folderLocation.data;

			if ((*CreateSymbolicLink_func)(baseLoc.c_str(), baseLoc.c_str(), flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}

		}
		else if (newSeason == 1) // spring
		{

			std::string baseLoc = (std::string)(char *)installLocation.data + "spring" + (std::string)(char *)folderLocation.data;

			if ((*CreateSymbolicLink_func)(baseLoc.c_str(), baseLoc.c_str(), flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}
			
		}
		else if (newSeason == 2) // summer
		{

			std::string baseLoc = (std::string)(char *)installLocation.data + "summer" + (std::string)(char *)folderLocation.data;

			if ((*CreateSymbolicLink_func)(baseLoc.c_str(), baseLoc.c_str(), flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}

		}
		else if (newSeason == 3) // autumn
		{

			std::string baseLoc = (std::string)(char *)installLocation.data + "autumn" + (std::string)(char *)folderLocation.data;

			if ((*CreateSymbolicLink_func)(baseLoc.c_str(), baseLoc.c_str(), flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}

		}
		else // winter
		{

			std::string baseLoc = (std::string)(char *)installLocation.data + "winter" + (std::string)(char *)folderLocation.data;

			if ((*CreateSymbolicLink_func)(baseLoc.c_str(), baseLoc.c_str(), flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}

		}

		return (float)newSeason;
	}

	bool RegisterFuncs(VMClassRegistry* registry) {
		registry->RegisterFunction(
			new NativeFunction4 <StaticFunctionTag, float, UInt32, UInt32, BSFixedString, BSFixedString>("ChangeSeasonLodDirectory", "SeasonChanger", MyPluginNamespace::ChangeSeasonLodDirectory, registry));

		return true;
	}
} 
