package com.vstyran.transform.model
{
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
		
		
		public function clone():TargetData
		{
			var clone:TargetData = new TargetData();
			clone.x = x;
			clone.y = y;
			clone.width = width;
			clone.height = height;
			clone.rotation = rotation;
			
			return clone;
		}
	}
}