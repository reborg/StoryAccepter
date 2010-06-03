#import "Tracker+Spec.h"

@implementation Tracker (Spec)

- (void)setToken:(NSString *)token {
    NSString *temp = [token copy];
    [token_ release];
    token_ = temp;
}

@end
