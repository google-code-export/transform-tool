package com.vstyran.transform.operations
{
	import com.vstyran.transform.controls.IAnchor;
	import com.vstyran.transform.model.TargetData;
	
	import flash.geom.Point;

	public class AnchorOperation implements IOperation
	{
		
		
		public var anchor:IAnchor;
		public var shiftAnchor:IAnchor;
		public var altAnchor:IAnchor;
		public var ctrlAnchor:IAnchor;
		
		protected var startData:TargetData;
		protected var startPoint:Point;
		
		public function AnchorOperation()
		{
		}
		
		public function initOperation(data:TargetData, point:Point):void
		{
			startData = data;
			startPoint = point;
		}
		
		public function doOperation(point:Point):TargetData
		{
			return null;
		}
	}
}