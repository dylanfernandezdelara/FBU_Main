//
//  ComposeReviewViewController.h
//  findfood
//
//  Created by dylanfdl on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "Review.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeReviewViewControllerDelegate
- (void)didWriteReview:(nonnull Review*)review;
@end

@interface ComposeReviewViewController : UIViewController

@property (nonatomic, weak) id<ComposeReviewViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *selectedTruckID;
@property (strong, nonatomic) NSString *selectedTruckName;

@end

NS_ASSUME_NONNULL_END
