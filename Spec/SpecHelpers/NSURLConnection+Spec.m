#import "NSURLConnection+Spec.h"

#pragma mark NSURLConnection
@interface NSURLConnection (SpecPrivate)
+ (NSMutableArray *)connectionsInternal;
@end

@implementation NSURLConnection (Spec)

+ (NSArray *)connections {
    return [self connectionsInternal];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [self initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    FakeURLConnection *fake = [[FakeURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:startImmediately];
    [[[self class] connectionsInternal] addObject:fake];
    return fake;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark private methods

static NSMutableArray *connections__;
+ (NSMutableArray *)connectionsInternal {
    @synchronized(connections__) {
        if (!connections__) {
            connections__ = [[NSMutableArray alloc] init];
        }
    }
    return connections__;
}

@end

#pragma mark FakeURLConnection
@implementation FakeURLConnection

@synthesize request = request_, delegate = delegate_;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately {
    if (self = [super init]) {
        self.request = request;
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.request = nil;
    [super dealloc];
}

@end
