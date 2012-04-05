package other
{
  import com.greensock.TweenLite;
  import com.greensock.loading.XMLLoader;
  
  import estate.Estate;
  
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.utils.flash_proxy;
  
  public class Menu extends MovieClip
  {
    
    private var _menu:menu =  new menu();
    private var _back:go_back =  new go_back();
    private var _change:Button =  new Button(_menu.choose_condignation);
    private var _pos:Number  = 0;
    private var _rooms:Sprite =  new Sprite();
    private var _flats_array:Array =  new Array()
    private var _buttonchange:Boolean =  true;
    public function Menu()
    {
      _menu.x = 1000+_menu.width;
      _menu.y  = 0;
      _menu.flat.visible = false;
      _menu.flat.addChild(_rooms);
      _menu.floor_number.text = "Ogólny widok budynku";
      addChild(_menu);
      addButtons();
      addTextFlatsListeners();
      clearTextFields();
      super();
    }
    public function addButtons():void{
      addBackButton();
      _menu.addChild(_change);
      _change.addEventListeners(backPressed);
    }
    private function addBackButton():void{
      _back.x = -296;
      _back.y =  500;
      _back.gotoAndStop(1);
      _back.buttonMode =  true;
      _menu.addChild(_back)
      _back.visible = false;
      _back.addEventListener(MouseEvent.CLICK,onChangePressed);
      _back.addEventListener(MouseEvent.ROLL_OVER, onOver);
      _back.addEventListener(MouseEvent.ROLL_OUT, onOut);
    }
    private function onOver(e:MouseEvent):void{
      if(_buttonchange)
        e.target.gotoAndStop(2);
    }
    private function onOut(e:MouseEvent):void{
      if(_buttonchange)
        e.target.gotoAndStop(1);
    }
    public function showBack():void{
      _buttonchange = true;
      _back.gotoAndStop(1);
      _back.visible = true;
      TweenLite.to(_back,1,{alpha:1});
    }
    public function hideBack():void{
      updateMenuFloor();
      _back.visible =  false;
    }
    private function backPressed(e:MouseEvent):void{
      Estate.instance().onBackClick();
    }
    private function onChangePressed(e:MouseEvent):void{
      _buttonchange = false;
      e.target.gotoAndStop(3);
      clearTextFields();
      TweenLite.to(_back,1,{alpha:0,onComplete:hideBack});
      Estate.instance().getCurrentBlock().showAllCondignations();
    }
    public function showMenu():void{
      trace("menu start");
      hideBack();
      clearTextFields();
      TweenLite.to(_menu,1,{x:1000,delay:0, onComplete:changeView});
    }
    private function changeView():void{
      //      trace("menu stop");
      //      Estate.instance().addBlockView();
    }
    public function hideMenu():void{
      TweenLite.to(_menu,1,{x:1000+_menu.width});
      TweenLite.to(_back,1,{alpha:0,onComplete:hideBack});
    }
    public function updateMenuFloor(floor:String = " "):void{
      switch (floor){
        case " ":
          _menu.floor_number.text = "Ogólny widok budynku";
          break;
        case "0":
          _menu.floor_number.text =  "PARTER";
          break;
        case "1":
          _menu.floor_number.text =  "I PIĘTRO";
          break;
        case "2":
          _menu.floor_number.text =  "II PIĘTRO";
          break;
        case "3":
          _menu.floor_number.text =  "III PIĘTRO ";
          break;
        case "4":
          _menu.floor_number.text =  "IV PIĘTRO";
          break;
      }
      showAvaliableFlats(floor);
      showFlatsList();
    }
    private function showAvaliableFlats(floor:String =""):void{
      clearTextFields();
      Estate.instance().xmlData.getFlats(floor,addFlats);
    }
    private function addFlats(labelname:String, number:String, meters:String, rooms:String):void{
      
      try{
        (_menu.flats.getChildByName(labelname) as MovieClip).txt.text = "NR.  "+  number + ",  " + meters+"m2,  "+rooms;
      }
      catch(e:Error){
        trace("nie ma childa ",labelname);
      }
      
    }
    private function clearTextFields():void{
      _menu.flats.m1.txt.text = "";
      _menu.flats.m2.txt.text = "";
      _menu.flats.m3.txt.text = "";
      _menu.flats.m4.txt.text = "";
      _menu.flats.m5.txt.text = "";
      _menu.flats.m6.txt.text = "";
    }
    private function addTextFlatsListeners():void{
      _menu.flats.m1.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m2.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m3.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m4.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m5.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m6.addEventListener(MouseEvent.ROLL_OVER, onTextMouseOver);
      _menu.flats.m1.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
      _menu.flats.m2.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
      _menu.flats.m3.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
      _menu.flats.m4.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
      _menu.flats.m5.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
      _menu.flats.m6.addEventListener(MouseEvent.ROLL_OUT, onTextMouseOut);
    }
    private function onTextMouseOver(e:MouseEvent):void{
      trace(e.target.name);
      try{
        Estate.instance().getCurrentBlock().getFlast().showFlat(e.target.name);
      }
      catch (e:Error){
        
      }
    }
    private function onTextMouseOut(e:MouseEvent):void{
      Estate.instance().getCurrentBlock().getFlast().hideFlast();
    }
    public function updateMenuBuildingType( building_type:String = "A"):void{
      _menu.building_type.text = building_type;
      _menu.floor_number.text = " ";
    }
    public function showFlatDetails(labelname:String ="m1"):void{
      //     Estate.instance().xmlData.
      _menu.flats.visible = false;
      _menu.flat.visible = true;
      setFlatRooms(swapLabelName(labelname));
    }
    private function setFlatRooms(labelname:String):void{
      _pos = 30;
      while(_rooms.numChildren>0)
        _rooms.removeChildAt(0);
      Estate.instance().xmlData.getRooms(labelname,addRoom);
    }
    private function addRoom(name:String, meters:String):void{
      trace(name,meters);
      switch (name){
        case "label":{
          return;
        }
        case "rooms":{
          return;
        }
        case "number":{
          _menu.flat.flat.text = "MIESZKANIE "+meters;
          break;
        }
        case "all":{
          _menu.flat.all_m.text = meters;
          _menu.flat.all_txt.text = "metraż całkowity:";
          break;
        }
        default:{
          if(name!=" "){
            
            var room:flat_m =  new flat_m();
            room.room_txt.text = getRoomName(name);
            room.room_m.text = meters;
            _pos += 20;
            room.y = _pos;
            _rooms.addChild(room);
            trace("add room", room.y);
          }
          break;
        }
      }
    }
    private function getRoomName(name:String):String{
      trace(name);
      switch (name){
        case "hall":{
          return "korytarz:";
        }
        case "mainroom_witch_kitchen":{
          return "salon z kuchnią:";
        }
        case "sleeping":{
          return "sypialnia:";
        }
        case "sleeping2":{
          return "sypialnia 2:";
        }
        case "sleeping3":{
          return "sypialnia 3:";
        }
        case "bathroom":{
          return "łazienka:";
        }
        case "main_kitchen":{
          return "salon z kuchnią:";
        }
        case "":{
          return "";
        }
        default:{
          return "";
          
        }
      }
    }
    public function showFlatsList():void{
      _menu.flats.visible = true;
      _menu.flat.visible = false;
      showAvaliableFlats("1");//poprawić
      
    }
    private function swapLabelName(label:String):String{
      if(label=="m1")return "m6";
      else if(label=="m2")return "m5";
      else if(label=="m3")return "m4";
      else if(label=="m4")return "m3";
      else if(label=="m5")return "m2";
      else if(label=="m6")return "m1";
      else return "nie ma takiego";
    }
    
    
  }
}