#include <windows.h>
#include "RE/Skyrim.h"
#include "LodHandler.h"
#include "SKSE/API.h"

namespace LodHandler
{

	float ChangeSeasonLodDirectory(RE::StaticFunctionTag*, SInt32 newSeason, RE::BSFixedString installLocation, RE::BSFixedString folderLocation)
	{

		std::string Season;
		switch (newSeason)
		{

			case 1: Season = "Spring";
			case 2: Season = "Summer";
			case 3: Season = "Autumn";
			case 4: Season = "Winter";
			
		}
		
		if (CopyFile(((std::string)installLocation.c_str() + "/" + Season + "/" + (std::string)folderLocation.c_str()).c_str(), ((std::string)installLocation.c_str() + "/" + (std::string)folderLocation.c_str()).c_str(), false) != 0)
		{

			return 0;

		}

		return GetLastError();

	}

	bool RegisterFuncs(RE::BSScript::Internal::VirtualMachine* a_vm)
	{

		a_vm->RegisterFunction("ChangeSeasonLodDirectory", "SeasonChanger", ChangeSeasonLodDirectory);
		return true;

	}
	
}