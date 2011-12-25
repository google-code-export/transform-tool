package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Move operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class MoveOperation implements IOperation
	{
		/**
		 * Constructor. 
		 */		
		public function MoveOperation()
		{
		}
		
		/**
		 * Grid that will be used as step size for operation. 
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
		public var guideCross:GuidelineCross
		
		/**
		 * Flag indicates whether movement should be fitted into grid if it is specified. 
		 */		
		public var maintainGrid:Boolean = true;
		
		/**
		 * Flag indicates whether movement should be fitted into bounds if it is specified. 
		 */		
		public var maintainBounds:Boolean = true;
		
		/**
		 * Flag indicates whether guidelines should be taken into account. 
		 */		
		public var maintainGuidelines:Boolean = true;
		
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
			
			if(guideCross)
				guideCross = null;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			
			// calculate new position
			var m:Matrix = new Matrix();
			m.rotate(data.rotation*Math.PI/180);
			var p:Point = m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			data.x = startData.x + p.x;
			data.y = startData.y + p.y;
			
			// fit into bounds
			DataUtil.fitData(data, bounds);
			
			// snap to guidelines
			guideCross = DataUtil.guidePosition(data, guidelines);
			
			// snap to grid in case is not snapped to guidelines
			var snapX:Boolean = !(guideCross && guideCross.vGuideline); 
			var snapY:Boolean = !(guideCross && guideCross.hGuideline); 
			DataUtil.snapData(data, grid, snapX, snapY);
			
			// recheck fitting to bounds
			DataUtil.fitData(data, bounds);
			
			// check pasive guidelines
			guideCross = DataUtil.getPreciseGuides(data, guideCross, guidelines);
			
			return data;
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