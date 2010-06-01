#import <Foundation/Foundation.h>

@protocol NSURLConnectionDelegate;

#pragma mark NSURLConnection+Spec
@interface NSURLConnection (Spec)
+ (NSArray *)connections;
@end

#pragma mark FakeURLConnection
@interface FakeURLConnection : NSURLConnection {
    NSURLRequest *request_;
    id<NSURLConnectionDelegate> delegate_;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, assign) id<NSURLConnectionDelegate> delegate;

@end
