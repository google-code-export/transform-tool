package com.vstyran.transform.connectors
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.events.IEventDispatcher;

	public interface IConnector extends IEventDispatcher
	{
		function getData():TargetData;
		
		function transfrom(data:TargetData):TargetData;
	}
}