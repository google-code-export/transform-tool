package com.vstyran.transform.layouts
{
	import flash.geom.Point;
	
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class AnchorLayout extends LayoutBase
	{
		public function AnchorLayout()
		{
			super();
		}
		
		private var lastPanelSize:Point;
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			var count:int = layoutTarget.numElements;
			var containerSize:Point = new Point(layoutTarget.getLayoutBoundsWidth(), layoutTarget.getLayoutBoundsHeight());
			
			if(lastPanelSize)
			{
				
				for (var i:int = 0; i < count; i++)
				{
					var layoutElement:ILayoutElement = layoutTarget.getElementAt(i);
					if (!layoutElement || !layoutElement.includeInLayout)
						continue;
					
					layoutElement.setLayoutBoundsSize(NaN, NaN);
					
					var x:Number = layoutElement.getLayoutBoundsX() + layoutElement.getLayoutBoundsWidth()/2;
					var y:Number = layoutElement.getLayoutBoundsY() + layoutElement.getLayoutBoundsHeight()/2;
					
					x = x/lastPanelSize.x * containerSize.x - layoutElement.getLayoutBoundsWidth()/2;
					y = y/lastPanelSize.y * containerSize.y - layoutElement.getLayoutBoundsHeight()/2;
					
					layoutElement.setLayoutBoundsPosition(x,y);
				}
			}
			
			lastPanelSize = containerSize;
		}
	}
}