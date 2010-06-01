#import "Tracker.h"

static NSURL *BASE_URL;

@implementation Tracker

- (id)init {
    if (self = [super init]) {
        activeConnections_ = [[NSMutableArray alloc] init];
        @synchronized(BASE_URL) {
            if (!BASE_URL) {
                BASE_URL = [[NSURL alloc] initWithString:@""TRACKER_PROTOCOL TRACKER_HOST TRACKER_API_BASE_URI];
            }
        }
    }
    return self;
}

- (void)dealloc {
    [activeConnections_ release];
    [super dealloc];
}

- (void)logIn {
    NSURL *url = [[NSURL alloc] initWithString:@"tokens/active" relativeToURL:BASE_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [activeConnections_ addObject:connection];

    [connection release];
    [request release];
    [url release];
}

#pragma mark NSURLConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [NSException raise:@"NotImplemented" format:@"Not implemented"];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [NSException raise:@"NotImplemented" format:@"Not implemented"];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // TODO: handle auth challenge
}

@end
