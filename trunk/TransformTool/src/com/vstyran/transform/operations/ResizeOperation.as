package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ResizeOperation extends AnchorOperation
	{
		public function ResizeOperation()
		{
			super();
		}
		
		public var verticalEnabled:Boolean = true;
		public var horizontalEnabled:Boolean = true;
		
		override public function doOperation(point:Point):TargetData
		{
			var data:TargetData = startData.clone();
			
			var deltaPoint:Point = MathUtil.roundPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			
			if(horizontalEnabled)
			{
				var newWidth:Number = data.width + data.width*deltaPoint.x/(startPoint.x-startAnchor.x);
				data.width = MathUtil.round(newWidth,2);
			}
			if(verticalEnabled)
			{
				var newHeight:Number = data.height + data.height*deltaPoint.y/(startPoint.y-startAnchor.y);
				data.height = MathUtil.round(newHeight,2);
			}
			
			var m:Matrix = new Matrix();
			m.rotate(startData.rotation*Math.PI/180);
			
			var pos:Point = m.transformPoint(new Point(data.width*startAnchor.x/startData.width - startAnchor.x,data.height*startAnchor.y/startData.height-startAnchor.y));
			
			data.x = MathUtil.round(startData.x - pos.x, 2);
			data.y = MathUtil.round(startData.y - pos.y, 2);
					
			return data;
		}
	}
}