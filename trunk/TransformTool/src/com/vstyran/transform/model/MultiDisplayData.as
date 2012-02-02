package com.vstyran.transform.model
{
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.MatrixUtil;

	/**
	 * Value object for composit DisplayData.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class MultiDisplayData extends DisplayData
	{
		/**
		 * Constructor.
		 * 
		 * @param x Position by X axis.
		 * @param y Position by Y axis.
		 * @param width Width of display object. 
		 * @param height Height of display object. 
		 * @param rotation Rotation of display object, will be clamped between -180 and 180 degrees. 
		 */		
		public function MultiDisplayData(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, rotation:Number = 0)
		{
			_children = new Vector.<DisplayData>();
			
			super(x, y, width, height, rotation);
		}
		
		/**
		 * @private 
		 */		
		protected var _children:Vector.<DisplayData>;

		/**
		 * Vector of DisplayData objects in the same coordinate space as parent. 
		 */		
		public function get children():Vector.<DisplayData>
		{
			return _children.slice();
		}
		
		/**
		 * Add child if it's not added yet. This method invokes parent data validation. 
		 * 
		 * @param value Child DisplayData object in the same coordinate space as parent. 
		 */		
		public function addChild(value:DisplayData):void
		{
			addChildInternal(value);
			validateData();
		}
		
		/**
		 * @private 
		 */		
		protected function addChildInternal(value:DisplayData):void
		{
			if(_children.indexOf(value) == -1)
				_children.push(value);
		}
		
		/**
		 * Add vector of children if they are not added yet. This method invokes parent data validation. 
		 * 
		 * @param value Vector of DisplayData object in the same coordinate space as parent. 
		 */	
		public function addChildVector(value:Vector.<DisplayData>):void
		{
			for each (var child:DisplayData in value) 
			{
				addChildInternal(child);
			}
			
			validateData();
		}
		
		/**
		 * Add array of children if they are not added yet. This method invokes parent data validation. 
		 * 
		 * @param value Array of DisplayData object in the same coordinate space as parent. 
		 */	
		public function addChildArray(value:Array):void
		{
			for each (var child:DisplayData in value) 
			{
				addChildInternal(child);
			}
			
			validateData();
		}
		
		/**
		 * Remove DisplayData object if it's child of parent. This method invokes parent data validation. 
		 * 
		 * @param value Child DisplayData object. 
		 */		
		public function removeChild(value:DisplayData):void
		{
			var index:int = _children.indexOf(value);
			if(index == -1)
				_children.splice(index, 1);
			
			validateData();
		}
		
		/**
		 * @private 
		 */		
		protected var _padding:Number = 0;

		/**
		 * Padding for children. Parent data size and position will be increased by this value for each side.
		 */		
		public function get padding():Number
		{
			return _padding;
		}
		
		/**
		 * @private 
		 */
		public function set padding(value:Number):void
		{
			_padding = value;
			
			validateData();
		}

		/**
		 * @inheritDoc 
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set rotation(value:Number):void
		{
			super.rotation = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set position(value:Point):void
		{
			super.position = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function set size(value:Point):void
		{
			super.size = value;
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			super.setTo(x, y, width, height, rotation);
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function offset(dx:Number, dy:Number):void
		{
			super.offset(dx, dy);
			
			validateChildren();
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function setNaturalSize(size:Point):void
		{
			super.setNaturalSize(size);
			
			validateChildren();
		}
		
		/**
		 * @private 
		 */		
		protected var validData:DisplayData = new DisplayData();
		
		/**
		 * @private 
		 */		
		protected var localChildren:Vector.<DisplayData> = new Vector.<DisplayData>();
		
		/**
		 * Recalculate parent geometry properties depending on children.
		 *  
		 * @param rotation Degree value that will be used as new validated data rotation.
		 */		
		public function validateData(rotation:Number=0):void
		{
			rotation = MatrixUtil.clampRotation(rotation);
			
			// validata children at first.
			for each (var child:DisplayData in children)
			{
				if(child is MultiDisplayData)
					(child as MultiDisplayData).validateData(rotation);
			}
			
			// validate itself
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
				for each (child in children) 
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
			
			createLocalChildren();
			
		}
		
		/**
		 * @private 
		 */		
		private function createLocalChildren():void
		{
			localChildren.length = 0;
			var m:Matrix = MatrixUtil.composeMatrix(validData.x, validData.y, 1, 1, validData.rotation);
			m.invert();
			for each (var child:DisplayData in children) 
			{
				var localData:DisplayData = TransformUtil.transformData(m, child);
				
				localChildren.push(localData);
			}
		}
		
		/**
		 * Recalculate geometry properties of children depending on current properties of parent.
		 */		
		public function validateChildren():void
		{
			var actualData:DisplayData = trimPadding(this, padding);
			var actuaMatrix:Matrix = MatrixUtil.composeMatrix(actualData.x, actualData.y, 1, 1, rotation);
			if(children.length > 0)
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					var child:DisplayData = children[i];
					var localData:DisplayData = localChildren[i].clone();
					
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
					var newData:DisplayData = TransformUtil.transformData(actuaMatrix, localData);
					
					child.setTo(newData.x, newData.y, newData.width, newData.height, newData.rotation);
				}
			}
		}
		
		/**
		 * @private
		 */		
		protected function trimPadding(data:DisplayData, padding:Number):DisplayData
		{
			var m:Matrix = MatrixUtil.composeMatrix(0, 0, 1, 1, data.rotation);
			var point:Point = m.transformPoint(new Point(padding, padding));
			
			return new DisplayData(data.x+point.x, data.y+point.y, data.width-2*padding, data.height-2*padding, data.rotation);
		}
		
		/**
		 * @private
		 */
		protected function addPadding(data:DisplayData, padding:Number):DisplayData
		{
			var m:Matrix = MatrixUtil.composeMatrix(0, 0, 1, 1, data.rotation);
			var point:Point = m.transformPoint(new Point(padding, padding));
			
			return new DisplayData(data.x-point.x, data.y-point.y, data.width+2*padding, data.height+2*padding, data.rotation);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():DisplayData
		{
			var clone:MultiDisplayData = super.clone() as MultiDisplayData;
			
			clone._children = children;
			clone.validData = validData.clone();
			
			for each (var localChild:DisplayData in localChildren) 
			{
				clone.localChildren.push(localChild.clone());
			}
			
			return clone;
		}
	}
}