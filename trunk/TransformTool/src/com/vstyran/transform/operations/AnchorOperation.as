package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Base class for operations that uses anchor point.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class AnchorOperation implements IAncorOperation
	{
		[Bindable]
		/**
		 * Point in transform tool coordinate space that used as anchor. 
		 */		
		public var anchorPoint:Point;
		
		/**
		 * Grid that will be used as step size for operations. 
		 */		
		public var grid:GridData;
		
		/**
		 * Bounds that will be used position boundaries. 
		 */		
		public var bounds:Bounds;
		
		/**
		 * Guidelines that can make influence on transformation. 
		 */		
		public var guidelines:Vector.<Guideline>;
		
		[Bindable]
		/**
		 * Guidelines that currently active. 
		 */	
		public var activeGuides:Vector.<Guideline>
		
		/**
		 * Anchor point at the moment of starting transformation. 
		 */	
		protected var startAnchor:Point;
		
		/**
		 * Data object of transform tool at the moment of starting transformation. 
		 */		
		protected var startData:DisplayData;
		
		/**
		 * Mouse position in transform tool coordinate space 
		 * at the moment of starting transformation.  
		 */		
		protected var startPoint:Point;
		
		/**
		 * Flag indicates whether operation should be fitted into grid if it is specified. 
		 */		
		public var maintainGrid:Boolean = true;
		
		/**
		 * Flag indicates whether operation should be fitted into bounds if it is specified. 
		 */		
		public var maintainBounds:Boolean = true;
		
		/**
		 * Flag indicates whether guidelines should be taken into account. 
		 */		
		public var maintainGuidelines:Boolean = true;
		
		/**
		 * Constructor. 
		 */		
		public function AnchorOperation()
		{
		}

		/**
		 * @inheritDoc 
		 */		
		public function startOperation(data:DisplayData, point:Point, grid:GridData = null, bounds:Bounds = null, guidelines:Vector.<Guideline> = null):void
		{
			if(maintainGrid)
				this.grid = grid;
			
			if(maintainBounds)
				this.bounds = bounds;
			
			if(maintainGuidelines)
				this.guidelines = guidelines;
			
			startData = data;
			startPoint = MathUtil.roundPoint(point);
			if(anchorPoint)
				startAnchor =  MathUtil.floorPoint(anchorPoint.clone(), 2)
			else
				startAnchor =  MathUtil.floorPoint(new Point(startData.width/2, startData.height/2));	
			
			if(activeGuides)
				activeGuides.length = 0;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function doOperation(point:Point):DisplayData
		{
			// should be overriden
			return null;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function endOperation(point:Point):DisplayData
		{
			return doOperation(point);
		}
	}
}