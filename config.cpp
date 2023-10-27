#include "\vbs2\basic_defines.hpp"
#define __CurrentDir__ \vbs2\customer\plugins\falah_behaviors\

//Class necessary for VBS to load the new addon correctly
class CfgPatches
{
	class vbs2_vbs_plugins_falah_behaviors
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {
			vbs2_editor, 
			vbs2_people
		};
		modules[] =
		{
			vbs_core_content_module
		};
	};
};

// Adds btset to list of btsets which are loaded automatically
class CfgBehaviorTrees
{
	class falah_behaviors //this is an arbitrary className, it needs to be unique though
	{
		path = "\vbs2\customer\plugins\falah_behaviors\data\falah_behaviors\falah_behaviors.btset"; //This is the relative path to the BT-set file to load
		name = "falah_behaviors"; // This is the btset name duplicated in the configuration
	};
};

class vbs_functions_base;
class CfgFunctions
{
	// Macro to build a function in sripts top folder
	#define MAKE_CORE_FUNCTION(functionName)                                 \
	class fn_vbs_falah_behaviors_##functionName : vbs_functions_base                     \
	{                                                                       \
		path = __CurrentDir__\data\scripts\fn_vbs_falah_behaviors__##functionName##.sqf;  \
	}

};

// formations
class CfgFormations
{
	class West
	{
		#include "cfgFormations.hpp"
	};

	class East : West
	{
		#include "cfgFormations.hpp"
	};

	class Civ : West
	{
		#include "cfgFormations.hpp"
	};

	class Guer : West
	{
		#include "cfgFormations.hpp"
	};
};

// Defines the new order as available from the Control AI - Military
class CfgAvailableBehaviors
{
	class falah_behaviors_occupy
	{
		icon = "\vbs2\customer\plugins\falah_behaviors\data\falah_behaviors_occupy.paa";
		allowRotate = true;

		identity = "generic_team";
		displayname = "Falah FT Occupy";
		description = "Falah team occupy";				

		newOrderSubject = "NewOrder";
		
		class RootBehaviors
		{
			group[] = {"falah_behaviors", "genericRoot"};
			entity[] = {"falah_behaviors", "genericRoot"};
		};
		
		class Parameters
		{
			class orderName
			{
				displayName = "orderName";
				value = "occupy";
				type = "string";
			};
			class orderParameters
			{
				displayName = "orderParameters";
				value = "";
				type = "table";
			};
			class reportCompletedToExternal
			{
				displayName = "reportCompletedToExternal";
				value = "true";
				type = "boolean";
			};
			class debugEnabled
			{
				displayName = "debugEnabled";
				value = "false";
				type = "boolean";
			};
		};
	};
	class falah_behaviors_defend
	{
		icon = "\vbs2\customer\plugins\falah_behaviors\data\falah_behaviors_defend.paa";
		allowRotate = true;

		identity = "generic_team";
		displayname = "Falah FT Defend";
		description = "Falah team Defend";				

		newOrderSubject = "NewOrder";
		
		class RootBehaviors
		{
			group[] = {"falah_behaviors", "genericRoot"};
			entity[] = {"falah_behaviors", "genericRoot"};
		};
		
		class Parameters
		{
			class orderName
			{
				displayName = "orderName";
				value = "defend";
				type = "string";
			};
			class debugEnabled
			{
				displayName = "debugEnabled";
				value = "false";
				type = "boolean";
			};
		};
	};
	class falah_behaviors_mount
	{
		icon = "\vbs2\customer\plugins\falah_behaviors\data\falah_behaviors_mount.paa";
		allowRotate = true;

		identity = "generic_team";
		displayname = "Falah FT Mount";
		description = "Falah team Mount";				

		newOrderSubject = "NewOrder";
		
		class RootBehaviors
		{
			group[] = {"falah_behaviors", "genericRoot"};
			entity[] = {"falah_behaviors", "genericRoot"};
		};
		
		class Parameters
		{
			class orderName
			{
				displayName = "orderName";
				value = "mount";
				type = "string";
			};
			class debugEnabled
			{
				displayName = "debugEnabled";
				value = "false";
				type = "boolean";
			};
		};
	};
};
