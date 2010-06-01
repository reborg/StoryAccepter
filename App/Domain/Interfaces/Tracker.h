#import <Foundation/Foundation.h>
#import "NSURLConnectionDelegate.h"

#define TRACKER_PROTOCOL "https://"
#define TRACKER_HOST "www.pivotaltracker.com/"
#define TRACKER_API_BASE_URI "services/v3/"

@interface Tracker : NSObject <NSURLConnectionDelegate> {
    NSMutableArray *activeConnections_;
}

- (void)logIn;

@end
