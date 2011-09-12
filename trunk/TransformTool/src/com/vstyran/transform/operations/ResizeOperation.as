package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.supportClasses.Converter;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ResizeOperation extends AnchorOperation
	{
		public function ResizeOperation()
		{
			super();
		}
		
		override public function doOperation(point:Point):TargetData
		{
			var data:TargetData = startData.clone();
			
			var m:Matrix = new Matrix();
			m.rotate(startData.rotation*Math.PI/180);
			var deltaPoint:Point = m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			
			data.width = startData.width + startData.width/(startPoint.x-anchor.x) * deltaPoint.x;
			data = centerAroundAnchor(data);
			
			return data;
		}
		
		public function centerAroundAnchor(data:TargetData):TargetData
		{
			var m:Matrix = getMatrix(null, startData);
			var localAnchor:Point = m.transformPoint(anchor);
		
			var newLocalAnchor:Point = new Point(localAnchor.x/startData.width*data.width, localAnchor.y/startData.height*data.height);
			
			var m1:Matrix = getMatrix(startData, null);
			var newAnchor:Point = m1.transformPoint(newLocalAnchor);
			
			
			data.x = startData.x + anchor.x - newAnchor.x;
			data.y = startData.y + anchor.y - newAnchor.y;
			return data;
		}
		
		private function getMatrix(fromContext:TargetData, toContext:TargetData):Matrix
		{
			var m:Matrix = new Matrix();
			
			if(fromContext)
			{
				m.rotate(fromContext.rotation*Math.PI/180);
				m.translate(fromContext.x,fromContext.y);
			}
			
			if(toContext)
			{
				var tm:Matrix = new Matrix();
				tm.rotate(toContext.rotation*Math.PI/180);
				tm.translate(toContext.x, toContext.y);
				tm.invert();
				m.concat(tm);
			}
			
			return m;
		}
	}
}