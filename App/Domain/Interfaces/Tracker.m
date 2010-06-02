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
    [NSException raise:@"NotImplemented" format:@"Not implemented"];
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

static NSURL *BASE_URL;

@implementation Tracker

- (id)init {
    if (self = [super init]) {
        activeConnections_ = [[NSMutableArray alloc] init];
        if (!BASE_URL) {
            BASE_URL = [[NSURL alloc] initWithString:@TRACKER_PROTOCOL TRACKER_HOST TRACKER_API_BASE_URI];
        }
    }
    return self;
}

- (void)dealloc {
    [activeConnections_ release];
    [super dealloc];
}

- (NSURLConnection *)logInWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    NSURL *url = [[NSURL alloc] initWithString:@"tokens/active" relativeToURL:BASE_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[TrackerConnection alloc] initWithRequest:request delegate:delegate];
    [activeConnections_ addObject:connection];

    [connection release];
    [request release];
    [url release];

    return connection;
}

@end
