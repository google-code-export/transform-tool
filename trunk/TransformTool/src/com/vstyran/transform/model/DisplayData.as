package com.vstyran.transform.model
{
	[Bindable]
	public class DisplayData
	{
		include "../Version.as";
		
		public function DisplayData()
		{
		}
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		public var rotation:Number = 0;
		
		public var minWidth:Number;
		public var minHeight:Number;
		public var maxWidth:Number;
		public var maxHeight:Number;
		
		public function clone():DisplayData
		{
			var clone:DisplayData = new DisplayData();
			clone.x = x;
			clone.y = y;
			clone.width = width;
			clone.height = height;
			clone.rotation = rotation;
			
			clone.minWidth = minWidth;
			clone.minHeight = minHeight;
			clone.maxWidth = maxWidth;
			clone.maxHeight = maxHeight;
			
			return clone;
		}
	}
}