#import <UIKit/UIKit.h>
#import "Cedar.h"
#import "CedarApplicationDelegate.h"

int main(int argc, char *argv[]) {
    // Builds that target the iPhone have to use Cedar as a static library.  Cedar includes an
    // application delegate specific to tests, but since this code only instantiates it via
    // interpolation and never by directly referencing the symbol the linker throws out the
    // reference to the class.  So, this next line is to force the linker to keep the symbol
    // around.
    [[[CedarApplicationDelegate alloc] init] release];

    @try {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

        int retVal = UIApplicationMain(argc, argv, nil, @"CedarApplicationDelegate");
        [pool release];
        return retVal;
    } @catch (NSString *x) {
        NSLog(@"=====================> NSString exception: %@", x);
    } @catch (NSException *x) {
        NSLog(@"=====================> NSException: %@", x);
    }
}
