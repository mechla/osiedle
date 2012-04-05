package estate
{
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  import com.greensock.easing.Sine;
  import com.greensock.events.LoaderEvent;
  import com.greensock.loading.ImageLoader;
  import com.greensock.loading.LoaderMax;
  import com.greensock.loading.display.ContentDisplay;
  
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  import flash.filters.GlowFilter;
  
  import other.Button;
  import other.Cloud;
  import other.Curtain;
  import other.Info;
  import other.Menu;
  import other.XMLLoader;
  
  public class Estate extends MovieClip
  {
    private var _home:Button = new Button(new home_btn);
    private var _info:Button =  new Button(new info_btn);
    private var _info_view:Info  = new Info();
    private var _blocks:Array;
    private var _tags:Array;
    private var _currentId:int;
    private var _current_name:String = "init";
    private var _current_floor:String = "";
    
    private var _move_spaces:move_main =  new move_main();
    private var _estate_hittest:osiedle =  new osiedle();
    
    private var _xmlData:XMLLoader =  new XMLLoader();
    
    //    private var _cloud:Cloud = new Cloud();
    private var _content:ContentDisplay;
    protected var _imageLoader:LoaderMax = new LoaderMax({name:"imageLoader",onProgress:progressHandler,onComplete:completeHandler, onError:errorHandler});
    protected var _image:ImageLoader = new ImageLoader("assets/video/OSIEDLE.jpg",{name:"startPhoto",container:this,alpha:1, width:600,heigh:1000});
    
    private var _indexX:Number = -1;
    private var _indexY:Number = -1;
    private var _menu:Menu =  new Menu();
    private var _curtain:Curtain =  new Curtain();
    private var _buildings_container:MovieClip =  new MovieClip();
    private var _estate_container:MovieClip =  new MovieClip();
    
    
    private static var _instance:Estate =  new Estate();
    
    
    
    
    public function get current_floor():String
    {
      return _current_floor;
    }

    public function set current_floor(value:String):void
    {
      _current_floor = value;
    }

    public function get xmlData():XMLLoader
    {
      return _xmlData;
    }

    public function get current_name():String
    {
      return _current_name;
    }

    public function get curtain():Curtain
    {
      return _curtain;
    }

    public static function instance():Estate
    {
      return _instance;
    }
    public function Estate()
    {
      if(_instance) throw(new Error("DO NOT CALL ME, THIS WAY!"));
    }
    public function init():void{
      _imageLoader.append(_image);
      _imageLoader.load();
    }
    private function buildingCliked(e:MouseEvent):void{
      _current_name = e.target.name;
      addMenu();
    }
    public function addBlockView():void{
      trace("changing view");
      for (var i:int =0;i<_blocks.length;i++){
        if(_blocks[i].name == _current_name){
          _currentId = i;
          _blocks[i].startLoader();
          _buildings_container.addChild(_blocks[i]);
          _blocks[i].queue.prioritize();
          addReturnHomeBtn();
        }
      }
    }
    public function removeBlockView():void{
      removeMe(_home);
      removeMe(_blocks[_currentId]);
    }
    private function addReturnHomeBtn():void{
      _buildings_container.addChild(_home);
      _home.filters = [];
      _home.addEventListeners(onBackClick);
    }
    private function addMenu():void{
      _curtain.show(false);
      _menu.updateMenuBuildingType( _current_name.toString());
    }
    public function onBackClick(...args):void{
      _curtain.show(true);
      _menu.hideMenu();
      _home.removeEventListeners(onBackClick);
      zoomOut();
    }
    private function completeHandler(e:LoaderEvent):void{
      trace("IMAGE COMPLETED DOWNLOAD!");
      _content =  _imageLoader.getContent("startPhoto");
      _content.height = 600;
      _content.width = 1000;
      _content.alpha = 0;
      _estate_container.addChild(_content)
      TweenLite.to(_content,2,{alpha:1});
      _content.addChild(_estate_hittest);
      addChild(_estate_container);
      addChild(_buildings_container);
      addChild(_curtain);
      addChild(_menu);
      addChild(_info_view);
      addHitTest();
      _home.x = 70;
      _home.y = 550;
      _info.x = 20;
      _info.y = 550;
      _info.addEventListeners(showInfo);
      addChild(_info);
      addNavigation();
    }
    private function addTag():void{
      
    }
    private function showInfo(e:MouseEvent):void{
      _info_view.show();
      _info.removeEventListener(MouseEvent.CLICK,showInfo);
      _info.addEventListeners(hideInfo);
    }
    public function hideInfo(...args):void{
      _info_view.hide();
      changeInfoEvents();
    }
    
      public function changeInfoEvents():void{
      _info.removeEventListener(MouseEvent.CLICK,hideInfo);
      _info.addEventListeners(showInfo);
    }
    
    private function addHitTest():void{
      var names:Array = ["A","B","C","D","E","F","G","H","I"];
      _blocks = new Array();
      _tags =  new Array();
      for(var i:int =0;i<names.length;i++){
        var block:Block =  new Block(names[i]);
        _blocks[i] = block;
        _blocks[i].name= names[i];
        _estate_hittest.getChildByName(names[i]).addEventListener(MouseEvent.CLICK,buildingCliked);
        _estate_hittest.getChildByName(names[i]).addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
        _estate_hittest.getChildByName(names[i]).addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
        (_estate_hittest.getChildByName(names[i]) as MovieClip).buttonMode = true;
        _estate_hittest.getChildByName(names[i]).alpha =0;
        (_estate_hittest.getChildByName(names[i]) as MovieClip).useHandCursor = true;
        (_estate_hittest.getChildByName(names[i]) as MovieClip).buttonMode = true;
        var tag:znacznik_tween = new znacznik_tween();
        _tags[i] = tag;
        _tags[i].tag.building_type.text = names[i];
        _tags[i].stop();
        _content.addChild(_tags[i]);
        _tags[i].name = names[i];
        _tags[i].x = _estate_hittest.getChildByName(names[i]).x+_estate_hittest.getChildByName(names[i]).width/2;
        _tags[i].y = _estate_hittest.getChildByName(names[i]).y+_estate_hittest.getChildByName(names[i]).height/10;
      }
    }
    ///////NAVIGATION//////////////////
    private function addNavigation():void{
      this.addEventListener(MouseEvent.MOUSE_WHEEL, zoomIn);
    }
    private function zoomOut(...args):void{
      this.removeEventListener(MouseEvent.MOUSE_WHEEL, zoomOut);
      TweenLite.to(_content,1,{width:1000,height:600,x:0,y:0,ease:Sine.easeOut,onComplete:removeMoveHitTest});
    }
    private function removeMoveHitTest():void{
      if(_move_spaces.parent != null){
        TweenMax.delayedCall(.5,addEventZoomIn);
        _estate_container.removeChild(_move_spaces);
      }
      _content.width =1000;
      _content.height = 600;
      _content.x = 0;
      _content.y = 0;
    }
    private function addEventZoomIn():void{
      this.addEventListener(MouseEvent.MOUSE_WHEEL, zoomIn);
    }
    private function addEventZoomOut():void{
      this.addEventListener(MouseEvent.MOUSE_WHEEL, zoomOut);
    }
    private function zoomIn(e:MouseEvent):void{
      this.removeEventListener(MouseEvent.MOUSE_WHEEL, zoomIn);
      TweenLite.to(_content,1,{width:2000,height:1200,x:-.25*2000,y:-.25*1200,ease:Sine.easeOut,onComplete:addMoveHitTest});
    }
    private function addMoveHitTest():void{
      TweenMax.delayedCall(.5,addEventZoomOut);
      _estate_container.addChild(_move_spaces);
      _move_spaces.down.addEventListener(MouseEvent.ROLL_OVER, moveUp);
      _move_spaces.up.addEventListener(MouseEvent.ROLL_OVER, moveDown);
      _move_spaces.right.addEventListener(MouseEvent.ROLL_OVER, moveLeft);
      _move_spaces.left.addEventListener(MouseEvent.ROLL_OVER, moveRight);
    }
    private function moveUp(e:MouseEvent):void{
      _indexY--;
      if(_indexY<-2) _indexY =-2;
      else  tweenContent();
    }
    private function moveDown(e:MouseEvent):void{
      _indexY++;
      if(_indexY>0)  _indexY=0;
      else  tweenContent();
    }
    private function moveLeft(e:MouseEvent):void{
      _indexX--;
      if(_indexX<-2) _indexX=-2;
      else tweenContent();
    }
    private function moveRight(e:MouseEvent):void{
      _indexX++;
      if(_indexX>0) _indexX=0;
      else  tweenContent();
    }
    private function tweenContent():void{
      TweenLite.to(_content,1.5,{x:_indexX*.25*2000,ease:Sine.easeInOut});
      TweenLite.to(_content,1.5,{y:_indexY*.25*1200,ease:Sine.easeInOut});
    }
    private function removeMe(mc:MovieClip):void{
      if(mc.parent != null) mc.parent.removeChild(mc);
    }
    private function onMouseOver(e:MouseEvent):void
    {
      for(var i:int = 0 ;i<_tags.length;i++){
        if(_tags[i].name==e.target.name){
          _tags[i].play();
        }
      }
      e.target.alpha = .4;
      TweenMax.to(e.target, 1, {glowFilter:{color:0xffffff, alpha:1,blurX:10, blurY:10, strength:3.5}});
    }
    private function onMouseOut(e:MouseEvent):void
    {
      for(var i:int = 0 ;i<_tags.length;i++){
        if(_tags[i].name==e.target.name){
          _tags[i].stop();
        }
      }
      e.target.alpha = 0;
      TweenMax.to(e.target, 1, {glowFilter:{color:0xffffff, alpha:0,blurX:10, blurY:10, strength:3.5}});
    }
    private function errorHandler(e:LoaderEvent):void{
      trace("error occured" + e.text);
    }
    private function progressHandler(e:LoaderEvent):void{
    }
    public function getCurrentBlock():Block{
      return _blocks[_currentId] as Block;
    }
    public function get menu():Menu
    {
      return _menu;
    }
    
  }
}