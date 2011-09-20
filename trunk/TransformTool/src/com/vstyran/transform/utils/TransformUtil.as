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
		include "../Version.as";
		
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
			
			data.minWidth = !isNaN(sourceData.minWidth) ? sourceData.minWidth * components[3] : NaN;
			data.minHeight = !isNaN(sourceData.minHeight) ? sourceData.minHeight * components[4] : NaN; 
			data.maxWidth = !isNaN(sourceData.maxWidth) ? sourceData.maxWidth * components[3] : NaN; 
			data.maxHeight = !isNaN(sourceData.maxHeight) ? sourceData.maxHeight * components[4] : NaN;
			
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
		
		public static function createData(target:UIComponent):TargetData
		{
			var data:TargetData = new TargetData();
			data.x = Math.round(target.x);
			data.y = Math.round(target.y);
			data.width = Math.round(target.width*target.scaleX);
			data.height = Math.round(target.height*target.scaleY);
			data.rotation = target.rotation;
			
			data.minWidth = !isNaN(target.minWidth) ? target.minWidth * target.scaleX : NaN;
			data.minHeight = !isNaN(target.minHeight) ? target.minHeight * target.scaleY : NaN;
			data.maxWidth = !isNaN(target.maxWidth) ? target.maxWidth * target.scaleX : NaN;
			data.maxHeight = !isNaN(target.maxHeight) ? target.maxHeight * target.scaleY : NaN;
			
			return data;
		}
		
		public static function createDataInContext(source:UIComponent, context:UIComponent):TargetData
		{
			return createDataByMatrix(source, getTransformationMatrix(source.parent, context));
		}
		
		public static function createDataByMatrix(source:UIComponent, matrix:Matrix):TargetData
		{
			return transformData(matrix, createData(source));
		}
		
		public static function applyData(target:UIComponent, data:TargetData, applyMinMax:Boolean = false):void
		{
			target.x = data.x;
			target.y = data.y;
			target.width = data.width/target.scaleX;
			target.height = data.height/target.scaleY;
			target.rotation = data.rotation;
			
			if(applyMinMax)
			{
				target.minWidth = !isNaN(data.minWidth) ? data.minWidth/target.scaleX : NaN;
				target.minHeight = !isNaN(data.minHeight) ? data.minHeight/target.scaleY : NaN;
				target.maxWidth = !isNaN(data.maxWidth) ? data.maxWidth/target.scaleX : NaN;
				target.maxHeight = !isNaN(data.maxHeight) ? data.maxHeight/target.scaleY : NaN;
			}
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