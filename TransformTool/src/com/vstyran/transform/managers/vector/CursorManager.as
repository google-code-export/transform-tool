package com.vstyran.transform.managers.vector
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import com.vstyran.transform.namespaces.tt_internal;
	
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
	
	public class CursorManager implements ICursorManager, IMXMLObject
	{
		include "../../Version.as";
		
		public function CursorManager()
		{
		}
		
		private var cursorStage:IVisualElementContainer;
		
		public var hideMouse:Boolean = true;
		
		public function initialized(document:Object, id:String):void
		{
			cursorStage = FlexGlobals.topLevelApplication as IVisualElementContainer;
		}
		
		private var _tool:TransformTool;
		
		public function set tool(value:TransformTool):void
		{
			if(_tool != value)
			{
				for each (var item:CursorItem in items) 
				{
					item.cursor.includeInLayout = false;
					item.cursor.visible = false;
					if((item.cursor as Object).hasOwnProperty("rotation"))
						item.originalRotation = (item.cursor as Object).rotation;
					cursorStage.addElement(item.cursor);
				}
				
				_tool = value;
			}
		}
		
		private var currentCursor:IVisualElement;
		
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
		
		private function moveHandler(event:MouseEvent):void
		{
			if(currentCursor)
			{
				setCursorPosition(event.stageX, event.stageY);
				event.updateAfterEvent();
			}
		}
		
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
					var m:Matrix = TransformUtil.getTransformationMatrix(_tool.parent, null);
					var data:TargetData = TransformUtil.transformData(m, TransformUtil.createData(_tool));
					
					var matrix:Matrix = new Matrix();
					matrix.translate(-currentCursor.getLayoutBoundsWidth()/2, -currentCursor.getLayoutBoundsHeight()/2);
					matrix.rotate((data.rotation + item.originalRotation) * Math.PI/180);
					matrix.translate(currentCursor.getLayoutBoundsWidth()/2, currentCursor.getLayoutBoundsHeight()/2);
					currentCursor.setLayoutMatrix(matrix, false);
					
					delta = matrix.transformPoint(new Point(currentCursor.getLayoutBoundsWidth()/2, currentCursor.getLayoutBoundsHeight()/2));
				}
				else
				{
					delta = new Point(currentCursor.getLayoutBoundsWidth()/2, currentCursor.getLayoutBoundsHeight()/2);
				}
				
				
				setCursorPosition(stageX, stageY);
			}
		}
		
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
		
		public var items:Vector.<CursorItem>;
		
		private var delta:Point;
		
		private function setCursorPosition(stageX:Number, stageY:Number):void
		{
			if(currentCursor)
			{
				currentCursor.x = stageX - delta.x;
				currentCursor.y = stageY - delta.y;
			}
		}
		
	}
}