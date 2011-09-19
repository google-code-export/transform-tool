package com.vstyran.transform.model
{
	[Bindable]
	public class TargetData
	{
		public function TargetData()
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
		
		public function clone():TargetData
		{
			var clone:TargetData = new TargetData();
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