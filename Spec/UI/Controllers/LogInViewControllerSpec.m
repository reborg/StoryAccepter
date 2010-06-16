#import <Cedar-iPhone/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest-iPhone/OCHamcrest.h>
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
            assertThat(controller.usernameTextField, notNilValue());
            assertThat(controller.passwordTextField, notNilValue());
        });
    });

    describe(@"viewDidUnload", ^{
        beforeEach(^{
            [controller viewDidLoad];
            [controller viewDidUnload];
        });

        it(@"should set the text field views to nil", ^{
            assertThat(controller.usernameTextField, nilValue());
            assertThat(controller.passwordTextField, nilValue());
        });
    });
});

SPEC_END
