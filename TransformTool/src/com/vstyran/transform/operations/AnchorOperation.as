package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class AnchorOperation implements IAncorOperation
	{
		include "../Version.as";
		
		[Bindable]
		public var anchorPoint:Point;
		
		
		protected var startAnchor:Point;
		protected var startData:DisplayData;
		protected var startPoint:Point;
		
		public function AnchorOperation()
		{
		}
		
		public function initOperation(data:DisplayData, point:Point):void
		{
			startData = data;
			startPoint = MathUtil.roundPoint(point);
			if(anchorPoint)
				startAnchor =  MathUtil.floorPoint(anchorPoint.clone(), 2)
			else
				startAnchor =  MathUtil.floorPoint(new Point(startData.width/2, startData.height/2));	
		}
		
		public function doOperation(point:Point):DisplayData
		{
			return null;
		}
	}
}