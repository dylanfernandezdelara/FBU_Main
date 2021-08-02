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
#import "FavoritedTrucksCell.h"

@interface UserProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *favoritedTrucks;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self setProfilePhoto];
    [self setProfileLabels];
    
    [self getUserFavoriteTrucks];
}

- (void)getUserFavoriteTrucks {
    PFUser *currUser = [PFUser currentUser];
    NSArray *favoritedTrucksIDs = currUser[@"favoritedTrucks"];
    self.favoritedTrucks = [[NSMutableArray alloc] init];
    
    PFQuery *truckQuery = [PFUser query];
    [truckQuery whereKey:@"objectId" containedIn:favoritedTrucksIDs];

    [truckQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects){
            for (int i = 0; i < objects.count; i++){
                PFUser *truck = objects[i];
                [self.favoritedTrucks addObject:truck];
            }
            [self.collectionView reloadData];
        }
    }];
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritedTrucksCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoritedTrucksCell" forIndexPath:indexPath];
    PFUser *truck = self.favoritedTrucks[indexPath.row];
    
    cell.layer.cornerRadius = 20;
    cell.layer.masksToBounds = true;
    cell.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    
    cell.truckName.text = truck[@"fullName"];
    cell.numLikesLabel.text = [truck[@"favoriteCount"] stringValue];
    
    PFFileObject *temp_file = truck[@"Image"];
    [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            cell.truckImage.image = thumbnailImageView.image;
        cell.truckImage.layer.cornerRadius = 5;
        cell.truckImage.layer.masksToBounds = true;
        }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoritedTrucks.count;
}
@end
