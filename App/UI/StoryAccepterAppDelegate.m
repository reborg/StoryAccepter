#import "StoryAccepterAppDelegate.h"
#import "LandingViewController.h"

@implementation StoryAccepterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	landingController_ = [[LandingViewController alloc] init];

    landingController_.view.frame = [UIScreen mainScreen].applicationFrame;
	[window_ addSubview:landingController_.view];
    [window_ makeKeyAndVisible];

	return YES;
}

- (void)dealloc {
    [landingController_ release];
    [window_ release];
    [super dealloc];
}

@end
