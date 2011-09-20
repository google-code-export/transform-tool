package com.vstyran.transform.managers.vector
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.managers.ICursorManager;
	
	import flash.display.DisplayObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	[DefaultProperty("items")]
	
	public class CursorManager implements ICursorManager, IMXMLObject
	{
		include "../../Version.as";
		
		public function CursorManager()
		{
		}
		
		public var cursorStage:IVisualElementContainer;
		
		public var useAppStage:Boolean = true;
		
		public var hideMouse:Boolean = true;
		
		public function initialized(document:Object, id:String):void
		{
			if(useAppStage)
				cursorStage = FlexGlobals.topLevelApplication as IVisualElementContainer;
			
			if(!cursorStage)
				cursorStage = document as IVisualElementContainer;
		}
		
		public function addedToStage():void
		{
			for each (var item:CursorItem in items) 
			{
				item.cursor.includeInLayout = false;
				item.cursor.visible = false;
				cursorStage.addElement(item.cursor);
			}
		}
		
		public function removedFromStage():void
		{
			for each (var item:CursorItem in items) 
			{
				cursorStage.removeElement(item.cursor);
			}
		}
		
		
		private var currentCursor:IVisualElement;
		
		public function setCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				if(currentCursor)
					currentCursor.visible = false;
				
				if(hideMouse)
					Mouse.hide();
				
				item.cursor.visible = true;
				
				currentCursor = item.cursor;
			}
			else
				Mouse.show();
		}
		
		public function removeCursor(control:Control):void
		{
			var item:CursorItem = findItem(control);
			if(item)
			{
				item.cursor.visible = false;
				currentCursor = null;
			}
			
			Mouse.show();
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
	}
}