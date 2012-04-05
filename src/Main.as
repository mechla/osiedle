package
{
  import flash.display.Sprite;
  
  import loaders.VideoLoaderClass;
  
  import other.Constans;
  [SWF(width=1000,height=600)]
  public class Main extends Sprite
  {
    
    private var _video:VideoLoaderClass; 
    public function Main()
    {
      Constans.STAGE_HEIGHT = 600;
      Constans.STAGE_WIDTH = 1000;
      _video = new VideoLoaderClass();
      addChild(_video);
    }
  }
}