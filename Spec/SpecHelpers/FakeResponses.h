#import <Foundation/Foundation.h>

@class FakeHTTPURLResponse;

@interface FakeResponses : NSObject {
    NSString * request_;
}

+ (id)responsesForRequest:(NSString *)request;
- (id)initForRequest:(NSString *)request;

- (FakeHTTPURLResponse *)success;
- (FakeHTTPURLResponse *)badRequest;

@end
