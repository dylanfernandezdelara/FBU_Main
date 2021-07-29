//
//  LoginViewController.m
//  findfood
//
//  Created by dylanfdl on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    self.username.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    self.password.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    
    self.signUpButton.layer.cornerRadius = 5;
    self.signUpButton.layer.masksToBounds = true;
    self.signUpButton.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = true;
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];
}

- (IBAction)signUpNow:(UIButton *)sender {
    PFUser *newUser = [PFUser user];
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    newUser[@"favoriteCount"] = [NSNumber numberWithInteger:0];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"signupSegue" sender:nil];
        }
    }];
}

- (IBAction)loginNow:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            if ([@"FoodTruck" isEqualToString: user[@"userType"]]){
                [self performSegueWithIdentifier:@"loginFoodTruck" sender:nil];
            }
            else if([@"generalUser" isEqualToString:user[@"userType"]]){
                [self performSegueWithIdentifier:@"loginGeneralUser" sender:nil];
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
