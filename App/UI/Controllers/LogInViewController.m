#import "LogInViewController.h"

@implementation LogInViewController

@synthesize usernameTextField = usernameTextField_, passwordTextField = passwordTextField_;

- (id)init {
    if (self = [super initWithNibName:@"LogInViewController" bundle:nil]) {
    }
    return self;
}

- (void)dealloc {
    [self viewDidUnload];
    [super dealloc];
}

- (void)viewDidUnload {
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    [super viewDidUnload];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

@end
