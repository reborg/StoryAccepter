#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "Tracker.h"
#import "NSURLConnectionDelegate.h"
#import "NSURLConnection+Spec.h"
#import "FakeResponses.h"
#import "FakeHTTPURLResponse.h"

SPEC_BEGIN(TrackerSpec)

describe(@"Tracker", ^{
    __block Tracker *tracker;

    beforeEach(^{
        tracker = [[Tracker alloc] init];
    });

    afterEach(^{
        [tracker release];
    });

    describe(@"logIn", ^{
        __block id mockDelegate;
        __block NSURLConnection *connection;
        __block NSURLRequest *request;

        beforeEach(^{
            mockDelegate = [OCMockObject mockForProtocol:@protocol(NSURLConnectionDelegate)];

            [tracker logInWithDelegate:mockDelegate];
            connection = [[NSURLConnection connections] lastObject];

            request = [connection request];
        });

        it(@"should send one HTTP request", ^{
            assertThatInt([[NSURLConnection connections] count], equalToInt(1));
        });

        it(@"should send to the proper URI", ^{
            assertThat([[request URL] host], equalTo(@"www.pivotaltracker.com"));
            assertThat([[request URL] path], equalTo(@"/services/v3/tokens/active"));
        });

        it(@"should use the GET method", ^{
            assertThat([request HTTPMethod], equalTo(@"GET"));
        });

        it(@"should use SSL", ^{
            assertThat([[request URL] scheme], equalTo(@"https"));
        });

        describe(@"on success", ^{
            beforeEach(^{
                FakeHTTPURLResponse *response = [[FakeResponses responsesForRequest:@"LogIn"] success];
                [[mockDelegate expect] connection:connection didReceiveResponse:response];

                [connection returnResponse:response];
            });

            it(@"should pass along the success response", ^{
                [mockDelegate verify];
            });

            it(@"should use the returned token in subsequent requests", PENDING);
        });
    });
});

SPEC_END
