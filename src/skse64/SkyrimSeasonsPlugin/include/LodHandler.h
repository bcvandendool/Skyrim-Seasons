#pragma once
#include "RE/BSTEvent.h"
#include "RE/MenuOpenCloseEvent.h"

namespace LodHandler
{

	bool RegisterFuncs(RE::BSScript::Internal::VirtualMachine* a_vm);

	class MenuOpenCloseEventHandler : public RE::BSTEventSink<RE::MenuOpenCloseEvent>
	{
	public:

		virtual RE::EventResult ReceiveEvent(RE::MenuOpenCloseEvent* a_event, RE::BSTEventSource<RE::MenuOpenCloseEvent>* a_dispatcher) override;
		
	};

	extern MenuOpenCloseEventHandler g_menuOpenCloseEventHandler;
	
}
