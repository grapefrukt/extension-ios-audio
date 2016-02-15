package extension.iosaudio;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end


class IOSAudio {

	/**
	 * Allows you to check if external music (or any audio) is playing
	 */
	public static var hasExternalMusicPlaying(get, never):Bool;

	/**
	 * Call once at startup to add the fix for interrupted sound. Can be used independent of ambient settings.
	 * Do _not_ call multiple times. 
	 */
	public static function fixInterrupt():Void {
		iosaudio_fixinterrupt();
	}

	/**
	* Sets your audio session as ambient which allows mixing with other audio sources
	*/
	public static function enableAmbient():Void {
		iosaudio_enableambient();
	}

	/**
	* Returns your audio session to the default state, not allowing any other audio to be played
	*/
	public static function disableAmbient():Void {
		iosaudio_disableambient ();
	}
	
	static function get_hasExternalMusicPlaying():Bool {
		return iosaudio_hasexternalmusicplaying();
	}

	private static var iosaudio_fixinterrupt = Lib.load("iosaudio", "iosaudio_fixinterrupt", 0);
	private static var iosaudio_enableambient = Lib.load("iosaudio", "iosaudio_enableambient", 0);
	private static var iosaudio_disableambient = Lib.load("iosaudio", "iosaudio_disableambient", 0);
	private static var iosaudio_hasexternalmusicplaying = Lib.load("iosaudio", "iosaudio_hasexternalmusicplaying", 0);

}