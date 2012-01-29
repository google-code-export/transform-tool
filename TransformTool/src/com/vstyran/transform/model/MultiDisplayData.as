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
			super();
			
			_children = new Vector.<DisplayData>();
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
		
		private var _pudding:Number

		public function get pudding():Number
		{
			return _pudding;
		}

		public function set pudding(value:Number):void
		{
			_pudding = value;
			
			validateData();
		}

		
		override public function set x(value:Number):void
		{
			super.x = value;
			
			vlidateChildren();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			
			vlidateChildren();
		}
		
		override public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			super.setTo(x, y, width, height, rotation);
			
			vlidateChildren();
		}
		
		
		
		
		
		
		
		
		private var validData:DisplayData = new DisplayData();
		
		public function validateData():void
		{
			var data:DisplayData = new DisplayData();
			var rect:Rectangle = data.unionVector(children);
			super.setTo(rect.x, rect.y, rect.width, rect.height, 0);
			
			
			
			validData.setTo(rect.x, rect.y, rect.width, rect.height, 0);
		}
		
		public function vlidateChildren():void
		{
			
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
					var deltaW:Number = oldLocalBox.width*width/validData.width - oldLocalBox.width;
					var deltaH:Number = oldLocalBox.height*height/validData.height - oldLocalBox.height;
					var naturalSize:Point = localData.getNaturalSize();
					localData.setNaturalSize(localData.resolveMinMax(new Point(naturalSize.x + deltaW, naturalSize.y + deltaH)));
					
					// calculate new position
					var newLocalBox:Rectangle = localData.getBoundingBox();
					var newX:Number = (oldLocalBox.x + oldLocalBox.width/2)*width/validData.width - newLocalBox.width/2;
					var newY:Number = (oldLocalBox.y + oldLocalBox.height/2)*height/validData.height - newLocalBox.height/2;
					localData.setBoundingPosition(newX, newY);
					
					// set global data
					m = MatrixUtil.composeMatrix(x, y, 1, 1, rotation);
					var newData:DisplayData = TransformUtil.transformData(m, localData);
					
					child.setTo(newData.x, newData.y, newData.width, newData.height, newData.rotation);
				}
			}
			
			validData.setTo(rect.x, rect.y, rect.width, rect.height, rotation);
		}
		
		
		
		
		override public function clone():DisplayData
		{
			var clone:MultiDisplayData = clone() as MultiDisplayData;
			
			clone._children = children;
			
			return clone;
		}
	}
}