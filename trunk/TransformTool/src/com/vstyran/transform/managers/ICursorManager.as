package com.vstyran.transform.managers
{
	import com.vstyran.transform.controls.Control;

	public interface ICursorManager
	{
		function setCursor(control:Control):void
		function removeCursor(control:Control):void
			
		function addedToStage():void
		function removedFromStage():void
	}
}