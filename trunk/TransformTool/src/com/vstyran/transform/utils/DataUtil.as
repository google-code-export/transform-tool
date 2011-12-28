package com.vstyran.transform.utils
{
	import com.vstyran.transform.consts.GuidelineType;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.SandboxMouseEvent;
	
	/**
	 * Utility class that has methods for manipulating display data.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DataUtil
	{
		/**
		 * Create data from ui component.
		 *  
		 * @param target Source ui component.
		 * @return Display data.
		 */		
		public static function createData(target:UIComponent):DisplayData
		{
			var data:DisplayData = new DisplayData();
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
		
		/**
		 * Apply data on ui component. 
		 * 
		 * @param target UI component to which the data will be applied.
		 * @param data Display data.
		 * @param applyMinMax Flag that indicates whether min/max size should be applied.
		 */		
		public static function applyData(target:UIComponent, data:DisplayData, applyMinMax:Boolean = false):void
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
		
		/**
		 * Apply data on ui component scaling rather than changing size. 
		 * 
		 * @param target UI component to which the data will be applied.
		 * @param data Display data.
		 */		
		public static function applyScaledData(target:UIComponent, data:DisplayData):void
		{
			target.x = data.x;
			target.y = data.y;
			target.scaleX = data.width/target.width;
			target.scaleY = data.height/target.height;
			target.rotation = data.rotation;
		}
		
		/**
		 * Fit position of data into bounds. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param bounds Bounds that will be used as fitting boundaries.
		 * @return Data with fitted position.
		 */		
		public static function fitData(data:DisplayData, bounds:Bounds):DisplayData 
		{
			if(bounds)
			{
				var box:Rectangle =  data.getBoundingBox();
				var boundsRight:Number = bounds.right - box.width;
				var boundsBottom:Number = bounds.bottom - box.height;
				
				var newX:Number = MathUtil.fitValue(box.x, bounds.x, boundsRight);
				var newY:Number = MathUtil.fitValue(box.y, bounds.y, boundsBottom);
				
				data.x = MathUtil.round(newX + data.x - box.x, 2);
				data.y =  MathUtil.round(newY + data.y - box.y, 2);
			}
			
			return data;
		}
		
		/**
		 * Snap position of data into grid. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param grid Grid that will be used as step size.
		 * @param snapX Snap by X axis.
		 * @param snapY Snap by Y axis.
		 * @return Data with fitted position.
		 */		
		public static function snapData(data:DisplayData, grid:GridData, snapX:Boolean, snapY:Boolean):DisplayData 
		{
			if(grid)
			{
				var box:Rectangle =  data.getBoundingBox();
				
				if(snapX)
				{
					var newX:Number = MathUtil.snapValue(box.x, grid.x, grid.cellWidth, grid.fraction);
					data.x = MathUtil.round(newX + data.x - box.x, 2);
				}
				
				if(snapY)
				{
					var newY:Number = MathUtil.snapValue(box.y, grid.y, grid.cellWidth, grid.fraction);
					data.y = MathUtil.round(newY + data.y - box.y, 2);
				}
			}
			
			return data;
		}
		
		/**
		 * Snap data into guidelines by changing position. 
		 *  
		 * @param data Source data to be guided. Will be changed.
		 * @param guidelines List of guidelines.
		 * @return Cross of guidelines that currently active.
		 */		
		public static function guidePosition(data:DisplayData, guidelines:Vector.<Guideline>):GuidelineCross 
		{
			var cross:GuidelineCross = new GuidelineCross();
			if(guidelines)
			{
				var box:Rectangle = data.getBoundingBox();
				var delta:Point = new Point();
				for each (var guideline:Guideline in guidelines) 
				{
					// check left adge
					delta = checkActiveGuideline(cross, guideline, delta, box.x, box.y, false);
					// check center
					delta = checkActiveGuideline(cross, guideline, delta, box.x + box.width/2, box.y + box.height/2, true);
					// check right adge
					delta = checkActiveGuideline(cross, guideline, delta, box.x + box.width, box.y + box.height, false);
				}
				
				data.x += delta.x;
				data.y += delta.y;
			}
			return (cross.vGuideline || cross.hGuideline) ? cross : null;
		}
		
		/**
		 * Snap data into guidelines by changing size. Rotation should be multiple of 90 degree.
		 *  
		 * @param startData Start data.
		 * @param data Source data to be guided. Will be changed.
		 * @param anchor Anchor point should be set in data coordinate space. 
		 * @param guidelines List of guidelines.
		 * @return Cross of guidelines that currently active.
		 */		
		public static function guideSize(startData:DisplayData, data:DisplayData, anchor:Point, guidelines:Vector.<Guideline>):GuidelineCross 
		{
			startData.precision = 2;
			data.precision = 2;
			
			var delta:Point = new Point();
			
			var cross:GuidelineCross = new GuidelineCross();
			if(guidelines)
			{
				var box:Rectangle = data.getBoundingBox();
				for each (var guideline:Guideline in guidelines) 
				{
					// check left adge
					var x:Number = (startData.left.x != data.left.x) ? data.left.x : NaN;
					var y:Number = (startData.top.y != data.top.y) ? data.top.y : NaN;
					delta = checkActiveGuideline(cross, guideline, null, x, y, false);
					if(delta.x != 0)
						data.setLeft(guideline.value, anchor);
					if(delta.y != 0)
						data.setTop(guideline.value, anchor);
					
					// check right adge
					x = (startData.right.x != data.right.x) ? data.right.x : NaN;
					y = (startData.bottom.y != data.bottom.y) ? data.bottom.y : NaN;
					delta = checkActiveGuideline(cross, guideline, null, x, y, false);
					if(delta.x != 0)
						data.setRight(guideline.value, anchor);
					if(delta.y != 0)
						data.setBottom(guideline.value, anchor);
				}
			}
			
			return (cross.vGuideline || cross.hGuideline) ? cross : null;
		}
		
		/**
		 * Snap to rotation guideliones.
		 *  
		 * @param rotation Current rotation
		 * @param guidelines List of guidelines.
		 * @return Cross of guidelines that currently active.
		 */		
		public static function guideRotation(rotation:Number, guidelines:Vector.<Guideline>):GuidelineCross
		{
			var cross:GuidelineCross = new GuidelineCross();
			
			for each (var guideline:Guideline in guidelines) 
			{
				if(cross.rGuideline != null)
					break;
				
				if(guideline.type == GuidelineType.ROTATION)
				{
					if(Math.abs(guideline.value-rotation) <= guideline.fraction)
						cross.addGuideline(guideline, true);
				}
			}
			
			return cross.rGuideline ? cross : null;
		}
		
		/**
		 * @private
		 * Returns list of guides that exactly matches snapping values of specified DisplayData object. 
		 * 
		 * @param data DisplayData object to be checked.
		 * @param cross Current GuidelineCross object. Will be updated.
		 * @param guidelines List of guidelines.
		 * @return center Updated GuidelineCross object.
		 */	
		public static function getPreciseGuides(data:DisplayData, cross:GuidelineCross, guidelines:Vector.<Guideline>):GuidelineCross 
		{
			cross ||= new GuidelineCross();
			
			if(guidelines)
			{
				var box:Rectangle = data.getBoundingBox();
				for each (var guideline:Guideline in guidelines) 
				{
					// check left adge
					checkGuideline(cross, guideline, box.x, box.y, false);
					// check center
					checkGuideline(cross, guideline, box.x + box.width/2, box.y + box.height/2, true);
					// check right adge
					checkGuideline(cross, guideline, box.x + box.width, box.y + box.height, false);
				}
			}
			
			// validate active guidelines
			if(cross.vGuideline && !validatePreciseGuideLine(data, cross.vGuideline))
				cross.removeGuideline(cross.vGuideline);
			
			if(cross.hGuideline && !validatePreciseGuideLine(data, cross.hGuideline))
				cross.removeGuideline(cross.hGuideline);
			
			return cross.getGuidelines().length > 0 ? cross : null;
		}
		
		/**
		 * Validation guideline to check whether it's still precisely fit.
		 *  
		 * @param data DisplayData object to be checked.
		 * @param guideline Guideline to validate.
		 * 
		 * @return true if it;s fit; otherwise false.
		 */		
		public static function validatePreciseGuideLine(data:DisplayData, guideline:Guideline):Boolean 
		{
			var box:Rectangle = data.getBoundingBox();
			var cross:GuidelineCross = new GuidelineCross();
			// check left adge
			checkGuideline(cross, guideline, box.x, box.y, false);
			// check center
			checkGuideline(cross, guideline, box.x + box.width/2, box.y + box.height/2, true);
			// check right adge
			checkGuideline(cross, guideline, box.x + box.width, box.y + box.height, false);
			
			return cross.getGuidelines().length > 0;
		}
		
		/**
		 * @private
		 * Checks whether specified guideline matches snapping range. 
		 * 
		 * @param cross Current GuidelineCross object.
		 * @param guideline Guideline object for checking.
		 * @param delta Value for adjusting. 
		 * @param x Snapping value by X axis.
		 * @param y Snapping value by Y axis.
		 * @param center Flag indicates whether it checks for snapping by center point of target
		 */
		private static function checkActiveGuideline(cross:GuidelineCross, guideline:Guideline, delta:Point, x:Number, y:Number, center:Boolean):Point
		{
			delta ||= new Point();
			
			if(canUseVGuideline(guideline, center) && !isNaN(x))
			{
				if(cross.vGuideline == null && Math.abs(guideline.value-x) <= guideline.fraction)
				{
					delta.x = guideline.value - x;
					cross.addGuideline(guideline, true);
				}
			}
			else if(canUseHGuideline(guideline, center) && !isNaN(y))
			{
				if(cross.hGuideline == null && Math.abs(guideline.value-y) <= guideline.fraction)
				{
					delta.y = guideline.value - y;
					cross.addGuideline(guideline, true);
				}
			}
			
			return delta;
		}
		
		/**
		 * @private
		 * Checks whether specified guideline is exactly matches snapping value. 
		 * 
		 * @param cross Current GuidelineCross object.
		 * @param guideline Guideline object for checking.
		 * @param x Snapping value by X axis.
		 * @param y Snapping value by Y axis.
		 * @param center Flag indicates whether it checks for snapping by center point of target
		 */		
		private static function checkGuideline(cross:GuidelineCross, guideline:Guideline, x:Number, y:Number, center:Boolean):void
		{
			if(canUseVGuideline(guideline, center))
			{
				if(x == guideline.value)
					cross.addGuideline(guideline);
			}
			else if(canUseHGuideline(guideline, center))
			{
				if(y == guideline.value)
					cross.addGuideline(guideline);
			}
		}
		
		/**
		 * @private
		 * Checks whether this guideline can be used for vertical snapping. 
		 * 
		 * @param guideline Guideline object for checking
		 * @param center Flag indicates whether it checks for snapping by center point of target
		 * @return true if can be used; otherwise false 
		 */		
		private static function canUseVGuideline(guideline:Guideline, center:Boolean):Boolean
		{
			return (guideline.type == GuidelineType.VERTICAL || (center && guideline.type == GuidelineType.VERTICAL_CENTER) || (!center && guideline.type == GuidelineType.VERTICAL_EDGE));
		}
		
		/**
		 * @private
		 * Checks whether this guideline can be used for horizontal snapping. 
		 * 
		 * @param guideline Guideline object for checking
		 * @param center Flag indicates whether it checks for snapping by center point of target
		 * @return true if can be used; otherwise false 
		 */		
		private static function canUseHGuideline(guideline:Guideline, center:Boolean):Boolean
		{
			return (guideline.type == GuidelineType.HORIZONTAL || (center && guideline.type == GuidelineType.HORIZONTAL_CENTER) || (!center && guideline.type == GuidelineType.HORIZONTAL_EDGE));
		}
	}
}