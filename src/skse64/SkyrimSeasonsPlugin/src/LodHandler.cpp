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

			default: Season = "Spring";
			
		}
		
		if (CopyFile((static_cast<std::string>(installLocation.c_str()) + "/" + Season + "/" + static_cast<std::string>(folderLocation.c_str())).c_str(), (static_cast<std::string>(installLocation.c_str()) + "/" + static_cast<std::string>(folderLocation.c_str())).c_str(), false) != 0)
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
	
	RE::EventResult MenuOpenCloseEventHandler::ReceiveEvent(RE::MenuOpenCloseEvent* a_event, RE::BSTEventSource<RE::MenuOpenCloseEvent>* a_dispatcher)
	{

		using RE::EventResult;

		static RE::UI* ui = RE::UI::GetSingleton();
		static RE::BGSSaveLoadManager* saveManager = RE::BGSSaveLoadManager::GetSingleton();
		
		if(!a_event || a_event->menuName != "Main Menu" || !a_event->isOpening)
		{
			return EventResult::kContinue;
		}

		RE::IMenu* menu = ui->GetMenu(a_event->menuName).get();
		if(menu)
		{

			saveManager->Load("DynamicSeasonsSave");
			
		}
		
		return EventResult::kContinue;
	}

	MenuOpenCloseEventHandler g_menuOpenCloseEventHandler;

}