#include "MyPlugin.h"
#include <windows.h>
#include "skse/Utilities.h"

namespace MyPluginNamespace {
	float ChangeSeasonLod(StaticFunctionTag *base, UInt32 n)
	{
		DWORD flag = 0x1;
		std::string NormalDirectoryString = GetRuntimeDirectory() + "";
		LPCSTR NormalDirectory = const_cast<char *>(NormalDirectoryString.c_str());

		if (n == 1) // spring
		{

			std::string SeasonDirectoryString = GetRuntimeDirectory() + "";
			LPCSTR BaseDirectory = const_cast<char *>(SeasonDirectoryString.c_str());
			bool b = CreateSymbolicLinkA(NormalDirectory, BaseDirectory, flag);

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
			new NativeFunction1 <StaticFunctionTag, float, UInt32>("ChangeSeasonLod", "MyPluginScript", MyPluginNamespace::ChangeSeasonLod, registry));

		return true;
	}
} 
