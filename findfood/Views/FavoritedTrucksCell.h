//
//  FavoritedTrucksCell.h
//  findfood
//
//  Created by dylanfdl on 8/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoritedTrucksCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *truckName;
@property (weak, nonatomic) IBOutlet UIImageView *truckImage;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeIcon;

@end

NS_ASSUME_NONNULL_END
