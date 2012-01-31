package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Point;
	
	/**
	 * Base class for operations.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class BaseOperation implements IOperation
	{
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
		 * User-supplied snapping function. 
		 */		
		public var snappingFunction:Function;
		
		/**
		 * Constructor. 
		 */		
		public function BaseOperation()
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
		public function startOperation(data:DisplayData, point:Point, grid:GridData = null, 
									   bounds:Bounds = null, guidelines:Vector.<Guideline> = null,
									   snappingFunction:Function = null):void
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
			
			this.snappingFunction = snappingFunction;
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
		
		/**
		 * Run user snapping function if it's exsist. 
		 * 
		 * @param operation Current operation.
		 * @param data Current display data.
		 * @param anchor Anchor point at the moment of starting transformation.
		 * 
		 * @return display data if snapped; otherwise null.
		 */
		protected function invokeSnappingFunction(operation:IOperation, data:DisplayData, anchor:Point):DisplayData
		{
			try
			{
				if(snappingFunction != null)
					return snappingFunction(operation, data, anchor);
			} 
			catch(error:Error) 
			{
				return null;
			}
			
			return null;
		}
	}
}