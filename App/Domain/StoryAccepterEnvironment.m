#import "StoryAccepterEnvironment.h"
#import "Tracker.h"

@implementation StoryAccepterEnvironment

static StoryAccepterEnvironment *environment__ = nil;
+ (StoryAccepterEnvironment *)environment {
    if (!environment__) {
        environment__ = [[StoryAccepterEnvironment alloc] init];
    }
    return environment__;
}

- (void)dealloc {
    [trackerInterface_ release];
    [super dealloc];
}

- (Tracker *)trackerInterface {
    if (!trackerInterface_) {
        trackerInterface_ = [[Tracker alloc] init];
    }
    return trackerInterface_;
}

@end
