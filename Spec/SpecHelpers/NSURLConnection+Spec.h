#import <Foundation/Foundation.h>

@protocol NSURLConnectionDelegate;
@class FakeHTTPURLResponse;

@interface NSURLConnection (Spec)

+ (NSArray *)connections;

- (NSURLRequest *)request;
- (id<NSURLConnectionDelegate>)delegate;

- (void)returnResponse:(FakeHTTPURLResponse *)response;
- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential;

@end
