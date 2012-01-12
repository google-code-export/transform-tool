package com.vstyran.transform.utils
{
	import flash.geom.Point;

	/**
	 * Utility class that has math methods.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class MathUtil
	{
		/**
		 * Round point. Doesn't change original point.
		 *  
		 * @param point Point that needs to be rounded. 
		 * @param precision Value that specifies how many digits after comma should be left.
		 * @return Rounded point
		 */		
		public static function roundPoint(point:Point, precision:uint = 0):Point
		{
			return new Point(round(point.x, precision), round(point.y, precision));
		}
		
		/**
		 * Floor point. Doesn't change original point.
		 *  
		 * @param point Point that needs to be floored. 
		 * @param precision Value that specifies how many digits after comma should be left.
		 * @return Floored point
		 */	
		public static function floorPoint(point:Point, precision:uint = 0):Point
		{
			return new Point(floor(point.x, precision), floor(point.y, precision));
		}
		
		/**
		 * Round number.
		 *  
		 * @param value Number that needs to be rounded. 
		 * @param precision Value that specifies how many digits after comma should be left.
		 * @return Rounded number
		 */		
		public static function round(value:Number, precision:uint = 0):Number
		{
			var p:Number = Math.pow(10, precision);
			return Math.round(value*p)/p;
		}
		
		/**
		 * Floor number.
		 *  
		 * @param value Number that needs to be floored. 
		 * @param precision Value that specifies how many digits after comma should be left.
		 * @return Floored number
		 */
		public static function floor(value:Number, precision:uint = 0):Number
		{
			var p:Number = Math.pow(10, precision);
			return Math.floor(value*p)/p;
		}
		
		/**
		 * Convert degree to radians.
		 *  
		 * @param degree Rotation in degree
		 * @return Rotation in radians
		 */		
		public static function degreeToRadian(degree:Number):Number 
		{
			return (degree * (Math.PI / 180));
		}
		
		/**
		 * Fit value into range.
		 * 
		 * @param value Value to be fitted.
		 * @param min Minimum value. Can be NaN.
		 * @param max Maximum value. Can be NaN.
		 * 
		 * @return Fitted value.
		 */		
		public static function fitValue(value:Number, min:Number, max:Number):Number 
		{
			min = !isNaN(min) ? min : value;
			max = !isNaN(max) ? max : value;
			
			return  Math.max(min, Math.min(max, value));
		}
		
		/**
		 * Fit value into grid.
		 * 
		 * @param value Value to be fitted.
		 * @param snapStart Step start value. Can be NaN.
		 * @param snapStep Step size. Can be NaN.
		 * @param fraction Max delta value that can be snapped.
		 * @return Snapped value.
		 */	
		public static function snapValue(value:Number, snapStart:Number, snapStep:Number, fraction:Number = NaN):Number
		{
			snapStart ||= 0;
			if(!isNaN(snapStep) && snapStep > 0)
			{
				if(!isNaN(fraction))
				{
					var delta:Number = (value-snapStart)%snapStep;
					if(delta <= 0 || (delta > fraction && delta < snapStep-fraction))
						return value;
				}
				
				value = Math.round((value-snapStart)/snapStep)*snapStep + snapStart;
			}
			
			return value;
		}
	}
}