#include <OpenFLIOSAudio.h>
#define __STDC_FORMAT_MACROS // non needed in C, only in C++
#import <Foundation/Foundation.h>
#include <inttypes.h>
#import <AVFoundation/AVFoundation.h>

#include <OpenAL/al.h>
#include <OpenAL/alc.h>

typedef void (*FunctionType)();

static ALCcontext *alcContext = nil;

@interface GlitchIOSWrapper : NSObject {
}
- (void)onAudioSessionEvent: (NSNotification *) notification;
@end

@implementation GlitchIOSWrapper

- (void) onAudioSessionEvent: (NSNotification *) notification
{
	//Check the type of notification, especially if you are sending multiple AVAudioSession events here
	if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
		NSLog(@"Interruption notification received!");

		//Check to see if it was a Begin interruption
		if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
			NSLog(@"Interruption began!");

			alcContext = alcGetCurrentContext();
			// Deactivate the current audio session
			AudioSessionSetActive(NO);
			// set the current context to NULL will 'shutdown' openAL
			alcMakeContextCurrent(NULL);
			// now suspend your context to 'pause' your sound world
			alcSuspendContext(alcContext);

		} else {
			NSLog(@"Interruption ended!");
			AVAudioSession *session = [AVAudioSession sharedInstance];
			[session setActive: YES error: nil];


			// Reset audio session
			//UInt32 category = kAudioSessionCategory_AmbientSound;
			//AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof (category), &category );
				
			// Reactivate the current audio session
			AudioSessionSetActive(YES);
				
			// Restore open al context
			alcMakeContextCurrent(alcContext);
			// 'unpause' my context
			alcProcessContext(alcContext);
		}
	}
}

@end

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

		[[NSNotificationCenter defaultCenter] addObserver: [[GlitchIOSWrapper alloc] init]
			selector: @selector(onAudioSessionEvent:)
			name: AVAudioSessionInterruptionNotification
			object: session];
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