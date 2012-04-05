package other
{
  import com.greensock.TweenMax;
  
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.text.TextFieldAutoSize;
  
  
  public class Button extends MovieClip
  {
    private var _image:Sprite;
    public function Button(image:Sprite)
    {
      super();
      _image=image;
      this.addChild(_image);
     
      
      this.buttonMode=true;
      this.mouseChildren=false;
      this.useHandCursor=true;
    }
    public function addEventListeners(onClick:Function=null):void
    {
      this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
      this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
      if(onClick!=null)
        this.addEventListener(MouseEvent.CLICK,onClick);
    }
    public function removeEventListeners(onClick:Function=null):void
    {
      this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
      this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
      if(onClick!=null)
        this.removeEventListener(MouseEvent.CLICK,onClick);
    }
    private function mouseOverHandler(evt:MouseEvent):void
    {
      TweenMax.to(this,0,{colorMatrixFilter:{brightness:1.5}});
    }
    private function mouseOutHandler(evt:MouseEvent):void
    {
      TweenMax.to(this,0,{colorMatrixFilter:{brightness:1.0}});
    }
  }
}