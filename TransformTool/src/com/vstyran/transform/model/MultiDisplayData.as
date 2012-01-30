package com.vstyran.transform.model
{
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.MatrixUtil;

	public class MultiDisplayData extends DisplayData
	{
		public function MultiDisplayData()
		{
			_children = new Vector.<DisplayData>();
			
			super();
			
		}
		
		private var _children:Vector.<DisplayData>;

		public function get children():Vector.<DisplayData>
		{
			return _children.slice();
		}
		
		public function addChild(value:DisplayData):void
		{
			addChildInternal(value);
			validateData();
		}
		
		public function addChildInternal(value:DisplayData):void
		{
			if(_children.indexOf(value) == -1)
				_children.push(value);
		}
		
		public function addChildVector(value:Vector.<DisplayData>):void
		{
			for each (var child:DisplayData in value) 
			{
				addChildInternal(child);
			}
			
			validateData();
		}
		
		public function addChildArray(value:Array):void
		{
			for each (var child:DisplayData in value) 
			{
				addChildInternal(child);
			}
			
			validateData();
		}
		
		public function removeChild(value:DisplayData):void
		{
			var index:int = _children.indexOf(value);
			if(index == -1)
				_children.splice(index, 1);
			
			validateData();
		}
		
		private var _padding:Number = 0;

		public function get padding():Number
		{
			return _padding;
		}

		public function set padding(value:Number):void
		{
			_padding = value;
			
			validateData();
		}

		override public function set x(value:Number):void
		{
			super.x = value;
			
			validateChildren();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			
			validateChildren();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			validateChildren();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			validateChildren();
		}
		
		override public function set rotation(value:Number):void
		{
			super.rotation = value;
			
			validateChildren();
		}
		
		override public function set position(value:Point):void
		{
			super.position = value;
			
			validateChildren();
		}
		
		override public function set size(value:Point):void
		{
			super.size = value;
			
			validateChildren();
		}
		
		override public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			super.setTo(x, y, width, height, rotation);
			
			validateChildren();
		}
		
		override public function offset(dx:Number, dy:Number):void
		{
			super.offset(dx, dy);
			
			validateChildren();
		}
		
		override public function setNaturalSize(size:Point):void
		{
			super.setNaturalSize(size);
			
			validateChildren();
		}
		
		private var validData:DisplayData = new DisplayData();
		
		public function validateData(rotation:Number=0):void
		{
			rotation = MatrixUtil.clampRotation(rotation);
			
			var data:DisplayData = new DisplayData();
			var rect:Rectangle;
			
			if(rotation == 0)
			{
				rect = data.unionVector(children);
				super.setTo(rect.x-padding, rect.y-padding, rect.width+2*padding, rect.height+2*padding, rotation);
				
				// store last valid data
				validData.setTo(rect.x, rect.y, rect.width, rect.height, 0);
			}
			else
			{
				var list:Vector.<DisplayData> = new Vector.<DisplayData>();
				
				// translate children
				var m:Matrix = MatrixUtil.composeMatrix(0, 0, 1, 1, rotation);
				m.invert();
				for each (var child:DisplayData in children) 
				{
					list.push(TransformUtil.transformData(m, child));					
				}
				
				// calculate union
				rect = data.unionVector(list);
				m = MatrixUtil.composeMatrix(0, 0, 1, 1, rotation);
				var newData:DisplayData = TransformUtil.transformData(m, new DisplayData(rect.x, rect.y, rect.width, rect.height));
				
				// store last valid data
				validData.setTo(newData.x, newData.y, newData.width, newData.height, newData.rotation);
				
				// add padding
				newData = addPadding(newData, padding);
				super.setTo(newData.x, newData.y, newData.width, newData.height, newData.rotation);
			}
		}
		
		public function validateChildren():void
		{
			var actualData:DisplayData = trimPadding(this, padding);
			
			if(children.length > 0)
			{
				for each (var child:DisplayData in children) 
				{
					// get local data
					var m:Matrix = MatrixUtil.composeMatrix(validData.x, validData.y, 1, 1, validData.rotation);
					m.invert();
					var localData:DisplayData = TransformUtil.transformData(m, child);
					
					// calculate new size
					var oldLocalBox:Rectangle = localData.getBoundingBox();
					var deltaW:Number = oldLocalBox.width*actualData.width/validData.width - oldLocalBox.width;
					var deltaH:Number = oldLocalBox.height*actualData.height/validData.height - oldLocalBox.height;
					var naturalSize:Point = localData.getNaturalSize();
					localData.setNaturalSize(localData.resolveMinMax(new Point(naturalSize.x + deltaW, naturalSize.y + deltaH)));
					
					// calculate new position
					var newLocalBox:Rectangle = localData.getBoundingBox();
					var newX:Number = (oldLocalBox.x + oldLocalBox.width/2)*actualData.width/validData.width - newLocalBox.width/2;
					var newY:Number = (oldLocalBox.y + oldLocalBox.height/2)*actualData.height/validData.height - newLocalBox.height/2;
					localData.setBoundingPosition(newX, newY);
					
					// set global data
					m = MatrixUtil.composeMatrix(actualData.x, actualData.y, 1, 1, rotation);
					var newData:DisplayData = TransformUtil.transformData(m, localData);
					
					child.setTo(newData.x, newData.y, newData.width, newData.height, newData.rotation);
				}
			}
			
			validData.setTo(actualData.x, actualData.y, actualData.width, actualData.height, rotation);
		}
		
		
		public function trimPadding(data:DisplayData, padding:Number):DisplayData
		{
			var m:Matrix = MatrixUtil.composeMatrix(0, 0, 1, 1, data.rotation);
			var point:Point = m.transformPoint(new Point(padding, padding));
			
			return new DisplayData(data.x+point.x, data.y+point.y, data.width-2*padding, data.height-2*padding, data.rotation);
		}
		
		public function addPadding(data:DisplayData, padding:Number):DisplayData
		{
			var m:Matrix = MatrixUtil.composeMatrix(0, 0, 1, 1, data.rotation);
			var point:Point = m.transformPoint(new Point(padding, padding));
			
			return new DisplayData(data.x-point.x, data.y-point.y, data.width+2*padding, data.height+2*padding, data.rotation);
		}
		
		override public function clone():DisplayData
		{
			var clone:MultiDisplayData = clone() as MultiDisplayData;
			
			clone._children = children;
			
			return clone;
		}
	}
}