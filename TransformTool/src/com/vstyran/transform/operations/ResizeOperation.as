package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	
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
			var rad:Number = (360-startData.rotation)*Math.PI/180;
			var sin:Number = Math.sin(rad);
			var cos:Number = Math.cos(rad);	
			var deltaX:Number = Math.floor((point.x - startPoint.x)*cos - (point.y - startPoint.y)*sin);
			var deltaY:Number = Math.floor((point.x - startPoint.x)*sin + (point.y - startPoint.y)*cos);
			
			var c:Number = anchor.x/(startData.width-anchor.x)*deltaX;
			data.x = startData.x + anchor.x - c;
			data.width = c + anchor.x + deltaX;
			
			
			return data;
		}
	}
}