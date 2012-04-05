package other
{
  
  import com.greensock.TweenMax;
  
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.filters.DropShadowFilter;
  
  //  import vendor.as3isolib.display.IsoSprite;
  
  public class Cloud extends Sprite
  {
    private var _cloud:MovieClip =  new MovieClip();
    private var _speedX:Number = Math.random()*4 -2;
    private var _speedY:Number = Math.random()*4 -2;
    private var _angle:Number = 0;
    private var _yPos:Number = 0;
    
    public function Cloud()
    {
      super();
      init();
    }
    public function init():void{
      for(var i:int =  0; i<10;i++){
        var mc:cloud_sky =  new cloud_sky();
        _cloud.addChild(mc);
        mc.x = Math.random()*20 -10;
        mc.y = Math.random()*20-10;
      }
      _cloud.alpha = 0.4;
      _cloud.scaleX = _cloud.scaleY = .6;
      _cloud.x =  Math.random()*500 + 100;
      _yPos = Math.random()*500 + 100;
      _cloud.y = _yPos;
        addChild(_cloud);
      _cloud.filters =  [new DropShadowFilter(150,55,0x000000,.6,12,12,1)];
      tween();
    }
    private function tween():void{
      
      _cloud.x = -150;
      _cloud.y = 100;
      TweenMax.to(_cloud, 100, {bezierThrough:[{x:110, y:216}, {x:381, y:342}, {x:512, y:146}, {x:850, y:346}], orientToBezier:false,  onComplete:tween});
      
    }
  }
}