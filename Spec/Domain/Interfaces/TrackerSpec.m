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
    __block id mockDelegate;
    __block NSURLConnection *connection;
    __block NSURLRequest *request;

    beforeEach(^{
        [NSURLConnection resetAll];

        tracker = [[Tracker alloc] init];
        mockDelegate = [OCMockObject mockForProtocol:@protocol(NSURLConnectionDelegate)];
    });

    afterEach(^{
        [tracker release];
    });

    describe(@"logInWithDelegate:", ^{
        beforeEach(^{
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

        it(@"should add the new connection to the active connections", ^{
            assertThat([tracker activeConnections], hasItem(connection));
        });

        describe(@"on success", ^{
            beforeEach(^{
                FakeHTTPURLResponse *response = [[FakeResponses responsesForRequest:@"LogIn"] success];
                [[mockDelegate expect] connection:connection didReceiveResponse:response];
                [[mockDelegate expect] connectionDidFinishLoading:connection];

                [connection returnResponse:response];
            });

            it(@"should pass along the success response, and notify the delegate when the request has completed", ^{
                [mockDelegate verify];
            });

            it(@"should remove the connection from the active connections", ^{
                assertThat([tracker activeConnections], isNot(hasItem(connection)));
            });

            it(@"should use the returned token in subsequent requests", ^{
                [tracker getProjectsWithDelegate:nil];
                NSURLRequest *subsequentRequest = [[[NSURLConnection connections] lastObject] request];

                // This is the token in the fake request.
                NSString *expectedToken = @"c93f12c71bec27843c1d84b3bdd547f3";
                assertThat([subsequentRequest valueForHTTPHeaderField:@"X-TrackerToken"], equalTo(expectedToken));
            });
        });

        describe(@"on cancel", ^{
            it(@"should not notify the delegate that the connection completed (because it didn't)", ^{
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]]connection:connection didReceiveResponse:[OCMArg any]];
                [[[mockDelegate stub] andThrow:[NSException exceptionWithName:@"MockFailure" reason:@"I should not be called" userInfo:nil]]connection:connection didFailWithError:[OCMArg any]];

                [connection cancel];
            });

            it(@"should remove the connection from the active connections", ^{
                [[[connection retain] autorelease] cancel];
                assertThat([tracker activeConnections], isNot(hasItem(connection)));
            });
        });

        describe(@"on authentication failure", ^{
            beforeEach(^{
                [[mockDelegate expect] connection:connection didReceiveAuthenticationChallenge:[OCMArg any]];
                NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username" password:@"password" persistence:NSURLCredentialPersistenceNone];

                [connection sendAuthenticationChallengeWithCredential:credential];
            });

            it(@"should request credentials from the delegate", ^{
                [mockDelegate verify];
            });

            describe(@"when the client chooses to cancel the authentication challenge", ^{
                beforeEach(^{
                    [[connection delegate] connection:connection didCancelAuthenticationChallenge:nil];
                });

                it(@"should remove the connection from the active connections", PENDING);
            });
        });

        describe(@"on failure", ^{
            it(@"should pass along the failure response", PENDING);
        });

        describe(@"on connection error", ^{
            it(@"should notify the delegate of the error", PENDING);
        });
    });

    describe(@"getProjectsWithDelegate:", ^{
        __block NSString *token = @"wibble wobble wubble";

        beforeEach(^{
            mockDelegate = [OCMockObject mockForProtocol:@protocol(NSURLConnectionDelegate)];

            [tracker setToken:token];
            [tracker getProjectsWithDelegate:mockDelegate];
            connection = [[NSURLConnection connections] lastObject];

            request = [connection request];
        });

        it(@"should send one HTTP request", ^{
            assertThatInt([[NSURLConnection connections] count], equalToInt(1));
        });

        it(@"should send to the proper URI", ^{
            assertThat([[request URL] host], equalTo(@"www.pivotaltracker.com"));
            assertThat([[request URL] path], equalTo(@"/services/v3/projects"));
        });

        it(@"should use the GET method", ^{
            assertThat([request HTTPMethod], equalTo(@"GET"));
        });

        it(@"should not use SSL", ^{
            assertThat([[request URL] scheme], equalTo(@"http"));
        });

        it(@"should include the user's Tracker token in the request header", ^{
            assertThat([request valueForHTTPHeaderField:@"X-TrackerToken"], equalTo(token));
        });

        it(@"should add the new connection to the active connections", PENDING);
    });
});

SPEC_END
