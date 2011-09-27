package com.vstyran.transform.managers.raster
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.view.TransformTool;
	
	import mx.managers.CursorManager;

	use namespace tt_internal;
	
	[DefaultProperty("items")]
	/**
	 * Cursor manager for bitmap transform tool cursors. 
	 * This type of cursors can't change their rotation depends on rotation of transform tool.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class CursorManager implements ICursorManager
	{
	
		include "../../Version.as";
		
		/**
		 * Constructor. 
		 */		
		public function CursorManager()
		{
		}
		
		/**
		 * List of cursor items. 
		 */		
		public var items:Vector.<CursorItem>;
		
		/**
		 * @inheritDoc 
		 */		
		public function setCursor(control:Control, stageX:Number, stageY:Number):void
		{
			var item:CursorItem = findItem(control);
			if(item && item.cursorID == -1)
				item.cursorID = mx.managers.CursorManager.setCursor(item.cursor, item.priority, item.xOffset, item.yOffset);
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function removeCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				mx.managers.CursorManager.removeCursor(item.cursorID);
				item.cursorID = -1;
			}
		}
		
		/**
		 * @private 
		 * Find item that corresponds to control. 
		 */		
		private function findItem(control:Control):CursorItem
		{
			if(items)
			{
				for each (var item:CursorItem in items) 
				{
					if(item.control == control)
						return item;
				}
			}
			
			return null;
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function set tool(value:TransformTool):void
		{
			// TODO Auto Generated method stub
		}
	}
}