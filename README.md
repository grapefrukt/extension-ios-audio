OpenFL iOS Audio Extension
==========

Enables setting the iOS audio session as "ambient" to allow playback of external audio while playing a game. It also exposes a way to know if external music is playing or not.

Installation
============
You can easily install this extension using haxelib:

    haxelib git extension-ios-audio https://github.com/grapefrukt/extension-ios-audio

To add it to a Lime or OpenFL project, add this to your project file:

    <haxelib name="extension-ios-audio" if="ios" />

Installation
============

This extension was originally built by [Joon for Glitchnap](http://www.glitchnap.com/) and has had further work on it by [grapefrukt](http://grapefrukt.com)


Usage
=====

This extension provides four functions, use them as follows:

```haxe
#if ios
	// to fix the audio going silent on interruptions, call this function _once_ 
	// as your game starts
	extension.iosaudio.IOSAudio.fixInterrupt();

	// to enable audio ducking (ie. allowing other things to play audio
	// over your game) call this immediately on startup
	extension.iosaudio.IOSAudio.enableAmbient();

	// you can use the hasExternalMusicPlaying property to decide whether 
	// to play your own music or not
	if (extension.iosaudio.IOSAudio.hasExternalMusicPlaying) {
		// don't play
	} else {
		// do play
	}

	// should you ever want to put things back the way they were you can
	// disable ducking again
	extension.iosaudio.IOSAudio.disableAmbient();
#end
```
