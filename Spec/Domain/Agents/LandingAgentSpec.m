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

    describe(@"#load", ^{
        __block NSURLConnection *logInConnection;

        beforeEach(^{
            [agent load];
            logInConnection = [[NSURLConnection connections] lastObject];
        });

        it(@"should try to log into Tracker", ^{
            assertThat([[[logInConnection request] URL] path], endsWith(@"tokens/active"));
        });

        describe(@"on authentication challenge", ^{
            __block NSURLAuthenticationChallenge *challenge;
            __block id mockChallengeSender;

            beforeEach(^{
                id mockProtectionSpace = [OCMockObject mockForClass:[NSURLProtectionSpace class]];
                id mockFailedCredential =  [OCMockObject mockForClass:[NSURLCredential class]];
                id mockFailureResponse = [OCMockObject mockForClass:[NSURLResponse class]];
                mockChallengeSender = [OCMockObject mockForProtocol:@protocol(NSURLAuthenticationChallengeSender)];
                challenge = [[NSURLAuthenticationChallenge alloc] initWithProtectionSpace:mockProtectionSpace
                                                                       proposedCredential:mockFailedCredential
                                                                     previousFailureCount:1
                                                                          failureResponse:mockFailureResponse
                                                                                    error:nil
                                                                                   sender:mockChallengeSender];
                [[mockAgentDelegate expect] newLogInCredential:mockFailedCredential];

                [[logInConnection delegate] connection:logInConnection didReceiveAuthenticationChallenge:challenge];
            });

            afterEach(^{
                [challenge release];
            });

            it(@"should ask the delegate for new credentials", ^{
                [mockAgentDelegate verify];
            });

            describe(@"when the delegate provides a new credential object", ^{
                it(@"should pass the new credential object back to the challenge sender", PENDING);
            });

            describe(@"when the delegate does not provide a new credential object", ^{
                it(@"should ask the challenge sender to cancel the challenge", PENDING);
            });
        });
    });
});

SPEC_END
