package com.vstyran.transform.view
{
	
	import com.vstyran.transform.connectors.IConnector;
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.managers.ICursorManager;
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.skins.TransformToolSkin;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.SkinUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	use namespace tt_internal;
	
	/**
	 *  Dispatched when the guidelines is activated.
	 *
	 *  @eventType com.vstyran.transform.events.GuidelineEvent.GUIDELINES_UPDATE
	 */
	[Event(name="guidelinesUpdate", type="com.vstyran.transform.events.GuidelineEvent")]
	
	/**
	 * Transfrom tool that can edit geometry properties of target object.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class TransformTool extends SkinnableComponent
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.transform.view.TransformTool", TransformToolSkin);
		
		[SkinPart]
		/**
		 * Manager for managing cursors under controls. 
		 */		
		public var toolCursorManager:ICursorManager;
		
		[SkinPart]
		/**
		 * Move control. 
		 */		
		public var moveControl:Control;
		
		/**
		 * Constructor. 
		 */		
		public function TransformTool()
		{
			super();
			
			includeInLayout = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		/**
		 * @private 
		 */		
		private var _connector:IConnector;
		
		/**
		 * Connector object for managing transform targets. 
		 */		
		public function get connector():IConnector
		{
			return _connector;
		}
		
		/**
		 * @private 
		 */		
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
		
		/**
		 * Grid that will be used as step size for operations. 
		 */		
		public var grid:GridData;
		
		/**
		 * Bounds that will be used position boundaries. 
		 */		
		public var bounds:Bounds;
		
		/**
		 * Guide lines. 
		 */		
		public var guidelines:Vector.<Guideline>;
		
		//------------------------------------------------
		// Life cycle methods
		//------------------------------------------------
		/**
		 * @inheritDoc 
		 */		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if(skin)
				skin.addEventListener(Event.ADDED_TO_STAGE, skinAddedHandler, true);
			
			validateControls = true;
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == toolCursorManager && addedToStage)
			{
				toolCursorManager.tool = this;
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == toolCursorManager)
			{
				toolCursorManager.tool = null;
			}
		}
		
		/**
		 * @private 
		 */		
		private var validateControls:Boolean;
		
		/**
		 * @inheritDoc 
		 */		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
		}
		
		/**
		 * Skin added to stage
		 * @private
		 */		
		protected function skinAddedHandler(event:Event):void
		{
			skin.removeEventListener(Event.ADDED_TO_STAGE, skinAddedHandler);
			
			validateControls = true;
			invalidateProperties();
		}
		
		/**
		 * Loop through all skin elements and add tool to all Controls
		 * @private 
		 */		
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
		
	
		//------------------------------------------------
		// Event handlers
		//------------------------------------------------
		
		/**
		 * @private 
		 */		
		private var addedToStage:Boolean;
		
		/**
		 * Tool added to stage handler 
		 * @private
		 */	
		protected function addedToStageHandler(event:Event):void
		{
			if(connector)
				connector.setToolPanel(parent);
			
			addedToStage = true;
			
			if(toolCursorManager)
				toolCursorManager.tool = this;
			
			updateTool();
		}
		
		/**
		 * Tool removed from stage handler 
		 * @private
		 */		
		protected function removedFromStageHandler(event:Event):void
		{
			addedToStage = false;
			
			if(toolCursorManager)
				toolCursorManager.tool = null;
		}
		
		/**
		 * Connector data change handler.
		 * Data is changed by target so we need to update transform tool.
		 * @param event
		 */		
		private function dataChangeHendler(event:ConnectorEvent):void
		{
			updateTool();
		}
		
		
		//------------------------------------------------
		// Methods
		//------------------------------------------------
		
		/**
		 * @private 
		 */		
		private var _transforming:Boolean;

		/**
		 * Flag that indicate whether tyransforming is in progress. 
		 */		
		public function get transforming():Boolean
		{
			return _transforming;
		}

		/**
		 * Start transformation (mouse down on control) 
		 */		
		public function startTransformation(control:Control):void
		{
			_transforming = true;
		}
		
		/**
		 * Transformation is in progress (mouse move on control) 
		 */	
		public function doTransformation(data:DisplayData):void
		{
			DataUtil.applyData(this, connector.transfrom(data));
		}
		
		/**
		 * Transformation is finished  (mouse up on control)
		 */		
		public function endTransformation(data:DisplayData):void
		{
			DataUtil.applyData(this, connector.complete(data));
			
			_transforming = false;
		}
		
		/**
		 * Upodate size, position, etc. of tool 
		 */		
		public function updateTool():void
		{
			var data:DisplayData = connector.getData();
			if(data)
				DataUtil.applyData(this, data, true);
		}
		
		/**
		 * Start moving.
		 * 
		 * @param mouseEvent Mouse down event.
		 */		
		public function startMoving(mouseEvent:MouseEvent):void
		{
			validateNow();
			if(moveControl && mouseEvent && mouseEvent.type == MouseEvent.MOUSE_DOWN && mouseEvent.buttonDown)
			{
				moveControl.startTransformation(mouseEvent);
			}
		}
	}
}