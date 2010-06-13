#import <Foundation/Foundation.h>

@protocol NSURLConnectionDelegate;

@interface Tracker : NSObject {
    NSMutableArray *activeConnections_;
    NSString *token_;
}

@property (nonatomic, readonly) NSArray *activeConnections;
@property (nonatomic, copy) NSString *token;

- (NSURLConnection *)logInWithDelegate:(id<NSURLConnectionDelegate>)delegate;
- (NSURLConnection *)getProjectsWithDelegate:(id<NSURLConnectionDelegate>)delegate;

@end
