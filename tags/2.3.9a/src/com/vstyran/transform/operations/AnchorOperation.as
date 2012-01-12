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
	public class AnchorOperation implements IAncorOperation
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
		 * Cross of guidelines that currently active. 
		 */	
		public var guideCross:GuidelineCross;
		
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
		public function get type():String
		{
			// to be overriden
			return null;
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
			if(anchor)
				startAnchor = new Point(anchor.x*startData.width, anchor.y*startData.height);
			else
				startAnchor =  MathUtil.floorPoint(new Point(startData.width/2, startData.height/2));	
			
			if(guideCross)
				guideCross = null;
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