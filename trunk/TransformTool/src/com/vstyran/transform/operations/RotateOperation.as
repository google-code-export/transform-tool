package com.vstyran.transform.operations
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.SegmentData;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Rotate operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class RotateOperation extends AnchorOperation
	{
		/**
		 * Constructor. 
		 */		
		public function RotateOperation()
		{
			super();
		}
		
		/**
		 * Segmets that will be used as step size for operations. 
		 */		
		public var segments:Vector.<SegmentData>;
		
		/**
		 * Flag indicates whether operation should be fitted into segmets if it is specified. 
		 */		
		public var maintainSegments:Boolean = true;
		
		/**
		 * @inheritDoc
		 */		
		override public function get type():String
		{
			return TransformationType.ROTATE;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			var deltaRotation:Number = 0;
			
			var initialAngle:Number =  Math.atan2(startPoint.y - startAnchor.y, startPoint.x - startAnchor.x) * 180/Math.PI;
			
			var alpha:Number =  Math.atan2(point.y - startAnchor.y, point.x - startAnchor.x) * 180/Math.PI ;
			deltaRotation = alpha - initialAngle; 
			
			// reset cross
			guideCross = null;
			
			// snap to guidelines
			if(maintainGuidelines)
			{
				guideCross = DataUtil.guideRotation(data.rotation + deltaRotation, guidelines);
				if(guideCross && guideCross.rGuideline)
					deltaRotation = guideCross.rGuideline.value - data.rotation;
			}
			
			// snap to specified step
			if(segments && maintainSegments && (!guideCross || !guideCross.rGuideline))
			{
				for each (var segment:SegmentData in segments) 
				{
					deltaRotation = DataUtil.snapRotation(data.rotation + deltaRotation, segment) - data.rotation;
				}
			}
			
			//rotate data
			data.rotate(deltaRotation, startAnchor);
			
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