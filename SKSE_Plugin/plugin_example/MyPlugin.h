#include "skse/PapyrusNativeFunctions.h"
#include <string>

namespace MyPluginNamespace
{
	float ChangeSeasonLodDirectory(StaticFunctionTag *base, UInt32 newSeason, UInt32 baseSeason, BSFixedString installLocation, BSFixedString folderLocation);

	bool RegisterFuncs(VMClassRegistry* registry);
}
 