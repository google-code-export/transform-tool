package com.vstyran.transform.operations
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Move operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class MoveOperation extends BaseOperation
	{
		/**
		 * Constructor. 
		 */		
		public function MoveOperation()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function get type():String
		{
			return TransformationType.MOVE;
		}
		
		
		/**
		 * @inheritDoc 
		 */
		override public function doOperation(point:Point):DisplayData
		{
			//reset guideline cross
			guideCross = null;
			
			var data:DisplayData = startData.clone();
			
			// calculate new position
			var m:Matrix = new Matrix();
			m.rotate(data.rotation*Math.PI/180);
			var p:Point = m.transformPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			data.x = startData.x + p.x;
			data.y = startData.y + p.y;
			
			// fit into bounds
			DataUtil.fitData(data, bounds);
			
			// invoke user snapping function
			var userData:DisplayData = data.clone();
			userData = invokeSnappingFunction(this, userData, null);
			
			if(userData)
			{
				// use snapped data
				data = userData;
			}
			else
			{
				// snap to guidelines
				guideCross = DataUtil.guidePosition(data, guidelines);
				
				// snap to grid in case is not snapped to guidelines
				var snapX:Boolean = !(guideCross && guideCross.vGuideline); 
				var snapY:Boolean = !(guideCross && guideCross.hGuideline); 
				DataUtil.snapData(data, grid, snapX, snapY);
			}
			
			// recheck fitting to bounds
			DataUtil.fitData(data, bounds);
			
			// check pasive guidelines
			guideCross = DataUtil.getPreciseGuides(data, guideCross, guidelines);
			
			return data;
		}
	}
}