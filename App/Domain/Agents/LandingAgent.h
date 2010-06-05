#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

@protocol LandingAgentDelegate;

@interface LandingAgent : NSObject <NSURLConnectionDelegate> {
    id<LandingAgentDelegate> delegate_;
}

- (id)initWithDelegate:(id<LandingAgentDelegate>)delegate;

- (void)logIn;

@end
