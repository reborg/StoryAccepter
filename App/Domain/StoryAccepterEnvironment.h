#import <Foundation/Foundation.h>

@class Tracker;

@interface StoryAccepterEnvironment : NSObject {
    Tracker *trackerInterface_;
}

+ (StoryAccepterEnvironment *)environment;

@property (nonatomic, readonly) const Tracker * const trackerInterface;

@end
