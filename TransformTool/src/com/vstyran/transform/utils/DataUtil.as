package com.vstyran.transform.utils
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.model.GuidelineCross;
	
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
				var box:Rectangle = TransformUtil.getBoundingBox(data);
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
				var box:Rectangle = TransformUtil.getBoundingBox(data);
				
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
		 * Snap data into guidelines. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param grid List of guidelines.
		 * @return Cross of guidelines that currently active.
		 */		
		public static function guideData(data:DisplayData, guidelines:Vector.<Guideline>):GuidelineCross 
		{
			var result:GuidelineCross = new GuidelineCross();
			
			var box:Rectangle = TransformUtil.getBoundingBox(data);
			if(guidelines)
			{
				for each (var guideline:Guideline in guidelines) 
				{
					if(guideline.direction == Guideline.VERTICAL && !result.vGuideline)
					{
						// check left adge
						if(canUseGuideline(box.x, guideline.value, guideline.fraction))
						{
							data.x = guideline.value + data.x - box.x;
							result.vGuideline = guideline;
							continue;
						}
						// check center
						if(canUseGuideline(box.x + box.width/2, guideline.value, guideline.fraction))
						{
							data.x = guideline.value - box.width/2 + data.x - box.x;
							result.vGuideline = guideline;
							continue;
						}
						// check right adge
						if(canUseGuideline(box.x + box.width, guideline.value, guideline.fraction))
						{
							data.x = guideline.value - box.width + data.x - box.x;
							result.vGuideline = guideline;
							continue;
						}
					}
					
					if(guideline.direction == Guideline.HORIZONTAL && !result.hGuideline)
					{
						// check top adge
						if(canUseGuideline(box.y, guideline.value, guideline.fraction))
						{
							data.y = guideline.value + data.y - box.y;
							result.hGuideline = guideline;
							continue;
						}
						// check center
						if(canUseGuideline(box.y + box.height/2, guideline.value, guideline.fraction))
						{
							data.y = guideline.value - box.height/2 + data.y - box.y;;
							result.hGuideline = guideline;
							continue;
						}
						// check bottom adge
						if(canUseGuideline(box.y + box.height, guideline.value, guideline.fraction))
						{
							data.y = guideline.value - box.height + data.y - box.y;;
							result.hGuideline = guideline;
							continue;
						}
					}
				}
			}
			return (result.vGuideline || result.hGuideline) ? result : null;
		}
		
		/**
		 * Snap to guide value. 
		 * 
		 * @param value Value to be guided.
		 * @param pos Guide position
		 * @param fraction Max delta value that can be guided.
		 * @return true if can be guided.
		 */		
		private static function canUseGuideline(value:Number, pos:Number, fraction:Number=0):Boolean
		{
			return Math.abs(value-pos) <= fraction;
		}
	}
}