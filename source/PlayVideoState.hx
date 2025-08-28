package;

import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.utils.Assets as OpenFlAssets;
import VideoSprite;
#if sys
import sys.FileSystem;
#end

class PlayVideoState extends MusicBeatState
{
    public var videoID:String = "credits3";
    public var videoCutscene:VideoSprite = null;

    override function create()
    {
        super.create();
        startVideo(videoID);
    }

    function goToMenu()
    {
        LoadingState.loadAndSwitchState(new AmongStoryMenuState(), true);
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function startVideo(name:String, forMidSong:Bool = false, canSkip:Bool = true, loop:Bool = false, playOnLoad:Bool = true)
    {
        #if VIDEOS_ALLOWED
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

            function onVideoEnd()
            {
                videoCutscene = null;
                startAndEnd();
            }
            videoCutscene.finishCallback = onVideoEnd;
            videoCutscene.onSkip = onVideoEnd;

            add(videoCutscene);
            if (playOnLoad) videoCutscene.play();
            return videoCutscene;
        }
        else
        {
            FlxG.log.error("Video not found: " + fileName);
        }
        #else
        FlxG.log.warn('Platform not supported!');
        startAndEnd();
        #end
        return null;

    function startAndEnd()
    {
        if (endingSong)
            endSong();
        else
            startCountdown();
    }
}
