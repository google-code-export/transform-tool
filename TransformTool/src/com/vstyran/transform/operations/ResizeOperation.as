package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.supportClasses.Converter;
	import com.vstyran.transform.utils.TransformUtil;
	
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
			var deltaPoint:Point = TransformUtil.roundPoint(m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y)));
			
			data.width = Math.round(startData.width + startData.width/(startPoint.x-startAnchor.x) * deltaPoint.x);
			data = centerAroundAnchor(data);
			
			return data;
		}
		
		public function centerAroundAnchor(data:TargetData):TargetData
		{
			
			var newLocalAnchor:Point = TransformUtil.roundPoint(new Point(startLocalAnchor.x/startData.width*data.width, startLocalAnchor.y/startData.height*data.height));
			//trace("old: " + startLocalAnchor.toString() + " new: " + newLocalAnchor.toString());
			
			
			var m1:Matrix = getMatrix(startData, null);
			var newAnchor:Point = TransformUtil.roundPoint(m1.transformPoint(newLocalAnchor));
		//	trace(newAnchor.toString());
			
			data.x = Math.round(startAnchor.x - Math.cos(startData.rotation*Math.PI/180)*newLocalAnchor.x);
			data.y = Math.round(startAnchor.y - Math.cos(startData.rotation*Math.PI/180)*newLocalAnchor.y);
			
			/*data.x = startData.x + startAnchor.x - newAnchor.x;
			data.y = startData.y + startAnchor.y - newAnchor.y;*/
			
			//trace("x: " + data.x + " y: " + data.y);
			return data;
		}
		
		
	}
}