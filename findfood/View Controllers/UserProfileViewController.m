//
//  UserProfileViewController.m
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import "UserProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiNameLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    
    [self setProfilePhoto];
    
    [self setProfileLabels];
}

- (void)setProfilePhoto {
    PFUser *currUser = [PFUser currentUser];
    PFFileObject *temp_file = currUser[@"Image"];
    [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            self.profilePicture.image = thumbnailImageView.image;
        }];
    self.profilePicture.layer.cornerRadius = 10;
    self.profilePicture.layer.masksToBounds = true;
}

-(void)setProfileLabels {
    PFUser *currUser = [PFUser currentUser];
    self.nameLabel.text = [@"@" stringByAppendingString:currUser[@"username"]];
    self.emailLabel.text = currUser[@"email"];
    self.hiNameLabel.text = [@"Hi," stringByAppendingString:currUser[@"fullName"]];
}

- (IBAction)logoutNow:(UIButton *)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"User logged out successfully");
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
