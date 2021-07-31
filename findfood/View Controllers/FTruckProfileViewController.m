//
//  FTruckProfileViewController.m
//  findfood
//
//  Created by dylanfdl on 7/14/21.
//

#import "FTruckProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import <ChameleonFramework/Chameleon.h>

@interface FTruckProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *foodPhoto;
@property (weak, nonatomic) IBOutlet UILabel *truckName;
@property (weak, nonatomic) IBOutlet UILabel *truckEmail;
@property (weak, nonatomic) IBOutlet UILabel *truckDescription;
@property (weak, nonatomic) IBOutlet UILabel *hiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *monOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *friOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *satOpenLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *monCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *friCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *satCloseLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *separatorImage;

@end

@implementation FTruckProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    self.separatorImage.backgroundColor = [UIColor colorWithHexString:@"3B5B33"];

    [self setPhotos];
    [self setLabels];
}

- (void)setLabels {
    PFUser *currUser = [PFUser currentUser];
    self.hiNameLabel.text = [@"Hi," stringByAppendingString:currUser[@"fullName"]];
    self.truckName.text = [@"@" stringByAppendingString:currUser[@"username"]];
    self.truckEmail.text = currUser[@"email"];
    self.truckDescription.text = currUser[@"truckDescription"];
    
    self.sunOpenLabel.text = currUser[@"sunOpenTime"];
    self.monOpenLabel.text = currUser[@"monOpenTime"];
    self.tueOpenLabel.text = currUser[@"tueOpenTime"];
    self.wedOpenLabel.text = currUser[@"wedOpenTime"];
    self.thuOpenLabel.text = currUser[@"thuOpenTime"];
    self.friOpenLabel.text = currUser[@"friOpenTime"];
    self.satOpenLabel.text = currUser[@"satOpenTime"];
    
    self.sunCloseLabel.text = currUser[@"sunCloseTime"];
    self.monCloseLabel.text = currUser[@"monCloseTime"];
    self.tueCloseLabel.text = currUser[@"tueCloseTime"];
    self.wedCloseLabel.text = currUser[@"wedCloseTime"];
    self.thuCloseLabel.text = currUser[@"thuCloseTime"];
    self.friCloseLabel.text = currUser[@"friCloseTime"];
    self.satCloseLabel.text = currUser[@"satCloseTime"];
    
    self.numberOfLikesLabel.text = [currUser[@"favoriteCount"] stringValue];
}

- (void)setPhotos {
    PFUser *currUser = [PFUser currentUser];
    PFFileObject *temp_file = currUser[@"Image"];
    [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            self.profilePhoto.image = thumbnailImageView.image;
        }];
    PFFileObject *tempDetailsFile = currUser[@"detailsImage"];
    [tempDetailsFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            self.foodPhoto.image = thumbnailImageView.image;
        }];
    self.profilePhoto.layer.cornerRadius = 10;
    self.profilePhoto.layer.masksToBounds = true;
    self.foodPhoto.layer.cornerRadius = 10;
    self.foodPhoto.layer.masksToBounds = true;
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
