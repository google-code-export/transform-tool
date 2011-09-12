package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.operations.AnchorOperation;
	import com.vstyran.transform.operations.IAncorOperation;
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.supportClasses.Converter;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class Control extends SkinnableComponent
	{
		public var anchor:DisplayObject;
		public var shiftAnchor:DisplayObject;
		public var altAnchor:DisplayObject;
		public var ctrlAnchor:DisplayObject;
		
		public function Control()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		private function getAnchorPoint(anchor:DisplayObject):Point
		{
			if(!anchor)
				return null;
			
			return converter.transformPoint(new Point(Math.floor(anchor.width/2), Math.floor(anchor.height/2)));
		}
		
		private function resolveAnchor(event:MouseEvent):DisplayObject
		{
			if(event.shiftKey && shiftAnchor)
				return shiftAnchor;
			if(event.ctrlKey && ctrlAnchor)
				return ctrlAnchor;
			if(event.altKey && altAnchor)
				return altAnchor;
			
			return anchor;
		}
		
		protected var converter:Converter;
		
		protected function downHandler(event:MouseEvent):void
		{
			if(!tool)
				return;
			
			converter = new Converter(anchor, tool.sourcePanel);
			
			tool.startTransformation(this);
			
			if(operation)
				operation.initOperation(tool.sourceData, tool.sourcePanel.globalToLocal(new Point(event.stageX, event.stageY)));
			
			if(operation is IAncorOperation)
				(operation as IAncorOperation).anchor = getAnchorPoint(resolveAnchor(event));
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		protected function moveHandler(event:MouseEvent):void
		{
			if(operation)
				tool.doTransformation(operation.doOperation(tool.sourcePanel.globalToLocal(new Point(event.stageX, event.stageY))));
		
			event.updateAfterEvent();
		}
		
		protected function upHandler(event:MouseEvent):void
		{
			if(operation)
				tool.endTransformation(operation.doOperation(tool.sourcePanel.globalToLocal(new Point(event.stageX, event.stageY))));
			
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		public var tool:TransformTool;
		
		public var operation:IOperation;
		
		
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}