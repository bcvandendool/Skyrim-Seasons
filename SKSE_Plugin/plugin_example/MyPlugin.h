#include "skse/PapyrusNativeFunctions.h"
#include <string>

namespace MyPluginNamespace
{
	float ChangeSeasonLodDirectory(StaticFunctionTag *base, UInt32 newSeason, BSFixedString installLocation, BSFixedString folderLocation);

	bool RegisterFuncs(VMClassRegistry* registry);
}
 