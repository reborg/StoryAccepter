#import <Foundation/Foundation.h>

@protocol LandingAgentDelegate

- (NSURLCredential *)newLogInCredential:(NSURLCredential *)failedCredential;

@end
