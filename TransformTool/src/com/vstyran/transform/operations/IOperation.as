package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.geom.Point;

	/**
	 * Interface for transform operations.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public interface IOperation
	{
		/**
		 * Initiate operation, called when user starts transformation.
		 * 
		 * @param data Initial data of transform tool on moment of starting transformation. 
		 * @param point Initial mouse position in transform tool coordinate space
		 * on moment of starting transformation
		 */		
		function initOperation(data:TargetData, point:Point):void;
		
		/**
		 * Perform transformation.
		 *  
		 * @param point Current mouse position in transform tool coordinate space
		 * @return New data of transform tool.
		 */		
		function doOperation(point:Point):TargetData;
	}
}