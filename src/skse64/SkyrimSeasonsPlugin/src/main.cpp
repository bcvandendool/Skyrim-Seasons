//#include "common/IDebugLog.h"  // IDebugLog
#include "skse64_common/skse_version.h"  // RUNTIME_VERSION

#include "version.h"  // VERSION_VERSTRING, VERSION_MAJOR

#include "SKSE/API.h"
#include "LodHandler.h"
#include "RE/UI.h"
#include "skse64/PluginAPI.h"

static SKSEMessagingInterface* g_messaging = nullptr;

void MessageHandler(SKSEMessagingInterface::Message* a_msg)
{

	if(a_msg->type == SKSEMessagingInterface::kMessage_DataLoaded)
	{

		RE::UI* ui = RE::UI::GetSingleton();
		ui->AddEventSink(&LodHandler::g_menuOpenCloseEventHandler);
		_MESSAGE("Menu open/close event handler sinked");
		
	}
	
}

extern "C" {
	bool SKSEPlugin_Query(const SKSE::QueryInterface* a_skse, SKSE::PluginInfo* a_info)
	{
		SKSE::Logger::OpenRelative(FOLDERID_Documents, L"\\My Games\\Skyrim Special Edition\\SKSE\\SkyrimSeasonsPlugin.log");
		SKSE::Logger::SetPrintLevel(SKSE::Logger::Level::kDebugMessage);
		SKSE::Logger::SetFlushLevel(SKSE::Logger::Level::kDebugMessage);
		SKSE::Logger::UseLogStamp(true);

		_MESSAGE("SkyrimSeasonsPlugin v%s", SSP_VERSION_VERSTRING);

		a_info->infoVersion = SKSE::PluginInfo::kVersion;
		a_info->name = "SkyrimSeasonsPlugin";
		a_info->version = SSP_VERSION_MAJOR;
		
		if (a_skse->IsEditor()) {
			_FATALERROR("Loaded in editor, marking as incompatible!\n");
			return false;
		}

		switch (a_skse->RuntimeVersion()) {
		case RUNTIME_VERSION_1_5_97:
			break;
		default:
			_FATALERROR("Unsupported runtime version %08X!\n", a_skse->RuntimeVersion());
			return false;
		}

		return true;
	}


	bool SKSEPlugin_Load(const SKSE::LoadInterface* a_skse)
	{
		_MESSAGE("SkyrimSeasonsPlugin loaded");

		if (!SKSE::Init(a_skse)) {
			return false;
		}

		auto papyrus = SKSE::GetPapyrusInterface();
		if(papyrus->Register(LodHandler::RegisterFuncs))
		{

			_MESSAGE("Papyrus function registration succesful");
			
		} else
		{

			_FATALERROR("Papyrus function registration failed");
			return false;
			
		}

		g_messaging = static_cast<SKSEMessagingInterface*>(a_skse->QueryInterface(SKSE::InterfaceID::kMessaging));
		if(g_messaging->RegisterListener(a_skse->GetPluginHandle(), "SKSE", MessageHandler))
		{

			_MESSAGE("Messaging interface registration succesful");
			
		} else
		{

			_FATALERROR("Messaging interface registration failed!\n");
			return false;
			
		}
		
		return true;
	}
};
