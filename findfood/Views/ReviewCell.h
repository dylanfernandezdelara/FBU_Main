//
//  ReviewCell.h
//  findfood
//
//  Created by dylanfdl on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView/HCSStarRatingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRating;
@property (weak, nonatomic) IBOutlet UILabel *reviewDescription;
@property (weak, nonatomic) IBOutlet UIImageView *pfpPicture;
@property (weak, nonatomic) IBOutlet UILabel *truckName;

@end

NS_ASSUME_NONNULL_END
