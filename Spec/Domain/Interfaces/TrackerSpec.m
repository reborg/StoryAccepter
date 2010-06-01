#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "Tracker.h"
#import "NSURLConnection+Spec.h"

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
        __block FakeURLConnection *connection;
        __block NSURLRequest *request;

        beforeEach(^{
            [tracker logIn];
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

        describe(@"on authentication challenge", ^{
            __block id<NSURLConnectionDelegate> delegate;
            __block NSURLAuthenticationChallenge *challenge;
            __block NSURLCredential *failedCredential;
            __block unsigned int failureCount;
            __block void (^setUpConnection)(void);

            beforeEach(^{
                setUpConnection = [^{
                    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@TRACKER_HOST
                                                                                                  port:0
                                                                                              protocol:@TRACKER_PROTOCOL
                                                                                                 realm:nil
                                                                                  authenticationMethod:nil];
                    challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:protectionSpace
                                                                           proposedCredential:failedCredential
                                                                         previousFailureCount:failureCount
                                                                              failureResponse:nil
                                                                                        error:nil
                                                                                       sender:nil];
                    [protectionSpace release];

                    delegate = [connection delegate];
                    [delegate connection:connection didReceiveAuthenticationChallenge:challenge];
                } copy];
            });

            afterEach(^{
                [challenge release];
            });

            describe(@"with no previous authentication failure", ^{
                beforeEach(^{
                    failureCount = 0;
                    setUpConnection();
                });

                it(@"should ask its delegate for credentials", ^{
                });

                it(@"should pass nil to the delegate for the previous credentials", ^{
                });

                it(@"should retry the request with the newly specified credentials", ^{
                });
            });

            describe(@"with a previous authentication failure", ^{
                beforeEach(^{
                    failureCount = 1;
                    failedCredential = [[NSURLCredential alloc] initWithUser:@"username"
                                                                    password:@"password"
                                                                 persistence:NSURLCredentialPersistenceNone];
                    setUpConnection();
                });

                it(@"should !!!", ^{
                });
            });
        });

        describe(@"on success", ^{
            beforeEach(^{
                // !!! Succeed
            });
        });
    });
});

SPEC_END
