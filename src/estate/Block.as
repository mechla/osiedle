package estate
{
  
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  import com.greensock.easing.Sine;
  import com.greensock.events.LoaderEvent;
  import com.greensock.loading.ImageLoader;
  import com.greensock.loading.LoaderMax;
  import com.greensock.loading.display.ContentDisplay;
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.filters.ColorMatrixFilter;
  import flash.filters.GlowFilter;
  import flash.geom.Matrix;
  
  import loaders.PhotosData;
  
  import other.Button;
  
  public class Block extends MovieClip
  {
    private var _queue:LoaderMax;
    private var _flors:Array = new Array();
    private var _urls:Array = new Array();
    private var _flats:Flats =  new Flats(1,"G");
    private var _currentFloor:int = 0;
    private var _filters:Array =  new Array();
    private var _white_bg:Shape  = new Shape();
    private var _started:Boolean = false;
    
    private var _building_container:MovieClip =  new MovieClip();
    
    public function Block(blockType:String) 
    {
      //FILTERS
      _white_bg.graphics.beginFill(0xffffff,1);
      _white_bg.graphics.drawRect(0,0,1000,600);
      _white_bg.graphics.endFill();
      addChild(_white_bg);
      addChild(_building_container);
      switchUrl(blockType);
      var index:int =0;
      _queue = new LoaderMax({name:"childQueue",requireWithRoot:this.root, maxConnections:1,onError:errorHandler,onProgress:progressHandler,onComplete:completeHandler,onChildComplete:_childCompleteHandler});
      for(var i:int = _urls.length-1;i>=0;i--){
        var name:String = _urls[i].url.slice(14,16);
        var imageLoad:ImageLoader  =new ImageLoader(_urls[i].url,{name:name,x:0,y:0,estimatedBytes:_urls[i].bytes});
        _queue.append(imageLoad);
        index++;
      }
    }
    
    public function get currentFloor():int
    {
      return _currentFloor;
    }
    
    public function startLoader():void{
      if(!_started){
        _started = true;
        _queue.load();
      }else{
        for(var i:int =1;i<_flors.length;i++){
          _flors[i].alpha =1;
          _flors[i].y = 0;
        }
        addEventListeners();
        Estate.instance().curtain.hide(false);
      }
    }
    private function completeHandler(e:LoaderEvent):void{
      
      var index:int =0;
      for(var i:int = _urls.length-1;i>=0;i--){
        var name:String = _urls[i].url.slice(14,16);
        var image:Sprite = _queue.getContent(name);
        var floor:Floor = new Floor();
        var b:BitmapData = new BitmapData(1000, 600, true, 0x0);
        b.draw(image);
        var bitmap:Bitmap = new Bitmap(b);
        _flors[index] = floor;
        _flors[index].buttonMode = true;
        _flors[index].addMainChild(bitmap);//bitmap);
        _flors[index].name = index.toString();
        _flors[index].alpha = 0;
        _building_container.addChild(_flors[index]);
        TweenLite.to(_flors[index],.5,{alpha:1});
        if(index!=0){
          _flors[index].addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,10,true);
          _flors[index].addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
          _flors[index].addEventListener(MouseEvent.CLICK,mouseClickHandler);
        }
        index++;
      }
      Estate.instance().curtain.hide(false);
    }
    private function removeEventListeners():void{
      var index:int =0;
      for(var i:int = _urls.length-1;i>=0;i--){
        if(index!=0){
          _flors[index].removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
          _flors[index].removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
          _flors[index].removeEventListener(MouseEvent.CLICK,mouseClickHandler);
        }
        index++;
      }
    }
    private function mouseClickHandler(e:MouseEvent):void{
      if(int(e.target.name)<_flors.length-1){
        removeEventListeners();
        TweenMax.to(e.target,.5,{colorMatrixFilter:{brightness:1.0}});
        TweenMax.to(e.target,.5,{glowFilter:{color:0xffffff,alpha:0}});
        e.target.filters =[];
        var florNo:int = int(e.target.name)+1;
        for(var i:int =florNo;i<_flors.length;i++){
          TweenLite.to(_flors[i],1.5,{alpha:0,y:-300,ease:Sine.easeIn});
        }
        _flats =  new Flats(florNo-1,Estate.instance().current_name);
        addChild(_flats);
        Estate.instance().menu.updateMenuFloor((florNo-2).toString());
        Estate.instance().menu.showBack();
        trace("mouse click",e.target.name);
      }
    }
    public function mouseOverHandler(e:MouseEvent):void
    {
      if(int(e.target.name)<_flors.length-1){
        TweenMax.to(e.target,.5,{colorMatrixFilter:{brightness:2}});
        TweenMax.to(e.target,.5,{glowFilter:{color:0xffffff,alpha:1, blurX:15, blurY:15}});
        _currentFloor = int(e.target.name) -1
      }
    }
    private function mouseOutHandler(e:MouseEvent):void
    {
      TweenMax.to(e.target,.5,{colorMatrixFilter:{brightness:1.0}});
      TweenMax.to(e.target,.5,{glowFilter:{color:0xffffff,alpha:0}});
    }
    private function removeMe(mc:MovieClip):void{
      if(mc.stage) removeChild(mc);
    }
    public function showAllCondignations(...args):void{
      for(var i:int =1;i<_flors.length;i++){
        TweenLite.to(_flors[i],1.5,{alpha:1,y:0,ease:Sine.easeIn});
      }
      addEventListeners();
    }
    private function addEventListeners():void{
      if(_flats.parent != null)
        _flats.parent.removeChild(_flats);
      var index:int = 0;
      for(var i:int = _urls.length-1;i>=0;i--){
        if(index!=0){
          _flors[index].addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,10,true);
          _flors[index].addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
          _flors[index].addEventListener(MouseEvent.CLICK,mouseClickHandler);
        }
        index++;
      }
    }
    private function _childCompleteHandler(e:LoaderEvent):void{
    }
    private function progressHandler(e:LoaderEvent):void{
    }
    private function errorHandler(e:LoaderEvent):void{
      trace("error occured" + e.text);
    }
    private function switchUrl(blockType:String):void{
      switch(blockType)
      {
        case 'A':{
          _urls.push(new PhotosData({url:"assets/blocks/A4.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/A3.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/A2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/A1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/A0.png",bytes:968123}));
          break;
        }
        case 'B':{
          _urls.push(new PhotosData({url:"assets/blocks/B4.png",bytes:312421}));
          _urls.push(new PhotosData({url:"assets/blocks/B3.png",bytes:312421}));
          _urls.push(new PhotosData({url:"assets/blocks/B2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/B1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/B0.png",bytes:968123}));
          break;
        }
        case 'C':{
          _urls.push(new PhotosData({url:"assets/blocks/C4.png",bytes:312421}));
          _urls.push(new PhotosData({url:"assets/blocks/C3.png",bytes:312421}));
          _urls.push(new PhotosData({url:"assets/blocks/C2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/C1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/C0.png",bytes:968123}));
          break;
        }
        case 'D':{
          _urls.push(new PhotosData({url:"assets/blocks/D3.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/D2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/D1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/D0.png",bytes:968123}));
          break;
        }
        case 'E':{
          _urls.push(new PhotosData({url:"assets/blocks/E4.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/E3.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/E2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/E1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/E0.png",bytes:968123}));
          break;
        }
        case 'F':{
          _urls.push(new PhotosData({url:"assets/blocks/F4.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/F3.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/F2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/F1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/F0.png",bytes:968123}));
          break;
        }
        case 'G':{
          _urls.push(new PhotosData({url:"assets/blocks/G4.png",bytes:193817}));
          _urls.push(new PhotosData({url:"assets/blocks/G3.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/G2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/G1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/G0.png",bytes:968123}));
          break;
        }
        case 'H':{
          _urls.push(new PhotosData({url:"assets/blocks/H5.png",bytes:193817}));
          _urls.push(new PhotosData({url:"assets/blocks/H4.png",bytes:193817}));
          _urls.push(new PhotosData({url:"assets/blocks/H3.png",bytes:312421}));
          _urls.push(new PhotosData({url:"assets/blocks/H2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/H1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/H0.png",bytes:968123}));
          break;
        }
        case 'I':{
          _urls.push(new PhotosData({url:"assets/blocks/I5.png",bytes:193817}));
          _urls.push(new PhotosData({url:"assets/blocks/I4.png",bytes:193817}));
          _urls.push(new PhotosData({url:"assets/blocks/I3.png",bytes:312421 }));
          _urls.push(new PhotosData({url:"assets/blocks/I2.png",bytes:312392}));
          _urls.push(new PhotosData({url:"assets/blocks/I1.png",bytes:279849}));
          _urls.push(new PhotosData({url:"assets/blocks/I0.png",bytes:968123}));
          break;
        }
      }
    }
    public function get queue():LoaderMax
    {
      return _queue;
    }
    public function getFlast():Flats{
      return _flats;
    }
    
  }
}

