#import <UIKit/UIKit.h>
#import "LandingAgentDelegate.h"

@class LandingAgent;

@interface LandingViewController : UIViewController <LandingAgentDelegate> {
    UIImageView *logoImageView_;
    LandingAgent *agent_;
}

@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;

- (IBAction)logIn;

@end
