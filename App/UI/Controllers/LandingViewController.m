#import "LandingViewController.h"
#import "LandingAgent.h"
#import "LogInViewController.h"

@interface LandingViewController (private)
- (NSURLCredential *)obtainCredential;
@end

@implementation LandingViewController

@synthesize logoImageView = logoImageView_;

- (id)init {
    if ((self = [super initWithNibName:@"LandingViewController" bundle:nil])) {
        agent_ = [[LandingAgent alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [self viewDidUnload];
    [agent_ release];
    [super dealloc];
}

- (void)viewDidUnload {
    self.logoImageView = nil;
    [super viewDidUnload];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)logIn {
    [self obtainCredential];
    [agent_ logIn];
}

#pragma mark LandingAgentDelegate

- (NSURLCredential *)newLogInCredential:(NSURLCredential *)failedCredential {
    return nil;
}

#pragma mark private interface

- (NSURLCredential *)obtainCredential {
    LogInViewController *logInViewController = [[LogInViewController alloc] init];
    [self presentModalViewController:logInViewController animated:true];
    return nil;
}

@end
