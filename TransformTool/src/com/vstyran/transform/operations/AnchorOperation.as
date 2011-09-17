package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class AnchorOperation implements IAncorOperation
	{
		
		private var _anchor:Point;

		[Bindable]
		public function get anchor():Point
		{
			return _anchor;
		}

		public function set anchor(value:Point):void
		{
			_anchor = value;
		}
		
		
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