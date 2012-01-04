package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	
	import flash.geom.Point;

	/**
	 * Interface for transform operations.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public interface IOperation
	{
		/**
		 * Start operation, called when user starts transformation.
		 * 
		 * @param data Initial data of transform tool on moment of starting transformation. 
		 * @param point Initial mouse position in transform tool coordinate space
		 * on moment of starting transformation
		 * @param grid Grid that will be used as step size for operations. 
		 * @param guidelines Guidelines that can make influence on transformation. 
		 * @param bounds Bounds that will boundaries for operations. 
		 */		
		function startOperation(data:DisplayData, point:Point, grid:GridData = null, bounds:Bounds = null, guidelines:Vector.<Guideline> = null):void;
		
		/**
		 * Perform transformation.
		 *  
		 * @param point Current mouse position in transform tool coordinate space
		 * @return New data of transform tool.
		 */		
		function doOperation(point:Point):DisplayData;
		
		/**
		 * End transformation.
		 *  
		 * @param point Current mouse position in transform tool coordinate space
		 * @return New data of transform tool.
		 */		
		function endOperation(point:Point):DisplayData;
		
		/**
		 * Guidelines that currently active.
		 */		
		function get guideCross():GuidelineCross;
		
		/**
		 * Type of transformation.
		 * 
		 * @see com.vstyran.transform.consts.TransformationType
		 */		
		function get type():String;
	}
}