package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.supportClasses.Converter;
	
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
			
			/*var c:Number = anchor.x/(startData.width-anchor.x)*deltaX;
			data.x = startData.x  - c;
			data.width = c + deltaX + startData.width;*/
			
			var k:Number = anchor.x/startData.width;
			
			var znak:Number  = startPoint.x > anchor.x ? 1 : -1;
			data.width +=  (point.x - startPoint.x) * znak;
			var newAnckorX:Number =  Math.round(k * data.width);
			//data.x -= ;
			
			var converter:Converter = new Converter(null, null, startData);
			
			var p:Point = converter.transformPoint(new Point(newAnckorX - anchor.x, 0)); 
			data.x = startData.x + p.x;
			return data;
		}
	}
}