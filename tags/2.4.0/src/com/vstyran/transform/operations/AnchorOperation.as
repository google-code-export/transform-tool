package com.vstyran.transform.operations
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Base class for operations that uses anchor point.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class AnchorOperation extends BaseOperation
	{
		[Bindable]
		/**
		 * Anchor proportions. Will be used to calculate anchor point.
		 * </br>
		 * Formula: 
		 * </br>
		 * <code> anchorX = anchor.x &#0042; width; </code> 
		 * </br>
		 * <code> anchorY = anchor.y &#0042; height; </code>   
		 */		
		public var anchor:Point;
		
		/**
		 * Anchor point at the moment of starting transformation. 
		 */	
		protected var startAnchor:Point;
		
		/**
		 * Constructor. 
		 */		
		public function AnchorOperation()
		{
			super();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function startOperation(data:DisplayData, point:Point, grid:GridData = null, 
									   bounds:Bounds = null, guidelines:Vector.<Guideline> = null,
									   snappingFunction:Function = null):void
		{
			
			super.startOperation(data, point, grid, bounds, guidelines, snappingFunction);
			
			startPoint = MathUtil.roundPoint(point);
			if(anchor)
				startAnchor = new Point(anchor.x*startData.width, anchor.y*startData.height);
			else
				startAnchor =  MathUtil.floorPoint(new Point(startData.width/2, startData.height/2));	
		}
	}
}