package estate
{
  import com.greensock.TweenMax;
  
  import flash.display.DisplayObject;
  import flash.display.InteractiveObject;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.geom.Point;
  
  public class Floor extends InteractivePNG
  {
    
    private var _mainImage:DisplayObject;
    private var _dot:Sprite = new Sprite();
    public function Floor()
    {
      super();
      this.buttonMode = true;
      this.useHandCursor = true;
    }
    public function highlight():void
    {
      if(_mainImage!=null)
        TweenMax.to(_mainImage,0,{glowFilter:{color:0x0000ff, alpha:1, blurX:30, blurY:30}});
    }
    public function unhighlight():void
    {
      if(_mainImage!=null)
        TweenMax.to(_mainImage, 0, {glowFilter:{color:0x0000ff, alpha:0, blurX:30, blurY:30}});
      
    }
    public function addMainChild(child:DisplayObject):void
    {
      if(_mainImage !=null && _mainImage.stage)
        removeChild(_mainImage);
      _mainImage = child;
      if(_mainImage !=null && !_mainImage.stage)
        addChild(_mainImage);
    }
    override public function addChild(child:DisplayObject):DisplayObject
    {
      var retval:DisplayObject =  super.addChild(child)
      return retval;
    }
    public function getOffset(mousePoint:Point):Point
    {
      return new Point((_mainImage.x+mousePoint.x+ _mainImage.width/2),(mousePoint.y-(_mainImage.height+_mainImage.y)));
    }
  }
}