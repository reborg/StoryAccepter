#import "SpecHelper.h"
#import "LogInViewController.h"

SPEC_BEGIN(LogInViewControllerSpec)

describe(@"LogInViewController", ^{
    __block LogInViewController *controller;

    beforeEach(^{
        controller = [[LogInViewController alloc] init];
        [controller loadView];
    });

    afterEach(^{
        [controller release];
    });

    describe(@"viewDidLoad", ^{
        beforeEach(^{
            [controller viewDidLoad];
        });

        it(@"should initialize the text field views from the XIB", ^{
            // TODO !!! matchers
            if (!controller.usernameTextField) {
                fail(@"Username text field not initialized.");
            }

            if (!controller.passwordTextField) {
                fail(@"Password text field not initialized.");
            }
        });
    });

    describe(@"viewDidUnload", ^{
        beforeEach(^{
            [controller viewDidLoad];
            [controller viewDidUnload];
        });

        it(@"should set the text field views to nil", ^{
            if (controller.usernameTextField) {
                fail(@"Username text field not released by viewDidUnload");
            }

            if (controller.passwordTextField) {
                fail(@"Password text field not released by viewDidUnload");
            }
        });
    });
});

SPEC_END
