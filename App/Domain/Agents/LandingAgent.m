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

- (void)logIn {
    [[[StoryAccepterEnvironment environment] trackerInterface] logInWithDelegate:self];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSException exceptionWithName:@"NotImplemented" reason:@"error" userInfo:nil] raise];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSURLCredential *newCredential = [delegate_ newLogInCredential:[challenge proposedCredential]];
    if (newCredential) {
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    [newCredential release];
}

@end
