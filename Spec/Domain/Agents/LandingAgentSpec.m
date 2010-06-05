#import <Cedar/SpecHelper.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "LandingAgent.h"
#import "LandingAgentDelegate.h"
#import "NSURLConnection+Spec.h"
#import "NSURLConnectionDelegate.h"

SPEC_BEGIN(LandingAgentSpec)

describe(@"LandingAgent", ^{
    __block LandingAgent *agent;
    __block id mockAgentDelegate;

    beforeEach(^{
        mockAgentDelegate = [OCMockObject mockForProtocol:@protocol(LandingAgentDelegate)];
        agent = [[LandingAgent alloc] initWithDelegate:mockAgentDelegate];
    });

    afterEach(^{
        [agent release];
    });

    describe(@"logIn", ^{
        __block NSURLConnection *logInConnection;

        beforeEach(^{
            [agent logIn];
            logInConnection = [[NSURLConnection connections] lastObject];
        });

        it(@"should try to log into Tracker", ^{
            assertThat([[[logInConnection request] URL] path], endsWith(@"tokens/active"));
        });

        describe(@"on authentication challenge", ^{
            __block NSURLAuthenticationChallenge *challenge;
            __block id mockChallengeSender;
            __block id mockFailedCredential;
            __block void (^sendChallenge)(void);

            beforeEach(^{
                id mockProtectionSpace = [OCMockObject mockForClass:[NSURLProtectionSpace class]];
                id mockFailureResponse = [OCMockObject mockForClass:[NSURLResponse class]];
                mockFailedCredential =  [OCMockObject mockForClass:[NSURLCredential class]];
                mockChallengeSender = [OCMockObject niceMockForProtocol:@protocol(NSURLAuthenticationChallengeSender)];
                challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:mockProtectionSpace
                                                                       proposedCredential:mockFailedCredential
                                                                     previousFailureCount:1
                                                                          failureResponse:mockFailureResponse
                                                                                    error:nil
                                                                                   sender:mockChallengeSender];
                sendChallenge = [^{
                    [[logInConnection delegate] connection:logInConnection didReceiveAuthenticationChallenge:challenge];
                } copy];

            });

            afterEach(^{
                [challenge release];
            });

            it(@"should ask the delegate for new credentials", ^{
                [[mockAgentDelegate expect] newLogInCredential:mockFailedCredential];
                sendChallenge();
                [mockAgentDelegate verify];
            });

            describe(@"when the delegate provides a new credential object", ^{
                __block NSURLCredential *newCredential;

                beforeEach(^{
                    newCredential = [[OCMockObject mockForClass:[NSURLCredential class]] retain];
                    [[[mockAgentDelegate expect] andReturn:newCredential] newLogInCredential:mockFailedCredential];
                });

                it(@"should pass the new credential object back to the challenge sender", ^{
                    [[mockChallengeSender expect] useCredential:newCredential forAuthenticationChallenge:challenge];
                    sendChallenge();
                    [mockChallengeSender verify];
                });

                it(@"should clean up the reference to the new credential", ^{
                    int initialRetainCount = [newCredential retainCount];
                    sendChallenge();
                    assertThatInt([newCredential retainCount], equalToInt(initialRetainCount - 1));
                });
            });

            describe(@"when the delegate does not provide a new credential object", ^{
                beforeEach(^{
                    [[[mockAgentDelegate expect] andReturn:nil] newLogInCredential:mockFailedCredential];
                });

                it(@"should ask the challenge sender to cancel the challenge", ^{
                    [[mockChallengeSender expect] cancelAuthenticationChallenge:challenge];
                    sendChallenge();
                    [mockChallengeSender verify];
                });
            });
        });
    });
});

SPEC_END
