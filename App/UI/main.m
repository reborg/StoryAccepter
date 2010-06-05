#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    @try {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

        int retVal = UIApplicationMain(argc, argv, nil, @"StoryAccepterAppDelegate");
        [pool release];
        return retVal;
    } @catch (NSString *x) {
        NSLog(@"=====================> NSString exception: %@", x);
    } @catch (NSException *x) {
        NSLog(@"=====================> NSException: %@", x);
    }
}
