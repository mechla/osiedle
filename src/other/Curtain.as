package other
{
  import com.greensock.TweenLite;
  
  import estate.Estate;
  
  import flash.display.MovieClip;
  
  public class Curtain extends MovieClip
  {
    private var _curtain:MovieClip;
    public function Curtain()
    {
      super();
      initCurtain();
    }
    private function initCurtain():void{
      _curtain =  new MovieClip();
      _curtain.graphics.beginFill(0xffffff,1);
      _curtain.graphics.drawRect(0,0,1000,600);
      _curtain.graphics.endFill();
      var logo:logo_ =  new logo_();
      logo.x = 500 - logo.width/2;
      logo.y = 300 - logo.height/2;
      _curtain.addChild(logo);
    }
    public function hide(back:Boolean = false):void{
     if(back) {
       Estate.instance().removeBlockView();
     }
     else{
       Estate.instance().menu.showMenu();
     }
      TweenLite.to(_curtain,1,{alpha:0,delay:.5, onComplete:removeCurtain});
    }
    private function removeCurtain():void{
      removeChild(_curtain);
    }
    public function show(back:Boolean = false):void{
      addChild(_curtain);
      _curtain.alpha = 0;
      TweenLite.to(_curtain,1,{alpha:1,onComplete:changeView, onCompleteParams:[back]});
    }
    private function changeView(back:Boolean):void{
      if(back)
        hide(back);
      else
      Estate.instance().addBlockView();
    }
  }
}