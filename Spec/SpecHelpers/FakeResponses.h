#import <Foundation/Foundation.h>

@class FakeHTTPURLResponse;

@interface FakeResponses : NSObject {
    FakeHTTPURLResponse *success_;
}

@property (nonatomic, readonly) FakeHTTPURLResponse *success;

+ (id)responsesForRequest:(NSString *)request;
- (id)initForRequest:(NSString *)request;

@end
