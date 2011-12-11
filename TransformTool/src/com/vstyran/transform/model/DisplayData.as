package com.vstyran.transform.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	public class DisplayData extends EventDispatcher
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
		
		[Bindable("xChanged")]
		/**
		 * Position by X axis. 
		 */
		public function get x():Number
		{
			return round(_x);
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if(_x == value) return;
			_x = value;
			invalidate();
			dispatchEvent(new Event("xChanged"));
		}
		
		/**
		 * @private
		 */
		private var _y:Number = 0;
		
		[Bindable("yChanged")]
		/**
		 * Position by Y axis. 
		 */
		public function get y():Number
		{
			return round(_y);
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if(_y == value) return;
			_y = value;
			invalidate();
			dispatchEvent(new Event("xChanged"));
		}
		
		/**
		 * @private
		 */
		private var _width:Number = 0;
		
		[Bindable("widthChanged")]
		/**
		 * Width of display object. 
		 */
		public function get width():Number
		{
			return round(_width);
		}
		
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if(_width == value) return;
			_width = value;
			invalidate();
			dispatchEvent(new Event("widthChanged"));
		}
		
		/**
		 * @private
		 */
		private var _height:Number = 0;
		
		[Bindable("heightChanged")]
		/**
		 * Height of display object. 
		 */
		public function get height():Number
		{
			return round(_height);
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			invalidate();
			dispatchEvent(new Event("heightChanged"));
		}
		
		/**
		 * @private 
		 */		
		private var _rotation:Number = 0;
		
		[Bindable("rotationChanged")]
		/**
		 * Rotation of display object clamped between -180 and 180 degreeds. 
		 */
		public function get rotation():Number
		{
			return round(_rotation);
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
			dispatchEvent(new Event("rotationChanged"));
		}
		
		private var _minWidth:Number;

		[Bindable]
		/**
		 * Minimum value for width. 
		 */
		public function get minWidth():Number
		{
			return round(_minWidth);
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			_minWidth = value;
		}

		
		private var _minHeight:Number;

		[Bindable]
		/**
		 * Minimum value for height. 
		 */
		public function get minHeight():Number
		{
			return round(_minHeight);
		}

		/**
		 * @private
		 */
		public function set minHeight(value:Number):void
		{
			_minHeight = value;
		}

		
		private var _maxWidth:Number;

		[Bindable]
		/**
		 * Maximum value for width. 
		 */
		public function get maxWidth():Number
		{
			return round(_maxWidth);
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}

		
		private var _maxHeight:Number;

		[Bindable]
		/**
		 * Maximum value for height. 
		 */
		public function get maxHeight():Number
		{
			return round(_maxHeight);
		}

		/**
		 * @private
		 */
		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}

		
		//------------------------------------------------------------------
		//
		// Additional properties
		//
		//------------------------------------------------------------------
		
		private var _precisionValue:uint = 0;
		private var _precision:int = -1;

		[Bindable]
		public function get precision():int
		{
			return _precision;
		}

		public function set precision(value:int):void
		{
			if(_precision == value) return;
			
			_precision = Math.min(value, 14);
			
			_precisionValue = _precision >= 0 ? Math.pow(10, precision) : 0;
		}

		
		public function get size():Point
		{
			return new Point(width, height);
		}
		
		public function set size(value:Point):void
		{
			_width = value.x;
			_height = value.y;
			
			invalidate();
			
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
		}
		
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		public function set position(value:Point):void
		{
			_x = value.x;
			_y = value.y;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
		}
		
		
		private var _topCenter:Point;
		[Bindable("invalidated")]
		public function get topCenter():Point
		{
			if(!_topCenter)
			{
				if(rotation == 0)
					_topCenter = new Point(x + width/2, y);
				else				
					_topCenter = matrix.transformPoint(new Point(width/2, 0));
			}
			return new Point(round(_topCenter.x), round(_topCenter.y));
		}
		
		private var _bottomCenter:Point;
		[Bindable("invalidated")]
		public function get bottomCenter():Point
		{
			if(!_bottomCenter)
			{
				if(rotation == 0)
					_bottomCenter = new Point(x + width/2, y + height);
				else				
					_bottomCenter = matrix.transformPoint(new Point(width/2, height));
			}
			return new Point(round(_bottomCenter.x), round(_bottomCenter.y));
		}
		
		private var _middleLeft:Point;
		[Bindable("invalidated")]
		public function get middleLeft():Point
		{
			if(!_middleLeft)
			{
				if(rotation == 0)
					_middleLeft = new Point(x, y + height/2);
				else				
					_middleLeft = matrix.transformPoint(new Point(0, height/2));
			}
			return new Point(round(_middleLeft.x), round(_middleLeft.y));
		}
		
		private var _middleRight:Point;
		[Bindable("invalidated")]
		public function get middleRight():Point
		{
			if(!_middleRight)
			{
				if(rotation == 0)
					_middleRight = new Point(x + width, y + height/2);
				else				
					_middleRight = matrix.transformPoint(new Point(width, height/2));
			}
			return new Point(round(_middleRight.x), round(_middleRight.y));
		}
		
		private var _topLeft:Point;
		[Bindable("invalidated")]
		public function get topLeft():Point
		{
			if(!_topLeft)
			{
				_topLeft = new Point(x, y);
			}
			return new Point(round(_topLeft.x), round(_topLeft.y));
		}
		
		private var _topRight:Point;
		[Bindable("invalidated")]
		public function get topRight():Point
		{
			if(!_topRight)
			{
				if(rotation == 0)
					_topRight = new Point(x + width, y);
				else
					_topRight = matrix.transformPoint(new Point(width, 0));
			}
			return new Point(round(_topRight.x), round(_topRight.y));
		}
		
		private var _bottomLeft:Point;
		[Bindable("invalidated")]
		public function get bottomLeft():Point
		{
			if(!_bottomLeft)
			{
				if(rotation == 0)
					_bottomLeft = new Point(x , y + height);
				else				
					_bottomLeft = matrix.transformPoint(new Point(0, height));
			}
			return new Point(round(_bottomLeft.x), round(_bottomLeft.y));
		}
		
		private var _bottomRight:Point;
		[Bindable("invalidated")]
		public function get bottomRight():Point
		{
			if(!_bottomRight)
			{
				if(rotation == 0)
					_bottomRight = new Point(x + width , y + height);
				else
					_bottomRight = matrix.transformPoint(new Point(width, height));
			}
			return new Point(round(_bottomRight.x), round(_bottomRight.y));
		}
		
		private var _top:Point;
		[Bindable("invalidated")]
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
			return new Point(round(_top.x), round(_top.y));
		}
		
		private var _bottom:Point;
		[Bindable("invalidated")]
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
			return new Point(round(_bottom.x), round(_bottom.y));
		}
		
		private var _left:Point;
		[Bindable("invalidated")]
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
			return new Point(round(_left.x), round(_left.y));
		}
		
		private var _right:Point;
		[Bindable("invalidated")]
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
			return new Point(round(_right.x), round(_right.y));
		}
		
		private var _matrix:Matrix;
		[Bindable("invalidated")]
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
			
			dispatchEvent(new Event("invalidated"));
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			if(hasEventListener(event.type))
				return super.dispatchEvent(event);
			else
				return false;
		}
		
		private function round(value:Number):Number
		{
			if(_precisionValue > 0)
				return Math.round(value*_precisionValue)/_precisionValue;
			else
				return value;
		}
		
		//------------------------------------------------------------------
		//
		// Methods
		//
		//------------------------------------------------------------------
		public function intersects(data:DisplayData):Boolean
		{
			return (contains(data.topLeft.x, data.topLeft.y) ||
				contains(data.topRight.x, data.topRight.y) ||
				contains(data.bottomRight.x, data.bottomRight.y) ||
				contains(data.bottomLeft.x, data.bottomLeft.y) ||
				data.contains(topLeft.x, topLeft.y) ||
				data.contains(topRight.x, topRight.y) ||
				data.contains(bottomRight.x, bottomRight.y) ||
				data.contains(bottomLeft.x, bottomLeft.y));
			
			return false;
		}
		
		public function contains(x:Number, y:Number):Boolean
		{
			if(rotation == 0)
			{
				return rect.contains(x, y);
			}
			else
			{
				var m:Matrix = matrix;
				m.invert();
				var localPoint:Point = m.transformPoint(new Point(x, y));
				
				return rect.contains(localPoint.x, localPoint.y)
			}
		}
		public function containsData(data:DisplayData):Boolean
		{
			return (contains(data.topLeft.x, data.topLeft.y) &&
					contains(data.topRight.x, data.topRight.y) &&
					contains(data.bottomRight.x, data.bottomRight.y) &&
					contains(data.bottomLeft.x, data.bottomLeft.y));
		}
		public function offset(dx:Number, dy:Number):void
		{
			_x += !isNaN(dx) ? dx : 0;
			_y += !isNaN(dy) ? dy : 0;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
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
			minWidth = 0;
			minHeight = 0;
			maxWidth = 0;
			maxHeight = 0;
			
			setTo(0, 0, 0, 0, 0);
		}
		public function rotate(angle:Number, anchor:Point):void
		{
			anchor ||= new Point(width/2, height/2);
			
			var m:Matrix = matrix;
			m.translate(-anchor.x, -anchor.y);
			m.rotate(angle*Math.PI/180);
			m.translate(anchor.x, anchor.y);
			
			position = m.transformPoint(new Point(0, 0));
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
		
		public function setBoundingPosition(x:Number, y:Number):void
		{
			var currentBox:Rectangle = getBoundingBox();
			offset(x - currentBox.x, y - currentBox.y);
		}
		
		public function setBoundingWidth(w:Number, anchor:Point=null):void
		{
			var delta:Point = getDeltaByRotation(w - getBoundingBox().width, 0);
			
			setBoundingSizeInternal(delta.x, delta.y, anchor);
		}
		
		public function setBoundingHeight(h:Number, anchor:Point=null):void
		{
			var delta:Point = getDeltaByRotation(0, h - getBoundingBox().height);
			
			setBoundingSizeInternal(delta.x, delta.y, anchor);
		}
		
		public function setBoundingSizeInternal(w:Number, h:Number, anchor:Point=null):void
		{
			if(width + w < 0 || height + h < 0) 
			{
				w = -width;  
				h = -height;  
			}
			
			inflate(w, h, anchor);
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
			_width = inversion ? size.y : size.x;
			_height = inversion ? size.x : size.y;
			
			invalidate();
			
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
		}
		
		public function isNaturalInvertion():Boolean
		{
			return (Math.abs(rotation) > 45 && Math.abs(rotation) < 135);
		}
		
		override public function toString():String
		{
			return "x: " + x + " y: " + y + " width: " + width + " height: " + height + " rotation: " + rotation +
				" minWidth: " + minWidth + " minHeight: " + minHeight + " maxWidth: " + maxWidth + " maxHeight: " + maxHeight;	
		}
		public function union(data:DisplayData, ...params):Rectangle
		{
			params ||= new Array();
			params.push(data);
			
			return unionArray(params);
		}
		
		public function unionVector(list:Vector.<DisplayData>):Rectangle
		{
			var union:Rectangle = getBoundingBox();
			for each (var data:DisplayData in list) 
			{
				union.union(data.getBoundingBox());
			}
			
			return union;
		}
		public function unionArray(list:Array):Rectangle
		{
			var union:Rectangle = getBoundingBox();
			for each (var data:DisplayData in list) 
			{
				union.union(data.getBoundingBox());
			}
			
			return union;
		}
		
		
		public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_rotation = rotation;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
			dispatchEvent(new Event("rotationChanged"));
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
			
			clone.precision = precision;
			
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