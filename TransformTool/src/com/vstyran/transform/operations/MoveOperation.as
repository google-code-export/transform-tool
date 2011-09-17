package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MoveOperation implements IOperation
	{
		public function MoveOperation()
		{
		}
		
		protected var startData:TargetData;
		protected var startPoint:Point;
		
		public function initOperation(data:TargetData, point:Point):void
		{
			startData = data;
			startPoint = MathUtil.roundPoint(point);
		}
		
		public function doOperation(point:Point):TargetData
		{
			var data:TargetData = startData.clone();
			
			var m:Matrix = new Matrix();
			m.rotate(data.rotation*Math.PI/180);
			var p:Point = m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			data.x = startData.x + p.x;
			data.y = startData.y + p.y;
			
			return data;
		}
	}
}