package com.vstyran.reuler.view
{
	
	import com.vstyran.reuler.consts.MeasureUnit;
	import com.vstyran.reuler.model.Tick;
	
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	public class RulerBarBase extends SkinnableComponent
	{
		public function RulerBarBase()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		[SkinPart(required="true")]
		public var tickGroup:DataGroup;
		
		protected var ticks:ArrayList = new ArrayList();
		
		private var _minDistance:Number = 30;

		public function get minDistance():Number
		{
			return _minDistance;
		}

		public function set minDistance(value:Number):void
		{
			if(_minDistance != value)
			{
				_minDistance = !isNaN(value) && value > 0 ? value : 30;
				updateSkinDisplayList(true);
			}
		}

		
		private var _distanceList:Array = [1, 2, 5, 10, 25, 50, 100, 250, 500, 1000];
		public function get distanceList():Array
		{
			return _distanceList;
		}

		public function set distanceList(value:Array):void
		{
			if(_distanceList != value)
			{
				_distanceList = value;
				updateSkinDisplayList(true);
			}
		}

;
		
		private var _zoom:Number = 1;

		public function get zoom():Number
		{
			return _zoom;
		}

		public function set zoom(value:Number):void
		{
			if(_zoom != value)
			{
				_zoom = !isNaN(value) && value > 0 ? value : 1;
				updateSkinDisplayList(true);
			}
		}

		
		private var _pixelsPerValue:Number = MeasureUnit.INCH;

		public function get pixelsPerValue():Number
		{
			return _pixelsPerValue;
		}

		public function set pixelsPerValue(value:Number):void
		{
			if(_pixelsPerValue != value)
			{
				_pixelsPerValue = !isNaN(value) && value > 0 ? value : MeasureUnit.INCH;
				updateSkinDisplayList(true);
			}
		}
		
		
		protected function getDistance():Number
		{
			var list:Array = distanceList.slice();
			list.push(Number.MAX_VALUE);
			var distance:Number;
			for (var i:int = 0; i < list.length-1; i++) 
			{
				distance = list[i];
				while(distance < list[i+1])
				{
					if(distance*pixelsPerValue*zoom > minDistance)
						return distance;
				
					distance += list[i];
				}
			}
			
			return minDistance;
		}
		
		protected function updateTicks(length:Number, shift:Number):void
		{
			ticks.removeAll();
			var distance:Number = getDistance();
			var distancePx:Number = distance*pixelsPerValue*zoom;
			var count:Number = length/distancePx;
			
			for (var i:int = 0; i < count; i++) 
			{
				ticks.addItem(new Tick(i*distance,i*distancePx + shift, distancePx));	
			}
		}
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(tickGroup)
			{
				tickGroup.dataProvider = ticks;
				tickGroup.addEventListener(ResizeEvent.RESIZE, tickGroup_resizeHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			if(tickGroup)
			{
				tickGroup.removeEventListener(ResizeEvent.RESIZE, tickGroup_resizeHandler);
			}
			
			super.partRemoved(partName, instance);
		}
		
		/**
		 *  Sets the bounds of skin parts, typically the thumb, whose geometry isn't fully
		 *  specified by the skin's layout.
		 * 
		 *  <p>Most subclasses override this method to update the thumb's size, position, and 
		 *  visibility, based on the <code>minimum</code>, <code>maximum</code>, and <code>value</code> properties. </p>
		 * 
		 *  <p>By default, this method does nothing.</p> 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * 
		 */
		protected function updateSkinDisplayList(force:Boolean = false):void {}
		
		/**
		 *  @private
		 *  Redraw whenever added to the stage to ensure the calculations
		 *  in updateSkinDisplayList() are correct.
		 */
		private function addedToStageHandler(event:Event):void
		{
			updateSkinDisplayList();
		}
		
		/**
		 *  @private
		 */
		private function tickGroup_resizeHandler(event:Event):void
		{
			updateSkinDisplayList();
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			updateSkinDisplayList();
		}
	}
}