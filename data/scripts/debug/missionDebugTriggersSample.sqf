VBS_Sample_ControlAIDebug_UnitsEnabled = [];
VBS_Sample_ControlAIDebug_UpdateSelection = {
	_map = ((findDisplay 137) displayCtrl 51);
	
	_edobj = selectedEditorObjects _map;
	// convert the editor objects into game objects
	_objects = [];
	{
		_obj = _map evalObjectArgument [_x,"VARIABLE_NAME"];
		// only add the selected item if it's an object (i.e. exclude any selected markers)
		if (typeName _obj=="object") then {
			_objects = _objects + [_obj];
			player sidechat format["Object %1.",_obj];
		};
		
	} forEach _edobj;

	{
		_enabled = [VBS_Sample_ControlAIDebug_UnitsEnabled, _x, false] call fn_vbs_tableFind;
		if (_enabled) then
		{
			VBS_Sample_ControlAIDebug_UnitsEnabled = [VBS_Sample_ControlAIDebug_UnitsEnabled, _x, false] call fn_vbs_tableInsert;
			_x receiveMessage ["SensorDebugAll", [
					"fallbackBtset", "generic_soldier",
					"reportSubject", "StopControlAIDebug"
				]
			];
		} else
		{
			VBS_Sample_ControlAIDebug_UnitsEnabled = [VBS_Sample_ControlAIDebug_UnitsEnabled, _x, true] call fn_vbs_tableInsert;
			_x receiveMessage ["SensorDebugAll", [
					"fallbackBtset", "generic_soldier",
					"reportSubject", "ControlAIDebug"
				]
			];
		};
		

	} forEach _objects;
};

// one update
VBS_Sample_ControlAIDebug_Update = {
	for "_i" from 0 to (count VBS_Sample_ControlAIDebug_UnitsEnabled)-1 step 2 do 
	{
		_unit = VBS_Sample_ControlAIDebug_UnitsEnabled select _i;
		_enabled = VBS_Sample_ControlAIDebug_UnitsEnabled select (_i + 1);
		if _enabled then {
			_unit receiveMessage ["SensorDebugAll", [
					"fallbackBtset", "generic_soldier",
					"reportSubject", "ControlAIDebug"
				]
			];
		};
	};
};

// enabled/disabled
VBS_Sample_ControlAIDebug_UpdateContinous = false;

[] spawn {
	while {true} do 
	{
		if VBS_Sample_ControlAIDebug_UpdateContinous then
		{
			[] call VBS_Sample_ControlAIDebug_Update;
			sleep 0.05;
		}
		else
		{
			sleep 1.0;
		};
	};
};

// radio trigger for selection	
_selectionTrigger = createTrigger ["EmptyDetector", [(getPos player), [-10, 1, 0]] call fn_vbs_vectorAdd];
_selectionTrigger setTriggerArea [5, 10, 0, true];
_selectionTrigger setTriggerActivation ["INDIA", "PRESENT", true];
_selectionTrigger setTriggerStatements ["this", "[] call VBS_Sample_ControlAIDebug_UpdateSelection", ""];
_selectionTrigger setTriggerText "AIDebug: Update selection";
_selectionTrigger setVariable ["MESSAGE_FORM", ""];
_selectionTrigger setVariable ["ON_ACT_STATEMENT", ""];
[_selectionTrigger] call fn_vbs_editor_trigger_import;

// radio trigger for continuous update
_contUpdateTrigger = createTrigger ["EmptyDetector", [(getPos player), [1, -10, 0]] call fn_vbs_vectorAdd];
_contUpdateTrigger setTriggerArea [10, 5, 0, true];
_contUpdateTrigger setTriggerActivation ["JULIET", "PRESENT", true];
_contUpdateTrigger setTriggerStatements ["this", "VBS_Sample_ControlAIDebug_UpdateContinous = !VBS_Sample_ControlAIDebug_UpdateContinous", ""]; 
_contUpdateTrigger setTriggerText "AIDebug: Continuous update";
_contUpdateTrigger setVariable ["MESSAGE_FORM", ""];
_contUpdateTrigger setVariable ["ON_ACT_STATEMENT", ""];
[_contUpdateTrigger] call fn_vbs_editor_trigger_import;