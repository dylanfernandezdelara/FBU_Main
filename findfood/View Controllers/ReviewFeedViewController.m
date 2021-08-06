//
//  ReviewFeedViewController.m
//  findfood
//
//  Created by dylanfdl on 8/6/21.
//

#import "ReviewFeedViewController.h"
#import "Parse/Parse.h"
#import "Review.h"
#import "ReviewCell.h"
#import <ChameleonFramework/Chameleon.h>

@interface ReviewFeedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *allReviews;

@end

@implementation ReviewFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFEE5"];
    [self fetchAllReviews];
}

- (void)fetchAllReviews {
    PFQuery *reviewQuery = [Review query];
    [reviewQuery whereKey:@"author" notEqualTo:[PFUser currentUser].objectId];
    [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.allReviews = [objects mutableCopy];
        [self.collectionView reloadData];
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
    ReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReviewCell" forIndexPath:indexPath];
    Review *review = self.allReviews[indexPath.row];
    
    cell.layer.cornerRadius = 20;
    cell.layer.masksToBounds = true;
    [cell.contentView.layer setBorderColor: [UIColor colorWithHexString:@"B6D2AF"].CGColor];
    [cell.contentView.layer setBorderWidth:2.0f];
    
    PFUser *author = [review.author fetchIfNeeded];
    
    cell.authorNameLabel.text = [@"@" stringByAppendingString:author.username];
    cell.reviewDescription.text = review.reviewContent;
    cell.reviewDescription.layer.cornerRadius = 10;
    cell.reviewDescription.layer.masksToBounds = 10;
    
    cell.truckName.text = review.truckName;
    
    cell.starRating.value = [review.score doubleValue];
    cell.starRating.backgroundColor = ClearColor;
    cell.starRating.tintColor = [UIColor colorWithHexString:@"3B5B33"];
    
    PFFileObject *temp_file = author[@"Image"];
    [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            cell.pfpPicture.image = thumbnailImageView.image;
        }];
    cell.pfpPicture.layer.cornerRadius = 20;
    cell.pfpPicture.layer.masksToBounds = true;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allReviews.count;
}
@end
