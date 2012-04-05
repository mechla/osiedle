package loaders
{
  import flash.external.ExternalInterface;

  public class PhotosData extends Object
  {
    private var _url:String;
    private var _bytes:Number;
    public function PhotosData(object:Object)
    {
      super();
      _url = object.url;
      _bytes = object.bytes;
    }

    public function get url():String
    {
      return _url;
    }

    public function set url(value:String):void
    {
      _url = value;
    }

    public function get bytes():Number
    {
      return _bytes;
    }

    public function set bytes(value:Number):void
    {
      _bytes = value;
    }


  }
}