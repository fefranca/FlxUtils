package com.fefranca.flixel
{
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
		
		public function FlxTilemapExt(MapData:String, TileGraphic:Class, CollisionIndex:uint = 1, DrawIndex:uint = 1) 
		{
			var tileWidth:int = 32;
			var tileHeight:int = 32;
			
			loadMap(MapData, TileGraphic, tileWidth, tileHeight);
			collideIndex = CollisionIndex;
			drawIndex = DrawIndex;
		}
		
		public function collidePoint(X:Number,Y:Number):Boolean
		{
			var d:uint =  Math.floor((Y - y) / _tileHeight) * widthInTiles + Math.floor((X - x) / _tileWidth);
			return (_data[d] < collideIndex);
		}
		
	}

}