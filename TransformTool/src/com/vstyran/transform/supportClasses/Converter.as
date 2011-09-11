package com.vstyran.transform.supportClasses
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Converter
	{
		public function Converter(sourcePanel:DisplayObject, targetPanel:DisplayObject, targetData:TargetData = null)
		{
			matrix = TransformUtil.getTransformationMatrix(sourcePanel, targetPanel, targetData);
		}
		
		private var matrix:Matrix;
		
		
		public function getData(source:DisplayObject):TargetData
		{
			return TransformUtil.createDataByMatrix(source, matrix);
		}
		
		public function transformPoint(point:Point):Point
		{
			return matrix.transformPoint(point);
		}
		
		public function transformData(data:TargetData):TargetData
		{
			return TransformUtil.transformData(matrix, data);
		}
	}
}