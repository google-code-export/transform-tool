package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
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
		include "../Version.as";
		
		/**
		 * Constructor. 
		 */		
		public function MoveOperation()
		{
		}
		
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
		public function initOperation(data:DisplayData, point:Point):void
		{
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
			
			return data;
		}
	}
}