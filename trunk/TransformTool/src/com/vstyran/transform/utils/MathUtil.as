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
		include "../Version.as";
		
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
	}
}