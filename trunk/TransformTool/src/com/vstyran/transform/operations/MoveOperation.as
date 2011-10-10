package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
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
		 * Flag indicates whether movement should be fitted into grid if it is specified. 
		 */		
		public var maintainGrid:Boolean = true;
		
		/**
		 * Flag indicates whether movement should be fitted into bounds if it is specified. 
		 */		
		public var maintainBounds:Boolean = true;
		
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
		public function startOperation(data:DisplayData, point:Point, grid:GridData = null, bounds:Bounds = null):void
		{
			if(maintainGrid)
				this.grid = grid;
			
			if(bounds)
				this.bounds = bounds;
			
			startData = data;
			startPoint = MathUtil.roundPoint(point);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			
			var m:Matrix = new Matrix();
			m.rotate(data.rotation*Math.PI/180);
			var p:Point = m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			data.x = startData.x + p.x;
			data.y = startData.y + p.y;
			
			DataUtil.fitPosition(data, grid, bounds);
			
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