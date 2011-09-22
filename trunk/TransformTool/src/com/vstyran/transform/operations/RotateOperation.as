package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class RotateOperation extends AnchorOperation
	{
		include "../Version.as";
		
		public function RotateOperation()
		{
			super();
		}
		
		override public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			
			
			var initialAngle:Number =  Math.atan2(startPoint.y - startAnchor.y, startPoint.x - startAnchor.x) * 180/Math.PI;
			
			var alpha:Number =  Math.atan2(point.y - startAnchor.y, point.x - startAnchor.x) * 180/Math.PI ;
			data.rotation += alpha-initialAngle; 
			
			// calculates anchor in tool paren panel space
			var m:Matrix = new Matrix();
			m.rotate(startData.rotation * Math.PI/180);
			m.translate(startData.x, startData.y);
			var globalAnchor:Point = m.transformPoint(new Point(startAnchor.x, startAnchor.y));	
			
			// calculates position
			m = new Matrix();
			m.translate(-startAnchor.x, -startAnchor.y);
			m.rotate(data.rotation*Math.PI/180);
			m.translate(globalAnchor.x, globalAnchor.y);
			
			var pos:Point = MathUtil.roundPoint(m.transformPoint(new Point(0, 0)), 2);
			
			data.x = pos.x;
			data.y = pos.y;
			
			return data;
		}
	}
}