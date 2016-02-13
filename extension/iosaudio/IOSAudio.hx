package extension.iosaudio;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end


class IOSAudio {

	public static var hasExternalMusicPlaying(get, never):Bool;
	
	public static function enableDuck():Void {
		iosaudio_enableduck();
	}

	public static function disableDuck():Void {
		iosaudio_disableduck ();
	}
	
	static function get_hasExternalMusicPlaying():Bool {
		return iosaudio_hasexternalmusicplaying();
	}

	private static var iosaudio_enableduck = Lib.load("iosaudio", "iosaudio_enableduck", 0);
	private static var iosaudio_disableduck = Lib.load("iosaudio", "iosaudio_disableduck", 0);
	private static var iosaudio_hasexternalmusicplaying = Lib.load("iosaudio", "iosaudio_hasexternalmusicplaying", 0);

}