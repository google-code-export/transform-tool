package com.vstyran.transform.view
{
	
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class TransformTool extends SkinnableComponent
	{
		
		public function TransformTool()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedTostageHandler);
		}
		
		protected function addedTostageHandler(event:Event):void
		{
			if(connector)
				connector.setToolPanel(parent);
			
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
		
		public function startTransformation(control:Control):void
		{
		}
		
		public function doTransformation(data:TargetData):void
		{
			TransformUtil.applyData(this, connector.transfrom(data));
		}
		
		public function endTransformation(data:TargetData):void
		{
		}
		
		public function updateTool():void
		{
			var data:TargetData = connector.getData()
			if(data)
				TransformUtil.applyData(this, data);
		}
	}
}