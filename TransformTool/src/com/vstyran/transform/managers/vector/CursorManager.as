package com.vstyran.transform.managers.vector
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.controls.Hint;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.TransformUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	use namespace tt_internal;
	
	[DefaultProperty("items")]
	/**
	 * Cursor manager for vector transform tool cursors. 
	 * This type of cursors can change their rotation depends on rotation of transform tool.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class CursorManager implements ICursorManager
	{
		/**
		 * Constructor. 
		 */		
		public function CursorManager()
		{
			cursorStage = FlexGlobals.topLevelApplication as IVisualElementContainer;
		}
		
		/**
		 * @private 
		 * Panel there cursors will be placed.
		 */		
		private var cursorStage:IVisualElementContainer;
		
		/**
		 * Flag that indicates whether system mouse cursor should be hidden. 
		 */		
		public var hideMouse:Boolean = true;
		
		/**
		 * @private 
		 */		
		private var _tool:TransformTool;
		
		/**
		 * List of cursors. 
		 */		
		public var items:Vector.<CursorItem>;
		
		/**
		 * @private
		 * Flag that indicates whether cursors are added to stage.
		 */		
		private var cursorsAdded:Boolean;
		
		/**
		 * @inheritDoc 
		 */		
		public function set tool(value:TransformTool):void
		{
			if(_tool != value)
			{
				if(!cursorsAdded && value)
					addRemoveCursors();
				
				if(cursorsAdded && !value)
					addRemoveCursors(false);
					
				_tool = value;
				
				if(_hint)
					_hint.tool = _tool;
			}
		}
		
		/**
		 * @private 
		 */		
		private var _hint:Hint;

		/**
		 * Transformation hint. 
		 */		
		public function get hint():Hint
		{
			return _hint;
		}

		/**
		 * @private 
		 */	
		public function set hint(value:Hint):void
		{
			if(_hint == value) return;
			
			if(_hint)
				_hint.tool = null;
			
			_hint = value;
			
			if(_hint)
				_hint.tool = _tool;
			
			setHintPosition();
		}

		/**
		 * Hint offset by X axis. 
		 */		
		public var hintXOffset:Number = 0;
		
		/**
		 * Hint offset by Y axis. 
		 */	
		public var hintYOffset:Number = 0;
		
		/**
		 * @private 
		 * Add or remove cursors to stage.
		 */		
		private function addRemoveCursors(adding:Boolean = true):void
		{
			for each (var item:CursorItem in items) 
			{
				item.cursor.includeInLayout = false;
				item.cursor.visible = false;
				if(adding)
				{
					cursorStage.addElement(item.cursor);
				}
				else
				{
					if(item.cursor.parent)
						cursorStage.removeElement(item.cursor);
				}
			}
			
			cursorsAdded = adding;
		}
		
		/**
		 * Current active cursor. 
		 */		
		private var currentCursor:IVisualElement;
		
		/**
		 * @private
		 * Show cursor.
		 */		
		private function setCurrentCursor(value:IVisualElement):void
		{
			if(currentCursor != value)
			{
				if(currentCursor)
					(cursorStage as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
				
				currentCursor = value;
				
				if(currentCursor)
					(cursorStage as IEventDispatcher).addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}
		}
		
		/**
		 * Mouse move event handler 
		 */		
		private function moveHandler(event:MouseEvent):void
		{
			if(currentCursor)
			{
				setCursorPosition(event.stageX, event.stageY);
				event.updateAfterEvent();
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function setCursor(control:Control, stageX:Number, stageY:Number):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				if(currentCursor)
					currentCursor.visible = false;
				
				if(hideMouse)
					Mouse.hide();
				
				item.cursor.visible = true;
				
				setCurrentCursor(item.cursor);
				
				currentCursor.setLayoutBoundsSize(NaN, NaN);
				if(item.maintainRotation)
				{
					var m:Matrix = TransformUtil.getMatrix(_tool.parent, null);
					var data:DisplayData = TransformUtil.transformData(m, DataUtil.createData(_tool));
					
					var matrix:Matrix = new Matrix();
					matrix.translate(-currentCursor.width/2, -currentCursor.height/2);
					matrix.rotate((data.rotation + item.originalRotation) * Math.PI/180);
					matrix.translate(currentCursor.width/2, currentCursor.height/2);
					
					currentCursor.setLayoutMatrix(matrix, false);
					
					matrix = new Matrix();
					matrix.rotate((data.rotation + item.originalRotation) * Math.PI/180);
					
					delta = matrix.transformPoint(new Point(currentCursor.width/2, currentCursor.height/2));
				}
				else
				{
					delta = new Point(currentCursor.width/2, currentCursor.height/2);
				}
				
				delta.x = item.xOffset - delta.x;
				delta.y = item.yOffset - delta.y;
				
				setCursorPosition(stageX, stageY);
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		public function removeCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				item.cursor.visible = false;
				setCurrentCursor(null);
				Mouse.show();
			}
		}
		
		/**
		 * @private
		 * 
		 * Find item that corresponds to control.  
		 */		
		private function findItem(control:Control):CursorItem
		{
			if(items)
			{
				for each (var item:CursorItem in items) 
				{
					if(item.control == control)
						return item;
				}
			}
			
			return null;
		}
		
		/**
		 * @private 
		 * Current cursor delta position 
		 */		
		private var delta:Point;
		
		/**
		 * @private 
		 * 
		 * Set current cursor position taking to account delta value
		 */		
		private function setCursorPosition(stageX:Number, stageY:Number):void
		{
			if(currentCursor)
			{
				currentCursor.x = stageX + delta.x;
				currentCursor.y = stageY + delta.y;
			}
			
			setHintPosition();
		}
		
		/**
		 * @private 
		 * 
		 * Set hint position taking to account offset value
		 */	
		private function setHintPosition():void
		{
			if(hint && currentCursor)
			{
				hint.x = currentCursor.x - delta.x + hintXOffset;
				hint.y = currentCursor.y - delta.y + hintYOffset;
			}
		}
	}
}