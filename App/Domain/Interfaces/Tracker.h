#import <Foundation/Foundation.h>

#define TRACKER_PROTOCOL "https://"
#define TRACKER_HOST "www.pivotaltracker.com/"
#define TRACKER_API_BASE_URI "services/v3/"

@protocol NSURLConnectionDelegate;

@interface Tracker : NSObject {
    NSMutableArray *activeConnections_;
    NSString *token_;
}

- (NSURLConnection *)logInWithDelegate:(id<NSURLConnectionDelegate>)delegate;
- (NSURLConnection *)getProjectsWithDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
