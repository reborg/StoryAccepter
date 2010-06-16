#import <Cedar-iPhone/SpecHelper.h>
#import <OCMock-iPhone/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrest-iPhone/OCHamcrest.h>
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

    it(@"should instantiate an appropriate agent", PENDING);

    describe(@"viewDidLoad", ^{
        beforeEach(^{
            [controller viewDidLoad];
        });

        it(@"should initialize the logo image view from the XIB", ^{
            assertThat(controller.logoImageView, notNilValue());
        });
    });

    describe(@"viewDidUnload", ^{
        beforeEach(^{
            [controller viewDidLoad];
            [controller viewDidUnload];
        });

        it(@"should set the logo image view to nil", ^{
            assertThat(controller.logoImageView, nilValue());
        });
    });

    describe(@"logIn", ^{
        it(@"should push a modal logInController", PENDING);
    });
});

SPEC_END
