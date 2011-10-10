package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Resize operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class ResizeOperation extends AnchorOperation
	{
		/**
		 * Constructor. 
		 */		
		public function ResizeOperation()
		{
			super();
		}
		
		/**
		 * Flag that indicates whether vertical resizing is enebled. 
		 */		
		public var verticalEnabled:Boolean = true;
		
		/**
		 * Flag that indicates whether horizontal resizing is enebled. 
		 */
		public var horizontalEnabled:Boolean = true;
		
		/**
		 * Flag that indicates whether aspect ratio should be kept. 
		 */
		public var maintainAspectRatio:Boolean = false;
		
		/**
		 * @inheritDoc 
		 */		
		override public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			
			var deltaPoint:Point = MathUtil.roundPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			
			if(horizontalEnabled)
			{
				var newWidth:Number = data.width + data.width*deltaPoint.x/(startPoint.x-startAnchor.x);
				data.width = resolveSize(MathUtil.round(newWidth,2), startData.minWidth, startData.maxWidth);
			}
			if(verticalEnabled)
			{
				var newHeight:Number = data.height + data.height*deltaPoint.y/(startPoint.y-startAnchor.y);
				data.height = resolveSize(MathUtil.round(newHeight,2), startData.minHeight, startData.maxHeight);
			}
			
			if(maintainAspectRatio) 
			{
				var horizontalFactor:Number = horizontalEnabled ? data.width/startData.width : 0;
				var verticalFactor:Number = verticalEnabled ? data.height/startData.height : 0;
				
				var ratio:Number;
				
				if(verticalFactor > horizontalFactor)
					ratio = resolveSize(verticalFactor * startData.width, startData.minWidth, startData.maxWidth)/startData.width;
				else
					ratio = resolveSize(horizontalFactor * startData.height, startData.minHeight, startData.maxHeight)/startData.height;
				
				
				data.width = ratio* startData.width;
				data.height = ratio* startData.height;
			}
			
			var m:Matrix = new Matrix();
			m.rotate(startData.rotation*Math.PI/180);
			
			var pos:Point = m.transformPoint(new Point(data.width*startAnchor.x/startData.width - startAnchor.x,data.height*startAnchor.y/startData.height-startAnchor.y));
			
			data.x = MathUtil.round(startData.x - pos.x, 2);
			data.y = MathUtil.round(startData.y - pos.y, 2);
					
			return data;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function endOperation(point:Point):DisplayData
		{
			var data:DisplayData = doOperation(point);
			
			DataUtil.fitData(data, bounds);
			
			return data;
		}
		
		/**
		 * @private 
		 */		
		private function resolveSize(value:Number, min:Number, max:Number):Number 
		{
			min = !isNaN(min) ? min : value;
			max = !isNaN(max) ? max : value;
			
			return Math.min(max, Math.max(min, value));
		}
	}
}