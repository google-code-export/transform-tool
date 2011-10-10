package com.vstyran.transform.model
{
	import flashx.textLayout.formats.Direction;

	public class Guideline
	{
		public static const VERTICAL:String = "vertical"
			
		public static const HORIZONTAL:String = "horizontal"
			
		public function Guideline(direction:String = "horizontal", value:Number = 0)
		{
			this.direction = direction;
			this.value = value;
		}
		
		public var value:Number;
		
		public var direction:String;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
	}
}