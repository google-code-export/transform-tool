package com.vstyran.transform.managers
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.view.TransformTool;

	/**
	 * Interface for manager that used to manage control's cursors.
	 * 
	 * @author Volodymyr Styranivskyi
	 */	
	public interface ICursorManager
	{
		/**
		 * Show cursor on stage.
		 *  
		 * @param control Control which uses cursor.
		 * @param stageX Initial position of cursor by X axis on stage coordinate space.
		 * @param stageY Initial position of cursor by Y axis on stage coordinate space.
		 */		
		function setCursor(control:Control, stageX:Number, stageY:Number):void
			
		/**
		 * Hide cursor from stage. 
		 * 
		 * @param control Control which uses cursor.
		 */			
		function removeCursor(control:Control):void
			
		/**
		 * Setter for transform tool.
		 * 
		 * @param value Transform tool which uses manager.
		 */			
		function set tool(value:TransformTool):void
	}
}