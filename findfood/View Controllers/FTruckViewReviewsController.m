//
//  FTruckViewReviewsController.m
//  findfood
//
//  Created by dylanfdl on 8/4/21.
//

#import "FTruckViewReviewsController.h"
#import "ReviewCell.h"
#import "Parse/Parse.h"
#import "Review.h"
#import <ChameleonFramework/Chameleon.h>

@interface FTruckViewReviewsController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *reviewsForTruck;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FTruckViewReviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)fetchReviewsForTruck {
    PFQuery *getReviews = [Review query];
    PFUser *signedInTruck = [PFUser currentUser];
    [getReviews whereKey:@"truckID" equalTo:signedInTruck.objectId];
    [getReviews findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.reviewsForTruck = objects;
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
    Review *review = self.reviewsForTruck[indexPath.row];
    
    cell.layer.cornerRadius = 20;
    cell.layer.masksToBounds = true;
    cell.backgroundColor = [UIColor colorWithHexString:@"B6D2AF"];
    
    PFUser *author = [review.author fetchIfNeeded];
    
    cell.authorNameLabel.text = [@"@" stringByAppendingString:author.username];
    cell.reviewDescription.text = review.reviewContent;
    cell.starRating.value = [review.score doubleValue];
    cell.starRating.tintColor = [UIColor colorWithHexString:@"FFFEE5"];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.reviewsForTruck.count;
}

@end
