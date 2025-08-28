package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import WeekData;
import openfl.utils.Assets as OpenFlAssets;
import VideoSprite;

using StringTools;

#if sys
import sys.FileSystem;
#end

class PlayVideoState extends MusicBeatState
{

 overide function create()
 {
        super.create();
        startVideo(videoID);
 }

 function goToMenu(){
        LoadingState.loadAndSwitchState(new AmongStoryMenuState(), true);
  FlxG.sound.playMusic(Paths.music('freakyMenu'));
 }

 override function update(elapsed:Float)
 {
  super.update(elapsed);
 }

 public var videoCutscene:VideoSprite = null;
 public function startVideo(name:String, forMidSong:Bool = false, canSkip:Bool = true, loop:Bool = false, playOnLoad:Bool = true)
 {
  #if VIDEOS_ALLOWED
  inCutscene = !forMidSong;
  canPause = forMidSong;

  var foundFile:Bool = false;
  var fileName:String = Paths.video(name);

  #if sys
  if (FileSystem.exists(fileName))
  #else
  if (OpenFlAssets.exists(fileName))
  #end
  foundFile = true;

  if (foundFile)
  {
   videoCutscene = new VideoSprite(fileName, forMidSong, canSkip, loop);
   if(forMidSong) videoCutscene.videoSprite.bitmap.rate = playbackRate;

   // Finish callback
   if (!forMidSong)
   {
    function onVideoEnd()
    {
     if (!isDead && generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
     {
      moveCameraSection();
      FlxG.camera.snapToTarget();
     }
     videoCutscene = null;
     canPause = true;
     inCutscene = false;
     startAndEnd();
    }
    videoCutscene.finishCallback = onVideoEnd;
    videoCutscene.onSkip = onVideoEnd;
   }
   if (GameOverSubstate.instance != null && isDead) GameOverSubstate.instance.add(videoCutscene);
   else add(videoCutscene);

   if (playOnLoad)
    videoCutscene.play();
   return videoCutscene;
  }
  #if LUA_ALLOWED
  else addTextToDebug("Video not found: " + fileName, FlxColor.RED);
  #else
  else FlxG.log.error("Video not found: " + fileName);
  #end
  #else
  FlxG.log.warn('Platform not supported!');
  startAndEnd();
  #end
  return null;
 } 

  function startAndEnd()
     {
     if(endingSong)
      endSong();
     else
      startCountdown();
      }
    }
