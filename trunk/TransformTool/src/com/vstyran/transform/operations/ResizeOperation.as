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
			data.precision = 2;
			
			var deltaPoint:Point = MathUtil.roundPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			var newSize:Point = data.size;
			
			// calculate new width
			if(horizontalEnabled)
				newSize.x = data.width + data.width*deltaPoint.x/(startPoint.x-startAnchor.x);
			
			// calculate new height
			if(verticalEnabled)
				newSize.y = data.height + data.height*deltaPoint.y/(startPoint.y-startAnchor.y);
			
			// guide data
			if(data.rotation%90 == 0)
			{
				var guidData:DisplayData = data.clone();
				guidData.inflate(newSize.x - startData.width, newSize.y - startData.height, startAnchor);
				guideCross = DataUtil.guideSize(data.clone(), guidData, guidelines);
				newSize = new Point(guidData.width, guidData.height);
			}
			
			// check min/max values
			newSize = data.resolveMinMax(newSize);
			
			//keep aspect ratio
			if(maintainAspectRatio) 
				newSize = startData.resolveAspectRatio(newSize,horizontalEnabled, verticalEnabled);
			
			// set new size
			data.inflate(newSize.x - data.width, newSize.y - data.height, startAnchor);
			
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
	}
}