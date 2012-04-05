package other
{
  import com.greensock.loading.XMLLoader;
  
  import estate.Estate;
  
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  public class XMLLoader
  {
    private var _urlRequest:URLRequest =  new URLRequest("assets/osiedle.xml");
    private var _loader:URLLoader =  new URLLoader();
    private var _xmlData:XML;
    
    
    public function XMLLoader()
    {
      init();
    }
    public function init():void{
      _loader.load(_urlRequest);
      _loader.addEventListener(Event.COMPLETE, onLoaderComplete);
    }
    
    public function get xmlData():XML
    {
      return _xmlData;
    }
    
    private function onLoaderComplete(e:Event):void{
      _xmlData =   new XML(_loader.data);
    }
    
    
    public function getNumeration(labelname:String):Object{
      for(var i:int = 0; i< 9;i++){
        //        trace("buildings",i,_xmlData.building[i].attribute("name"),Estate.instance().current_name);
        if(_xmlData.building[i].attribute("name") == Estate.instance().current_name){
          for(var j:int = 0; j< 4;j++){
            //            trace("floors",j,_xmlData.building[i].floor[j].attribute("number"),Estate.instance().getCurrentBlock().currentFloor);
            if(_xmlData.building[i].floor[j].attribute("number")==Estate.instance().getCurrentBlock().currentFloor){
              for(var k:int = 0; k<6;k++){
                //                trace("flats",_xmlData.building[i].floor[j].flat[k].attribute("labelname"),labelname);
                if(_xmlData.building[i].floor[j].flat[k].attribute("labelname")==labelname){
                  return {number:_xmlData.building[i].floor[j].flat[k].attribute("number"),meters:_xmlData.building[i].floor[j].flat[k].attribute("square_footage")};
                }//else{return "flat";}
              }
            }//else{ return "floor";}
          }
        }//else{return "building";}
      }
      return {number:"?",meters:"?"};
    }
    public function getRooms(labelname:String,callBack:Function):Object{
      for(var i:int = 0; i< 9;i++){
        //        trace("buildings",i,_xmlData.building[i].attribute("name"),Estate.instance().current_name);
        if(_xmlData.building[i].attribute("name") == Estate.instance().current_name){
          for(var j:int = 0; j< 4;j++){
            if(_xmlData.building[i].floor[j]!=null){
              //              trace("floors",j,_xmlData.building[i].floor[j].attribute("number"),Estate.instance().getCurrentBlock().currentFloor);
              if(_xmlData.building[i].floor[j].attribute("number")==Estate.instance().getCurrentBlock().currentFloor){
                for(var k:int = 0; k<6;k++){
                  if(_xmlData.building[i].floor[j].flat[k]!=null){
                    //                    trace("flats",_xmlData.building[i].floor[j].flat[k].attribute("label"),labelname);
                    if(_xmlData.building[i].floor[j].flat[k].attribute("label")==labelname){
                      for each(var attribute:XML in _xmlData.building[i].floor[j].flat[k].attributes()){
                        callBack(attribute.name(),attribute);
                      }
                      return _xmlData.building[i].floor[j].flat[k].toString();
                    }else{callBack(" "," ");}
                  }
                }
              }
            }
          }
        }
      }
      return new XML();
    }
    public function getFlats(floor:String,callBack:Function):void{
      var labelname:String;
      var number:String;
      var meters:String;
      var rooms:String;
      for(var i:int = 0; i< 9;i++){
        trace("buildings",i,_xmlData.building[i].attribute("name"),Estate.instance().current_name);
        if(_xmlData.building[i].attribute("name") == Estate.instance().current_name){
          for(var j:int = 0; j< 4;j++){
            if(_xmlData.building[i].floor[j]!=null){
              trace("floors",j,_xmlData.building[i].floor[j].attribute("number"),Estate.instance().getCurrentBlock().currentFloor);
              if(_xmlData.building[i].floor[j].attribute("number")==Estate.instance().getCurrentBlock().currentFloor){
                for(var k:int = 0; k<6;k++){
                  if(_xmlData.building[i].floor[j].flat[k]!=null){
                    labelname = _xmlData.building[i].floor[j].flat[k].attribute("label");
                    number = _xmlData.building[i].floor[j].flat[k].attribute("number");
                    meters = _xmlData.building[i].floor[j].flat[k].attribute("all")
                    rooms = xmlData.building[i].floor[j].flat[k].attribute("rooms")
                    callBack(swapLabelName(labelname), number, meters,rooms);
                    trace("KOLEJNOSC: ",labelname);
                  }
                  else{
                    callBack("","","","");
                  }
                }
              }
            }
          }
        }
      }
    }
    private function swapLabelName(label:String):String{
//      return label
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
