package com.vstyran.transform.managers.raster
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.managers.ICursorManager;
	
	import mx.managers.CursorManager;

	[DefaultProperty("items")]
	public class CursorManager implements ICursorManager
	{
		public function CursorManager()
		{
		}
		
		public function setCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item && item.cursorID == -1)
				item.cursorID = mx.managers.CursorManager.setCursor(item.cusrsor, item.priority, item.xOffset, item.yOffset);
		}
		
		public function removeCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				mx.managers.CursorManager.removeCursor(item.cursorID);
				item.cursorID = -1;
			}
		}
		
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
		
		public var items:Vector.<CursorItem>;
	}
}