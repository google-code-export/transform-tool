package com.vstyran.transform.utils
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.utils.MatrixUtil;
	
	public class TransformUtil
	{
		public static function transformData(m:Matrix, sourceData:TargetData):TargetData
		{
			var data:TargetData = new TargetData();
			
			var position:Point = m.transformPoint(new Point(sourceData.x, sourceData.y));
			data.x = position.x;
			data.y = position.y;
			
			var components:Vector.<Number> = new Vector.<Number>(4);
			MatrixUtil.decomposeMatrix(components,m);
			
			data.width = sourceData.width* components[3];
			data.height = sourceData.height*components[4];
			data.rotation = components[2];
			
			return data;
		}
		
		public static function getTransformationMatrix(sourceContext:DisplayObject, destContext:DisplayObject):Matrix
		{
			var m:Matrix = new Matrix();
			
			if(sourceContext)
				m = MatrixUtil.getConcatenatedMatrix(sourceContext, null);
			
			if(destContext)
			{
				var dm:Matrix = MatrixUtil.getConcatenatedMatrix(destContext, null);
				dm.invert();
				m.concat(dm);
			}
			
			return m;
		}
		
		public static function createData(target:DisplayObject):TargetData
		{
			var data:TargetData = new TargetData();
			data.x = target.x;
			data.y = target.y;
			data.width = target.width;
			data.height = target.height;
			data.rotation = target.rotation;
			
			return data;
		}
		
		public static function createDataInContext(source:DisplayObject, context:DisplayObject):TargetData
		{
			return createDataByMatrix(source, getTransformationMatrix(source.parent, context));
		}
		
		public static function createDataByMatrix(source:DisplayObject, matrix:Matrix):TargetData
		{
			return transformData(matrix, createData(source));
		}
		
		public static function applyData(target:DisplayObject, data:TargetData):void
		{
			target.x = data.x;
			target.y = data.y;
			target.width = data.width;
			target.height = data.height;
			target.rotation = data.rotation;
		}
	}
}