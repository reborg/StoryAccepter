#import "Tracker.h"
#import "NSURLConnectionDelegate.h"
#import "NSXMLParserDelegate.h"

#define TRACKER_PROTOCOL "https://"
#define TRACKER_HOST "www.pivotaltracker.com/"
#define TRACKER_API_BASE_URI "services/v3/"
static NSURL *BASE_URL = nil;

@interface TrackerConnection : NSURLConnection <NSURLConnectionDelegate> {
    Tracker *tracker_;
    id<NSURLConnectionDelegate> delegate_;
}

- (id)initWithTracker:(Tracker *)tracker forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate;

@end

@interface Tracker (TrackerConnectionFriend)
- (void)clearConnection:(NSURLConnection *)connection;
@end

@implementation TrackerConnection

- (id)initWithTracker:(Tracker *)tracker forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithRequest:request delegate:self]) {
        tracker_ = tracker;
        delegate_ = delegate;
    }
    return self;
}

- (void)cancel {
    [super cancel];
    [tracker_ clearConnection:self];
}

#pragma mark NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [delegate_ connectionDidFinishLoading:connection];
    [tracker_ clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate_ connection:connection didFailWithError:error];
    [tracker_ clearConnection:connection];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([delegate_ respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [delegate_ connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [delegate_ connection:connection didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [delegate_ connection:connection didCancelAuthenticationChallenge:challenge];
    [tracker_ clearConnection:connection];
}

@end

@interface TrackerLogInConnection : TrackerConnection <NSXMLParserDelegate> {
    NSMutableData *data_;
    NSMutableString *token_;
    BOOL inTokenElement_, inGuidElement_;
}
@end

@implementation TrackerLogInConnection

- (id)initWithTracker:(Tracker *)tracker forRequest:(NSURLRequest *)request andDelegate:(id<NSURLConnectionDelegate>)delegate {
    if (self = [super initWithTracker:tracker forRequest:request andDelegate:delegate]) {
        data_ = [[NSMutableData alloc] init];
        token_ = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [token_ release];
    [data_ release];
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [super connection:connection didReceiveResponse:response];
    [data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data_];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([@"token" isEqual:elementName]) {
        inTokenElement_ = true;
    } else if (inTokenElement_ && [@"guid" isEqual:elementName]) {
        inGuidElement_ = true;
        [token_ setString:@""];
    } else {
        inTokenElement_ = inGuidElement_ = false;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (inGuidElement_) {
        [token_ appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (inGuidElement_ && [@"guid" isEqual:elementName]) {
        [tracker_ setToken:token_];
    }
}

@end

@interface Tracker (private)
- (NSURLConnection *)connectionOfClass:(Class)class forPath:(NSString *)path andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure;
@end

@implementation Tracker

@synthesize activeConnections = activeConnections_, token = token_;

+ (void)initialize {
    BASE_URL = [[NSURL alloc] initWithString:@TRACKER_PROTOCOL TRACKER_HOST TRACKER_API_BASE_URI];
}

- (id)init {
    if (self = [super init]) {
        activeConnections_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [token_ release];
    [activeConnections_ release];
    [super dealloc];
}

- (NSURLConnection *)logInWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionOfClass:[TrackerLogInConnection class] forPath:@"tokens/active" andDelegate:delegate secure:true];
}

- (NSURLConnection *)getProjectsWithDelegate:(id<NSURLConnectionDelegate>)delegate {
    return [self connectionOfClass:[TrackerConnection class] forPath:@"projects" andDelegate:delegate secure:false];
}

#pragma mark friend interface for TrackerConnection

- (void)clearConnection:(NSURLConnection *)connection {
    [activeConnections_ removeObject:connection];
}

#pragma mark private interface

- (NSURLConnection *)connectionOfClass:(Class)class forPath:(NSString *)path andDelegate:(id<NSURLConnectionDelegate>)delegate secure:(BOOL)secure {
    NSURL *url = [[NSURL alloc] initWithString:path relativeToURL:BASE_URL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:token_ forHTTPHeaderField:@"X-TrackerToken"];

    NSURLConnection *connection = [[class alloc] initWithTracker:self forRequest:request andDelegate:delegate];
    [activeConnections_ addObject:connection];

    [connection release];
    [request release];
    [url release];

    return connection;
}

@end
