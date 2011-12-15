package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
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
		 *   The amount of degree that used as step size for rotation. 
		 */		
		public var stepDegree:Number;
		
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
			
			// snap to specified step
			if(!isNaN(stepDegree) && stepDegree > 0)
				deltaRotation = Math.round((data.rotation + deltaRotation)/stepDegree)*stepDegree - data.rotation;
			
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