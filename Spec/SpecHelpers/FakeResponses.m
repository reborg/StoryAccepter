#import "FakeResponses.h"
#import "FakeHTTPURLResponse.h"

@interface FakeResponses (private)
- (NSString *)responseBodyForRequest:(NSString *)request andStatusCode:(int)statusCode;
@end

@implementation FakeResponses

@synthesize success = success_;

+ (id)responsesForRequest:(NSString *)request {
    return [[[[self class] alloc] initForRequest:request] autorelease];
}

- (id)initForRequest:(NSString *)request {
    if (self = [super init]) {
        NSString *responseBody = [self responseBodyForRequest:request andStatusCode:200];
        success_ = [[FakeHTTPURLResponse alloc] initWithStatusCode:200 andHeaders:[NSDictionary dictionary] andBody:responseBody];
    }
    return self;
}

- (void)dealloc {
    [success_ release];
    [super dealloc];
}

#pragma mark private interface

static const NSString *FAKE_RESPONSES_DIRECTORY = @"../../Spec/Fixtures/FakeResponses";
- (NSString *)responseBodyForRequest:(NSString *)request andStatusCode:(int)statusCode {
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:FAKE_RESPONSES_DIRECTORY, request, [NSString stringWithFormat:@"%d.txt", statusCode], nil]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    }
    @throw [NSException exceptionWithName:@"FileNotFound" reason:[NSString stringWithFormat:@"No file found for request '%@'", request] userInfo:nil];
}

@end
