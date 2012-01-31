package com.vstyran.transform.model
{
	import com.vstyran.transform.utils.MathUtil;
	
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
		 * 
		 * @see com.vstyran.transform.consts.GuidelineType
		 */			
		public function Guideline(type:String = "horizontal", value:Number = 0, fraction:Number = 0)
		{
			this.type = type;
			this.value = value;
			this.fraction = fraction;
		}
		
		/**
		 * @private 
		 */		
		private var _value:Number;

		/**
		 * Guideline direction. 
		 * Will be rounded with precision 2.
		 */
		public function get value():Number
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:Number):void
		{
			_value = MathUtil.round(value, 2);
		}

		
		/**
		 * Position. 
		 * @see com.vstyran.transform.consts.GuidelineType
		 */		
		public var type:String;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
		
		/**
		 * User specific data.
		 */	
		public var userData:Object;
	}
}