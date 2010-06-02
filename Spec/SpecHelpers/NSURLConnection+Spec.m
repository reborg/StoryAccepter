#import "NSURLConnection+Spec.h"
#import "FakeHTTPURLResponse.h"
#import "NSURLConnectionDelegate.h"

@interface NSURLConnection (SpecPrivate)
+ (NSMutableArray *)connectionsInternal;
+ (NSMutableDictionary *)requestsByConnection;
+ (NSMutableDictionary *)delegatesByConnection;
@end

@implementation NSURLConnection (Spec)

+ (NSArray *)connections {
    return [self connectionsInternal];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    if (self = [super init]) {
        [[[self class] connectionsInternal] addObject:self];

        CFDictionaryAddValue((CFMutableDictionaryRef)[[self class] requestsByConnection], self, request);
        CFDictionaryAddValue((CFMutableDictionaryRef)[[self class] delegatesByConnection], self, delegate);
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Test HTTP connection for request %@>", [self request]];
}

- (NSURLRequest *)request {
    return [[[self class] requestsByConnection] objectForKey:self];
}

- (id<NSURLConnectionDelegate>)delegate {
    return [[[self class] delegatesByConnection] objectForKey:self];
}

- (void)returnResponse:(FakeHTTPURLResponse *)response {
    [[self delegate] connection:self didReceiveResponse:response];
}

#pragma mark private methods

static NSMutableArray *connections__;
static NSMutableDictionary *requests__, *delegates__;
+ (NSMutableArray *)connectionsInternal {
    if (!connections__) {
        connections__ = [[NSMutableArray alloc] init];
    }
    return connections__;
}

+ (NSMutableDictionary *)requestsByConnection {
    if (!requests__) {
        requests__ = [[NSMutableDictionary alloc] init];
    }
    return requests__;
}

+ (NSMutableDictionary *)delegatesByConnection {
    if (!delegates__) {
        delegates__ = [[NSMutableDictionary alloc] init];
    }
    return delegates__;
}

@end
