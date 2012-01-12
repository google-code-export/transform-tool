package com.vstyran.transform.operations
{
	import flash.geom.Point;

	/**
	 * Interface for transform operations that uses anchor.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public interface IAncorOperation extends IOperation
	{
		/**
		 * Setter for anchor point.
		 *  
		 * @param point Position of anchor.
		 */		
		function set anchor(point:Point):void;
	}
}