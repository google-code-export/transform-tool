package com.vstyran.transform.view
{
	
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class TransformTool extends SkinnableComponent
	{
		include "../Version.as";
		
		[SkinPart]
		public var toolCursorManager:ICursorManager;
		
		public function TransformTool()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		private var addedToStage:Boolean;
		protected function removedFromStageHandler(event:Event):void
		{
			addedToStage = false;
			
			if(toolCursorManager)
				toolCursorManager.tool = null;
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			if(connector)
				connector.setToolPanel(parent);
			
			addedToStage = true;
			
			if(toolCursorManager)
				toolCursorManager.tool = this;
			
			updateTool();
		}
		
		private var _connector:IConnector;

		public function get connector():IConnector
		{
			return _connector;
		}

		public function set connector(value:IConnector):void
		{
			if(_connector != value)
			{
				if(_connector)
					_connector.removeEventListener(ConnectorEvent.DATA_CHANGE, dataChangeHendler);
				
				_connector = value;
				
				if(_connector)
					_connector.addEventListener(ConnectorEvent.DATA_CHANGE, dataChangeHendler);
				
				updateTool();
			}
		}
		
		private function dataChangeHendler(event:ConnectorEvent):void
		{
			updateTool();
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if(skin)
				skin.addEventListener(Event.ADDED_TO_STAGE, addedHandler, true);
			
			
			validateControls = true;
			invalidateProperties();
		}
		
		protected function addedHandler(event:Event):void
		{
			skin.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			validateControls = true;
			invalidateProperties();
		}
		
		protected function processParts(container:UIComponent):void
		{
			if(container is Control)
			{
				(container as Control).tool = this;
				return;
			}
			
			if(container is IVisualElementContainer)
			{
				for (var i:int = 0; i < (container as IVisualElementContainer).numElements; i++) 
				{
					var element:IVisualElement = (container as IVisualElementContainer).getElementAt(i);
					if(element is UIComponent)
						processParts(element as UIComponent);	
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == toolCursorManager && addedToStage)
			{
				toolCursorManager.tool = this;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == toolCursorManager)
			{
				toolCursorManager.tool = null;
			}
		}
		
		private var validateControls:Boolean;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
		}
		
		private var _transforming:Boolean;

		public function get transforming():Boolean
		{
			return _transforming;
		}

		public function startTransformation(control:Control):void
		{
			_transforming = true;
		}
		
		public function doTransformation(data:DisplayData):void
		{
			TransformUtil.applyData(this, connector.transfrom(data));
		}
		
		public function endTransformation(data:DisplayData):void
		{
			TransformUtil.applyData(this, connector.transfrom(data));
			
			_transforming = false;
		}
		
		public function updateTool():void
		{
			var data:DisplayData = connector.getData();
			if(data)
				TransformUtil.applyData(this, data, true);
		}
	}
}