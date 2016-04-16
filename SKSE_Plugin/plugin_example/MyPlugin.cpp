#include "MyPlugin.h"
#include <windows.h>
#include "skse/Utilities.h"

typedef BOOL(WINAPI* CreateSymbolicLinkProc) (LPCSTR, LPCSTR, DWORD);

namespace MyPluginNamespace {
	float ChangeSeasonLodDirectory(StaticFunctionTag *base, UInt32 n, std::string s)
	{

		HMODULE h;
		CreateSymbolicLinkProc CreateSymbolicLink_func;
		LPCSTR link = s.c_str();
		LPCSTR target = s.c_str();
		DWORD flag = 0x1;
		h = LoadLibrary("kernel32");
		CreateSymbolicLink_func = (CreateSymbolicLinkProc)GetProcAddress(h, "CreateSymbolicLink");
		if (CreateSymbolicLink_func == NULL)
		{

			fprintf(stderr, "CreateSymbolicLinkA not available\n");

		}
		else
		{
			
			if ((*CreateSymbolicLink_func)(link, target, flag) == 0)
			{

				fprintf(stderr, "CreateSymbolicLink failed: %d\n", GetLastError());

			}

		}

		
		if (n == 1) // spring
		{


			
		}
		else if (n == 2) // summer
		{



		}
		else if (n == 3) // autumn
		{



		}
		else // winter
		{



		}

		return (float)n;
	}

	bool RegisterFuncs(VMClassRegistry* registry) {
		registry->RegisterFunction(
			new NativeFunction2 <StaticFunctionTag, float, UInt32, std::string>("ChangeSeasonLodDirectory", "MyPluginScript", MyPluginNamespace::ChangeSeasonLodDirectory, registry));

		return true;
	}
} 
