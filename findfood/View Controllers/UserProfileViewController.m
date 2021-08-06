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
#import "Review.h"
#import "ReviewCell.h"

@interface UserProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *favoritesCollectionView;
@property (strong, nonatomic) NSMutableArray *favoritedTrucks;
@property (weak, nonatomic) IBOutlet UICollectionView *reviewCollectionView;

@property (strong, nonatomic) NSMutableArray *userReviews;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    
    self.favoritesCollectionView.dataSource = self;
    self.favoritesCollectionView.delegate = self;
    [self.favoritesCollectionView setTag:1];
    
    self.reviewCollectionView.dataSource = self;
    self.reviewCollectionView.delegate = self;
    
    [self setProfilePhoto];
    [self setProfileLabels];
    
    [self getUserFavoriteTrucks];
    [self fetchUserReviews];
}

- (void)fetchUserReviews {
    PFQuery *reviewQuery = [Review query];
    PFUser *currUser = [PFUser currentUser];
    [reviewQuery whereKey:@"author" containsString:currUser.objectId];
    
    [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.userReviews = [objects mutableCopy];
        [self.reviewCollectionView reloadData];
    }];
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
            [self.favoritesCollectionView reloadData];
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
    self.hiNameLabel.text = [@"Hi, " stringByAppendingString:currUser[@"fullName"]];
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.favoritesCollectionView) {
        FavoritedTrucksCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoritedTrucksCell" forIndexPath:indexPath];
        PFUser *truck = self.favoritedTrucks[indexPath.row];
        
        cell.layer.cornerRadius = 20;
        cell.layer.masksToBounds = true;
        cell.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
        
        cell.truckName.text = truck[@"fullName"];
        cell.numLikesLabel.text = [truck[@"favoriteCount"] stringValue];
        cell.likeIcon.tintColor = [UIColor colorWithHexString:@"FFFEE5"];
        
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
    
    else if (collectionView == self.reviewCollectionView) {
        ReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewCell" forIndexPath:indexPath];
        Review *review = self.userReviews[indexPath.row];
        
        cell.layer.cornerRadius = 20;
        cell.layer.masksToBounds = true;
        cell.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
        
        cell.truckName.text = review.truckName;
        
        cell.reviewDescription.text = review.reviewContent;
        cell.starRating.value = [review.score doubleValue];
        cell.starRating.tintColor = [UIColor colorWithHexString:@"FFFEE5"];
        
        return cell;
    }
    return nil;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.favoritesCollectionView){
        return self.favoritedTrucks.count;
    }
    
    else if (collectionView == self.reviewCollectionView){
        return self.userReviews.count;
    }
    return 0;
}
@end
