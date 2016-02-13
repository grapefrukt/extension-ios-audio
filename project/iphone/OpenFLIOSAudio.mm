#include <OpenFLIOSAudio.h>
#define __STDC_FORMAT_MACROS // non needed in C, only in C++
#import <Foundation/Foundation.h>
#include <inttypes.h>
#import <AVFoundation/AVFoundation.h>


typedef void (*FunctionType)();

namespace openfliosaudio {

	void enableduck() {
		AVAudioSession *session = [AVAudioSession sharedInstance];

		NSError *setCategoryError = nil;
		if (![session setCategory:AVAudioSessionCategoryAmbient
				 withOptions:AVAudioSessionCategoryOptionMixWithOthers
				 error:&setCategoryError]) {
			// handle error
			NSLog(@"ERROR SETTING AVAUDIOSESSION");
		}
		NSLog(@"SETTING AVAUDIOSESSION TO DUCK (play others)");
	}

	void disableduck() {
		AVAudioSession *session = [AVAudioSession sharedInstance];

		NSError *setCategoryError = nil;
		if (![session setCategory:AVAudioSessionCategorySoloAmbient
				 withOptions:AVAudioSessionCategoryOptionDuckOthers
				 error:&setCategoryError]) {
			// handle error
			NSLog(@"ERROR SETTING AVAUDIOSESSION");
		}
		NSLog(@"SETTING AVAUDIOSESSION TO NOT DUCK (duck others)");
	}
	
	bool hasexternalmusicplaying() {
		BOOL isOtherAudioPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying];
		return isOtherAudioPlaying;
	}	
}