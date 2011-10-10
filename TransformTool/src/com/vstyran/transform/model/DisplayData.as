package com.vstyran.transform.model
{
	import mx.utils.MatrixUtil;
	
	[Bindable]
	/**
	 * Value object of UI components that contains geometry info.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DisplayData
	{
		/**
		 * Position by X axis. 
		 */		
		public var x:Number = 0;
		
		/**
		 * Position by Y axis. 
		 */	
		public var y:Number = 0;
		
		/**
		 * Width of display object. 
		 */	
		public var width:Number = 0;
		
		/**
		 * Height of display object. 
		 */
		public var height:Number = 0;
		
		/**
		 * @private 
		 */		
		private var _rotation:Number = 0;
		
		/**
		 * Rotation of display object. 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 * @private
		 */
		public function set rotation(value:Number):void
		{
			_rotation = MatrixUtil.clampRotation(value);
		}
		
		
		/**
		 * Minimum value for width. 
		 */
		public var minWidth:Number;
		
		/**
		 * Minimum value for height. 
		 */
		public var minHeight:Number;
		
		/**
		 * Maximum value for width. 
		 */
		public var maxWidth:Number;
		
		/**
		 * Maximum value for height. 
		 */
		public var maxHeight:Number;
		
		/**
		 * Clone data.
		 *  
		 * @return New data object with the same values
		 */		
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
		
		/**
		 * Compare data.
		 *  
		 * @return true id data is equals
		 */		
		public function compare(value:DisplayData):Boolean
		{
			return (value &&
					value.x == x &&
					value.y == y &&
					value.width == width &&
					value.height == height &&
					value.rotation == rotation &&
					value.minWidth == minWidth &&
					value.minHeight == minHeight &&
					value.maxWidth == maxWidth &&
					value.maxHeight == maxHeight);
		}
	}
}