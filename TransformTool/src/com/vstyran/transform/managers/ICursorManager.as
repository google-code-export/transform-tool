package com.vstyran.transform.managers
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.view.TransformTool;

	public interface ICursorManager
	{
		function setCursor(control:Control, stageX:Number, stageY:Number):void
		function removeCursor(control:Control):void
			
		function set tool(value:TransformTool):void
	}
}