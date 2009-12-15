package com.fefranca.flixel
{
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	
	/**
	 * UNDER CONSTRUCTION :P
	 * overlapsPoint is a good idea and I needed it for a game.
	 * On the other hand I've been using this with Flan, so I haven't updated the constructor to properly match Flixel 1.45+
	 * 
	 * Tested on: Flixel 1.45
	 * @author Fernando França
	 */
	public class FlxTilemapExt extends FlxTilemap
	{
		
		public function FlxTilemapExt(MapData:String, TileGraphic:Class, CollisionIndex:uint = 1, DrawIndex:uint = 1) 
		{
			var TileSize:int = 32;
			super(MapData, TileGraphic, TileSize, CollisionIndex, DrawIndex);
		}
		
		override public function overlapsPoint(X:Number,Y:Number,PerPixel:Boolean = false):Boolean
		{
			var d:uint =  Math.floor((Y - y) / _tileSize) * widthInTiles + Math.floor((X - x) / _tileSize);
			return (_data[d] < _ci);
		}
		
	}

}