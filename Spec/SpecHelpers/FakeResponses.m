#import "FakeResponses.h"
#import "FakeHTTPURLResponse.h"

@interface FakeResponses (private)
- (NSString *)responseBodyForStatusCode:(int)statusCode;
- (FakeHTTPURLResponse *)responseForStatusCode:(int)statusCode;
@end

@implementation FakeResponses

+ (id)responsesForRequest:(NSString *)request {
    return [[[[self class] alloc] initForRequest:request] autorelease];
}

- (id)initForRequest:(NSString *)request {
    if (self = [super init]) {
        request_ = [request copy];
    }
    return self;
}

- (void)dealloc {
    [request_ release];
    [super dealloc];
}

- (FakeHTTPURLResponse *)success {
    return [self responseForStatusCode:200];
}

#pragma mark private interface

static const NSString *FAKE_RESPONSES_DIRECTORY = @"../../Spec/Fixtures/FakeResponses";
- (NSString *)responseBodyForStatusCode:(int)statusCode {
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:FAKE_RESPONSES_DIRECTORY, request_, [NSString stringWithFormat:@"%d.txt", statusCode], nil]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    }
    @throw [NSException exceptionWithName:@"FileNotFound" reason:[NSString stringWithFormat:@"No %d response found for request '%@'", statusCode, request_] userInfo:nil];
}

- (FakeHTTPURLResponse *)responseForStatusCode:(int)statusCode {
    return [[[FakeHTTPURLResponse alloc] initWithStatusCode:statusCode
                                                 andHeaders:[NSDictionary dictionary]
                                                    andBody:[self responseBodyForStatusCode:statusCode]]
            autorelease];
}

@end
