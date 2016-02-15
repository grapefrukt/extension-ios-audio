#include <OpenFLIOSAudio.h>
#define __STDC_FORMAT_MACROS // non needed in C, only in C++
#import <Foundation/Foundation.h>
#include <inttypes.h>
#import <AVFoundation/AVFoundation.h>

#include <OpenAL/al.h>
#include <OpenAL/alc.h>

typedef void (*FunctionType)();

static ALCcontext *alcContext = nil;
static BOOL isAmbient = false;

@interface InterruptObserver : NSObject {
}
- (void) onAudioSessionEvent: (NSNotification *) notification;
@end

@implementation InterruptObserver

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

			// The ambient property gets lots when the session is deactivated, so that needs to be set again
			if (isAmbient) {
				UInt32 category = kAudioSessionCategory_AmbientSound;
				AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof (category), &category );
			}
				
			// Reactivate the current audio session
			AudioSessionSetActive(YES);
				
			// Restore OpenAL context
			alcMakeContextCurrent(alcContext);

			// finally, 'unpause' the context
			alcProcessContext(alcContext);
		}
	}
}

@end

namespace openfliosaudio {

	void fixinterrupt() {
		// get the shared audio session
		AVAudioSession *session = [AVAudioSession sharedInstance];

		[[NSNotificationCenter defaultCenter] addObserver: [[InterruptObserver alloc] init]
			selector: @selector(onAudioSessionEvent:)
			name: AVAudioSessionInterruptionNotification
			object: session];
	}

	void enableambient() {
		isAmbient = true;

		// get the shared audio session
		AVAudioSession *session = [AVAudioSession sharedInstance];

		NSError *setCategoryError = nil;

		// set it as ambient
		if (![session setCategory:AVAudioSessionCategoryAmbient
				 withOptions:AVAudioSessionCategoryOptionMixWithOthers
				 error:&setCategoryError]) {
			// it'd be nice to handle the error here, but i don't know what to do with it
			//NSLog(@"ERROR SETTING AVAUDIOSESSION");
		}
		//NSLog(@"SETTING AVAUDIOSESSION TO DUCK (play others)");
	}

	void disableambient() {
		// same thing as enable, but different category

		isAmbient = false;

		AVAudioSession *session = [AVAudioSession sharedInstance];

		NSError *setCategoryError = nil;
		if (![session setCategory:AVAudioSessionCategorySoloAmbient
				 withOptions:AVAudioSessionCategoryOptionDuckOthers
				 error:&setCategoryError]) {
			// handle error
			//NSLog(@"ERROR SETTING AVAUDIOSESSION");
		}
		//NSLog(@"SETTING AVAUDIOSESSION TO NOT DUCK (duck others)");
	}
	
	bool hasexternalmusicplaying() {
		BOOL isOtherAudioPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying];
		return isOtherAudioPlaying;
	}	
}