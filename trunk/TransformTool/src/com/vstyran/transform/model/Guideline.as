package com.vstyran.transform.model
{
	import flashx.textLayout.formats.Direction;

	[Bindable]
	/**
	 * Value object for guideline.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class Guideline
	{
		/**
		 * Vertical direction of guideline. 
		 */		
		public static const VERTICAL:String = "vertical"
		
		/**
		 * Horizontal direction of guideline. 
		 */
		public static const HORIZONTAL:String = "horizontal"
			
		/**
		 * Constructor.
		 *  
		 * @param direction Guideline direction
		 * @param value position
		 */			
		public function Guideline(direction:String = "horizontal", value:Number = 0)
		{
			this.direction = direction;
			this.value = value;
		}
		
		/**
		 * Guideline direction. 
		 */		
		public var value:Number;
		
		/**
		 * Position. 
		 */		
		public var direction:String;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
	}
}