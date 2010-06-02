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

- (void)cancel {
    [[[self class] connectionsInternal] removeObject:self];
    [[[self class] requestsByConnection] removeObjectForKey:self];
    [[[self class] delegatesByConnection] removeObjectForKey:self];
}

- (NSURLRequest *)request {
    return [[[self class] requestsByConnection] objectForKey:self];
}

- (id<NSURLConnectionDelegate>)delegate {
    return [[[self class] delegatesByConnection] objectForKey:self];
}

- (void)returnResponse:(FakeHTTPURLResponse *)response {
    id delegate = [self delegate];

    if ([delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [[self delegate] connection:self didReceiveResponse:response];
    }

    if ([delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [[self delegate] connection:self didReceiveData:[[response body] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if ([delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [[self delegate] connectionDidFinishLoading:self];
    }
}

- (void)sendAuthenticationChallengeWithCredential:(NSURLCredential *)credential {
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"www.example.com" port:0 protocol:@"http" realm:nil authenticationMethod:nil];
    NSURLAuthenticationChallenge *challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace proposedCredential:credential previousFailureCount:1 failureResponse:nil error:nil sender:nil];
    [protectionSpace release];

    id delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(connection:didReceiveAuthenticationChallenge:)]) {
        [[self delegate] connection:self didReceiveAuthenticationChallenge:challenge];
    }
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
