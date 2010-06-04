#import "LandingAgent.h"
#import "LandingAgentDelegate.h"
#import "StoryAccepterEnvironment.h"
#import "Tracker.h"

@implementation LandingAgent

- (id)initWithDelegate:(id<LandingAgentDelegate>)delegate {
    if (self = [super init]) {
        delegate_ = delegate;
    }
    return self;
}

- (void)load {
    [[[StoryAccepterEnvironment environment] trackerInterface] logInWithDelegate:self];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSException exceptionWithName:@"NotImplemented" reason:@"implement me" userInfo:nil] raise];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[NSException exceptionWithName:@"NotImplemented" reason:@"implement me" userInfo:nil] raise];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [delegate_ newLogInCredential:[challenge proposedCredential]];
}

@end
