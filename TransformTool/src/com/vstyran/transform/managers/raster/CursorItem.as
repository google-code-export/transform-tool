package com.vstyran.transform.managers.raster
{
	import com.vstyran.transform.controls.Control;

	public class CursorItem
	{
		public function CursorItem()
		{
		}
		
		public var control:Control;
		
		public var cusrsor:Class;
		
		public var priority:int = 2;
		
		public var xOffset:Number = 0;
		
		public var yOffset:Number = 0;
		
		public var cursorID:Number = -1;
	}
}