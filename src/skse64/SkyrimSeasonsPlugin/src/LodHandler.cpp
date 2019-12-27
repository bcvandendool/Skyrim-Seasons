#include <windows.h>
#include "RE/Skyrim.h"
#include "LodHandler.h"
#include "SKSE/API.h"
#include "json.hpp"

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
			_MESSAGE("recieved main menu opening event");

			using nlohmann::json;

			std::ifstream inFile("Data\\SKSE\\Plugins\\DynamicSeasons\\Changelists\\ChangeList.json");
			if(!inFile.is_open())
			{

				_ERROR("Failed to open .json file!\n");
				return EventResult::kContinue;
				
			}
			
			json j;

			try
			{

				inFile >> j;

				auto search = j.find("string");
				if(search == j.end())
				{

					_WARNING("Failed to find string within .json!\n");
					inFile.close();
					return EventResult::kContinue;
					
				}

				for(const auto& val : search.value().items())
				{
					if(val.key() == "lodchange" && val.value() == "TRUE")
					{

						j[search.key()][val.key()] = "False";
						inFile.close();
						std::ofstream o("Data\\SKSE\\Plugins\\DynamicSeasons\\Changelists\\ChangeList.json");
						o << std::setw(4) << j << std::endl;
						_MESSAGE("loading DynamicSeasonsSave");
						saveManager->Load("DynamicSeasonsSave");
						inFile.close();
						return EventResult::kContinue;
						
					} else if(val.key() == "lodchange")
					{

						_MESSAGE("lodchange not true");
						_MESSAGE(((std::string)val.value()).c_str());
						inFile.close();
						return EventResult::kContinue;
						
					}
					
				}

				_WARNING("could not find lodchange in .json");
				inFile.close();
				
			} catch (std::exception& e)
			{

				_ERROR("Failed to parse .json file!\n");
				_ERROR(e.what());
				inFile.close();
				return EventResult::kContinue;
				
			}
			
		}

		return EventResult::kContinue;
	}

	MenuOpenCloseEventHandler g_menuOpenCloseEventHandler;

}
