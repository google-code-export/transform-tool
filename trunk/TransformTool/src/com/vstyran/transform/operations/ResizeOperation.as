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
			
			var deltaPoint:Point = TransformUtil.roundPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			//trace(deltaPoint)
			var scaleX:Number = 1 + deltaPoint.x/(startPoint.x-anchor.x);
			var newWidth:Number = data.width*scaleX;
			
			trace("old " + scaleX);
			
			var deltaW:Number = Math.round(newWidth - startData.width);
			
			if(Math.floor(deltaW/2) != deltaW/2)
				deltaW = Math.round(deltaW/2) > deltaW/2 ? deltaW + 1 : deltaW - 1; 
			trace(deltaW);
			
			scaleX = Math.abs(deltaW > 0 ? (startData.width + deltaW)/startData.width : scaleX);
			trace("new " + scaleX);

			var m:Matrix = new Matrix();
			m.rotate(-startData.rotation*Math.PI/180);
			m.translate(-anchor.x, -anchor.y);
			m.scale(scaleX, 1);
			m.translate(anchor.x, anchor.y);
			m.rotate(startData.rotation*Math.PI/180);	
			m.translate(startData.x, startData.y);
			
			var pos:Point = m.transformPoint(new Point(0,0));
			data.x = Math.round(pos.x*100)/100;
			data.y = Math.round(pos.y*100)/100;
			data.width = Math.round(startData.width*scaleX*100)/100;
			
			
			/*var deltaPoint:Point = new Point(point.x - startPoint.x, point.y - startPoint.y);
			
			data.width = startData.width + startData.width/(startPoint.x-anchor.x) * deltaPoint.x;
			data = centerAroundAnchor(data);*/
			
			return data;
		}
		
		public function centerAroundAnchor(data:TargetData):TargetData
		{
			
			var newAnchor:Point = new Point(anchor.x/startData.width*data.width, anchor.y/startData.height*data.height);
			
			
			var m:Matrix = new Matrix();
			m.rotate(data.rotation*Math.PI/180);
			var p:Point = m.transformPoint(new Point(newAnchor.x - anchor.x, newAnchor.y - anchor.y));
			data.x = startData.x - p.x;
			data.y = startData.y - p.y;
			
			//trace("old: " + startLocalAnchor.toString() + " new: " + newLocalAnchor.toString());
			
			
			/*var m1:Matrix = getMatrix(startData, null);
			var newAnchor:Point = TransformUtil.roundPoint(m1.transformPoint(newLocalAnchor));
		//	trace(newAnchor.toString());
			
			data.x = Math.round(startAnchor.x - Math.cos(startData.rotation*Math.PI/180)*newLocalAnchor.x);
			data.y = Math.round(startAnchor.y - Math.cos(startData.rotation*Math.PI/180)*newLocalAnchor.y);*/
			
			/*data.x = startData.x + startAnchor.x - newAnchor.x;
			data.y = startData.y + startAnchor.y - newAnchor.y;*/
			
			//trace("x: " + data.x + " y: " + data.y);
			return data;
		}
		
		
	}
}