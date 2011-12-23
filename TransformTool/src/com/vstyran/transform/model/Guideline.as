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
		 * Constructor.
		 *  
		 * @param type Guideline type
		 * @param value position
		 * @param fraction Max delta value that can be guided.
		 */			
		public function Guideline(type:String = "horizontal", value:Number = 0, fraction:Number = 0)
		{
			this.type = type;
			this.value = value;
			this.fraction = fraction;
		}
		
		/**
		 * Guideline direction. 
		 */		
		public var value:Number;
		
		/**
		 * Position. 
		 */		
		public var type:String;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
	}
}