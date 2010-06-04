#import "SpecHelper.h"
#import "LandingViewController.h"

SPEC_BEGIN(LandingViewControllerSpec)

describe(@"LandingViewController", ^{
    __block LandingViewController *controller;

    beforeEach(^{
        controller = [[LandingViewController alloc] init];
        [controller loadView];
    });

    afterEach(^{
        [controller release];
    });

    describe(@"viewDidLoad", ^{
        beforeEach(^{
            [controller viewDidLoad];
        });

        it(@"should initialize the logo image view from the XIB", ^{
            // TODO !!! matchers
            if (!controller.logoImageView) {
                fail(@"Logo image not initialized.");
            }
        });
    });

    describe(@"viewDidUnload", ^{
        beforeEach(^{
            [controller viewDidLoad];
            [controller viewDidUnload];
        });

        it(@"should set the logo image view to nil", ^{
            if (controller.logoImageView) {
                fail(@"Logo image not released by viewDidUnload");
            }
        });
    });
});

SPEC_END