package estate
{
  import com.greensock.TweenLite;
  import com.greensock.easing.Sine;
  
  import flash.display.BlendMode;
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  
  public class Flats extends MovieClip
  {
    protected var _flats:MovieClip;
    private var _bg:MovieClip  = new MovieClip();
    public function Flats(no:int,block:String = 'G')
    {
      super();
      var name:String = block+no.toString();
      addBg();
      addFlats(name);
    }
    
    public function get flats():MovieClip
    {
      return _flats;
    }
    
    private function addBg():void{
      _bg.graphics.beginFill(0x5C5C5C,.6);
      _bg.graphics.drawRect(0,0,1000,600);
      _bg.graphics.endFill();
      this.addChild(_bg);
      _bg.alpha = 0;
      this.blendMode = BlendMode.LAYER;
    }
    private function addFlats(name:String):void{
      trace(name);
      
      switch (name){
        case "A1":{
          _flats = new A1();
          break;
        }
        case "A2":{
          _flats = new A2();
          break;
        }
        case "A3":{
          _flats = new A3();
          break;
        }
        case "B1":{
          _flats = new B1();
          break;
        }
        case "B2":{
          _flats = new B2();
          break;
        }
        case "B3":{
          _flats = new B3();
          break;
        }
        case "C1":{
          _flats = new C1();
          break;
        }
        case "C2":{
          _flats = new C2();
          break;
        }
        case "C3":{
          _flats = new C3();
          break;
        }
        case "D1":{
          _flats = new D1();
          break;
        }
        case "D2":{
          _flats = new D2();
          break;
        }
        case "E1":{
          _flats = new E1();
          break;
        }
        case "E2":{
          _flats = new E2();
          break;
        }
        case "E3":{
          _flats = new E3();
          break;
        }
        case "F1":{
          _flats = new F1();
          break;
        }
        case "F2":{
          _flats = new F2();
          break;
        }
        case "F3":{
          _flats = new F3();
          break;
        }
        case "G1":{
          _flats = new G1();
          break;
        }
        case "G2":{
          _flats = new G2();
          break;
        }
        case "G3":{
          _flats = new G3();
          break;
        }
          
        case "H1":{
          _flats = new H1();
          break;
        }
        case "H2":{
          _flats = new H2();
          break;
        }
        case "H3":{
          _flats = new H3();
          break;
        }
        case "H4":{
          _flats = new H4();
          break;
        }
          
        case "I1":{
          _flats = new I1();
          break;
        }
        case "I2":{
          _flats = new I2();
          break;
        }
        case "I3":{
          _flats = new I3();
          break;
        }
        case "I4":{
          _flats = new I4();
          break;
        }
          
        default:{ 
          _flats = new G3();
        }
      }
      addListeners();
      this.addChild(_flats);
      _flats.blendMode  = BlendMode.ERASE;
      _flats.addEventListener(MouseEvent.ROLL_OVER, flatsOver);
      _flats.addEventListener(MouseEvent.ROLL_OUT, flatsOut);
    }
    private function flatsOver(...args):void{
      TweenLite.to(_bg,.5,{alpha:1,ease:Sine.easeIn});
    }
    private function flatsOut(...args):void{
      TweenLite.to(_bg,.5,{alpha:0,ease:Sine.easeIn});
    }
    private function addListeners():void{
      for(var i:int = 0; i<_flats.numChildren;i++){
        _flats.getChildAt(i).addEventListener(MouseEvent.MOUSE_OVER,onFlatOver);
        _flats.getChildAt(i).addEventListener(MouseEvent.MOUSE_OUT,onFlatOut);
        _flats.getChildAt(i).addEventListener(MouseEvent.CLICK,onFlatClick);
        _flats.getChildAt(i).alpha =0;
        (_flats.getChildAt(i) as MovieClip).buttonMode = true;
      }
    }
    private function removeListeners():void{
      for(var i:int = 0; i<_flats.numChildren;i++){
        _flats.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OVER,onFlatOver);
        _flats.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OUT,onFlatOut);
//        _flats.getChildAt(i).removeEventListener(MouseEvent.CLICK,onFlatClick);
        (_flats.getChildAt(i) as MovieClip).buttonMode = true;
      }
    }
    private function onFlatOver(e:MouseEvent):void{
      TweenLite.to(e.target,.3,{alpha:1,ease:Sine.easeIn});
      for(var i:int = 0; i<_flats.numChildren;i++){
        if(e.target == _flats.getChildAt(i)){ 
          trace(_flats.getChildAt(i).name);
          Estate.instance().menu.showFlatDetails(_flats.getChildAt(i).name);
        }
      }
    }
    private function onFlatOut(e:MouseEvent):void{
      TweenLite.to(e.target,.3,{alpha:0,ease:Sine.easeIn});
      Estate.instance().menu.showFlatsList();
    }
    private function onFlatClick(e:MouseEvent):void{
//      for(var i:int = 0; i<_flats.numChildren;i++){
//        if(e.target == _flats.getChildAt(i)){ 
//          trace(_flats.getChildAt(i).name);
//          Estate.instance().menu.showFlatDetails(_flats.getChildAt(i).name);
//        }
//      }
    }
    private function removeMe(mc:MovieClip):void{
      addListeners();
      if(mc.stage) removeChild(mc);
    }
    public function showFlat(name:String):void{
      if(_flats.getChildByName(name)!=null){
        flatsOver();
        trace("NAME:",name)
        TweenLite.to(_flats.getChildByName(name),.3,{alpha:1,ease:Sine.easeIn});
      }
    }
    public function hideFlast():void{
      flatsOut();
      for(var i:int = 0; i<_flats.numChildren;i++)
        TweenLite.to(_flats.getChildAt(i),.3,{alpha:0,ease:Sine.easeIn});
    }
    
  }
}