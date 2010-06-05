#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController {
    UITextField *usernameTextField_, *passwordTextField_;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField, *passwordTextField;

@end
