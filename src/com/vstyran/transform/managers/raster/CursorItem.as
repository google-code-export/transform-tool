package com.vstyran.transform.managers.raster
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.namespaces.tt_internal;
	
	/**
	 * Value object for bitmap cursor item.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class CursorItem
	{
		/**
		 * Constructor. 
		 */		
		public function CursorItem()
		{
		}
		
		/**
		 * Control which uses this cursor. 
		 */		
		public var control:Control;
		
		/**
		 * Class for cursor image.  
		 */		
		public var cursor:Class;
		
		/**
		 * Integer that specifies the priority level of the cursor. Possible values are CursorManagerPriority.HIGH, CursorManagerPriority.MEDIUM, and CursorManagerPriority.LOW. 
		 */		
		public var priority:int = 2;
		
		/**
		 * Number that specifies the x offset of the cursor, in pixels, relative to the mouse pointer.
		 */
		public var xOffset:Number = 0;
		
		/**
		 * Number that specifies the y offset of the cursor, in pixels, relative to the mouse pointer. 
		 */		
		public var yOffset:Number = 0;
		
		/**
		 * Cursor id. 
		 */		
		tt_internal var cursorID:Number = -1;
	}
}