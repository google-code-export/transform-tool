package com.vstyran.transform.supportClasses
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	public class Converter
	{
		public function Converter()
		{
		}
		
		private var matrix:Matrix;
		
		public var target:DisplayObject;
		public var source:DisplayObject;
		
		public function updateMatrix():void
		{
			var sourceContext:DisplayObject = source ? source.parent : null;
			var targetContext:DisplayObject = target ? target.parent : null;
			matrix = TransformUtil.getTransformationMatrix(sourceContext, targetContext);
		}
		
		public function getData():TargetData
		{
			return TransformUtil.createDataByMatrix(target, matrix);
		}
	}
}