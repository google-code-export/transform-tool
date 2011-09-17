package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class AnchorOperation implements IAncorOperation
	{
		
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
			startAnchor = MathUtil.floorPoint(anchor.clone(), 2)
		}
		
		public function doOperation(point:Point):TargetData
		{
			return null;
		}
	}
}