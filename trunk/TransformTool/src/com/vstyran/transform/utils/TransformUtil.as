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
			data.rotation = components[2]+sourceData.rotation;
			
			return data;
		}
		
		public static function getTransformationMatrix(sourceContext:DisplayObject, destContext:DisplayObject):Matrix
		{
			var m:Matrix = new Matrix();
			
			if(sourceContext)
				m = MatrixUtil.getConcatenatedMatrix(sourceContext, null);
			
			if(destContext)
			{
				var dm:Matrix = new Matrix();
				dm = MatrixUtil.getConcatenatedMatrix(destContext, null);
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
			data.width = target.width*target.scaleX;
			data.height = target.height*target.scaleY;
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
			target.width = data.width/target.scaleX;
			target.height = data.height/target.scaleY;
			target.rotation = data.rotation;
		}
		
		/*public static function getBoundsInContext(sourcePanel:DisplayObject, source:TargetData, context:DisplayObject=null):TargetData
		{
			var m:Matrix = getTransformationMatrix(sourcePanel, context);
			
			return getBoundsByMatrix(m, source);
		}
		
		public static function getBoundsByMatrix(m:Matrix, source:TargetData):TargetData
		{
			var data:TargetData = new TargetData();
			
			
			var topLeft:Point = m.transformPoint(new Point(source.x, source.y));
			var topRight:Point = m.transformPoint(new Point(source.x+source.width,source.y));
			var bottomRight:Point = m.transformPoint(new Point(source.x+source.width, source.y+source.height));
			var bottomLeft:Point = m.transformPoint(new Point(source.x, source.y+source.height));
			
			var minX:Number = Math.min(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
			var minY:Number = Math.min(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
			var maxX:Number = Math.max(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
			var maxY:Number = Math.max(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
			
			data.x = minX;
			data.y = minY;
			data.width = maxX - minX;
			data.height = maxY - minY;
			
			return data;
		}*/
	}
}