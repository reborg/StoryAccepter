#import "LandingViewController.h"

@implementation LandingViewController

@synthesize logoImageView = logoImageView_;

- (id)init {
    if ((self = [super initWithNibName:@"LandingViewController" bundle:nil])) {
    }
    return self;
}

- (void)dealloc {
    [self viewDidUnload];
    [super dealloc];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidUnload {
    self.logoImageView = nil;
    [super viewDidUnload];
}

@end
