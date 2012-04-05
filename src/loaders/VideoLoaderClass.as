package loaders
{
  import com.greensock.events.LoaderEvent;
  import com.greensock.loading.ImageLoader;
  import com.greensock.loading.LoaderMax;
  import com.greensock.loading.VideoLoader;
  import com.greensock.loading.display.ContentDisplay;
  
  import estate.Estate;
  
  import flash.display.Loader;
  import flash.display.MovieClip;
  import flash.display.Shape;
  
  import other.Constans;
  
  public class VideoLoaderClass extends MovieClip
  {
    protected var _videoLoader:LoaderMax = new LoaderMax({name:"videoLoader",onProgress:progressHandler,onComplete:completeHandler, onError:errorHandler});
    protected var _video:VideoLoader = new VideoLoader("assets/video/video.flv",{name:"startVideo",autoplay:false,container:this, width:1000,heigh:600});
    public function VideoLoaderClass()
    {
      super();
//      addChild(Estate.instance());//USUNAĆ
//      Estate.instance().init();
      
      _videoLoader.append(_video);
      _videoLoader.load();//ODKOMENTOWAĆ
      _video.addEventListener(VideoLoader.PLAY_PROGRESS,onPlayProgress,false,0,true);
     _video.addEventListener(VideoLoader.VIDEO_COMPLETE, onVideoComplete,false,0,true);
    }
    private function progressHandler(e:LoaderEvent):void{

    }
    private function completeHandler(e:LoaderEvent):void{
     _video.playVideo(null);
      trace("VIDEO COMPLETED DOWNLOAD!");
    }
    private function onPlayProgress(e:LoaderEvent):void{
    }
    private function errorHandler(e:LoaderEvent):void{
      trace("error occured" + e.text);
    }
    private function onVideoComplete(e:LoaderEvent):void{
      trace("VIDEO COMPLETED PLAING");
      addChild(Estate.instance());//USUNAĆ
      Estate.instance().init();
    }

  }
}
