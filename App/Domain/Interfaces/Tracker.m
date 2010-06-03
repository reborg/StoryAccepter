#import "Tracker.h"
#import "NSURLConnectionDelegate.h"

@interface TrackerConnection : NSURLConnection <NSURLConnectionDelegate> {
    id<NSURLConnectionDelegate> delegate_;
}
@end

@implementation TrackerConnection

- (id)initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithRequest:request delegate:self]) {
        delegate_ = delegate;
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [delegate_ connectionDidFinishLoading:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [NSException raise:@"NotImplemented" format:@"Not implemented"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [delegate_ connection:connection didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [delegate_ connection:connection didReceiveAuthenticationChallenge:challenge];
}

@end

@interface Tracker (private)
- (NSURLConnection *) connectionForPath:(NSString *)path andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure;
- (NSURL *)newBaseURLWithSSL:(BOOL)secure;
@end

@implementation Tracker

- (id)init {
    if (self = [super init]) {
        activeConnections_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [activeConnections_ release];
    [super dealloc];
}

- (NSURLConnection *)logInWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:@"tokens/active" andDelegate:delegate secure:true];
}

- (NSURLConnection *)getProjectsWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionForPath:@"projects" andDelegate:delegate secure:false];
}

#pragma mark private interface

- (NSURLConnection *)connectionForPath:(NSString *)path andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure {
    NSURL *baseUrl = [self newBaseURLWithSSL:secure];
    NSURL *url = [[NSURL alloc] initWithString:path relativeToURL:baseUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[TrackerConnection alloc] initWithRequest:request delegate:delegate];
    [activeConnections_ addObject:connection];

    [connection release];
    [request release];
    [url release];
    [baseUrl release];

    return connection;
}

- (NSURL *)newBaseURLWithSSL:(BOOL)secure {
    if (secure) {
        return [[NSURL alloc] initWithString:@"https://" TRACKER_HOST TRACKER_API_BASE_URI];
    } else {
        return [[NSURL alloc] initWithString:@"http://" TRACKER_HOST TRACKER_API_BASE_URI];
    }
}

@end
