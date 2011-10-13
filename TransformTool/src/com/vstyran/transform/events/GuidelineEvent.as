package com.vstyran.transform.events
{
	import com.vstyran.transform.model.Guideline;
	
	import flash.events.Event;
	
	/**
	 * Event produced by transform tool in case guidelines is activated.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class GuidelineEvent extends Event
	{
		/**
		 *  The <code>GuidelineEvent.GUIDELINES_UPDATE</code> constant defines the value of the
		 *  <code>type</code> property of the event object for an <code>guidelinesUpdate</code> event.
		 *  This event is dispatched from an TransformTool when current active guides
		 *  is changed.
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType guidelinesUpdate
		 */
		public static const GUIDELINES_UPDATE:String = "guidelinesUpdate";
		
		/**
		 * @private 
		 */		
		private var _guidelines:Vector.<Guideline>;

		/**
		 * Guidelines that can make influence on transformation. 
		 */
		public function get guidelines():Vector.<Guideline>
		{
			return _guidelines;
		}

		/**
		 * Constructor.
		 *  
		 * @param type The event type; indicates the action that caused the event.
		 * @param guidelines List of active guidelines.
		 */		
		public function GuidelineEvent(type:String, guidelines:Vector.<Guideline> = null)
		{
			super(type);
			
			_guidelines = guidelines; 
		}
	}
}