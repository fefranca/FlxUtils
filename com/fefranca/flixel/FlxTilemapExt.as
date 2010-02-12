package com.fefranca.flixel
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	/**
	 * This class is under construction.
	 * In its current version it is a simple hack to adapt Flan's old output to Flixel 1.45+.
	 * collidePoint is useful for checking a point against collidable tiles.
	 * 
	 * @author Fernando França
	 */
	public class FlxTilemapExt extends FlxTilemap
	{
		private var _flxBuffer:BitmapData;
		private var _buffer:BitmapData;
		private var _bufferR:Rectangle;
		private var _bufferP:Point;
		
		public function FlxTilemapExt(MapData:String, TileGraphic:Class, CollisionIndex:uint = 1, DrawIndex:uint = 1) 
		{
			var tileWidth:int = 32;
			var tileHeight:int = 32;
			
			loadMap(MapData, TileGraphic, tileWidth, tileHeight);
			collideIndex = CollisionIndex;
			drawIndex = DrawIndex;
			
			
			_bufferR = new Rectangle(0, 0, FlxG.width, FlxG.height);
			_bufferP = new Point(0, 0);
			_buffer = new BitmapData(FlxG.width, FlxG.height, true, 0);
		}
		
		public function collidePoint(X:Number,Y:Number):Boolean
		{
			var d:uint =  Math.floor((Y - y) / _tileHeight) * widthInTiles + Math.floor((X - x) / _tileWidth);
			return (_data[d] < collideIndex);
		}
		
		override public function render():void
		{
			preProcess();
			_flxBuffer = FlxG.buffer; //necessary because of double buffering
			FlxG.buffer = _buffer;
			super.render();
			FlxG.buffer = _flxBuffer;
			postProcess();
			FlxG.buffer.copyPixels(_buffer, _bufferR, _bufferP, null, null, true);
		}
		
		virtual public function preProcess():void
		{
			_buffer.fillRect(_bufferR, 0x00000000);
		}
		
		virtual public function postProcess():void {}
		
	}

}