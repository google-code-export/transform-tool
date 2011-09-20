package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class AnchorOperation implements IAncorOperation
	{
		include "../Version.as";
		
		[Bindable]
		public var anchor:Point;
		
		
		protected var startAnchor:Point;
		protected var startData:TargetData;
		protected var startPoint:Point;
		
		public function AnchorOperation()
		{
		}
		
		public function initOperation(data:TargetData, point:Point):void
		{
			startData = data;
			startPoint = MathUtil.roundPoint(point);
			if(anchor)
				startAnchor =  MathUtil.floorPoint(anchor.clone(), 2)
			else
				startAnchor =  MathUtil.floorPoint(new Point(startData.width/2, startData.height/2));	
		}
		
		public function doOperation(point:Point):TargetData
		{
			return null;
		}
	}
}