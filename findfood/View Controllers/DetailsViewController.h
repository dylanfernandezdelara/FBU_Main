//
//  DetailsViewController.h
//  findfood
//
//  Created by dylanfdl on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property PFUser *currentTruckViewed;

@end

NS_ASSUME_NONNULL_END
