package com.vstyran.transform.model
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.effects.Fade;
	import mx.utils.MatrixUtil;
	
	import spark.primitives.Rect;
	
	/**
	 * Value object of UI components that contains geometry info.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DisplayData
	{
		//------------------------------------------------------------------
		//
		// Standard Properties
		//
		//------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _x:Number = 0;
		
		[Bindable]
		/**
		 * Position by X axis. 
		 */
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if(_x == value) return;
			_x = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		private var _y:Number = 0;
		
		[Bindable]
		/**
		 * Position by Y axis. 
		 */
		public function get y():Number
		{
			return _y;
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if(_y == value) return;
			_y = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		private var _width:Number = 0;
		
		[Bindable]
		/**
		 * Width of display object. 
		 */
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if(_width == value) return;
			_width = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		private var _height:Number = 0;
		
		[Bindable]
		/**
		 * Height of display object. 
		 */
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			invalidate();
		}
		
		/**
		 * @private 
		 */		
		private var _rotation:Number = 0;
		
		[Bindable]
		/**
		 * Rotation of display object clamped between -180 and 180 degreeds. 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 * @private
		 */
		public function set rotation(value:Number):void
		{
			value = MatrixUtil.clampRotation(value);
			if(_rotation == value) return;
			_rotation = value;
			invalidate();
		}
		
		[Bindable]
		/**
		 * Minimum value for width. 
		 */
		public var minWidth:Number;
		
		[Bindable]
		/**
		 * Minimum value for height. 
		 */
		public var minHeight:Number;
		
		[Bindable]
		/**
		 * Maximum value for width. 
		 */
		public var maxWidth:Number;
		
		[Bindable]
		/**
		 * Maximum value for height. 
		 */
		public var maxHeight:Number;
		
		//------------------------------------------------------------------
		//
		// Additional properties
		//
		//------------------------------------------------------------------
		
		public function get size():Point
		{
			return new Point(width, height);
		}
		
		public function set size(value:Point):void
		{
			width = value.x;
			height = value.x;
		}
		
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		public function set position(value:Point):void
		{
			x = value.x;
			y = value.x;
		}
		
		
		private var _topCenter:Point;
		public function get topCenter():Point
		{
			if(!_topCenter)
			{
				if(rotation == 0)
					_topCenter = new Point(x + width/2, y);
				else				
					_topCenter = matrix.transformPoint(new Point(width/2, 0));
			}
			return _topCenter.clone();
		}
		
		private var _bottomCenter:Point;
		public function get bottomCenter():Point
		{
			if(!_bottomCenter)
			{
				if(rotation == 0)
					_bottomCenter = new Point(x + width/2, y + height);
				else				
					_bottomCenter = matrix.transformPoint(new Point(width/2, height));
			}
			return _bottomCenter.clone();
		}
		
		private var _middleLeft:Point;
		public function get middleLeft():Point
		{
			if(!_middleLeft)
			{
				if(rotation == 0)
					_middleLeft = new Point(x, y + height/2);
				else				
					_middleLeft = matrix.transformPoint(new Point(0, height/2));
			}
			return _middleLeft.clone();
		}
		
		private var _middleRight:Point;
		public function get middleRight():Point
		{
			if(!_middleRight)
			{
				if(rotation == 0)
					_middleRight = new Point(x + width, y + height/2);
				else				
					_middleRight = matrix.transformPoint(new Point(width, height/2));
			}
			return _middleRight.clone();
		}
		
		private var _topLeft:Point;
		public function get topLeft():Point
		{
			if(!_topLeft)
			{
				_topLeft = new Point(x, y);
			}
			return _topLeft.clone();
		}
		
		private var _topRight:Point;
		public function get topRight():Point
		{
			if(!_topRight)
			{
				if(rotation == 0)
					_topRight = new Point(x + width, y);
				else
					_topRight = matrix.transformPoint(new Point(width, 0));
			}
			return _topRight.clone();
		}
		
		private var _bottomLeft:Point;
		public function get bottomLeft():Point
		{
			if(!_bottomLeft)
			{
				if(rotation == 0)
					_bottomLeft = new Point(x , y + height);
				else				
					_bottomLeft = matrix.transformPoint(new Point(0, height));
			}
			return _bottomLeft.clone();
		}
		
		private var _bottomRight:Point;
		public function get bottomRight():Point
		{
			if(!_bottomRight)
			{
				if(rotation == 0)
					_bottomRight = new Point(x + width , y + height);
				else
					_bottomRight = matrix.transformPoint(new Point(width, height));
			}
			return _bottomRight.clone();
		}
		
		private var _top:Point;
		public function get top():Point
		{
			if(!_top)
			{
				if(rotation == 0)
					_top = new Point(x, y);
				else
				{
					_top = topLeft;
					if(_top.y > topRight.y)
						_top = topRight;
					if(_top.y > bottomRight.y)
						_top = bottomRight;
					if(_top.y > bottomLeft.y)
						_top = bottomLeft;
				}
			}
			return _top.clone();
		}
		
		private var _bottom:Point;
		public function get bottom():Point
		{
			if(!_bottom)
			{
				if(rotation == 0)
					_bottom = new Point(x + width, y + height);
				else
				{
					_bottom = topLeft;
					if(_bottom.y < topRight.y)
						_bottom = topRight;
					if(_bottom.y < bottomRight.y)
						_bottom = bottomRight;
					if(_bottom.y < bottomLeft.y)
						_bottom = bottomLeft;
				}
			}
			return _bottom.clone();
		}
		
		private var _left:Point;
		public function get left():Point
		{
			if(!_left)
			{
				if(rotation == 0)
					_left = new Point(x, y);
				else
				{
					_left = topLeft;
					if(_left.x > topRight.x)
						_left = topRight;
					if(_left.x > bottomRight.x)
						_left = bottomRight;
					if(_left.x > bottomLeft.x)
						_left = bottomLeft;
				}
			}
			return _left.clone();
		}
		
		private var _right:Point;
		public function get right():Point
		{
			if(!_right)
			{
				if(rotation == 0)
					_right = new Point(x + width, y + height);
				else
				{
					_right = topLeft;
					if(_right.x < topRight.x)
						_right = topRight;
					if(_right.x < bottomRight.x)
						_right = bottomRight;
					if(_right.x < bottomLeft.x)
						_right = bottomLeft;
				}
			}
			return _right.clone();
		}
		
		private var _matrix:Matrix;
		public function get matrix():Matrix
		{
			if(!_matrix)
				_matrix = MatrixUtil.composeMatrix(x, y, 1, 1, rotation);
			
			return _matrix.clone();
		}
		
		//------------------------------------------------------------------
		//
		// Private Methods
		//
		//------------------------------------------------------------------
		private var _rect:Rectangle;
		
		protected function get rect():Rectangle
		{
			if(!_rect)
				_rect = new Rectangle(x, y, width, height);
			
			return _rect.clone();
		}
		
		protected function invalidate():void
		{
			_topCenter = null;
			_bottomCenter = null;
			_middleLeft = null;
			_middleRight = null;
			_topLeft = null;
			_topRight = null;
			_bottomLeft = null;
			_bottomRight = null;
			_left = null;
			_right = null;
			_top = null;
			_bottom = null;
			_matrix = null;
			_rect = null;
		}
		
		//------------------------------------------------------------------
		//
		// Methods
		//
		//------------------------------------------------------------------
		public function intersects(data:DisplayData):Boolean
		{
			if(rotation == 0 && data.rotation == 0)
			{
				return rect.intersects(new Rectangle(data.x, data.y, data.width, data.height));
			}
			
			return false;
		}
		
		public function contains(x:Number, y:Number):Boolean
		{
			if(rotation == 0)
			{
				return rect.contains(x, y);
			}
			return false;
		}
		public function containsData(data:DisplayData):Boolean
		{
			if(rotation == 0 && data.rotation == 0)
			{
				return rect.containsRect(new Rectangle(data.x, data.y, data.width, data.height));
			}
			return false;
		}
		public function offset(dx:Number, dy:Number):void
		{
			x += !isNaN(dx) ? dx : 0;
			y += !isNaN(dy) ? dy : 0;
		}
		
		public function inflate(dx:Number, dy:Number, anchor:Point=null):void
		{
			anchor ||= new Point(width/2, height/2);
			
			var newSize:Point = (new Point(width + dx, height + dy));
			
			var m:Matrix =  new Matrix();
			m.rotate(rotation / 180 * Math.PI);
			var deltPos:Point = m.transformPoint(new Point(newSize.x*anchor.x/width - anchor.x, newSize.y*anchor.y/height-anchor.y));
			
			setTo(x - deltPos.x, y - deltPos.y, newSize.x ,newSize.y, rotation);
		}
		
		
		public function resolveMinMax(size:Point):Point
		{
			var minW:Number = isNaN(minWidth) ? Number.MIN_VALUE : minWidth;
			var minH:Number = isNaN(minHeight) ? Number.MIN_VALUE : minHeight;
			var maxW:Number = isNaN(maxWidth) ? Number.MAX_VALUE : maxWidth;
			var maxH:Number = isNaN(maxHeight) ? Number.MAX_VALUE : maxHeight;
			
			return new Point(Math.max(Math.min(maxW, size.x), minW), Math.max(Math.min(maxH, size.y), minH));
		}
		
		public function setEmpty():void
		{
			x = 0;
			y = 0;
			width = 0;
			height = 0;
			rotation = 0;
			minWidth = 0;
			minHeight = 0;
			maxWidth = 0;
			maxHeight = 0;
		}
		public function getBoundingBox():Rectangle
		{
			if(rotation == 0)
			{
				return new Rectangle(x, y, width, height);
			}
			else
			{
				var minX:Number = Math.min(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
				var minY:Number = Math.min(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
				var maxX:Number = Math.max(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
				var maxY:Number = Math.max(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
				
				return  new Rectangle(minX, minY, maxX - minX, maxY - minY);
			}	
		}
		
		public function setBoundingWidth(w:Number, anchor:Point=null):void
		{
			var delta:Point = getDeltaByRotation(w - getBoundingBox().width, 0);
			
			if(width + delta.x < 0 || height + delta.y < 0) 
			{
				delta.x = -width;  
				delta.y = -height;  
			}
			
			inflate(delta.x, delta.y, anchor);
		}
		
		public function setBoundingHeight(h:Number, anchor:Point=null):void
		{
			var delta:Point = getDeltaByRotation(0, h - getBoundingBox().height);
			
			if(width + delta.x < 0 || height + delta.y < 0) 
			{
				delta.x = -width;  
				delta.y = -height;  
			}
			
			inflate(delta.x, delta.y, anchor);
		}
		
		private function getDeltaByRotation(dx:Number, dy:Number):Point
		{
			var cos:Number = Math.cos(rotation / 180 * Math.PI);
			var sin:Number = Math.sin(rotation / 180 * Math.PI);
			var deltaWidth:Number =  cos*dx + sin*dy;
			var deltaHeight:Number = sin*dx + cos*dy;
			
			return new Point(deltaWidth, deltaHeight);
		}
		
		public function getNaturalSize():Point
		{
			return isNaturalInvertion() ? new Point(height, width) : new Point(width, height);
		}
		
		public function setNaturalSize(size:Point):void
		{
			var inversion:Boolean = isNaturalInvertion();
			width = inversion ? size.y : size.x;
			height = inversion ? size.x : size.y;
		}
		
		public function isNaturalInvertion():Boolean
		{
			return (Math.abs(rotation) > 45 && Math.abs(rotation) < 135);
		}
		
		public function toString():String
		{
			return "x: " + x + " y: " + y + " width: " + width + " height: " + height + " rotation: " + rotation +
				" minWidth: " + minWidth + " minHeight: " + minHeight + " maxWidth: " + maxWidth + " maxHeight: " + maxHeight;	
		}
		public function union(data:DisplayData, ...params):DisplayData
		{
			return null;
		}
		public function unionVector(data:Vector.<DisplayData>):DisplayData
		{
			return null;
		}
		public function unionArray(data:Array):DisplayData
		{
			return null;
		}
		
		
		public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.rotation = rotation;
		}
		
		/**
		 * Clone data.
		 *  
		 * @return New data object with the same values
		 */		
		public function clone():DisplayData
		{
			var clone:DisplayData = new DisplayData();
			clone.x = x;
			clone.y = y;
			clone.width = width;
			clone.height = height;
			clone.rotation = rotation;
			
			clone.minWidth = minWidth;
			clone.minHeight = minHeight;
			clone.maxWidth = maxWidth;
			clone.maxHeight = maxHeight;
			
			return clone;
		}
		
		/**
		 * Compare data.
		 *  
		 * @return true id data is equals
		 */		
		public function compare(value:DisplayData):Boolean
		{
			return (value &&
				value.x == x &&
				value.y == y &&
				value.width == width &&
				value.height == height &&
				value.rotation == rotation &&
				value.minWidth == minWidth &&
				value.minHeight == minHeight &&
				value.maxWidth == maxWidth &&
				value.maxHeight == maxHeight);
		}
	}
}