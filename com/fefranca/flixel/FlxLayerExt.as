package com.fefranca.flixel
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxLayer;
	import org.flixel.FlxState;
	
	/**
	 * Adds a buffer you this layer.
	 * @author Fernando França
	 */
	public class FlxLayerExt extends FlxLayer
	{
		private var _flxBuffer:BitmapData;
		private var _buffer:BitmapData;
		private var _r:Rectangle;
		
		public function FlxLayerExt() 
		{
			_r = new Rectangle(0, 0, FlxG.width, FlxG.height);
			_buffer = new BitmapData(FlxG.width, FlxG.height, true, 0);
			super();
			
		}
		
		override public function render():void
		{
			preProcess();
			_flxBuffer = FlxG.buffer;
			FlxG.buffer = _buffer;
			super.render();
			FlxG.buffer = _flxBuffer;
			postProcess();
		}
		
		virtual public function preProcess():void
		{
			_buffer.fillRect(_r, 0);
		}
		
		virtual public function postProcess():void { }
		
	}

}