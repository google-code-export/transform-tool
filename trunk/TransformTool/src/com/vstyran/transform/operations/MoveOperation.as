package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MoveOperation implements IOperation
	{
		include "../Version.as";
		
		public function MoveOperation()
		{
		}
		
		protected var startData:DisplayData;
		protected var startPoint:Point;
		
		public function initOperation(data:DisplayData, point:Point):void
		{
			startData = data;
			startPoint = MathUtil.roundPoint(point);
		}
		
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