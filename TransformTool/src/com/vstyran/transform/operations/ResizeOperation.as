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
			var rad:Number = (360-startData.rotation)*Math.PI/180;
			var sin:Number = Math.sin(rad);
			var cos:Number = Math.cos(rad);	
			var deltaX:Number = Math.floor((point.x - startPoint.x)*cos - (point.y - startPoint.y)*sin);
			var deltaY:Number = Math.floor((point.x - startPoint.x)*sin + (point.y - startPoint.y)*cos);
			
			/*var c:Number = anchor.x/(startData.width-anchor.x)*deltaX;
			data.x = startData.x  - c;
			data.width = c + deltaX + startData.width;*/
			
			var k:Number = anchor.x/startData.width;
			
			var znak:Number = startPoint.x > anchor.x ? 1 : -1;
			data.width =  startData.width + (point.x - startPoint.x) * znak;
			
			data = centerAroundAnchor(data);
			//var newAnckorX:Number =  Math.round(k * data.width);
			//data.x -= ;
			
			//var converter:Converter = new Converter(null, null, startData);
			
		/*	var m:Matrix = new Matrix();
			m.rotate(startData.rotation*Math.PI/180);*/
			
			//var p:Point = converter.transformPoint(new Point(newAnckorX - anchor.x, 0));
		/*	var p:Point = m.transformPoint(new Point(newAnckorX - anchor.x, 0));
			data.x = startData.x - p.x;
			data.y = startData.y - p.y;*/
			//data.x = startData.x - (newAnckorX - anchor.x);
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