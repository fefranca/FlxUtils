package com.fefranca.flixel 
{
	import org.flixel.*;
	
	/**
	 * FlxTilemap modified for slopes. Recommended for Flixel 1.55.
	 * (1.56+ is likely to break things up)
	 * 
	 * Check out the following public properties with confusing names:
	 * 
	 * slopeSnapping      :3 by default, play around with its values ;)
	 * floorLeftSlopes    :_/
	 * floorRightSlopes   :\_
	 * ceilingLeftSlopes  :\
	 * ceilingRightSlopes :/
	 * 
	 * @author Fernando França
	 */
	public class FlxTilemapSloped extends FlxTilemap
	{
		public var floorLeftSlopes:Array;
		public var floorRightSlopes:Array;
		public var ceilingLeftSlopes:Array;
		public var ceilingRightSlopes:Array;
		public var slopeSnapping:Number;
		
		public function FlxTilemapSloped() 
		{
			slopeSnapping = 3;
			floorLeftSlopes = new Array();
			floorRightSlopes = new Array();
			ceilingLeftSlopes = new Array();
			ceilingRightSlopes = new Array();
			super();			
		}
		
		/**
		 * Collides a <code>FlxCore</code> object against the tilemap.
		 * 
		 * @param	Core	The <code>FlxCore</code> you want to collide against.
		 */
		override public function collide(Core:FlxCore):Boolean
		{
			var r:uint;
			var c:uint;
			var d:uint;
			var i:uint;
			var dd:uint;
			var blocks:Array = new Array();
			
			//First make a list of all the blocks we'll use for collision
			var ix:uint = Math.floor((Core.x - x)/_tileWidth);
			var iy:uint = Math.floor((Core.y - y)/_tileHeight);
			var iw:uint = Math.ceil((Core.x - x + Core.width)/_tileWidth) - ix;
			var ih:uint = Math.ceil((Core.y - y + Core.height + 2)/_tileHeight) - iy;
			
			//Slope related variables
			var blockX:Number;
			var blockY:Number;
			var dotX:Number;
			var slopeY:Number;
			var coreSprite:FlxSprite;
			
			for (r = 0; r < ih; r++)
			{
				if ((r < 0) || (r >= heightInTiles)) break;
				
				d = (iy+r)*widthInTiles+ix;
				
				for(c = 0; c < iw; c++)
				{				
					if ((c < 0) || (c >= widthInTiles)) break;				
					
					dd = _data[d+c];
					if (dd >= collideIndex) {
						//Slope UP  _/
						if (floorLeftSlopes.indexOf(dd) != -1) {
							blockX = x + (ix + c) * _tileWidth;
							blockY = y + (iy + r) * _tileHeight;
							dotX = Core.x + Core.width * 0.5;
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth + slopeSnapping) {
								//y position of the slope at the current x position (y = f(x))
								slopeY = blockY + _tileHeight + blockX - dotX;
								if (Core.y + Core.height >= slopeY - slopeSnapping) {
									if (Core.y - Core.last.y >= -1) {
										Core.hitFloor(this);
										if (slopeY < blockY) slopeY = blockY;
										Core.y = slopeY -Core.height;
									}
								}
								return true;
							}
						}
						//Slope DOWN \_
						else if (floorRightSlopes.indexOf(dd) != -1) {
							blockX = x + (ix + c) * _tileWidth;
							blockY = y + (iy + r) * _tileHeight;
							dotX = Core.x + Core.width * 0.5;
							//Character inside slope
							if (dotX  >= blockX - slopeSnapping && dotX < blockX + _tileWidth) {
								slopeY = blockY - blockX + dotX;
								if (Core.y + Core.height >= slopeY - slopeSnapping) {
									if (Core.y - Core.last.y >= -1) {	
										Core.hitFloor(this);
										if (slopeY < blockY) slopeY = blockY;
										Core.y = slopeY  -Core.height;
									}
								}
								return true;
							}
						}
						//Ceiling Slope TOP LEFT \_
						else if (ceilingLeftSlopes.indexOf(dd) != -1) {
							blockX = x + (ix + c) * _tileWidth;
							blockY = y + (iy + r) * _tileHeight;
							dotX = Core.x + Core.width * 0.5;
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth) {
								slopeY = blockY - blockX + dotX;
								if (Core.y <= slopeY + slopeSnapping) {
									coreSprite = Core as FlxSprite;
									if (coreSprite.velocity.y < 0) coreSprite.velocity.y = 0;
									coreSprite.velocity.y+=10;
									Core.y = slopeY + slopeSnapping;
								}
								c = widthInTiles;
							}
						}
						//Ceiling Slope TOP RIGHT _/
						else if (ceilingRightSlopes.indexOf(dd) != -1) {
							blockX = x + (ix + c) * _tileWidth;
							blockY = y + (iy + r) * _tileHeight;
							dotX = Core.x + Core.width * 0.5;
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth) {
								slopeY = blockY + _tileHeight + blockX - dotX;
								if (Core.y <= slopeY + slopeSnapping) {
									coreSprite = Core as FlxSprite;
									if (coreSprite.velocity.y < 0) coreSprite.velocity.y = 0;
									coreSprite.velocity.y+=10;
									Core.y = slopeY + slopeSnapping;
								}
								c = widthInTiles;
							}
						}
						else {
							blocks.push( { x:x + (ix + c) * _tileWidth, y:y + (iy + r) * _tileHeight, data:dd } );
						}				 
					}
				}
			}
			
			//Time to do our regular collisions routine.
			//These won't include any sloped tiles, only old-style rectangular shaped slopes.
			var bl:uint = blocks.length;
			var hx:Boolean = false;
			var hy:Boolean = false;
						
			//Then do all the X collisions
			for(i = 0; i < bl; i++)
			{
				_block.last.x = _block.x = blocks[i].x;
				_block.last.y = _block.y = blocks[i].y;
				_block.tileIndex = blocks[i].data;
				
				if(_block.collideX(Core))
				{
					d = blocks[i].data;
					if(_callbacks[d] != null)
						_callbacks[d](Core,_block.x/_tileWidth,_block.y/_tileHeight,d);
					hx = true;
				}
			}
			
			//Then do all the Y collisions
			for(i = 0; i < bl; i++)
			{
				_block.last.x = _block.x = blocks[i].x;
				_block.last.y = _block.y = blocks[i].y;
				_block.tileIndex = blocks[i].data;
				if(_block.collideY(Core))
				{
					d = blocks[i].data;
					if(_callbacks[d] != null)
						_callbacks[d](Core,_block.x/_tileWidth,_block.y/_tileHeight,d);
					hy = true;
				}
			}
		
			return hx || hy;
		}
		
		//TODO implement overlap's override
		
	}

}