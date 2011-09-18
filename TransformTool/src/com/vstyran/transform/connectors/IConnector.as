package com.vstyran.transform.connectors
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;

	public interface IConnector extends IEventDispatcher
	{
		function setToolPanel(toolPanel:DisplayObject):void;
		
		function getData():TargetData;
		
		function transfrom(data:TargetData):TargetData;
	}
}