package com.vstyran.transform.view
{
	
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.factories.TargetExporter;
	import com.vstyran.transform.factories.TargetImporter;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.supportClasses.Converter;
	import com.vstyran.transform.supportClasses.IExporter;
	import com.vstyran.transform.supportClasses.SimpleExporter;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.Skin;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class TransformTool extends SkinnableComponent
	{
		
		public function TransformTool()
		{
			super();
		}
		public var exporter:IExporter = new SimpleExporter();
		private var toolConverter:Converter;
		
		private var _source:UIComponent;

		public function get source():UIComponent
		{
			return _source;
		}

		public function set source(value:UIComponent):void
		{
			if(_source)
				_source.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_source = value;
			
			if(_source)
			{
				_source.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				sourcePanel = source.parent;
				sourceData = TransformUtil.createData(_source);
			}
			else
			{
				sourcePanel = null;
			}
			
			converterDirty = true;
			invalidateProperties();
			
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			sourcePanel = source.parent;
			converterDirty = true;
			invalidateProperties();
			
		}
		
		public var sourcePanel:DisplayObject;
		
		override public function parentChanged(p:DisplayObjectContainer):void
		{
			super.parentChanged(p);
			
			converterDirty = true;
			invalidateProperties();
		}
		
		
		private var _sourceData:TargetData;

		public function get sourceData():TargetData
		{
			return _sourceData;
		}

		public function set sourceData(value:TargetData):void
		{
			_sourceData = value;
			
			updateTool();
		}


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
		
		private var converterDirty:Boolean;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
			
			if(converterDirty)
			{
				toolConverter = new Converter(sourcePanel, parent);
				
				updateTool();
				converterDirty = false;
			}
		}
		
		public function startTransformation(control:Control):void
		{
		}
		
		public function doTransformation(data:TargetData):void
		{
			sourceData = exporter.export(source, data);
		}
		
		public function endTransformation(data:TargetData):void
		{
			sourceData = exporter.export(source, data);
		}
		
		public function updateTool():void
		{
			if(_sourceData)
				TransformUtil.applyData(this, toolConverter.transformData(_sourceData));
		}
	}
}