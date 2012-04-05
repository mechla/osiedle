package other
{
  import com.greensock.TweenLite;
  
  import estate.Estate;
  
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  
  public class Info extends MovieClip
  {
    private var _info:info_page =  new info_page();
    private var _exit:Button =  new Button(_info.exit);
    private var _next:Button =  new Button(_info.next);
    private var _prev:Button =  new Button(_info.prev);
    private var _page_number:Number = 1;
    public function Info()
    {
      super();
      init();
    }
    private function init():void{
      _info.page.gotoAndStop(0);
      _info.x = 500 - _info.width/2;
      addButtons();
    }
    private function addButtons():void{
      _exit.addEventListeners(hide);
      _prev.addEventListeners(showNext);
      _next.addEventListeners(showNext);
      _info.addChild(_exit);
      _info.addChild(_prev);
      _info.addChild(_next);
    }
    //    private function showPrev(e:MouseEvent):void{
    //      if
    //      _page_number--;
    //      _info.page_number.text = _page_number.toString()+"/3";
    //    }
    private function showNext(e:MouseEvent):void{
      if(_page_number == 1)
        _page_number = 2;
      else
        _page_number = 1; 
      trace(_page_number)
      _info.page.gotoAndStop(_page_number)
//      addButtons()
    //      _page_number++;
      _info.page_number.text = _page_number.toString()+"/2";
  }
  public function show():void{
    _info.page.gotoAndStop(1);
    if(_info.parent==null)addChild(_info);
    TweenLite.to(_info, .3,{alpha:1});
  }
  public function hide(...args):void{
    TweenLite.to(_info, .3,{alpha:0, onComplete:removeInfo});
  }
  private function removeInfo():void{
    if(_info.parent!=null)removeChild(_info);
    Estate.instance().changeInfoEvents();
  }
}
}